unit Company.DataProcessor;

interface

uses
  Company.DataProcessor.Interfaces;

type
  TDataProcessor = class(TInterfacedObject, IDataProcessor)
  private
    FTimestamp: TDateTime;
    FSecondaryData: string;
    FContent: string;
    FTitle: string;
    FMetadata: string;
    FPrimaryData: string;

    procedure SetMetadata(const Value: string);
    procedure SetSecondaryData(const Value: string);
    procedure SetPrimaryData(const Value: string);
    procedure SetContent(const Value: string);
    procedure SetTimestamp(const Value: TDateTime);
    procedure SetTitle(const Value: string);

    function GetMetadata: string;
    function GetSecondaryData: string;
    function GetPrimaryData: string;
    function GetContent: string;
    function GetTimestamp: TDateTime;
    function GetTitle: string;
  public
    property PrimaryData: string read GetPrimaryData write SetPrimaryData;
    property SecondaryData: string read GetSecondaryData write SetSecondaryData;
    property Metadata: string read GetMetadata write SetMetadata;
    property Content: string read GetContent write SetContent;
    property Title: string read GetTitle write SetTitle;
    property Timestamp: TDateTime read GetTimestamp write SetTimestamp;
  end;

implementation

{ TDataProcessor }

function TDataProcessor.GetMetadata: string;
begin
  Result := FMetadata;
end;

function TDataProcessor.GetSecondaryData: string;
begin
  Result := FSecondaryData;
end;

function TDataProcessor.GetPrimaryData: string;
begin
  Result := FPrimaryData;
end;

function TDataProcessor.GetContent: string;
begin
  Result := FContent;
end;

function TDataProcessor.GetTimestamp: TDateTime;
begin
  Result := FTimestamp;
end;

function TDataProcessor.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TDataProcessor.SetMetadata(const Value: string);
begin
  FMetadata := Value;
end;

procedure TDataProcessor.SetSecondaryData(const Value: string);
begin
  FSecondaryData := Value;
end;

procedure TDataProcessor.SetPrimaryData(const Value: string);
begin
  FPrimaryData := Value;
end;

procedure TDataProcessor.SetContent(const Value: string);
begin
  FContent := Value;
end;

procedure TDataProcessor.SetTimestamp(const Value: TDateTime);
begin
  FTimestamp := Value;
end;

procedure TDataProcessor.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

end.