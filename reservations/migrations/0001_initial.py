from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):
    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ("spaces", "0001_initial"),
    ]

    operations = [
        migrations.CreateModel(
            name="Reservation",
            fields=[
                ("id", models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name="ID")),
                ("created_at", models.DateTimeField(auto_now_add=True)),
                ("updated_at", models.DateTimeField(auto_now=True)),
                ("title", models.CharField(max_length=255)),
                ("description", models.TextField(blank=True)),
                ("start_at", models.DateTimeField()),
                ("end_at", models.DateTimeField()),
                (
                    "status",
                    models.CharField(
                        choices=[
                            ("PENDING", "Pending"),
                            ("APPROVED", "Approved"),
                            ("REJECTED", "Rejected"),
                            ("CANCELLED", "Cancelled"),
                        ],
                        default="PENDING",
                        max_length=20,
                    ),
                ),
                ("decision_at", models.DateTimeField(blank=True, null=True)),
                ("decision_note", models.TextField(blank=True)),
                ("approved_by", models.ForeignKey(blank=True, null=True, on_delete=models.PROTECT, related_name="approved_reservations", to=settings.AUTH_USER_MODEL)),
                ("created_by", models.ForeignKey(on_delete=models.PROTECT, related_name="created_reservations", to=settings.AUTH_USER_MODEL)),
                ("space", models.ForeignKey(on_delete=models.PROTECT, related_name="reservations", to="spaces.space")),
            ],
            options={"ordering": ["-start_at"]},
        ),
        migrations.AddIndex(
            model_name="reservation",
            index=models.Index(fields=["space", "start_at"], name="IX_reservations_space_start"),
        ),
        migrations.AddIndex(
            model_name="reservation",
            index=models.Index(fields=["space", "end_at"], name="IX_reservations_space_end"),
        ),
        migrations.AddIndex(
            model_name="reservation",
            index=models.Index(fields=["created_by", "start_at"], name="IX_reservations_created_start"),
        ),
        migrations.AddIndex(
            model_name="reservation",
            index=models.Index(fields=["status", "start_at"], name="IX_reservations_status_start"),
        ),
    ]
