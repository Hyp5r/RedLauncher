# RedLauncher
## A Windows application that launches the Red-DiscordBot to the system tray, complete with relaunching capabilities!

**RedLauncher** was created to help out in launching the fantastic [Red-DiscordBot](https://github.com/twentysix26/red-discordbot) created by *Twentysix26*. While people familiar to Python and Git may not need a launcher like this, there are a few benefits to using it, such as:

* Ease of launch with no extra windows open.
* Quick access to restarting Red-DiscordBot and updating Red-DiscordBot.
* Management of log files to find issues quickly.
* Ability to keep Red-DiscordBot persistent, preventing it from shutting down.

### Use of this application.
To use this application, you must already have installed Red-DiscordBot using the steps provided [at the Red-Docs wiki](https://twentysix26.github.io/Red-Docs/). Failure to follow those instructions may prevent this application from working correctly. Specifically, RedLauncher relies on you having Python and Git usable in the Windows Command Prompt. You can find more information on that [by clicking here](https://twentysix26.github.io/Red-Docs/red_win_requirements/).

### Contributing
Anyone can contribute to making RedLauncher a better piece of software. RedLauncher is fully written in AutoHotkey_L and is extremely easy to learn! Should you have any alterations you'd like to make, please submit an issue on the issue tracker or submit a pull request.

### support
If you're having issues with RedLauncher, please submit an issue on the issue tracker. Before you submit an issue, please try some troubleshooting yourself, such as:

* Launch Red-DiscordBot by the intended manner (running startRed.bat or startRedLoop.bat).
* Look at the official [troubleshooting guide for Red-DiscordBot](https://twentysix26.github.io/Red-Docs/red_guide_troubleshooting/) to see if your problem is listed there.

Two log files are generated when using **RedLauncher**.  These log files are named *RedLauncher.log* and *red.py.log*.  *RedLauncher.log* contains the updater information plus other information specific to **RedLauncher**, while *red.py.log* contains the Python output of *red.py*, including the URL needed to add your bot to your Discord server.  Please look at both logs while troubleshooting potential issues.

**Please note that I do not provide support for any issues that are specific to Red-DiscordBot. If you need assistance with setting up the bot or bot issues, please join their Discord channel by [clicking here](https://discord.gg/0k4npTwMvTpv9wrh).**

### Licensing
RedLauncher is licensed under the Creative Commons Attribution-ShareAlike 4.0 International license. Please [view the license](https://gitlab.com/Hyperdaemon/RedLauncher/blob/master/LICENSE) for more information.
