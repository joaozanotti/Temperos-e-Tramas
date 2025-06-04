import 'package:app_restaurante/screens/registrar_cliente_page.dart';
import 'package:flutter/material.dart';
import '../services/cliente_service.dart';
import '../models/cliente.dart';

const Color vermelhoEscuro = Color(0xFF770100);
const Color brancoGeloAzulado = Color(0xFFF8FBFF);

class ListarClientesPage extends StatefulWidget {
  const ListarClientesPage({super.key});

  @override
  State<ListarClientesPage> createState() => _ListarClientesPageState();
}

class _ListarClientesPageState extends State<ListarClientesPage> {
  final TextEditingController _filtroCtrl = TextEditingController();
  final ClienteService _service = ClienteService();

  List<Cliente> _todosClientes = [];
  List<Cliente> _clientesFiltrados = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _carregarClientes();
    _filtroCtrl.addListener(_filtrarClientes);
  }

  Future<void> _carregarClientes() async {
    setState(() => _loading = true);
    try {
      final clientes = await _service.listarClientes();
      setState(() {
        _todosClientes = clientes;
        _clientesFiltrados = clientes;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar clientes'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filtrarClientes() {
    final termo = _filtroCtrl.text.toLowerCase();
    setState(() {
      _clientesFiltrados =
          _todosClientes.where((cliente) {
            final cpf = cliente.pessoa.cpf?.toLowerCase() ?? '';
            final nome = cliente.pessoa.nome?.toLowerCase() ?? '';
            return cpf.contains(termo) || nome.contains(termo);
          }).toList();
    });
  }

  void _editarCliente(Cliente cliente) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RegistrarClientePage(cliente: cliente)),
    );

    if (result == true) {
      setState(() {
        _carregarClientes();
      });
    }
  }

  Future<void> _excluirCliente(Cliente cliente) async {
    bool confirmou =
        await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Confirmar exclusão'),
                content: Text(
                  'Deseja realmente excluir o cliente ${cliente.pessoa.nome}?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Excluir', style: TextStyle(color: Colors.red),),
                  ),
                ],
              ),
        ) ??
        false;

    if (!confirmou) return;

    setState(() => _loading = true);

    try {
      await _service.deletarCliente(
        cliente,
      ); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cliente ${cliente.pessoa.nome} excluído com sucesso!'),
        ),
      );
      await _carregarClientes();
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir cliente: $e')));
    }
  }

  @override
  void dispose() {
    _filtroCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brancoGeloAzulado,
      appBar: AppBar(
        title: const Text('Lista de clientes'), 
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
        child: Column(
          children: [
            TextField(
              controller: _filtroCtrl,
              decoration: const InputDecoration(
                labelText: 'Filtrar por nome ou CPF',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 12),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                  child:
                      _clientesFiltrados.isEmpty
                          ? const Center(
                            child: Text('Nenhum cliente encontrado.'),
                          )
                          : ListView.builder(
                            itemCount: _clientesFiltrados.length,
                            itemBuilder: (context, index) {
                              final cliente = _clientesFiltrados[index];
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text(
                                    cliente.pessoa.nome ?? 'Sem nome',
                                  ),
                                  subtitle: Text(
                                    'CPF: ${cliente.pessoa.cpf ?? 'Sem CPF'}',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed:
                                            () => _editarCliente(cliente),
                                        tooltip: 'Editar',
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed:
                                            () => _excluirCliente(cliente),
                                        tooltip: 'Excluir',
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.pushNamed(
            context,
            '/cadastroCliente',
          );
          if (resultado == true) {
            _carregarClientes();
          }
        },
        backgroundColor: vermelhoEscuro,
        tooltip: 'Cadastrar novo cliente',
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF770100),
        child: Center(child: Text("Desenvolvido por Adrian e João Vitor", style: TextStyle(color: Colors.white))),
      )
    );
  }
}
