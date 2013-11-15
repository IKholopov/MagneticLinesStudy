unit ParallelConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, ComCtrls, Forms, wireconfig;
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
         constructor Create(bar: TProgressBar);
         procedure Load(Form: TForm); override;
         procedure Show(); override;
         procedure Hide(); override;
         function Calculate(x, y, z: real): boolean; override;
         procedure Reshape(); override;
         procedure DrawWire(); override;
  end;

implementation

constructor TParallelConfig.Create(bar: TProgressBar);
begin
  ProgressBar := bar;
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
     SetBounds(10,37, 40, 40);
     Parent := Form;
  end;
  X1Edit := TEdit.Create(Form);
  with X1Edit do begin
    Text := FloatToStr(X1);
    //OnChange := @RadiusEditUpdate;
    Parent := Form;
    SetBounds(30,35, 40, 40);
  end;
  Y1Label := TLabel.Create(Form);
  with Y1Label do begin
     Caption := 'Y1:';
     SetBounds(10,59, 40, 40);
     Parent := Form;
  end;
  Y1Edit := TEdit.Create(Form);
  with Y1Edit do begin
    Text := FloatToStr(Y1);
    //OnChange := @RadiusEditUpdate;
    Parent := Form;
    SetBounds(30,57, 40, 40);
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
     SetBounds(75,59, 40, 40);
     Parent := Form;
  end;
  Y2Edit := TEdit.Create(Form);
  with Y2Edit do begin
    Text := FloatToStr(Y2);
    //OnChange := @RadiusEditUpdate;
    Parent := Form;
    SetBounds(92,57, 40, 40);
  end;
  I1Label := TLabel.Create(Form);
  with I1Label do begin
     Caption := 'I1:';
     SetBounds(12,81, 40, 40);
     Parent := Form;
  end;
  I1Edit := TEdit.Create(Form);
  with I1Edit do begin
    Text := FloatToStr(Amperage1);
    //OnChange := @RadiusEditUpdate;
    Parent := Form;
    SetBounds(30,78, 40, 40);
  end;
  I2Label := TLabel.Create(Form);
  with I2Label do begin
     Caption := 'I2:';
     SetBounds(75,79, 40, 40);
     Parent := Form;
  end;
  I2Edit := TEdit.Create(Form);
  with I2Edit do begin
    Text := FloatToStr(Amperage2);
    //OnChange := @RadiusEditUpdate;
    Parent := Form;
    SetBounds(92,78, 40, 40);
  end;

end;
procedure  TParallelConfig.Show();
  begin
    X1Edit.Visible:=true;
    X1Label.Visible:=true;
    Y1Edit.Visible:=true;
    Y1Label.Visible:=true;
    I1Edit.Visible:=true;
    I1Label.Visible:=true;
    X2Edit.Visible:=true;
    X2Label.Visible:=true;
    Y2Edit.Visible:=true;
    Y2Label.Visible:=true;
    I2Edit.Visible:=true;
    I2Label.Visible:=true;
end;
procedure  TParallelConfig.Hide();
begin
    X1Edit.Visible:=false;
    X1Label.Visible:=false;
    Y1Edit.Visible:=false;
    Y1Label.Visible:=false;
    I1Edit.Visible:=false;
    I1Label.Visible:=false;
    X2Edit.Visible:=false;
    X2Label.Visible:=false;
    Y2Edit.Visible:=false;
    Y2Label.Visible:=false;
    I2Edit.Visible:=false;
    I2Label.Visible:=false;
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

