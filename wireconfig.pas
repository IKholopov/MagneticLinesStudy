unit WireConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, ComCtrls, GL;
 {$M+}
type
  vector4 = record
          X, Y, Z, L: extended;
  end;

  TWireConfig = class(TObject)
  private

  public
        BaseGeometry: GLuint;
        Lines: GLuint;
        LinesLength: integer;
        DisplayLines: boolean;
        Vectors: array[0..200000] of vector4;
        VectorsLength: integer;
        ProgressBar: TProgressBar;
        constructor Create(bar: TProgressBar);
        procedure Load(Form: TForm); virtual;
        procedure Show(); virtual;
        procedure Hide();virtual;
        function Calculate(x, y, z: real):boolean;
        function BField(x, y, z:extended):vector4; virtual;
        procedure Reshape(); virtual;
        procedure DrawWire(); virtual;
  end;   
  
  implementation


     {TWireConfig}
constructor TWireConfig.Create(bar: TProgressBar);
begin
  raise exception.Create('Base class TWireConfig doesnt implement Constructor');
end;
procedure  TWireConfig.Load(Form: TForm);
begin
  raise exception.Create('Base class TWireConfig doesnt implement Load(Form)');
end;
procedure  TWireConfig.Show();
  begin
    raise exception.Create('Base class TWireConfig doesnt implement Show(Form)');
end;
procedure  TWireConfig.Hide();
begin
    raise exception.Create('Base class TWireConfig doesnt implement Hide(Form)');
end;
function TWireConfig.Calculate(x, y, z: real): boolean;
  const h = 0.1; ex = 0.01; e = 0.1;
var i: integer;
k1, k2, k3, k4, l1, l2, l3, l4, m1, m2, m3, m4, dx, dy, dz, l: extended;
Bt: vector4;
fileVar:TextFile;
begin
  ProgressBar.Visible:=true;
  AssignFile(fileVar, 'Verts.txt');
  Rewrite(fileVar);

  Vectors[0].X := x;
  Vectors[0].Y := y;
  Vectors[0].Z := z;

  for i := 1 to 200000 do begin
    ProgressBar.Position:= (i div 2000);
    Bt := BField(Vectors[i - 1].X, Vectors[i - 1].y, Vectors[i - 1].z);
    {write(vt.x:20:20, vt.y:20:20, vt.z:20:20);
    writeln;}
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
 {   write((aofl[t].Nodes[i - 1].X + dx):20:20, ' ',
          (aofl[t].Nodes[i - 1].y + dy):20:20, ' ',
          (aofl[t].Nodes[i - 1].z + dz):20:20, ' ');
    writeln; }
    if (abs(Vectors[i].X - Vectors[0].X) < e) and
       (abs(Vectors[i].y - Vectors[0].y) < e) and
       (abs(Vectors[i].z - Vectors[0].z) < e) and
       (i > 150) then begin
        showmessage('This lines is closed!');
        ProgressBar.Position:= 100;
        break;
      end;
  end;
   VectorsLength := i;

   Lines := glGenLists(1);
    glNewList(Lines, GL_COMPILE);
    glBegin(GL_LINE_STRIP);
    for i := 0 to VectorsLength do begin
          glColor3f(0, 1, 1);
          glVertex3f(Vectors[i].X, Vectors[i].Y, Vectors[i].Z);
    end;
    glColor3f(0, 0, 1);
          glVertex3f(Vectors[0].X, Vectors[0].Y, Vectors[0].Z);
    glEnd();
    glEndList();

   DisplayLines := true;
   CloseFile(fileVar);
   Result := true;

   ProgressBar.Visible := false;
end;
function TWireConfig.BField(x, y, z:extended):vector4;
begin
   raise exception.Create('Base class TWireConfig doesnt implement Create()');
end;

procedure  TWireConfig.DrawWire();
begin
  raise exception.Create('Base class TWireConfig doesnt implement DrawWire()');
end;
procedure  TWireConfig.Reshape();
begin
  raise exception.Create('Base class TWireConfig doesnt implement Reshape()');
end;

end.
