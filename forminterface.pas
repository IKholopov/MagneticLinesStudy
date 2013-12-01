unit FormInterface;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, StdCtrls, ComCtrls, ExtCtrls;
     {$M+}
type TFormInterface = class
  private
     Bar: TProgressBar;
     Message: TLabel;
     Icon:TImage;
  public
     constructor Create(setBar: TProgressBar; setLabel: TLabel; setIcon: TImage);
     procedure ShowMessage(msg: string);
     procedure ShowMessage(msg: string; status: boolean);
     procedure StartProcess();
     procedure UpdateProcess(percentage: integer);
     procedure StopProcess();
     procedure ClearMessage();
  end;
implementation
     constructor TFormInterface.Create(setBar: TProgressBar; setLabel: TLabel; setIcon: TImage);
     begin
       bar := setBar;
       message := setLabel;
       icon := setIcon;
     end;

     procedure TFormInterface.ShowMessage(msg: string);
     begin
         Message.Caption:=msg;
     end;
     procedure TFormInterface.ShowMessage(msg: string; status: boolean);
     begin
         Message.Caption:=msg;
         if status then Icon.Picture.LoadFromFile('../res/green.png')
         else Icon.Picture.LoadFromFile('../res/red.png');
     end;
     procedure TFormInterface.StartProcess();
     begin
         bar.Visible:=true;
         bar.Position:=0;
     end;
     procedure TFormInterface.UpdateProcess(percentage: integer);
     begin
         bar.Position:=percentage;
     end;
     procedure TFormInterface.StopProcess();
     begin
         bar.Visible:=false;
     end;
     procedure TFormInterface.ClearMessage();
     begin
         Icon.Picture.Clear;
         Message.Caption := '';
     end;
end.

