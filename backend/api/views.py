import random
from django.core.mail import send_mail
from django.core.cache import cache
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django.contrib.auth import authenticate

@api_view(['POST'])
def login_user(request):
    email = request.data.get('email')
    password = request.data.get('password')

    # 1. Authenticate User
    # user = authenticate(username=email, password=password) # Use if using Django Auth
    user_exists = True # Replace with your user validation logic

    if user_exists:
        # 2. Generate 6-digit OTP
        otp = str(random.randint(100000, 999999))
        
        # 3. Store in Cache for 5 minutes (Keyed by email)
        cache.set(f"otp_{email}", otp, timeout=300)

        # 4. Send the Email
        try:
            send_mail(
                'Your Login Verification Code',
                f'Your 2FA code is: {otp}',
                'noreply@yourapp.com',
                [email],
                fail_silently=False,
            )
            return Response({
                'status': True,
                'uid': '123', # Replace with user.id
                'user': {'email': email},
                'message': 'Code sent to email'
            })
        except Exception as e:
            return Response({'status': False, 'error': 'Failed to send email'}, status=500)

    return Response({'status': False, 'error': 'Invalid Credentials'}, status=401) 


@api_view(['POST'])
def verify_2fa(request):
    email = request.data.get('email')
    user_otp = request.data.get('otp')
    
    # Retrieve the OTP we stored earlier in the login_user function
    cached_otp = cache.get(f"otp_{email}")

    if cached_otp is not None and str(cached_otp) == str(user_otp):
        # Optional: Delete the code after successful use so it can't be reused
        cache.delete(f"otp_{email}")
        
        return Response({
            'status': True, 
            'message': 'OTP Verified successfully!'
        })
    
    return Response({
        'status': False, 
        'error': 'Invalid or expired verification code.'
    }, status=400)