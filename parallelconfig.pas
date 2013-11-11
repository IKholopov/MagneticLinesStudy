unit ParallelConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, Forms, wireconfig;
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
    private
         X1, Y1, X2, Y2, Amperage1, Amperage2: real;
    public
         constructor Create();
         procedure Load(Form: TForm); override;
         function Calculate(x, y, z: real): boolean; override;
         procedure Reshape(); override;
         procedure DrawWire(); override;
  end;

implementation

constructor TParallelConfig.Create();
begin
  LinesLength := 0;
end;

procedure  TParallelConfig.Load(Form: TForm);
begin
  Amperage1 := 0;
  Amperage2 := 0;
  X1 := -10;
  Y1 := -10;
  X2 := 10;
  Y2 := 10;
  DisplayLines := false;
  Reshape();
  X1Label := TLabel.Create(Form);
  with X1Label do begin
     Caption := 'X1:';
     SetBounds(10,32, 40, 40);
     Parent := Form;
  end;
  X1Edit := TEdit.Create(Form);
  with X1Edit do begin
    Text := FloatToStr(X1);
    //OnChange := @RadiusEditUpdate;
    Parent := Form;
    SetBounds(70,30, 60, 40);
  end;
  Y1Label := TLabel.Create(Form);
  with Y1Label do begin
     Caption := 'Y1:';
     SetBounds(10,57, 40, 40);
     Parent := Form;
  end;
  Y1Edit := TEdit.Create(Form);
  with Y1Edit do begin
    Text := FloatToStr(Y1);
    //OnChange := @RadiusEditUpdate;
    Parent := Form;
    SetBounds(30,55, 40, 40);
    end;
  X2Label := TLabel.Create(Form);
  with X2Label do begin
     Caption := 'X2:';
     SetBounds(75,37, 40, 40);
     Parent := Form;
  end;
  X2Edit := TEdit.Create(Form);
  with X2Edit do begin
    Text := FloatToStr(X2);
    //OnChange := @RadiusEditUpdate;
    Parent := Form;
    SetBounds(92,35, 40, 40);
  end;
  Y2Label := TLabel.Create(Form);
  with Y2Label do begin
     Caption := 'Y2:';
     SetBounds(75,57, 40, 40);
     Parent := Form;
  end;
  Y2Edit := TEdit.Create(Form);
  with Y2Edit do begin
    Text := FloatToStr(Y2);
    //OnChange := @RadiusEditUpdate;
    Parent := Form;
    SetBounds(92,55, 40, 40);
  end;
  I1Label := TLabel.Create(Form);
  with I1Label do begin
     Caption := 'I1:';
     SetBounds(12,77, 40, 40);
     Parent := Form;
  end;
  I1Edit := TEdit.Create(Form);
  with I1Edit do begin
    Text := FloatToStr(Amperage1);
    //OnChange := @RadiusEditUpdate;
    Parent := Form;
    SetBounds(30,75, 40, 40);
  end;
  I2Label := TLabel.Create(Form);
  with I2Label do begin
     Caption := 'Amperage 2:';
     SetBounds(10,32, 40, 40);
     Parent := Form;
  end;
  I2Edit := TEdit.Create(Form);
  with I2Edit do begin
    Text := FloatToStr(Amperage2);
    //OnChange := @RadiusEditUpdate;
    Parent := Form;
    SetBounds(70,30, 100, 40);
  end;

end;

function TParallelConfig.Calculate(x, y, z: real): boolean;
begin
  Result := true;
end;

procedure  TParallelConfig.Reshape();
begin
end;
procedure  TParallelConfig.DrawWire();
begin
end;

end.

