unit WireConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, GL;
 {$M+}
type
  vector3 = record
          X, Y, Z: extended;
  end;

  TWireConfig = class(TObject)
  private

  public
        Lines: array[0..20000] of GLuint;
        Vectors: array[0..199] of vector3;
        procedure Load(Form: TForm); virtual;
        function Calculate(x, y, z: real):boolean; virtual;
        procedure DrawWire(); virtual;
  end;   
  
  implementation


     {TWireConfig}
procedure  TWireConfig.Load(Form: TForm);
begin
  raise exception.Create('Absract class TWireConfig doesnt implement Load(Form)');
end;

function TWireConfig.Calculate(x, y, z: real): boolean;
begin
  raise exception.Create('Absract class TWireConfig doesnt implement Calculate()');
end;

procedure  TWireConfig.DrawWire();
begin
  raise exception.Create('Absract class TWireConfig doesnt implement DrawWire()');
end;  

end.