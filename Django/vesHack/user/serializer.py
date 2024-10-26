from rest_framework import serializers
from .models import Project, Transaction, User


class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ['id', 'name', 'email']


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ['name', 'email', 'password']

    def create(self, validated_data):
        user = User(
            name=validated_data['name'],
            email=validated_data['email'],
        )
        user.set_password(validated_data['password'])
        user.save()
        return user


class ProjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project
        fields = ['id',
                  'name', 'description', 'energy_produced', 'carbon_reduced_per_stock', 'total_carbon_reduced', 'availability', 'created_at', 'updated_at'
                  ]
        read_only_fields = ['id', 'created_at', 'updated_at',
                            'total_carbon_reduced']


class BuyStockSerializer(serializers.Serializer):
    project_id = serializers.UUIDField()
    shares_to_buy = serializers.IntegerField(min_value=1)

    def validate(self, data):
        project_id = data.get('project_id')
        shares_to_buy = data.get('shares_to_buy')

        # Check if the project exists
        try:
            project = Project.objects.get(id=project_id)
        except Project.DoesNotExist:
            raise serializers.ValidationError("Project does not exist.")

        # Check if project is available
        if not project.availability:
            raise serializers.ValidationError(
                "Project is not available for investment.")

        # Calculate the total cost for the shares
        total_cost = project.share_price * shares_to_buy

        # Check if the user has enough dummy amount
        user = self.context['request'].user
        if user.dummy_amount < total_cost:
            raise serializers.ValidationError("Insufficient funds.")

        # Set validated data for further use
        data['project'] = project
        data['total_cost'] = total_cost
        return data


class TransactionHistorySerializer(serializers.ModelSerializer):
    project_name = serializers.CharField(
        source='project.name')  # Fetch project name

    class Meta:
        model = Transaction
        fields = ['transaction_id', 'project_name',
                  'amount', 'status', 'timestamp']
