program Lines;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazopenglcontext, MainForm, Cameras, wireconfig, WireConfigs,
  ThreeRingsConfig, ParallelConfig, PerpendicularConfig, vector4unit,
IrregularWireConfig, FormInterface
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, Form1);
  Application.Run;
end.

