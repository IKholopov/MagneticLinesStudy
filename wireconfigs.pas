unit WireConfigs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, Forms, GL;
 {$M+}
type
  TWireConfig = class(TObject)
  private

  public
        procedure Load(Form: TForm); virtual;
        function Calculate():boolean; virtual;
        procedure DrawWire(); virtual;
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
         procedure DrawWire(); override;
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

procedure  TWireConfig.DrawWire();
begin
  raise exception.Create('Absract class TWireConfig doesnt implement DrawWire()');
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

procedure  ThreeRingsConfig.DrawWire();
const Pi2 = 2 * Pi;
var i ,j, k, n, numc, numt, offset: integer;
  s, t, x, y, z: double;
  torus: GLuint;
begin
    torus := glGenLists(1);
    numc := 2;
    numt := 50;
    offset := -1;
    glNewList(torus, GL_COMPILE);
    for n := 0 to 2 do begin
       for i := 0 to numc - 1 do begin
             glBegin(GL_QUAD_STRIP);
              for j := 0 to numt do begin
                      for k := 1 downto 0 do begin
                      s := (i + k) mod numc + 0.5;
                      t := j mod numt;
                      x := (1 + 0.1*cos(s * Pi2/numc))*cos(t*Pi2/numt);
                      y := (1 + 0.1*cos(s * Pi2/numc))*sin(t*Pi2/numt);
                      z := offset*2 + 0.1*sin(s * Pi2/numc);
                      glColor3f(0.4, 0.25, 0.25);
                      glVertex3f(x, y, z);
                      end;
              end;
              glEnd;
       end;
       offset := offset + 1;
    end;
    glEndList();

    glCallList(torus);
end;

end.
