unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LCLProc, Forms, LResources, Buttons,
  StdCtrls, ExtCtrls, Dialogs, Graphics, IntfGraphics, GL, FPimage, OpenGLContext,
  WireConfigs;

type
  TMainForm = class(TForm)
    OpenGLController: TOpenGLControl;
    EditRadius: TEdit;    //Радиус
    EditI: TEdit;   //Сила тока
    ConfigsComboBox: TComboBox;
    Button1: TButton;
    Config: TWireConfig;

    procedure FormResize(Sender: TObject);
    procedure OpenGLControllerPaint(Sender: TObject);
    procedure OpenGLControllerResize(Sender: TObject);

  private
    GLAreaInitialized: boolean;
  public
    constructor Create(TheOwner: TComponent); override;
    //destructor Destroy; override;
  end;

var
  Form1: TMainForm;

implementation

{$R *.lfm}
constructor TMainForm.Create(TheOwner: TComponent);
var Names: TStringList;
begin
  inherited CreateNew(TheOwner);

  SetBounds((Screen.Width-800) div 2,(Screen.Height-600) div 2,800,600);
  OnResize := @FormResize;

  Names := TStringList.Create; //Setting Configuraion names
  Names.Add('3 Rings');
  Names.Add('Parallel');
  Names.Add('Perpendicular');
  Names.Add('Wire and coil');

  Config := ThreeRingsConfig.Create;
  with Config do begin
    Load(Form1);
    Calculate();
  end;

  ConfigsComboBox := TComboBox.Create(Self); //A selection of different configs
  with ConfigsComboBox do begin
    Items := Names;
    ItemIndex := 0;
    ReadOnly := true;
    Parent := Self;
  end;


  FormResize(Self);

  OpenGLController := TOpenGLControl.Create(Self);
    with OpenGLController do begin
      Name:='OpenGLController';
      Parent:=Self;
      SetBounds(300,30,380,200);
      OnPaint:=@OpenGLControllerPaint;
      OnResize:=@OpenGLControllerResize;
    end;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  if OpenGLController <> nil then
             OpenGLController.SetBounds(300, 30, Width-330, Height-40);
  ConfigsComboBox.SetBounds(0, 0, 100, 25);
end;

//OpenGl
procedure TMainForm.OpenGLControllerPaint(Sender: TObject);
begin
     if OpenGLController.MakeCurrent then
                begin
                  if not GLAreaInitialized then begin
                    glMatrixMode (GL_PROJECTION);
                    glLoadIdentity ();
                    glFrustum (-1.0, 1.0, -1.0, 1.0, 1.5, 20.0);
                    glMatrixMode (GL_MODELVIEW);
                    glViewport (0, 0, OpenGLController.Width, OpenGLController.Height);
                    GLAreaInitialized := true;
                  end;

                  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
                  glLoadIdentity();
                  glTranslatef (0.0, 0.0,-3.0);
                  OpenGLController.SwapBuffers;
                end;
end;

procedure TMainForm.OpenGLControllerResize(Sender: TObject);
begin
  if (GLAreaInitialized) and OpenGLController.MakeCurrent then
             glViewport(0, 0, OpenGLController.Width, OpenGLController.Height);
end;

end.

