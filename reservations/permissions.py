from rest_framework.permissions import BasePermission

from accounts.models import User


class IsOwnerOrAdmin(BasePermission):
    """
    Allows action if the user is admin or owner of the reservation.
    """

    def has_object_permission(self, request, view, obj):
        if isinstance(request.user, User) and request.user.role == User.Role.ADMIN:
            return True
        return obj.created_by_id == getattr(request.user, "id", None)
