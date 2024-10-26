from django.urls import path

from .views import TransactionHistoryView, UserDetails, UserLogin, UserRegister, ProjectDisplay, BuyStockView


urlpatterns = [
    path("auth/register", UserRegister.as_view()),
    path("auth/login", UserLogin.as_view()),
    path("auth", UserDetails.as_view()),
    path("projects", ProjectDisplay.as_view()),
    path('buy-stock', BuyStockView.as_view(), name='buy-stock'),
    path('payment-history', TransactionHistoryView.as_view(),
         name='payment-history'),
]
