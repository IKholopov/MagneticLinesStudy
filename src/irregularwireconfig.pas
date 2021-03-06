unit IrregularWireConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, ComCtrls, GL, forminterface, wireconfig, vector4unit;
 {$M+}
type
  TIrregularWireConfig = class(TWireConfig)

  private
        Line: GLuint;
        line2index:integer;
  public
        constructor Create(setGui: TFormInterface);
        function Calculate(x, y, z: real; resolution: integer):boolean; override;
        procedure DrawWire(); override;
        procedure ResetLines(); override;
  end;

  implementation


     {TIrregularWireConfig}
constructor TIrregularWireConfig.Create(setGui: TFormInterface);
begin
    CurrentLine := 0;
    Gui := setGui;
end;

function TIrregularWireConfig.Calculate(x, y, z: real; resolution: integer): boolean;
  const h = 0.1; ex = 0.01; e = 0.1;
var i: integer;
k1, k2, k3, k4, l1, l2, l3, l4, m1, m2, m3, m4, dx, dy, dz, l: extended;
Bt: vector4;
lineClosed:boolean;
begin
  Gui.StartProcess();
  lineClosed := false;
  Vectors[0].X := x;
  Vectors[0].Y := y;
  Vectors[0].Z := z;

  for i := 1 to resolution do begin
    Gui.UpdateProcess(i div (resolution div 100));
    Bt := BField(Vectors[i - 1].X, Vectors[i - 1].y, Vectors[i - 1].z);
    k1 := h * bt.x / bt.l;
    l1 := h * bt.y / bt.l;
    m1 := h * bt.z / bt.l;

    Bt := BField(Vectors[i - 1].X + (k1 / 2), Vectors[i - 1].y + (l1 / 2),
                                    Vectors[i - 1].z + (m1 / 2));
    k2 := h * bt.x / bt.l;
    l2 := h * bt.y / bt.l;
    m2 := h * bt.z / bt.l;

    Bt := BField(Vectors[i - 1].X + (k2 / 2), Vectors[i - 1].y + (l2 / 2),
                                    Vectors[i - 1].z + (m2 / 2));
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
       (abs(Vectors[i].z - Vectors[0].z) < e) and
       (i > 150) then begin
        Gui.ShowMessage('This lines is closed!', true);
        Gui.StopProcess();
        lineClosed := true;
        break;
      end;
  end;
   if not lineClosed then begin
       Vectors[resolution + 1].X := x;
       Vectors[resolution + 1].Y := y;
       Vectors[resolution + 1].Z := z;
       for i := resolution + 2 to 2*resolution do begin
    Gui.UpdateProcess((i-(resolution + 2)) div (resolution div 100));
    Bt := BField(Vectors[i - 1].X, Vectors[i - 1].y, Vectors[i - 1].z);
    k1 := h * bt.x / bt.l;
    l1 := h * bt.y / bt.l;
    m1 := h * bt.z / bt.l;

    Bt := BField(Vectors[i - 1].X + (k1 / 2), Vectors[i - 1].y + (l1 / 2),
                                    Vectors[i - 1].z + (m1 / 2));
    k2 := h * bt.x / bt.l;
    l2 := h * bt.y / bt.l;
    m2 := h * bt.z / bt.l;

    Bt := BField(Vectors[i - 1].X + (k2 / 2), Vectors[i - 1].y + (l2 / 2),
                                    Vectors[i - 1].z + (m2 / 2));
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

    Vectors[i].X := Vectors[i - 1].X - dx;
    Vectors[i].y := Vectors[i - 1].y - dy;
    Vectors[i].z := Vectors[i - 1].z - dz;

    if ((
       (abs(Vectors[i].X - Vectors[0].X) < e) and
       (abs(Vectors[i].y - Vectors[0].y) < e) and
       (abs(Vectors[i].z - Vectors[0].z) < e)) or(
       (abs(Vectors[i].X - Vectors[resolution].X) < e) and
       (abs(Vectors[i].y - Vectors[resolution].y) < e) and
       (abs(Vectors[i].z - Vectors[resolution].z) < e))) and
       (i > resolution + 150) then begin
        Gui.ShowMessage('This line is closed!',true);
        Gui.StopProcess();
        lineClosed := true;
        break;
      end;
  end;
   end;
   VectorsLength := i;
   Lines[CurrentLine] := glGenLists(1);
   glNewList(Lines[CurrentLine], GL_COMPILE);
   if VectorsLength <= resolution then
    begin
       glBegin(GL_LINE_STRIP);
       for i := 0 to VectorsLength do begin
          glColor3f(0, 1, 1);
          glVertex3f(Vectors[i].X, Vectors[i].Y, Vectors[i].Z);
          end;
          glColor3f(0, 0, 1);
          glVertex3f(Vectors[0].X, Vectors[0].Y, Vectors[0].Z);;
    glEnd();
    end else begin
      glBegin(GL_LINE_STRIP);
      for i := 0 to resolution do begin
          glColor3f(0, 1, 1);
          glVertex3f(Vectors[i].X, Vectors[i].Y, Vectors[i].Z);
          end;
      glEnd();
      glBegin(GL_LINE_STRIP);
       for i := resolution + 1  to VectorsLength do begin
          glColor3f(0, 1, 1);
          glVertex3f(Vectors[i].X, Vectors[i].Y, Vectors[i].Z);
          end;
      if lineClosed then begin
          glColor3f(0, 0, 1);
          glVertex3f(Vectors[resolution + 1].X, Vectors[resolution + 1].Y, Vectors[resolution + 1].Z);
          end
          else Gui.ShowMessage('This line is not closed!',false);
      glEnd();
    end;

    glEndList();
   Gui.StopProcess();
   CurrentLine := CurrentLine + 1;
   DisplayLines := true;
   Result := true;
end;

procedure  TIrregularWireConfig.DrawWire();
var i: integer;
begin
     glCallList(BaseGeometry);
  if CurrentLine > 0 then
    for i := 0 to (CurrentLine - 1) do
    begin
      glCallList(Lines[i]);
    end;
end;

procedure  TIrregularWireConfig.ResetLines();
var i: integer;
begin
  for i := 0 to CurrentLine do
      glDeleteLists(Lines[i], 1);
    CurrentLine := 0;
end;

end.

