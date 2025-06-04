import 'package:flutter/material.dart';

const Color vermelhoEscuro = Color(0xFF770100);
const Color laranjaFundo = Color(0xffe8cdd9);
const Color brancoGeloAzulado = Color(0xFFF8FBFF);
const Color fundoClaro = Color(0xFFFFF8E1);
bool usuarioLogado = true;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brancoGeloAzulado,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Temperos & Tramas'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        centerTitle: true,
        backgroundColor: vermelhoEscuro,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage(
                'logo.png',
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Bem-vindo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: vermelhoEscuro,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Desfrute de nossos pratos deliciosos e um ambiente aconchegante. Escolha sua mesa e veja nosso cardápio!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/listarProdutos');
              },
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Produtos'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: vermelhoEscuro,
                minimumSize: const Size(double.infinity, 50),
                iconColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/listarClientes');
              },
              icon: const Icon(Icons.account_circle),
              label: const Text('Clientes'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: vermelhoEscuro,
                minimumSize: const Size(double.infinity, 50),
                iconColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/listarPedidos');
              },
              icon: const Icon(Icons.list_alt),
              label: const Text('Pedidos'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: vermelhoEscuro,
                minimumSize: const Size(double.infinity, 50),
                iconColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/fazerPedido');
              },
              icon: const Icon(Icons.restaurant),
              label: const Text('Registrar pedido'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: vermelhoEscuro,
                minimumSize: const Size(double.infinity, 50),
                iconColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF770100),
        child: Center(child: Text("Desenvolvido por Adrian e João Vitor", style: TextStyle(color: Colors.white))),
      )
    );
  }
}
