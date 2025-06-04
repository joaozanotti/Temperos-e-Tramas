import 'dart:convert';
import 'package:app_restaurante/models/cliente.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurante/models/pedido.dart';

class PedidoService {
  final String _baseUrlPedidos = 'http://127.0.0.1:8000/pedidos/';
  final String _baseUrlItensPedido = 'http://127.0.0.1:8000/itens_pedidos/';
  final String username = 'admin';
  final String password = '1234';

  Future<List<Pedido>> listarPedidosComItens() async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final responsePedidos = await http.get(
      Uri.parse(_baseUrlPedidos),
      headers: {'Content-Type': 'application/json', 'authorization': basicAuth},
    );

    if (responsePedidos.statusCode != 200) {
      throw Exception('Erro ao buscar pedidos');
    }

    final jsonListPedidos = json.decode(responsePedidos.body);
    List<Pedido> pedidos = [];

    for (var jsonPedido in jsonListPedidos) {
      String pedidoId = jsonPedido['id_pedi'];

      final responseItens = await http.get(
        Uri.parse('${_baseUrlItensPedido}pedido/$pedidoId/'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': basicAuth,
        },
      );

      if (responseItens.statusCode != 200) {
        throw Exception('Erro ao buscar itens do pedido $pedidoId');
      }

      final jsonItens = json.decode(responseItens.body) as List<dynamic>;

      List<ItemPedido> itens =
        jsonItens
          .map<ItemPedido>((jsonItem) => ItemPedido.fromJson(jsonItem))
          .toList();

      pedidos.add(
        Pedido(
          id: jsonPedido['id_pedi'],
          cliente: Cliente.fromJson(jsonPedido['cliente']),
          dataHora: DateTime.parse(jsonPedido['data_hora']),
          mesa: jsonPedido['mesa'],
          status: jsonPedido['status'],
          itens: itens,
        ),
      );
    }
    return pedidos;
  }

  Future registrarPedido(Pedido pedido, Map produtos) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, dynamic> requestPedido = {
      "cliente": pedido.cliente.id,
      "mesa": pedido.mesa,
      "status": pedido.status,
    };

    final responsePedido = await http.post(
      Uri.parse(_baseUrlPedidos),
      headers: {
        "Content-Type": "application/json",
        "Authorization": basicAuth,
      },
      body: jsonEncode(requestPedido),
    );

    if (responsePedido.statusCode != 201) {
      throw Exception('Erro ao criar pedido: ${responsePedido.body}');
    }

    Pedido novoPedido = Pedido.fromJson(json.decode(responsePedido.body));
    
    for (var entry in produtos.entries) {
      final produto = entry.key;
      final quantidade = entry.value;

      final item = {
        "pedido": novoPedido.id,
        "produto": produto.id,
        "quantidade": quantidade,
      };

      final responseItem = await http.post(
        Uri.parse(_baseUrlItensPedido),
        headers: {
          "Content-Type": "application/json",
          "Authorization": basicAuth,
        },
        body: jsonEncode(item),
      );

      if (responseItem.statusCode != 201) {
        throw Exception('Erro ao criar item do pedido: ${responseItem.body}');
      }
    }
  }
}
