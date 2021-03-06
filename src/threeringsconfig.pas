unit ThreeRingsConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, ComCtrls, Forms, Dialogs, GL, regularwireconfig, vector4unit;
 {$M+}
 type
 {TThreeRingsConfig}
  TThreeRingsConfig = class(TRegularWireConfig)
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
         procedure Load(Form: TForm); override;
         procedure Show(); override;
         procedure Hide(); override;
         function BField(x, y, z: extended): vector4; override;
         procedure Reshape(); override;
  end;

implementation

procedure  TThreeRingsConfig.Load(Form: TForm);
begin
  Amperage := 10;
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
    SetBounds(90,30, 100, 40);
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
    SetBounds(90,60, 100, 40);
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
    SetBounds(90,90, 100, 40);
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

end.                              
