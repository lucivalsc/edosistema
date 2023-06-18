object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Servidor - Padr'#227'o'
  ClientHeight = 182
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 80
    Top = 21
    Width = 26
    Height = 13
    Caption = 'Porta'
  end
  object Label2: TLabel
    Left = 80
    Top = 69
    Width = 36
    Height = 13
    Caption = 'Usu'#225'rio'
  end
  object Label3: TLabel
    Left = 80
    Top = 117
    Width = 30
    Height = 13
    Caption = 'Senha'
  end
  object edtPorta: TEdit
    Left = 80
    Top = 40
    Width = 57
    Height = 21
    NumbersOnly = True
    TabOrder = 1
    Text = '8082'
  end
  object Button1: TButton
    Left = 150
    Top = 38
    Width = 123
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object edtUsuario: TEdit
    Left = 80
    Top = 88
    Width = 193
    Height = 21
    TabOrder = 2
    Text = 'admin'
  end
  object edtSenha: TEdit
    Left = 80
    Top = 136
    Width = 193
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
    Text = 'admin'
  end
  object TrayIcon1: TTrayIcon
    BalloonHint = 'Servidor'
    PopupMenu = PopupMenu1
    OnDblClick = TrayIcon1DblClick
    Left = 24
    Top = 16
  end
  object PopupMenu1: TPopupMenu
    Left = 24
    Top = 72
    object Fechar1: TMenuItem
      Caption = 'Fechar'
      OnClick = Fechar1Click
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnMinimize = ApplicationEvents1Minimize
    Left = 24
    Top = 128
  end
end
