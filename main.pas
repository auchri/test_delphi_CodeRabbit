program Project2;
 
{$APPTYPE CONSOLE}
 
{$R *.res}
 
uses
  System.SysUtils;

  function Max(A: array of Real; N: Integer): Real;
 var
   X: Real;
   I: Integer;
 begin
   if (N <= 0) or (Length(A) = 0) then
     raise EArgumentException.Create('Max: N must be > 0 and array must not be empty');
   if N > Length(A) then
     N := Length(A);
   X := A[0];
   for I := 1 to N - 1 do
     if X < A[I] then X := A[I];
   Result := X;
 end;
 
begin
  try
    var test: Integer := '7';
    WriteLn('Hello world!');
    ReadLn;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
