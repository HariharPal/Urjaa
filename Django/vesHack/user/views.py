import uuid
from rest_framework.views import APIView
from rest_framework import status
from rest_framework.response import Response
from django.utils.decorators import method_decorator
from django.shortcuts import render
import jwt

from .middleware import jwt_required
from .models import Investment, Project, Transaction, User
from .serializer import BuyStockSerializer, ProjectSerializer, RegisterSerializer, TransactionHistorySerializer, UserSerializer
from vesHack import settings

# Create your views here.


class UserRegister(APIView):
    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        print(request.data)

        if serializer.is_valid():
            user = serializer.save()
            token = jwt.encode({'user_id': str(user.id)},
                               settings.SECRET_KEY, algorithm='HS256')
            return Response({
                'token': token,
                'userId': user.id,
                'name': user.name,
                'email': user.email,
                'password': user.password
            }, status=status.HTTP_201_CREATED)

        return Response({"error": "Invalid data format. Data must be serialized properly."}, status=status.HTTP_400_BAD_REQUEST)


class UserLogin(APIView):
    def post(self, request):
        email = request.data.get("email")
        password = request.data.get("password")
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

        if user.check_password(password):
            token = jwt.encode({'user_id': str(user.id)},
                               settings.SECRET_KEY, algorithm='HS256')
            return Response({'token': token, "userId": user.id, "name": user.name, "email": user.email, "password": user.password}, status=status.HTTP_200_OK)
        return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)


class UserDetails(APIView):

    @method_decorator(jwt_required)
    def get(self, request):
        user = getattr(request, 'user', None)
        if user:
            serializer = UserSerializer(user)
            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            return Response({'error': 'User not authenticated.'}, status=status.HTTP_401_UNAUTHORIZED)


class ProjectDisplay(APIView):
    @method_decorator(jwt_required)
    def get(self, request):
        projects = Project.objects.all()
        serializer = ProjectSerializer(projects, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class BuyStockView(APIView):
    @method_decorator(jwt_required)
    def post(self, request, *args, **kwargs):
        serializer = BuyStockSerializer(
            data=request.data, context={'request': request})

        # Validate input
        if serializer.is_valid():
            user = request.user
            project = serializer.validated_data['project']  # Corrected access
            shares_to_buy = serializer.validated_data['shares_to_buy']
            total_cost = serializer.validated_data['total_cost']

            # Process the investment
            investment = Investment.objects.create(
                user=user,
                project=project,
                shares_purchased=shares_to_buy
            )

            # Deduct from user's dummy amount
            user.dummy_amount -= total_cost
            user.save()

            # Log the transaction
            Transaction.objects.create(
                user=user,
                project=project,
                transaction_id=str(uuid.uuid4()),
                amount=total_cost,
                status="completed"
            )

            return Response({
                "message": "Investment successful",
                "investment": {
                    "project_name": project.name,
                    "shares_purchased": shares_to_buy,
                    "total_cost": total_cost
                },
                "new_balance": user.dummy_amount
            }, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class TransactionHistoryView(APIView):
    @method_decorator(jwt_required)
    def get(self, request, *args, **kwargs):
        user = request.user
        transactions = Transaction.objects.filter(
            user=user).order_by('-timestamp')
        serializer = TransactionHistorySerializer(transactions, many=True)

        return Response({
            "user": user.name,  # Adjusted user field
            "transactions": serializer.data
        })
