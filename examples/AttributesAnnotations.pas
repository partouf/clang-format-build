unit AttributesAnnotations;

interface

type
  [AttributeUsage([atClass])]
  TMyAttribute = class(TCustomAttribute)
  end;

  [Required]
  TUser = class
  private
    FName: string;
  public
    [Cached]
    function GetName: string;
  end;

implementation

[Logged]
function TUser.GetName: string;
begin
  Result := FName;
end;

end.