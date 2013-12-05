unit Cameras;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GL, LCLType, Keyboard;

  {$M+}
type
  Rotation = class
    public
      X,Y,Z:double;
  end;
  Camera = class
  private
        Rotating: Rotation;
        Scaling:double;
  public
    constructor Create();
    procedure Update();
    procedure Rotate(x,y,z:double);
    procedure Scale(s: double);
  end;


implementation

constructor Camera.Create();
begin
  Rotating := Rotation.Create;
  Rotating.X := 30;
  Rotating.Y := -45;
  Rotating.Z := 0;
  Scaling := -2;
end;

procedure Camera.Update();
begin
      glTranslatef(0, 0, Scaling);
      glRotatef(Rotating.X,1,0,0);
      glRotatef(Rotating.Y,0,1,0);
      glRotatef(Rotating.Z,0,0,1);

end;

procedure Camera.Rotate(x,y,z:double);
begin
      Rotating.X := Rotating.X + x;
      if Rotating.X > 90 then Rotating.X := 90;
      if Rotating.X < -90 then Rotating.X := -90;
      Rotating.Y := Rotating.Y + y;
      if Rotating.y > 360 then Rotating.Y := Rotating.Y -360;
      Rotating.Z := Rotating.Z + z;
      if Rotating.Z > 360 then Rotating.Z := Rotating.Z -360;
end;
procedure Camera.Scale(s: double);
begin
      Scaling := Scaling + s;
end;

end.
