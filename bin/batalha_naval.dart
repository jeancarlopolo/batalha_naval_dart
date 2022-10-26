import 'package:batalha_naval/lista.dart';
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
  if (dir == '') {
    print('Diretório de saída não especificado');
    return;
  }
  if (path != '') {
    lista = lerArquivoGeo('$path/$geo');
  } else {
    lista = lerArquivoGeo(geo);
  }
  var arquivo = svgfuncoes.criaSvg('$geo$qry.svg', path: dir);
  if (qry != '') {
    lerArquivoQry('$path/$qry', lista);
  } else {
    lerArquivoQry(qry, lista);
  }
  svgfuncoes.desenhar(lista, arquivo);
  svgfuncoes.finalizaSvg(arquivo);
  print('Arquivo $geo$qry.svg gerado com sucesso!');
}
