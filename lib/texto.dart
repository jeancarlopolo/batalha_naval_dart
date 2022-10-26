import 'barco.dart';

///TEXTO é uma classe filha de Barco que possui um ponto de origem no início, meio
/// ou fim (âncora definida por x e y), conteúdo, cor de borda e cor de preenchimento.
class Texto extends Barco {
  double? x;
  double? y;
  String? conteudo;
  String? corBorda;
  String? corPreenchimento;
  String? posicao;

  Texto(int? id, int? idCapitao, int? hp, double? protecao, this.x, this.y,
      this.conteudo, this.corBorda, this.corPreenchimento, this.posicao)
      : super(id, idCapitao, hp, protecao);

  @override
  double area() {
    return 0.1;
  }
}