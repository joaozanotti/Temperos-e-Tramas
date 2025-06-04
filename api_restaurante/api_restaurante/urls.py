"""
URL configuration for api_restaurante project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include

# django rest
from rest_framework import routers
from pessoas.api import viewsets as pessoas_viewsets
from produtos_pedidos.api import viewsets as produtos_pedidos_viewsets

from django.urls import path
from pessoas.views import ClienteListCreateView, ClienteDetailView
from produtos_pedidos.views import ProdutoListView, ProdutoDetailView, ItemPedidoLoteView, ItemPedidoDetailView, ItemPedidoListView, ItensPorPedidoView

rota = routers.DefaultRouter()
rota.register(r'pessoas', pessoas_viewsets.PessoaViewSet)
rota.register(r'clientes', pessoas_viewsets.ClienteViewSet)
rota.register(r'produtos', produtos_pedidos_viewsets.ProdutoViewSet)
rota.register(r'pedidos', produtos_pedidos_viewsets.PedidoViewSet)
rota.register(r'itens_pedidos', produtos_pedidos_viewsets.ItemPedidoViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include(rota.urls)),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    path('clientes/', ClienteListCreateView.as_view(), name='cliente-list'),
    path('clientes/<uuid:id_clie>/', ClienteDetailView.as_view(), name='cliente-detail'),
    path('produtos/', ProdutoListView.as_view(), name='produto-list'),
    path('produtos/<uuid:id_prod>/', ProdutoDetailView.as_view(), name='produto-detail'),
    path('itens_pedidos/lote/', ItemPedidoLoteView.as_view()),
    path('itens_pedidos/', ItemPedidoListView.as_view(), name='item-pedido-list'),
    path('itens_pedidos/<uuid:id_item_pedi>/', ItemPedidoDetailView.as_view(), name='item-pedido-detail'),
    path('itens_pedidos/pedido/<uuid:id_pedi>/', ItensPorPedidoView.as_view(), name='itens-por-pedido'),

]
