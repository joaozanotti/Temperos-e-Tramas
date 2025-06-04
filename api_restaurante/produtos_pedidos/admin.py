from django.contrib import admin
from .models import Produto, Pedido, ItemPedido

# Register your models here.
@admin.register(Produto)
class ProdutoAdmin(admin.ModelAdmin):
    list_display = ('id_prod', 'nome', 'descricao', 'preco', 'imagem')

@admin.register(Pedido)
class PedidoAdmin(admin.ModelAdmin):
    list_display = ('id_pedi', 'cliente', 'data_hora', 'mesa', 'status')

@admin.register(ItemPedido)
class ItemPedidoAdmin(admin.ModelAdmin):
    list_display = ('id_item_pedi', 'pedido', 'produto', 'quantidade')