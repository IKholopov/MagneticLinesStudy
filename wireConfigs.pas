unit WireConfigs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, Forms;
 {$M+}
type
  TWireConfig = class(TObject)
  private

  public
        procedure Load(Form: TForm); virtual;
        function Calculate():boolean; virtual;
  end;

  {ThreeRingsConfig}
  ThreeRingsConfig = class(TWireConfig)
          RadiusLabel:TLabel;
          EditRadius: TEdit;
          AmperageLabel:TLabel;
          EditI: TEdit;
          UpdateConfigButton: TButton;
  private

  public
         procedure Load(Form: TForm); override;
         function Calculate(): boolean; override;
  end;

implementation


     {TWireConfig}
procedure  TWireConfig.Load(Form: TForm);
begin
  raise exception.Create('Absract class TWireConfig doesnt implement Load(Form)');
end;

function TWireConfig.Calculate(): boolean;
begin
  raise exception.Create('Absract class TWireConfig doesnt implement Calculate()');
end;

     {ThreeRingsConfig}
procedure  ThreeRingsConfig.Load(Form: TForm);
begin
  RadiusLabel := TLabel.Create(Form);
  with RadiusLabel do begin
     Caption := 'Radius:';
     SetBounds(10,32, 40, 40);
     Parent := Form;
  end;
  EditRadius := TEdit.Create(Form);
  with EditRadius do begin
    Text := '5';
    Parent := Form;
    SetBounds(70,30, 100, 40);
  end;

  AmperageLabel := TLabel.Create(Form);
  with AmperageLabel do begin
     Caption := 'Amperage:';
     SetBounds(10,62, 40, 40);
     Parent := Form;
  end;
  EditI := TEdit.Create(Form);
  with EditI do begin
    Text := '2';
    Parent := Form;
    SetBounds(70,60, 100, 40);
  end;
end;

function ThreeRingsConfig.Calculate(): boolean;
begin
  Result := true;
end;

end.
