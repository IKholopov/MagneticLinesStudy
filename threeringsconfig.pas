unit ThreeRingsConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, Forms, Dialogs, GL, wireconfig;
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
          UpdateConfigButton: TButton;
  private
         TorusDistance: real;
         Amperage:real;
         TorusRadius: real;
         function BField(x, y, z: extended): vector3;
         procedure EditIUpdate(Sender: TObject);
         procedure DistanceEditUpdate(Sender: TObject);
         procedure RadiusEditUpdate(Sender: TObject);

  public
         procedure Load(Form: TForm); override;
         function Calculate(x, y, z: real): boolean; override;
         procedure DrawWire(); override;
  end;

implementation

procedure  TThreeRingsConfig.Load(Form: TForm);
begin
  Amperage := 0;
  TorusRadius := 1;
  TorusDistance := 1;
  Lines[0] := 1;
  glNewList(Lines[1], GL_COMPILE);

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

procedure TThreeRingsConfig.RadiusEditUpdate(Sender: TObject);
begin
    TryStrToFloat(EditRadius.Text, TorusRadius);
end;
procedure TThreeRingsConfig.EditIUpdate(Sender: TObject);
begin
     TryStrToFloat(EditI.Text, Amperage);
end;
procedure TThreeRingsConfig.DistanceEditUpdate(Sender: TObject);
begin
    TryStrToFloat(DistanceEdit.Text, TorusDistance);
end;
//Calculations
function TThreeRingsConfig.Calculate(x, y, z: real): boolean;
const e = 0.05; ex = 0.01;
var i: integer;
dx, dy, dz, l: extended;
vt: vector3;
begin
  inc(Lines[0]);
  Lines[Lines[0]] := Lines[Lines[0] - 1] + 1;
  glNewList(Lines[Lines[0]], GL_COMPILE);
  Vectors[0].X := x;
  Vectors[0].Y := y;
  Vectors[0].Z := z;
  for i := 1 to 10000 do begin

    vt := BField(Vectors[i - 1].X, Vectors[i - 1].y, Vectors[i - 1].z);
    {write(vt.x:20:20, vt.y:20:20, vt.z:20:20);
    writeln;}
    l := sqrt(vt.x * vt.x + vt.y * vt.y + vt.z * vt.z);
    if (l < e) then begin
        showmessage(IntToStr(i));
      showmessage('No current!');
      break;
    end;
    //showmessage(FloatToStr(l));
    dx := ex * vt.x / l;
    dy := ex * vt.y / l;
    dz := ex * vt.z / l;
    Vectors[i].X := Vectors[i - 1].X + dx;
    Vectors[i].y := Vectors[i - 1].y + dy;
    Vectors[i].z := Vectors[i - 1].z + dz;
    {write((aofl[t].Nodes[i - 1].X + dx):20:20, ' ',
          (aofl[t].Nodes[i - 1].y + dy):20:20, ' ',
          (aofl[t].Nodes[i - 1].z + dz):20:20, ' ');
    writeln;}
    if (abs(Vectors[i].X - Vectors[0].X) < e) and
       (abs(Vectors[i].y - Vectors[0].y) < e) and
       (abs(Vectors[i].z - Vectors[0].z) < e) and
       (i > 150) then begin
        showmessage('yes!');
        exit;
      end;
    //inc(i);

  end;
  Result := true;
end;

function TThreeRingsConfig.BField(x, y, z:extended):vector3;
const dAngle = pi / 600;
var m2, lll, dlm, rm, sna: extended;
    v1, v2, v3: vector3;
    ang: extended; //текущий угол и шаг угла
    qx, qy, qz: extended; //положение точки Q
    dl, rr, v22: vector3; //вектор тока и вектор направления на точку
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

    v22.x := rr.y * dl.z - rr.z * dl.y;         //векторное произведение
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

  result.x := v1.x + v2.x + v3.x;
  result.y := v1.y + v2.y + v3.y;
  result.z := v1.z + v2.z + v3.z;
end;

procedure  TThreeRingsConfig.DrawWire();
const Pi2 = 2 * Pi;
var i ,j, k, n, numc, numt: integer;
  s, t, x, y, z, offset: double;
  torus: GLuint;
begin
    torus := glGenLists(1);
    numc := 6;
    numt := 50;
    offset := -TorusDistance;
    glNewList(torus, GL_COMPILE);
    for n := 0 to 2 do begin
       for i := 0 to numc - 1 do begin
             glBegin(GL_QUAD_STRIP);
              for j := 0 to numt do begin
                      for k := 1 downto 0 do begin
                      s := (i + k) mod numc + 0.5;
                      t := j mod numt;
                      x := (TorusRadius + 0.1*cos(s * Pi2/numc))*cos(t*Pi2/numt);
                      y := (TorusRadius + 0.1*cos(s * Pi2/numc))*sin(t*Pi2/numt);
                      z := offset*2 + 0.1*sin(s * Pi2/numc);
                      glColor3f(1, 0.3, 0.25);
                      glVertex3f(x, y, z);
                      end;
              end;
              glEnd;
       end;
       offset := offset + TorusDistance;
    end;
    glEndList();

    glCallList(torus);
    {glBegin(GL_LINES );
                     glVertex3f(0,0,0);
                     glVertex3f(Vectors[0].X, Vectors[0].Y, Vectors[0].Z);
    glEnd;}

end;

end.                              
