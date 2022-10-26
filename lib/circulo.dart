import 'package:batalha_naval/barco.dart';

/// Circulo é uma classe filha de Barco que possui um ponto de origem (âncora definida por x e y),
/// raio, cor de borda e cor de preenchimento.
class Circulo extends Barco {
  double? x;
  double? y;
  double? raio;
  String? corBorda;
  String? corPreenchimento;

  Circulo(int? id, this.x, this.y,
      this.raio, this.corBorda, this.corPreenchimento)
      : super(id, -1, 2, 60);

  @override
  double area() {
    return 3.14 * raio! * raio!;
  }

  @override
  double pontos() {
    return 75 / (area() / 5);
  }

  @override
  double pontosDesativar() {
    return 75;
  }
}
