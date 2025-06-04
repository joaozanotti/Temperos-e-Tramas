from rest_framework.generics import ListAPIView, RetrieveAPIView, ListCreateAPIView
from rest_framework.response import Response
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated

from .models import Cliente
from .api.serializers import ClienteReadSerializer, ClienteWriteSerializer

# GET /clientes/ – lista todos os clientes
class ClienteListCreateView(ListCreateAPIView):
    queryset = Cliente.objects.all()
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get_serializer_class(self):
        if self.request.method == 'POST':
            return ClienteWriteSerializer  # Aceita apenas o ID de pessoa
        return ClienteReadSerializer 

# GET /clientes/<id_clie>/ – retorna um único cliente pelo ID
class ClienteDetailView(RetrieveAPIView):
    queryset = Cliente.objects.all()
    serializer_class = ClienteReadSerializer
    lookup_field = 'id_clie' # Busca usando o campo 'id_clie'
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, id_clie):
        cliente = Cliente.objects.get(id_clie=id_clie)
        serializer = ClienteReadSerializer(cliente)
        return Response(serializer.data)