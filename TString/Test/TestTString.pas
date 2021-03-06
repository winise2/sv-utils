﻿unit TestTString;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, uSvStrings, Classes, SysUtils, Diagnostics, Variants;

type
  TestTSvString = class(TTestCase)
  private
    FString: TSvString;
    sw: TStopwatch;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAdd;
    procedure TestImplicit;
    procedure TestEnum;
    procedure TestClone;
    procedure TestConcat;
    procedure TestTrimRight;
    procedure TestSaveToFile;
    procedure TestLoadFromFile;
    procedure TestCompress;
    procedure TestSoundex;
    procedure TestDefaultProperty;
    procedure TestIndexOfSpeed;
    procedure TestEquals;
    procedure TestReplace;
    procedure TestJoin;
    procedure TestSplit;
    procedure TestValueOf;
    procedure TestMD5();
  end;

implementation

uses
  StrUtils;

const
  cInit = 'Test big string';

procedure TestTSvString.SetUp;
begin
  FString := cInit;
end;

procedure TestTSvString.TearDown;
begin
//
end;


const
  ADD_COUNT = 100000;

procedure TestTSvString.TestAdd;
var
  i: Integer;
  s, s2: string;
  i1, i2, i3, i4: Int64;
  AStr: TSvString;
begin
  FString := FString + 'z';

  Check(FString = cInit + 'z');

  FString := '';
  sw := TStopwatch.StartNew;
  for i := 0 to ADD_COUNT - 1 do
  begin
    FString := FString + 'a';
  end;

  sw.Stop;
  i1 := sw.ElapsedMilliseconds;

  s := '';

  sw := TStopwatch.StartNew;
  for i := 0 to ADD_COUNT - 1 do
  begin
    s := s + 'a';
  end;

  sw.Stop;
  i2 := sw.ElapsedMilliseconds;

  AStr := '';
  sw := TStopwatch.StartNew;
  for i := 0 to ADD_COUNT - 1 do
  begin
    AStr := 'a';
  end;

  sw.Stop;
  i3 := sw.ElapsedMilliseconds;

  s2 := '';
  sw := TStopwatch.StartNew;
  for i := 0 to ADD_COUNT - 1 do
  begin
    s2 := 'a';
  end;

  sw.Stop;
  i4 := sw.ElapsedMilliseconds;

  CheckEqualsString(s, FString);
  Status(Format('TSvString + operator: %D ms. Native string: %D ms. Assign TsvString: %D ms, Native: %D ms.Iterations: %D',
    [i1, i2, i3, i4,ADD_COUNT]));

end;

procedure TestTSvString.TestClone;
var
  s: TSvString;
  iSize, iSize2: Integer;
  st: string;
begin
  iSize := SizeOf(s);
  iSize2 := SizeOf(st);
  s := FString.Clone;

  Check(s = FString);
end;

procedure TestTSvString.TestCompress;
const
  ctCompress = 'aaaaaa aaaa df45df aaa22222222 asasdfereo efo eofj eojf';
var
  s: TSvString;
  iLength: Integer;
  chr: Char;
begin
  s := ctCompress;
  iLength := s.Length;
  s.Compress;

  Check(s.Length < iLength);

  s.Decompress;

  Check(s = ctCompress);

  chr := 'a';
end;

procedure TestTSvString.TestConcat;
begin
  FString.Concat('z');
  Check(FString = cInit + 'z');
end;

procedure TestTSvString.TestDefaultProperty;
var
  AChar: Char;
  s: string;
  i: Integer;
begin
  s := '';
  for i := 1 to FString.Length do
  begin
    AChar := FString[i];
    s := s + AChar;
  end;

  Check(s = FString);
end;

procedure TestTSvString.TestEnum;
var
  chr: Char;
  iCount: Integer;
  sRes, sTest: string;
begin
  iCount := 0;
  sRes := '';
  for chr in FString do
  begin
    sRes := sRes + chr;
    Inc(iCount);
  end;

  sTest := FString;

  Check(iCount = FString.Length);
  Check(sRes = FString);
end;

procedure TestTSvString.TestEquals;
var
  s : TSvString;
  i: Integer;
begin
  FString := 'Lorem ipsum dolor sit amet '+
    'Consectetuer dui nec Sed tincidunt'+
    'Nam Vivamus et eget ut'+
    'Id risus condimentum metus ut'+
    'Feugiat metus feugiat Donec congue'+
    'Id dictum adipiscing congue Morbi'+
    'Aenean eget tellus wisi elit'+
    'Curabitur elit ac purus vitae'+
    'Nec Nunc congue mus sed'+
    'Dui Aliquam sodales Curabitur est'+
    'Quis pellentesque malesuada consectetuer ut'+
    'Elit Nulla velit Suspendisse sit'+
    'Eros Nulla id hac Donec'+
    'Mattis at leo urna mollis' ;

  s := FString;

  sw := TStopwatch.StartNew;
  for i := 0 to 100000-1 do
  begin
    Check(FString.Equals(s, scInvariantIgnoreCase));
  end;

  sw.Stop;

  Status(Format('Equals time: %D ms', [sw.ElapsedMilliseconds]));

  sw := TStopwatch.StartNew;
  for i := 0 to 100000-1 do
  begin
    Check(FString.EqualsEx(s, scInvariantIgnoreCase));
  end;

  sw.Stop;

  Status(Format('EqualsEx time: %D ms', [sw.ElapsedMilliseconds]));

  sw := TStopwatch.StartNew;
  for i := 0 to 100000-1 do
  begin
    Check(SameText(s, FString));
  end;

  sw.Stop;

  Status(Format('SameText time: %D ms', [sw.ElapsedMilliseconds]));
end;

procedure TestTSvString.TestImplicit;
var
  s: TSvString;
begin
  s := 'a';
  Check(s = 'a');
end;

procedure TestTSvString.TestIndexOfSpeed;
var
  i, ix: Integer;
  s: TSvString;
begin
  FString := 'Lorem ipsum dolor sit amet '+
    'Consectetuer dui nec Sed tincidunt'+
    'Nam Vivamus et eget ut'+
    'Id risus condimentum metus ut'+
    'Feugiat metus feugiat Donec congue'+
    'Id dictum adipiscing congue Morbi'+
    'Aenean eget tellus wisi elit'+
    'Curabitur elit ac purus vitae'+
    'Nec Nunc congue mus sed'+
    'Dui Aliquam sodales Curabitur est'+
    'Quis pellentesque malesuada consectetuer ut'+
    'Elit Nulla velit Suspendisse sit'+
    'Eros Nulla id hac Donec'+
    'Mattis at leo urna mollis' ;

  sw := TStopwatch.StartNew;

  for i := 0 to 10000 - 1 do
  begin
    ix := FString.IndexOf('mollis');

    Check(ix = 410);
  end;


  sw.Stop;

  s := 'Testas';
  ix := s.Pos('z');

  Status(Format('IndexOf time: %D ms', [sw.ElapsedMilliseconds]));
  Check(sw.ElapsedMilliseconds < 1000);

  sw := TStopwatch.StartNew;

  for i := 0 to 10000 - 1 do
  begin
    ix := FString.Pos('mollis');

    Check(ix = 410);
  end;


  sw.Stop;

  Status(Format('Pos time: %D ms', [sw.ElapsedMilliseconds]));
  Check(sw.ElapsedMilliseconds < 100);

  sw := TStopwatch.StartNew;

  for i := 0 to 10000 - 1 do
  begin
    ix := FString.Pos('mollis', scInvariantIgnoreCase);

    Check(ix = 410);
  end;


  sw.Stop;

  Status(Format('Pos(ignore case) time: %D ms', [sw.ElapsedMilliseconds]));
  Check(sw.ElapsedMilliseconds < 500);
end;

procedure TestTSvString.TestJoin;
begin
  FString.Join(';', ['First', 'Second', 'Third']);

  Check(FString = 'First;Second;Third');
end;

procedure TestTSvString.TestLoadFromFile;
begin
  FString := '';
  Check(FString = '');
  FString.LoadFromFile('FString.txt');

  Check(FString = cInit);

  FString.LoadFromFile('SQLiteTable3.pas');

  FString.Compress(scMax);

  FString.SaveToFile('SQLiteTable3_compressed.pas');

  FString.LoadFromFile('SQLiteTable3_compressed.pas');

  FString.Decompress;

  FString.SaveToFile('SQLiteTable3_decompressed.pas');
end;

const
  md5_VALUE = '214dfaa473b74771e7e7dddfd72bdd39';

procedure TestTSvString.TestMD5;
begin
  FString := 'somerийandomŠtext12546(83e4h';

  FString.MD5;

  CheckEqualsString(md5_VALUE, FString);
end;

procedure TestTSvString.TestReplace;
var
  i: Integer;
  s: TSvString;
  str, str2: string;
begin
  FString := 'Lorem ipsum dolor sit amet '+
    'Consectetuer dui nec Sed tincidunt'+
    'Nam Vivamus et eget ut'+
    'Id risus condimentum metus ut'+
    'Feugiat metus feugiat Donec congue'+
    'Id dictum adipiscing congue Morbi'+
    'Aenean eget tellus wisi elit'+
    'Curabitur elit ac purus vitae'+
    'Nec Nunc congue mus sed'+
    'Dui Aliquam sodales Curabitur est'+
    'Quis pellentesque malesuada consectetuer ut'+
    'Elit Nulla velit Suspendisse sit'+
    'Eros Nulla id hac Donec'+
    'Mattis at leo urna mollis' ;

  s := FString;
  str := FString;
  str2 := str;
  FString.Replace('a', '1');

  CheckFalse(FString.Contains('a'));

  sw := TStopwatch.StartNew;
  //speed test
  for i := 0 to 10000-1 do
  begin
    FString.Replace('a', '1', scInvariantIgnoreCase);
    FString := s;
  end;

  sw.Stop;
  Status(Format('Replace time: %D ms', [sw.ElapsedMilliseconds]));

  sw := TStopwatch.StartNew;
  //speed test
  for i := 0 to 10000-1 do
  begin
    str := ReplaceText(str, 'a', '1');
    str := str2;
  end;

  sw.Stop;
  Status(Format('ReplaceStr time: %D ms', [sw.ElapsedMilliseconds]));
end;

procedure TestTSvString.TestSaveToFile;
var
  sl: TStringList;
begin
  FString.SaveToFile('FString.txt');

  sl := TStringList.Create;
  try
    sl.LoadFromFile('FString.txt');

    Check(FString = Trim(sl.Text));


  finally
    sl.Free;
  end;
end;

procedure TestTSvString.TestSoundex;
var
  s: string;
begin
  FString := 'Facebook';
  Check(FString.SoundexSimilar('facebooc'));
  Check(FString.SoundexSimilar('faceboock'));

  s := FString.Soundex();
end;

procedure TestTSvString.TestSplit;
var
  arr: TArray<string>;
  i: Integer;
begin
  FString := 'One Two Three Four Five ';

  arr := FString.Split(' ');

  Check(Length(arr)=6);

  arr := FString.Split(' ', True);

  for i := Low(arr) to High(arr) do
  begin
    FString := arr[i];
  end;

  Check(Length(arr)=5);
end;

procedure TestTSvString.TestTrimRight;
var
  s: TSvString;
begin
  s := FString;
  FString.Concat(',');

  FString.TrimRight([',']);

  Check(FString = s);
end;

procedure TestTSvString.TestValueOf;
var
  sText: string;
  i: Integer;
begin
  i := 10;
  sText := 'value of i is ' + TSvString.ValueOf(i) + '.';
  Check(sText = 'value of i is 10.');
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTSvString.Suite);
end.

