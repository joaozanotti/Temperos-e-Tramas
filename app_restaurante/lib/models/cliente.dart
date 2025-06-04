import 'pessoa.dart';

class Cliente {
  final String id;
  final Pessoa pessoa;

  Cliente({
    required this.id,
    required this.pessoa,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id_clie'],
      pessoa: Pessoa.fromJson(json['pessoa']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_clie': id,
      'pessoa': pessoa.toJson(),
    };
  }
}