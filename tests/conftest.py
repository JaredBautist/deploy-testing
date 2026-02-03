import pytest
from django.contrib.auth import get_user_model
from rest_framework.test import APIClient

from spaces.models import Space


@pytest.fixture
def api_client():
    return APIClient()


@pytest.fixture
def user_factory():
    def factory(**kwargs):
        User = get_user_model()
        password = kwargs.pop("password", "Password123!")
        defaults = {"role": User.Role.TEACHER, "email": "user@example.com"}
        defaults.update(kwargs)
        user = User.objects.create(**defaults)
        user.set_password(password)
        user.save()
        user.raw_password = password  # convenience for login
        return user

    return factory


@pytest.fixture
def admin_user(user_factory):
    return user_factory(email="admin@example.com", role="ADMIN")


@pytest.fixture
def teacher_user(user_factory):
    return user_factory(email="teacher@example.com", role="TEACHER")


@pytest.fixture
def space():
    return Space.objects.create(name="Módulo 3")
