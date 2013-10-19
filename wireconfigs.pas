unit WireConfigs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, Forms, GL;
 {$M+}
type
  vector3 = record
          X, Y, Z: extended;
  end;

  TWireConfig = class(TObject)
  private
        Vectors: array[0..199] of vector3;
  public
        procedure Load(Form: TForm); virtual;
        function Calculate(x, y, z: real):boolean; virtual;
        procedure DrawWire(); virtual;
  end;

  {ThreeRingsConfig}
  ThreeRingsConfig = class(TWireConfig)
          RadiusLabel:TLabel;
          EditRadius: TEdit;
          AmperageLabel:TLabel;
          EditI: TEdit;
          DistanceLabel:TLabel;
          DistanceEdit: TEdit;
          UpdateConfigButton: TButton;
  private
         TorusDistance: real;
         Amperage:real;
         TorusRadius: real;
         function BField(x, y, z: extended): vector3;
         procedure EditIUpdate(Sender: TObject);
         procedure DistanceEditUpdate(Sender: TObject);
         procedure RadiusEditUpdate(Sender: TObject);

  public
         procedure Load(Form: TForm); override;
         function Calculate(x, y, z: real): boolean; override;
         procedure DrawWire(); override;
  end;

implementation


     {TWireConfig}
procedure  TWireConfig.Load(Form: TForm);
begin
  raise exception.Create('Absract class TWireConfig doesnt implement Load(Form)');
end;

function TWireConfig.Calculate(x, y, z: real): boolean;
begin
  raise exception.Create('Absract class TWireConfig doesnt implement Calculate()');
end;

procedure  TWireConfig.DrawWire();
begin
  raise exception.Create('Absract class TWireConfig doesnt implement DrawWire()');
end;

     {ThreeRingsConfig}
procedure  ThreeRingsConfig.Load(Form: TForm);
begin
  Amperage := 0;
  TorusRadius := 1;
  TorusDistance := 1;

  RadiusLabel := TLabel.Create(Form);
  with RadiusLabel do begin
     Caption := 'Radius:';
     SetBounds(10,32, 40, 40);
     Parent := Form;
  end;
  EditRadius := TEdit.Create(Form);
  with EditRadius do begin
    Text := FloatToStr(TorusRadius);
    OnChange := @RadiusEditUpdate;
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
    Text := FloatToStr(Amperage);
    Parent := Form;
    OnChange := @EditIUpdate;
    SetBounds(70,60, 100, 40);
  end;
  DistanceLabel := TLabel.Create(Form);
  with DistanceLabel do begin
     Caption := 'Distance:';
     SetBounds(10,92, 40, 40);
     Parent := Form;
  end;
  DistanceEdit := TEdit.Create(Form);
  with DistanceEdit do begin
    Text := FloatToStr(TorusDistance);
    Parent := Form;
    OnChange := @DistanceEditUpdate;
    SetBounds(70,90, 100, 40);
  end;
end;

procedure ThreeRingsConfig.RadiusEditUpdate(Sender: TObject);
begin
    TryStrToFloat(EditRadius.Text, TorusRadius);
end;
procedure ThreeRingsConfig.EditIUpdate(Sender: TObject);
begin
     TryStrToFloat(EditI.Text, Amperage);
end;
procedure ThreeRingsConfig.DistanceEditUpdate(Sender: TObject);
begin
    TryStrToFloat(DistanceEdit.Text, TorusDistance);
end;
//Calculations
function ThreeRingsConfig.Calculate(x, y, z: real): boolean;
begin

  Result := true;
end;

function ThreeRingsConfig.BField(x, y, z:extended):vector3;
begin

end;

procedure  ThreeRingsConfig.DrawWire();
const Pi2 = 2 * Pi;
var i ,j, k, n, numc, numt: integer;
  s, t, x, y, z, offset: double;
  torus: GLuint;
begin
    torus := glGenLists(1);
    numc := 5;
    numt := 50;
    offset := -TorusDistance;
    glNewList(torus, GL_COMPILE);
    for n := 0 to 2 do begin
       for i := 0 to numc - 1 do begin
             glBegin(GL_QUAD_STRIP);
              for j := 0 to numt do begin
                      for k := 1 downto 0 do begin
                      s := (i + k) mod numc + 0.5;
                      t := j mod numt;
                      x := (TorusRadius + 0.1*cos(s * Pi2/numc))*cos(t*Pi2/numt);
                      y := (TorusRadius + 0.1*cos(s * Pi2/numc))*sin(t*Pi2/numt);
                      z := offset*2 + 0.1*sin(s * Pi2/numc);
                      glColor3f(1, 0.3, 0.25);
                      glVertex3f(x, y, z);
                      end;
              end;
              glEnd;
       end;
       offset := offset + TorusDistance;
    end;
    glEndList();

    glCallList(torus);
end;

end.

