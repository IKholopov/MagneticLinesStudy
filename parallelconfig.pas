unit ParallelConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, ComCtrls, Forms, Dialogs, GL, wireconfig;
  {$M+}
  type
  {TParallelConfig}
  TParallelConfig = class(TWireConfig)
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
         constructor Create(bar: TProgressBar);
         procedure Load(Form: TForm); override;
         procedure Show(); override;
         procedure Hide(); override;
         function Calculate(x, y, z: real): boolean; override;
         function BField(x, y, z: extended): vector4; override;
         procedure Reshape(); override;
         procedure DrawWire(); override;
  end;

implementation

constructor TParallelConfig.Create(bar: TProgressBar);
begin
  ProgressBar := bar;
  LinesLength := 0;
end;

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

function TParallelConfig.Calculate(x, y, z: real): boolean;
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

   ProgressBar.Visible := false;;
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
begin
  BaseGeometry := glGenLists(1);
  glNewList(BaseGeometry, GL_COMPILE);
      glBegin(GL_LINES);
                       glColor3f(0.6, 0.2, 1.0);
                       glVertex3f(X1, Y1, 1000);
                       glVertex3f(X1, Y1, -1000);
                       glColor3f(0.2, 1.0, 0.2);
                       glVertex3f(X2, Y2, 1000);
                       glVertex3f(X2, Y2, -1000);
      glEnd();
  glEndList();
end;
procedure  TParallelConfig.DrawWire();
begin
  glCallList(BaseGeometry);
  glCallList(Lines);
end;

end.

