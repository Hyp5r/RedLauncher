;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;: TITLE: RedLauncher                                         :;
;: AUTHOR: William Quinn (wquinn@outlook.com)                 :;
;: PURPOSE: A frontend for the Red-DiscordClient.             :;
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;: RedLauncher was designed to automatically launch the       :;
;: Red-DiscordBot from wherever you installed it, while       :;
;: giving users the option to always keep Red up-to-date and  :;
;: shutdown-proof.                                            :;
;:                                                            :;
;: RedLauncher was designed to be used after the initial      :;
;: setup of Red-DiscordBot and will not work unless the       :;
;: directions for setting up Red-DiscordBot are followed      :;
;: exactly as written. You can view the instructions for      :;
;: installing Red-DiscordBot by going to:                     :;
;:                                                            :;
;: --------- https://twentysix26.github.io/Red-Docs --------- :;
;:                                                            :;
;: Red-DiscordBot was created by Twentysix26 and the source   :;
;: is located at:                                             :;
;:                                                            :;
;: ----- https://github.com/Twentysix26/Red-DiscordBot/ ----- :;
;:                                                            :;
;: Use of RedLauncher is provided as-is and the author is not :;
;: responsible for any issues that may arise by using this    :;
;: application. The author of RedLauncher is not affiliated   :;
;: in any way with Red-DiscordBot, Twentysix26, or any other  :;
;: developer / contributer to the Red-DiscordBot project.     :;
;:                                                            :;
;: The source of RedLauncher is located at:                   :;
;:                                                            :;
;: ------- https://gitlab.com/Hyperdaemon/RedLauncher ------- :;
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;: Set initial variables needed for script to function.       :;
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
#NoEnv
#NoTrayIcon
#Persistent
#SingleInstance,Force
SendMode,Input
SetWorkingDir,%A_ScriptDir%
FormatTime,Date,,yyyy-MM-dd
FormatTime,Time,,h:mm:ss tt
EnvGet,Temp,Temp
EnvGet,Tmp,Tmp
EnvGet,WinDir,WinDir
@install = %A_Temp%\af066a14-3a70-475c-b0d0-8309a2bfa118
@python = py.exe
@scriptname = RedLauncher
@version = 1.0.0
@ini = %@scriptname%.ini
@log = %A_ScriptDir%\%@scriptname%.log

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;: Check directory for INI file. If INI not found, ask the    :;
;: user the questions needed to create one.                   :;
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
#staged-checkforini:
IfExist,%@ini%
{ IniRead,@mywillisgood,%@ini%,RedLauncher,mywillisgood
  IniRead,@location,%@ini%,RedLauncher,location
  IniRead,@checkforupdates,%@ini%,RedLauncher,checkforupdates
  IniRead,@alwayson,%@ini%,RedLauncher,alwayson
  If @mywillisgood = 0
  { MsgBox,You just had to set MyWillIsGood to equal 0.  This means that you no longer agree to the disclaimer, so I no longer agree to work.  Set that value back to 1 and try again.
    ExitApp,43468
    }
  If @location =
    Gosub,#staged-askforlocation
  Gosub,#staged-verifyredpyexists
  }

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;: Read the user the disclaimer to using this program.        :;
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
#staged-disclaimer:
MsgBox,4132,%@scriptname%,Alright`, here's the disclaimer. RedLauncher is completely unaffiliated with Red-DiscordBot and the developers. What this means is that if RedLauncher fails to work for you`, sets your computer on fire`, or decides to become sentinent and take over the world`, the developers of Red-DiscordBot are not to blame and will not assist you with this script. This script is not guaranteed to work for anyone other than the author and is provided to anyone on an as-is basis. You`'re free to post issues on the RedLauncher GitLab issue tracker should you come across anything that fails to work or if you have suggestions for the script. Do you agree?
IfMsgBox,Yes
  IniWrite,1,%@ini%,RedLauncher,MyWillIsGood
  Else
  ExitApp,43468

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;: Start asking questions needed for the INI file.            :;
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
#staged-askforlocation:
FileSelectFolder,@location,,0,Please choose the folder where Red-DiscordBot is located.
If ErrorLevel
  ExitApp,301
IfNotExist,%@location%/red.py
{ Loop,2
  { MsgBox,I didn't see red.py in the folder you selected.  Want to try again?
    FileSelectFolder,@location,,0,Please choose the folder where Red-DiscordBot is located.
    If ErrorLevel
      ExitApp,301
    IfExist,%@location%/red.py
      Break
    }
  }
IfNotExist,%@location%/red.py
{ MsgBox,Listen`, I gave you a chance`, and you blew it.  Go download Red-DiscordBot and when you get everything done`, run this again.
  ExitApp,43468
  }
IniWrite,%@location%,%@ini%,RedLauncher,Location
Gosub,#staged-asktocheckforupdates

#staged-asktocheckforupdates:
MsgBox,4132,%@scriptname%,Would you like RedLauncher to automatically keep Red up-to-date? Please note that it requires that you have git installed and git is able to be used from the Windows Command Line.
IfMsgBox,Yes
  IniWrite,1,%@ini%,RedLauncher,checkforupdates
  Else
  IniWrite,0,%@ini%,RedLauncher,checkforupdates
Gosub,#staged-asktostayalwayson

#staged-asktostayalwayson:
MsgBox,4132,%@scriptname%,Would you like RedLauncher to automatically launch Red if it's shutdown?  This will make the [p]shutdown command useless!
IfMsgBox,Yes
  IniWrite,1,%@ini%,RedLauncher,alwayson
  Else
  IniWrite,0,%@ini%,RedLauncher,alwayson
Gosub,#staged-verifyredpyexists

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;: Verify that red.py exists, then start the log file and     :;
;: build the tray icon's options.                             :;
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
#staged-verifyredpyexists:
SetWorkingDir,%@location%
IfNotExist,red.py
{ MsgBox,I couldn't launch red.py since it doesn't seem to exist.  Check the INI file and make sure it's correct.  Otherwise, delete the INI file and reselect the folder by running %@scriptname% again.
  ExitApp,401
  }
Gosub,#staged-startlogfile

#staged-startlogfile:
RunWait,%comspec% /c echo RedLauncher Log >%@log% & date /t >>%@log% & time /t >>%@log% & echo -------------------------------- >>%@log%,,Hide,
Gosub,#staged-buildtray

#staged-buildtray:
Menu,Tray,Icon
Menu,Tray,NoStandard
Menu,Tray,Add,Restart Red,#tray-restartred
Menu,Tray,Add,Update and Restart Red,#tray-updateandrestartred
Menu,Tray,Add,Close Red,#tray-closered

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;: Check for updates to Red-DiscordBot by pulling from the    :;
;: repo. This will prompt UAC for administrative rights.      :;
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
#staged-checkforupdates:
If (@checkforupdates = 1 or @manualcheckforupdate = 1)
{ SetWorkingDir,%@location%
  TrayTip,%@scriptname%,Red is checking for updates.,15,1
  RunWait,%comspec% /c echo Checking Red for updates ... >>%@log% & echo -------------------------------- >>%@log%,,Hide,
  RunWait,*runas %comspec% /c cd %@location% & git pull & pip install --upgrade git+https://github.com/Rapptz/discord.py@async >>%@log% 2>>&1,,Hide,
  If ErrorLevel
  { MsgBox,%@scriptname% failed to update Red.  Please check the log file at %@log% for more information`, then try running %@scriptname% again.
    ExitApp,302
    }
  @manualcheckforupdate = 0
  Gosub,#staged-runredpy
  }
Else
  Gosub,#staged-runredpy

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;: Run Red-DiscordBot and start the RedLauncher life support. :;
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
#staged-runredpy:
RunWait,%comspec% /c echo. >>%@log% & echo -------------------------------- >>%@log% & echo Starting Red ... >>%@log% & echo -------------------------------- >>%@log%,,Hide,
Run,%comspec% /c %@python% -u red.py >>%@log% 2>>&1,%@location%,Hide,@cmdpid
If ErrorLevel
{ MsgBox,%@scriptname% encountered an error with Red.  This could`'ve happened when starting Red or while Red was running.  Please check the log file at %@log% for more information`, then try running %@scriptname% again.'
  ExitApp,402
  }
TrayTip,%@scriptname%,Red is now active!,15,1
Gosub,#staged-redlifesupport

#staged-redlifesupport:
Process,WaitClose,%@cmdpid%,
@redmonitor = %ErrorLevel%
If @redmonitor = 0 ; Funnily enough, 0 in this case means it did close.  Otherwise, ErrorLevel would be the PID of the CMD process spawned.
  Gosub,#staged-inioptions

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;: See what we need to do now that Red was verified closed.   :;
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
#staged-inioptions:
If @alwayson = 1
  Gosub,#staged-runredpy
Else
  Process,Close,%@python%
  TrayTip,%@scriptname%,Red has been shut down.,15,2
  Sleep,5000
  ExitApp,0

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;: Tray options for the RedLauncher tray menu.                :;
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
#tray-restartred:
Process,Close,%@cmdpid%
Process,Close,%@python%
Gosub,#staged-runredpy

#tray-updateandrestartred:
Process,Close,%@cmdpid%
Process,Close,%@python%
@manualcheckforupdate = 1
Gosub,#staged-checkforupdates

#tray-closered:
Process,Close,%@cmdpid%
Process,Close,%@python%
TrayTip,%@scriptname%,Red was shut down from the tray icon. Red may still show as online in Discord for a little bit!,15,2
Sleep,5000
ExitApp
