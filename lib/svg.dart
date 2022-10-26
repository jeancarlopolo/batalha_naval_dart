///Conjunto de funções para desenhar um SVG.

import 'dart:io';

import 'circulo.dart';
import 'linha.dart';
import 'lista.dart';
import 'retangulo.dart';
import 'texto.dart';


///Cria um SVG
File criaSvg(String nome, {String path = ''}) {
  final file = File('$path/$nome');
  file.writeAsStringSync(
      '<svg xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" version="1.1">\n\r');
  return file;
}

///Cria um retângulo
void desenharRetangulo(Retangulo retangulo, File file) {
  file.writeAsStringSync(
      '<rect x="${retangulo.x}" y="${retangulo.y}" width="${retangulo.largura}" height="${retangulo.altura}" fill="${retangulo.corPreenchimento}" stroke="${retangulo.corBorda}" />\r',
      mode: FileMode.append);
}

///Cria um círculo
void desenharCirculo(Circulo circulo, File file) {
  file.writeAsStringSync(
      '<circle cx="${circulo.x}" cy="${circulo.y}" r="${circulo.raio}" fill="${circulo.corPreenchimento}" stroke="${circulo.corBorda}" />\r',
      mode: FileMode.append);
}

///Cria uma linha
void desenharLinha(Linha linha, File file) {
  file.writeAsStringSync(
      '<line x1="${linha.x}" y1="${linha.y}" x2="${linha.x2}" y2="${linha.y2}" stroke="${linha.cor}" />\r',
      mode: FileMode.append);
}

///Cria um texto
void desenharTexto(Texto texto, File file) {
  file.writeAsStringSync(
      '<text x="${texto.x}" y="${texto.y}" fill="${texto.corPreenchimento}" stroke="${texto.corBorda}" text-anchor="${texto.posicao}">${texto.conteudo}</text>\r',
      mode: FileMode.append);
}

///Finaliza o SVG
void finalizaSvg(File file) {
  file.writeAsStringSync('</svg>\r', mode: FileMode.append);
}

///Recebe uma lista encadeada de elementos e os desenha no SVG
void desenhar(ListaLigada lista, File file) {
  Elemento? elemento = lista.inicio;
  while (elemento != null) {
    if (elemento.item is Circulo) {
      desenharCirculo(elemento.item, file);
    } else if (elemento.item is Retangulo) {
      desenharRetangulo(elemento.item, file);
    } else if (elemento.item is Linha) {
      desenharLinha(elemento.item, file);
    } else if (elemento.item is Texto) {
      desenharTexto(elemento.item, file);
    }
    elemento = elemento.next;
  }
}
