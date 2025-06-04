from rest_framework import status
from rest_framework.views import APIView
from rest_framework.generics import ListAPIView, RetrieveAPIView
from rest_framework.authentication import TokenAuthentication, BasicAuthentication, SessionAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from .models import Produto, ItemPedido
from .api.serializers import ProdutoSerializer, ItemPedidoReadSerializer, ItemPedidoWriteSerializer

# GET /produtos/ – lista todos os produtos
class ProdutoListView(ListAPIView):
    queryset = Produto.objects.all()
    serializer_class = ProdutoSerializer
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

# GET /produtos/<id_prod>/ – retorna um único produto pelo ID
class ProdutoDetailView(RetrieveAPIView):
    queryset = Produto.objects.all()
    serializer_class = ProdutoSerializer
    lookup_field = 'id_prod'  # Busca usando o campo 'id_prod'
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

# POST /itens_pedidos/lote/ – adiciona vários itens de uma só vez
class ItemPedidoLoteView(APIView):
    def post(self, request):
        serializer = ItemPedidoWriteSerializer(data=request.data, many=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# GET /itens_pedidos/ – lista todos os itens
class ItemPedidoListView(ListAPIView):
    queryset = ItemPedido.objects.all()
    serializer_class = ItemPedidoReadSerializer
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

# GET /itens_pedidos/<id_item_pedi>/ – retorna um único item pelo ID 
class ItemPedidoDetailView(RetrieveAPIView):
    queryset = ItemPedido.objects.all()
    serializer_class = ItemPedidoReadSerializer
    lookup_field = 'id_item_pedi' # Busca usando o campo 'id_item_pedi'
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, id_item_pedi):
        item_pedido = ItemPedido.objects.get(id_item_pedi=id_item_pedi)
        serializer = ItemPedidoReadSerializer(item_pedido)
        return Response(serializer.data)
    
# GET /itens_pedidos/pedido/<id_pedi>/ - lista todos os itens de certo pedido
class ItensPorPedidoView(APIView):
    authentication_classes = [BasicAuthentication, SessionAuthentication, TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, id_pedi):
        itens = ItemPedido.objects.filter(pedido_id=id_pedi)
        serializer = ItemPedidoReadSerializer(itens, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
