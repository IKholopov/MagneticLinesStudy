unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LCLProc, LCLType, Forms, LResources, Buttons,
  StdCtrls, ExtCtrls, Dialogs, Graphics, IntfGraphics, GL, FPimage, OpenGLContext,
  WireConfigs, Cameras;

type
  TMainForm = class(TForm)
    OpenGLController: TOpenGLControl;
    ConfigsComboBox: TComboBox;
    XLabel: TLabel;
    XCordEdit: TEdit;
    YLabel: TLabel;
    YCordEdit: TEdit;
    ZLabel: TLabel;
    ZCordEdit: TEdit;
    CalculateButton: TButton;
    Config: TWireConfig;
    Camera1: Camera;

    procedure FormResize(Sender: TObject);
    procedure OpenGLControllerPaint(Sender: TObject);
    procedure OpenGLControllerResize(Sender: TObject);
    procedure DrawCoords();
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure IdleFunc(Sender: TObject; var Done: Boolean);

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
var
  Names: TStringList;
begin

  inherited CreateNew(TheOwner);
  Application.OnIdle := @IdleFunc;
  Form1.KeyPreview:=true;
  Form1.OnKeyDown:=@FormKeyDown;
  //SetBounds((Screen.Width - 800) div 2, (Screen.Height - 600) div 2, 800, 600);
  SetBounds((Screen.Width - 1280) div 2, (Screen.Height - 720) div 2, 1280, 720);
  OnResize := @FormResize;

  Camera1 := Camera.Create();

  Names := TStringList.Create; //Setting Configuraion names
  Names.Add('3 Rings');
  Names.Add('Parallel');
  Names.Add('Perpendicular');
  Names.Add('Wire and coil');

  Config := ThreeRingsConfig.Create;
  with Config do
  begin
    Load(Form1);
    Calculate();
  end;

  ConfigsComboBox := TComboBox.Create(Self); //A selection of different configs
  with ConfigsComboBox do
  begin
    Items := Names;
    ItemIndex := 0;
    ReadOnly := True;
    Parent := Self;
  end;

  XLabel := TLabel.Create(Self);
  with XLabel do
  begin
    Caption := 'X:';
    SetBounds(10, 355, 20, 40);
    Parent := Self;
  end;
  XCordEdit := TEdit.Create(Self);
  with XCordEdit do
  begin
    SetBounds(20, 350, 100, 40);
    Parent := Self;
  end;

  YLabel := TLabel.Create(Self);
  with YLabel do
  begin
    Caption := 'Y:';
    SetBounds(10, 385, 20, 40);
    Parent := Self;
  end;
  YCordEdit := TEdit.Create(Self);
  with YCordEdit do
  begin
    SetBounds(20, 380, 100, 40);
    Parent := Self;
  end;

  ZLabel := TLabel.Create(Self);
  with ZLabel do
  begin
    Caption := 'Z:';
    SetBounds(10, 415, 20, 40);
    Parent := Self;
  end;
  ZCordEdit := TEdit.Create(Self);
  with ZCordEdit do
  begin
    SetBounds(20, 410, 100, 40);
    Parent := Self;
  end;

  CalculateButton := TButton.Create(Self);
  with CalculateButton do
  begin
    Caption := 'Calculate';
    SetBounds(20, 450, 80, 30);
    Parent := Self;
  end;

  FormResize(Self);

  OpenGLController := TOpenGLControl.Create(Self);
  with OpenGLController do
  begin
    Name := 'OpenGLController';
    Parent := Self;
    SetBounds(300, 30, 380, 200);
    OnPaint := @OpenGLControllerPaint;
    OnResize := @OpenGLControllerResize;
  end;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  if OpenGLController <> nil then
    OpenGLController.SetBounds(300, 30, Width - 330, Height - 40);
  ConfigsComboBox.SetBounds(0, 0, 100, 25);
end;

//OpenGl
procedure TMainForm.OpenGLControllerPaint(Sender: TObject);
begin
  if OpenGLController.MakeCurrent then
  begin
    if not GLAreaInitialized then
    begin
      glMatrixMode(GL_PROJECTION);
      glLoadIdentity();
      glFrustum(-1.0, 1.0, -1.0, 1.0, 1.5, 20.0);
      glMatrixMode(GL_MODELVIEW);
      glViewport(0, 0, OpenGLController.Width, OpenGLController.Height);
      GLAreaInitialized := True;
    end;

    glClearColor(0.942,0.942,0.942,1.0);
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
    glLoadIdentity;
    glTranslatef(0, 0, -2*Pi);
    glPushMatrix;
    Camera1.Update();
    DrawCoords();
    Config.DrawWire();
    glPushMatrix;
    OpenGLController.SwapBuffers;
  end;
end;

procedure TMainForm.DrawCoords();
begin
  glBegin(GL_LINES);
    //Z
    glColor3f(1,0.4,0 );
    glVertex3f(0, 0, -50);
    glVertex3f(0, 0, 50);
    glVertex3f(0, 0.1, 3);
    glVertex3f(0, 0, 3.5);
    glVertex3f(0, -0.1, 3);
    glVertex3f(0, 0, 3.5);

    glVertex3f(0, 0.3, 3.2);
    glVertex3f(0, 0.3, 3.3);
    glVertex3f(0, 0.3, 3.3);
    glVertex3f(0, 0.2, 3.2);
    glVertex3f(0, 0.2, 3.2);
    glVertex3f(0, 0.2, 3.3);

    //Y
    glColor3f(1,0.4,0 );
    glVertex3f(0, -50, 0);
    glVertex3f(0, 50, 0);
    glVertex3f(0, 3, 0.1);
    glVertex3f(0, 3.5, 0);
    glVertex3f(0, 3, -0.1);
    glVertex3f(0, 3.5, 0);

    glVertex3f(0, 3.8, -0.5);
    glVertex3f(0, 3.6, -0.4);
    glVertex3f(0, 3.6, -0.4);
    glVertex3f(0, 3.8, -0.3);
    glVertex3f(0, 3.6, -0.4);
    glVertex3f(0, 3.4, -0.4);
   glEnd;
end;

procedure TMainForm.OpenGLControllerResize(Sender: TObject);
begin
  if (GLAreaInitialized) and OpenGLController.MakeCurrent then
    glViewport(0, 0, OpenGLController.Width, OpenGLController.Height);
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
    if Key =  VK_RIGHT then
      Camera1.Rotate(0,-5,0);
    if Key =  VK_LEFT then
      Camera1.Rotate(0,5,0);
    if Key =  VK_UP then
      Camera1.Rotate(5,0,0);
    if Key =  VK_DOWN then
      Camera1.Rotate(-5,0,0);
end;

procedure TMainForm.IdleFunc(Sender: TObject; var Done: Boolean);
begin
  OpenGLController.Invalidate;
  Done:=false;
end;

end.
