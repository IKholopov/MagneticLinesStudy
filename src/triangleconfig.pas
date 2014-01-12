unit TriangleConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, ComCtrls, Forms, Dialogs, GL, regularwireconfig, vector4unit, Math;
  {$M+}
  type
  {TTriangleConfig}
  TTriangleConfig = class(TRegularWireConfig)
       const  X1 = -3; Y1 = 0; Z1 = 0;
       var CZEdit: TEdit;
           CZLabel: TLabel;
           CYEdit: TEdit;
           CYLabel: TLabel;
    private
           Amperage, CathetusY, CathetusZ: real;
           AdditionalBaseGeometry: Gluint;
           procedure CYUpdate(Sender: TObject);
           procedure CZUpdate(Sender: TObject);

    public
         procedure Load(Form: TForm); override;
         procedure Show(); override;
         procedure Hide(); override;
         function BField(x, y, z: extended): vector4; override;
         procedure Reshape(); override;
         procedure DrawWire(); override;
  end;

implementation

procedure  TTriangleConfig.Load(Form: TForm);
begin
  Amperage := 100;
  CathetusZ := 10;
  CathetusY := 10;
  DisplayLines := false;
  Position.x:= X1;
  CZLabel := TLabel.Create(Form);
  with CZLabel do
  begin
    Caption := 'Cathetus Z';
    SetBounds(12, 81, 40, 40);
    Parent := Form;
  end;
  CZEdit := TEdit.Create(Form);
  with CZEdit do
  begin
    Text := FloatToStr(CathetusZ);
    OnChange := @CZUpdate;
    Parent := Form;
    SetBounds(90, 78, 40, 40);
  end;
  CYLabel := TLabel.Create(Form);
  with CYLabel do
  begin
    Caption := 'Cathetus Y';
    SetBounds(12, 103, 40, 40);
    Parent := Form;
  end;
  CYEdit := TEdit.Create(Form);
  with CYEdit do
  begin
    Text := FloatToStr(CathetusY);
    OnChange := @CYUpdate;
    Parent := Form;
    SetBounds(90, 100, 40, 40);
  end;
  Reshape();
end;
procedure  TTriangleConfig.Show();
  begin
    CYEdit.Visible := True;
    CYLabel.Visible := True;
    CZEdit.Visible := True;
    CZLabel.Visible := True;
    Reshape();
end;
procedure  TTriangleConfig.Hide();
begin
  CYEdit.Visible := False;
    CYLabel.Visible := False;
    CZEdit.Visible := False;
    CZLabel.Visible := False;
end;

procedure TTriangleConfig.CZUpdate(Sender: TObject);
begin
  TryStrToFloat(CZEdit.Text, CathetusZ);
  Reshape();
end;

procedure TTriangleConfig.CYUpdate(Sender: TObject);
begin
  TryStrToFloat(CYEdit.Text, CathetusY);
  Reshape();
end;

function TTriangleConfig.BField(x, y, z: extended): vector4;
var m1, m2, r1, r2, sin1, sin2, sina, sinb, cosa, cosb: extended;
    v1, v2: vector4;
begin



  result.l := sqrt(result.x * result.x + result.y * result.y
                                       + result.z * result.z);
end;

procedure  TTriangleConfig.Reshape();
const length = 1000; edges = 50; radius = 0.25;
  rings = 50;
var angle, tgAlpha: real;
    i,j:integer;
begin
  AdditionalBaseGeometry := glGenLists(1);
  glNewList(AdditionalBaseGeometry, GL_COMPILE);
  angle := 0;
  tgAlpha := CathetusY/CathetusZ;
  glBegin(GL_QUADS);
  for i := 0 to edges do
      begin
        for j := 0 to 20 do begin
          glColor3f(0.2, 1.0, 0.2);
                      glVertex3f(X1 + radius * sin(angle), Y1 + radius * cos(angle), (sqrt(power(CathetusZ,2)+power(CathetusY,2))/21)*j-radius);
                      glVertex3f(X1 + radius * sin(angle + 2*Pi/edges), Y1 + radius * cos(angle + 2*Pi/edges), (sqrt(power(CathetusZ,2)+power(CathetusY,2))/21)*j-radius);
                      glVertex3f(X1 + radius * sin(angle + 2*Pi/edges), Y1 + radius * cos(angle + 2*Pi/edges), (sqrt(power(CathetusZ,2)+power(CathetusY,2))/21)*(j+1)-radius);
                      glVertex3f(X1 + radius * sin(angle), Y1 + radius * cos(angle), (sqrt(power(CathetusZ,2)+power(CathetusY,2))/21)*(j+1)-radius);
        end;
        angle := angle + 2*Pi/edges;
      end;
  glEnd();
  glEndList();
  BaseGeometry := glGenLists(1);
  glNewList(BaseGeometry, GL_COMPILE);
  angle := 0;
  glBegin(GL_QUADS);
  for i := 0 to edges do
      begin
        for j := 0 to 20 do begin
            {glColor3f(0.2, 1.0, 0.2);
            glVertex3f(X1 + radius * sin(angle), Y1 + radius * cos(angle), (CathetusZ/20)*j-radius);
            glVertex3f(X1 + radius * sin(angle + 2*Pi/edges), Y1 + radius * cos(angle + 2*Pi/edges), (CathetusZ/20)*j-radius);
            glVertex3f(X1 + radius * sin(angle + 2*Pi/edges), Y1 + radius * cos(angle + 2*Pi/edges), (CathetusZ/20)*(j+1)-radius);
            glVertex3f(X1 + radius * sin(angle), Y1 + radius * cos(angle), (CathetusZ/20)*(j+1)-radius);}

            glColor3f(0.2, 1.0, 0.2);
            glVertex3f(X1 + radius * sin(angle), (CathetusY/21)* j-radius, Z1 + radius * cos(angle));
            glVertex3f(X1 + radius * sin(angle + 2 * Pi / edges),  (CathetusY/21) * j-radius, Z1 +
            radius * cos(angle + 2 * Pi / edges));
            glVertex3f(X1 + radius * sin(angle + 2 * Pi / edges), (CathetusY/21) * (j + 1)-radius, Z1 +
            radius * cos(angle + 2 * Pi / edges));
            glVertex3f(X1 + radius * sin(angle), (CathetusY/21) * (j + 1)-radius, Z1 + radius * cos(angle));

                        glVertex3f(X1 + radius * sin(angle), Y1 + radius * cos(angle), (CathetusZ/21)*j-radius);
            glVertex3f(X1 + radius * sin(angle + 2*Pi/edges), Y1 + radius * cos(angle + 2*Pi/edges), (CathetusZ/21)*j-radius);
            glVertex3f(X1 + radius * sin(angle + 2*Pi/edges), Y1 + radius * cos(angle + 2*Pi/edges), (CathetusZ/21)*(j+1)-radius);
            glVertex3f(X1 + radius * sin(angle), Y1 + radius * cos(angle), (CathetusZ/21)*(j+1)-radius);
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

procedure TTriangleConfig.DrawWire();
var
  i: integer;
begin
  glPushMatrix();
  glTranslatef(0,CathetusY-0.25,0.1);
  glRotatef(arctan(CathetusY/CathetusZ)/Pi*180,1,0,0);
  glCallList(AdditionalBaseGeometry);
  glPopMatrix();
  glCallList(BaseGeometry);
  if CurrentLine > 0 then
    for i := 0 to (CurrentLine - 1) do
    begin
      glCallList(Lines[i]);
    end;
end;

end.

