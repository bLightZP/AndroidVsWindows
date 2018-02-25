unit mainUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.Diagnostics,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TmainForm = class(TForm)
    ButtonMemoryArray: TButton;
    procedure ButtonMemoryArrayClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  mainForm  : TmainForm;
  stopWatch : TStopWatch;

implementation

{$R *.fmx}

procedure TmainForm.ButtonMemoryArrayClick(Sender: TObject);
// windows :  3027 - 3036ms
// android : 16638
const
  BlockSize  = 512;
  BlockCount = 1000;

  ValueCount = 8;
  ValueTable : Array[0..ValueCount-1] of Cardinal = (0,$FF,$FFFF,$FFFFFF,$FFFFFFFF,$00FF,$0000FF,$000000FF);


type
  TPixelMetaDataRecord =
  Record
    mdByte        : Byte;
    mdCardinal    : Cardinal;
  End;
  TBlockMetaDataRecord = Array[0..BlockSize-1,0..BlockSize-1] of TPixelMetaDataRecord;
  PBlockMetaDataRecord = ^TBlockMetaDataRecord;

  PMetaDataRecord = ^TBlockMetaDataRecord;

var
  X,Y,I         : Integer;
  i64TS         : Int64;
  BlockMetaData : PBlockMetaDataRecord;

begin
  stopWatch := TStopWatch.StartNew;
  For I := 0 to BlockCount-1 do
  Begin
    New(BlockMetaData);
    For Y := 0 to BlockSize-1 do For X := 0 to BlockSize-1 do
    Begin
      BlockMetaData^[X,Y].mdCardinal    := ValueTable[X mod ValueCount];
      BlockMetaData^[X,Y].mdByte        := 0;
    End;
    Dispose(BlockMetaData);
  End;
  i64TS := Round(stopWatch.Elapsed.TotalMilliseconds);

  ShowMessage(IntToStr(i64TS)+'ms');
end;

end.
