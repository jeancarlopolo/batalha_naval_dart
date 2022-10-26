import 'barco.dart';

/// Retangulo é uma classe filha de Barco que possui um ponto de origem (âncora definida por x e y),
/// largura, altura, cor de borda e cor de preenchimento.
class Retangulo extends Barco {
  double? x;
  double? y;
  double? largura;
  double? altura;
  String? corBorda;
  String? corPreenchimento;

  Retangulo(int? id, int? idCapitao, int? hp, double? protecao, this.x, this.y,
      this.largura, this.altura, this.corBorda, this.corPreenchimento)
      : super(id, idCapitao, hp, protecao);

  @override
  double area() {
    return largura! * altura!;
  }
}
