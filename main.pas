program Project2;
 
{$APPTYPE CONSOLE}
 
{$R *.res}
 
uses
  System.SysUtils;
 
begin
  try
    WriteLn('Hello world!');
    ReadLn;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.