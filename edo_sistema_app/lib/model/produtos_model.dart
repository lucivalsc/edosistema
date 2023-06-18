///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
// ignore_for_file: non_constant_identifier_names

class ProdutosModel {
/*
{
  "COD_PROD": "48493",
  "COD_ORG": "24578819",
  "PRE_CUS": 100,
  "PRE_VEN": 190,
  "COD_GRP": "001",
  "DES_GRP": "BICO INJETOR",
  "DES_PROD": "BICO INJ ONIX/COBALT/PRISMA 1.0 FLEX 11/... AZUL",
  "PER_DESC": 0,
  "FLG_TIPO": "P",
  "COD_BARR": ".",
  "NCM": "",
  "COD_GENERO": 0,
  "UNI_MED": "PC",
  "APLICA": ".",
  "DES_MARC": "GM",
  "QTD_ATUAL": 6,
  "QTD_MAX": 0,
  "LOC_ESTO": "R-05 D-49",
  "NOM_LOJA": "REVANCAR AUTO PEÇAS",
  "DATA_ENT": null,
  "PRE_DESC": 169.1,
  "DATA_ALT": "10/08/2021 00:00:00",
  "MASTER": "48493 24578819 . BICO INJ ONIX/COBALT/PRISMA 1.0 FLEX 11/... AZUL GM .",
  "DATEUSER": null
} 
*/

  String? CODPROD;
  String? CODORG;
  String? PRECUS;
  String? PREVEN;
  String? CODGRP;
  String? DESGRP;
  String? DESPROD;
  String? PERDESC;
  String? FLGTIPO;
  String? CODBARR;
  String? NCM;
  String? CODGENERO;
  String? UNIMED;
  String? APLICA;
  String? DESMARC;
  String? QTDATUAL;
  String? QTDMAX;
  String? LOCESTO;
  String? NOMLOJA;
  String? DATAENT;
  String? PREDESC;
  String? DATAALT;
  String? MASTER;
  String? DATEUSER;

  ProdutosModel({
    this.CODPROD,
    this.CODORG,
    this.PRECUS,
    this.PREVEN,
    this.CODGRP,
    this.DESGRP,
    this.DESPROD,
    this.PERDESC,
    this.FLGTIPO,
    this.CODBARR,
    this.NCM,
    this.CODGENERO,
    this.UNIMED,
    this.APLICA,
    this.DESMARC,
    this.QTDATUAL,
    this.QTDMAX,
    this.LOCESTO,
    this.NOMLOJA,
    this.DATAENT,
    this.PREDESC,
    this.DATAALT,
    this.MASTER,
    this.DATEUSER,
  });
  ProdutosModel.fromJson(Map<String, dynamic> json) {
    CODPROD = json['COD_PROD']?.toString();
    CODORG = json['COD_ORG']?.toString();
    PRECUS = json['PRE_CUS']?.toString();
    PREVEN = json['PRE_VEN']?.toString();
    CODGRP = json['COD_GRP']?.toString();
    DESGRP = json['DES_GRP']?.toString();
    DESPROD = json['DES_PROD']?.toString();
    PERDESC = json['PER_DESC']?.toString();
    FLGTIPO = json['FLG_TIPO']?.toString();
    CODBARR = json['COD_BARR']?.toString();
    NCM = json['NCM']?.toString();
    CODGENERO = json['COD_GENERO']?.toString();
    UNIMED = json['UNI_MED']?.toString();
    APLICA = json['APLICA']?.toString();
    DESMARC = json['DES_MARC']?.toString();
    QTDATUAL = json['QTD_ATUAL']?.toString();
    QTDMAX = json['QTD_MAX']?.toString();
    LOCESTO = json['LOC_ESTO']?.toString();
    NOMLOJA = json['NOM_LOJA']?.toString();
    DATAENT = json['DATA_ENT']?.toString();
    PREDESC = json['PRE_DESC']?.toString();
    DATAALT = json['DATA_ALT']?.toString();
    MASTER = json['MASTER']?.toString();
    DATEUSER = json['DATEUSER']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['COD_PROD'] = CODPROD;
    data['COD_ORG'] = CODORG;
    data['PRE_CUS'] = PRECUS;
    data['PRE_VEN'] = PREVEN;
    data['COD_GRP'] = CODGRP;
    data['DES_GRP'] = DESGRP;
    data['DES_PROD'] = DESPROD;
    data['PER_DESC'] = PERDESC;
    data['FLG_TIPO'] = FLGTIPO;
    data['COD_BARR'] = CODBARR;
    data['NCM'] = NCM;
    data['COD_GENERO'] = CODGENERO;
    data['UNI_MED'] = UNIMED;
    data['APLICA'] = APLICA;
    data['DES_MARC'] = DESMARC;
    data['QTD_ATUAL'] = QTDATUAL;
    data['QTD_MAX'] = QTDMAX;
    data['LOC_ESTO'] = LOCESTO;
    data['NOM_LOJA'] = NOMLOJA;
    data['DATA_ENT'] = DATAENT;
    data['PRE_DESC'] = PREDESC;
    data['DATA_ALT'] = DATAALT;
    data['MASTER'] = MASTER;
    data['DATEUSER'] = DATEUSER;
    return data;
  }
}
