import 'package:app_restaurante/screens/selecionar_cliente_page.dart';
import 'package:app_restaurante/screens/listar_clientes_page.dart';
import 'package:app_restaurante/screens/listar_pedidos_page.dart';
import 'package:app_restaurante/screens/registrar_cliente_page.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/listar_produtos_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurante',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/listarProdutos': (context) => const ListarProdutosPage(),
        '/fazerPedido': (context) => const SelecionarClientePage(),
        '/listarClientes': (context) => const ListarClientesPage(),
        '/listarPedidos': (context) => ListarPedidosPage(),
        '/cadastroCliente': (context) => const RegistrarClientePage(),
      },
    );
  }
}
