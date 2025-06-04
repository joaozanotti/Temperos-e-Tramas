import 'package:app_restaurante/models/cliente.dart';
import 'package:app_restaurante/models/pedido.dart';
import 'package:app_restaurante/screens/selecionar_cliente_page.dart';
import 'package:app_restaurante/services/pedido_service.dart';
import 'package:app_restaurante/services/produto_service.dart';
import 'package:flutter/material.dart';
import '../models/produto.dart';

const Color vermelhoEscuro = Color(0xFF770100);
const Color brancoGeloAzulado = Color(0xFFF8FBFF);

class RegistrarPedidoPage extends StatefulWidget {
  final Cliente cliente;

  const RegistrarPedidoPage({super.key, required this.cliente});

  @override
  State<RegistrarPedidoPage> createState() => _RegistrarPedidoPageState();
}

class _RegistrarPedidoPageState extends State<RegistrarPedidoPage> {
  final Map<Produto, int> _produtos = {};
  late Future<List<Produto>> _produtosFuture;
  final TextEditingController _mesaController = TextEditingController();
  bool _mostrarResumo = false;

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  void _carregarProdutos() {
    _produtosFuture = ProdutoService().listarProdutos();
  }

  void _adicionarPrato(Produto produto) {
    setState(() {
      if (_produtos.containsKey(produto)) {
        _produtos[produto] = _produtos[produto]! + 1;
      } else {
        _produtos[produto] = 1;
      }
    });
  }

  void _removerPrato(Produto produto) {
    setState(() {
      if (_produtos.containsKey(produto) && _produtos[produto]! > 1) {
        _produtos[produto] = _produtos[produto]! - 1;
      } else {
        _produtos.remove(produto);
      }
    });
  }

  Future<void> _enviarPedido(Pedido pedido) async {
    try {
      await PedidoService().registrarPedido(pedido, _produtos);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pedido enviado com sucesso!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _produtos.clear();
        _mesaController.clear();
        _mostrarResumo = false;
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar pedido: $e')));
    }
  }

  void _finalizarPedido() {
    if (_produtos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Selecione pelo menos um produto',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      _mostrarResumo = true;
    });
  }

  void _editarPedido() {
    setState(() {
      _mostrarResumo = false;
    });
  }

  double get _totalPedido {
    double total = 0;
    _produtos.forEach((produto, qtd) {
      total += produto.preco! * qtd;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    if (_mostrarResumo) {
      return Scaffold(
        backgroundColor: brancoGeloAzulado,
        appBar: AppBar(
          title: const Text('Resumo do pedido'),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: vermelhoEscuro,
          leading: IconButton(
            icon: const Icon(Icons.reply),
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => SelecionarClientePage()),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children:
                      _produtos.entries.map((entry) {
                        final prato = entry.key;
                        final qtd = entry.value;

                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: prato.imagem != null && prato.imagem!.startsWith('http')
                              ? Image.network(
                                prato.imagem!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Icon(Icons.broken_image, size: 35),
                                  );
                                },
                              )
                              : const SizedBox(
                                width: 60,
                                height: 60,
                                child: Icon(Icons.image_not_supported, size: 35),
                              )
                          ),
                          title: Text(prato.nome ?? "Sem nome"),
                          subtitle: Text('Quantidade: $qtd'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => _removerPrato(prato),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => _adicionarPrato(prato),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _produtos.remove(prato);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
              TextField(
                controller: _mesaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número da mesa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Total: R\$ ${_totalPedido.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final pedido = Pedido(cliente: widget.cliente, mesa: int.parse(_mesaController.text), status: "Aberto");
                        _enviarPedido(pedido);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Confirmar Pedido'),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 14),
                        backgroundColor: vermelhoEscuro,
                        minimumSize: const Size(double.infinity, 50),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: _editarPedido,
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar Pedido'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: vermelhoEscuro,
                        minimumSize: const Size(double.infinity, 50),
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: brancoGeloAzulado,
      appBar: AppBar(
        title: const Text('Fazer pedido'),
        centerTitle: true,
        backgroundColor: vermelhoEscuro,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        leading: IconButton(
          icon: const Icon(Icons.reply),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Produto>>(
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
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final prato = produtos[index];
                final selecionado = _produtos.containsKey(prato);
                final quantidade = _produtos[prato] ?? 0;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: prato.imagem != null && prato.imagem!.startsWith('http')
                        ? Image.network(
                          prato.imagem!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              width: 60,
                              height: 60,
                              child: Icon(Icons.broken_image, size: 35),
                            );
                          },
                        )
                        : const SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.image_not_supported, size: 35),
                        )
                    ),
                    title: Text(prato.nome ?? "Sem nome"),
                    subtitle: Text('R\$ ${prato.preco.toString()}'),
                    trailing:
                        selecionado
                            ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => _removerPrato(prato),
                                ),
                                Text(
                                  quantidade.toString(),
                                  style: const TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => _adicionarPrato(prato),
                                ),
                              ],
                            )
                            : ElevatedButton(
                              onPressed: () => _adicionarPrato(prato),
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 14),
                                backgroundColor: vermelhoEscuro,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Adicionar'),
                            ),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _finalizarPedido,
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 14),
            backgroundColor: vermelhoEscuro,
            minimumSize: const Size(double.infinity, 50),
            foregroundColor: Colors.white,
          ),
          child: const Text('Finalizar Pedido'),
        ),
      ),
    );
  }
}
