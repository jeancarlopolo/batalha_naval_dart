///Conjunto de funções que realizam a leitura de um arquivo GEO e inserem os elementos em uma lista encadeada.

import 'dart:io';

import 'circulo.dart';
import 'linha.dart';
import 'lista.dart';
import 'retangulo.dart';
import 'texto.dart';

///Lê um arquivo GEO e retorna uma lista encadeada com os elementos
ListaLigada lerArquivoGeo(String nome) {
  final file = File(nome);
  final lista = ListaLigada();
  final lines = file.readAsLinesSync();
  for (var line in lines) {
    final split = line.split(' ');
    switch (split[0]) {
      case 'c':
        lista.insert(Circulo(
            int.parse(split[1]),
            double.parse(split[2]),
            double.parse(split[3]),
            double.parse(split[4]),
            split[5],
            split[6]));
        break;
      case 'r':
        lista.insert(Retangulo(
            int.parse(split[1]),
            double.parse(split[2]),
            double.parse(split[3]),
            double.parse(split[4]),
            double.parse(split[5]),
            split[6],
            split[7]));
        break;
      case 't':
        var posic = 'middle';
        switch (split[7]) {
          case 'i':
            posic = 'start';
            break;
          case 'f':
            posic = 'end';
            break;
        }
        lista.insert(Texto(
          int.parse(split[1]),
          double.parse(split[2]),
          double.parse(split[3]),
          split[4],
          split[5],
          split[6],
          posic,
        ));
        break;
      case 'l':
        lista.insert(Linha(
            int.parse(split[1]),
            double.parse(split[2]),
            double.parse(split[3]),
            double.parse(split[4]),
            double.parse(split[5]),
            split[6]));
        break;
    }
  }
  return lista;
}
