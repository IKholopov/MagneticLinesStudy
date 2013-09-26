unit WireConfigs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TWireConfigs = class(TForm)

  private
    GLAreaInitialized: boolean;
  public
    constructor Create(TheOwner: TComponent); override;
    //destructor Destroy; override;
  end;

var
  Form1: TMainForm;

implementation

{$R *.lfm}

end.

