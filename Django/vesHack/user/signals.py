from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Investment, User, Project, EnvironmentalImpact, CommunityImpact


@receiver(post_save, sender=Investment)
def update_user_and_environmental_impact(sender, instance, created, **kwargs):
    # Update user totals if it's a new investment
    if created:
        instance.user.update_totals()

        total_carbon_saved = sum(
            inv.carbon_saving for inv in instance.project.investments.all())

        # Update Environmental Impact
        EnvironmentalImpact.objects.update_or_create(
            project=instance.project,
            defaults={
                'total_carbon_saved': total_carbon_saved,
                'equivalent_cars_removed': calculate_equivalent_cars(total_carbon_saved),
                'equivalent_trees_planted': calculate_equivalent_trees(total_carbon_saved)
            }
        )

        # Update Community Impact
        total_investment = sum(
            inv.invested_amount for inv in Investment.objects.all())
        total_energy_savings = sum(
            inv.energy_saving for inv in Investment.objects.all())
        total_carbon_savings = sum(
            inv.carbon_saving for inv in Investment.objects.all())

        CommunityImpact.objects.update_or_create(
            defaults={
                'total_investment': total_investment,
                'total_energy_savings': total_energy_savings,
                'total_carbon_savings': total_carbon_savings,
                'equivalent_cars_removed': calculate_equivalent_cars(total_carbon_savings),
                'equivalent_trees_planted': calculate_equivalent_trees(total_carbon_savings)
            }
        )


@receiver(post_save, sender=Investment)
def update_project_totals(sender, instance, created, **kwargs):
    if created:  # Only update totals if a new investment is created
        instance.project.update_totals()


def calculate_equivalent_cars(carbon_saved):
    return int(carbon_saved / 4.6)


def calculate_equivalent_trees(carbon_saved):
    return int(carbon_saved / 0.048)
