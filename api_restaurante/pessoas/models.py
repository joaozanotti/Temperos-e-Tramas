from django.db import models
from uuid import uuid4

# Create your models here.
class Pessoa(models.Model):
    id_pess = models.UUIDField(primary_key=True, default=uuid4, editable=False)
    nome = models.CharField(max_length=50)
    telefone = models.CharField(max_length=15)
    CPF = models.CharField(max_length=15)
    endereco = models.CharField(max_length=100)
    email = models.CharField(max_length=50)
    senha = models.CharField(max_length=15)

    def __str__(self):
        return f'{self.nome} ({self.CPF})'

class Cliente(models.Model):
    id_clie = models.UUIDField(primary_key=True, default=uuid4, editable=False)
    pessoa = models.OneToOneField(Pessoa, on_delete=models.CASCADE, db_column='pessoa_id')