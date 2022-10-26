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

  Texto(int? id, this.x, this.y, this.conteudo, this.corBorda,
      this.corPreenchimento, this.posicao)
      : super(id, -1, 1, 50);

  @override
  double area() {
    return 0.1;
  }

  @override
  double pontos() {
    return 500;
  }

  @override
  double pontosDesativar() {
    return 30;
  }
}
