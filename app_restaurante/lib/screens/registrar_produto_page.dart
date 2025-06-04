import 'package:app_restaurante/models/produto.dart';
import 'package:app_restaurante/services/produto_service.dart';
import 'package:flutter/material.dart';

const Color vermelhoEscuro = Color(0xFF770100);
const Color brancoGeloAzulado = Color(0xFFF8FBFF);

class RegistrarProdutoPage extends StatefulWidget {
  const RegistrarProdutoPage({super.key});

  @override
  State<RegistrarProdutoPage> createState() => _RegistrarProdutoPageState();
}

class _RegistrarProdutoPageState extends State<RegistrarProdutoPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _imagemController = TextEditingController();

  @override
  void dispose() {
    // Liberar memória ao sair da tela
    _nomeController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();
    _imagemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brancoGeloAzulado,
      appBar: AppBar(
        title: const Text('Adicionar produto'),
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
              _buildTextField(
                label: 'Nome',
                icon: Icons.shopping_bag,
                controller: _nomeController,
              ),
              _buildTextField(
                label: 'Descrição',
                icon: Icons.description,
                controller: _descricaoController,
              ),
              _buildTextField(
                label: 'Preço',
                icon: Icons.monetization_on,
                keyboardType: TextInputType.number,
                controller: _precoController,
              ),
              _buildTextField(
                label: 'Link da imagem (opcional)',
                icon: Icons.image,
                controller: _imagemController,
                isOptional: true
              ),
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final nome = _nomeController.text.trim();
                      final descricao = _descricaoController.text.trim();
                      final preco = double.tryParse(_precoController.text.trim()) ?? 0.0;
                      final imagem = _imagemController.text.trim();
                      final imagemProduto = imagem != "" ? imagem : null;

                      Produto produto = Produto(
                        nome: nome, 
                        descricao: descricao, 
                        preco: preco, 
                        imagem: imagemProduto
                      );
                      await ProdutoService().criarProduto(produto);
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text('Cadastrar'),
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

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isOptional = false,
  }) {
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
        validator: (value) {
          if (!isOptional && (value == null || value.isEmpty)) {
            return 'Preencha o campo $label';
          }
          return null;
        },
      ),
    );
  }

}
