# tests/test_api_endpoints.py
#
# Integration-style tests for the REST endpoints.
# Firebase and the external Firebase Auth REST call are both mocked
# so these run without any real credentials.
#
# Run with:  python manage.py test tests.test_api_endpoints
#

import json
from unittest.mock import patch, MagicMock, PropertyMock

import django
import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'softdes.settings')
django.setup()

from django.test import TestCase, RequestFactory
from django.urls import reverse
from rest_framework.test import APIClient


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _mock_user_doc(uid="uid_abc", username="testuser", email="test@usc.edu.ph",
                   role="student", department="CS", ces_points=0):
    doc = MagicMock()
    doc.uid = uid
    doc.to_dict.return_value = {
        "uid": uid,
        "username": username,
        "email": email,
        "role": role,
        "department": department,
        "ces_points": ces_points,
        "active_participating_ces_activities": [],
    }
    return doc


def _mock_activity_doc(uid="act_001", title="Beach Cleanup"):
    doc = MagicMock()
    doc.id = uid
    doc.to_dict.return_value = {
        "uid": uid,
        "title": title,
        "status": "active",
        "department": "CS",
        "approval_status": "pending",
        "beneficiaries": "community",
        "facilitator": ["uid_abc"],
        "date": {"month": "january", "day": "15", "year": "2026"},
        "type": {"isStrenuous": "false", "isOffCampus": "false", "type": "Default"},
        "volunteers": [],
        "private": "false",
        "documents": [],
    }
    return doc


# ---------------------------------------------------------------------------
# UserApi tests
# ---------------------------------------------------------------------------

class TestCreateUserEndpoint(TestCase):

    def setUp(self):
        self.client = APIClient()

    @patch('api.controller.UserApi.auth')
    @patch('api.controller.UserApi.firestore')
    def test_create_user_happy_path(self, mock_firestore, mock_auth):
        fake_user = MagicMock()
        fake_user.uid = "new_uid_999"
        mock_auth.create_user.return_value = fake_user

        mock_db = MagicMock()
        mock_firestore.client.return_value = mock_db
        doc_snapshot = _mock_user_doc(uid="new_uid_999")
        mock_db.collection.return_value.document.return_value.get.return_value = doc_snapshot

        payload = {
            "username": "newuser",
            "email": "newuser@usc.edu.ph",
            "password": "SafePass1",
            "course": "BSCS",
        }
        response = self.client.post("/api/v1/create-user/", payload, format="json")
        self.assertEqual(response.status_code, 201)
        self.assertTrue(response.data["status"])

    def test_create_user_missing_school_email_returns_400(self):
        payload = {
            "username": "testguy",
            "email": "testguy@gmail.com",
            "password": "SafePass1",
            "course": "BSCS",
        }
        response = self.client.post("/api/v1/create-user/", payload, format="json")
        self.assertEqual(response.status_code, 400)
        self.assertFalse(response.data["status"])

    def test_create_user_illegal_char_in_email_returns_400(self):
        payload = {
            "username": "testguy",
            "email": "test$@usc.edu.ph",
            "password": "SafePass1",
            "course": "BSCS",
        }
        response = self.client.post("/api/v1/create-user/", payload, format="json")
        self.assertEqual(response.status_code, 400)


class TestGetUserDataEndpoint(TestCase):

    def setUp(self):
        self.client = APIClient()

    @patch('api.controller.UserApi.db')
    def test_returns_user_when_found(self, mock_db):
        user_doc = _mock_user_doc(uid="uid_xyz")
        mock_db.collection.return_value.where.return_value.get.return_value = [user_doc]

        response = self.client.get("/api/v1/get-user-data/uid_xyz/")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data["uid"], "uid_xyz")

    @patch('api.controller.UserApi.db')
    def test_returns_404_when_user_missing(self, mock_db):
        mock_db.collection.return_value.where.return_value.get.return_value = []

        response = self.client.get("/api/v1/get-user-data/nonexistent_uid/")
        self.assertEqual(response.status_code, 404)
        self.assertFalse(response.data["status"])

    @patch('api.controller.UserApi.db')
    def test_get_all_users_returns_list(self, mock_db):
        users = [_mock_user_doc(uid=f"uid_{i}") for i in range(3)]
        mock_db.collection.return_value.get.return_value = users

        response = self.client.get("/api/v1/get-all-users/")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.data["status"])
        self.assertEqual(len(response.data["data"]), 3)

    @patch('api.controller.UserApi.db')
    def test_get_all_users_empty_returns_404(self, mock_db):
        mock_db.collection.return_value.get.return_value = []

        response = self.client.get("/api/v1/get-all-users/")
        self.assertEqual(response.status_code, 404)


# ---------------------------------------------------------------------------
# CesApi tests
# ---------------------------------------------------------------------------

class TestPostCesEndpoint(TestCase):

    def setUp(self):
        self.client = APIClient()

    @patch('api.controller.CesApi.db')
    def test_post_ces_creates_activity(self, mock_db):
        mock_db.collection.return_value.document.return_value.set = MagicMock()

        payload = {
            "title": "Coastal Cleanup Drive",
            "status": "active",
            "month": "february",
            "day": "10",
            "year": "2026",
            "beneficiaries": "Local community",
            "uid": "uid_facilitator",
            "private": "false",
            "department": "CS",
            "isStrenuous": "false",
            "isOffCampus": "true",
            "type": "Outreach",
        }
        response = self.client.post("/api/v1/post-ces/", payload, format="json")
        self.assertEqual(response.status_code, 201)
        self.assertTrue(response.data["status"])
        self.assertIn("activity", response.data)

    def test_post_ces_profane_title_rejected(self):
        payload = {
            "title": "ass",   # actual profanity from the library's word list
            "status": "active",
            "month": "february",
            "day": "10",
            "year": "2026",
            "beneficiaries": "community",
            "uid": "uid_facilitator",
            "private": "false",
            "department": "CS",
            "isStrenuous": "false",
            "isOffCampus": "false",
            "type": "Default",
        }
        response = self.client.post("/api/v1/post-ces/", payload, format="json")
        self.assertEqual(response.status_code, 400)
        self.assertFalse(response.data["status"])


class TestGetCesEndpoints(TestCase):

    def setUp(self):
        self.client = APIClient()

    @patch('api.controller.CesApi.db')
    def test_get_ces_returns_all_activities(self, mock_db):
        activities = [_mock_activity_doc(uid=f"act_{i}") for i in range(5)]
        mock_db.collection.return_value.get.return_value = activities

        response = self.client.get("/api/v1/get-ces/")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.data["status"])
        self.assertEqual(len(response.data["data"]), 5)

    @patch('api.controller.CesApi.db')
    def test_find_activity_returns_data_when_exists(self, mock_db):
        act = _mock_activity_doc(uid="act_001")
        act.exists = True
        mock_db.collection.return_value.document.return_value.get.return_value = act

        response = self.client.get("/api/v1/find-activity/?uid=act_001")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.data["status"])

    @patch('api.controller.CesApi.db')
    def test_find_activity_returns_404_when_missing(self, mock_db):
        act = MagicMock()
        act.exists = False
        mock_db.collection.return_value.document.return_value.get.return_value = act

        response = self.client.get("/api/v1/find-activity/?uid=ghost_id")
        self.assertEqual(response.status_code, 404)

    @patch('api.controller.CesApi.db')
    def test_get_display_info_shapes_response(self, mock_db):
        activities = [_mock_activity_doc()]
        mock_db.collection.return_value.get.return_value = activities

        response = self.client.get("/api/v1/get-display/")
        self.assertEqual(response.status_code, 200)
        entry = response.data["data"][0]
        # should have title, volunteers count, and date string
        self.assertIn("title", entry)
        self.assertIn("volunteers", entry)
        self.assertIn("date", entry)


class TestParticipationEndpoints(TestCase):

    def setUp(self):
        self.client = APIClient()

    @patch('api.controller.CesApi.db')
    def test_join_activity_success(self, mock_db):
        ces_snapshot = MagicMock()
        ces_snapshot.exists = True

        user_doc = MagicMock()
        user_doc.reference = MagicMock()

        mock_db.collection.return_value.document.return_value.get.return_value = ces_snapshot
        mock_db.collection.return_value.where.return_value.stream.return_value = [user_doc]

        payload = {"uid": "uid_abc", "ces_uid": "act_001"}
        response = self.client.post("/api/v1/add-participant/", payload, format="json")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.data["status"])

    @patch('api.controller.CesApi.db')
    def test_join_activity_missing_activity_returns_404(self, mock_db):
        ces_snapshot = MagicMock()
        ces_snapshot.exists = False
        mock_db.collection.return_value.document.return_value.get.return_value = ces_snapshot

        payload = {"uid": "uid_abc", "ces_uid": "ghost_act"}
        response = self.client.post("/api/v1/add-participant/", payload, format="json")
        self.assertEqual(response.status_code, 404)

    @patch('api.controller.CesApi.db')
    def test_leave_activity_success(self, mock_db):
        ces_snapshot = MagicMock()
        ces_snapshot.exists = True

        user_doc = MagicMock()
        user_doc.reference = MagicMock()

        mock_db.collection.return_value.document.return_value.get.return_value = ces_snapshot
        mock_db.collection.return_value.where.return_value.stream.return_value = [user_doc]

        payload = {"uid": "uid_abc", "ces_uid": "act_001"}
        response = self.client.post("/api/v1/leave-activity/", payload, format="json")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.data["status"])


class TestEditCesPoints(TestCase):

    def setUp(self):
        self.client = APIClient()

    @patch('api.controller.CesApi.db')
    def test_update_ces_points_success(self, mock_db):
        user_doc = MagicMock()
        user_doc.reference = MagicMock()
        mock_db.collection.return_value.where.return_value.stream.return_value = [user_doc]

        payload = {"uid": "uid_abc", "ces_points": 50}
        response = self.client.post("/api/v1/edit-ces-points/", payload, format="json")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.data["status"])

    def test_update_ces_points_missing_uid_returns_400(self):
        response = self.client.post("/api/v1/edit-ces-points/",
                                    {"ces_points": 50}, format="json")
        self.assertEqual(response.status_code, 400)
        self.assertFalse(response.data["status"])

    @patch('api.controller.CesApi.db')
    def test_update_ces_points_unknown_user_returns_404(self, mock_db):
        mock_db.collection.return_value.where.return_value.stream.return_value = []

        payload = {"uid": "ghost_uid", "ces_points": 10}
        response = self.client.post("/api/v1/edit-ces-points/", payload, format="json")
        self.assertEqual(response.status_code, 404)


# ---------------------------------------------------------------------------
# CesApiApproval tests
# ---------------------------------------------------------------------------

class TestCesApprovalEndpoints(TestCase):

    def setUp(self):
        self.client = APIClient()

    @patch('api.controller.CesApiApproval.db')
    def test_approve_activity_success(self, mock_db):
        mock_db.collection.return_value.document.return_value.update = MagicMock()

        response = self.client.post("/api/v1/approve-activity/",
                                    {"uid": "act_001"}, format="json")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.data["status"])

    def test_approve_activity_no_uid_returns_400(self):
        response = self.client.post("/api/v1/approve-activity/", {}, format="json")
        self.assertEqual(response.status_code, 400)

    @patch('api.controller.CesApiApproval.db')
    def test_deny_activity_success(self, mock_db):
        mock_db.collection.return_value.document.return_value.update = MagicMock()

        response = self.client.post("/api/v1/deny-activity/",
                                    {"uid": "act_001"}, format="json")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.data["status"])

    def test_deny_activity_no_uid_returns_400(self):
        response = self.client.post("/api/v1/deny-activity/", {}, format="json")
        self.assertEqual(response.status_code, 400)

    @patch('api.controller.CesApiApproval.db')
    def test_get_ces_filter_no_status_returns_all(self, mock_db):
        activities = [_mock_activity_doc(uid=f"act_{i}") for i in range(4)]
        mock_db.collection.return_value.get.return_value = activities

        response = self.client.get("/api/v1/get-ces-filter/")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.data["data"]), 4)

    @patch('api.controller.CesApiApproval.db')
    def test_get_ces_filter_with_status_queries_correctly(self, mock_db):
        activities = [_mock_activity_doc()]
        mock_db.collection.return_value.where.return_value.get.return_value = activities

        response = self.client.get("/api/v1/get-ces-filter/?status=pending")
        self.assertEqual(response.status_code, 200)
        # confirm the where() filter was actually called
        mock_db.collection.return_value.where.assert_called_once_with(
            "approval_status", "==", "pending"
        )


# ---------------------------------------------------------------------------
# 2FA view tests
# ---------------------------------------------------------------------------

class TestVerify2FA(TestCase):

    def setUp(self):
        self.client = APIClient()

    def test_correct_otp_returns_200(self):
        from django.core.cache import cache
        cache.set("otp_someone@usc.edu.ph", "123456", timeout=300)

        response = self.client.post("/api/v1/verify-2fa/",
                                    {"email": "someone@usc.edu.ph", "otp": "123456"},
                                    format="json")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.data["status"])

    def test_wrong_otp_returns_400(self):
        from django.core.cache import cache
        cache.set("otp_someone@usc.edu.ph", "123456", timeout=300)

        response = self.client.post("/api/v1/verify-2fa/",
                                    {"email": "someone@usc.edu.ph", "otp": "000000"},
                                    format="json")
        self.assertEqual(response.status_code, 400)
        self.assertFalse(response.data["status"])

    def test_expired_otp_returns_400(self):
        # no OTP set in cache → should behave as expired/invalid
        response = self.client.post("/api/v1/verify-2fa/",
                                    {"email": "nobody@usc.edu.ph", "otp": "999999"},
                                    format="json")
        self.assertEqual(response.status_code, 400)

    def test_otp_deleted_after_successful_verify(self):
        from django.core.cache import cache
        cache.set("otp_onetime@usc.edu.ph", "555555", timeout=300)

        self.client.post("/api/v1/verify-2fa/",
                         {"email": "onetime@usc.edu.ph", "otp": "555555"},
                         format="json")

        # OTP should be gone — a second attempt must fail
        response = self.client.post("/api/v1/verify-2fa/",
                                    {"email": "onetime@usc.edu.ph", "otp": "555555"},
                                    format="json")
        self.assertEqual(response.status_code, 400)
