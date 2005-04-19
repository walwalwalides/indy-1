{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  11787: IdThreadComponent.pas
{
{   Rev 1.13    9/30/2004 2:26:04 PM  BGooijen
{ wrong property was referenced
}
{
{   Rev 1.12    2004.02.03 4:17:12 PM  czhower
{ For unit name changes.
}
{
{   Rev 1.11    2004.01.20 10:03:38 PM  czhower
{ InitComponent
}
{
{   Rev 1.10    09.11.2003 14:05:52  ARybin
{ AV
}
{
{   Rev 1.9    08.11.2003 20:03:20  ARybin
{ run-time active bug
}
{
    Rev 1.8    10/15/2003 8:48:58 PM  DSiders
  Added resource strings for exceptions raised when setting thread component
  properties.
}
{
{   Rev 1.7    2003.10.11 9:58:04 PM  czhower
{ Several bug fixes
}
{
{   Rev 1.6    2003.10.11 5:51:54 PM  czhower
{ -VCL fixes for servers
{ -Chain suport for servers (Super core)
{ -Scheduler upgrades
{ -Full yarn support
}
{
{   Rev 1.5    2003.09.30 7:48:02 PM  czhower
{ Fixed Loop and ThreadName
}
{
{   Rev 1.4    9/18/2003 07:40:52 PM  JPMugaas
{ Removed IdGlobal.
}
{
{   Rev 1.3    9/16/2003 04:47:22 PM  JPMugaas
{ Made some code follow the Indy conventions so it's easier to debug.
}
{
{   Rev 1.2    2003.07.01 4:14:38 PM  czhower
{ ThreadName and Loop added. Other bugs fixed.
}
{
{   Rev 1.1    06.03.2003 12:16:52  ARybin
{ adapted for new IdThread
}
{
{   Rev 1.0    11/13/2002 08:03:06 AM  JPMugaas
}
{-----------------------------------------------------------------------------
 UnitName: IdThreadComponent
 Author:   Andrew P.Rybin [magicode@mail.ru]
 Creation: 12.03.2002
 Version:  0.1.0
 Purpose:
 History:  Based on my TmcThread
 2002-05-03 -Andrew P.Rybin
   -St�phane Grob�ty (Fulgan) suggestion: component is Data owner, don't FreeAndNIL Data property
   -special TThread.OnTerminate support (it is sync-event)
 2002-05-23 -APR
   -right support for Thread terminate
-----------------------------------------------------------------------------}

unit IdThreadComponent;

interface

uses
  Classes,
  IdBaseComponent, IdException, IdGlobal, IdSysUtils, IdThread;

const
  IdThreadComponentDefaultPriority = tpNormal;
  IdThreadComponentDefaultStopMode = smTerminate;

type
  TIdThreadComponent = class;

  TIdExceptionThreadComponentEvent = procedure(Sender: TIdThreadComponent; AException: Exception) of object;
  TIdExceptionThreadComponentEventEx = procedure(Sender: TIdThreadComponent; AException: Exception; var VHandled: Boolean) of object;
  TIdNotifyThreadComponentEvent = procedure(Sender: TIdThreadComponent) of object;
  //TIdSynchronizeThreadComponentEvent = procedure(Sender: TIdThreadComponent; AData: Pointer) of object;

  TIdThreadComponent = class(TIdBaseComponent)
  protected
    FActive: Boolean;
    FLoop: Boolean;
    FPriority : TIdThreadPriority;
    FStopMode : TIdThreadStopMode;
    FThread: TIdThread;
    FThreadName: string;
    //
    FOnAfterExecute: TIdNotifyThreadComponentEvent;
    FOnAfterRun: TIdNotifyThreadComponentEvent;
    FOnBeforeExecute: TIdNotifyThreadComponentEvent;
    FOnBeforeRun: TIdNotifyThreadComponentEvent;
    FOnCleanup: TIdNotifyThreadComponentEvent;
    FOnException: TIdExceptionThreadComponentEvent;
    FOnRun: TIdNotifyThreadComponentEvent;
    FOnStopped: TIdNotifyThreadComponentEvent;
    FOnTerminate: TIdNotifyThreadComponentEvent;
    FOnHandleRunException: TIdExceptionThreadComponentEventEx;
    //
    procedure DoAfterExecute; virtual;
    procedure DoAfterRun; virtual;
    procedure DoBeforeExecute; virtual;
    procedure DoBeforeRun; virtual;
    procedure DoCleanup; virtual;
    procedure DoException(AThread: TIdThread; AException: Exception); virtual; //thev
    function DoHandleRunException(AException: Exception): Boolean; virtual;
    procedure DoRun; virtual;
    procedure DoStopped(AThread: TIdThread); virtual; //thev
    procedure DoTerminate(Sender: TObject); virtual; //thev
    function GetActive: Boolean;
    function GetData: TObject;
    function GetHandle: THandle;
    function GetPriority: TIdThreadPriority;
    function GetReturnValue: Integer;
    function GetStopMode: TIdThreadStopMode;
    function GetStopped: Boolean;
    function GetSuspended: Boolean;
    function GetTerminatingException: string;
    function GetTerminatingExceptionClass: TClass;
    function GetTerminated: Boolean;
    procedure InitComponent; override;
    function IsRunning: Boolean;
    procedure Loaded; override;
    procedure SetActive(const AValue: Boolean); virtual;
    procedure SetData(const AValue: TObject);
    procedure SetLoop(const AValue: Boolean);
    procedure SetThreadName(const AValue: string);
    procedure SetOnTerminate(const AValue: TIdNotifyThreadComponentEvent);
    procedure SetPriority(const AValue: TIdThreadPriority);
    procedure SetReturnValue(const AValue: Integer);
    procedure SetStopMode(const AValue: TIdThreadStopMode);
  public
    destructor Destroy; override;
    procedure Start; virtual;
    procedure Stop; virtual;
    procedure Synchronize(AMethod: TThreadMethod);
    procedure Terminate; virtual;
    procedure TerminateAndWaitFor; virtual;
    function WaitFor: LongWord;
    // Properties
    property Data: TObject read GetData write SetData;
    property Handle: THandle read GetHandle;
    property ReturnValue: Integer read GetReturnValue write SetReturnValue;
    property Stopped: Boolean read GetStopped;
    property Suspended: Boolean read GetSuspended;
    property TerminatingException: string read GetTerminatingException;
    property TerminatingExceptionClass: TClass read GetTerminatingExceptionClass;
    property Terminated: Boolean read GetTerminated;
  published
    property Active: Boolean read GetActive write SetActive;
    property Loop: Boolean read FLoop write SetLoop;
    property Priority: TIdThreadPriority read GetPriority write SetPriority;
    property StopMode: TIdThreadStopMode read GetStopMode write SetStopMode;
    property ThreadName: string read FThreadName write SetThreadName;
    // Events
    property OnAfterExecute: TIdNotifyThreadComponentEvent read FOnAfterExecute write FOnAfterExecute;
    property OnAfterRun: TIdNotifyThreadComponentEvent read FOnAfterRun write FOnAfterRun;
    property OnBeforeExecute: TIdNotifyThreadComponentEvent read FOnBeforeExecute write FOnBeforeExecute;
    property OnBeforeRun: TIdNotifyThreadComponentEvent read FOnBeforeRun write FOnBeforeRun;
    property OnCleanup: TIdNotifyThreadComponentEvent read FOnCleanup write FOnCleanup;
    property OnException: TIdExceptionThreadComponentEvent read FOnException write FOnException;
    property OnHandleRunException: TIdExceptionThreadComponentEventEx
     read FOnHandleRunException write FOnHandleRunException;
    property OnRun: TIdNotifyThreadComponentEvent read FOnRun write FOnRun;
    property OnStopped: TIdNotifyThreadComponentEvent read FOnStopped
     write FOnStopped;
    property OnTerminate: TIdNotifyThreadComponentEvent read FOnTerminate
     write SetOnTerminate;
  end;

  //For Component-writers ONLY!
  TIdThreadEx = class(TIdThread)
  protected
    FThreadComponent: TIdThreadComponent;
    //
    procedure AfterRun; override;
    procedure AfterExecute; override;
    procedure BeforeExecute; override;
    procedure BeforeRun; override;
    procedure Cleanup; override;
    function  HandleRunException(AException: Exception): Boolean; override;
    procedure Run; override;
  public
    constructor Create(AThreadComponent: TIdThreadComponent); reintroduce;
  end;

implementation

uses
  IdResourceStringsCore;

{ TIdThreadEx }

procedure TIdThreadEx.AfterExecute;
begin
  try
    FThreadComponent.DoAfterExecute;
  finally
    FThreadComponent.FActive := FALSE;
  end;
end;

procedure TIdThreadEx.AfterRun;
begin
  FThreadComponent.DoAfterRun;
end;

procedure TIdThreadEx.BeforeExecute;
begin
  FThreadComponent.DoBeforeExecute;
end;

procedure TIdThreadEx.BeforeRun;
begin
  FThreadComponent.DoBeforeRun;
end;

procedure TIdThreadEx.Cleanup;
begin
  inherited Cleanup;
  FThreadComponent.DoCleanup;
end;

constructor TIdThreadEx.Create(AThreadComponent: TIdThreadComponent);
begin
  inherited Create(True, AThreadComponent.Loop, iif(AThreadComponent.ThreadName = ''
   , AThreadComponent.Name, AThreadComponent.ThreadName));
  Exclude(FOptions, itoDataOwner); //TIdThreadComponent is data owner
  FThreadComponent := AThreadComponent;
  FOnException := FThreadComponent.DoException;
  FOnStopped := FThreadComponent.DoStopped;
end;

function TIdThreadEx.HandleRunException(AException: Exception): Boolean;
begin
  Result := FThreadComponent.DoHandleRunException(AException);
end;

procedure TIdThreadEx.Run;
begin
  FThreadComponent.DoRun;
end;

{ TIdThreadComponent }

procedure TIdThreadComponent.DoAfterExecute;
begin
  if Assigned(FOnAfterExecute) then
  begin
    FOnAfterExecute(SELF);
  end;
end;

procedure TIdThreadComponent.DoAfterRun;
begin
  if Assigned(FOnAfterRun) then
  begin
    FOnAfterRun(SELF);
  end;
end;

procedure TIdThreadComponent.DoBeforeExecute;
begin
  if Assigned(FOnBeforeExecute) then
  begin
    FOnBeforeExecute(SELF);
  end;
end;

procedure TIdThreadComponent.DoBeforeRun;
begin
  if Assigned(FOnBeforeRun) then
  begin
    FOnBeforeRun(SELF);
  end;
end;

procedure TIdThreadComponent.DoCleanup;
begin
  if Assigned(FOnCleanup) then
  begin
    FOnCleanup(SELF);
  end;
end;

destructor TIdThreadComponent.Destroy;
begin
  {FThread.TerminateAndWaitFor;}
  //make sure thread is not active before we attempt to destroy it
  if Assigned(FThread) then begin
    FThread.Terminate;
    FThread.Start;//resume for terminate
  end;
  Sys.FreeAndNIL(FThread);
  inherited Destroy;
end;

procedure TIdThreadComponent.DoException(AThread: TIdThread; AException: Exception);
begin
  if Assigned(FOnException) then begin
    FOnException(SELF,AException);
  end;
end;

function TIdThreadComponent.DoHandleRunException(AException: Exception): Boolean;
begin
  Result := FALSE;//not handled
  if Assigned(FOnHandleRunException) then begin
    FOnHandleRunException(SELF,AException,Result);
  end;
end;

procedure TIdThreadComponent.DoStopped(AThread: TIdThread);
begin
  if Assigned(FOnStopped) then begin
    FOnStopped(SELF);
  end;
end;

procedure TIdThreadComponent.DoTerminate;
begin
  if Assigned(FOnTerminate) then begin
    FOnTerminate(SELF);
  end;
end;

function TIdThreadComponent.GetData: TObject;
begin
  Result := FThread.Data;
end;

function TIdThreadComponent.GetHandle: THandle;
begin
  Result := GetThreadHandle(FThread);
end;

function TIdThreadComponent.GetReturnValue: Integer;
begin
  Result := FThread.ReturnValue;
end;

function TIdThreadComponent.GetStopMode: TIdThreadStopMode;
begin
  if FThread = NIL then begin
    Result := FStopMode;
  end else begin
    Result := FThread.StopMode;
  end;
end;

function TIdThreadComponent.GetStopped: Boolean;
begin
  if Assigned(FThread) then begin
    Result := FThread.Stopped;
  end else begin
    Result := TRUE;
  end;
end;

function TIdThreadComponent.GetSuspended: Boolean;
begin
  Result := FThread.Suspended;
end;

function TIdThreadComponent.GetTerminated: Boolean;
begin
  if Assigned(FThread) then begin
    Result := FThread.Terminated;
  end else begin
    Result := TRUE;
  end;
end;

function TIdThreadComponent.GetTerminatingException: string;
begin
  Result := FThread.TerminatingException;
end;

function TIdThreadComponent.GetTerminatingExceptionClass: TClass;
begin
  Result := FThread.TerminatingExceptionClass;
end;

procedure TIdThreadComponent.Loaded;
begin
  inherited Loaded;
  // Active = True must not be performed before all other props are loaded
  if Assigned(FThread) and Assigned(OnTerminate) then begin
    FThread.OnTerminate := DoTerminate;
  end;

  if FActive then begin
    // Retoggle for load since we ignore during loading until all properties
    // are ready
    FActive := False;
    Active := True;
  end;
end;

procedure TIdThreadComponent.DoRun;
begin
  if Assigned(FOnRun) then begin
    FOnRun(SELF);
  end;
end;

procedure TIdThreadComponent.SetActive(const AValue: Boolean);
begin
  if ((csDesigning in ComponentState) = False)
   and ((csLoading in ComponentState) = False) then begin
    if Active <> AValue then begin
      if AValue then begin
        Start;
      end else begin
        Stop;
      end;
    end;
  end;
  FActive := AValue;
end;

procedure TIdThreadComponent.SetData(const AValue: TObject);
begin
// this should not be accessed at design-time.
  FThread.Data := AValue;
end;

procedure TIdThreadComponent.SetReturnValue(const AValue: Integer);
begin
// this should not be accessed at design-time.
  FThread.ReturnValue := AValue;
end;

procedure TIdThreadComponent.SetStopMode(const AValue: TIdThreadStopMode);
begin
  if Assigned(FThread) and NOT FThread.Terminated then begin
    FThread.StopMode := AValue;
  end;
  FStopMode := AValue;
end;

procedure TIdThreadComponent.Start;
begin
  if NOT (csDesigning in ComponentState) then begin
    if Assigned(FThread) and FThread.Terminated then begin
      Sys.FreeAndNIL(FThread);
    end;

    if NOT Assigned(FThread) then begin
      FThread := TIdThreadEx.Create(SELF);
    end;

    // MUST read from F variants as thread is now created
    FThread.Name := FThreadName;
    FThread.Loop := FLoop;
    FThread.Priority := FPriority;
    FThread.StopMode := FStopMode;
    FThread.Start;
  end;
end;

procedure TIdThreadComponent.Stop;
begin
  if Assigned(FThread) then begin
    FThread.Stop;
  end;
end;

procedure TIdThreadComponent.Synchronize(AMethod: TThreadMethod);
begin
  FThread.Synchronize(AMethod);
end;

procedure TIdThreadComponent.Terminate;
begin
  FThread.Terminate;
end;

procedure TIdThreadComponent.TerminateAndWaitFor;
begin
  FThread.TerminateAndWaitFor;
end;

function TIdThreadComponent.WaitFor: LongWord;
begin
  Result := FThread.WaitFor;
end;

function TIdThreadComponent.GetPriority: TIdThreadPriority;
begin
  if FThread <> nil then begin
    Result := FThread.Priority;
  end else begin
    Result := FPriority;
  end;
end;

procedure TIdThreadComponent.SetPriority(const AValue: TIdThreadPriority);
begin
  if Assigned(FThread) then begin
    if not FThread.Terminated then begin
      FThread.Priority := AValue;
    end;
  end;
  FPriority := AValue;
end;

function TIdThreadComponent.GetActive: Boolean;
begin
  Result := False;
  if csDesigning in ComponentState then begin
    Result := FActive;
  end else if FThread <> nil then begin
    Result := IsRunning;
  end;
end;

procedure TIdThreadComponent.SetOnTerminate(const AValue: TIdNotifyThreadComponentEvent);
begin
  FOnTerminate := AValue;
  if Assigned(FThread) then begin
    if Assigned(AValue) then begin
      FThread.OnTerminate := DoTerminate;
    end else begin
      FThread.OnTerminate := nil;
    end;
  end;
end;

procedure TIdThreadComponent.SetLoop(const AValue: Boolean);
begin
  EIdException.IfTrue(IsRunning, RSThreadComponentLoopAlreadyRunning);
  FLoop := AValue;
end;

procedure TIdThreadComponent.SetThreadName(const AValue: string);
begin
  EIdException.IfTrue(IsRunning, RSThreadComponentThreadNameAlreadyRunning);
  FThreadName := AValue;
end;

function TIdThreadComponent.IsRunning: Boolean;
begin
  if FThread = nil then begin
    Result := False;
  end else begin
    Result := not FThread.Stopped
  end;
end;

procedure TIdThreadComponent.InitComponent;
begin
  inherited;
  StopMode := IdThreadComponentDefaultStopMode;
  Priority := IdThreadComponentDefaultPriority;
end;

end.

