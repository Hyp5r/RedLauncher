; Set variables
#NoEnv
#Persistent
#SingleInstance,Force
SendMode,Input
SetWorkingDir,%A_ScriptDir%
FormatTime,Date,,yyyy/MM/dd
FormatTime,Time,,h:mm:ss tt

; Retrieve common Windows variables
EnvGet,Temp,Temp
EnvGet,Tmp,Tmp
EnvGet,WinDir,WinDir

; Script Variables
@ini = RedLauncher.ini
@install = %A_Temp%\af066a14-3a70-475c-b0d0-8309a2bfa118
@scriptname = RedLauncher
@version = 1.0.0 Alpha

; Is there an INI file that tells where Red-DiscordBot is?
#redfolder:
IfExist,%@ini%
{ IniRead,@mywillisgood,%@ini%,RedLauncher,MyWillIsGood
  IniRead,@redfolder,%@ini%,RedLauncher,Location
  IniRead,@alwayson,%@ini%,RedLauncher,AlwaysOn
  If @mywillisgood = 0
  { MsgBox,You just had to set MyWillIsGood to equal 0.  This means that you no longer agree to the disclaimer, so I no longer agree to work.  Set that value back to 1 and try again.
    ExitApp
    }
  Gosub,#launchred
  }

; The INI didn't exist or didn't have what I was looking for, so let's ask the user where Red-DiscordBot is.
#redfoldernew:
FileSelectFolder,@redfolder,,0,Please choose the folder where Red-DiscordBot is located.
If ErrorLevel
  ExitApp
IfNotExist,%@redfolder%/red.py
{ Loop,2
  { MsgBox,I didn't see red.py in the folder you selected.  Want to try again?
    FileSelectFolder,@redfolder,,0,Please choose the folder where Red-DiscordBot is located.
    If ErrorLevel
      ExitApp
    IfExist,%@redfolder%/red.py
      Break
    }
  }
IfNotExist,%@redfolder%/red.py
{ MsgBox,Listen`, I gave you a chance`, and you blew it.  Go download Red-DiscordBot and when you get everything done`, run this again.
  ExitApp
  }
IniWrite,1,%@ini%,RedLauncher,MyWillIsGood
IniWrite,%@redfolder%,%@ini%,RedLauncher,Location
IniWrite,0,%@ini%,RedLauncher,AlwaysOn

; So we know where everything is, let's try to launch the bot!
#launchred:
SetWorkingDir,%@redfolder%
IfNotExist,red.py
{ MsgBox,I couldn't launch red.py since it doesn't seem to exist.  Check the INI file and make sure it's correct.  Otherwise, delete the INI file and reselect the folder by running %@scriptname% again.
  ExitApp
  }

; ## TODO ## Check if Python is in the Windows PATH.

Run,python red.py,,Hide,@redpid
If ErrorLevel
{ MsgBox,Well`, I saw red.py.  Unfortunately`, I couldn't launch it.  May want to check if you have Python installed on your machine.
  ExitApp
  }
TrayTip,%@scriptname%,Red is now active!,15,1
Gosub,#redlifesupport

; Now let's monitor Red for when it closes.
#redlifesupport:
Process,WaitClose,%@redpid%,
@redmonitor = %ErrorLevel%
If @redmonitor = 0 ; Funnily enough, 0 in this case means it did close.  Otherwise, ErrorLevel would be the PID of the python process spawned.
  Gosub,#inioptions

; Red closed!  Well, let's see what we should do when this happens.
#inioptions:
If @alwayson = 1
  Gosub,#launchredagain
Else
  ExitApp

; You can't keep a good bot down.
#launchredagain:
IfNotExist,red.py
{ MsgBox,I couldn't launch red.py since it doesn't seem to exist.  Check the INI file and make sure it's correct.  Otherwise, delete the INI file and reselect the folder by running %@scriptname% again.
  ExitApp
  }
Run,python red.py,,Hide,@redpid
If ErrorLevel
{ MsgBox,Well`, I saw red.py.  Unfortunately`, I couldn't launch it.  May want to check if you have Python installed on your machine.
  ExitApp
  }
TrayTip,%@scriptname%,Red was relaunched successfully!,15,1
Gosub,#redlifesupport
