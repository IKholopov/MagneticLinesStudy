unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LCLProc, LCLType, Forms, LResources, Buttons,
  StdCtrls, ExtCtrls, ComCtrls, Dialogs, Graphics, IntfGraphics, GL, FPimage, OpenGLContext,
  WireConfigs, Cameras, FormInterface;

type
  TMainForm = class(TForm)
    OpenGLController: TOpenGLControl;
    ConfigsComboBox: TComboBox;
    ResolutionLabel: TLabel;
    ResolutionEdit: TEdit;
    XLabel: TLabel;
    XCordEdit: TEdit;
    YLabel: TLabel;
    YCordEdit: TEdit;
    ZLabel: TLabel;
    ZCordEdit: TEdit;
    ProgressBar: TProgressBar;
    Message: TLabel;
    StatusIcon:TImage;
    FormGui: TFormInterface;
    CalculateButton: TButton;
    ResetButton: TButton;
    ThreeRings, Parallel, Perpendicular, WireAndCoil, WireAngle, Triangle,
      Config: TWireConfiguration;
    Camera1: Camera;

    procedure FormResize(Sender: TObject);
    procedure OpenGLControllerPaint(Sender: TObject);
    procedure OpenGLControllerResize(Sender: TObject);
    procedure InitCoords();
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CalculateClick(Sender: TObject);
    procedure ResetClick(Sender: TObject);
    procedure IdleFunc(Sender: TObject; var Done: Boolean);
    procedure OnChangeConfig(Sender: TObject);

  private
    GLAreaInitialized: boolean;
    Coords: GLuint;
  public
    constructor Create(TheOwner: TComponent); override;
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
  Names.Add('Bent wire');
  Names.Add('Triangle');


  ConfigsComboBox := TComboBox.Create(Self); //A selection of different configs
  with ConfigsComboBox do
  begin
    Items := Names;
    ItemIndex := 0;
    ReadOnly := True;
    Parent := Self;
    OnChange := @OnChangeConfig;
  end;

  ResolutionLabel := TLabel.Create(Self);
  with ResolutionLabel do
  begin
    Caption := 'Resolution:';
    SetBounds(30, 290, 50, 40);
    Parent := Self;
  end;
  ResolutionEdit := TEdit.Create(Self);
  with ResolutionEdit do
  begin
    SetBounds(30, 310, 80, 40);
    Text := FloatToStr(TWireConfiguration.MAX_EDGES);
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
    SetBounds(25, 350, 100, 40);
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
    SetBounds(25, 380, 100, 40);
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
    SetBounds(25, 410, 100, 40);
    Parent := Self;
  end;
  ProgressBar := TProgressBar.Create(Self);
  with ProgressBar do
  begin
    Parent := Self;
    SetBounds(20,500, 80, 20);
    Visible := false;
  end;
  Message := TLabel.Create(Self);
  with Message do
  begin
    Parent := Self;
    SetBounds (50, 600, 500, 200);
  end;
  StatusIcon := TImage.Create(Self);
  with StatusIcon do begin
    Parent := Self;
    SetBounds (20, 600, 24, 24);
  end;
  FormGui := TFormInterface.Create(ProgressBar, Message, StatusIcon);

  CalculateButton := TButton.Create(Self);
  with CalculateButton do
  begin
    Caption := 'Calculate';
    SetBounds(20, 450, 80, 30);
    Parent := Self;
    OnClick := @CalculateClick;
  end;
  ResetButton := TButton.Create(Self);
  with ResetButton do
  begin
    Caption := 'Reset';
    SetBounds(20, 550, 60, 30);
    Parent := Self;
    OnClick := @ResetClick;
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

  ThreeRings := ThreeRingsConfiguration.Create(FormGui);
  with ThreeRings do
  begin
    Load(Form1);
  end;
  Parallel := ParallelConfiguration.Create(FormGui);
  with Parallel do
  begin
    Load(Form1);
    Hide();
  end;
  Perpendicular := PerpendicularConfiguration.Create(FormGui);
  with  Perpendicular do
  begin
    Load(Form1);
    Hide();
  end;
  WireAndCoil := WireAndCoilConfiguration.Create(FormGui);
  with  WireAndCoil do
  begin
    Load(Form1);
    Hide();
  end;
  WireAngle := WireAngleConfiguration.Create(FormGui);
  with  WireAngle do
  begin
    Load(Form1);
    Hide();
  end;
  Triangle := TriangleConfiguration.Create(FormGui);
  with Triangle do
  begin
    Load(Form1);
    Hide();
  end;
  Config := ThreeRings;
end;
procedure TMainForm.OnChangeConfig(Sender: TObject);
begin
  Config.Hide();
  FormGui.ClearMessage();
   if ConfigsComboBox.ItemIndex = 0 then
   begin
     Config := ThreeRings;
     Config.Show();
   end;
   if ConfigsComboBox.ItemIndex = 1 then
   begin
     Config := Parallel;
     Config.Show();
   end;
   if ConfigsComboBox.ItemIndex = 2 then
   begin
     Config := Perpendicular;
     Config.Show();
   end;
   if ConfigsComboBox.ItemIndex = 3 then
   begin
     Config := WireAndCoil;
     Config.Show();
   end;
   if ConfigsComboBox.ItemIndex = 4 then
   begin
     Config := WireAngle;
     Config.Show();
   end;
   if ConfigsComboBox.ItemIndex = 5 then
   begin
     Config := Triangle;
     Config.Show();
   end;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  if OpenGLController <> nil then
    OpenGLController.SetBounds(300, 30, Width - 440, Height - 40);
  ConfigsComboBox.SetBounds(0, 0, 100, 25);
end;

//OpenGl
procedure TMainForm.OpenGLControllerPaint(Sender: TObject);
const lights: array[0..3] of GLfloat = (4,4, 10, 1);
   mat_specular: array[0..3] of GLfloat = (1.0, 1.0, 1.0, 1.0);
   mat_shininess: array[0..0] of GLfloat = (120.0);
begin
  if OpenGLController.MakeCurrent then
  begin
    if not GLAreaInitialized then
    begin
      glMatrixMode(GL_PROJECTION);
      glLoadIdentity();
      glFrustum(-1.0, 1.0, -1.0, 1.0, 1, 1000.0);
      glShadeModel (GL_SMOOTH);
      glMaterialfv(GL_FRONT, GL_SPECULAR, mat_specular);
      glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess);
      glLightfv(GL_LIGHT0, GL_POSITION, lights);
      glEnable(GL_LIGHTING);
      InitCoords();
      Config.Reshape();
      glEnable(GL_LIGHT0);
      glMatrixMode(GL_MODELVIEW);
      glViewport(0, 0, OpenGLController.Width, OpenGLController.Height);
      glEnable(GL_DEPTH_TEST);
      GLAreaInitialized := True;
    end;

    glClearColor(0.942,0.942,0.942,1.0);
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
    glEnable(GL_COLOR_MATERIAL);
    glLoadIdentity;
    glTranslatef(0, 0, -4*Pi);

    glMatrixMode(GL_MODELVIEW);
    Camera1.Update();
    glLightfv(GL_LIGHT0, GL_POSITION, lights);
    glCallList(Coords);
    Config.DrawWire();
    OpenGLController.SwapBuffers;
  end;
end;

procedure TMainForm.InitCoords();
const R = 0.25;
   PositionArrow = 6.5;
var i: integer;
  x, y, z, angle: real;
begin
  Coords := glGenLists(1);
  glNewList(Coords, GL_COMPILE);
  glBegin(GL_LINES);
  //Z
    glColor3f(0.4,0,0.4 );
    glVertex3f(0, 0, -1000);
    glVertex3f(0, 0, 1000);
  glEnd();
  //Arrow
  glBegin(GL_TRIANGLE_FAN);
    glVertex3f(0, 0, PositionArrow);
    x := R;
    y := 0;
    angle := 0;
    for i := 0 to 50 do begin
       glVertex3f(x, y, PositionArrow - 1);
       angle := angle + Pi /25;
       x := R * cos(angle);
       y := R * sin(angle);
    end;
  glEnd();

  glBegin(GL_LINES);
  //Y
    glColor3f(1,0.4,0 );
    glVertex3f(0, -1000, 0);
    glVertex3f(0, 1000, 0);
  glEnd();
  //Arrow
  glBegin(GL_TRIANGLE_FAN);
    glVertex3f(0, PositionArrow, 0);
    x := R;
    z := 0;
    angle := 0;
    for i := 0 to 50 do begin
       glVertex3f(x, PositionArrow - 1, z);
       angle := angle + Pi /25;
       x := R * cos(angle);
       z := R * sin(angle);
    end;
  glEnd();

  glBegin(GL_LINES);
  //X
    glColor3f(0.4,0.4,0 );
    glVertex3f(-1000, 0, 0);
    glVertex3f(1000, 0, 0);
  glEnd();
  //Arrow
  glBegin(GL_TRIANGLE_FAN);
    glVertex3f(PositionArrow, 0, 0);
    y := R;
    z := 0;
    angle := 0;
    for i := 0 to 50 do begin
       glVertex3f(PositionArrow - 1, y, z);
       angle := angle + Pi /25;
       y := R * cos(angle);
       z := R * sin(angle);
    end;
  glEnd();
  glEndList();
end;

procedure TMainForm.OpenGLControllerResize(Sender: TObject);
begin
  if (GLAreaInitialized) and OpenGLController.MakeCurrent then
    glViewport(0, 0, OpenGLController.Width, OpenGLController.Height);
end;

//Forms methods

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
    if Key =  VK_RIGHT then
      Camera1.Rotate(0,-5,0);
    if Key =  VK_LEFT then
      Camera1.Rotate(0,5,0);
    if Key =  VK_UP then
       if (ssShift in Shift) or (ssCtrl in Shift)then
          Camera1.Scale(1)
       else Camera1.Rotate(5,0,0);
    if Key =  VK_DOWN then
    if (ssShift in Shift) or (ssCtrl in Shift) then
          Camera1.Scale(-1)
    else Camera1.Rotate(-5,0,0);
end;

procedure TMainForm.CalculateClick(Sender: TObject);
var x, y, z: double;
  resolution: integer;
begin
  if TryStrToInt(ResolutionEdit.Text,resolution) then
  begin
      if TryStrToFloat(XCordEdit.Text,x) and TryStrToFloat(YCordEdit.Text,y) and TryStrToFloat(ZCordEdit.Text, z)
      and (resolution  <= TWireConfiguration.MAX_EDGES) and (resolution  >= 100)then
      Config.Calculate(x, y, z, resolution)
      else FormGui.ShowMessage('Incorrect input!');
  end
  else FormGui.ShowMessage('Incorrect input!');
end;
procedure TMainForm.ResetClick(Sender: TObject);
var x, y, z: double;
begin
      Config.ResetLines();
end;

procedure TMainForm.IdleFunc(Sender: TObject; var Done: Boolean);
begin
  OpenGLController.Invalidate;
  Done:=false;
end;




end.
