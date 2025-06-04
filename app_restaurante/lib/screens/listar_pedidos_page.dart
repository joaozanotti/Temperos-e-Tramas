import 'package:flutter/material.dart';
import 'package:app_restaurante/models/pedido.dart';
import 'package:app_restaurante/services/pedido_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

const Color vermelhoEscuro = Color(0xFF770100);
const Color brancoGeloAzulado = Color(0xFFF8FBFF);

class ListarPedidosPage extends StatefulWidget {
  const ListarPedidosPage({super.key});

  @override
  State<ListarPedidosPage> createState() => _ListarPedidosPageState();
}

class _ListarPedidosPageState extends State<ListarPedidosPage> {
  late Future<List<Pedido>> _pedidosFuture;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    initializeDateFormatting('pt_BR', null);
    super.initState();
    _carregarPedidos();
  }

  void _carregarPedidos() {
    _pedidosFuture = PedidoService().listarPedidosComItens();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brancoGeloAzulado,
      appBar: AppBar(
        title: const Text('Lista de pedidos'),
        centerTitle: true,
        backgroundColor: vermelhoEscuro,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        leading: IconButton(
          icon: const Icon(Icons.reply),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Pedido>>(
        future: _pedidosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum pedido encontrado'));
          }

          final pedidos = snapshot.data!;

          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];

              DateTime dataHora = pedido.dataHora!.toLocal();
              String dataFormatada = DateFormat('dd/MM', 'pt_BR').format(dataHora);
              String horaFormatada = DateFormat('HH:mm', 'pt_BR').format(dataHora);

              return Card(
                margin: EdgeInsets.all(8),
                child: ExpansionTile(
                  leading: Icon(Icons.list, size: 30),
                  title: Text('Pedido de $dataFormatada - $horaFormatada | Mesa ${pedido.mesa}'),
                  subtitle: Text(
                    'Cliente: ${pedido.cliente.pessoa.nome}\nStatus: ${pedido.status}',
                  ),
                  children:
                    pedido.itens.map<Widget>((ItemPedido item) {
                      return ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Produto:', style: TextStyle(fontSize: 15)),
                            const SizedBox(width: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: item.produto.imagem != null && item.produto.imagem!.startsWith('http')
                                ? Image.network(
                                  item.produto.imagem!,
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: Icon(Icons.broken_image, size: 30),
                                    );
                                  },
                                )
                                : const SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Icon(Icons.image_not_supported, size: 30),
                                )
                            ),
                          ],
                        ),
                        title: Text('${item.produto.nome}', style: TextStyle(fontSize: 14)),
                        trailing: Text('Qtd: ${item.quantidade}', style: TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF770100),
        child: Center(child: Text("Desenvolvido por Adrian e João Vitor", style: TextStyle(color: Colors.white))),
      )
    );
  }
}
