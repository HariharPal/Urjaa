from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.utils import timezone
from django.contrib.auth.hashers import make_password


class AdminManager(BaseUserManager):
    def create_admin(self, email, name, password):
        hashed_password = make_password(password)
        admin = self.model(email=email, name=name, password=hashed_password)
        admin.save(using=self._db)
        return admin

    def create_superuser(self, email, name, password=None, **extra_fields):
        """
        Create and return a superuser with admin rights.
        """
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        admin = self.model(email=email, name=name, **extra_fields)
        admin.set_password(password)
        admin.is_staff = True
        admin.is_superuser = True
        admin.save(using=self._db)
        return admin


class Admin(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(unique=True)
    name = models.CharField(max_length=255)
    password = models.CharField(max_length=128)  # Store hashed password
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)

    objects = AdminManager()
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['name']

    def __str__(self):
        return self.email

    class Meta:
        db_table = "admin"
        verbose_name_plural = "Admin"
