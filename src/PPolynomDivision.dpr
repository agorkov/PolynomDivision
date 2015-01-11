program PPolynomDivision;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TRFraction = record
    u, d: integer;
  end;

  TPol = array of TRFraction;

var
  a, b, Res, t: TPol;
  N: integer;

procedure FrucSimplify(var a: TRFraction);
var
  i: word;
begin
  i := 2;
  while i <= a.d do
  begin
    if (a.u mod i = 0) and (a.d mod i = 0) then
    begin
      a.u := a.u div i;
      a.d := a.d div i;
    end
    else
      i := i + 1;
  end;
end;

function FrucDivision(a, b: TRFraction): TRFraction;
var
  tmp: TRFraction;
begin
  tmp.u := a.u * b.d;
  tmp.d := a.d * b.u;
  FrucSimplify(tmp);
  Result := tmp;
end;

function FrucMultiplication(a, b: TRFraction): TRFraction;
var
  tmp: TRFraction;
begin
  tmp.u := a.u * b.u;
  tmp.d := a.d * b.d;
  FrucSimplify(tmp);
  Result := tmp;
end;

function FrucSubstraction(a, b: TRFraction): TRFraction;
var
  tmp: TRFraction;
begin
  a.u := a.u * b.d;
  b.u := b.u * a.d;
  tmp.u := a.u - b.u;
  tmp.d := a.d * b.d;
  FrucSimplify(tmp);
  Result := tmp;
end;

procedure MultiplicatinFracPol(
  a: TPol;
  power: integer;
  f: TRFraction);
var
  i: integer;
begin
  for i := 0 to N do
  begin
    t[i].u := 0;
    t[i].d := 1;
  end;
  for i := 0 to N do
    t[i + power] := FrucMultiplication(
      a[i],
      f);
end;

procedure PolSubstraction;
var
  i: integer;
begin
  for i := 0 to N do
    a[i] := FrucSubstraction(
      a[i],
      t[i]);
end;

function MaxPower(P: TPol): integer;
var
  i: integer;
  pow: integer;
begin
  pow := 0;
  for i := 0 to N do
    if P[i].u <> 0 then
      pow := i;
  Result := pow;
end;

procedure input;
var
  f: TextFile;
  i: integer;
begin
  AssignFile(
    f,
    'input.txt');
  reset(f);
  readln(
    f,
    N);
  a := nil;
  SetLength(
    a,
    N + 1);
  b := nil;
  SetLength(
    b,
    N + 1);
  Res := nil;
  SetLength(
    Res,
    N + 1);
  t := nil;
  SetLength(
    t,
    N + 1);
  for i := 0 to N do
  begin
    readln(
      f,
      a[i].u);
    a[i].d := 1;
  end;
  for i := 0 to N do
  begin
    readln(
      f,
      b[i].u);
    b[i].d := 1;
  end;
  for i := 0 to N do
  begin
    Res[i].u := 0;
    Res[i].d := 1;
  end;
  CloseFile(f);
end;

procedure output;
var
  f: TextFile;
  i: byte;
  str: string;
begin
  AssignFile(
    f,
    'output.txt');
  rewrite(f);
  writeln(
    f,
    MaxPower(Res));
  for i := MaxPower(Res) downto 0 do
  begin
    str := '';
    if Res[i].u = 0 then
      str := '0'
    else
      if Res[i].d = 1 then
        str := inttostr(Res[i].u)
      else
        str := inttostr(Res[i].u) + '/' + inttostr(Res[i].d);
    writeln(
      f,
      str);
  end;
  writeln(
    f,
    MaxPower(a));
  for i := MaxPower(a) downto 0 do
  begin
    str := '';
    if a[i].u = 0 then
      str := '0'
    else
      if a[i].d = 1 then
        str := inttostr(a[i].u)
      else
        str := inttostr(a[i].u) + '/' + inttostr(a[i].d);
    writeln(
      f,
      str);
  end;
  CloseFile(f);
end;

function notnull: boolean;
var
  i: byte;
  fl: boolean;
begin
  fl := false;
  for i := 0 to N do
    if a[i].u <> 0 then
      fl := true;
  Result := fl;
end;

begin
  try
    input;
    while (MaxPower(a) >= MaxPower(b)) and (notnull) do
    begin
      Res[MaxPower(a) - MaxPower(b)] := FrucDivision(
        a[MaxPower(a)],
        b[MaxPower(b)]);
      MultiplicatinFracPol(
        b,
        MaxPower(a) - MaxPower(b),
        Res[MaxPower(a) - MaxPower(b)]);
      PolSubstraction;
    end;
    output;
  except
    on E: Exception do
      writeln(
        E.ClassName,
        ': ',
        E.Message);
  end;

end.
