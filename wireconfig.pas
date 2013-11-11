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
        BaseGeometry: GLuint;
        Lines: GLuint;
        LinesLength: integer;
        DisplayLines: boolean;
        Vectors: array[0..10000] of vector3;
        VectorsLength: integer;
        procedure Load(Form: TForm); virtual;
        function Calculate(x, y, z: real):boolean; virtual;
        procedure Reshape(); virtual;
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
procedure  TWireConfig.Reshape();
begin
  raise exception.Create('Absract class TWireConfig doesnt implement Reshape()');
end;

end.
