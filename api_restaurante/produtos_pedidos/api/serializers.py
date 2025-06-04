from rest_framework import serializers
from produtos_pedidos import models
from pessoas.api.serializers import ClienteReadSerializer

class PedidoReadSerializer(serializers.ModelSerializer):
    cliente = ClienteReadSerializer()

    class Meta:
        model = models.Pedido
        fields = '__all__'

class PedidoWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Pedido
        fields = '__all__'

class ProdutoSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Produto
        fields = '__all__'

class ItemPedidoReadSerializer(serializers.ModelSerializer):
    produto = ProdutoSerializer()

    class Meta:
        model = models.ItemPedido
        fields = '__all__'

class ItemPedidoWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.ItemPedido
        fields = '__all__'