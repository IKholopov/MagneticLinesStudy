unit ThreeRingsConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, ComCtrls, Forms, Dialogs, GL, wireconfig;
 {$M+}
 type
 {TThreeRingsConfig}
  TThreeRingsConfig = class(TWireConfig)
          RadiusLabel:TLabel;
          EditRadius: TEdit;
          AmperageLabel:TLabel;
          EditI: TEdit;
          DistanceLabel:TLabel;
          DistanceEdit: TEdit;
  private
         TorusDistance: real;
         Amperage:real;
         TorusRadius: real;
         procedure EditIUpdate(Sender: TObject);
         procedure DistanceEditUpdate(Sender: TObject);
         procedure RadiusEditUpdate(Sender: TObject);

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

constructor TThreeRingsConfig.Create(bar: TProgressBar);
begin
  ProgressBar := bar;
  LinesLength := 0;
end;

procedure  TThreeRingsConfig.Load(Form: TForm);
begin
  Amperage := 0;
  TorusRadius := 5;
  TorusDistance := 2;
  DisplayLines := false;
  Reshape();
  RadiusLabel := TLabel.Create(Form);
  with RadiusLabel do begin
     Caption := 'Radius:';
     SetBounds(10,32, 40, 40);
     Parent := Form;
  end;
  EditRadius := TEdit.Create(Form);
  with EditRadius do begin
    Text := FloatToStr(TorusRadius);
    OnChange := @RadiusEditUpdate;
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
    Text := FloatToStr(Amperage);
    Parent := Form;
    OnChange := @EditIUpdate;
    SetBounds(70,60, 100, 40);
  end;
  DistanceLabel := TLabel.Create(Form);
  with DistanceLabel do begin
     Caption := 'Distance:';
     SetBounds(10,92, 40, 40);
     Parent := Form;
  end;
  DistanceEdit := TEdit.Create(Form);
  with DistanceEdit do begin
    Text := FloatToStr(TorusDistance);
    Parent := Form;
    OnChange := @DistanceEditUpdate;
    SetBounds(70,90, 100, 40);
  end;
end;
procedure  TThreeRingsConfig.Show();
  begin
    RadiusLabel.Visible:=true;
          EditRadius.Visible:=true;
          AmperageLabel.Visible:=true;
          EditI.Visible:=true;
          DistanceLabel.Visible:=true;
          DistanceEdit.Visible:=true;
end;
procedure  TThreeRingsConfig.Hide();
begin
    RadiusLabel.Visible:=false;
    EditRadius.Visible:=false;
    AmperageLabel.Visible:=false;
    EditI.Visible:=false;
    DistanceLabel.Visible:=false;
    DistanceEdit.Visible:=false;
end;

procedure TThreeRingsConfig.RadiusEditUpdate(Sender: TObject);
begin
    TryStrToFloat(EditRadius.Text, TorusRadius);
    Reshape();
end;
procedure TThreeRingsConfig.EditIUpdate(Sender: TObject);
begin
     TryStrToFloat(EditI.Text, Amperage);
     Reshape();
end;
procedure TThreeRingsConfig.DistanceEditUpdate(Sender: TObject);
begin
    TryStrToFloat(DistanceEdit.Text, TorusDistance);
    Reshape();
end;
//Calculations
function TThreeRingsConfig.Calculate(x, y, z: real): boolean;
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

function TThreeRingsConfig.BField(x, y, z:extended):vector4;
const dAngle = pi / 600;
var m2, lll, dlm, rm, sna: extended;
    v1, v2, v3: vector4;
    ang: extended; //������� ���� � ��� ����
    qx, qy, qz: extended; //��������� ����� Q
    dl, rr, v22: vector4; //������ ���� � ������ ����������� �� �����
begin

  v1.x := 0;
  v1.y := 0;
  v1.z := 0;
  v2.x := 0;
  v2.y := 0;
  v2.z := 0;
  v3.x := 0;
  v3.y := 0;
  v3.z := 0;



  ang := 0;
  dlm := TorusRadius * sin(dAngle);

  while (ang < (2 * pi)) do begin
    // showmessage(floattostr(ang));

    dl.x := - dlm * sin(ang);
    dl.y := dlm * cos(ang);
    dl.z := 0;

    qx := TorusRadius * cos(ang);
    qy := TorusRadius * sin(ang);
    qz := 0;

    rr.x := x - qx;
    rr.y := y - qy;
    rr.z := z - qz;

    rm := sqrt(rr.x * rr.x + rr.y * rr.y + rr.z * rr.z);

    sna := sqrt(1 - (dl.x * rr.x + dl.y * rr.y + dl.z * rr.z) *
                    (dl.x * rr.x + dl.y * rr.y + dl.z * rr.z)
                    / rm / rm / dlm / dlm);

    m2 := (dlm / 2) * Amperage * sna / rm / rm;

    v22.x := rr.y * dl.z - rr.z * dl.y;         //��������� ������������
    v22.y := rr.z * dl.x - rr.x * dl.z;
    v22.z := rr.x * dl.y - rr.y * dl.x;

    lll := sqrt(v22.x * v22.x + v22.y * v22.y + v22.z * v22.z);

    v2.x := v2.x + m2 * (v22.x / lll);
    v2.y := v2.y + m2 * (v22.y / lll);
    v2.z := v2.z + m2 * (v22.z / lll);

    ang := ang + dAngle;
  end;


  ang := 0;
  dlm := TorusRadius * sin(dAngle);

  while (ang < (2 * pi)) do begin

    dl.x := - dlm * sin(ang);
    dl.y := dlm * cos(ang);
    dl.z := 0;

    qx := TorusRadius * cos(ang);
    qy := TorusRadius * sin(ang);
    qz := TorusDistance;

    rr.x := x - qx;
    rr.y := y - qy;
    rr.z := z - qz;

    rm := sqrt(rr.x * rr.x + rr.y * rr.y + rr.z * rr.z);

    sna := sqrt(1 - (dl.x * rr.x + dl.y * rr.y + dl.z * rr.z) *
                    (dl.x * rr.x + dl.y * rr.y + dl.z * rr.z)
                    / rm / rm / dlm / dlm);

    m2 := (dlm / 2) * Amperage * sna / rm / rm;

    v22.x := rr.y * dl.z - rr.z * dl.y;
    v22.y := rr.z * dl.x - rr.x * dl.z;
    v22.z := rr.x * dl.y - rr.y * dl.x;

    lll := sqrt(v22.x * v22.x + v22.y * v22.y + v22.z * v22.z);

    v2.x := v2.x + m2 * (v22.x / lll);
    v2.y := v2.y + m2 * (v22.y / lll);
    v2.z := v2.z + m2 * (v22.z / lll);

    ang := ang + dAngle;
  end;
  ang := 0;
  dlm := TorusRadius * sin(dAngle);

  while (ang < (2 * pi)) do begin
    // showmessage(floattostr(ang));

    dl.x := - dlm * sin(ang);
    dl.y := dlm * cos(ang);
    dl.z := 0;

    qx := TorusRadius * cos(ang);
    qy := TorusRadius * sin(ang);
    qz := -TorusDistance;

    rr.x := x - qx;
    rr.y := y - qy;
    rr.z := z - qz;

    rm := sqrt(rr.x * rr.x + rr.y * rr.y + rr.z * rr.z);

    sna := sqrt(1 - (dl.x * rr.x + dl.y * rr.y + dl.z * rr.z) *
                    (dl.x * rr.x + dl.y * rr.y + dl.z * rr.z)
                    / rm / rm / dlm / dlm);

    m2 := (dlm / 2) * Amperage * sna / rm / rm;

    v22.x := rr.y * dl.z - rr.z * dl.y;         //��������� ������������
    v22.y := rr.z * dl.x - rr.x * dl.z;
    v22.z := rr.x * dl.y - rr.y * dl.x;

    lll := sqrt(v22.x * v22.x + v22.y * v22.y + v22.z * v22.z);

    v2.x := v2.x + m2 * (v22.x / lll);
    v2.y := v2.y + m2 * (v22.y / lll);
    v2.z := v2.z + m2 * (v22.z / lll);

    ang := ang + dAngle;
  end;

  result.x := v1.x + v2.x + v3.x;
  result.y := v1.y + v2.y + v3.y;
  result.z := v1.z + v2.z + v3.z;
  result.l := sqrt(result.x * result.x + result.y * result.y +
                                                    result.z * result.z);
end;

procedure  TThreeRingsConfig.Reshape();
const Pi2 = 2 * Pi;
var i ,j, k, n, numc, numt: integer;
  s, t, x, y, z, offset: double;
begin
    BaseGeometry := glGenLists(1);
    numc := 6;
    numt := 50;
    offset := -TorusDistance;
    glNewList(BaseGeometry, GL_COMPILE);
    for n := 0 to 2 do begin
       for i := 0 to numc - 1 do begin
             glBegin(GL_QUAD_STRIP);
              for j := 0 to numt do begin
                      for k := 1 downto 0 do begin
                      s := (i + k) mod numc + 0.5;
                      t := j mod numt;
                      x := (TorusRadius + 0.1*cos(s * Pi2/numc))*cos(t*Pi2/numt);
                      y := (TorusRadius + 0.1*cos(s * Pi2/numc))*sin(t*Pi2/numt);
                      z := offset + 0.1*sin(s * Pi2/numc);
                      glColor3f(1, 0.3, 0.25);
                      glVertex3f(x, y, z);
                      end;
              end;
              glEnd;
       end;
       offset := offset + TorusDistance;
    end;
    glEndList();

end;
procedure  TThreeRingsConfig.DrawWire();
begin
    glCallList(BaseGeometry);
    if DisplayLines then
    glCallList(Lines);

end;

end.                              
