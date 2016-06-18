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
@version = 1.0.0 Beta

; Is there an INI file that tells where Red-DiscordBot is?
#redfolder:
IfExist,%@ini%
{ IniRead,@mywillisgood,%@ini%,RedLauncher,mywillisgood
  IniRead,@location,%@ini%,RedLauncher,location
  IniRead,@checkforupdates,%@ini%,RedLauncher,checkforupdates
  IniRead,@alwayson,%@ini%,RedLauncher,alwayson
  If @mywillisgood = 0
  { MsgBox,You just had to set MyWillIsGood to equal 0.  This means that you no longer agree to the disclaimer, so I no longer agree to work.  Set that value back to 1 and try again.
    ExitApp
    }
  If @location =
    Gosub,#location
  Gosub,#launchred
  }

; The disclaimer to using this script.
#disclaimer:
MsgBox,4132,%@scriptname%,Alright`, here's the disclaimer. RedLauncher is completely unaffiliated with Red-DiscordBot and the developers. What this means is that if RedLauncher fails to work for you`, sets your computer on fire`, or decides to become sentinent and take over the world`, the developers of Red-DiscordBot are not to blame and will not assist you with this script. This script is not guaranteed to work for anyone other than the author and is provided to anyone on an as-is basis. You`'re free to post issues on the RedLauncher GitLab issue tracker should you come across anything that fails to work or if you have suggestions for the script. Do you agree?
IfMsgBox,Yes
  IniWrite,1,%@ini%,RedLauncher,MyWillIsGood
  Else
  ExitApp

; The INI didn't exist or didn't have what I was looking for, so let's ask the user where Red-DiscordBot is.
#location:
FileSelectFolder,@location,,0,Please choose the folder where Red-DiscordBot is located.
If ErrorLevel
  ExitApp
IfNotExist,%@location%/red.py
{ Loop,2
  { MsgBox,I didn't see red.py in the folder you selected.  Want to try again?
    FileSelectFolder,@location,,0,Please choose the folder where Red-DiscordBot is located.
    If ErrorLevel
      ExitApp
    IfExist,%@location%/red.py
      Break
    }
  }
IfNotExist,%@location%/red.py
{ MsgBox,Listen`, I gave you a chance`, and you blew it.  Go download Red-DiscordBot and when you get everything done`, run this again.
  ExitApp
  }
IniWrite,%@location%,%@ini%,RedLauncher,Location
Gosub,#checkforupdates

#checkforupdates:
MsgBox,4132,%@scriptname%,Would you like RedLauncher to automatically keep Red up-to-date? Please note that it requires that you have git installed and git is able to be used from the Windows Command Line.
IfMsgBox,Yes
  IniWrite,1,%@ini%,RedLauncher,checkforupdates
  Else
  IniWrite,0,%@ini%,RedLauncher,checkforupdates
Gosub,#alwayson

#alwayson:
MsgBox,4132,%@scriptname%,Would you like RedLauncher to automatically launch Red if it's shutdown?  This will make the [p]shutdown command useless!
IfMsgBox,Yes
  IniWrite,1,%@ini%,RedLauncher,alwayson
  Else
  IniWrite,0,%@ini%,RedLauncher,alwayson
Gosub,#launchred

; So we know where everything is, let's try to launch the bot!
#launchred:
SetWorkingDir,%@location%
IfNotExist,red.py
{ MsgBox,I couldn't launch red.py since it doesn't seem to exist.  Check the INI file and make sure it's correct.  Otherwise, delete the INI file and reselect the folder by running %@scriptname% again.
  ExitApp
  }

; Time to pull from Red-DiscordBot's repo.
If @checkforupdates = 1
{ SetWorkingDir,%@location%
  RunWait,*runas %comspec% /c cd %@location% & git pull & pip install --upgrade git+https://github.com/Rapptz/discord.py@async,,,
  }

Run,python red.py,%@location%,Hide,@redpid
If ErrorLevel
{ MsgBox,Well`, I saw red.py.  Unfortunately`, I couldn't launch it.  May want to check if you have Python installed on your machine and it's in the Windows PATH.
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
  TrayTip,%@scriptname%,Red was shutdown.,15,2
  Sleep,5000
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
