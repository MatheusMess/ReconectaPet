class Animal {
  final String nome;
  final String descricao;
  final String raca;
  final String cor;
  final String especie;
  final String sexo;
  final String imagem;
  final String ultimoLocal;
  final String cidade;
  final String bairro;
  final String endereco;
  final String dataDesaparecimento;

  Animal({
    required this.nome,
    required this.descricao,
    required this.raca,
    required this.cor,
    required this.especie,
    required this.sexo,
    required this.imagem,
    required this.ultimoLocal,
    required this.cidade,
    required this.bairro,
    required this.endereco,
    required this.dataDesaparecimento,
  });

  // Lista de exemplo
  static List<Animal> exemplos = [
    Animal(
      nome: "Rex",
      descricao: "Cachorro perdido no bairro Centro",
      raca: "Vira-lata",
      cor: "Marrom",
      especie: "Cachorro",
      sexo: "Macho",
      imagem: "assets/cachorro3.jpg",
      ultimoLocal: "Centro",
      cidade: "São Paulo",
      bairro: "Centro",
      endereco: "Rua Principal, 123",
      dataDesaparecimento: "10/08/2025",
    ),
    Animal(
      nome: "Mimi",
      descricao: "Cachorro visto pela última vez na Rua A",
      raca: "Salsicha",
      cor: "Branco",
      especie: "Cachorro",
      sexo: "Fêmea",
      imagem: "assets/cachorro4.jpg",
      ultimoLocal: "Rua A",
      cidade: "São Paulo",
      bairro: "Jardim das Flores",
      endereco: "Rua A, 45",
      dataDesaparecimento: "12/08/2025",
    ),
  ];
}
