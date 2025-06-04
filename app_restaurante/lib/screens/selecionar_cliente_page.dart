import 'package:app_restaurante/screens/registrar_pedido_page.dart';
import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../services/cliente_service.dart';

class SelecionarClientePage extends StatefulWidget {
  const SelecionarClientePage({super.key});

  @override
  State<SelecionarClientePage> createState() => _SelecionarClientePageState();
}

class _SelecionarClientePageState extends State<SelecionarClientePage> {
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

  void _selecionarCliente(Cliente cliente) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RegistrarPedidoPage(cliente: cliente)),
    );
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
        title: const Text('Selecionar cliente'),
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
                ? const CircularProgressIndicator()
                : Expanded(
                  child:
                      _clientesFiltrados.isEmpty
                          ? const Center(
                            child: Text('Nenhum cliente encontrado'),
                          )
                          : ListView.builder(
                            itemCount: _clientesFiltrados.length,
                            itemBuilder: (context, index) {
                              final cliente = _clientesFiltrados[index];
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text(
                                    cliente.pessoa.nome ?? 'Nome não informado',
                                  ),
                                  subtitle: Text(
                                    'CPF: ${cliente.pessoa.cpf ?? 'Não informado'}',
                                  ),
                                  trailing: ElevatedButton.icon(
                                    icon: const Icon(Icons.check),
                                    label: const Text('Selecionar'),
                                    onPressed:
                                        () => _selecionarCliente(cliente),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF770100),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
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