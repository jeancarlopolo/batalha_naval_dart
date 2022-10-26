import 'dart:io';

import 'package:batalha_naval/lista.dart';
import 'package:batalha_naval/qry.dart';
import 'package:batalha_naval/svg.dart' as svgfuncoes;
import 'package:batalha_naval/geo.dart';

void main(List<String> args) {
  if (args.length < 4) {
    print('Uso: batalha_naval [-e path] -f arq.geo [-q consulta.qry] [-o dir]');
    return;
  }
  var geo = '';
  var qry = '';
  var dir = '';
  var path = '';
  var lista = ListaLigada();
  var listaminas = ListaLigada();
  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '-f':
        geo = args[i + 1];
        break;
      case '-q':
        qry = args[i + 1];
        break;
      case '-o':
        dir = args[i + 1];
        break;
      case '-e':
        path = args[i + 1];
        break;
    }
  }
  if (geo == '') {
    print('Arquivo .geo não especificado');
    return;
  }
  if (path != '') {
    lista = lerArquivoGeo('$path/$geo', listaminas);
  } else {
    lista = lerArquivoGeo(geo, listaminas);
  }
  var arquivotemp = File('${dir}temporario.svg');
  arquivotemp.writeAsStringSync('');
  if (path != '') {
    if (qry != '') {
      lerArquivoQry('$path/$qry', lista, arquivotemp, listaminas);
    }
  } else {
    if (qry != '') {
      lerArquivoQry(qry, lista, arquivotemp, listaminas);
    }
  }
  var arquivo =
      File('$dir${geo.replaceFirst('.', '')}${qry.replaceFirst('.', '')}.svg');
  arquivo.writeAsStringSync('');
  arquivo.writeAsStringSync(
      '<svg xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" version="1.1">\n\n',
      mode: FileMode.append);
  svgfuncoes.desenhar(lista, arquivo);
  if (arquivotemp.existsSync()) {
    final lines = arquivotemp.readAsLinesSync();
    for (var line in lines) {
      arquivo.writeAsStringSync('\n$line', mode: FileMode.append);
    }
    arquivotemp.deleteSync();
  }
  arquivo.writeAsStringSync('</svg>', mode: FileMode.append);
  print('Arquivo $arquivo gerado com sucesso!');
}
