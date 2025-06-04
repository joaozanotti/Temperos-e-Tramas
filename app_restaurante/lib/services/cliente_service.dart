import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:app_restaurante/models/pessoa.dart';
import 'package:app_restaurante/models/cliente.dart';

class ClienteService {
  final String _baseUrlClientes = 'http://127.0.0.1:8000/clientes/';
  final String _baseUrlPessoas = 'http://127.0.0.1:8000/pessoas/';
  final String username = 'admin';
  final String password = '1234';

  Future<List<Cliente>> listarClientes() async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.get(
      Uri.parse(_baseUrlClientes),
      headers: {
        'Content-Type': 'application/json',
        'authorization': basicAuth
      },
    );

    if (response.statusCode == 200) {
      developer.log('RESPONSE BODY: ${response.body}');
      List jsonList = json.decode(response.body);
      return jsonList.map((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar clientes');
    }
  }

  Future<Cliente> buscarCliente(String idCliente) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.get(
      Uri.parse("$_baseUrlClientes$idCliente/"),
      headers: {
        'Content-Type': 'application/json',
        'authorization': basicAuth
      },
    );

    if (response.statusCode == 200) {
      developer.log('RESPONSE BODY: ${response.body}');
      return Cliente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao buscar cliente');
    }
  }

  Future<String> criarCliente(Cliente cliente) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    Map<String, dynamic> requestPessoa = {
      'nome': cliente.pessoa.nome, 
      'telefone': cliente.pessoa.telefone, 
      'CPF': cliente.pessoa.cpf, 
      'endereco': cliente.pessoa.endereco, 
      'email': cliente.pessoa.email, 
      'senha': cliente.pessoa.senha
    };

    final responsePessoa = await http.post(
      Uri.parse(_baseUrlPessoas),
      headers: {
        'Content-Type': 'application/json',
        'authorization': basicAuth
      },
      body: jsonEncode(requestPessoa)
    );

    if (responsePessoa.statusCode == 201) {
      developer.log('RESPONSE BODY: ${responsePessoa.body}');

      Pessoa pessoa = Pessoa.fromJson(json.decode(responsePessoa.body));
      Map<String, dynamic> requestCliente = {
        'pessoa': pessoa.id
      };

      final responseCliente = await http.post(
        Uri.parse(_baseUrlClientes),
        headers: {
          'Content-Type': 'application/json',
          'authorization': basicAuth
        },
        body: jsonEncode(requestCliente)
      );

      developer.log('RESPONSE BODY: ${responseCliente.body}');
      return 'Cliente criado com sucesso';
    } else {
      throw Exception("Erro ao adicionar cliente");
    }
  }

  Future<Pessoa> editarCliente(Cliente cliente) async {
    final String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    Map<String, dynamic> request = {
      'nome': cliente.pessoa.nome, 
      'telefone': cliente.pessoa.telefone, 
      'CPF': cliente.pessoa.cpf, 
      'endereco': cliente.pessoa.endereco, 
      'email': cliente.pessoa.email, 
      'senha': cliente.pessoa.senha
    };

    final response = await http.put(
      Uri.parse('$_baseUrlPessoas${cliente.pessoa.id}/'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': basicAuth
      },
      body: jsonEncode(request)
    );

    if (response.statusCode == 200) {
      developer.log('RESPONSE BODY: ${response.body}');
      return Pessoa.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar cliente');
    }
  }

  Future<String> deletarCliente(Cliente cliente) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final responseCliente = await http.delete(
      Uri.parse('$_baseUrlClientes${cliente.id}/'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': basicAuth
      },
    );

    if (responseCliente.statusCode == 204) {
      final responsePessoa = await http.delete(
        Uri.parse('$_baseUrlPessoas${cliente.pessoa.id}/'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': basicAuth
        },
      );

      if (responsePessoa.statusCode == 204) {
        developer.log('RESPONSE BODY: ${responsePessoa.body}');
        return 'Cliente deletado com sucesso';

      } else {
        throw Exception('Erro ao deletar pessoa');
      }
    } else {
      throw Exception('Erro ao deletar cliente');
    }
  }
}