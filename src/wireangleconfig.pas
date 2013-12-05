unit WireAngleConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, ComCtrls, Forms, Dialogs, GL, regularwireconfig, vector4unit;
  {$M+}
  type
  {TWireAngleConfig}
  TWireAngleConfig = class(TRegularWireConfig)
       const  X1 = -3; Y1 = 0; Z1 = 0;
    private
           Amperage: real;
    public
         procedure Load(Form: TForm); override;
         procedure Show(); override;
         procedure Hide(); override;
         function BField(x, y, z: extended): vector4; override;
         procedure Reshape(); override;
  end;

implementation

procedure  TWireAngleConfig.Load(Form: TForm);
begin
  Amperage := 100;
  DisplayLines := false;
  Position.x:= X1;
  Reshape();
end;
procedure  TWireAngleConfig.Show();
  begin
    Reshape();
end;
procedure  TWireAngleConfig.Hide();
begin
end;

function TWireAngleConfig.BField(x, y, z: extended): vector4;
var m1, m2, r1, r2, sin1, sin2, sina, sinb, cosa, cosb: extended;
    v1, v2: vector4;
begin
  // вычисление индцкции от z-проводника
  v1.z := 0;
  r1 := sqrt(x * x + y * y);
  sin1 := z / sqrt(x * x + y * y + z * z);
  m1 := 100 / r1 * (1 + sin1);  // пусть n0 * I / 4 * pi = 100
  sina := y / r1; cosa := x / r1;
  v1.x := -m1 * sina;
  v1.y := m1 * cosa;

  v2.y := 0;
  r2 := sqrt(z * z + x * x);
  sin2 := y / sqrt(x * x + y * y + z * z);
  m2 := -100 / r2 * (1 + sin2);
  sinb := z / r2; cosb := x / r2;
  v2.x := m2 * sinb;
  v2.z := -m2 * cosb;



  result.x := v1.x + v2.x;
  result.y := v1.y + v2.y;
  result.z := v1.z + v2.z;


  result.l := sqrt(result.x * result.x + result.y * result.y
                                       + result.z * result.z);
end;

procedure  TWireAngleConfig.Reshape();
const length = 1000; edges = 50; radius = 0.25;
  rings = 50;
var angle: real;
    i,j:integer;
begin
  BaseGeometry := glGenLists(1);
  glNewList(BaseGeometry, GL_COMPILE);
  angle := 0;
  glBegin(GL_QUADS);
  for i := 0 to edges do
      begin
        for j := 0 to (length div 20) do begin
            glColor3f(0.2, 1.0, 0.2);
            glVertex3f(X1 + radius * sin(angle), Y1 + radius * cos(angle), 20*j-radius);
            glVertex3f(X1 + radius * sin(angle + 2*Pi/edges), Y1 + radius * cos(angle + 2*Pi/edges), 20*j-radius);
            glVertex3f(X1 + radius * sin(angle + 2*Pi/edges), Y1 + radius * cos(angle + 2*Pi/edges), 20*(j+1)-radius);
            glVertex3f(X1 + radius * sin(angle), Y1 + radius * cos(angle), 20*(j+1)-radius);

            glColor3f(0.2, 1.0, 0.2);
            glVertex3f(X1 + radius * sin(angle), 20 * j-radius, Z1 + radius * cos(angle));
            glVertex3f(X1 + radius * sin(angle + 2 * Pi / edges),  20 * j-radius, Z1 +
            radius * cos(angle + 2 * Pi / edges));
            glVertex3f(X1 + radius * sin(angle + 2 * Pi / edges), 20 * (j + 1)-radius, Z1 +
            radius * cos(angle + 2 * Pi / edges));
            glVertex3f(X1 + radius * sin(angle), 20 * (j + 1)-radius, Z1 + radius * cos(angle));
        end;
        angle := angle + 2*Pi/edges;
      end;
  glEnd();


      {glBegin(GL_LINES);
                       glColor3f(0.6, 0.2, 1.0);
                       glVertex3f(X1, Y1, 1000);
                       glVertex3f(X1, Y1, -1000);
                       glColor3f(0.2, 1.0, 0.2);
                       glVertex3f(X2, Y2, 1000);
                       glVertex3f(X2, Y2, -1000);
      glEnd();}
  glEndList();
end;

end.


