from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
import uuid

# Custom User Manager


class CustomUserManager(BaseUserManager):
    def create_user(self, name, email, password=None):
        if not email:
            raise ValueError('The Email field must be set')
        normalized_email = self.normalize_email(email)
        user = self.model(email=normalized_email, name=name)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(email, password, **extra_fields)


class User(AbstractBaseUser):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=50)
    email = models.EmailField(max_length=255, unique=True)
    password = models.CharField(max_length=128)
    total_investment = models.DecimalField(
        max_digits=10, decimal_places=2, default=0.00)
    total_carbon_saving = models.DecimalField(
        max_digits=10, decimal_places=2, default=0.00)
    total_energy_saving = models.DecimalField(
        max_digits=10, decimal_places=2, default=0.00)
    dummy_amount = models.DecimalField(
        max_digits=10, decimal_places=2, default=100000)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    objects = CustomUserManager()

    USERNAME_FIELD = 'email'  # Use email as the unique identifier for authentication
    REQUIRED_FIELDS = ['name']

    def __str__(self):
        return self.email

    class Meta:
        db_table = "user"
        verbose_name_plural = "Merchants"

    def update_totals(self):
        # Calculate the total investment and shares based on related investments
        # Assuming you have a related name set up in your Investment model
        investments = self.investments.all()
        self.total_investment = sum(inv.total_cost for inv in investments)
        self.total_shares = sum(inv.shares_purchased for inv in investments)

        # Save the updated totals
        self.save()


# Project Model
class Project(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=100)
    description = models.TextField()
    availability = models.BooleanField(default=True)  # New availability field
    energy_produced = models.DecimalField(
        max_digits=10, decimal_places=2, null=True)
    carbon_reduced_per_stock = models.DecimalField(
        max_digits=10, decimal_places=2, default=0.00)
    total_carbon_reduced = models.DecimalField(
        max_digits=10, decimal_places=2, default=0.00)

    share_price = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name

    class Meta:
        db_table = "project"
        verbose_name_plural = "Projects"

    def update_totals(self):
        investments = self.investments.all()

        self.total_investment = sum(inv.invested_amount for inv in investments)
        self.save()


# Investment Model


class Investment(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='investments')
    project = models.ForeignKey(
        Project, on_delete=models.CASCADE, related_name='investments')
    # Keep this if tracking share quantity per investment
    shares_purchased = models.IntegerField()
    invested_amount = models.DecimalField(
        max_digits=10, decimal_places=2, editable=False)
    investment_date = models.DateTimeField(auto_now_add=True)
    availability = models.BooleanField(default=True)
    energy_saving = models.DecimalField(
        max_digits=10, decimal_places=2, default=0.00)
    carbon_saving = models.DecimalField(
        max_digits=10, decimal_places=2, default=0.00)

    def __str__(self):
        return f"{self.user.name} invested in {self.project.name}"

    class Meta:
        db_table = "investment"
        verbose_name_plural = "Investments"

    def save(self, *args, **kwargs):
        # Check project availability before saving
        if not self.project.availability:
            raise ValueError(
                "Investment cannot be made; project is not available.")

        # Calculate invested amount based on share price
        self.invested_amount = self.shares_purchased * self.project.share_price
        super().save(*args, **kwargs)
        self.project.update_totals()
        self.user.update_totals()


# Energy Savings Model
class EnergySaving(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    project = models.ForeignKey(
        Project, on_delete=models.CASCADE, related_name='energy_savings')
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='energy_savings')
    user_energy_generated = models.DecimalField(
        max_digits=10, decimal_places=2)  # kWh
    user_carbon_saved = models.DecimalField(
        max_digits=10, decimal_places=2)  # kg CO2
    saving_record_at = models.DateTimeField(
        auto_now_add=True)  # Record date and time

    def __str__(self):
        # Corrected here
        return f"{self.user.name} savings for {self.project.name}"

    class Meta:
        db_table = "energy_saving"


class EnvironmentalImpact(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    project = models.ForeignKey(
        Project, on_delete=models.CASCADE, related_name='environmental_impacts')
    total_carbon_saved = models.DecimalField(
        max_digits=10, decimal_places=2)  # kg CO2
    equivalent_cars_removed = models.IntegerField()  # Number of cars
    equivalent_trees_planted = models.IntegerField()  # Number of trees

    def __str__(self):
        return f"Impact for {self.project.name}"

    class Meta:
        db_table = "environmental_impact"


class Transaction(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='transactions')
    project = models.ForeignKey(
        Project, on_delete=models.CASCADE, related_name='transactions')
    # Assuming this is a unique transaction identifier
    transaction_id = models.CharField(max_length=100, unique=True)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    # e.g., 'completed', 'pending', 'failed'
    status = models.CharField(max_length=50)
    transaction_date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Transaction {self.transaction_id} by {self.user.name}"

    class Meta:
        db_table = "transaction"


class CommunityImpact(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    total_investment = models.DecimalField(
        max_digits=10, decimal_places=2, default=0.00)
    total_energy_savings = models.DecimalField(
        max_digits=10, decimal_places=2, default=0.00)
    total_carbon_savings = models.DecimalField(
        max_digits=10, decimal_places=2, default=0.00)
    equivalent_cars_removed = models.IntegerField()
    equivalent_trees_planted = models.IntegerField()

    def __str__(self):
        return f"Community Impact Overview"

    class Meta:
        db_table = "community_impact"
