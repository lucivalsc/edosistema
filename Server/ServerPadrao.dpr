program ServerPadrao;

uses
  Vcl.Forms,
  untPrincipal in 'forms\untPrincipal.pas' {frmPrincipal},
  untServerMethodDataModule in 'forms\untServerMethodDataModule.pas' {ServerModule: TDataModule},
  untArquivoINI in 'forms\untArquivoINI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Servidor Nacpreços';
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
