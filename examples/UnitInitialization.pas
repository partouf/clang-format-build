unit UnitInitialization;

interface

type
  TManager = class
  private
    FInstance: TManager;
  public
    class function GetInstance: TManager;
    procedure Initialize;
    procedure Cleanup;
  end;

var
  GlobalCounter: Integer;

implementation

var
  Manager: TManager;

class function TManager.GetInstance: TManager;
begin
  if not Assigned(FInstance) then
    FInstance := TManager.Create;
  Result := FInstance;
end;

procedure TManager.Initialize;
begin
  WriteLn('Manager initialized');
end;

procedure TManager.Cleanup;
begin
  WriteLn('Manager cleanup');
end;

initialization
  GlobalCounter := 0;
  Manager := TManager.Create;
  Manager.Initialize;
  WriteLn('Unit initialization complete');

finalization
  if Assigned(Manager) then
  begin
    Manager.Cleanup;
    Manager.Free;
  end;
  WriteLn('Unit finalization complete');

end.