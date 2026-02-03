from django.conf import settings
from django.db import models
from django.utils import timezone

from core.models import TimeStampedModel
from spaces.models import Space

User = settings.AUTH_USER_MODEL


class Reservation(TimeStampedModel):
    class Status(models.TextChoices):
        PENDING = "PENDING", "Pending"
        APPROVED = "APPROVED", "Approved"
        REJECTED = "REJECTED", "Rejected"
        CANCELLED = "CANCELLED", "Cancelled"

    space = models.ForeignKey(Space, on_delete=models.PROTECT, related_name="reservations")
    created_by = models.ForeignKey(User, on_delete=models.PROTECT, related_name="created_reservations")
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    start_at = models.DateTimeField()
    end_at = models.DateTimeField()
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDING)
    approved_by = models.ForeignKey(
        User, null=True, blank=True, on_delete=models.PROTECT, related_name="approved_reservations"
    )
    decision_at = models.DateTimeField(null=True, blank=True)
    decision_note = models.TextField(blank=True)

    class Meta:
        ordering = ["-start_at"]
        indexes = [
            models.Index(fields=["space", "start_at"], name="IX_reservations_space_start"),
            models.Index(fields=["space", "end_at"], name="IX_reservations_space_end"),
            models.Index(fields=["created_by", "start_at"], name="IX_reservations_created_start"),
            models.Index(fields=["status", "start_at"], name="IX_reservations_status_start"),
        ]

    def __str__(self):
        return f"{self.title} ({self.start_at} - {self.end_at})"

    def clean(self):
        super().clean()
        if self.start_at and self.end_at and self.start_at >= self.end_at:
            from django.core.exceptions import ValidationError

            raise ValidationError("start_at must be before end_at")
        if timezone.is_naive(self.start_at) or timezone.is_naive(self.end_at):
            from django.core.exceptions import ValidationError

            raise ValidationError("Datetime values must be timezone-aware")
