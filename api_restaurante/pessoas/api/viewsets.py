from rest_framework import viewsets, permissions
from rest_framework.authentication import SessionAuthentication, BasicAuthentication, TokenAuthentication
from pessoas.api.serializers import PessoaSerializer, ClienteReadSerializer, ClienteWriteSerializer
from pessoas import models

class PessoaViewSet(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = (BasicAuthentication, SessionAuthentication, TokenAuthentication)
    serializer_class  = PessoaSerializer
    queryset = models.Pessoa.objects.all()

class ClienteViewSet(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = (BasicAuthentication, SessionAuthentication, TokenAuthentication)
    queryset = models.Cliente.objects.all()

    def get_serializer_class(self):
        if self.action in ['list', 'retrieve']:
            return ClienteReadSerializer
        return ClienteWriteSerializer