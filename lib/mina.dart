///Mina é uma classe que possui um ponto de origem no início, meio
/// ou fim (âncora definida por x e y), conteúdo, cor de borda e cor de preenchimento.
class Mina {
  double? x;
  double? y;
  String? conteudo;
  String? corBorda;
  String? corPreenchimento;
  String? posicao;

  Mina(int? id, this.x, this.y, this.conteudo, this.corBorda,
      this.corPreenchimento, this.posicao);
}
