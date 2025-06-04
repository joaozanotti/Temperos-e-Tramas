from rest_framework import viewsets, permissions, status
from rest_framework.response import Response
from rest_framework.authentication import SessionAuthentication, BasicAuthentication, TokenAuthentication
from produtos_pedidos.api.serializers import PedidoReadSerializer, PedidoWriteSerializer, ItemPedidoReadSerializer, ItemPedidoWriteSerializer, ProdutoSerializer
from produtos_pedidos import models

class PedidoViewSet(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = (BasicAuthentication, SessionAuthentication, TokenAuthentication)
    queryset = models.Pedido.objects.all()

    def get_serializer_class(self):
        if self.action in ['list', 'retrieve']:
            return PedidoReadSerializer
        return PedidoWriteSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = PedidoWriteSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        pedido = serializer.save()
        read_serializer = PedidoReadSerializer(pedido)
        return Response(read_serializer.data, status=status.HTTP_201_CREATED)

class ItemPedidoViewSet(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = (BasicAuthentication, SessionAuthentication, TokenAuthentication)
    queryset = models.ItemPedido.objects.all()

    def get_serializer_class(self):
        if self.action in ['list', 'retrieve']:
            return ItemPedidoReadSerializer
        return ItemPedidoWriteSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = ItemPedidoWriteSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        item_pedido = serializer.save()
        read_serializer = ItemPedidoReadSerializer(item_pedido)
        return Response(read_serializer.data, status=status.HTTP_201_CREATED)

class ProdutoViewSet(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = (BasicAuthentication, SessionAuthentication, TokenAuthentication)
    serializer_class  = ProdutoSerializer
    queryset = models.Produto.objects.all()