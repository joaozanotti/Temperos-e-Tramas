# Generated by Django 5.2.1 on 2025-05-29 00:49

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('pessoas', '0002_rename_id_pess_cliente_pessoa'),
    ]

    operations = [
        migrations.AlterField(
            model_name='cliente',
            name='pessoa',
            field=models.OneToOneField(db_column='pessoa_id', on_delete=django.db.models.deletion.CASCADE, to='pessoas.pessoa'),
        ),
    ]
