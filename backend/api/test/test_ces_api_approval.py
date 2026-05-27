from django.test import TestCase
from unittest.mock import patch, MagicMock
from rest_framework.test import APIClient
from rest_framework import status


# ---------------------------------------------------------------------------
# Helper
# ---------------------------------------------------------------------------

def make_activity(uid="ACT001", approval_status="pending"):
    return {
        "uid": uid,
        "title": "Sample Activity",
        "approval_status": approval_status,
    }


def mock_doc(data):
    doc = MagicMock()
    doc.to_dict.return_value = data
    doc.id = data.get("uid", "DOC_ID")
    return doc


# ---------------------------------------------------------------------------
# get_ces_status_filter
# ---------------------------------------------------------------------------

@patch("api.controller.CesApiApproval.db")
class GetCesStatusFilterTests(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.url = "/api/v1/get-ces-filter/"

    def test_returns_all_when_no_status_param(self, mock_db):
        activities = [
            mock_doc(make_activity("A1", "pending")),
            mock_doc(make_activity("A2", "approved")),
            mock_doc(make_activity("A3", "denied")),
        ]
        mock_db.collection.return_value.get.return_value = activities

        response = self.client.get(self.url)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data["status"])
        self.assertEqual(len(response.data["data"]), 3)

    def test_filters_by_pending_status(self, mock_db):
        activities = [mock_doc(make_activity("A1", "pending"))]
        mock_db.collection.return_value.where.return_value.get.return_value = activities

        response = self.client.get(self.url, {"status": "pending"})

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data["data"]), 1)
        self.assertEqual(response.data["data"][0]["approval_status"], "pending")
        mock_db.collection.return_value.where.assert_called_once_with(
            "approval_status", "==", "pending"
        )

    def test_filters_by_approved_status(self, mock_db):
        activities = [mock_doc(make_activity("A2", "approved"))]
        mock_db.collection.return_value.where.return_value.get.return_value = activities

        response = self.client.get(self.url, {"status": "approved"})

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["data"][0]["approval_status"], "approved")

    def test_filters_by_denied_status(self, mock_db):
        activities = [mock_doc(make_activity("A3", "denied"))]
        mock_db.collection.return_value.where.return_value.get.return_value = activities

        response = self.client.get(self.url, {"status": "denied"})

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["data"][0]["approval_status"], "denied")

    def test_empty_result_returns_empty_list(self, mock_db):
        mock_db.collection.return_value.where.return_value.get.return_value = []

        response = self.client.get(self.url, {"status": "pending"})

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["data"], [])


# ---------------------------------------------------------------------------
# approve_activity
# ---------------------------------------------------------------------------

@patch("api.controller.CesApiApproval.db")
class ApproveActivityTests(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.url = "/api/v1/approve-activity/"

    def test_approve_success(self, mock_db):
        doc_ref = MagicMock()
        mock_db.collection.return_value.document.return_value = doc_ref

        response = self.client.post(self.url, {"uid": "ACT001"}, format="json")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data["status"])
        self.assertEqual(response.data["message"], "Activity approved successfully")
        doc_ref.update.assert_called_once_with({"approval_status": "approved"})

    def test_approve_missing_uid_returns_400(self, mock_db):
        response = self.client.post(self.url, {}, format="json")

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertFalse(response.data["status"])
        self.assertIn("uid is required", response.data["message"])

    def test_approve_sets_correct_document(self, mock_db):
        """Verify it targets the specific uid document, not any other."""
        doc_ref = MagicMock()
        mock_db.collection.return_value.document.return_value = doc_ref

        self.client.post(self.url, {"uid": "SPECIFIC_DOC_ID"}, format="json")

        mock_db.collection.return_value.document.assert_called_once_with("SPECIFIC_DOC_ID")
        doc_ref.update.assert_called_once_with({"approval_status": "approved"})


# ---------------------------------------------------------------------------
# deny_activity
# ---------------------------------------------------------------------------

@patch("api.controller.CesApiApproval.db")
class DenyActivityTests(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.url = "/api/v1/deny-activity/"

    def test_deny_success(self, mock_db):
        doc_ref = MagicMock()
        mock_db.collection.return_value.document.return_value = doc_ref

        response = self.client.post(self.url, {"uid": "ACT001"}, format="json")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data["status"])
        self.assertEqual(response.data["message"], "Activity denied successfully")
        doc_ref.update.assert_called_once_with({"approval_status": "denied"})

    def test_deny_missing_uid_returns_400(self, mock_db):
        response = self.client.post(self.url, {}, format="json")

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertFalse(response.data["status"])
        self.assertIn("uid is required", response.data["message"])

    def test_deny_sets_correct_document(self, mock_db):
        doc_ref = MagicMock()
        mock_db.collection.return_value.document.return_value = doc_ref

        self.client.post(self.url, {"uid": "TARGET_DOC"}, format="json")

        mock_db.collection.return_value.document.assert_called_once_with("TARGET_DOC")
        doc_ref.update.assert_called_once_with({"approval_status": "denied"})

    def test_approve_and_deny_are_independent(self, mock_db):
        """Approving and then denying the same activity should make two separate update calls."""
        approve_ref = MagicMock()
        deny_ref = MagicMock()
        mock_db.collection.return_value.document.side_effect = [approve_ref, deny_ref]

        self.client.post("/api/v1/approve-activity/", {"uid": "ACT001"}, format="json")
        self.client.post(self.url, {"uid": "ACT001"}, format="json")

        approve_ref.update.assert_called_once_with({"approval_status": "approved"})
        deny_ref.update.assert_called_once_with({"approval_status": "denied"})
