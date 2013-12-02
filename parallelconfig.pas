unit ParallelConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, ComCtrls, Forms, Dialogs, GL, regularwireconfig, vector4unit;
  {$M+}
  type
  {TParallelConfig}
  TParallelConfig = class(TRegularWireConfig)
    X1Edit: TEdit;
    X1Label: TLabel;
    Y1Edit: TEdit;
    Y1Label: TLabel;
    I1Edit: TEdit;
    I1Label: TLabel;
    X2Edit: TEdit;
    X2Label: TLabel;
    Y2Edit: TEdit;
    Y2Label: TLabel;
    I2Edit: TEdit;
    I2Label: TLabel;
    private
         X1, Y1, X2, Y2, Amperage1, Amperage2: real;
         procedure X1Update(Sender: TObject);
         procedure Y1Update(Sender: TObject);
         procedure X2Update(Sender: TObject);
         procedure Y2Update(Sender: TObject);
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

procedure  TParallelConfig.Load(Form: TForm);
begin
  Amperage1 := 0;
  Amperage2 := 0;
  X1 := -5;
  Y1 := -5;
  X2 := 5;
  Y2 := 5;
  DisplayLines := false;
  Reshape();
  X1Label := TLabel.Create(Form);
  with X1Label do begin
     Caption := 'X1:';
     SetBounds(10,37, 40, 40);
     Parent := Form;
  end;
  X1Edit := TEdit.Create(Form);
  with X1Edit do begin
    Text := FloatToStr(X1);
    OnChange := @X1Update;
    Parent := Form;
    SetBounds(30,35, 40, 40);
  end;
  Y1Label := TLabel.Create(Form);
  with Y1Label do begin
     Caption := 'Y1:';
     SetBounds(10,59, 40, 40);
     Parent := Form;
  end;
  Y1Edit := TEdit.Create(Form);
  with Y1Edit do begin
    Text := FloatToStr(Y1);
    OnChange := @Y1Update;
    Parent := Form;
    SetBounds(30,57, 40, 40);
    end;
  X2Label := TLabel.Create(Form);
  with X2Label do begin
     Caption := 'X2:';
     SetBounds(75,37, 40, 40);
     Parent := Form;
  end;
  X2Edit := TEdit.Create(Form);
  with X2Edit do begin
    Text := FloatToStr(X2);
    OnChange := @X2Update;
    Parent := Form;
    SetBounds(92,35, 40, 40);
  end;
  Y2Label := TLabel.Create(Form);
  with Y2Label do begin
     Caption := 'Y2:';
     SetBounds(75,59, 40, 40);
     Parent := Form;
  end;
  Y2Edit := TEdit.Create(Form);
  with Y2Edit do begin
    Text := FloatToStr(Y2);
    OnChange := @Y2Update;
    Parent := Form;
    SetBounds(92,57, 40, 40);
  end;
  I1Label := TLabel.Create(Form);
  with I1Label do begin
     Caption := 'I1:';
     SetBounds(12,81, 40, 40);
     Parent := Form;
  end;
  I1Edit := TEdit.Create(Form);
  with I1Edit do begin
    Text := FloatToStr(Amperage1);
    OnChange := @I1Update;
    Parent := Form;
    SetBounds(30,78, 40, 40);
  end;
  I2Label := TLabel.Create(Form);
  with I2Label do begin
     Caption := 'I2:';
     SetBounds(75,79, 40, 40);
     Parent := Form;
  end;
  I2Edit := TEdit.Create(Form);
  with I2Edit do begin
    Text := FloatToStr(Amperage2);
    OnChange := @I2Update;
    Parent := Form;
    SetBounds(92,78, 40, 40);
  end;

end;
procedure  TParallelConfig.Show();
  begin
    X1Edit.Visible:=true;
    X1Label.Visible:=true;
    Y1Edit.Visible:=true;
    Y1Label.Visible:=true;
    I1Edit.Visible:=true;
    I1Label.Visible:=true;
    X2Edit.Visible:=true;
    X2Label.Visible:=true;
    Y2Edit.Visible:=true;
    Y2Label.Visible:=true;
    I2Edit.Visible:=true;
    I2Label.Visible:=true;
    Reshape();
end;
procedure  TParallelConfig.Hide();
begin
    X1Edit.Visible:=false;
    X1Label.Visible:=false;
    Y1Edit.Visible:=false;
    Y1Label.Visible:=false;
    I1Edit.Visible:=false;
    I1Label.Visible:=false;
    X2Edit.Visible:=false;
    X2Label.Visible:=false;
    Y2Edit.Visible:=false;
    Y2Label.Visible:=false;
    I2Edit.Visible:=false;
    I2Label.Visible:=false;
end;
procedure TParallelConfig.X1Update(Sender: TObject);
begin
     TryStrToFloat(X1Edit.Text, X1);
     Reshape();
end;
procedure TParallelConfig.Y1Update(Sender: TObject);
begin
     TryStrToFloat(Y1Edit.Text, Y1);
     Reshape();
end;
procedure TParallelConfig.X2Update(Sender: TObject);
begin
      TryStrToFloat(X2Edit.Text, X2);
     Reshape();
end;
procedure TParallelConfig.Y2Update(Sender: TObject);
begin
      TryStrToFloat(Y2Edit.Text, Y2);
     Reshape();
end;
procedure TParallelConfig.I1Update(Sender: TObject);
begin
     TryStrToFloat(I1Edit.Text, Amperage1);
     Reshape();
end;
procedure TParallelConfig.I2Update(Sender: TObject);
begin
     TryStrToFloat(I2Edit.Text, Amperage2);
     Reshape();
end;

function TParallelConfig.BField(x, y, z: extended): vector4;
var tx, ty, tz, m1, m2, r1, r2, lll: extended;
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
  ty := y - y2;
  v2.y := tx;
  v2.x := -ty;
  r2 := sqrt((x - x2) * (x - x2) + (y - y2) * (y - y2));
  m2 := 4 * Amperage2 / (2 * r2);
  lll := sqrt(v2.x * v2.x + v2.y * v2.y);
  v2.x := m2 * (v2.x / lll);
  v2.y := m2 * (v2.y / lll);
  v2.z := 0;

  result.x := v1.x + v2.x;
  result.y := v1.y + v2.y;
  result.z := v1.z + v2.z;
  result.l := sqrt(result.x * result.x + result.y * result.y +
                                          result.z * result.z);
end;

procedure  TParallelConfig.Reshape();
const length = 1000; edges = 50; radius = 1;
var angle: real;
    i,j:integer;
begin
  BaseGeometry := glGenLists(1);
  glNewList(BaseGeometry, GL_COMPILE);
  angle := 0;
  glBegin(GL_QUADS);
  for i := 0 to edges do
      begin
        for j := (-length div 20) to (length div 20) do begin
            glColor3f(0.6, 0.2, 1.0);
            glVertex3f(X1 + radius * sin(angle), Y1 + radius * cos(angle), 20*j);
            glVertex3f(X1 + radius * sin(angle + 2*Pi/edges), Y1 + radius * cos(angle + 2*Pi/edges), 20*j);
            glVertex3f(X1 + radius * sin(angle + 2*Pi/edges), Y1 + radius * cos(angle + 2*Pi/edges), 20*(j+1));
            glVertex3f(X1 + radius * sin(angle), Y1 + radius * cos(angle), 20*(j+1));

            glColor3f(0.2, 1.0, 0.2);
            glVertex3f(X2 + radius * sin(angle), Y2 + radius * cos(angle), 20*j);
            glVertex3f(X2 + radius * sin(angle + 2*Pi/edges), Y2 + radius * cos(angle + 2*Pi/edges), 20*j);
            glVertex3f(X2 + radius * sin(angle + 2*Pi/edges), Y2 + radius * cos(angle + 2*Pi/edges), 20*(j+1));
            glVertex3f(X2 + radius * sin(angle), Y2 + radius * cos(angle), 20*(j+1));
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

