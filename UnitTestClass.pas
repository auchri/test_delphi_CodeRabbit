unit UnitTestClass;

interface

type
  TSomeClass = class
    private
      FValue: String;
    public
      constructor Create(const AValue: String = 'foo');
      property Val: String read FValue write FValue;
  end;

implementation

uses System.SysUtils, System.StringUtils;

constructor TSomeClass.Create(const AValue: String);
begin
  var val: String := AValue;
  val := val.PadLeft(10, '_').PadRight(20, '_');
  FValue := val;
end;

end.
