from django.db import models
from uuid import uuid4
from pessoas import models as pessoas_models

class StatusPedido(models.TextChoices):
    ABERTO = 'Aberto', 'Aberto'
    PREPARANDO = 'Preparando', 'Preparando'
    FECHADO = 'Fechado', 'Fechado'

# Create your models here.
class Pedido(models.Model):
    id_pedi = models.UUIDField(primary_key=True, default=uuid4, editable=False)
    cliente = models.ForeignKey(pessoas_models.Cliente, on_delete=models.CASCADE, related_name='pedido')
    data_hora = models.DateTimeField(auto_now_add=True)
    mesa = models.IntegerField()
    status = models.CharField(max_length=10,choices=StatusPedido.choices, default=StatusPedido.ABERTO)

    def __str__(self):
        return f'{self.data_hora} (Mesa {self.mesa}) - {self.status}'

class Produto(models.Model):
    id_prod = models.UUIDField(primary_key=True, default=uuid4, editable=False)
    nome = models.CharField(max_length=45)
    descricao = models.CharField(max_length=45)
    preco = models.DecimalField(max_digits=5, decimal_places=2)
    imagem = models.CharField(max_length=255, null=True)

    def __str__(self):
        return f'{self.nome} (R${self.preco})'

class ItemPedido(models.Model):
    id_item_pedi = models.UUIDField(primary_key=True, default=uuid4, editable=False)
    pedido = models.ForeignKey('Pedido', on_delete=models.CASCADE, related_name='pedido')
    produto = models.ForeignKey('Produto', on_delete=models.CASCADE, related_name='produto')
    quantidade = models.IntegerField()