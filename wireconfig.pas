unit WireConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, ComCtrls, GL;
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
        Vectors: array[0..200000] of vector3;
        VectorsLength: integer;
        ProgressBar: TProgressBar;
        constructor Create(bar: TProgressBar);
        procedure Load(Form: TForm); virtual;
        procedure Show(); virtual;
        procedure Hide();virtual;
        function Calculate(x, y, z: real):boolean; virtual;
        procedure Reshape(); virtual;
        procedure DrawWire(); virtual;
  end;   
  
  implementation


     {TWireConfig}
constructor TWireConfig.Create(bar: TProgressBar);
begin
  raise exception.Create('Absract class TWireConfig doesnt implement Constructor');
end;
procedure  TWireConfig.Load(Form: TForm);
begin
  raise exception.Create('Absract class TWireConfig doesnt implement Load(Form)');
end;
procedure  TWireConfig.Show();
  begin
    raise exception.Create('Absract class TWireConfig doesnt implement Show(Form)');
end;
procedure  TWireConfig.Hide();
begin
    raise exception.Create('Absract class TWireConfig doesnt implement Hide(Form)');
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
