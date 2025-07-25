unit virtuals;

interface

uses
  SysUtils,
  System.Classes,
  Virtuals.Interfaces;

type
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

implementation

end.