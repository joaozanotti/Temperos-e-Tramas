import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:app_restaurante/models/produto.dart';

class ProdutoService {
  final String _baseUrl = 'http://127.0.0.1:8000/produtos/';
  final String username = 'admin';
  final String password = '1234';

  Future<List<Produto>> listarProdutos() async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'authorization': basicAuth
      },
    );

    if (response.statusCode == 200) {
      developer.log('RESPONSE BODY: ${response.body}');
      List jsonList = json.decode(response.body);
      return jsonList.map((json) => Produto.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar produtos');
    }
  }

  Future<Produto> buscarProduto(String? idProduto) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.get(
      Uri.parse("$_baseUrl$idProduto/"),
      headers: {
        'Content-Type': 'application/json',
        'authorization': basicAuth
      },
    );

    if (response.statusCode == 200) {
      developer.log('RESPONSE BODY: ${response.body}');
      return Produto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao buscar produto');
    }
  }

  Future<Produto> criarProduto(Produto produto) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    Map<String, dynamic> request = {
      'nome': produto.nome, 
      'descricao': produto.descricao, 
      'preco': produto.preco, 
      'imagem': produto.imagem
    };

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'authorization': basicAuth
      },
      body: jsonEncode(request)
    );

    if (response.statusCode == 201) {
      developer.log('RESPONSE BODY: ${response.body}');
      return Produto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Erro ao adicionar produto");
    }
  }

  Future<String> editarProduto(Produto produto) async {
    final String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    Map<String, dynamic> request = {
      'nome': produto.nome, 
      'descricao': produto.descricao, 
      'preco': produto.preco, 
      'imagem': produto.imagem
    };

    final response = await http.put(
      Uri.parse('$_baseUrl${produto.id}/'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': basicAuth
      },
      body: jsonEncode(request)
    );

    if (response.statusCode == 200) {
      developer.log('RESPONSE BODY: ${response.body}');
      return 'Produto atualizado com sucesso';
    } else {
      throw Exception('Erro ao atualizar produto');
    }
  }

  Future<String> deletarProduto(String? idProduto) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.delete(
      Uri.parse("$_baseUrl$idProduto/"),
      headers: {
        'Content-Type': 'application/json',
        'authorization': basicAuth
      },
    );

    if (response.statusCode == 204) {
      developer.log('RESPONSE BODY: ${response.body}');
      return 'Produto deletado com sucesso';
    } else {
      throw Exception('Erro ao deletar produto');
    }
  }
}