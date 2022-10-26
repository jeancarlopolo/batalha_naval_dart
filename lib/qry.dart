/// Funções que lêem um arquivo QRY e manipulam a lista encadeada

import 'dart:io';
import 'dart:math';
import 'package:batalha_naval/circulo.dart';
import 'package:batalha_naval/lista.dart';
import 'package:batalha_naval/retangulo.dart';
import 'package:batalha_naval/texto.dart';
import 'package:batalha_naval/linha.dart';

import 'barco.dart';
import 'mina.dart';

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
        '<text x="$x" y="$y" fill="gray" stroke="gray" text-anchor="middle">*</text>\n',
        mode: FileMode.append);
    txt.writeAsStringSync('ÁGUA! Nenhum barco foi atingido.\n\n',
        mode: FileMode.append);
  } else {
    svg.writeAsStringSync(
        '<text x="$x" y="$y" fill="red" stroke="red" text-anchor="middle">*</text>\n',
        mode: FileMode.append);
    svg.writeAsStringSync(
        '<text x="${x + 10}" y="${y + 10}" fill="red" stroke="red" text-anchor="middle">$barcosAtingidos</text>\n',
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
      }
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
      '<text x="$x" y="$y" fill="red" stroke="red" text-anchor="middle">@</text>\n',
      mode: FileMode.append);
}

///Bomba de radiação atinge o local especificado. Retorna a pontuação recebida
double bombaRadiacao(ListaLigada lista, double x, double y, double r, double na,
    File svg, File txt) {
  var pontos = 0.0;
  var navio = lista.inicio;

  double calculoReducao(double area, double raio, double nivel) {
    double reducao = 0.0;
    raio = raio * raio * pi;
    reducao = (area * nivel) / raio;
    return reducao;
  }

  var na = 1.0;
  while (navio != null) {
    if (navio.item is Circulo) {
      var circulo = navio.item as Circulo;
      if (sqrt(((x - circulo.x!) * (x - circulo.x!)) +
                  ((y - circulo.y!) * (y - circulo.y!))) +
              circulo.raio! <=
          r) {
        circulo.protecao =
            circulo.protecao! - calculoReducao(circulo.area(), r, na);
        svg.writeAsStringSync(
            '<circle cx="${circulo.x}" cy="${circulo.y}" r="2" fill="red" stroke="red" stroke-width="1" />\n',
            mode: FileMode.append);
        if (circulo.protecao! <= 0) {
          pontos += circulo.pontosDesativar();
          txt.writeAsStringSync(
              'A bomba de radiação atingiu o círculo ${circulo.id} e o desativou.\nDados do círculo: x=${circulo.x}\ny=${circulo.y}\nraio=${circulo.raio}\ncor de preenchimento=${circulo.corPreenchimento}\ncor da borda=${circulo.corBorda}\nHP=${circulo.hp}\nNível de Proteção=${circulo.protecao}\n\n',
              mode: FileMode.append);
          lista.remove(circulo);
        } else {
          txt.writeAsStringSync(
              'A bomba de radiação atingiu o círculo ${circulo.id}.\nDados do círculo: x=${circulo.x}\ny=${circulo.y}\nraio=${circulo.raio}\ncor de preenchimento=${circulo.corPreenchimento}\ncor da borda=${circulo.corBorda}\nHP=${circulo.hp}\nNível de Proteção=${circulo.protecao}\n\n',
              mode: FileMode.append);
        }
      }
    } else if (navio.item is Retangulo) {
      var retangulo = navio.item as Retangulo;
      if (x + r >= retangulo.x! &&
          x - r <= retangulo.x! + retangulo.largura! &&
          y + r >= retangulo.y! &&
          y - r <= retangulo.y! + retangulo.altura!) {
        if (sqrt(pow(x - retangulo.x!, 2) + pow(y - retangulo.y!, 2)) < r &&
            sqrt(pow(x - retangulo.x! - retangulo.largura!, 2) +
                    pow(y - retangulo.y!, 2)) <
                r &&
            sqrt(pow(x - retangulo.x!, 2) +
                    pow(y - retangulo.y! - retangulo.altura!, 2)) <
                r &&
            sqrt(pow(x - retangulo.x! - retangulo.largura!, 2) +
                    pow(y - retangulo.y! - retangulo.altura!, 2)) <
                r) {
          retangulo.protecao =
              retangulo.protecao! - calculoReducao(retangulo.area(), r, na);
          svg.writeAsStringSync(
              '<circle cx="${retangulo.x}" cy="${retangulo.y}" r="2" fill="red" stroke="red" stroke-width="1" />\n',
              mode: FileMode.append);
          if (retangulo.protecao! <= 0) {
            pontos += retangulo.pontosDesativar();
            txt.writeAsStringSync(
                'A bomba de radiação atingiu o retângulo ${retangulo.id} e o desativou.\nDados do retângulo: x=${retangulo.x}\ny=${retangulo.y}\nlargura=${retangulo.largura}\naltura=${retangulo.altura}\ncor de preenchimento=${retangulo.corPreenchimento}\ncor da borda=${retangulo.corBorda}\nHP=${retangulo.hp}\nNível de Proteção=${retangulo.protecao}\n\n',
                mode: FileMode.append);
            lista.remove(retangulo);
          } else {
            txt.writeAsStringSync(
                'A bomba de radiação atingiu o retângulo ${retangulo.id}.\nDados do retângulo: x=${retangulo.x}\ny=${retangulo.y}\nlargura=${retangulo.largura}\naltura=${retangulo.altura}\ncor de preenchimento=${retangulo.corPreenchimento}\ncor da borda=${retangulo.corBorda}\nHP=${retangulo.hp}\nNível de Proteção=${retangulo.protecao}\n\n',
                mode: FileMode.append);
          }
        }
      }
    } else if (navio.item is Linha) {
      var linha = navio.item as Linha;
      if (sqrt(pow(linha.x! - x, 2) + pow(linha.y! - y, 2)) < r &&
          sqrt(pow(linha.x2! - x, 2) + pow(linha.y2! - y, 2)) < r) {
        linha.protecao = linha.protecao! - calculoReducao(linha.area(), r, na);
        svg.writeAsStringSync(
            '<circle cx="${linha.x}" cy="${linha.y}" r="2" fill="red" stroke="red" stroke-width="1" />\n',
            mode: FileMode.append);
        if (linha.protecao! <= 0) {
          pontos += linha.pontosDesativar();
          txt.writeAsStringSync(
              'A bomba de radiação atingiu a linha ${linha.id} e a desativou.\nDados da linha: x1=${linha.x}\ny1=${linha.y}\nx2=${linha.x2}\ny2=${linha.y2}\ncor da linha=${linha.cor}\nHP=${linha.hp}\nNível de Proteção=${linha.protecao}\n\n',
              mode: FileMode.append);
          lista.remove(linha);
        } else {
          txt.writeAsStringSync(
              'A bomba de radiação atingiu a linha ${linha.id}.\nDados da linha: x1=${linha.x}\ny1=${linha.y}\nx2=${linha.x2}\ny2=${linha.y2}\ncor da linha=${linha.cor}\nHP=${linha.hp}\nNível de Proteção=${linha.protecao}\n\n',
              mode: FileMode.append);
        }
      }
    } else if (navio.item is Texto) {
      var texto = navio.item as Texto;
      if (sqrt(pow(texto.x! - x, 2) + pow(texto.y! - y, 2)) < r) {
        texto.protecao = texto.protecao! - calculoReducao(texto.area(), r, na);
        svg.writeAsStringSync(
            '<circle cx="${texto.x}" cy="${texto.y}" r="2" fill="red" stroke="red" stroke-width="1" />\n',
            mode: FileMode.append);
        if (texto.protecao! <= 0) {
          pontos += texto.pontosDesativar();
          txt.writeAsStringSync(
              'A bomba de radiação atingiu o texto ${texto.id} e o desativou.\nDados do texto: x=${texto.x}\ny=${texto.y}\ntexto=${texto.conteudo}\ncor de preenchimento=${texto.corPreenchimento}\ncor de borda=${texto.corBorda}\nHP=${texto.hp}\nNível de Proteção=${texto.protecao}\n\n',
              mode: FileMode.append);
          lista.remove(texto);
        } else {
          txt.writeAsStringSync(
              'A bomba de radiação atingiu o texto ${texto.id}.\nDados do texto: x=${texto.x}\ny=${texto.y}\ntexto=${texto.conteudo}\ncor de preenchimento=${texto.corPreenchimento}\ncor de borda=${texto.corBorda}\nHP=${texto.hp}\nNível de Proteção=${texto.protecao}\n\n',
              mode: FileMode.append);
        }
      }
    }
    navio = navio.next;
  }
  //círculo vermelho pontilhado no centro da bomba sem preenchimento
  svg.writeAsStringSync(
      '<circle cx="$x" cy="$y" r="$r" fill="none" stroke="red" stroke-width="1" stroke-dasharray="2,2" />\n',
      mode: FileMode.append);
  return pontos;
}

/// Verifica se há uma mina entre o barco e seu destino.
bool passouMina(Barco b, double dx, double dy, ListaLigada lista,
    ListaLigada listaminas, ListaLigada listaSelec, File svg, File txt) {
  var navio = b;
  var mina = listaminas.inicio as Mina?;
  while (mina != null) {
    if (navio is Circulo) {
      var circulo = navio;

      if (dx == 0) {
        if (dy <= 0) {
          if (circulo.y! + dy - circulo.raio! <= mina.y! &&
              mina.y! <= circulo.y! + circulo.raio! &&
              circulo.x! - circulo.raio! <= mina.x! &&
              circulo.x! + circulo.raio! >= mina.x!) {
            txt.writeAsStringSync(
                'O círculo ${circulo.id} passou por uma mina e foi destruído.\nDados do barco: x=${circulo.x}\ny=${circulo.y}\nraio=${circulo.raio}\ncor de preenchimento=${circulo.corPreenchimento}\ncor da borda=${circulo.corBorda}\nHP=${circulo.hp}\nNível de Proteção=${circulo.protecao}\n\n',
                mode: FileMode.append);
            lista.remove(circulo);
            listaSelec.remove(circulo);
            listaminas.remove(mina);
            svg.writeAsStringSync(
                '<text x="${circulo.x}" y="${circulo.y}" fill="red" font-size="5" font-family="Verdana">@</text>\n',
                mode: FileMode.append);
            return true;
          }
        } else {
          if (circulo.y! + dy + circulo.raio! >= mina.y! &&
              mina.y! >= circulo.y! - circulo.raio! &&
              circulo.x! - circulo.raio! <= mina.x! &&
              circulo.x! + circulo.raio! >= mina.x!) {
            txt.writeAsStringSync(
                'O círculo ${circulo.id} passou por uma mina e foi destruído.\nDados do barco: x=${circulo.x}\ny=${circulo.y}\nraio=${circulo.raio}\ncor de preenchimento=${circulo.corPreenchimento}\ncor da borda=${circulo.corBorda}\nHP=${circulo.hp}\nNível de Proteção=${circulo.protecao}\n\n',
                mode: FileMode.append);
            lista.remove(circulo);
            listaSelec.remove(circulo);
            listaminas.remove(mina);
            svg.writeAsStringSync(
                '<text x="${circulo.x}" y="${circulo.y}" fill="red" font-size="5" font-family="Verdana">@</text>\n',
                mode: FileMode.append);
            return true;
          }
        }
      } else {
        if (dx <= 0) {
          if (circulo.x! + dx - circulo.raio! <= mina.x! &&
              mina.x! <= circulo.x! + circulo.raio! &&
              circulo.y! - circulo.raio! <= mina.y! &&
              circulo.y! + circulo.raio! >= mina.y!) {
            txt.writeAsStringSync(
                'O círculo ${circulo.id} passou por uma mina e foi destruído.\nDados do barco: x=${circulo.x}\ny=${circulo.y}\nraio=${circulo.raio}\ncor de preenchimento=${circulo.corPreenchimento}\ncor da borda=${circulo.corBorda}\nHP=${circulo.hp}\nNível de Proteção=${circulo.protecao}\n\n',
                mode: FileMode.append);
            lista.remove(circulo);
            listaSelec.remove(circulo);
            listaminas.remove(mina);
            svg.writeAsStringSync(
                '<text x="${circulo.x}" y="${circulo.y}" fill="red" font-size="5" font-family="Verdana">@</text>\n',
                mode: FileMode.append);
            return true;
          }
        } else {
          if (circulo.x! + dx + circulo.raio! >= mina.x! &&
              mina.x! >= circulo.x! - circulo.raio! &&
              circulo.y! - circulo.raio! <= mina.y! &&
              circulo.y! + circulo.raio! >= mina.y!) {
            txt.writeAsStringSync(
                'O círculo ${circulo.id} passou por uma mina e foi destruído.\nDados do barco: x=${circulo.x}\ny=${circulo.y}\nraio=${circulo.raio}\ncor de preenchimento=${circulo.corPreenchimento}\ncor da borda=${circulo.corBorda}\nHP=${circulo.hp}\nNível de Proteção=${circulo.protecao}\n\n',
                mode: FileMode.append);
            lista.remove(circulo);
            listaSelec.remove(circulo);
            listaminas.remove(mina);
            svg.writeAsStringSync(
                '<text x="${circulo.x}" y="${circulo.y}" fill="red" font-size="5" font-family="Verdana">@</text>\n',
                mode: FileMode.append);
            return true;
          }
        }
      }
    } else if (navio is Retangulo) {
      var retangulo = navio;
      
      if (dx == 0) {
        if (dy <= 0) {
          if (retangulo.y! + dy - retangulo.altura! <= mina.y! &&
              mina.y! <= retangulo.y! + retangulo.altura! &&
              retangulo.x! - retangulo.largura! <= mina.x! &&
              retangulo.x! + retangulo.largura! >= mina.x!) {
            txt.writeAsStringSync(
                'O retângulo ${retangulo.id} passou por uma mina e foi destruído.\nDados do barco: x=${retangulo.x}\ny=${retangulo.y}\nlargura=${retangulo.largura}\naltura=${retangulo.altura}\ncor de preenchimento=${retangulo.corPreenchimento}\ncor da borda=${retangulo.corBorda}\nHP=${retangulo.hp}\nNível de Proteção=${retangulo.protecao}\n\n',
                mode: FileMode.append);
            lista.remove(retangulo);
            listaSelec.remove(retangulo);
            listaminas.remove(mina);
            svg.writeAsStringSync(
                '<text x="${retangulo.x}" y="${retangulo.y}" fill="red" font-size="5" font-family="Verdana">@</text>\n',
                mode: FileMode.append);
            return true;
          }
        } else {
          if (retangulo.y! + dy + retangulo.altura! >= mina.y! &&
              mina.y! >= retangulo.y! - retangulo.altura! &&
              retangulo.x! - retangulo.largura! <= mina.x! &&
              retangulo.x! + retangulo.largura! >= mina.x!) {
            txt.writeAsStringSync(
                'O retângulo ${retangulo.id} passou por uma mina e foi destruído.\nDados do barco: x=${retangulo.x}\ny=${retangulo.y}\nlargura=${retangulo.largura}\naltura=${retangulo.altura}\ncor de preenchimento=${retangulo.corPreenchimento}\ncor da borda=${retangulo.corBorda}\nHP=${retangulo.hp}\nNível de Proteção=${retangulo.protecao}\n\n',
                mode: FileMode.append);
            lista.remove(retangulo);
            listaSelec.remove(retangulo);
            listaminas.remove(mina);
            svg.writeAsStringSync(
                '<text x="${retangulo.x}" y="${retangulo.y}" fill="red" font-size="5" font-family="Verdana">@</text>\n',
                mode: FileMode.append);
            return true;
          }
        }
      } else {
        if (dx <= 0) {
          if (retangulo.x! + dx - retangulo.largura! <= mina.x! &&
              mina.x! <= retangulo.x! + retangulo.largura! &&
              retangulo.y! - retangulo.altura! <= mina.y! &&
              retangulo.y! + retangulo.altura! >= mina.y!) {
            txt.writeAsStringSync(
                'O retângulo ${retangulo.id} passou por uma mina e foi destruído.\nDados do barco: x=${retangulo.x}\ny=${retangulo.y}\nlargura=${retangulo.largura}\naltura=${retangulo.altura}\ncor de preenchimento=${retangulo.corPreenchimento}\ncor da borda=${retangulo.corBorda}\nHP=${retangulo.hp}\nNível de Proteção=${retangulo.protecao}\n\n',
                mode: FileMode.append);
            lista.remove(retangulo);
            listaSelec.remove(retangulo);
            listaminas.remove(mina);
            svg.writeAsStringSync(
                '<text x="${retangulo.x}" y="${retangulo.y}" fill="red" font-size="5" font-family="Verdana">@</text>\n',
                mode: FileMode.append);
            return true;
          }
        } else {
          if (retangulo.x! + dx + retangulo.largura! >= mina.x! &&
              mina.x! >= retangulo.x! - retangulo.largura! &&
              retangulo.y! - retangulo.altura! <= mina.y! &&
              retangulo.y! + retangulo.altura! >= mina.y!) {
            txt.writeAsStringSync(
                'O retângulo ${retangulo.id} passou por uma mina e foi destruído.\nDados do barco: x=${retangulo.x}\ny=${retangulo.y}\nlargura=${retangulo.largura}\naltura=${retangulo.altura}\ncor de preenchimento=${retangulo.corPreenchimento}\ncor da borda=${retangulo.corBorda}\nHP=${retangulo.hp}\nNível de Proteção=${retangulo.protecao}\n\n',
                mode: FileMode.append);
            lista.remove(retangulo);
            listaSelec.remove(retangulo);
            listaminas.remove(mina);
            svg.writeAsStringSync(
                '<text x="${retangulo.x}" y="${retangulo.y}" fill="red" font-size="5" font-family="Verdana">@</text>\n',
                mode: FileMode.append);
            return true;
          }
        }
      }
    } else if (navio is Linha) {
      var linha = navio;
      var largura = (linha.x! - linha.x2!).abs();
      var altura = (linha.y! - linha.y2!).abs();
      
      if (dx == 0) {
        if (dy <= 0) {
          if (linha.y! + dy - altura <= mina.y! &&
              mina.y! <= linha.y! + altura &&
              linha.x! - largura <= mina.x! &&
              linha.x! + largura >= mina.x!) {
            txt.writeAsStringSync(
                'A linha ${linha.id} passou por uma mina e foi destruída.\nDados da linha: x=${linha.x}\ny=${linha.y}\nlargura=$largura\naltura=$altura}ncor de preenchimento=${linha.cor}\nHP=${linha.hp}\nNível de Proteção=${linha.protecao}\n\n',
                mode: FileMode.append);
            lista.remove(linha);
            listaSelec.remove(linha);
            listaminas.remove(mina);
            svg.writeAsStringSync(
                '<text x="${linha.x}" y="${linha.y}" fill="red" font-size="5" font-family="Verdana">@</text>\n',
                mode: FileMode.append);
            return true;
          }
        } else {
          if (linha.y! + dy + altura >= mina.y! &&
              mina.y! >= linha.y! - altura &&
              linha.x! - largura <= mina.x! &&
              linha.x! + largura >= mina.x!) {
            txt.writeAsStringSync(
                'A linha ${linha.id} passou por uma mina e foi destruída.\nDados da linha: x=${linha.x}\ny=${linha.y}\nlargura=$largura\naltura=$altura\ncor de preenchimento=${linha.cor}\nHP=${linha.hp}\nNível de Proteção=${linha.protecao}\n\n',
                mode: FileMode.append);
            lista.remove(linha);
            listaSelec.remove(linha);
            listaminas.remove(mina);
            svg.writeAsStringSync(
                '<text x="${linha.x}" y="${linha.y}" fill="red" font-size="5" font-family="Verdana">@</text>\n',
                mode: FileMode.append);
            return true;
          }
        }
      }
    } else if (navio is Texto) {
      var texto = navio;
      
      if (dx == 0) {
        if (dy <= 0) {
          if (texto.y! + dy <= mina.y! &&
              mina.y! <= texto.y! &&
              texto.x! <= mina.x! &&
              texto.x! >= mina.x!) {
            txt.writeAsStringSync(
                'O texto ${texto.id} passou por uma mina e foi destruído.\nDados do texto: x=${texto.x}\ny=${texto.y}\ncor de preenchimento=${texto.corPreenchimento}\ncor de borda=${texto.corBorda}\nHP=${texto.hp}\nNível de Proteção=${texto.protecao}\n\n',
                mode: FileMode.append);
            lista.remove(texto);
            listaSelec.remove(texto);
            listaminas.remove(mina);
            svg.writeAsStringSync(
                '<text x="${texto.x}" y="${texto.y}" fill="red" font-size="5" font-family="Verdana">@</text>\n',
                mode: FileMode.append);
            return true;
          }
        } else {
          if (texto.y! + dy >= mina.y! &&
              mina.y! >= texto.y! &&
              texto.x! <= mina.x! &&
              texto.x! >= mina.x!) {
            txt.writeAsStringSync(
                'O texto ${texto.id} passou por uma mina e foi destruído.\nDados do texto: x=${texto.x}\ny=${texto.y}\ncor de preenchimento=${texto.corPreenchimento}\ncor de borda=${texto.corBorda}\nHP=${texto.hp}\nNível de Proteção=${texto.protecao}\n\n',
                mode: FileMode.append);
            lista.remove(texto);
            listaSelec.remove(texto);
            listaminas.remove(mina);
            svg.writeAsStringSync(
                '<text x="${texto.x}" y="${texto.y}" fill="red" font-size="5" font-family="Verdana">@</text>\n',
                mode: FileMode.append);
            return true;
          }
        }
      } else if (dy == 0) {
        if (dx <= 0) {
          if (texto.x! + dx <= mina.x! &&
              mina.x! <= texto.x! &&
              texto.y! <= mina.y! &&
              texto.y! >= mina.y!) {
            txt.writeAsStringSync(
                'O texto ${texto.id} passou por uma mina e foi destruído.\nDados do texto: x=${texto.x}\ny=${texto.y}\ncor de preenchimento=${texto.corPreenchimento}\ncor de borda=${texto.corBorda}\nHP=${texto.hp}\nNível de Proteção=${texto.protecao}\n\n',
                mode: FileMode.append);
            lista.remove(texto);
            listaSelec.remove(texto);
            listaminas.remove(mina);
            svg.writeAsStringSync(
                '<text x="${texto.x}" y="${texto.y}" fill="red" font-size="5" font-family="Verdana">@</text>\n',
                mode: FileMode.append);
            return true;
          }
        } else {
          if (texto.x! + dx >= mina.x! &&
              mina.x! >= texto.x! &&
              texto.y! <= mina.y! &&
              texto.y! >= mina.y!) {
            txt.writeAsStringSync(
                'O texto ${texto.id} passou por uma mina e foi destruído.\nDados do texto: x=${texto.x}\ny=${texto.y}\ncor de preenchimento=${texto.corPreenchimento}\ncor de borda=${texto.corBorda}\nHP=${texto.hp}\nNível de Proteção=${texto.protecao}\n\n',
                mode: FileMode.append);
            lista.remove(texto);
            listaSelec.remove(texto);
            listaminas.remove(mina);
            svg.writeAsStringSync(
                '<text x="${texto.x}" y="${texto.y}" fill="red" font-size="5" font-family="Verdana">@</text>\n',
                mode: FileMode.append);
            return true;
          }
        }
      }
    }
  }
  return false;
}

///Função que move o navio selecionado e verifica se ele passou por uma mina. Retorna os pontos recebidos.
double moveBarco(
    ListaLigada lista,
    ListaLigada listaminas,
    ListaLigada listaSelec,
    double dx,
    double dy,
    int j,
    int k,
    File svg,
    File txt) {
  var pontos = 0.0;
  Elemento? escolherBarco(ListaLigada listaSelec, int j, int k) {
    var elemento = listaSelec.inicio;
    Elemento? barcoCapitao;
    while (elemento != null) {
      if (elemento.item.id == j) {
        barcoCapitao = elemento;
        break;
      }
      elemento = elemento.next;
    }
    if (k > 0) {
      for (var i = 0; i < k; i++) {
        barcoCapitao = barcoCapitao?.next ?? listaSelec.inicio;
      }
    } else {
      for (var i = 0; i > k; i--) {
        barcoCapitao = listaSelec.previous(barcoCapitao) ?? listaSelec.last();
      }
    }
    try {
      return barcoCapitao;
    } catch (e) {
      throw Exception('Barco não encontrado');
    }
  }

  var barco = escolherBarco(listaSelec, j, k);
  if (barco == null) {
    throw Exception('Barco não encontrado');
  }
  if (!passouMina(barco.item, dx, dy, lista, listaminas, listaSelec, svg, txt)) {
    if (barco.item is Circulo) {
      barco.item.x = barco.item.x + dx;
      barco.item.y = barco.item.y + dy;
      txt.writeAsStringSync(
          'O círculo ${barco.item.id} foi movido para a posição x=${barco.item.x} e y=${barco.item.y}.\nDados do barco: x=${barco.item.x}\ny=${barco.item.y}\ncor de preenchimento=${barco.item.corPreenchimento}\ncor de borda=${barco.item.corBorda}\nHP=${barco.item.hp}\nNível de Proteção=${barco.item.protecao}\n\n',
          mode: FileMode.append);
    } else if (barco.item is Retangulo) {
      barco.item.x = barco.item.x! + dx;
      barco.item.y = barco.item.y! + dy;
      txt.writeAsStringSync(
          'O retângulo ${barco.item.id} foi movido para a posição x=${barco.item.x} e y=${barco.item.y}.\nDados do barco: x=${barco.item.x}\ny=${barco.item.y}\ncor de preenchimento=${barco.item.corPreenchimento}\ncor de borda=${barco.item.corBorda}\nHP=${barco.item.hp}\nNível de Proteção=${barco.item.protecao}\n\n',
          mode: FileMode.append);
    } else if (barco.item is Linha) {
      barco.item.x = barco.item.x! + dx;
      barco.item.y = barco.item.y! + dy;
      barco.item.x2 = barco.item.x2! + dx;
      barco.item.y2 = barco.item.y2! + dy;
      txt.writeAsStringSync(
          'A linha ${barco.item.id} foi movida para a posição x=${barco.item.x} e y=${barco.item.y}.\nDados do barco: x=${barco.item.x}\ny=${barco.item.y}\ncor=${barco.item.cor}\nHP=${barco.item.hp}\nNível de Proteção=${barco.item.protecao}\n\n',
          mode: FileMode.append);
    } else if (barco.item is Texto) {
      barco.item.x = barco.item.x! + dx;
      barco.item.y = barco.item.y! + dy;
      txt.writeAsStringSync(
          'O texto ${barco.item.id} foi movido para a posição x=${barco.item.x} e y=${barco.item.y}.\nDados do barco: x=${barco.item.x}\ny=${barco.item.y}\ncor de preenchimento=${barco.item.corPreenchimento}\ncor de borda=${barco.item.corBorda}\nHP=${barco.item.hp}\nNível de Proteção=${barco.item.protecao}\n\n',
          mode: FileMode.append);
    }
  } else {
    pontos += barco.item.pontos();
  }
  return pontos;
}

/// Lê um arquivo QRY e manipula a lista encadeada
File lerArquivoQry(
    String qry, ListaLigada lista, File svg, ListaLigada listaminas) {
  var arquivo = File(qry);
  var linhas = arquivo.readAsLinesSync();
  var listaSelec = ListaLigada();
  double na = 0, pontos = 0, pontosmax = 0;
  var cont = 0;
  var elemento = lista.inicio;
  var txt = File('relatorio.txt');
  txt.writeAsStringSync('');
  for (var linha in linhas) {
    txt.writeAsStringSync('[*] $linha\n', mode: FileMode.append);
    var comando = linha.split(' ');
    switch (comando[0]) {
      case 'na':
        na = double.parse(comando[1]);
        break;
      case 'tp':
        pontos += ataqueTorpedo(lista, double.parse(comando[1]),
            double.parse(comando[2]), txt, svg);
        break;
      case 'tr':
        ataqueTorpedoReplicante(
            lista,
            double.parse(comando[1]),
            double.parse(comando[2]),
            double.parse(comando[3]),
            double.parse(comando[4]),
            int.parse(comando[5]),
            svg,
            txt);
        break;
      case 'be':
        pontos += bombaRadiacao(lista, double.parse(comando[1]),
            double.parse(comando[2]), double.parse(comando[3]), na, svg, txt);
        break;
      case 'mvh':
        pontos += moveBarco(
            lista,
            listaminas,
            listaSelec,
            double.parse(comando[3]),
            0,
            int.parse(comando[1]),
            int.parse(comando[2]),
            svg,
            txt);
        break;
      case 'mvv':
        pontos += moveBarco(
            lista,
            listaminas,
            listaSelec,
            0,
            double.parse(comando[3]),
            int.parse(comando[1]),
            int.parse(comando[2]),
            svg,
            txt);
        break;
      case 'se':
        while (elemento != null) {
          if (elemento.item is Barco) {
            if (elemento.item.id == int.parse(comando[1])) {
              listaSelec.insert(elemento.item);
            }
          }
          elemento = elemento.next;
        }
        break;
      case 'sec':
        while (elemento != null) {
          if (elemento.item is Barco) {
            if (elemento.item.id == int.parse(comando[1])) {
              listaSelec.insert(elemento.item);
              elemento.item.idCapitao = int.parse(comando[2]);
            }
          }
          elemento = elemento.next;
        }
        break;
      default:
        continue;
    }
    cont++;
    txt.writeAsStringSync('\n', mode: FileMode.append);
  }
  elemento = lista.inicio;
  while (elemento != null) {
    if (elemento.item is Barco) {
      Barco barco = elemento.item;
      if (barco.pontos() < barco.pontosDesativar()) {
        pontosmax += barco.pontosDesativar();
      } else {
        pontosmax += barco.pontos();
      }
    }
    elemento = elemento.next;
  }
  txt.writeAsStringSync('Pontuação: $pontos\n', mode: FileMode.append);
  txt.writeAsStringSync(
      'Proporção entre a pontuação e o número de comandos: ${pontos / cont}\n',
      mode: FileMode.append);
  txt.writeAsStringSync(
      'Proporção entre a pontuação e a pontuação máxima: ${pontos / pontosmax}\n',
      mode: FileMode.append);
  return arquivo;
}
