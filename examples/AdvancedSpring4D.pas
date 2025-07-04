unit AdvancedSpring4D;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  SysUtils,
  Spring.Container,
  Spring.Collections,
  Spring.Services;

type
  // Interface with GUID
  IHandler = interface
    ['{B92F8AF7-8F8B-4F8C-8B8F-8F8B8F8C8F8B}']
    function CanHandle(const ARequest: string): Boolean;
    procedure Handle(const ARequest: string);
    procedure SetNext(const ANext: IHandler);
  end;

  ILogger = interface
    ['{A92F8AF7-8F8B-4F8C-8B8F-8F8B8F8C8F8A}']
    procedure Log(const AMessage: string);
  end;

  IRepository = interface
    ['{C92F8AF7-8F8B-4F8C-8B8F-8F8B8F8C8F8C}']
    function FindById(const AId: Integer): string;
    procedure Save(const AEntity: string);
  end;

  // Abstract base handler
  TBaseHandler = class(TInterfacedObject, IHandler)
  private
    FNext: IHandler;
    FLogger: ILogger;
  protected
    constructor Create(const ALogger: ILogger);
  public
    function CanHandle(const ARequest: string): Boolean; virtual; abstract;
    procedure Handle(const ARequest: string); virtual;
    procedure SetNext(const ANext: IHandler);
  end;

  // Concrete handlers  
  TValidationHandler = class(TBaseHandler)
  public
    function CanHandle(const ARequest: string): Boolean; override;
    procedure Handle(const ARequest: string); override;
  end;

  TAuthorizationHandler = class(TBaseHandler)
  private
    FRepository: IRepository;
  public
    constructor Create(const ALogger: ILogger; const ARepository: IRepository);
    function CanHandle(const ARequest: string): Boolean; override;
    procedure Handle(const ARequest: string); override;
  end;

  // Service implementations
  TConsoleLogger = class(TInterfacedObject, ILogger)
  public
    procedure Log(const AMessage: string);
  end;

  TMemoryRepository = class(TInterfacedObject, IRepository)
  private
    FData: IList<string>;
  public
    constructor Create;
    destructor Destroy; override;
    function FindById(const AId: Integer): string;
    procedure Save(const AEntity: string);
  end;

  // Chain of responsibility coordinator
  TChainCoordinator = class
  private
    FFirstHandler: IHandler;
    FContainer: TContainer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure BuildChain;
    procedure ProcessRequest(const ARequest: string);
  end;

implementation

{ TBaseHandler }

constructor TBaseHandler.Create(const ALogger: ILogger);
begin
  inherited Create;
  FLogger := ALogger;
end;

procedure TBaseHandler.Handle(const ARequest: string);
begin
  if CanHandle(ARequest) then
  begin
    FLogger.Log('Handling request: ' + ARequest);
    // Specific handling logic would go here
  end
  else if Assigned(FNext) then
    FNext.Handle(ARequest)
  else
    FLogger.Log('No handler found for: ' + ARequest);
end;

procedure TBaseHandler.SetNext(const ANext: IHandler);
begin
  FNext := ANext;
end;

{ TValidationHandler }

function TValidationHandler.CanHandle(const ARequest: string): Boolean;
begin
  Result := Pos('validate', LowerCase(ARequest)) > 0;
end;

procedure TValidationHandler.Handle(const ARequest: string);
begin
  if CanHandle(ARequest) then
  begin
    FLogger.Log('Validating request: ' + ARequest);
    // Validation logic here
  end
  else
    inherited Handle(ARequest);
end;

{ TAuthorizationHandler }

constructor TAuthorizationHandler.Create(const ALogger: ILogger; const ARepository: IRepository);
begin
  inherited Create(ALogger);
  FRepository := ARepository;
end;

function TAuthorizationHandler.CanHandle(const ARequest: string): Boolean;
begin
  Result := Pos('authorize', LowerCase(ARequest)) > 0;
end;

procedure TAuthorizationHandler.Handle(const ARequest: string);
begin
  if CanHandle(ARequest) then
  begin
    FLogger.Log('Authorizing request: ' + ARequest);
    // Check repository for authorization - inline variable example
    var userData := FRepository.FindById(1);
    FLogger.Log('User data: ' + userData);
  end
  else
    inherited Handle(ARequest);
end;

{ TConsoleLogger }

procedure TConsoleLogger.Log(const AMessage: string);
begin
  WriteLn('[LOG] ', AMessage);
end;

{ TMemoryRepository }

constructor TMemoryRepository.Create;
begin
  inherited Create;
  FData := TCollections.CreateList<string>;
  FData.Add('User1 Data');
  FData.Add('User2 Data');
end;

function TMemoryRepository.FindById(const AId: Integer): string;
begin
  if (AId >= 1) and (AId <= FData.Count) then
    Result := FData[AId - 1]
  else
    Result := 'User not found';
end;

procedure TMemoryRepository.Save(const AEntity: string);
begin
  FData.Add(AEntity);
end;

{ TChainCoordinator }

constructor TChainCoordinator.Create;
begin
  inherited Create;
  FContainer := TContainer.Create;
  
  // Register dependencies
  FContainer.RegisterType<ILogger, TConsoleLogger>.AsSingleton;
  FContainer.RegisterType<IRepository, TMemoryRepository>.AsSingleton;
  
  // Register handlers with dependency injection
  FContainer.RegisterType<TValidationHandler>.InjectConstructor([TypeInfo(ILogger)]);
  FContainer.RegisterType<TAuthorizationHandler>.InjectConstructor([TypeInfo(ILogger), TypeInfo(IRepository)]);
  
  FContainer.Build;
end;

procedure TChainCoordinator.BuildChain;
var
  validationHandler: IHandler;
  authHandler: IHandler;
begin
  // Resolve handlers from container
  validationHandler := FContainer.Resolve<TValidationHandler>;
  authHandler := FContainer.Resolve<TAuthorizationHandler>;
  
  // Build the chain
  validationHandler.SetNext(authHandler);
  
  FFirstHandler := validationHandler;
end;

procedure TChainCoordinator.ProcessRequest(const ARequest: string);
begin
  if Assigned(FFirstHandler) then
    FFirstHandler.Handle(ARequest)
  else
    WriteLn('Chain not built');
end;

end.