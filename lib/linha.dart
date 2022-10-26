import 'barco.dart';

///linha é uma classe filha de Barco que possui dois pontos de origem (âncora definida por x e y) e cor.
class Linha extends Barco {
  double? x;
  double? y;
  double? x2;
  double? y2;
  String? cor;

  Linha(int? id, this.x, this.y, this.x2, this.y2, this.cor) : super(id, -1, 1, 50);

  double get _comprimento {
    return (x2! - x!).abs() + (y2! - y!).abs();
  }

  @override
  double area() {
    return _comprimento;
  }

  @override
  double pontos() {
    return 50;
  }

  @override
  double pontosDesativar() {
    return 50;
  }
}
