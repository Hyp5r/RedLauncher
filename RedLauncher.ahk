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
;: Exit Codes                                                 :;
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;: 0     Program closed out without any issues.               :;
;: 300   Program closed out during #staged-askforlocation,    :;
;:       log file required to investigate. Should be a rare   :;
;:       occurrance.                                          :;
;: 400   Program closed out during #staged-verifyredpyexists. :;
;:       This would occur if someone edited the INI file's    :;
;:       location parameter and it did not hold the red.py    :;
;:       file.                                                :;
;: 500   Program closed during #staged-checkforupdates. This  :;
;:       can be due to not having Internet access or          :;
;:       administrative rights to run the command process to  :;
;:       update Red-DiscordBot.                               :;
;: 600   Program closed during #staged-runredpy. Log file     :;
;:       required to investigate. This would be related to    :;
;:       running a cog in Red that, for whatever reason,      :;
;:       could not launch correctly.                          :;
;: 43468 Program closed during #staged-checkforini or         :;
;:       #staged-disclaimer. This means that the user did not :;
;:       agree to the disclaimer. 43468 is T9 for "idiot."    :;
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
FormatTime,Time,,hh:mm:ss tt
EnvGet,Temp,Temp
EnvGet,Tmp,Tmp
EnvGet,WinDir,WinDir
@install = %A_Temp%\af066a14-3a70-475c-b0d0-8309a2bfa118
@python = py.exe
@red = red.py
@scriptname = RedLauncher
@version = 1.0.0
@ini = %@scriptname%.ini
@redlauncherlog = %A_ScriptDir%\%@scriptname%.log
@redpylog = %A_ScriptDir%\%@red%.log
@logstartlogfile = `;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;`n`;: %@scriptname% Log --- %Date% at %Time%              :;`n`;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;`n
@logcheckforupdates = `n`;: Checking Red-DiscordBot for updates.`n`;: %comspec% /c cd %@location% & git pull & pip install --upgrade git+https://github.com/Rapptz/discord.py@async`n`n
@logrunredpy = `;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;`n`;: %@scriptname% Log --- %Date% at %Time%              :;`n`;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;`n`n`;: Starting %@red%.`n`;: %comspec% /c %@python% -u %@red%`n`n
@logclosedbyexternal = `n`;: %@python% was closed via Discord or other external means.
@logclosedbytray = `n`;: %@python% was closed via Tray Icon.

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
  { MsgBox,You just had to set mywillisgood to equal 0.  This means that you no longer agree to the disclaimer, so I no longer agree to work.  Set that value back to 1 and try again.
    ExitApp,43468
    }
  If (@location = "" or @location = "ERROR")
    Gosub,#staged-askforlocation
  Gosub,#staged-verifyredpyexists
  }

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;: Read the user the disclaimer to using this program.        :;
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
#staged-disclaimer:
MsgBox,4388,%@scriptname%,Alright`, here's the disclaimer. RedLauncher is completely unaffiliated with Red-DiscordBot and the developers. What this means is that if RedLauncher fails to work for you`, sets your computer on fire`, or decides to become sentinent and take over the world`, the developers of Red-DiscordBot are not to blame and will not assist you with this script.`n`nThis script is not guaranteed to work for anyone other than the author and is provided to anyone on an as-is basis. You`'re free to post issues on the RedLauncher GitLab issue tracker should you come across anything that fails to work or if you have suggestions for the script. Do you agree?,60
IfMsgBox,Yes
{ IniWrite,1,%@ini%,RedLauncher,mywillisgood
  Gosub,#staged-askforlocation
  }
Else
  ExitApp,43468

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
;: Start asking questions needed for the INI file.            :;
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
#staged-askforlocation:
FileSelectFolder,@location,,0,Please choose the folder where Red-DiscordBot is located.
If ErrorLevel
  ExitApp,300
IfNotExist,%@location%/%@red%
{ Loop,2
  { MsgBox,I didn't see %@red% in the folder you selected.  Want to try again?
    FileSelectFolder,@location,,0,Please choose the folder where Red-DiscordBot is located.
    If ErrorLevel
      ExitApp,300
    IfExist,%@location%/%@red%
      Break
    }
  }
IfNotExist,%@location%/%@red%
{ MsgBox,Listen`, I gave you a chance`, and you blew it.  Go download Red-DiscordBot and when you get everything done`, run this again.
  ExitApp,43468
  }
IniWrite,%@location%,%@ini%,RedLauncher,location
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
;: Verify that %@red% exists, then start the log file and     :;
;: build the tray icon's options.                             :;
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
#staged-verifyredpyexists:
SetWorkingDir,%@location%
IfNotExist,%@red%
{ MsgBox,I couldn't launch %@red% since it doesn't seem to exist.  Check the INI file and make sure it's correct.  Otherwise, delete the INI file and reselect the folder by running %@scriptname% again.
  ExitApp,400
  }
Gosub,#staged-startlogfile

#staged-startlogfile:
IfExist,%@redlauncherlog%
  FileDelete,%@redlauncherlog%
IfExist,%@redpylog%
  FileDelete,%@redpylog%
FileAppend,%@logstartlogfile%,%@redlauncherlog%
Gosub,#staged-buildtray

#staged-buildtray:
Menu,Tray,Icon
If A_IsCompiled = 1
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
  FileAppend,%@logcheckforupdates%,%@redlauncherlog%
  RunWait,*runas %comspec% /c cd %@location% & git pull >>%@redlauncherlog% 2>&1 & echo. >>%@redlauncherlog% 2>&1 & echo. >>%@redlauncherlog% 2>&1 & pip install --upgrade git+https://github.com/Rapptz/discord.py@async >>%@redlauncherlog% 2>&1,%@location%,Hide,
  If ErrorLevel
  { MsgBox,%@scriptname% failed to update Red.  Please check the log file at %@redlauncherlog% for more information`, then try running %@scriptname% again.
    ExitApp,500
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
FileAppend,%@logrunredpy%,%@redpylog%
Run,%comspec% /c %@python% -u %@red% >>%@redpylog% 2>>&1,%@location%,Hide,@cmdpid
If ErrorLevel
{ MsgBox,%@scriptname% encountered an error with Red.  This could`'ve happened when starting Red or while Red was running.  Please check the log files at %@redlauncherlog% and %@redpylog% for more information`, then try running %@scriptname% again.'
  ExitApp,600
  }
TrayTip,%@scriptname%,Red is now active!,15,1
Gosub,#staged-redlifesupport

#staged-redlifesupport:
FileAppend,`n`;: Monitoring %@python% with a background cmd.exe process.`n`;: PID: %@cmdpid%`n,%@redlauncherlog% ; Cannot place this log in a variable due to not having @cmdpid defined until #staged-runredpy.
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
  FileAppend,%@logclosedbyexternal%,%@redlauncherlog%
  TrayTip,%@scriptname%,Red was shut down by Discord or other external means.,15,2
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
FileAppend,%@logclosedbytray%,%@redlauncherlog%
TrayTip,%@scriptname%,Red was shut down from the tray icon. Red may still show as online in Discord for a little bit!,15,2
Sleep,5000
ExitApp,0
