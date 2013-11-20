unit PerpendicularConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, ComCtrls, Forms, Dialogs, GL, wireconfig;

  {$M+}
type
  {TPerpendicularConfig}
  TPerpendicularConfig = class(TWireConfig)
    X1Edit: TEdit;
    X1Label: TLabel;
    Y1Edit: TEdit;
    Y1Label: TLabel;
    I1Edit: TEdit;
    I1Label: TLabel;
    X2Edit: TEdit;
    X2Label: TLabel;
    Z2Edit: TEdit;
    Z2Label: TLabel;
    I2Edit: TEdit;
    I2Label: TLabel;
  private
    X1, Y1, X2, Z2, Amperage1, Amperage2: real;
    procedure X1Update(Sender: TObject);
    procedure Y1Update(Sender: TObject);
    procedure X2Update(Sender: TObject);
    procedure Z2Update(Sender: TObject);
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

procedure TPerpendicularConfig.Load(Form: TForm);
begin
  Amperage1 := 0;
  Amperage2 := 0;
  X1 := -5;
  Y1 := -5;
  X2 := 5;
  Z2 := 5;
  DisplayLines := False;
  Reshape();
  X1Label := TLabel.Create(Form);
  with X1Label do
  begin
    Caption := 'X1:';
    SetBounds(10, 37, 40, 40);
    Parent := Form;
  end;
  X1Edit := TEdit.Create(Form);
  with X1Edit do
  begin
    Text := FloatToStr(X1);
    OnChange := @X1Update;
    Parent := Form;
    SetBounds(30, 35, 40, 40);
  end;
  Y1Label := TLabel.Create(Form);
  with Y1Label do
  begin
    Caption := 'Y1:';
    SetBounds(10, 59, 40, 40);
    Parent := Form;
  end;
  Y1Edit := TEdit.Create(Form);
  with Y1Edit do
  begin
    Text := FloatToStr(Y1);
    OnChange := @Y1Update;
    Parent := Form;
    SetBounds(30, 57, 40, 40);
  end;
  X2Label := TLabel.Create(Form);
  with X2Label do
  begin
    Caption := 'X2:';
    SetBounds(75, 37, 40, 40);
    Parent := Form;
  end;
  X2Edit := TEdit.Create(Form);
  with X2Edit do
  begin
    Text := FloatToStr(X2);
    OnChange := @X2Update;
    Parent := Form;
    SetBounds(92, 35, 40, 40);
  end;
  Z2Label := TLabel.Create(Form);
  with Z2Label do
  begin
    Caption := 'Z2:';
    SetBounds(75, 59, 40, 40);
    Parent := Form;
  end;
  Z2Edit := TEdit.Create(Form);
  with Z2Edit do
  begin
    Text := FloatToStr(Z2);
    OnChange := @Z2Update;
    Parent := Form;
    SetBounds(92, 57, 40, 40);
  end;
  I1Label := TLabel.Create(Form);
  with I1Label do
  begin
    Caption := 'I1:';
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
    Caption := 'I2:';
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

procedure TPerpendicularConfig.Show();
begin
  X1Edit.Visible := True;
  X1Label.Visible := True;
  Y1Edit.Visible := True;
  Y1Label.Visible := True;
  I1Edit.Visible := True;
  I1Label.Visible := True;
  X2Edit.Visible := True;
  X2Label.Visible := True;
  Z2Edit.Visible := True;
  Z2Label.Visible := True;
  I2Edit.Visible := True;
  I2Label.Visible := True;
  Reshape();
end;

procedure TPerpendicularConfig.Hide();
begin
  X1Edit.Visible := False;
  X1Label.Visible := False;
  Y1Edit.Visible := False;
  Y1Label.Visible := False;
  I1Edit.Visible := False;
  I1Label.Visible := False;
  X2Edit.Visible := False;
  X2Label.Visible := False;
  Z2Edit.Visible := False;
  Z2Label.Visible := False;
  I2Edit.Visible := False;
  I2Label.Visible := False;
end;

procedure TPerpendicularConfig.X1Update(Sender: TObject);
begin
  TryStrToFloat(X1Edit.Text, X1);
  Reshape();
end;

procedure TPerpendicularConfig.Y1Update(Sender: TObject);
begin
  TryStrToFloat(Y1Edit.Text, Y1);
  Reshape();
end;

procedure TPerpendicularConfig.X2Update(Sender: TObject);
begin
  TryStrToFloat(X2Edit.Text, X2);
  Reshape();
end;

procedure TPerpendicularConfig.Z2Update(Sender: TObject);
begin
  TryStrToFloat(Z2Edit.Text, Z2);
  Reshape();
end;

procedure TPerpendicularConfig.I1Update(Sender: TObject);
begin
  TryStrToFloat(I1Edit.Text, Amperage1);
  Reshape();
end;

procedure TPerpendicularConfig.I2Update(Sender: TObject);
begin
  TryStrToFloat(I2Edit.Text, Amperage2);
  Reshape();
end;

function TPerpendicularConfig.BField(x, y, z: extended): vector4;
var
  tx, ty, tz, m1, m2, r1, r2, lll: extended;
  v1, v2: vector4;
begin
  tx := x - X1;
  ty := y - y1;
  v1.y := tx;
  v1.x := -ty;
  r1 := sqrt((x - x1) * (x - x1) + (y - y1) * (y - y1));
  m1 := 4 * Amperage1 / (2 * r1);
  lll := sqrt(v1.x * v1.x + v1.y * v1.y);
  v1.x := m1 * (v1.x / lll);
  v1.y := m1 * (v1.y / lll);
  v1.z := 0;

  tx := x - x2;
  tz := Z - Z2;
  v2.z := tx;
  v2.x := -tZ;
  v2.y := 0;
  r2 := sqrt((x - x2) * (x - x2) + (z - z2) * (z - z2));
  m2 := 4 * Amperage2 / (2 * r2);
  lll := sqrt(v2.x * v2.x + v2.z * v2.z);
  v2.x := m2 * (v2.x / lll);
  v2.z := m2 * (v2.z / lll);
  v2.y := 0;

  Result.x := v1.x + v2.x;
  Result.y := v1.y + v2.y;
  Result.z := v1.z + v2.z;
  Result.l := sqrt(Result.x * Result.x + Result.y * Result.y +
    Result.z * Result.z);
end;

procedure TPerpendicularConfig.Reshape();
const
  length = 1000;
  edges = 50;
  radius = 0.25;
var
  angle: real;
  i, j: integer;
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
      glVertex3f(X1 + radius * sin(angle), Y1 + radius * cos(angle), 20 * j);
      glVertex3f(X1 + radius * sin(angle + 2 * Pi / edges), Y1 +
        radius * cos(angle + 2 * Pi / edges), 20 * j);
      glVertex3f(X1 + radius * sin(angle + 2 * Pi / edges), Y1 +
        radius * cos(angle + 2 * Pi / edges), 20 * (j + 1));
      glVertex3f(X1 + radius * sin(angle), Y1 + radius * cos(angle), 20 * (j + 1));

      glColor3f(0.2, 1.0, 0.2);
      glVertex3f(X2 + radius * sin(angle), 20 * j, Z2 + radius * cos(angle));
      glVertex3f(X2 + radius * sin(angle + 2 * Pi / edges),  20 * j, Z2 +
        radius * cos(angle + 2 * Pi / edges));
      glVertex3f(X2 + radius * sin(angle + 2 * Pi / edges), 20 * (j + 1), Z2 +
        radius * cos(angle + 2 * Pi / edges));
      glVertex3f(X2 + radius * sin(angle), 20 * (j + 1), Z2 + radius * cos(angle));
    end;
    angle := angle + 2 * Pi / edges;
  end;
  glEnd();
  glEndList();
end;


end.
