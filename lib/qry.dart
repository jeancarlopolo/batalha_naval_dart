/// Funções que lêem um arquivo QRY e manipulam a lista encadeada

import 'dart:io';
import 'dart:math';
import 'package:batalha_naval/circulo.dart';
import 'package:batalha_naval/lista.dart';
import 'package:batalha_naval/retangulo.dart';
import 'package:batalha_naval/texto.dart';
import 'package:batalha_naval/linha.dart';

///O torpedo é um tipo de ataque que pode ser disparado contra um navio. Ele causa 1 de dano
///e marca o local onde o torpedo foi disparado com um asterisco vermelho caso tenha atingido
///um navio ou um asterisco cinza caso tenha atingido o mar. Retorna a pontuação recebida.
double ataqueTorpedo(
    ListaLigada lista, double x, double y, File txt, File svg) {
  var pontuacao = 0.0;
  var barcosAtingidos = 0;
  var navio = lista.inicio;
  while (navio != null) {
    if (navio.item is Circulo) {
      var circulo = navio.item as Circulo;
      var distancia = sqrt(pow(circulo.x! - x, 2) + pow(circulo.y! - y, 2));
      if (distancia <= circulo.raio!) {
        barcosAtingidos++;
        pontuacao += circulo.pontos();
        if (circulo.causarDano(1)) {
          txt.writeAsStringSync(
              'O torpedo atingiu o círculo ${circulo.id} e o destruiu.\nDados do círculo: x=${circulo.x}\ny=${circulo.y}\nr=${circulo.raio}\ncor de preenchimento=${circulo.corPreenchimento}\ncor da borda=${circulo.corBorda}\n\n',
              mode: FileMode.append);
          lista.remove(circulo);
        } else {
          txt.writeAsStringSync(
              'O torpedo atingiu o círculo ${circulo.id} e causou 1 de dano nele\nDados do círculo: x=${circulo.x}\ny=${circulo.y}\nr=${circulo.raio}\ncor de preenchimento=${circulo.corPreenchimento}\ncor da borda=${circulo.corBorda}\nHP restante=${circulo.hp}\n\n',
              mode: FileMode.append);
        }
        break;
      }
    } else if (navio.item is Retangulo) {
      var retangulo = navio.item as Retangulo;
      if (x >= retangulo.x! &&
          x <= retangulo.x! + retangulo.largura! &&
          y >= retangulo.y! &&
          y <= retangulo.y! + retangulo.altura!) {
        barcosAtingidos++;
        pontuacao += retangulo.pontos();
        if (retangulo.causarDano(1)) {
          txt.writeAsStringSync(
              'O torpedo atingiu o retângulo ${retangulo.id} e o destruiu.\nDados do retângulo: x=${retangulo.x}\ny=${retangulo.y}\nlargura=${retangulo.largura}\naltura=${retangulo.altura}\ncor de preenchimento=${retangulo.corPreenchimento}\ncor da borda=${retangulo.corBorda}\n\n',
              mode: FileMode.append);
          lista.remove(retangulo);
        } else {
          txt.writeAsStringSync(
              'O torpedo atingiu o retângulo ${retangulo.id} e causou 1 de dano nele\nDados do retângulo: x=${retangulo.x}\ny=${retangulo.y}\nlargura=${retangulo.largura}\naltura=${retangulo.altura}\ncor de preenchimento=${retangulo.corPreenchimento}\ncor da borda=${retangulo.corBorda}\nHP restante=${retangulo.hp}\n\n',
              mode: FileMode.append);
        }
        break;
      }
    } else if (navio.item is Linha) {
      var linha = navio.item as Linha;
      if (((x <= linha.x! && x >= linha.x2!) ||
              (x >= linha.x! && x <= linha.x2!)) &&
          ((y >= linha.y! && y <= linha.y2!) ||
              (y <= linha.y! && y >= linha.y2!))) {
        barcosAtingidos++;
        pontuacao += linha.pontos();
        if (linha.causarDano(1)) {
          txt.writeAsStringSync(
              'O torpedo atingiu a linha ${linha.id} e a destruiu.\nDados da linha: x=${linha.x}\ny=${linha.y}\nx2=${linha.x2}\ny2=${linha.y2}\ncor da linha=${linha.cor}\n\n',
              mode: FileMode.append);
          lista.remove(linha);
        } else {
          txt.writeAsStringSync(
              'O torpedo atingiu a linha ${linha.id} e causou 1 de dano nela\nDados da linha: x=${linha.x}\ny=${linha.y}\nx2=${linha.x2}\ny2=${linha.y2}\ncor da linha=${linha.cor}\nHP restante=${linha.hp}\n\n',
              mode: FileMode.append);
        }
        break;
      }
    } else if (navio.item is Texto) {
      var texto = navio.item as Texto;
      if (x == texto.x! && y == texto.y!) {
        barcosAtingidos++;
        pontuacao += texto.pontos();
        if (texto.causarDano(1)) {
          txt.writeAsStringSync(
              'O torpedo atingiu o texto ${texto.id} e o destruiu.\nDados do texto: x=${texto.x}\ny=${texto.y}\ntexto=${texto.conteudo}\ncor da borda=${texto.corBorda}\ncor do preenchimento=${texto.corPreenchimento}\n\n',
              mode: FileMode.append);
          lista.remove(texto);
        } else {
          txt.writeAsStringSync(
              'O torpedo atingiu o texto ${texto.id} e causou 1 de dano nele\nDados do texto: x=${texto.x}\ny=${texto.y}\ntexto=${texto.conteudo}\ncor da borda=${texto.corBorda}\ncor do preenchimento=${texto.corPreenchimento}\nHP restante=${texto.hp}\n\n',
              mode: FileMode.append);
        }
        break;
      }
    }
    navio = navio.next;
  }
  if (barcosAtingidos == 0) {
    svg.writeAsStringSync(
        '<text x="$x" y="$y" fill="gray" stroke="gray" text-anchor="middle">*</text>\r',
        mode: FileMode.append);
    txt.writeAsStringSync('ÁGUA! Nenhum barco foi atingido.\n\n',
        mode: FileMode.append);
  } else {
    svg.writeAsStringSync(
        '<text x="$x" y="$y" fill="red" stroke="red" text-anchor="middle">*</text>\r',
        mode: FileMode.append);
    svg.writeAsStringSync(
        '<text x="${x + 10}" y="${y + 10}" fill="red" stroke="red" text-anchor="middle">$barcosAtingidos</text>\r',
        mode: FileMode.append);
  }
  return pontuacao;
}

///Dispara um torpedo replicante nas coordenadas x e y que replica barcos atingidos
void ataqueTorpedoReplicante(ListaLigada lista, double x, double y, double dx,
    double dy, int id, File svg, File txt) {
  var contador = 0;
  var navio = lista.inicio;
  while (navio != null) {
    if (navio.item is Circulo) {
      var circulo = navio.item as Circulo;
      if (x >= circulo.x! - circulo.raio! &&
          x <= circulo.x! + circulo.raio! &&
          y >= circulo.y! - circulo.raio! &&
          y <= circulo.y! + circulo.raio!) {
        contador++;
        var circuloClone = Circulo(
          id + contador,
          circulo.x! + dx,
          circulo.y! + dy,
          circulo.raio,
          circulo.corPreenchimento,
          circulo.corBorda,
        );
        lista.insert(circuloClone);
        circuloClone.hp = circulo.hp;
        txt.writeAsStringSync(
            'O torpedo replicante atingiu o círculo ${circulo.id} e o replicou.\nDados do círculo: x=${circulo.x}\ny=${circulo.y}\nraio=${circulo.raio}\ncor de preenchimento=${circulo.corPreenchimento}\ncor da borda=${circulo.corBorda}\nHP=${circulo.hp}\n\n',
            mode: FileMode.append);
      } else if (navio.item is Retangulo) {
        var retangulo = navio.item as Retangulo;
        if (x >= retangulo.x! &&
            x <= retangulo.x! + retangulo.largura! &&
            y >= retangulo.y! &&
            y <= retangulo.y! + retangulo.altura!) {
          contador++;
          var retanguloClone = Retangulo(
            id + contador,
            retangulo.x! + dx,
            retangulo.y! + dy,
            retangulo.largura,
            retangulo.altura,
            retangulo.corPreenchimento,
            retangulo.corBorda,
          );
          lista.insert(retanguloClone);
          retanguloClone.hp = retangulo.hp;
          txt.writeAsStringSync(
              'O torpedo replicante atingiu o retângulo ${retangulo.id} e o replicou.\nDados do retângulo: x=${retangulo.x}\ny=${retangulo.y}\nlargura=${retangulo.largura}\naltura=${retangulo.altura}\ncor de preenchimento=${retangulo.corPreenchimento}\ncor da borda=${retangulo.corBorda}\nHP=${retangulo.hp}\n\n',
              mode: FileMode.append);
        }
      } else if (navio.item is Linha) {
        var linha = navio.item as Linha;
        if (((x <= linha.x! && x >= linha.x2!) ||
                (x >= linha.x! && x <= linha.x2!)) &&
            ((y >= linha.y! && y <= linha.y2!) ||
                (y <= linha.y! && y >= linha.y2!))) {
          contador++;
          var linhaClone = Linha(
            id + contador,
            linha.x! + dx,
            linha.y! + dy,
            linha.x2,
            linha.y2,
            linha.cor,
          );
          lista.insert(linhaClone);
          linhaClone.hp = linha.hp;
          txt.writeAsStringSync(
              'O torpedo replicante atingiu a linha ${linha.id} e a replicou.\nDados da linha: x=${linha.x}\ny=${linha.y}\nx2=${linha.x2}\ny2=${linha.y2}\ncor=${linha.cor}\nHP=${linha.hp}\n\n',
              mode: FileMode.append);
        }
      } else if (navio.item is Texto) {
        var texto = navio.item as Texto;
        if (x >= texto.x! &&
            x <= texto.x! + texto.conteudo!.length * 10 &&
            y >= texto.y! - 10 &&
            y <= texto.y!) {
          contador++;
          var textoClone = Texto(
            id + contador,
            texto.x! + dx,
            texto.y! + dy,
            texto.conteudo,
            texto.corPreenchimento,
            texto.corBorda,
            texto.posicao,
          );
          lista.insert(textoClone);
          textoClone.hp = texto.hp;
          txt.writeAsStringSync(
              'O torpedo replicante atingiu o texto ${texto.id} e o replicou.\nDados do texto: x=${texto.x}\ny=${texto.y}\ntexto=${texto.conteudo}\ncor da borda=${texto.corBorda}\ncor do preenchimento=${texto.corPreenchimento}\nHP=${texto.hp}\n\n',
              mode: FileMode.append);
        }
      }
      navio = navio.next;
    }
    svg.writeAsStringSync(
        '<text x="$x" y="$y" fill="red" stroke="red" text-anchor="middle">@</text>\r',
        mode: FileMode.append);
  }

  /// Lê um arquivo QRY e manipula a lista encadeada
  // File lerArquivoQry(String qry, ListaLigada lista) {
  //   var arquivo = File(qry);
  //   var linhas = arquivo.readAsLinesSync();
  //   for (var linha in linhas) {
  //     var comando = linha.split(' ');
  //     switch (comando[0]) {
  //     }
  //   }
  //   return arquivo;
  // }
}
