import 'package:app_restaurante/models/cliente.dart';
import 'package:app_restaurante/models/produto.dart';

class Pedido {
  final String? id;
  final Cliente cliente;
  final DateTime? dataHora;
  final int mesa;
  final String status;
  final List<ItemPedido> itens;

  Pedido({
    this.id,
    required this.cliente,
    this.dataHora,
    required this.mesa,
    required this.status,
    this.itens = const [],
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id_pedi'],
      cliente: Cliente.fromJson(json['cliente']),
      dataHora: DateTime.parse(json['data_hora']),
      mesa: json['mesa'],
      status: json['status']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pedi': id,
      'cliente': cliente.id,
      'data_hora': dataHora!.toIso8601String(),
      'mesa': mesa,
      'status': status,
    };
  }
}

class ItemPedido {
  final String idItem;
  final String idPedido;
  final Produto produto;
  final int quantidade;

  ItemPedido({
    required this.idItem,
    required this.idPedido,
    required this.produto,
    required this.quantidade,
  });

  factory ItemPedido.fromJson(Map<String, dynamic> json) {
    return ItemPedido(
      idItem: json['id_item_pedi'],
      idPedido: json['pedido'],
      produto: Produto.fromJson(json['produto']),
      quantidade: json['quantidade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_item_pedi': idItem,
      'pedido': idPedido,
      'produto': produto.id,
      'quantidade': quantidade,
    };
  }
}
