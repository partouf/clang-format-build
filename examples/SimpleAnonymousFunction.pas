unit SimpleAnonymousFunction;

interface

type
  TProcessor = class
  public
    procedure TestAnonymous;
  end;

implementation

procedure TProcessor.TestAnonymous;
var
  SimpleFunc: TFunc<Integer, string>;
begin
  SimpleFunc := function(X: Integer): string
  begin
    Result := IntToStr(X);
  end;
  
  WriteLn(SimpleFunc(42));
end;

end.