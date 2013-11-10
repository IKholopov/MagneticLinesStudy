unit ParallelConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, wireconfig;
  {$M+}
  type
  {TParallelConfig}
  TParallelConfig = class(TWireConfig)
    X1Edit: TEdit;
    X1Label: TLabel;
    Y1Edit: TEdit;
    Y1Label: TLabel;
    I1Edit: TEdit;
    I1Label: TLabel;
    X2Edit: TEdit;
    X2Label: TLabel;
    Y2Edit: TEdit;
    Y2Label: TLabel;
    I2Edit: TEdit;
    I2Label: TLabel;
  end;

implementation

end.

