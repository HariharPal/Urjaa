import jwt
from django.conf import settings
from django.http import JsonResponse
from django.utils.deprecation import MiddlewareMixin


from user.models import User
from functools import wraps


def jwt_required(view_func):
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        auth_header = request.headers.get('token')
        if not auth_header:
            return JsonResponse({'error': 'Authentication token not provided.'}, status=401)
        try:
            print(auth_header)
            token = auth_header.split(' ')[0]
            payload = jwt.decode(
                token, settings.SECRET_KEY, algorithms=['HS256'])

            if 'user_id' in payload:
                try:
                    user = User.objects.get(id=payload['user_id'])
                    request.user = user

                except User.DoesNotExist:
                    return JsonResponse({'error': 'User not found.'}, status=401)

        except jwt.ExpiredSignatureError:
            return JsonResponse({'error': 'Token has expired.'}, status=401)
        except jwt.InvalidTokenError:
            return JsonResponse({'error': 'Invalid token.'}, status=401)

        return view_func(request, *args, **kwargs)

    return _wrapped_view
