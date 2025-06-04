import 'package:app_restaurante/models/pessoa.dart';
import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../services/cliente_service.dart';

const Color vermelhoEscuro = Color(0xFF770100);
const Color brancoGeloAzulado = Color(0xFFF8FBFF);

class RegistrarClientePage extends StatefulWidget {
  final Cliente? cliente;

  const RegistrarClientePage({super.key, this.cliente});

  @override
  State<RegistrarClientePage> createState() => _RegistrarClientePageState();
}

class _RegistrarClientePageState extends State<RegistrarClientePage> {
  final _formKey = GlobalKey<FormState>();
  final _clienteService = ClienteService();
  bool _showPassword = false;

  final TextEditingController _nomeCtrl = TextEditingController();
  final TextEditingController _cpfCtrl = TextEditingController();
  final TextEditingController _telefoneCtrl = TextEditingController();
  final TextEditingController _enderecoCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _senhaCtrl = TextEditingController();

  bool get _isEdicao => widget.cliente != null;

  @override
  void initState() {
    super.initState();
    if (_isEdicao) {
      final p = widget.cliente!.pessoa;
      _nomeCtrl.text = p.nome ?? '';
      _cpfCtrl.text = p.cpf ?? '';
      _telefoneCtrl.text = p.telefone ?? '';
      _enderecoCtrl.text = p.endereco ?? '';
      _emailCtrl.text = p.email ?? '';
      _senhaCtrl.text = p.senha ?? '';
    }
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _cpfCtrl.dispose();
    _telefoneCtrl.dispose();
    _enderecoCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvarCliente() async {
    if (!_formKey.currentState!.validate()) return;

    final pessoa = Pessoa(
      id: _isEdicao ? widget.cliente!.pessoa.id : '',
      nome: _nomeCtrl.text,
      cpf: _cpfCtrl.text,
      telefone: _telefoneCtrl.text,
      endereco: _enderecoCtrl.text,
      email: _emailCtrl.text,
      senha: _senhaCtrl.text,
    );

    try {
      if (_isEdicao) {
        final cliente = Cliente(id: widget.cliente!.id, pessoa: pessoa);
        await _clienteService.editarCliente(cliente);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente atualizado com sucesso!')),
        );
      } else {
        final cliente = Cliente(id: '', pessoa: pessoa);
        await _clienteService.criarCliente(cliente);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente cadastrado com sucesso!')),
        );
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar cliente: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brancoGeloAzulado,
      appBar: AppBar(
        title: Text(_isEdicao ? 'Editar cliente' : 'Adicionar cliente'),
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
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nomeCtrl, 'Nome completo', Icons.person),
              _buildTextField(
                _cpfCtrl,
                'CPF',
                Icons.badge,
                TextInputType.number,
              ),
              _buildTextField(
                _telefoneCtrl,
                'Telefone',
                Icons.phone,
                TextInputType.phone,
              ),
              _buildTextField(_enderecoCtrl, 'Endereço', Icons.location_on),
              _buildTextField(
                _emailCtrl,
                'Email',
                Icons.email,
                TextInputType.emailAddress,
              ),
              _buildPasswordField(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vermelhoEscuro,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: _salvarCliente,
                  child: Text(_isEdicao ? 'Atualizar' : 'Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF770100),
        child: Center(child: Text("Desenvolvido por Adrian e João Vitor", style: TextStyle(color: Colors.white))),
      )
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: keyboardType,
        validator:
            (value) =>
                value == null || value.isEmpty
                    ? 'Preencha o campo $label'
                    : null,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _senhaCtrl,
        obscureText: !_showPassword,
        decoration: InputDecoration(
          labelText: 'Senha',
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator:
            (value) =>
                value == null || value.length < 6
                    ? 'A senha deve ter no mínimo 6 caracteres'
                    : null,
      ),
    );
  }
}