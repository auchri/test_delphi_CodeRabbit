program TestMain;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

// Copy of the Max function from main.pas to test
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

// Test framework variables
var
  TestsPassed: Integer = 0;
  TestsFailed: Integer = 0;
  TestName: string;

procedure AssertEquals(Expected, Actual: Real; const Msg: string);
begin
  if Abs(Expected - Actual) < 0.0001 then
  begin
    Inc(TestsPassed);
    WriteLn('  PASS: ', Msg);
  end
  else
  begin
    Inc(TestsFailed);
    WriteLn('  FAIL: ', Msg);
    WriteLn('    Expected: ', Expected:0:4, ', Actual: ', Actual:0:4);
  end;
end;

procedure AssertException(Proc: TProc; const Msg: string);
var
  ExceptionRaised: Boolean;
begin
  ExceptionRaised := False;
  try
    Proc();
  except
    on EArgumentException do
      ExceptionRaised := True;
  end;

  if ExceptionRaised then
  begin
    Inc(TestsPassed);
    WriteLn('  PASS: ', Msg);
  end
  else
  begin
    Inc(TestsFailed);
    WriteLn('  FAIL: ', Msg, ' (Expected exception was not raised)');
  end;
end;

procedure TestMaxWithPositiveNumbers;
var
  Result: Real;
begin
  WriteLn('TestMaxWithPositiveNumbers:');
  Result := Max([1.0, 5.0, 3.0, 9.0, 2.0], 5);
  AssertEquals(9.0, Result, 'Max of positive numbers should be 9.0');
end;

procedure TestMaxWithNegativeNumbers;
var
  Result: Real;
begin
  WriteLn('TestMaxWithNegativeNumbers:');
  Result := Max([-1.0, -5.0, -3.0, -9.0, -2.0], 5);
  AssertEquals(-1.0, Result, 'Max of negative numbers should be -1.0');
end;

procedure TestMaxWithMixedNumbers;
var
  Result: Real;
begin
  WriteLn('TestMaxWithMixedNumbers:');
  Result := Max([-5.0, 3.0, -2.0, 8.0, 1.0], 5);
  AssertEquals(8.0, Result, 'Max of mixed numbers should be 8.0');
end;

procedure TestMaxWithSingleElement;
var
  Result: Real;
begin
  WriteLn('TestMaxWithSingleElement:');
  Result := Max([42.0], 1);
  AssertEquals(42.0, Result, 'Max of single element should be that element');
end;

procedure TestMaxWithNLessThanArrayLength;
var
  Result: Real;
begin
  WriteLn('TestMaxWithNLessThanArrayLength:');
  Result := Max([1.0, 5.0, 3.0, 9.0, 2.0], 3);
  AssertEquals(5.0, Result, 'Max of first 3 elements should be 5.0');
end;

procedure TestMaxWithNEqualsArrayLength;
var
  Result: Real;
begin
  WriteLn('TestMaxWithNEqualsArrayLength:');
  Result := Max([1.0, 5.0, 3.0], 3);
  AssertEquals(5.0, Result, 'Max should handle N = array length');
end;

procedure TestMaxWithNGreaterThanArrayLength;
var
  Result: Real;
begin
  WriteLn('TestMaxWithNGreaterThanArrayLength:');
  Result := Max([1.0, 5.0, 3.0], 10);
  AssertEquals(5.0, Result, 'Max should auto-adjust N to array length');
end;

procedure TestMaxWithDuplicates;
var
  Result: Real;
begin
  WriteLn('TestMaxWithDuplicates:');
  Result := Max([7.0, 7.0, 7.0, 7.0], 4);
  AssertEquals(7.0, Result, 'Max with all duplicates should return that value');
end;

procedure TestMaxWithDuplicateMaxValues;
var
  Result: Real;
begin
  WriteLn('TestMaxWithDuplicateMaxValues:');
  Result := Max([1.0, 9.0, 5.0, 9.0, 3.0], 5);
  AssertEquals(9.0, Result, 'Max should handle duplicate max values');
end;

procedure TestMaxWithZeroAndPositive;
var
  Result: Real;
begin
  WriteLn('TestMaxWithZeroAndPositive:');
  Result := Max([0.0, 5.0, 3.0], 3);
  AssertEquals(5.0, Result, 'Max with zero and positive should be positive');
end;

procedure TestMaxWithZeroAndNegative;
var
  Result: Real;
begin
  WriteLn('TestMaxWithZeroAndNegative:');
  Result := Max([0.0, -5.0, -3.0], 3);
  AssertEquals(0.0, Result, 'Max with zero and negative should be zero');
end;

procedure TestMaxWithFloatingPoint;
var
  Result: Real;
begin
  WriteLn('TestMaxWithFloatingPoint:');
  Result := Max([1.5, 2.3, 5.7, 3.2], 4);
  AssertEquals(5.7, Result, 'Max should handle floating point numbers');
end;

procedure TestMaxWithVerySmallDifferences;
var
  Result: Real;
begin
  WriteLn('TestMaxWithVerySmallDifferences:');
  Result := Max([1.0001, 1.0002, 1.0003], 3);
  AssertEquals(1.0003, Result, 'Max should handle very small differences');
end;

procedure TestMaxWithLargeNumbers;
var
  Result: Real;
begin
  WriteLn('TestMaxWithLargeNumbers:');
  Result := Max([1000000.0, 999999.0, 1000001.0], 3);
  AssertEquals(1000001.0, Result, 'Max should handle large numbers');
end;

procedure TestMaxWithEmptyArray;
begin
  WriteLn('TestMaxWithEmptyArray:');
  AssertException(
    procedure
    var
      Arr: array of Real;
      Res: Real;
    begin
      SetLength(Arr, 0);
      Res := Max(Arr, 1);
    end,
    'Empty array should raise EArgumentException'
  );
end;

procedure TestMaxWithNZero;
begin
  WriteLn('TestMaxWithNZero:');
  AssertException(
    procedure
    var
      Res: Real;
    begin
      Res := Max([1.0, 2.0, 3.0], 0);
    end,
    'N=0 should raise EArgumentException'
  );
end;

procedure TestMaxWithNNegative;
begin
  WriteLn('TestMaxWithNNegative:');
  AssertException(
    procedure
    var
      Res: Real;
    begin
      Res := Max([1.0, 2.0, 3.0], -1);
    end,
    'Negative N should raise EArgumentException'
  );
end;

procedure TestMaxWithEmptyArrayAndNZero;
begin
  WriteLn('TestMaxWithEmptyArrayAndNZero:');
  AssertException(
    procedure
    var
      Arr: array of Real;
      Res: Real;
    begin
      SetLength(Arr, 0);
      Res := Max(Arr, 0);
    end,
    'Empty array with N=0 should raise EArgumentException'
  );
end;

procedure TestMaxAtFirstPosition;
var
  Result: Real;
begin
  WriteLn('TestMaxAtFirstPosition:');
  Result := Max([10.0, 5.0, 3.0, 1.0], 4);
  AssertEquals(10.0, Result, 'Max at first position should be found');
end;

procedure TestMaxAtLastPosition;
var
  Result: Real;
begin
  WriteLn('TestMaxAtLastPosition:');
  Result := Max([1.0, 3.0, 5.0, 10.0], 4);
  AssertEquals(10.0, Result, 'Max at last position should be found');
end;

procedure TestMaxInMiddlePosition;
var
  Result: Real;
begin
  WriteLn('TestMaxInMiddlePosition:');
  Result := Max([1.0, 10.0, 5.0, 3.0], 4);
  AssertEquals(10.0, Result, 'Max in middle position should be found');
end;

procedure TestMaxWithNEqualsOne;
var
  Result: Real;
begin
  WriteLn('TestMaxWithNEqualsOne:');
  Result := Max([5.0, 10.0, 3.0], 1);
  AssertEquals(5.0, Result, 'Max with N=1 should return first element');
end;

procedure TestMaxWithTwoElements;
var
  Result: Real;
begin
  WriteLn('TestMaxWithTwoElements:');
  Result := Max([3.0, 7.0], 2);
  AssertEquals(7.0, Result, 'Max with two elements should return larger');
end;

procedure TestMaxBoundaryLargeArray;
var
  Arr: array of Real;
  I: Integer;
  Result: Real;
begin
  WriteLn('TestMaxBoundaryLargeArray:');
  SetLength(Arr, 1000);
  for I := 0 to 999 do
    Arr[I] := I * 1.0;
  Result := Max(Arr, 1000);
  AssertEquals(999.0, Result, 'Max should handle large arrays efficiently');
end;

procedure TestMaxPartialLargeArray;
var
  Arr: array of Real;
  I: Integer;
  Result: Real;
begin
  WriteLn('TestMaxPartialLargeArray:');
  SetLength(Arr, 1000);
  for I := 0 to 999 do
    Arr[I] := I * 1.0;
  // Max of first 100 elements should be 99
  Result := Max(Arr, 100);
  AssertEquals(99.0, Result, 'Max with N < large array length should work correctly');
end;

begin
  WriteLn('');
  WriteLn('========================================');
  WriteLn('Running Comprehensive Tests for Max Function');
  WriteLn('========================================');
  WriteLn('');

  try
    // Normal cases
    TestMaxWithPositiveNumbers;
    TestMaxWithNegativeNumbers;
    TestMaxWithMixedNumbers;
    TestMaxWithSingleElement;
    TestMaxWithDuplicates;
    TestMaxWithDuplicateMaxValues;
    TestMaxWithZeroAndPositive;
    TestMaxWithZeroAndNegative;
    TestMaxWithFloatingPoint;
    TestMaxWithVerySmallDifferences;
    TestMaxWithLargeNumbers;
    TestMaxWithTwoElements;

    // Boundary cases with N parameter
    TestMaxWithNLessThanArrayLength;
    TestMaxWithNEqualsArrayLength;
    TestMaxWithNGreaterThanArrayLength;
    TestMaxWithNEqualsOne;

    // Position tests
    TestMaxAtFirstPosition;
    TestMaxAtLastPosition;
    TestMaxInMiddlePosition;

    // Error cases
    TestMaxWithEmptyArray;
    TestMaxWithNZero;
    TestMaxWithNNegative;
    TestMaxWithEmptyArrayAndNZero;

    // Performance/stress tests
    TestMaxBoundaryLargeArray;
    TestMaxPartialLargeArray;

    WriteLn('');
    WriteLn('========================================');
    WriteLn('Test Results:');
    WriteLn('  Passed: ', TestsPassed);
    WriteLn('  Failed: ', TestsFailed);
    WriteLn('  Total:  ', TestsPassed + TestsFailed);
    WriteLn('========================================');

    if TestsFailed = 0 then
    begin
      WriteLn('All tests passed!');
      ExitCode := 0;
    end
    else
    begin
      WriteLn('Some tests failed!');
      ExitCode := 1;
    end;
  except
    on E: Exception do
    begin
      WriteLn('Unexpected error during testing: ', E.ClassName, ': ', E.Message);
      ExitCode := 2;
    end;
  end;

  WriteLn('');
  WriteLn('Press Enter to exit...');
  ReadLn;
end.