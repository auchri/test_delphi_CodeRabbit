program Project2;
 
{$APPTYPE CONSOLE}
 
{$R *.res}
 
uses
  System.SysUtils;
 
begin
  var test: Integer;
  try
    WriteLn('Hello world!');
    test := 5;
    ShowMessage(test.ToString);
    ReadLn;

    for var i: Integer in [1, 5, 7] do begin
      ShowMessage(i.ToString);
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
