from django import forms
from django.contrib import admin
from user.models import Project, User  # Ensure the correct import
from .models import Admin


@admin.register(Admin)
class AdminAdmin(admin.ModelAdmin):
    pass


class ProjectForm(forms.ModelForm):
    class Meta:
        model = Project
        fields = ['name', 'description', 'availability', 'share_price',
                  'carbon_reduced_per_stock']


@admin.register(Project)
class ProjectAdmin(admin.ModelAdmin):
    form = ProjectForm
    list_display = ('name', 'description', 'availability',
                    'created_at', 'updated_at')
    search_fields = ('name',)
    ordering = ('created_at',)
