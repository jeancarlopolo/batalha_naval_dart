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

  Retangulo(int? id, this.x, this.y, this.largura, this.altura, this.corBorda,
      this.corPreenchimento)
      : super(id, -1, 3, 60);

  @override
  double area() {
    return largura! * altura!;
  }

  @override
  double pontos() {
    return 90 / (area() / 5);
  }

  @override
  double pontosDesativar() {
    return 90;
  }
}
