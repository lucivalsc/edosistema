unit untPadraoBotao;

interface

uses
  FMX.Ani,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Objects;

type
  TFramePadraoBotao = class(TFrame)
    PathPadraoBotao: TPath;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Loaded; override;
  end;

implementation

{$R *.fmx}

procedure TFramePadraoBotao.Loaded;
begin
  inherited;
end;

end.
