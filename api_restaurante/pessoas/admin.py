from django.contrib import admin
from .models import Pessoa, Cliente

@admin.register(Pessoa)
class PessoaAdmin(admin.ModelAdmin):
    list_display = ('id_pess', 'nome', 'telefone', 'CPF')

@admin.register(Cliente)
class ClienteAdmin(admin.ModelAdmin):
    list_display = ('id_clie', 'pessoa')
