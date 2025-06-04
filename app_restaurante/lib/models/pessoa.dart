class Pessoa {
  final String id;
  final String? nome;
  final String? cpf;
  final String? telefone;
  final String? endereco;
  final String? email;
  final String? senha;

  Pessoa({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.endereco,
    required this.email,
    required this.senha,
  });

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      id: json['id_pess'],
      nome: json['nome'],
      cpf: json['CPF'],
      telefone: json['telefone'],
      endereco: json['endereco'],
      email: json['email'],
      senha: json['senha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pess': id,
      'nome': nome,
      'CPF': cpf,
      'telefone': telefone,
      'endereco': endereco,
      'email': email,
      'senha': senha,
    };
  }
}

