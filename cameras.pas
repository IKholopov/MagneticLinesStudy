unit Cameras;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GL, LCLType, Keyboard;

  {$M+}
type
  Camera = class
  private
        Rotation: real;
  public
    constructor Create();
    procedure Update();
  end;

implementation

constructor Camera.Create();
begin
  Rotation := 45;
end;

procedure Camera.Update();
begin
  //IsKeyPressed(VK_LEFT);
  Rotation := Rotation + 0.3;
  glRotatef(Rotation, 0, 1, 0);
end;



end.
