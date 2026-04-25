from firebase_admin import firestore
# from api.firebase import db

from django.http import JsonResponse

# Create your views here.
def add_user_to_firebase(name, email):
    # 'users' is the collection, 'alovelace' is the document ID (optional)
    doc_ref = db.collection("users").document("user_01")
    
    doc_ref.set({
        "full_name": name,
        "email": email,
        "created_at": firestore.SERVER_TIMESTAMP # Good practice!
    })
    
    print("Data successfully added!")

# Run the function
add_user_to_firebase("Josh Herald", "josh@example.com")

# ... (your firebase imports)

def add_user_view(request):
    # 1. Pull data from the URL parameters (Query Params)
    name = request.GET.get('name', 'Default Name')
    email = request.GET.get('email')

    # 2. Check if email was actually provided
    if not email:
        return JsonResponse({"error": "You must provide an email!"}, status=400)

    # 3. Pass the data to your Firebase function
    try:
        add_user_to_firebase(name, email)
        return JsonResponse({"status": "Success! User added to Firebase."})
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)