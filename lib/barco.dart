/// Um barco é uma classe que contém um id, um id de capitão, hp e proteção. Ele pode ser destruído de três maneiras:
///1. Seu hp chegar a 0 ao ser bombardeado
///2. Seu nível de proteção chegar a 0 ao ser atingido por uma bomba de radiação
///3. Ao passar por uma mina
abstract class Barco {
  int? id;
  int? idCapitao;
  int? hp;
  double? protecao;

  Barco(this.id, this.idCapitao, this.hp, this.protecao);

  /// Causa dano ao barco. Retorna true se o barco foi destruído e false caso contrário.
  bool causarDano(int dano) {
    hp = hp! - dano;
    return hp! <= 0;
  }

  /// Causa dano à proteção do barco
  void reduzirProt(int dano) {
    protecao = protecao! - dano;
  }

  /// Retorna a área do barco
  double area();

  /// Retorna a quantidade de pontos recebidos ao destruir o barco
  double pontos();

  /// Retorna a quantidade de pontos recebidos ao desativar o barco
  double pontosDesativar();
}
