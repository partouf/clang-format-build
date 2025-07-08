unit GenericsAndOverrides;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  SysUtils,
  Generics.Collections;

type
  // Generic interface
  IProcessor<T> = interface
    ['{B92F8AF7-8F8B-4F8C-8B8F-8F8B8F8C8F8B}']
    function Process(const AItem: T): T;
    procedure Add(const AItem: T);
  end;

  // Base class with generics
  TBaseProcessor<T> = class(TInterfacedObject, IProcessor<T>)
  private
    FItems: TList<T>;
  protected
    constructor Create;
  public
    destructor Destroy; override;
    function Process(const AItem: T): T; virtual; abstract;
    procedure Add(const AItem: T); virtual;
  end;

  // Concrete implementations
  TStringProcessor = class(TBaseProcessor<string>)
  public
    function Process(const AItem: string): string; override;
    procedure Add(const AItem: string); override;
  end;

implementation

{ TBaseProcessor<T> }

constructor TBaseProcessor<T>.Create;
begin
  inherited Create;
  FItems := TList<T>.Create;
end;

destructor TBaseProcessor<T>.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TBaseProcessor<T>.Add(const AItem: T);
begin
  FItems.Add(AItem);
end;

{ TStringProcessor }

function TStringProcessor.Process(const AItem: string): string;
begin
  // Inline variable example
  var processed := UpperCase(AItem);
  Result := processed + '_PROCESSED';
end;

procedure TStringProcessor.Add(const AItem: string);
begin
  if Length(AItem) > 0 then
    inherited Add(AItem);
end;

end.