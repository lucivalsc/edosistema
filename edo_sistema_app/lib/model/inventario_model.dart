// ignore_for_file: non_constant_identifier_names

class InventarioModel {
  String? NUM_LANC;
  String? DATA;
  String? COD_PROD;
  String? QTDE_ANT;
  String? QTDE_NOVA;
  String? TIPO;
  String? UCLOGIN;
  String? VLR_CUSTO;
  String? VLR_VENDA;
  String? COD_LOJA;
  String? DESCRICAO;
  String? LOC_ESTO;
  String? COD_BARR;
  InventarioModel();

  InventarioModel.fromJson(Map<String, dynamic> json) {
    // CODPROD = json['COD_PROD']?.toString();
    NUM_LANC = json['NUM_LANC']?.toString();
    DATA = json['DATA']?.toString();
    COD_PROD = json['COD_PROD']?.toString();
    QTDE_ANT = json['QTDE_ANT']?.toString();
    QTDE_NOVA = json['QTDE_NOVA']?.toString();
    TIPO = json['TIPO']?.toString();
    UCLOGIN = json['UCLOGIN']?.toString();
    VLR_CUSTO = json['VLR_CUSTO']?.toString();
    VLR_VENDA = json['VLR_VENDA']?.toString();
    COD_LOJA = json['COD_LOJA']?.toString();
    DESCRICAO = json['DESCRICAO']?.toString();
    LOC_ESTO = json['LOC_ESTO']?.toString();
    COD_BARR = json['COD_BARR']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // data['COD_PROD'] = CODPROD;
    data['NUM_LANC'] = NUM_LANC;
    data['DATA'] = DATA;
    data['COD_PROD'] = COD_PROD;
    data['QTDE_ANT'] = QTDE_ANT;
    data['QTDE_NOVA'] = QTDE_NOVA;
    data['TIPO'] = TIPO;
    data['UCLOGIN'] = UCLOGIN;
    data['VLR_CUSTO'] = VLR_CUSTO;
    data['VLR_VENDA'] = VLR_VENDA;
    data['COD_LOJA'] = COD_LOJA;
    data['DESCRICAO'] = DESCRICAO;
    data['LOC_ESTO'] = LOC_ESTO;
    data['COD_BARR'] = COD_BARR;
    return data;
  }
}
