from django.test import TestCase
from unittest.mock import patch, MagicMock
from rest_framework.test import APIClient
from rest_framework import status


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def make_activity(uid="ACT001", approval_status="approved", volunteers=None,
                  month="january", day="15", year="2025", act_type="Default",
                  is_strenuous=False, is_off_campus=False):
    """Return a minimal activity dict that mirrors Firestore shape."""
    return {
        "uid": uid,
        "title": "Clean-Up Drive",
        "status": "active",
        "date": {"month": month, "day": day, "year": year},
        "volunteers": volunteers or [],
        "facilitator": ["USER1"],
        "beneficiaries": "Community",
        "documents": [],
        "private": False,
        "department": "Engineering",
        "type": {
            "isStrenuous": is_strenuous,
            "isOffCampus": is_off_campus,
            "type": act_type,
        },
        "approval_status": approval_status,
    }


def mock_doc(data):
    """Wrap a dict so it behaves like a Firestore DocumentSnapshot."""
    doc = MagicMock()
    doc.to_dict.return_value = data
    doc.id = data.get("uid", "DOC_ID")
    doc.exists = True
    return doc


# ---------------------------------------------------------------------------
# post_ces
# ---------------------------------------------------------------------------

@patch("api.controller.CesApi.db")
@patch("api.controller.CesApi.IdFactory")
@patch("api.controller.CesApi.CheckProfanityHandler")
class PostCesTests(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.url = "/api/v1/post-ces/"
        self.valid_payload = {
            "title": "Tree Planting",
            "status": "active",
            "month": "march",
            "day": "10",
            "year": "2025",
            "uid": "USER1",
            "beneficiaries": "Local community",
            "private": False,
            "department": "Science",
            "isStrenuous": False,
            "isOffCampus": False,
            "type": "Default",
        }

    def test_post_ces_success(self, MockProfanity, MockIdFactory, mock_db):
        handler_instance = MagicMock()
        handler_instance.handle.return_value = True
        MockProfanity.return_value = handler_instance

        MockIdFactory.create_numeric_id.return_value = 12345

        doc_ref = MagicMock()
        mock_db.collection.return_value.document.return_value = doc_ref

        response = self.client.post(self.url, self.valid_payload, format="json")

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(response.data["status"])
        self.assertEqual(response.data["message"], "Successfully created the CES Activity")

        doc_ref.set.assert_called_once()
        saved = doc_ref.set.call_args[0][0]
        self.assertEqual(saved["approval_status"], "pending")
        self.assertEqual(saved["volunteers"], [])
        self.assertEqual(saved["facilitator"], ["USER1"])

    def test_post_ces_profanity_rejected(self, MockProfanity, MockIdFactory, mock_db):
        handler_instance = MagicMock()
        handler_instance.handle.return_value = False   # profanity detected
        MockProfanity.return_value = handler_instance

        payload = {**self.valid_payload, "title": "Bad Word Title"}
        response = self.client.post(self.url, payload, format="json")

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertFalse(response.data["status"])
        self.assertIn("profanity", response.data["message"].lower())

    def test_post_ces_stores_type_field(self, MockProfanity, MockIdFactory, mock_db):
        """The 'type' key inside the type dict must be saved (not omitted)."""
        handler_instance = MagicMock()
        handler_instance.handle.return_value = True
        MockProfanity.return_value = handler_instance
        MockIdFactory.create_numeric_id.return_value = 99999
        doc_ref = MagicMock()
        mock_db.collection.return_value.document.return_value = doc_ref

        payload = {**self.valid_payload, "type": "Immersion"}
        response = self.client.post(self.url, payload, format="json")

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        saved = doc_ref.set.call_args[0][0]
        self.assertEqual(saved["type"]["type"], "Immersion")


# ---------------------------------------------------------------------------
# get_ces
# ---------------------------------------------------------------------------

@patch("api.controller.CesApi.db")
class GetCesTests(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.url = "/api/v1/get-ces/"

    def test_returns_only_approved(self, mock_db):
        activities = [
            mock_doc(make_activity(uid="A1", approval_status="approved")),
            mock_doc(make_activity(uid="A2", approval_status="pending")),
            mock_doc(make_activity(uid="A3", approval_status="denied")),
        ]
        mock_db.collection.return_value.get.return_value = activities

        response = self.client.get(self.url)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data["status"])
        self.assertEqual(len(response.data["data"]), 1)
        self.assertEqual(response.data["data"][0]["uid"], "A1")

    def test_empty_collection_returns_empty_list(self, mock_db):
        mock_db.collection.return_value.get.return_value = []

        response = self.client.get(self.url)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["data"], [])


# ---------------------------------------------------------------------------
# get_display_info
# ---------------------------------------------------------------------------

@patch("api.controller.CesApi.db")
class GetDisplayInfoTests(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.url = "/api/v1/get-display/"

    def test_formats_date_and_volunteer_count(self, mock_db):
        activities = [
            mock_doc(make_activity(uid="A1", volunteers=["U1", "U2"], month="april", day="5", year="2025")),
        ]
        mock_db.collection.return_value.get.return_value = activities

        response = self.client.get(self.url)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        item = response.data["data"][0]
        self.assertEqual(item["title"], "Clean-Up Drive")
        self.assertEqual(item["volunteers"], 2)
        self.assertEqual(item["date"], "april 5, 2025")

    def test_missing_title_defaults_to_no_title(self, mock_db):
        data = make_activity(uid="A1")
        del data["title"]
        mock_db.collection.return_value.get.return_value = [mock_doc(data)]

        response = self.client.get(self.url)

        self.assertEqual(response.data["data"][0]["title"], "no title")


# ---------------------------------------------------------------------------
# participate_ces_activity
# ---------------------------------------------------------------------------

@patch("api.controller.CesApi.db")
class ParticipateCesActivityTests(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.url = "/api/v1/add-participant/"

    def test_join_success(self, mock_db):
        ces_snapshot = MagicMock()
        ces_snapshot.exists = True
        ces_ref = MagicMock()
        ces_ref.get.return_value = ces_snapshot

        user_doc_ref = MagicMock()
        user_doc = MagicMock()
        user_doc.reference = user_doc_ref

        def collection_side_effect(name):
            col = MagicMock()
            if name == "CESArchive":
                col.document.return_value = ces_ref
            elif name == "users":
                col.where.return_value.stream.return_value = iter([user_doc])
            return col

        mock_db.collection.side_effect = collection_side_effect

        response = self.client.post(self.url, {"ces_uid": "ACT001", "uid": "USER1"}, format="json")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data["status"])
        user_doc_ref.update.assert_called_once()
        ces_ref.update.assert_called_once()

    def test_join_activity_not_found(self, mock_db):
        ces_snapshot = MagicMock()
        ces_snapshot.exists = False
        ces_ref = MagicMock()
        ces_ref.get.return_value = ces_snapshot
        mock_db.collection.return_value.document.return_value = ces_ref

        response = self.client.post(self.url, {"ces_uid": "MISSING", "uid": "USER1"}, format="json")

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.assertFalse(response.data["status"])
        self.assertIn("not found", response.data["message"].lower())

    def test_join_user_not_found(self, mock_db):
        ces_snapshot = MagicMock()
        ces_snapshot.exists = True
        ces_ref = MagicMock()
        ces_ref.get.return_value = ces_snapshot

        def collection_side_effect(name):
            col = MagicMock()
            if name == "CESArchive":
                col.document.return_value = ces_ref
            elif name == "users":
                col.where.return_value.stream.return_value = iter([])  # no user
            return col

        mock_db.collection.side_effect = collection_side_effect

        response = self.client.post(self.url, {"ces_uid": "ACT001", "uid": "GHOST"}, format="json")

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.assertFalse(response.data["status"])


# ---------------------------------------------------------------------------
# find_activity
# ---------------------------------------------------------------------------

@patch("api.controller.CesApi.db")
class FindActivityTests(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.url = "/api/v1/find-activity/"

    def test_find_existing_activity(self, mock_db):
        activity = make_activity(uid="ACT123")
        snapshot = MagicMock()
        snapshot.exists = True
        snapshot.to_dict.return_value = activity
        mock_db.collection.return_value.document.return_value.get.return_value = snapshot

        response = self.client.get(self.url, {"uid": "ACT123"})

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data["status"])
        self.assertEqual(response.data["data"]["uid"], "ACT123")

    def test_find_missing_activity(self, mock_db):
        snapshot = MagicMock()
        snapshot.exists = False
        mock_db.collection.return_value.document.return_value.get.return_value = snapshot

        response = self.client.get(self.url, {"uid": "NOPE"})

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.assertFalse(response.data["status"])


# ---------------------------------------------------------------------------
# leave_ces_activity
# ---------------------------------------------------------------------------

@patch("api.controller.CesApi.db")
class LeaveCesActivityTests(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.url = "/api/v1/leave-activity/"

    def test_leave_success(self, mock_db):
        ces_snapshot = MagicMock()
        ces_snapshot.exists = True
        ces_ref = MagicMock()
        ces_ref.get.return_value = ces_snapshot

        user_doc_ref = MagicMock()
        user_doc = MagicMock()
        user_doc.reference = user_doc_ref

        def collection_side_effect(name):
            col = MagicMock()
            if name == "CESArchive":
                col.document.return_value = ces_ref
            elif name == "users":
                col.where.return_value.stream.return_value = iter([user_doc])
            return col

        mock_db.collection.side_effect = collection_side_effect

        response = self.client.post(self.url, {"ces_uid": "ACT001", "uid": "USER1"}, format="json")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data["status"])
        user_doc_ref.update.assert_called_once()
        ces_ref.update.assert_called_once()

    def test_leave_activity_not_found(self, mock_db):
        ces_snapshot = MagicMock()
        ces_snapshot.exists = False
        ces_ref = MagicMock()
        ces_ref.get.return_value = ces_snapshot
        mock_db.collection.return_value.document.return_value = ces_ref

        response = self.client.post(self.url, {"ces_uid": "MISSING", "uid": "USER1"}, format="json")

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.assertFalse(response.data["status"])


# ---------------------------------------------------------------------------
# edit_ces_points
# ---------------------------------------------------------------------------

@patch("api.controller.CesApi.db")
class EditCesPointsTests(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.url = "/api/v1/edit-ces-points/"

    def test_update_points_success(self, mock_db):
        user_doc_ref = MagicMock()
        user_doc = MagicMock()
        user_doc.reference = user_doc_ref
        mock_db.collection.return_value.where.return_value.stream.return_value = iter([user_doc])

        response = self.client.post(self.url, {"uid": "USER1", "ces_points": 50}, format="json")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data["status"])
        user_doc_ref.update.assert_called_once_with({"ces_points": 50})

    def test_missing_uid_returns_400(self, mock_db):
        response = self.client.post(self.url, {"ces_points": 50}, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertFalse(response.data["status"])

    def test_missing_ces_points_returns_400(self, mock_db):
        response = self.client.post(self.url, {"uid": "USER1"}, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertFalse(response.data["status"])

    def test_user_not_found_returns_404(self, mock_db):
        mock_db.collection.return_value.where.return_value.stream.return_value = iter([])

        response = self.client.post(self.url, {"uid": "GHOST", "ces_points": 10}, format="json")
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.assertFalse(response.data["status"])


# ---------------------------------------------------------------------------
# get_calendar
# ---------------------------------------------------------------------------

@patch("api.controller.CesApi.db")
class GetCalendarTests(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.url = "/api/v1/get-calendar/"

    def test_groups_activities_by_date(self, mock_db):
        a1 = make_activity(uid="A1", month="january", day="15", year="2025", act_type="Immersion")
        a2 = make_activity(uid="A2", month="january", day="15", year="2025", act_type="Outreach")
        mock_db.collection.return_value.get.return_value = [mock_doc(a1), mock_doc(a2)]

        response = self.client.get(self.url)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        cal = response.data["calendar"]
        self.assertIn("2025-01-15", cal)
        entry = cal["2025-01-15"]
        self.assertEqual(len(entry["activities"]), 2)
        self.assertTrue(entry["is_split"])

    def test_max_two_activities_per_day(self, mock_db):
        """Business rule: no more than 2 activities appear per day."""
        docs = [mock_doc(make_activity(uid=f"A{i}", month="march", day="1", year="2025")) for i in range(5)]
        mock_db.collection.return_value.get.return_value = docs

        response = self.client.get(self.url)

        entry = response.data["calendar"]["2025-03-01"]
        self.assertLessEqual(len(entry["activities"]), 2)

    def test_filter_by_activity_ids(self, mock_db):
        a1 = make_activity(uid="A1", month="february", day="10", year="2025")
        a2 = make_activity(uid="A2", month="february", day="10", year="2025")
        doc1 = mock_doc(a1)
        doc1.id = "A1"
        doc2 = mock_doc(a2)
        doc2.id = "A2"
        mock_db.collection.return_value.get.return_value = [doc1, doc2]

        response = self.client.get(self.url, {"activity_ids": "A1"})

        cal = response.data["calendar"]
        self.assertEqual(len(cal["2025-02-10"]["activities"]), 1)
        self.assertEqual(cal["2025-02-10"]["activities"][0]["uid"], "A1")

    def test_skips_unparseable_dates(self, mock_db):
        bad = make_activity(uid="BAD", month="notamonth", day="xx", year="2025")
        mock_db.collection.return_value.get.return_value = [mock_doc(bad)]

        response = self.client.get(self.url)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["calendar"], {})

    def test_is_split_false_when_same_type(self, mock_db):
        a1 = make_activity(uid="A1", month="june", day="1", year="2025", act_type="Outreach")
        a2 = make_activity(uid="A2", month="june", day="1", year="2025", act_type="Outreach")
        mock_db.collection.return_value.get.return_value = [mock_doc(a1), mock_doc(a2)]

        response = self.client.get(self.url)

        entry = response.data["calendar"]["2025-06-01"]
        self.assertFalse(entry["is_split"])
        self.assertIsNone(entry["secondary_type"])