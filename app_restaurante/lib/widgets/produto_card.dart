import 'package:app_restaurante/screens/editar_produto_page.dart';
import 'package:app_restaurante/services/produto_service.dart';
import 'package:flutter/material.dart';
import '../models/produto.dart';

class ProdutoCard extends StatelessWidget {
  final Produto produto;
  final void Function(String? id, String mensagem)? onDelete;
  final void Function(String? id, String mensagem)? onEdit;

  const ProdutoCard({super.key, required this.produto, this.onDelete, this.onEdit});

  void _editarProduto(BuildContext context, String? id) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditarProdutoPage(id: id!)),
    );

    if (result != null && result is Map<String, dynamic>) {
      final success = result['success'] ?? false;
      final mensagem = result['mensagem'] ?? '';

      if (success && onEdit != null) {
        onEdit!(id, mensagem);
      }
    }
  }

  void _deletarProdutoComConfirmacao(BuildContext context, String? id) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Tem certeza que deseja excluir este produto?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                try {
                  final mensagem = await ProdutoService().deletarProduto(id);
                  onDelete?.call(id, mensagem);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro: $e')),
                  );
                }
              },
              child: const Text(
                'Excluir',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: produto.imagem != null && produto.imagem!.startsWith('http')
            ? Image.network(
              produto.imagem!,
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
        title: Row(
          children: [
            Text(
              produto.nome ?? "Sem nome",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(" - "),
            Text(
              produto.preco != null
                ? 'R\$${produto.preco!.toStringAsFixed(2)}'
                : 'Sem preço',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Text(produto.descricao ?? "Sem descrição"),
        trailing: SizedBox(
          width: 96,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => _editarProduto(context, produto.id),
                icon: const Icon(Icons.edit),
                color: Colors.blue,
              ),
              IconButton(
                onPressed: () => _deletarProdutoComConfirmacao(context, produto.id),
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
