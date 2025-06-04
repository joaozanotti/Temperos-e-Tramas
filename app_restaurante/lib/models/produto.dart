class Produto {
  final String? id;
  final String? nome;
  final String? descricao;
  final double? preco;
  final String? imagem;

  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagem,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id_prod'],
      nome: json['nome'],
      descricao: json['descricao'],
      preco: double.tryParse(json['preco'].toString()),
      imagem: json['imagem'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_prod': id,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'imagem': imagem
    };
  }
}