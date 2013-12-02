unit WireAndCoil;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, ComCtrls, Forms, Dialogs, GL, regularwireConfig, irregularwireConfig, vector4unit;

  {$M+}
type
  {TWireAndCoilConfig}
  TWireAndCoilConfig = class(TIrregularWireConfig)
  const      x1=0;
             y1=0;
  var
    REdit: TEdit;
    RLabel: TLabel;
    I1Edit: TEdit;
    I1Label: TLabel;
    I2Edit: TEdit;
    I2Label: TLabel;
  private
    Radius, Amperage1, Amperage2: real;
    procedure RUpdate(Sender: TObject);
    procedure I1Update(Sender: TObject);
    procedure I2Update(Sender: TObject);

  public
    procedure Load(Form: TForm); override;
    procedure Show(); override;
    procedure Hide(); override;
    function BField(x, y, z: extended): vector4; override;
    procedure Reshape(); override;
  end;

implementation

procedure TWireAndCoilConfig.Load(Form: TForm);
begin
  Amperage1 := 0;
  Amperage2 := 0;
  Radius := 5;
  DisplayLines := False;
  Reshape();
  RLabel := TLabel.Create(Form);
  with RLabel do
  begin
    Caption := 'R';
    SetBounds(10, 37, 40, 40);
    Parent := Form;
  end;
  REdit := TEdit.Create(Form);
  with REdit do
  begin
    Text := FloatToStr(Radius);
    OnChange := @RUpdate;
    Parent := Form;
    SetBounds(30, 35, 40, 40);
  end;
  I1Label := TLabel.Create(Form);
  with I1Label do
  begin
    Caption := 'I1';
    SetBounds(12, 81, 40, 40);
    Parent := Form;
  end;
  I1Edit := TEdit.Create(Form);
  with I1Edit do
  begin
    Text := FloatToStr(Amperage1);
    OnChange := @I1Update;
    Parent := Form;
    SetBounds(30, 78, 40, 40);
  end;
  I2Label := TLabel.Create(Form);
  with I2Label do
  begin
    Caption := 'I2';
    SetBounds(75, 79, 40, 40);
    Parent := Form;
  end;
  I2Edit := TEdit.Create(Form);
  with I2Edit do
  begin
    Text := FloatToStr(Amperage2);
    OnChange := @I2Update;
    Parent := Form;
    SetBounds(92, 78, 40, 40);
  end;

end;

procedure TWireAndCoilConfig.Show();
begin
  REdit.Visible := True;
  RLabel.Visible := True;
  I1Edit.Visible := True;
  I1Label.Visible := True;
  I2Edit.Visible := True;
  I2Label.Visible := True;
  Reshape();
end;

procedure TWireAndCoilConfig.Hide();
begin
  REdit.Visible := False;
  RLabel.Visible := False;
  I1Edit.Visible := False;
  I1Label.Visible := False;
  I2Edit.Visible := False;
  I2Label.Visible := False;
end;

procedure TWireAndCoilConfig.RUpdate(Sender: TObject);
begin
  TryStrToFloat(REdit.Text, Radius);
  Reshape();
end;
procedure TWireAndCoilConfig.I1Update(Sender: TObject);
begin
  TryStrToFloat(I1Edit.Text, Amperage1);
  Reshape();
end;

procedure TWireAndCoilConfig.I2Update(Sender: TObject);
begin
  TryStrToFloat(I2Edit.Text, Amperage2);
  Reshape();
end;

function TWireAndCoilConfig.BField(x, y, z: extended): vector4;
const dAngle = pi / 600;
var
  tx, ty, tz, m1, m2, r1, r2, lll, dlm, rm, sna: extended;
    v1, v2: vector4;
    ang: extended;
    qx, qy, qz: extended;
    dl, rr, v22: vector4;
begin
  tx := x - x1;
  ty := y - y1;
  v1.y := tx;
  v1.x := -ty;
  r1 := sqrt((x - x1) * (x - x1) + (y - y1) * (y - y1));
  m1 := Amperage1 / (r1 + 0.0000001);
  lll := sqrt(v1.x * v1.x + v1.y * v1.y);
  v1.x := m1 * (v1.x / lll);
  v1.y := m1 * (v1.y / lll);
  v1.z := 0;

  ang := 0;
  dlm := Radius * sin(dAngle);
  v2.x := 0;
  v2.y := 0;
  v2.z := 0;
  while (ang < (2 * pi)) do begin
    // showmessage(floattostr(ang));

    dl.x := - dlm * sin(ang);
    dl.y := dlm * cos(ang);
    dl.z := 0;

    qx := Radius * cos(ang);
    qy := Radius * sin(ang);
    qz := 0;

    rr.x := x - qx;
    rr.y := y - qy;
    rr.z := z - qz;

    rm := sqrt(rr.x * rr.x + rr.y * rr.y + rr.z * rr.z);

    sna := sqrt(1 - (dl.x * rr.x + dl.y * rr.y + dl.z * rr.z) *
                    (dl.x * rr.x + dl.y * rr.y + dl.z * rr.z)
                    / rm / rm / dlm / dlm);

    m2 := (dlm / 2) * Amperage2 * sna / rm / rm;

    v22.x := rr.y * dl.z - rr.z * dl.y;         //векторное произведение
    v22.y := rr.z * dl.x - rr.x * dl.z;
    v22.z := rr.x * dl.y - rr.y * dl.x;

    lll := sqrt(v22.x * v22.x + v22.y * v22.y + v22.z * v22.z);

    v2.x := v2.x + m2 * (v22.x / lll);
    v2.y := v2.y + m2 * (v22.y / lll);
    v2.z := v2.z + m2 * (v22.z / lll);

    ang := ang + dAngle;
end;
   result.x := v1.x + v2.x;
  result.y := v1.y + v2.y;
  result.z := v1.z + v2.z;
  result.l := sqrt(result.x * result.x + result.y * result.y +
                                                    result.z * result.z);
end;
procedure TWireAndCoilConfig.Reshape();
const
  length = 1000;
  edges = 50;
  wireRadius = 0.25;
  Pi2 = 2 * Pi;
var
  angle: real;
  i, j, k, n, numc, numt: integer;
  s, t, x, y, z, offset: double;
begin
  BaseGeometry := glGenLists(1);
  glNewList(BaseGeometry, GL_COMPILE);
  angle := 0;
  glBegin(GL_QUADS);
  for i := 0 to edges do
  begin
    for j := (-length div 20) to (length div 20) do
    begin
      glColor3f(0.6, 0.2, 1.0);
      glVertex3f(X1 + wireRadius * sin(angle), Y1 + wireRadius * cos(angle), 20 * j);
      glVertex3f(X1 + wireRadius * sin(angle + 2 * Pi / edges), Y1 +
        wireRadius * cos(angle + 2 * Pi / edges), 20 * j);
      glVertex3f(X1 + wireRadius * sin(angle + 2 * Pi / edges), Y1 +
        wireRadius * cos(angle + 2 * Pi / edges), 20 * (j + 1));
      glVertex3f(X1 + wireRadius * sin(angle), Y1 + wireRadius * cos(angle), 20 * (j + 1));
    end;
    angle := angle + 2 * Pi / edges;
  end;
  glEnd();
  numc := 6;
    numt := 50;
       for i := 0 to numc - 1 do begin
             glBegin(GL_QUAD_STRIP);
              for j := 0 to numt do begin
                      for k := 1 downto 0 do begin
                      s := (i + k) mod numc + 0.5;
                      t := j mod numt;
                      x := (Radius + 0.1*cos(s * Pi2/numc))*cos(t*Pi2/numt);
                      y := (Radius + 0.1*cos(s * Pi2/numc))*sin(t*Pi2/numt);
                      z := offset + 0.1*sin(s * Pi2/numc);
                      glColor3f(1, 0.3, 0.25);
                      glVertex3f(x, y, z);
                      end;
              end;
              glEnd;
       end;
  glEndList();
end;


end.

