from rest_framework import serializers
from pessoas import models

class PessoaSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Pessoa
        fields = '__all__'

# Leitura detalhada (usado no GET)
class ClienteReadSerializer(serializers.ModelSerializer):
    pessoa = PessoaSerializer()  # dados completos

    class Meta:
        model = models.Cliente
        fields = ['id_clie', 'pessoa']

# Escrita simplificada (usado no POST/PUT)
class ClienteWriteSerializer(serializers.ModelSerializer):
    pessoa = serializers.PrimaryKeyRelatedField(queryset=models.Pessoa.objects.all())

    class Meta:
        model = models.Cliente
        fields = ['id_clie', 'pessoa']