from datetime import timedelta

from django.conf import settings
from django.core.exceptions import PermissionDenied
from django.db import connection, transaction
from django.db.models import Q
from django.utils import timezone
from rest_framework.exceptions import ValidationError

from reservations.models import Reservation


def _validate_duration(start_at, end_at):
    if start_at >= end_at:
        raise ValidationError("La fecha de inicio debe ser anterior a la fecha fin")
    duration = end_at - start_at
    min_duration = timedelta(minutes=settings.RESERVATION_MIN_DURATION_MINUTES)
    max_duration = timedelta(hours=settings.RESERVATION_MAX_DURATION_HOURS)
    if duration < min_duration:
        raise ValidationError(f"La reserva debe durar al menos {min_duration}")
    if duration > max_duration:
        raise ValidationError(f"La reserva no puede exceder {max_duration}")


def _get_default_space():
    from spaces.models import Space  # Local import to avoid circular import in migrations

    space, _ = Space.objects.get_or_create(
        name="Módulo 3", defaults={"description": "Espacio único de Biblioteca FESC", "is_active": True}
    )
    return space


def validate_overlap(space, start_at, end_at, exclude_reservation_id=None):
    """
    Validate no overlapping reservations in PENDING/APPROVED for the same space.
    """
    _validate_duration(start_at, end_at)
    overlap_filter = Q(start_at__lt=end_at) & Q(end_at__gt=start_at)
    active_statuses = [Reservation.Status.PENDING, Reservation.Status.APPROVED]
    qs = Reservation.objects.filter(space=space, status__in=active_statuses)
    if getattr(connection.features, "supports_select_for_update", False):
        qs = qs.select_for_update()
    if exclude_reservation_id:
        qs = qs.exclude(id=exclude_reservation_id)
    if qs.filter(overlap_filter).exists():
        raise ValidationError("Ya existe una reserva en ese rango")


def create_reservation(user, data):
    from spaces.models import Space  # Local import to avoid circular import in migrations

    space_obj = data.get("space")
    if isinstance(space_obj, Space):
        space = space_obj
    elif space_obj:
        try:
            space = Space.objects.get(id=space_obj)
        except Space.DoesNotExist as exc:
            raise ValidationError("No se encontró el espacio") from exc
    else:
        space = _get_default_space()
    start_at = data["start_at"]
    end_at = data["end_at"]
    if timezone.is_naive(start_at):
        start_at = timezone.make_aware(start_at, timezone.get_default_timezone())
    if timezone.is_naive(end_at):
        end_at = timezone.make_aware(end_at, timezone.get_default_timezone())
    with transaction.atomic():
        validate_overlap(space, start_at, end_at)
        reservation = Reservation.objects.create(
            space=space,
            created_by=user,
            title=data.get("title"),
            description=data.get("description", ""),
            start_at=start_at,
            end_at=end_at,
            status=Reservation.Status.PENDING,
        )
    return reservation


def cancel_reservation(actor, reservation: Reservation):
    if actor.role != "ADMIN" and reservation.created_by_id != actor.id:
        raise PermissionDenied("Cannot cancel another user's reservation")
    with transaction.atomic():
        reservation.status = Reservation.Status.CANCELLED
        reservation.decision_at = timezone.now()
        reservation.approved_by = None
        reservation.decision_note = ""
        reservation.save()
    return reservation


def approve_reservation(admin_user, reservation: Reservation, note=None):
    if admin_user.role != "ADMIN":
        raise PermissionDenied("Only admins can approve")
    with transaction.atomic():
        reservation.status = Reservation.Status.APPROVED
        reservation.approved_by = admin_user
        reservation.decision_at = timezone.now()
        reservation.decision_note = note or ""
        reservation.save()
    return reservation


def reject_reservation(admin_user, reservation: Reservation, note=None):
    if admin_user.role != "ADMIN":
        raise PermissionDenied("Only admins can reject")
    with transaction.atomic():
        reservation.status = Reservation.Status.REJECTED
        reservation.approved_by = admin_user
        reservation.decision_at = timezone.now()
        reservation.decision_note = note or ""
        reservation.save()
    return reservation
