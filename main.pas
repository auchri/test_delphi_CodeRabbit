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
   X := A[0];
   for I := 1 to N - 1 do
     if X < A[I] then X := A[I];
   Max := X;
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
