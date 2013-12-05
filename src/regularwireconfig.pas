unit RegularWireConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, ComCtrls, GL, forminterface, wireconfig, vector4unit;

 {$M+}
type
  TRegularWireConfig = class(TWireConfig)
  private

  public
    Position:vector4;
    constructor Create(setGui: TFormInterface);
    function Calculate(x, y, z: real; resolution: integer): boolean; override;
    procedure DrawWire(); override;
    procedure ResetLines(); override;
  end;

implementation


{TRegularWireConfig}
constructor TRegularWireConfig.Create(setGui: TFormInterface);
begin
  CurrentLine := 0;
  Position.x := 0;
  Position.y := 0;
  Position.z := 0;
  Gui := setGui;
end;

function TRegularWireConfig.Calculate(x, y, z: real; resolution: integer): boolean;
const
  h = 0.1;
  ex = 0.01;
  e = 0.1;
var
  i: integer;
  k1, k2, k3, k4, l1, l2, l3, l4, m1, m2, m3, m4, dx, dy, dz, l: extended;
  Bt: vector4;
  lineClosed: boolean;
begin
  Gui.StartProcess();
  lineClosed := False;
  Vectors[0].X := x;
  Vectors[0].Y := y;
  Vectors[0].Z := z;

  for i := 1 to resolution do
  begin
    Gui.UpdateProcess(i div (resolution div 100));
    Bt := BField(Vectors[i - 1].X, Vectors[i - 1].y, Vectors[i - 1].z);
    k1 := h * bt.x / bt.l;
    l1 := h * bt.y / bt.l;
    m1 := h * bt.z / bt.l;

    Bt := BField(Vectors[i - 1].X + (k1 / 2), Vectors[i - 1].y +
      (l1 / 2), Vectors[i - 1].z + (m1 / 2));
    k2 := h * bt.x / bt.l;
    l2 := h * bt.y / bt.l;
    m2 := h * bt.z / bt.l;

    Bt := BField(Vectors[i - 1].X + (k2 / 2), Vectors[i - 1].y +
      (l2 / 2), Vectors[i - 1].z + (m2 / 2));
    k3 := h * bt.x / bt.l;
    l3 := h * bt.y / bt.l;
    m3 := h * bt.z / bt.l;

    Bt := BField(Vectors[i - 1].X + (k3), Vectors[i - 1].y + (l3),
      Vectors[i - 1].z + (m3));
    k4 := h * bt.x / bt.l;
    l4 := h * bt.y / bt.l;
    m4 := h * bt.z / bt.l;

    dx := (k1 + 2 * k2 + 2 * k3 + k4) / 6;
    dy := (l1 + 2 * l2 + 2 * l3 + l4) / 6;
    dz := (m1 + 2 * m2 + 2 * m3 + m4) / 6;

    Vectors[i].X := Vectors[i - 1].X + dx;
    Vectors[i].y := Vectors[i - 1].y + dy;
    Vectors[i].z := Vectors[i - 1].z + dz;
    if (abs(Vectors[i].X - Vectors[0].X) < e) and
      (abs(Vectors[i].y - Vectors[0].y) < e) and
      (abs(Vectors[i].z - Vectors[0].z) < e) and (i > 150) then
    begin
      Gui.ShowMessage('This lines is closed!', true);
      Gui.StopProcess();
      lineClosed := True;
      break;
    end;
  end;
  VectorsLength := i;
  Lines[CurrentLine] := glGenLists(1);
  glNewList(Lines[CurrentLine], GL_COMPILE);
  glBegin(GL_LINE_STRIP);
  for i := 0 to VectorsLength do
  begin
    glColor3f(0, 1, 1);
    glVertex3f(Vectors[i].X + Position.x, Vectors[i].Y + Position.y, Vectors[i].Z + Position.z);
  end;
  if lineClosed then
  begin
    glColor3f(0, 0, 1);
    glVertex3f(Vectors[0].X + Position.x, Vectors[0].Y + Position.y, Vectors[0].Z + Position.z);
  end
  else
    Gui.ShowMessage('This line is not closed!', false);
  glEnd();
  glEndList();
  CurrentLine := CurrentLine + 1;
  DisplayLines := True;
  Result := True;
end;

procedure TRegularWireConfig.DrawWire();
var
  i: integer;
begin
  glCallList(BaseGeometry);
  if CurrentLine > 0 then
    for i := 0 to (CurrentLine - 1) do
    begin
      glCallList(Lines[i]);
    end;
end;

procedure TRegularWireConfig.ResetLines();
var
  i: integer;
begin
  for i := 0 to CurrentLine do
    glDeleteLists(Lines[i], 1);
  CurrentLine := 0;
end;

end.
