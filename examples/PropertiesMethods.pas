unit PropertiesAndMethods;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections;

type
  TPropertyExample = class(TInterfacedObject)
  private
    FName: string;
    FAge: Integer;
    FItems: TList<string>;
    function GetFullInfo: string;
    procedure SetAge(const Value: Integer);
  protected
    function ValidateAge(const Age: Integer): Boolean; virtual;
  public
    constructor Create(const AName: string);
    destructor Destroy; override;
    
    property Name: string read FName write FName;
    property Age: Integer read FAge write SetAge;
    property FullInfo: string read GetFullInfo;
    property Items: TList<string> read FItems;
  end;

  TAdvancedClass = class(TPropertyExample)
  private
    FEmail: string;
    class var FInstanceCount: Integer;
  protected
    function ValidateAge(const Age: Integer): Boolean; override;
  public
    class constructor Create;
    class destructor Destroy;
    
    class property InstanceCount: Integer read FInstanceCount;
    property Email: string read FEmail write FEmail;
  end;

implementation

{ TPropertyExample }

constructor TPropertyExample.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
  FAge := 0;
  FItems := TList<string>.Create;
end;

destructor TPropertyExample.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TPropertyExample.GetFullInfo: string;
begin
  Result := Format('%s (Age: %d)', [FName, FAge]);
end;

procedure TPropertyExample.SetAge(const Value: Integer);
begin
  if ValidateAge(Value) then
    FAge := Value
  else
    raise Exception.Create('Invalid age');
end;

function TPropertyExample.ValidateAge(const Age: Integer): Boolean;
begin
  Result := (Age >= 0) and (Age <= 150);
end;

{ TAdvancedClass }

class constructor TAdvancedClass.Create;
begin
  FInstanceCount := 0;
end;

class destructor TAdvancedClass.Destroy;
begin
  // Cleanup if needed
end;

function TAdvancedClass.ValidateAge(const Age: Integer): Boolean;
begin
  Result := (Age >= 18) and (Age <= 100);
end;

end.