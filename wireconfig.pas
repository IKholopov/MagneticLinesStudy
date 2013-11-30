unit WireConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, ComCtrls, GL, vector4unit, forminterface;
 {$M+}
type
  TWireConfig = class(TObject)
                const MAX_EDGES = 200000;
  private

  public
        BaseGeometry: GLuint;
        Lines: array[0..100] of GLuint;
        CurrentLine: integer;
        DisplayLines: boolean;
        Vectors: array[0..2*MAX_EDGES] of vector4;
        VectorsLength: integer;
        Gui: TFormInterface;
        constructor Create(setGui: TFormInterface);
        procedure Load(Form: TForm); virtual;
        procedure Show(); virtual;
        procedure Hide();virtual;
        function Calculate(x, y, z: real):boolean; virtual;
        function BField(x, y, z:extended):vector4; virtual;
        procedure Reshape(); virtual;
        procedure DrawWire(); virtual;
        procedure ResetLines(); virtual;
  end;

  implementation


     {TWireConfig}
constructor TWireConfig.Create(setGui: TFormInterface);
begin
    raise exception.Create('Abstract class TWireConfig doesnt implement Constructor');
end;
procedure  TWireConfig.Load(Form: TForm);
begin
  raise exception.Create('Abstract class TWireConfig doesnt implement Load(Form)');
end;
procedure  TWireConfig.Show();
  begin
    raise exception.Create('Abstract class TWireConfig doesnt implement Show(Form)');
end;
procedure  TWireConfig.Hide();
begin
    raise exception.Create('Abstract class TWireConfig doesnt implement Hide(Form)');
end;
function TWireConfig.Calculate(x, y, z: real): boolean;
begin
  raise exception.Create('Abstract class TWireConfig doesnt implement Calculate(x, y, z: real)');
end;
function TWireConfig.BField(x, y, z:extended): vector4;
begin
  raise exception.Create('Abstract class TWireConfig doesnt implement BField(x, y, z:extended)');
end;

procedure  TWireConfig.Reshape();
begin
  raise exception.Create('Abstract class TWireConfig doesnt implement Reshape()');
end;
procedure  TWireConfig.DrawWire();
begin
  raise exception.Create('Abstract class TWireConfig doesnt implement DrawWire()');
end;
procedure  TWireConfig.ResetLines();
begin
     raise exception.Create('Abstract class TWireConfig doesnt ResetLines Reshape()');
end;

end.
