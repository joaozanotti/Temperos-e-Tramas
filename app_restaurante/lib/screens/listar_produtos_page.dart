import 'package:app_restaurante/screens/registrar_produto_page.dart';
import 'package:app_restaurante/widgets/produto_card.dart';
import 'package:flutter/material.dart';
import '../services/produto_service.dart';
import '../models/produto.dart';

class ListarProdutosPage extends StatefulWidget {
  const ListarProdutosPage({super.key});

  @override
  State<ListarProdutosPage> createState() => _ListarProdutosPageState();
}

class _ListarProdutosPageState extends State<ListarProdutosPage> {
  late Future<List<Produto>> _produtosFuture;

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  void _carregarProdutos() {
    _produtosFuture = ProdutoService().listarProdutos();
  }

  void _adicionarProduto() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrarProdutoPage()),
    );

    if (result == true) {
      setState(() {
        _carregarProdutos();
      });
    }
  }

  void _editarProduto(String? id, String mensagem) {
    setState(() {
      _carregarProdutos();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  void _removerProduto(String? id, String mensagem) {
    setState(() {
      _carregarProdutos();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brancoGeloAzulado,
      appBar: AppBar(
        title: const Text('Lista de produtos'),
        centerTitle: true,
        backgroundColor: vermelhoEscuro,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        leading: IconButton(
          icon: const Icon(Icons.reply),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Produto>>(
        future: _produtosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }

          final produtos = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              return ProdutoCard(
                produto: produtos[index],
                onDelete: _removerProduto,
                onEdit: _editarProduto
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF770100),
        foregroundColor: Colors.white,
        onPressed: () => _adicionarProduto(), 
        tooltip: 'Cadastrar novo produto',
        child: Icon(Icons.add)
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF770100),
        child: Center(child: Text("Desenvolvido por Adrian e João Vitor", style: TextStyle(color: Colors.white))),
      )
    );
  }
}
