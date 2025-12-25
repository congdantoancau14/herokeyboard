#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 2
SetNumLockState, off

-------------------------------------------------------------------------------
;~ ICON
-------------------------------------------------------------------------------
ico_main := "main.ico"
ico_pause := "pause.ico"
ico_suspend := "suspend.ico"
IfExist, %ico_main%
	Menu, Tray, Icon, %ico_main%
else
	Menu, Tray, Icon, shell32.dll, 160


; Call WM_COMMAND() whenever the WM_COMMAND (0x111) message is received.
;~ OnMessage(0x111, "WM_COMMAND")

;...
;~ WM_COMMAND(wParam, lParam)
;~ {
    ;~ static IsPaused, IsSuspended
    ;~ Critical
    ;~ SetFormat, Integer, D ; to be sure (since if..in compares alphabetically)
    ;~ id := wParam & 0xFFFF
    ;~ if id in 65305,65404,65306,65403
    ;~ {  ; "Suspend Hotkeys" or "Pause Script"
        ;~ if id in 65306,65403  ; pause
            ;~ IsPaused := ! IsPaused
        ;~ else  ; at this point, A_IsSuspended has not yet been toggled.
            ;~ IsSuspended := ! A_IsSuspended

        ;~ ; INSERT CODE HERE to set icon based on IsPaused and/or IsSuspended
		;~ If (IsPaused) {
			;~ if FileExist(ico_pause)
				;~ Menu, Tray, Icon, %ico_pause%
			;~ else
				;~ Menu, Tray, Icon, shell32.dll, 238 ; Pause icon
		;~ }
		;~ else if (IsSuspended) {
			;~ if FileExist(ico_suspend)
				;~ Menu, Tray, Icon, %ico_suspend%
			;~ else
				;~ Menu, Tray, Icon, shell32.dll, 110 ; Suspend icon
		;~ }
		;~ else if (FileExist(ico_main)) {
			;~ Menu, Tray, Icon, %ico_main%
		;~ } else {
			;~ Menu, Tray, Icon, shell32.dll, 160 ; Running icon
		;~ }
    ;~ }
;~ }

;~ Menu, Tray, NoStandard
; Allow clicking the tray icon
Menu, Tray, Click, 1
OnMessage(0x404, "AHK_NOTIFYICON")  ; Tray icon click handler

;~ UpdateTrayIcon()

; Handle left-click on tray icon
AHK_NOTIFYICON(wParam, lParam) {
    if (lParam = 0x202) { ; Left click
        Suspend, Toggle
        SetTimer, DelayedUpdateIcon, -50  ; Wait ~50ms, then update
    }
}

DelayedUpdateIcon:
UpdateTrayIcon()


; Update tray icon based on current state
UpdateTrayIcon() {
    global ico_main, ico_suspend, ico_pause
    if (A_IsPaused) {
        if FileExist(ico_pause)
            Menu, Tray, Icon, %ico_pause%
        else
            Menu, Tray, Icon, shell32.dll, 238  ; Pause icon
    } else if (A_IsSuspended) {
        if FileExist(ico_suspend)
            Menu, Tray, Icon, %ico_suspend%
        else
            Menu, Tray, Icon, shell32.dll, 110  ; Suspend icon
    } else {
        if FileExist(ico_main)
            Menu, Tray, Icon, %ico_main%
        else
            Menu, Tray, Icon, shell32.dll, 160  ; Running icon
    }
}

SwitchTrayIcon() {
	if (A_IsSuspended) {
		if FileExist(ico_main)
            Menu, Tray, Icon, %ico_main%
        else
            Menu, Tray, Icon, shell32.dll, 160  ; Running icon
    } else {
		if FileExist(ico_suspend)
            Menu, Tray, Icon, %ico_suspend%
        else
            Menu, Tray, Icon, shell32.dll, 110  ; Suspend icon
		MsgBox % A_IsSuspended
    }
}

-------------------------------------------------------------------------------
;~ VARIABLES INITIALIZING
-------------------------------------------------------------------------------
fixed_clipboard 	:= ""
confirm_winclose	:= false
trim_string_clip	:= true
forge_ime_english	:= true

explorer 	:= "ahk_class CabinetWClass"
desktop 	:= "ahk_class WorkerW"
taskbar		:= "ahk_class Shell_TrayWnd"
notepadp	:= "ahk_class Notepad++"
ahkeditor	:= "ahk_class SciTEWindow"
windialog	:= "ahk_class #32770"
ahkgui		:= "ahk_class AutoHotkeyGUI"

;~ Ctrl + Backspace
GroupAdd, CTRLBS, %windialog%
GroupAdd, CTRLBS, %ahkeditor%
GroupAdd, CTRLBS, %ahkgui%
GroupAdd, CTRLBS, ahk_class #32770
GroupAdd, CTRLBS, ahk_class SciTEWindow

;~ Ctrl + Q to Comment
GroupAdd, CTRLQCMT, %notepadp%
GroupAdd, CTRLQCMT, %ahkeditor%
; Double press '/' to send '^/' (Ctrl+/)
GroupAdd, DEVENV, ahk_class Qt5QWindowIcon		; HBuider

;~ Ctrl + PageUp/Dn to switch tabs
GroupAdd, CTRLPAGE, %notepadp%
GroupAdd, CTRLPAGE, %ahkeditor%


GroupAdd, DESKTOPS, %desktop%
;~ GroupAdd, DESKTOPS, %taskbar%
GroupAdd, DESKTOPS, ahk_class Progman
GroupAdd, DESKTOPS, ahk_class Windows.UI.Core.CoreWindow


GroupAdd, EXPLORER, ahk_class CabinetWClass
GroupAdd, EXPLORER, ahk_class ExploreWClass

;~ Create files
GroupAdd, FILES, ahk_class CabinetWClass
GroupAdd, FILES, ahk_class ExploreWClass
GroupAdd, FILES, ahk_class Progman
GroupAdd, FILES, ahk_class WorkerW

;~ Auto switch language Keyboard layout to English
GroupAdd, ENGLISH, cmd.exe ahk_class CASCADIA_HOSTING_WINDOW_CLASS	; Windows cmd.exe
GroupAdd, ENGLISH, FinalShell ahk_class SunAwtFrame		; FinalShell
GroupAdd, ENGLISH, ahk_class TMobaXtermForm 			; MobaXterm
GroupAdd, ENGLISH, /xterm ahk_class Chrome_WidgetWin_1	; 宝塔终端
GroupAdd, ENGLISH, /files ahk_class Chrome_WidgetWin_1	; 宝塔文件
GroupAdd, ENGLISH, /login ahk_class Chrome_WidgetWin_1	; 宝塔登陆
GroupAdd, ENGLISH, Visual Studio Code ahk_class Chrome_WidgetWin_1
GroupAdd, ENGLISH, New Tab ahk_class Chrome_WidgetWin_1	; New tab no Chinese
GroupAdd, ENGLISH, ahk_class SciTEWindow
GroupAdd, ENGLISH, ahk_class #32770 ; run dialog
GroupAdd, ENGLISH, ahk_class HwndWrapper[DefaultDomain;;fcf0d64f-f616-45aa-9cf6-fbc32d12a67d] ; Visual Studio new project dialog
GroupAdd, ENGLISH, ahk_class HwndWrapper[DefaultDomain;;51dfce30-8a6a-4e37-bcbe-87878c571e0c] ; Visual Studio ide
GroupAdd, ENGLISH, ahk_class _Class ; Vo lam 2 client

;~ Ctrl + C/V to Ctrl Insert, Shift Insert
GroupAdd, TERMINAL, cmd.exe ahk_class CASCA					; Commander
GroupAdd, TERMINAL, FinalShell ahk_class SunAwtFrame		; FinalShell
GroupAdd, TERMINAL, Terminal ahk_class Chrome_WidgetWin_1	; Terminus
GroupAdd, TERMINAL, /xterm ahk_class Chrome_WidgetWin_1		; 宝塔终端
GroupAdd, TERMINAL, Xshell ahk_class Xshell7::MainFrame_0	; Xshell7
GroupAdd, TERMINAL, Xshell
GroupAdd, TERMINAL, ahk_class VanDyke Software - SecureCRT 	; SecureCRT
GroupAdd, TERMINAL, ahk_class TMobaXtermForm 				; MobaXterm
GroupAdd, TERMINAL, ahk_class mintty 						; Git bash
GroupAdd, TERMINAL, root@ ahk_class Chrome_WidgetWin_1 		; Tabby
GroupAdd, TERMINAL, cmd.exe ahk_class CASCADIA_HOSTING_WINDOW_CLASS	; Windows cmd.exe
GroupAdd, TERMINAL, PowerShell ahk_class CASCADIA_HOSTING_WINDOW_CLASS	; Windows Powershell
GroupAdd, TERMINAL, cmd ahk_class VirtualConsoleClass 		; Conemu

GroupAdd, COMMANDER, cmd.exe ahk_class CASCA						; Commander
GroupAdd, COMMANDER, cmd.exe ahk_class CASCADIA_HOSTING_WINDOW_CLASS ; Commander (Win11)
GroupAdd, COMMANDER, cmd.exe ahk_class VirtualConsoleClass			; Conemu


-------------------------------------------------------------------------------
;~ SetScrollLockState, On
-------------------------------------------------------------------------------
;~ ONLOAD
-------------------------------------------------------------------------------
Loop
{
	;~ LangID := GetKeyboardLanguage(WinActive("A"))
	;~ ToolTip, % LangID
	if WinActive("ahk_group ENGLISH") or WinActive("ahk_group TERMINAL")
	{
		LangID := GetKeyboardLanguage(WinActive("A"))
		if (LangID != 1033) {
			SetInputLang(0x0409) ; English (USA)
			;~ MsgBox Language set to English
			CoordMode, ToolTip, Screen
			WinGetClass, sClass, a
			ToolTip("Language set to English for the class [" sClass "]", A_ScreenWidth/2, A_ScreenHeight/2, 2, 2000)
		}
	}
	Sleep 1000
}
-------------------------------------------------------------------------------
;~ INCLUDES
-------------------------------------------------------------------------------
#Include hotstrings.ahk
;~ #Include hotstrings_vime.ahk
-------------------------------------------------------------------------------
;~ CORE HOTKEY
-------------------------------------------------------------------------------
^!r:: reload
^!s:: suspend
^!p:: pause
^!e:: edit

; #IfWinActive, ahk_class Notepad
; #IfWinActive, ahk_class Notepad++
#IfWinActive, main.ahk
	F5:: reload
#IfWinActive, ahk_class SciTEWindow
	F5:: reload
#IfWinActive

; Toggle Scroll Lock with Left Alt + Right Alt
^Esc::
;~ ^AppsKey::
    SetScrollLockState, % (GetKeyState("ScrollLock", "T") ? "Off" : "On")
return

#IfWinActive ahk_group DEVENV
	/::
		key := "/"
		if isDoublepressKey(key)
			SendInput {Backspace}^/
		else
			SendInput /
	return

	;~ $/:: ; Double press '/' to send '^/' (Ctrl+/)
    ;~ If (A_PriorHotkey = A_ThisHotkey and A_TimeSincePriorHotkey < 300)
        ;~ Send {Backspace}^/
    ;~ else
        ;~ Send /
return
#IfWinActive

-------------------------------------------------------------------------------
;~ DESKTOP AREA
-------------------------------------------------------------------------------

; ===== Screen Rotation Script =====
; Ctrl+Alt+Up    = Normal (0°)
; Ctrl+Alt+Right = 90° (Portrait)
; Ctrl+Alt+Down  = 180° (Upside Down)
; Ctrl+Alt+Left  = 270° (Portrait flipped)

; ===== Screen Rotation Script (AHK v1) =====
; Ctrl+Alt+Arrow keys rotate screen

RotateScreen(orientation) {
    VarSetCapacity(DEVMODE,156,0)
    NumPut(156, DEVMODE,36,"UShort")      ; dmSize
    DllCall("EnumDisplaySettingsA","Ptr",0,"UInt",-1,"Ptr",&DEVMODE)
    NumPut(orientation, DEVMODE,84,"UInt") ; dmDisplayOrientation
    NumPut(0x80, DEVMODE,40,"UInt")        ; DM_DISPLAYORIENTATION
    DllCall("ChangeDisplaySettingsExA","Ptr",0,"Ptr",&DEVMODE,"Ptr",0,"UInt",0,"Ptr",0)
}

^!Up::    RotateScreen(0) ; Normal (0°)
^!Right:: RotateScreen(1) ; 90° Right
^!Down::  RotateScreen(2) ; 180°
^!Left::  RotateScreen(3) ; 270°



~LWin::
    if (A_PriorHotkey = "~LWin" and A_TimeSincePriorHotkey < 300)
    {
        ; Double press detected within 300 ms
        Send, #{Tab}  ; Ctrl + Win + Tab shows Task View and keeps it open
    }
    return


; Switch desktops
~RButton & WheelUp::Send ^#{Left}   ; Switch left when right button + wheel up
~RButton & WheelDown::Send ^#{Right} ; Switch right when right button + wheel down



; Mouse button drag to switch desktop
;~ ~LButton::
;~ MouseGetPos, x0, y0
;~ KeyWait, LButton
;~ MouseGetPos, x1, y1
;~ if (x1 < x0 - 100)
    ;~ Send ^#{Left}
;~ else if (x1 > x0 + 100)
    ;~ Send ^#{Right}
;~ return

;~ ~RButton::
	;~ CoordMode, Mouse, Screen  ; Ensure screen-based coords
	;~ MouseGetPos, x0, y0
	;~ KeyWait, RButton
	;~ MouseGetPos, x1, y1
	;~ if (x1 < x0 - 100)
		;~ Send ^#{Right}
	;~ else if (x1 > x0 + 100)
		;~ Send ^#{Left}
;~ return

dragSwitchDesktop()
{
	MouseGetPos, x0, y0
	KeyWait, LButton
	MouseGetPos, x1, y1
	if (x1 < x0 - 100)
		Send ^#{Left}
	else if (x1 > x0 + 100)
		Send ^#{Right}
}


#!r::
	run taskkill /f /im explorer.exe
	Sleep 1000
	run explorer.exe
return

#F7:: SendInput ^#{left}
#F8:: SendInput ^#{right}
;#pgup:: SendInput ^#{left}
;#pgdn:: SendInput ^#{right}
#IfWinActive ahk_group DESKTOPS
f1:: MsgBox % desktop
	;~ https://www.autohotkey.com/boards/viewtopic.php?t=75890
	F6:: DesktopIcons()
	F7:: SendInput ^#{left}
	F8:: SendInput ^#{right}
	#left:: SendInput ^#{left}
	#right:: SendInput ^#{right}
	F11:: HideShowTaskbar()

	F9:: run explorer.exe shell:desktop\Apps
	F10:: run explorer.exe shell:desktop\Drawer

#IfWinActive

;~ https://www.autohotkey.com/boards/viewtopic.php?t=60866
HideShowTaskbar() {
   static SW_HIDE := 0, SW_SHOWNA := 8, SPI_SETWORKAREA := 0x2F
   DetectHiddenWindows, On
   hTB := WinExist("ahk_class Shell_TrayWnd")
   WinGetPos,,,, H
   hBT := WinExist("ahk_class Button ahk_exe Explorer.EXE")  ; for Windows 7
   b := DllCall("IsWindowVisible", "Ptr", hTB)
   for k, v in [hTB, hBT]
      ( v && DllCall("ShowWindow", "Ptr", v, "Int", b ? SW_HIDE : SW_SHOWNA) )
   VarSetCapacity(RECT, 16, 0)
   NumPut(A_ScreenWidth, RECT, 8)
   NumPut(A_ScreenHeight - !b*H, RECT, 12, "UInt")
   DllCall("SystemParametersInfo", "UInt", SPI_SETWORKAREA, "UInt", 0, "Ptr", &RECT, "UInt", 0)
   WinGet, List, List
   Loop % List {
      WinGet, res, MinMax, % "ahk_id" . List%A_Index%
      if (res = 1)
         WinMove, % "ahk_id" . List%A_Index%,, 0, 0, A_ScreenWidth, A_ScreenHeight - !b*H
   }
}

DesktopIcons( Show:=-1 )                  ; By SKAN for ahk/ah2 on D35D/D495 @ tiny.cc/desktopicons
{
    Local hProgman := WinExist("ahk_class WorkerW", "FolderView") ? WinExist()
                   :  WinExist("ahk_class Progman", "FolderView")

    Local hShellDefView := DllCall("user32.dll\GetWindow", "ptr",hProgman,      "int",5, "ptr")
    Local hSysListView  := DllCall("user32.dll\GetWindow", "ptr",hShellDefView, "int",5, "ptr")

    If ( DllCall("user32.dll\IsWindowVisible", "ptr",hSysListView) != Show )
         DllCall("user32.dll\SendMessage", "ptr",hShellDefView, "ptr",0x111, "ptr",0x7402, "ptr",0)
}


#If WinActive("Apps ahk_class CabinetWClass") OR WinActive("Browsers ahk_class CabinetWClass")
	Esc:: WinClose, a
	~LButton::
		WinGetTitle, title, a
		Keywait, LButton
		;~ Send {Click 2}
		Sleep 100

		ControlGetFocus, ctrl
		if (ctrl == "DirectUIHWND2") {
			SendInput {enter}
			WinWaitNotActive, ahk_class CabinetWClass,, 1.5
			if ErrorLevel
			{
				;~ MsgBox, WinWait timed out.
				return
			}
			else
			{
				WinClose, %title% ahk_class CabinetWClass
			}
		}

	return
#IfWinActive

-------------------------------------------------------------------------------
;~ EXPLORER AREA
-------------------------------------------------------------------------------

;~ RELOAD EXPLORER
;~ https://www.autohotkey.com/board/topic/93906-restart-explorer-the-official-way/
;~ ^!#E::     ; ctrl+windows+alt+e
	;~ WinGet, h, ID, ahk_class Progman	        ; use ahk_class WorkerW for XP
	;~ PostMessage, 0x12, 0, 0, , ahk_id %h%	;wm_quit
	;~ sleep, 25
	;~ Run, "%windir%\explorer.exe"
;~ return

^!#E::
	;~ WinGet, h, ID, ahk_class WorkerW
	;~ PostMessage, 0x12, 0, 0, , ahk_id %h%	;wm_quit
	;~ sleep, 25
	;~ Run, explorer.EXE


	;~ Process,close,explorer.exe
	;~ sleep, 5000 ;This sleep 5000 is to let you see what actually happens. Decrease it later
	;~ run, explorer.exe


	run, taskkill /f /im explorer.exe
	sleep, 5000
	run, explorer.exe

return

#IfWinActive ahk_group FILES
	~e::	clickMenuItem("Edit with Notepad++")
	~w::	clickMenuItem("通过 Code 打开")


	; Define a hotkey to trigger the shortcut creation
	^+s::
		; Get the currently selected file path
		Clipboard := ""
		SendInput, ^c
		ClipWait, 1

		; Verify if a file path is in the clipboard
		if (Clipboard)
		{
			; Extract the file name from the file path
			SplitPath, Clipboard, FileName

			; Create a shortcut on the desktop using the file name
			FileCreateShortcut, %Clipboard%, %A_Desktop%\%FileName%.lnk
			MsgBox, Shortcut "%FileName%" has been created on the desktop.
		}
		else
		{
			MsgBox, No file selected.
		}
	return

#IfWinActive

;~ https://www.autohotkey.com/boards/viewtopic.php?t=41170
clickMenuItem(vNeedle)
{
	if isEditing()
		return
	;based on:
	;GUIs via DllCall: get/set internal/external control text - AutoHotkey Community
	;https://autohotkey.com/boards/viewtopic.php?f=6&t=40514
	;context menu window messages: focus/invoke item - AutoHotkey Community
	;https://autohotkey.com/boards/viewtopic.php?f=5&t=39209

	;~ q:: ;invoke menu item in context menu that matches string
	;e.g. Notepad right-click menu, 'Paste' menu item
	SendMessage, 0x1E1,,,, ahk_class #32768 ;MN_GETHMENU := 0x1E1
	hMenu := ErrorLevel

	;~ vNeedle := "Paste"
	vNeedle := StrReplace(vNeedle, "&")
	Loop, % DllCall("user32\GetMenuItemCount", Ptr,hMenu)
	{
		vIndex := A_Index-1
		vID := DllCall("user32\GetMenuItemID", Ptr,hMenu, Int,vIndex, UInt)
		if (vID = 0) || (vID = 0xFFFFFFFF) ;-1
			continue
		vChars := DllCall("user32\GetMenuString", Ptr,hMenu, UInt,vIndex, Ptr,0, Int,0, UInt,0x400) + 1
		VarSetCapacity(vText, vChars << !!A_IsUnicode)
		DllCall("user32\GetMenuString", Ptr,hMenu, UInt,vIndex, Str,vText, Int,vChars, UInt,0x400) ;MF_BYPOSITION := 0x400
		if (StrReplace(vText, "&") = vNeedle)
		{
			PostMessage, 0x1F1, % vIndex, 0,, ahk_class #32768 ;MN_DBLCLK := 0x1F1
			break
		}
	}
}

isEditing()
{
	return A_Cursor == "IBeam" or A_CaretX != "" and A_CaretY != ""
}
-------------------------------------------------------------------------------
;~ WINDOWS NAVIGATION
-------------------------------------------------------------------------------

; Capslock:: Sendinput, !{tab}

;https://superuser.com/questions/950452/how-to-quickly-move-current-window-to-another-task-view-desktop-in-windows-10
#!Left::
  WinGetTitle, Title, A
  WinSet, ExStyle, ^0x80, %Title%
  Send {LWin down}{Ctrl down}{Left}{Ctrl up}{LWin up}
  sleep, 50
  WinSet, ExStyle, ^0x80, %Title%
  WinActivate, %Title%
Return

#!Right::
  WinGetTitle, Title, A
  WinSet, ExStyle, ^0x80, %Title%
  Send {LWin down}{Ctrl down}{Right}{Ctrl up}{LWin up}
  sleep, 50
  WinSet, ExStyle, ^0x80, %Title%
  WinActivate, %Title%
Return

#PgDn::    ; Next window
WinGetClass, ActiveClass, A
WinSet, Bottom,, A
WinActivate, ahk_class %ActiveClass%
return

#PgUp::    ; Last window
WinGetClass, ActiveClass, A
WinActivateBottom, ahk_class %ActiveClass%
return

-------------------------------------------------------------------------------
;~ WINDOWS KEY (WINKEYS)
-------------------------------------------------------------------------------
#j:: run shell:Downloads
#n:: run notepad
#w:: run cmd
#q:: run explorer.exe shell:desktop\apps
^#a:: run explorer.exe shell:desktop\apps
#numlock:: run calc
#insert:: run excel
#AppsKey:: run notepad++ ; notepad++
#delete:: run shell:RecycleBinFolder

#+p:: SendInput {PrintScreen}
#!p:: SendInput {PrintScreen}

#Numpad1::PrintScreen
#Numpad2::ScrollLock
#Numpad3::CtrlBreak
#F12::PrintScreen



----------------------------------------

;~ show desktops
^#d::
	SendInput #{tab}
return

;~ quit app
^#q::
	winclose()
return

;~ get win id
^!#i::
	WinGetTitle, title, A
	WinGet,id,ID, %title%
	MsgBox, The active window's id is "%id%". Copied!
	clipboard := id
return

;~ get win title
^!t::
^#t::
	WinGetTitle, title, A
	MsgBox, The active window's title is "%title%". Copied!
	clipboard := title
return

;~ get win class
^#s::
	WinGetClass, class, A
	MsgBox, The active window's class is "%class%". Copied!
	clipboard := class
return

;~ get control name
^#c::
	ControlGetFocus, OutputVar, a
	if ErrorLevel
    		MsgBox, The target window doesn't exist or none of its controls has input focus.
	else
	{
    		MsgBox, Control with focus: [%OutputVar%]
		clipboard := OutputVar
	}
return

;~ get mouse coordinate (mouse position)
^#p::
	MouseGetPos , OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
	;~ Clipboard = %OutputVarX%, %OutputVarY%
	Clipboard = %OutputVarX% %OutputVarY%
	MsgBox, Copied mousepos: %OutputVarX%, %OutputVarY%
return

;~ get text from window
^#x::
	WinGetText, text , a
	MsgBox, Copied the text get from active window: `n----------------------------------------`n%text%`n----------------------------------------
	clipboard := text
return

; Function to list all opened windows along with their class and title
ListWindows() {
    WinGet, idList, List  ; Get list of all windows' IDs
	str_idlist := ""
    Loop, %idList%
    {
        this_id := idList%A_Index%  ; Get the ID of the current window
        WinGetTitle, this_title, ahk_id %this_id%  ; Get the title of the current window
        WinGetClass, this_class, ahk_id %this_id%  ; Get the class of the current window
        str_idlist .= "Window " A_Index "`nClass: " this_class "`nTitle: " this_title "`n`n"
    }

	; Remove the trailing delimiter
    str_idlist := SubStr(str_idlist, 1, -1)

	showMultiLines(str_idlist)
}

; Hotkey to trigger the function
^#w::ListWindows()  ; Press Ctrl+Shift+W to list all opened windows

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
;~ CONTROL KEYS
-------------------------------------------------------------------------------
RAlt:: SendInput #d

RCtrl:: Click, 3

Insert:: SendInput ^n

!Delete:: SendInput !{F4}

~Delete::
	if isEditing()
	{
		SendInput {end}+{home}{del}
	}
return

;~ ^+c::
^AppsKey::
^!i::SendInput ^{Insert}
+AppsKey::
^+i::SendInput +{Insert}


;~ Chrome not in input field
#if isEditing()
;~ Delete:: SendInput ^{f4}
#if
-------------------------------------------------------------------------------
;~ WINDOW CONTROL
-------------------------------------------------------------------------------

#IfWinActive ahk_group CTRLBS
^BS:: SendInput ^+{left}{BS}
;~ Esc:: MsgBox igopwjoasgfd
#IfWinActive


; Always on top
;~ ^SPACE:: Winset, Alwaysontop, , A
;~ ^SPACE::
;~ WinGetTitle, win_title, A
;~ Winset, Alwaysontop, , A
;~ TrayTip, AHK Main, [%win_title%] is set to always on top, 1
;~ return

^SPACE::
WinGetTitle, win_title, A
WinGet, ExStyle, ExStyle, A

if (ExStyle & 0x8) {
    ; Already always on top → remove it
    WinSet, AlwaysOnTop, Off, A
    TrayTip, AHK Main, [%win_title%] is no longer always on top, 1
} else {
    ; Not always on top → set it
    WinSet, AlwaysOnTop, On, A
    TrayTip, AHK Main, [%win_title%] is now always on top, 1
}
return


;~ ToolTip("Saving . . .", A_ScreenWidth/2, A_ScreenHeight/2, 11, 400)
;~ return

`:: Sendinput, ^w ; ^{f4}

#z:: WinMinimize, a
#x:: winremax()
#c:: winclose()

#printscreen:: WinMinimize, a
#scrolllock:: winremax()
#pause:: winclose()

$PrintScreen::
	if isMouseHoverTaskBar()
		WinMinimize, a
	else
		SendInput, {PrintScreen}
return

ScrollLock::winremax()
#InputLevel 1
^q::
#InputLevel 0
Pause::winclose()
^m:: Winminimize, a
#Enter::winremax2()

winremax()
{
	WinGet, currentWindow, ID, A
	WinGet MaxState, MinMax, ahk_id %currentWindow%
	;~ ToolTip, % MaxState
	if (!MaxState)
		WinMaximize, ahk_id %currentWindow%
	else
		WinRestore, ahk_id %currentWindow%
}

winremax2()
{
	WinGet,WinState,MinMax,a
	If WinState = -1
		WinRestore, a ; msgbox, Window is Minimized
	If WinState = 0
		WinMaximize, a ; msgbox, Window is neither
	If WinState = 1
		WinRestore, a ; msgbox, Window is Maximized
}

winclose()
{
	if (!confirm_winclose) {
		WinClose, a
		return
	}
	WingetTitle, title, a
	MsgBox, 1, , Do you want to exit [%title%]?
	IfMsgBox Ok
		Winclose, %title%
}


--------------------------------------------------------------------------------



#IfWinActive, ahk_class Notepad++
	^t:: SendInput ^n
#IfWinActive

; Replace caiji log in notepad++
#IfWinActive, caiji_log ahk_class Notepad++
	^r::
		SendInput ^h
		Sleep 100
		SendInput !f＜
		SendInput !l<
		SendInput !a
		Sleep 100
		SendInput !f＞
		SendInput !l>
		SendInput !a
		SendInput !f＇
		SendInput !l'
		SendInput !a
	return
#IfWinActive


--------------------------------------------------------------------------------

-------------------------------------------------------------------------------
;~ FUNCTION KEYS
-------------------------------------------------------------------------------

^F11::
    FileRead, hotstring, hotstrings.ahk
    ; MsgBox, %hotstring% ; Uncomment this line to verify if the content is read correctly
    showMultiLines(hotstring)
return

showMultiLines(longstring)
{
	Static MyEdit  ; Declare MyEdit as a static variable
	Gui, new
    Gui, Add, Edit, vMyEdit r50 vScroll hScroll +ReadOnly, % longstring
    Gui, show
    GuiControl,, MyEdit, % longstring  ; Select the text
}


~F2:: select_or_rename()

^F2:: rename_add_time()

F1:: set("^x")
F4:: set("^v")

#IfWinActive ahk_group TERMINAL
F1:: MsgBox Terminal
	F3:: set("^{Insert}")
	F4:: set("+{Insert}")
	^+p::
	^+v:: set("+{Insert}")
#IfWinActive

$F3::  copy_or_search()

copy_or_search()
{
	;~ ToolTip, % (isEditing() || !isTitleArea()),,,10
	if (isEditing() || !isTitleArea())
		set("^c")
	else
		Sendinput {f3}
}

select_or_rename()
{
	;~ clipsaved := Clipboard
	;~ SendInput ^c
	Sleep, 100
	ControlGetFocus, ctrl, a
	;~ if (ctrl != "Edit1" && Clipsaved == Clipboard) {
	if (ctrl != "Edit1" && ctrl != "ATL:00000001405373B01") {
		SendInput, ^a
		;~ Clipboard := clipsaved
	}
}

save_or_tab()
{
	if (A_Cursor == "IBeam")
		save()
	else
		SendInput {f6}
}

reload_or_refresh()
{
	IfWinActive, ahk_class SciTEWindow
		reload
	else
		SendInput {f5}
}

isTitleArea()
{
	;~ CoordMode, mouse, Screen ; Coordinates are relative to the desktop (entire screen).
	MouseGetPos,x,y
	return y <= 38
}

;F1:: SendInput, ^x
;F3:: SendInput, ^c
;F4:: SendInput, ^v
;F6:: SendInput, ^s


-------------------------------------------------------------------------------
;~ CONTROL ALTERNATE
-------------------------------------------------------------------------------

#IfWinActive ahk_group CTRLQCMT
^/:: SendInput, ^q
#IfWinActive

; ADDCLIP - ADDITIONAL CLIPBOARD
^!c::
	Send ^c
	Sleep 100
	global fixed_clipboard
	fixed_clipboard := Clipboard
return
^!v::SendRaw % fixed_clipboard



~^x::
~^c::
	Sleep 100
~^v::
	clipboardChangedNotify()
return

set(keys)
{
	KeyWait, Ctrl
	KeyWait, LAlt
	clip := Clipboard ;~ clipboard before keypress event

	global trim_string_clip
	if (isClipText() && trim_string_clip)
		Clipboard := Trim(Clipboard)

	if (isClipText() && (keys == "^v" or keys == "+{Insert}")) {
		; Check if the clipboard content is an IP:port format

		IfWinActive, ahk_group TERMINAL
		{
			; your code here
			if (IsIPPort(clip)) {
				; Replace ":" with " -p"
				clip := StrReplace(clip, ":", " -p")
			}
		}

		; Set the modified clipboard content
		Clipboard := clip
	}


	SendInput, %keys%


	Sleep 100
	;~ TrayTip, Functions key, %keys%
	clipboardChangedNotify()
	if (keys == "^{Insert}" and (Clipboard == "" or Clipboard == clip))
	{
		SendInput {f3}
	}
}

; Define a function to check if a string is in IP:port format
IsIPPort(str) {
    ; Regular expression to match IP:port format
    if (RegExMatch(Trim(str), "^(\d{1,3}\.){3}\d{1,3}:\d+$", match)) {
        return true  ; Return true if a match is found
    } else {
        return false  ; Return false if no match is found
    }
}


clipboardChangedNotify()
{
	clip := Clipboard
	;~ Sleep 100
	;clip := SubStr(clip,1,InStr(Trim(clip),"`n"))
	;clip := RegExReplace(ClipBoard," *([A-Za-z])\)","`n$1)")
	clip := handleClip(clip)
	;~ Sleep 100
	CoordMode, ToolTip, Screen
	xCoor := A_ScreenWidth/2 - StrLen(clip) * 6

	Tooltip, Clipboard: %clip%, %xCoor%, %A_ScreenHeight%, 20
	;~ Tooltip, Clipboard: %clip%, 400, %A_ScreenHeight%, 1
	hwnd := WinExist("ahk_class tooltips_class32")
    WinSet, Trans, 90, % "ahk_id" hwnd
	;Msgbox, %clipboard%
}

handleClip(clip)
{
	if isClipPic()
		clip := "[picture]"
	else if (clip == "")
		clip := "[empty]"
	else if (Trim(clip) == "")
		clip := "[space]"
	else ;~ clip is text
	{
		;~ cut down overflow text
		if StrLen(clip) > 128
			clip := SubStr(clip,1,128) . "..." . "[Length = " . StrLen(Clipboard) . "]"
		StringReplace, clip, clip,  `r`n,%A_Space%, All
		StringReplace, clip, clip,  `r,%A_Space%, All
		StringReplace, clip, clip,  `n,%A_Space%, All
	}
	return clip
}

isClipPic()
{
	if DllCall("IsClipboardFormatAvailable", "Uint", 2)	;2:CF_BITMAP
		return true ;msgbox it's bitmap
	else
		return false ;msgbox something else
}

isClipFile()
{
	if DllCall("IsClipboardFormatAvailable", "uint", 15)
		return true		; MsgBox Clipboard contains files.
	else
		return false	; MsgBox Clipboard does not contain files or text.
}

isClipText()
{
	if DllCall("IsClipboardFormatAvailable", "uint", 1)
		return true		; MsgBox Clipboard contains text.
	else
		return false
}
^!+c:: MsgBox % checkClip()
checkClip()
{
	if DllCall("IsClipboardFormatAvailable", "uint", 1)
		return 1	; MsgBox Clipboard contains text.
	else if DllCall("IsClipboardFormatAvailable", "uint", 15)
		return 2	; MsgBox Clipboard contains files.
	else
		return 0	; MsgBox Clipboard does not contain files or text.
}

;~ ~F6::
	;~ if (A_PriorHotkey != "~F6" or A_TimeSincePriorHotkey > 400)
	;~ {
		;~ ; Too much time between presses, so this isn't a double-press.
		;~ KeyWait, F6

		;~ return
	;~ }
	;~ MsgBox You double-pressed the  key.
	;~ save()
;~ return

;~ F6 Wait to anykey before to trigger save function https://www.autohotkey.com/docs/v1/lib/Input.htm


;~ F6::
	;~ if (A_PriorHotkey <> "F6" or A_TimeSincePriorHotkey > 1200)
	;~ {
		;~ KeyWait, F6
		;~ MsgBox, %A_PriorHotkey% %A_TimeSincePriorHotkey% yes
		;~ save()
		;~ return
	;~ }
	;~ IniWrite, https://www.google.com, %A_Desktop%\URL\My Shortcut.url, InternetShortcut, URL
	;~ MsgBox, Saved url: %A_Desktop%\My Shortcut.url
;~ return

isDoublepressKey(key)
{
	if (A_PriorHotkey != key or A_TimeSincePriorHotkey > 400)
	{
		; Too much time between presses, so this isn't a double-press.
		KeyWait, %key%
		return false
	}
	;~ MsgBox You double-pressed the  key.
	return true
}

;~ $x::
    ;~ startTime := A_TickCount ;record the time the key was pressed
    ;~ KeyWait, x, U ;wait for the key to be released
    ;~ keypressDuration := A_TickCount-startTime ;calculate the duration the key was pressed down
    ;~ if (keypressDuration > 200) ;if the key was pressed down for more than 200ms send >
    ;~ {
        ;~ Send >
    ;~ }
    ;~ else ;if the key was pressed down for less than 200ms send x
    ;~ {
         ;~ Send x
    ;~ }
;~ return


isLongpressKey(key)
{
	startTime := A_TickCount ;record the time the key was pressed
    KeyWait, %key%, U ;wait for the key to be released
    keypressDuration := A_TickCount-startTime ;calculate the duration the key was pressed down
    if (keypressDuration > 200) ;if the key was pressed down for more than 200ms send >
    {
        return true
    }
    else ;if the key was pressed down for less than 200ms send x
    {
         Send %key%
    }
}

save()
{
	SendInput ^s
	;~ TrayTip, Function Keys, Saved!,,1
	ToolTip("Saving . . .", A_ScreenWidth/2, A_ScreenHeight/2, 11, 400)
}

;~ ToolTip Timeout https://www.autohotkey.com/boards/viewtopic.php?t=65494
; ToolTip([Text, X, Y, WhichToolTip, Timeout])
ToolTip(Text := "", X := "", Y := "", WhichToolTip := 1, Timeout := "") {
	ToolTip, % Text, X, Y, WhichToolTip

	If (Timeout) {
		RemoveToolTip := Func("ToolTip").Bind(,,, WhichToolTip)
		SetTimer, % RemoveToolTip, % -Timeout
	}
}


; https://www.autohotkey.com/boards/viewtopic.php?t=75853
; How to add date and time to file name
rename_add_time()
{
	if !Explorer_GetSelection()
   {
	   msgbox,,,No files were selected,2
	   return
   }
	for each,Fn in strsplit(Explorer_GetSelection(),"`n","`r")
	{
	   SplitPath, Fn,,oDir, oExt, oNNE
	   FormatTime, oNow, , yyMMdd
	   nFn := oDir "\" oNNE "_" oNow "." oExt
	   filemove,%Fn%,%nFn%
	}
}

F7:: SendInput, ^+{tab}
F8:: SendInput, ^{tab}
#IfWinActive, ahk_group CTRLPAGE
F7:: SendInput, ^{PgUp}
F8:: SendInput, ^{PgDn}
#IfWinActive

move_tab_left()
{
	IfWinActive, ahk_group CTRLPAGE
		SendInput, ^{PgUp}
	else
		SendInput, ^+{tab}
}

move_tab_right()
{
	IfWinActive, ahk_group CTRLPAGE
		SendInput, ^{PgDn}
	else
		SendInput, ^{tab}
}

-------------------------------------------------------------------------------
;~ HOTSTRING AREA
-------------------------------------------------------------------------------

:*:vime::
	SetInputLang(0x0409) ; English (USA)
	KeyWait, e, U
	SendInput {ctrl}{shift}
return

-------------------------------------------------------------------------------
;~ CHROME AREA
-------------------------------------------------------------------------------


^F6:: showNavigator()

showNavigator()
{
	;~ show input slug
	InputBox, UserInput, Input url slug, Please enter a sub-category:, , 340, 120
	;~ if ErrorLevel
		;~ MsgBox, CANCEL was pressed.
	;~ else
		;~ MsgBox, You entered "%UserInput%"
	if ErrorLevel
		return

	;~ get url
	clipsaved := ClipboardAll
	Clipboard :=
	send ^+u
	ClipWait, 2
	if ErrorLevel
	{
		MsgBox, The attempt to copy url onto the clipboard failed.
		return
	}
	domain := Clipboard


	url = %domain%/%UserInput%
	Run, chrome.exe %url%
	Clipboard := clipsaved
}

;~ #if !WinActive(explorer) && !WinActive(desktop) && !WinActive(taskbar)
F6:: save()
;~ #if

#if WinActive("files") || (A_Cursor == "IBeam")
;~ #if WinActive("宝塔")
	F6:: save()
#if

#IfWinActive, VNC控制台 - Google Chrome
	`::
		SendInput ^w
	~LButton::
		Sleep 200
		IfWinActive, 离开此网站？
			SendInput {enter}
	return

#IfWinActive, Chrome ahk_class Chrome_WidgetWin_1

	;~ Auto login
	^+l::
	^F2::
		KeyWait, Control
		KeyWait, F2
		autologin()
	return

	;~ ~d::	clickMenuItem("复制") ; duplicate current tab

	;^tab:: SendInput, ^q ;^y ;Ctrl+Tab MRU

	$F2::
		;~ CoordMode
		if (A_Cursor == "IBeam")
			SendInput ^a
		else
			SendInput {f2}
	return

	$F3::

		clip := Clipboard
		SendInput, ^{Insert}
		Sleep 100
		;~ TrayTip, Functions key, %keys%
		clipboardChangedNotify()
		if (Clipboard == "" or Clipboard == clip)
		{
			MouseGetPos , OutputVarX, OutputVarY
			if (A_Cursor == "IBeam" && OutputVarY < 90) {
				SendInput ^+u ; Copy domain (copy url extension)
			} else {
				if WinActive("宝塔")
					SendInput ^f
				else
					SendInput {f3}
			}
		}

	return

	;~ $F5::
		;~ if WinActive("宝塔") or WinActive("后台") {
			;~ SendLevel 1
			;~ SendInput ^+r
		;~ } else
			;~ SendInput {f5}
	;~ return


	;~ ~F6::
		;~ Input, SingleKey, L1 T1.2, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
		;~ if (ErrorLevel = "Timeout")
		;~ {
			MsgBox, You entered "%UserInput%" at which time the input timed out.
			;~ save()
			;~ return
		;~ }
	;~ return

	$F6:: save_or_tab()

;~ Alt+F6 Save URL to URL folder
	!F6::
		Clipboard := ""
		save_dir := A_Desktop . "\URL\"
		SendInput ^+u
		Sleep 100
		url := Clipboard
		WingetTitle, title, a
		http := SubStr(url, 1 , 4)

		if (http == "http" and title != "")
		{
			IniWrite, %url%, %save_dir%%title%.url, InternetShortcut, URL
			TrayTip, Save Url, Saving Successfully!`n%title%`n%url%,,1
		}
		else
		{
			TrayTip, Save Url, Saving Failed!`n%title%`n%url%,,3
		}
	return

	F9:: Sendinput, ^+c
	F10:: Sendinput, ^+m
	+F11::
		KeyWait, Shift
		SendInput, {F11}
	return
	^!::
		KeyWait, Ctrl
		SendInput, {F11}
	return

	~!d::
		KeyWait, d
		SendInput, !{enter}
	return

	NumpadMult:: SendInput, ^+d ; Duplicate tab (Width extension)
	NumpadDiv:: SendInput, ^+i ; Incognito mod (Width extension)

	^+s:: ; Search selected
		KeyWait, ctrl
		SendInput ^c
		Sleep 100
		key := Clipboard
		url := "https://www.google.com/search?q=" + key
		run, %url%
	return

#IfWinActive

chrome_switch_inspect()
{
	IfWinActive, Chrome ahk_class Chrome_WidgetWin_1
		SendInput ^+c
}

chrome_switch_mobile()
{
	IfWinActive, Chrome ahk_class Chrome_WidgetWin_1
		SendInput ^+m
}

browser_or_devtool()
{
	ifWinNotActive, ahk_class Chrome_WidgetWin_1
		run chrome
	else
		SendInput {f12}
}


#IfWinNotActive, ahk_class Chrome_WidgetWin_1
	F12:: run chrome
#IfWinNotActive

autologin()
{
	clip := Clipboard
	clip := Trim(clip)
	if (clip == ""){
		MsgBox, Clipboard is empty!
		return
	}

	clip := StrReplace(clip,"：",":") ;~ Chinese quanjiao
	clip := StrReplace(clip,";",":") ;~ ahao
	clip := StrReplace(clip,"；",":") ;~ ahao

	if Instr(clip, "`r`n"){
		array := StrSplit(clip, "`r`n")
		arrayLength := array.Length()
		if (arrayLength > 2) {
			;~ array[1] := array[arrayLength - 1]  ; Second last element
			;~ array[2] := array[arrayLength]      ; Last element
			Loop, %arrayLength%
			{
				if Instr(array[A_Index],"http")
				{
					; Check if the next element does not contain "http" and there are at least two more elements
					if (A_Index < arrayLength - 1 && !Instr(array[A_Index + 1],"http"))
					{
						; Ensure there are at least two elements after the found element
						if (A_Index < arrayLength - 1)
						{
							array[1] := array[A_Index + 1]  ; Assign the next element to array[1]
						}
						if (A_Index < arrayLength - 2)
						{
							array[2] := array[A_Index + 2]  ; Assign the element after the next to array[2]
						}
						break  ; Exit the loop after finding the first match
					}
				}
			}
		}
		if Instr(array[1], ":") {
			array1 := StrSplit(array[1], ":")
			username := Trim(array1[2])
			array2 := StrSplit(array[2], ":")
			password := Trim(array2[2])
		}
		else if Instr(array[1], " ") {
			array[1] := RegExReplace(array[1], " +", " ")
			array1 := StrSplit(array[1], " ")
			username := Trim(array1[2])
			array[2] := RegExReplace(array[2], " +", " ")
			array2 := StrSplit(array[2], " ")
			password := Trim(array2[2])
		}
		else {
			username := array[1]
			password := array[2]
		}
	} else if Instr(clip, " ") {
		clip := RegExReplace(clip, " +", " ")
		array := StrSplit(clip, " ")
		username := array[1]
		password := array[2]
	} else {
		MsgBox, Error. Can not get username and password.`r`nUsername%username%Password%password%
		return
	}


	TrayTip, Auto Login, Username: %username%`r`nPassword: %password%

	if (username != "root") {
		SendRaw, %username%
		SendInput, {Tab}
	}
	SendRaw, %password%
	SendInput, {Tab}

}

#IfWinActive, Stylus - Google Chrome
	+1::
		KeyWait, Shift, L
		SendRaw, !important
	return
#IfWinActive
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
;~ TESTING
-------------------------------------------------------------------------------
^+!#g::
Loop, 200
{
    ToolTip, Testing! %A_Index%, 500, 500, 7
    hwnd := WinExist("ahk_class tooltips_class32")
    WinSet, Trans, 90, % "ahk_id" hwnd
    Sleep 160
}
ToolTip,,,,7
return

;~ --------------------------------------------------------------------------------
;~ 									NUMPAD
;~ --------------------------------------------------------------------------------

#If GetKeyState("ScrollLock", "T")
;~ NumpadLeft:: SendInput, !{left}
;~ NumpadRight:: SendInput, !{right}
NumpadUp:: Volume_Up
NumpadDown:: Volume_Down

NumpadIns:: Media_Play_Pause
NumpadDel:: Media_Stop
NumpadPgUp::Media_Prev
NumpadPgDn::Media_Next

NumpadHome:: SendInput !{Up}

NumpadClear::PrintScreen

#If

; -----------------------------------------
; Fn -	Function key
; -----------------------------------------
!.:: SendInput {PgUp}
!/:: SendInput {PgDn}
!;:: SendInput {Home}
!':: SendInput {End}
![:: SendInput {Insert}
!]:: SendInput {Delete}




-------------------------------------------------------------------------------
;~ MOUSE EVENT (MOUSE AREA)
-------------------------------------------------------------------------------
MButton:: SendInput ^w

!LButton::Send % "{Click " . ( GetKeyState("LButton") ? "Up}" : "Down}" )

~LButton::
	;~ dragSwitchDesktop()
	;~ hideTooltipFullscreen()
	removeTooltipFullscreen(20)
	clickClearExistToolTip()
	doubleClickToggleDesktopIcons()
	Random, rand, 1, 100
	if (rand == 1 and (isTitleArea() or isMouseHoverTaskBar())) {
		TrayTip, Mouse Action, Do you know?`nMFB and MBB can help you to go forward/back to history or folders.
	}
return

; Close tab with RButton + XButton1
~RButton & XButton1::
    Send ^w  ; Send the keyboard shortcut for closing a tab (Ctrl + W)
 Return

^XButton1:: SendInput ^{PgDn}
^XButton2:: SendInput ^{PgUp}

XButton1:: SendInput ^{Insert} ; copy
XButton2:: SendInput +{Insert} ; paste

!XButton1:: SendInput ^t ; New tab
!XButton2:: SendInput ^w ; Close tab

!WheelUp:: SendInput ^{PgUp}
!WheelDown:: SendInput ^{PgDn}

#if isTitleArea()
	WheelUp:: SendInput ^{PgUp}
	WheelDown:: SendInput ^{PgDn}

	XButton1:: SendInput ^{PgDn}
	XButton2:: SendInput ^{PgUp}
#if

#if isMouseHoverTaskBar()
	XButton1:: SendInput !{tab}
	XButton2:: SendInput !+{tab}
#if

#if isMouseHoverTaskBar() and !isMouseHoverSystemTray()
	WheelUp:: SendInput !+{tab}
	WheelDown:: SendInput !{tab}
#if

#XButton1:: SendInput !{tab}
#XButton2:: SendInput !+{tab}

#WheelUp:: SendInput !+{tab}
#WheelDown:: SendInput !{tab}

#IfWinActive ahk_group EdgeClose
	;~ close app
	~LButton::
		CoordMode, mouse, Screen ; Coordinates are relative to the desktop (entire screen).
		MouseGetPos, x,y
		;~ ToolTip %x% %y% %A_ScreenWidth%
		if (x >= A_ScreenWidth -1 && y == 0) {
			WinClose()
		}
	return
#IfWinActive

;~ !LButton::
	;~ SendInput {alt down}
	;~ SendInput {LButton Down}
	;~ KeyWait, Alt
	;~ SendInput {LButton Up}
;~ return


/*
WM_HELPMSG = 0x0053

OnMessage(0x112, "WM_SYSCOMMAND")
OnMessage(0x0053, "WM_Help")
OnMessage(0x201, "WM_LBUTTONDOWN")


WM_LBUTTONDOWN(wParam, lParam, Msg, hWnd)
{
	if (Msg = WM_HELPMSG)
	WM_HELP(0, lParam, WM_HELPMSG, hWnd)
	else
	{
    MouseGetPos,,,winID
	WinGetClass, class, ahk_id %winID%
	; Bizarro results with OutputVarControl so get class instead
    if (class="tooltips_class32")
	{
	ToolTip
	}
	}
}
*/

OnClipboardChange:
if(A_EventInfo=1)
{
text_selected := true
; ToolTip text is selected
; Sleep 1000
; ToolTip
}
else
text_selected := false
return
-------------------------------------------------------------------------------
;~ VOLUME CONTROL
-------------------------------------------------------------------------------
; Example 1: Adjust volume by scrolling the mouse wheel over the taskbar.
#If isMouseHoverSystemTray()
	;~ WheelUp::Send {Volume_Up}
	;~ WheelDown::Send {Volume_Down}
	WheelDown:: ToolTip % A_Now
#If

isMouseHoverSystemTray()
{
	w := A_ScreenWidth
	MouseGetPos,x,y, Win
	return isMouseHoverTaskBar() and x >= w - (w/4)
}

isMouseHoverTaskBar()
{
	return MouseIsOver("ahk_class Shell_TrayWnd")
}

MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}


;------------------------------------------------------------------------------------------------------------------
; 												FUNCTIONS AREA
;------------------------------------------------------------------------------------------------------------------



doubleClickToggleDesktopIcons()
{
    static lastClick := 0
    static clickCount := 0

    ; Check if click happened on desktop
    MouseGetPos,,, win
    WinGetClass, className, ahk_id %win%
    if (className != "Progman" && className != "WorkerW" && className != "Windows.UI.Core.CoreWindow")
        return

    ; Double-click detection
    if (A_TickCount - lastClick < 400)
    {
        clickCount++
        if (clickCount = 2)
        {
            DesktopIcons()
            clickCount := 0
        }
    }
    else
    {
        clickCount := 1
    }
    lastClick := A_TickCount
}


RandomString(length := 10, charset := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") {
    str := ""
    Loop, %length%
    {
        Random, randIndex, 1, % StrLen(charset)
        str .= SubStr(charset, randIndex, 1)
    }
    return str
}

; Example usage:
; MsgBox % "Random string: " . RandomString(16)

^+r:: SendInput % RandomString(16)

;~ https://www.autohotkey.com/boards/viewtopic.php?t=78216
;- show selected keyboard language
^!F1::
SetFormat, Integer, H
a2:= DllCall("user32.dll\GetKeyboardLayout", "UInt", ThreadId, "UInt")
msgbox,Now=%a2%
Return

;Keyboard Identifiers and Input Method Editors for Windows | Microsoft Docs @ https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-language-pack-default-values?view=windows-11
;- to change the input language of the active window ( maybe first use Setdefaultkeyboardlang ) :
;-----------------------------------------------------------------------------
^+!1::SetInputLang(0x0406) ; Danish
^+!2::SetInputLang(0x0409) ; English (USA)
^+!3::SetInputLang(0x0807) ; Swiss-german         ; SetInputLang(0x0411)  Japanese
^+!4::SetInputLang(0x0408) ; Greek

;--- modulo/toggle switch between 2 keyboard-languages
;~ ^CapsLock::
	;~ V++
	;~ M:=mod(V,2)
	;~ if M=1
	   ;~ SetInputLang(0x0408) ; Greek
	;~ else
	   ;~ SetInputLang(0x0409) ; English
	;~ sleep,1000
	;~ SetFormat, Integer, H
	;~ a2:= DllCall("user32.dll\GetKeyboardLayout", "UInt", ThreadId, "UInt")
	;~ msgbox,Now=%a2%
;~ return

SetInputLang(Lang)
{
    WinExist("A")
    ControlGetFocus, CtrlInFocus
    PostMessage, 0x50, 0, % Lang, %CtrlInFocus%
}

;- Keyboardx Keyboardchangelanguage
;- can change keyboard , but use WIN+SPACE or alt+Shift to select ( WIN-10 )
;--------------------------------------------------------------------------
;- (0x0406)=danish  (0x0409)=English (USA)  (0x0411)=Japanese
;-------------------------------------------------------------
; https://docs.microsoft.com/de-de/windows/desktop/Intl/language-identifier-constants-and-strings
^+!#F6::SetDefaultKeyboardLang(0x0409)  ; english -USA
^+!#F7::SetDefaultKeyboardLang(0x0408)  ; greek el-GR
^+!#F8::SetDefaultKeyboardLang(0x0807)  ; swiss german de-CH
;-------------------------------
; https://autohotkey.com/boards/viewtopic.php?f=6&t=18519
SetDefaultKeyboardLang(LocaleID){
	Static SPI_SETDEFAULTINPUTLANG := 0x005A, SPIF_SENDWININICHANGE := 2
	Lan := DllCall("LoadKeyboardLayout", "Str", Format("{:08x}", LocaleID), "Int", 0)
	VarSetCapacity(binaryLocaleID, 4, 0)
	NumPut(LocaleID, binaryLocaleID)
	DllCall("SystemParametersInfo", "UInt", SPI_SETDEFAULTINPUTLANG, "UInt", 0, "UPtr", &binaryLocaleID, "UInt", SPIF_SENDWININICHANGE)
	WinGet, windows, List
	Loop % windows {
		PostMessage 0x50, 0, % Lan, , % "ahk_id " windows%A_Index%
	}
}

;===========================================================================================



--------------------------------------------------------------------------------
;~ https://www.autohotkey.com/board/topic/116538-detect-which-language-is-currently-on/
;^F1:: CheckLanguage()

CheckLanguage()
{
	Send, {LAlt down}{Shift}{LAlt up}
	if !LangID := GetKeyboardLanguage(WinActive("A"))
	{
		MsgBox, % "GetKeyboardLayout function failed " ErrorLevel
		return
	}

	if (LangID = 0x0409)
		MsgBox, Language is EN
	else if (LangID = 0x080C)
		MsgBox, Language is FR
	else if (LangID = 0x0813)
		MsgBox, Language is NL
	else if (LangID = 2052)
		MsgBox, Language is CH
	else if (LangID = 1066)
		MsgBox, Language is VI
	else if (LangID = 1041)
		MsgBox, Language is JA
	else
		MsgBox, Other else: %LangID%
}

GetKeyboardLanguage(_hWnd=0)
{
	if !_hWnd
		ThreadId=0
	else
		if !ThreadId := DllCall("user32.dll\GetWindowThreadProcessId", "Ptr", _hWnd, "UInt", 0, "UInt")
			return false

	if !KBLayout := DllCall("user32.dll\GetKeyboardLayout", "UInt", ThreadId, "UInt")
		return false

	return KBLayout & 0xFFFF
}

~F11::
~F::
	hideTooltipFullscreen()
	;~ removeTooltipFullscreen(20)
return

F11::PrintScreen


Explorer_GetSelection() {
   WinGetClass, winClass, % "ahk_id" . hWnd := WinExist("A")
   if !(winClass ~= "(Cabinet|Explore)WClass")
      Return
   for window in ComObjCreate("Shell.Application").Windows
      if (hWnd = window.HWND) && (oShellFolderView := window.document)
         break
   for item in oShellFolderView.SelectedItems
      result .= (result = "" ? "" : "`n") . item.path
   Return result
}


hideTooltipFullscreen()
{
	Sleep, 1000
	isFullScreen := isWindowFullScreen( "A" )

	hwnd := WinExist("ahk_class tooltips_class32")
	;~ ToolTip, % hwnd
	if isFullScreen {
		;~ WinSet, Trans, 10, % "ahk_id" hwnd
		WinSet, Trans, 10, ahk_class tooltips_class32
	} else {
		;~ WinSet, Trans, 90, % "ahk_id" hwnd
		WinSet, Trans, 90, ahk_class tooltips_class32
	}
}

removeTooltipFullscreen(nToolTipIndex)
{
	Sleep, 100
	isFullScreen := isWindowFullScreen( "A" )

	hwnd := WinExist("ahk_class tooltips_class32")
	;~ ToolTip, % hwnd
	if isFullScreen {
		ToolTip,,,,%nToolTipIndex%
	} else {
		;~ MsgBox, not fullscreen
	}
}

clickClearExistToolTip()
{
	MouseGetPos,,, winID
    if (winID = WinExist("ahk_class tooltips_class32"))
		ToolTip,,,, 20
}

; https://www.autohotkey.com/board/topic/38882-detect-fullscreen-application/
^+!f::
isFullScreen := isWindowFullScreen( "A" )
MsgBox % isFullScreen ? "Full Screen" : "Windowed"
Return

isWindowFullScreen( winTitle ) {
	;checks if the specified window is full screen

	winID := WinExist( winTitle )

	If ( !winID )
		Return false

	WinGet style, Style, ahk_id %WinID%
	WinGetPos ,,,winW,winH, %winTitle%
	; 0x800000 is WS_BORDER.
	; 0x20000000 is WS_MINIMIZE.
	; no border and not minimized
	Return ((style & 0x20800000) or winH < A_ScreenHeight or winW < A_ScreenWidth) ? false : true
}

--------------------------------------------------------------------------------

; http://www.autohotkey.com/forum/viewtopic.php?t=55041
/*! TheGood
    Checks if a window is in fullscreen mode.
    ______________________________________________________________________________________________________________
    sWinTitle       - WinTitle of the window to check. Same syntax as the WinTitle parameter of, e.g., WinExist().
    bRefreshRes     - Forces a refresh of monitor data (necessary if resolution has changed)
    Return value    o If window is fullscreen, returns the index of the monitor on which the window is fullscreen.
                    o If window is not fullscreen, returns False.
    ErrorLevel      - Sets ErrorLevel to True if no window could match sWinTitle

        Based on the information found at http://support.microsoft.com/kb/179363/ which discusses under what
    circumstances does a program cover the taskbar. Even if the window passed to IsFullscreen is not the
    foreground application, IsFullscreen will check if, were it the foreground, it would cover the taskbar.
*/
IsFullscreen(sWinTitle = "A", bRefreshRes = False) {
    Static
    Local iWinX, iWinY, iWinW, iWinH, iCltX, iCltY, iCltW, iCltH, iMidX, iMidY, iMonitor, c, D, iBestD

    ErrorLevel := False

    If bRefreshRes Or Not Mon0 {
        SysGet, Mon0, MonitorCount
        SysGet, iPrimaryMon, MonitorPrimary
        Loop %Mon0% { ;Loop through each monitor
            SysGet, Mon%A_Index%, Monitor, %A_Index%
            Mon%A_Index%MidX := Mon%A_Index%Left + Ceil((Mon%A_Index%Right - Mon%A_Index%Left) / 2)
            Mon%A_Index%MidY := Mon%A_Index%Top + Ceil((Mon%A_Index%Top - Mon%A_Index%Bottom) / 2)
        }
    }

    ;Get the active window's dimension
    hWin := WinExist(sWinTitle)
    If Not hWin {
        ErrorLevel := True
        Return False
    }

    ;Make sure it's not desktop
    WinGetClass, c, ahk_id %hWin%
    If (hWin = DllCall("GetDesktopWindow") Or (c = "Progman") Or (c = "WorkerW"))
        Return False

    ;Get the window and client area, and style
    VarSetCapacity(iWinRect, 16), VarSetCapacity(iCltRect, 16)
    DllCall("GetWindowRect", UInt, hWin, UInt, &iWinRect)
    DllCall("GetClientRect", UInt, hWin, UInt, &iCltRect)
    WinGet, iStyle, Style, ahk_id %hWin%

    ;Extract coords and sizes
    iWinX := NumGet(iWinRect, 0), iWinY := NumGet(iWinRect, 4)
    iWinW := NumGet(iWinRect, 8) - NumGet(iWinRect, 0) ;Bottom-right coordinates are exclusive
    iWinH := NumGet(iWinRect, 12) - NumGet(iWinRect, 4) ;Bottom-right coordinates are exclusive
    iCltX := 0, iCltY := 0 ;Client upper-left always (0,0)
    iCltW := NumGet(iCltRect, 8), iCltH := NumGet(iCltRect, 12)

    ;Check in which monitor it lies
    iMidX := iWinX + Ceil(iWinW / 2)
    iMidY := iWinY + Ceil(iWinH / 2)

   ;Loop through every monitor and calculate the distance to each monitor
   iBestD := 0xFFFFFFFF
    Loop % Mon0 {
      D := Sqrt((iMidX - Mon%A_Index%MidX)**2 + (iMidY - Mon%A_Index%MidY)**2)
      If (D < iBestD) {
         iBestD := D
         iMonitor := A_Index
      }
   }

    ;Check if the client area covers the whole screen
    bCovers := (iCltX <= Mon%iMonitor%Left) And (iCltY <= Mon%iMonitor%Top) And (iCltW >= Mon%iMonitor%Right - Mon%iMonitor%Left) And (iCltH >= Mon%iMonitor%Bottom - Mon%iMonitor%Top)
    If bCovers
        Return True

    ;Check if the window area covers the whole screen and styles
    bCovers := (iWinX <= Mon%iMonitor%Left) And (iWinY <= Mon%iMonitor%Top) And (iWinW >= Mon%iMonitor%Right - Mon%iMonitor%Left) And (iWinH >= Mon%iMonitor%Bottom - Mon%iMonitor%Top)
    If bCovers { ;WS_THICKFRAME or WS_CAPTION
        bCovers := bCovers And (Not (iStyle & 0x00040000) Or Not (iStyle & 0x00C00000))
        Return bCovers ? iMonitor : False
    } Else Return False
}

;------------------------------------------------------------------------------------------------------------------
; 												CREATING NEW FILE
;------------------------------------------------------------------------------------------------------------------
; This is part of my AutoHotKey [1] script. When you are in Windows Explorer it
; allows you to press Alt+N and type a filename, and that file is created
; in the current directory and opened in the appropriate editor (usually
; [gVim](http://www.vim.org/) in my case, but it will use whatever program is
; associated with the file in Windows Explorer).

; This is much easier than the alternative that I have been using until now:
; Right click > New > Text file, delete default filename and extension (which
; isn't highlighted in Windows 7), type the filename, press enter twice.
; (Particularly for creating dot files like ".htaccess".)

; Credit goes to aubricus [2] who wrote most of this and davejamesmiller [3] who
; added the 'IfWinActive' check and 'Run %UserInput%' at the end. Also to
; syon [4] who changed regexp to make script work on non-english versions
; of Windows. And I changed the way how script gets full path to make it
; compatible with Windows 10 and also changed hotkey to Alt+N

; [1]: http://www.autohotkey.com/
; [2]: https://gist.github.com/1148174
; [3]: https://gist.github.com/1965432
; [4]: https://github.com/syon/ahk/blob/master/NewFile/NewFile.ahk


; Only run when Windows Explorer or Desktop is active
; Alt+N
#IfWinActive ahk_class CabinetWClass
!SC031::
#IfWinActive ahk_class ExploreWClass
!SC031::
#IfWinActive ahk_class Progman
!SC031::
#IfWinActive ahk_class WorkerW
!SC031::

    ; Get full path from open Explorer window
    WinGetText, FullPath, A

    ; Split up result (it returns paths seperated by newlines)
    StringSplit, PathArray, FullPath, `n

	; Find line with backslash which is the path
	Loop, %PathArray0%
    {
        StringGetPos, pos, PathArray%a_index%, \
        if (pos > 0) {
            FullPath:= PathArray%a_index%
            break
        }
    }

    ; Clean up result
    FullPath := RegExReplace(FullPath, "(^.+?: )", "")
	StringReplace, FullPath, FullPath, `r, , all


    ; Change working directory
    SetWorkingDir, %FullPath%

    ; An error occurred with the SetWorkingDir directive
    If ErrorLevel
        Return

    ; Display input box for filename
    InputBox, UserInput, New File, , , 400, 100, , , , ,

    ; User pressed cancel
    If ErrorLevel
        Return

    ; Create file
    FileAppend, , %UserInput%

    ; Open the file in the appropriate editor
    ;Run %UserInput%

    Return

#IfWinActive



#IfWinActive ahk_group FILES
^+t:: create_file("new.txt",true)
^+h:: create_file("new.html",true)
^+p:: create_file("new.php",true)
^NumpadAdd:: GuiCreateFile()
#IfWinActive

GuiCreateFile()
{
	InputBox, file_name , Create File, Input file name, false, 400, 120
	If (!ErrorLevel && file_name != "")
		create_file(file_name)
}

;~ create_file(FileName,rename:=false)
;~ {
	;~ ; Get full path from open Explorer window
    ;~ WinGetText, FullPath, A

    ;~ ; Split up result (it returns paths seperated by newlines)
    ;~ StringSplit, PathArray, FullPath, `n

	;~ ; Find line with backslash which is the path
	;~ ; This used to work in Windows 10
	;~ Loop, %PathArray0%
    ;~ {
        ;~ StringGetPos, pos, PathArray%a_index%, \
        ;~ if (pos > 0) {
            ;~ FullPath:= PathArray%a_index%
            ;~ break
        ;~ }
    ;~ }

	;~ ; Windows 11 Explorer
	;~ FullPath:= PathArray1

    ;~ ; Clean up result
    ;~ FullPath := RegExReplace(FullPath, "(^.+?: )", "")
	;~ StringReplace, FullPath, FullPath, `r, , all

    ;~ ; Change working directory
    ;~ SetWorkingDir, %FullPath%
	;~ FileAppend, , %FileName%
	;~ Sleep 2000
	;~ IfExist, %FileName%
		;~ SendInput %FileName%
	;~ Sleep 200
	;~ if (rename)new.txt
		;~ SendInput {f2}
;~ }

create_file(FileName, rename := false) {
    ; Get the active window's handle
    WinGet, activeHwnd, ID, A

    ; Check if the active window is a File Explorer
    if (WinActive("ahk_class CabinetWClass") || WinActive("ahk_class ExploreWClass")) {
        ; Create a Shell object to access the file system
        shell := ComObjCreate("Shell.Application")

        ; Get the active Explorer window
        for window in shell.Windows {
            if (window.hwnd = activeHwnd) {
                ; Retrieve the folder path
                FullPath := window.LocationURL
                FullPath := StrReplace(FullPath, "file:///", "")
                FullPath := StrReplace(FullPath, "/", "\") ; Convert slashes to backslashes
                MsgBox % "Current Directory Path: " FullPath

                ; Set the working directory
                SetWorkingDir, %FullPath%
                FileAppend, , %FileName%
                Sleep 2000

                IfExist, %FileName%
                    SendInput %FileName%
                Sleep 200

                if (rename)
                    SendInput {f2}

                return
            }
        }
        MsgBox "Active window not found in Shell."
    } else {
        MsgBox "The active window is not a file explorer."
    }
}



getDirPath2()
{
	; Get the active Explorer window's handle
	WinGet, activeHwnd, ID, A

	; Use DllCall to get the path from the Explorer window
	if (WinActive("ahk_class CabinetWClass") || WinActive("ahk_class ExploreWClass")) {
		; Get the path
		VarSetCapacity(path, 260) ; MAX_PATH
		if (DllCall("GetWindowText", "uint", activeHwnd, "str", path, "int", 260)) {
			; Trim the path to remove any leading/trailing whitespace
			StringTrimRight, path, path, 1
			MsgBox % "Current Directory Path: " path
		} else {
			MsgBox "Failed to retrieve the path."
		}
	} else {
		MsgBox "The active window is not a file explorer."
	}

}

getDirPath()
{
	; Get the active window's handle
	WinGet, activeHwnd, ID, A

	; Get the class name of the active window
	WinGetClass, className, ahk_id %activeHwnd%

	; Check if the active window is a File Explorer
	if (className = "CabinetWClass" || className = "ExploreWClass") {
		; Use DllCall to get the path from the window
		VarSetCapacity(buffer, 512)
		if (DllCall("GetWindowLong", "uint", activeHwnd, "int", -12) && DllCall("GetWindowText", "uint", activeHwnd, "str", buffer, "int", 512)) {
			; Remove trailing backslash
			StringTrimRight, buffer, buffer, 1
			MsgBox % "Current Directory Path: " buffer
		} else {
			MsgBox "Failed to get the path."
		}
	} else {
		MsgBox "The active window is not a file explorer."
	}
	return
}

; -----------------------------------------
; SCRLK -	SCROLLLOCK KEYS - SCROLLLOCK AREA
; -----------------------------------------
#if GetKeyState("ScrollLock", "T") ; True if ScrollLock is ON, false otherwise.
	;~ NumpadIns:: Media_Play_Pause
	;~ NumpadDel:: Media_Stop
	NumpadLeft:: Media_Prev
	NumpadRight:: Media_Next

	F5::Media_Stop
	F6::Media_Prev
	F7::Media_Play_Pause
	F8::Media_Next

; MACKEY
	1::F1
	4::F4

	2::
		SendInput {F2}
		select_or_rename()
	return

	3::copy_or_search()
	5::reload_or_refresh()
	6::save_or_tab()
	7::move_tab_left()
	8::move_tab_right()
	9::chrome_switch_inspect()
	0::chrome_switch_mobile()
	-::F11
	=::browser_or_devtool()

; MACKEY REDRAGON
; Remap Esc key to a pair of backticks
Esc:: closeTab()

	w::Up
	a::Left
	s::Down
	d::Right
	[::Insert
	]::Delete
	`;::Home
	'::End
	.::PgUp
	/::PgDn


#if

closeTab()
{
	IfWinActive, ahk_class #32770
		SendInput {esc}
	else
		SendInput ^w
}


+NumLock:: Sendinput {scrollLock}
;!NumLock:: Sendinput {CapsLock}
!NumLock::
    SetCapsLockState, % GetKeyState("CapsLock", "T") ? "Off" : "On"
return


#if !GetKeyState("NumLock", "T") ; True if ScrollLock is ON, false otherwise.
	NumpadAdd::
		if (!WinActive("ahk_class Chrome_WidgetWin_1", , "Visual Studio Code") and !WinActive("ahk_class CabinetWClass"))
			SendInput ^n
		else
			SendInput ^t
	return
	NumpadSub::  SendInput, ^w
#if

;~ --------------------------------------------------------------------------------
;~ MACKEY AREA
;~ --------------------------------------------------------------------------------

^#1:: remapto("F1")
^#2:: remapto("F2")
^#3:: remapto("F3")
^#4:: remapto("F4")
^#5:: remapto("F5")
^#6:: remapto("F6")
^#7:: remapto("F7")
^#8:: remapto("F8")
^#9:: remapto("F9")
^#0:: remapto("F10")
^#-:: remapto("F11")
^#=:: remapto("F12")


remapto(key)
{
    KeyWait, Ctrl
    KeyWait, LWin
    Send, {%key%}
}


; ----------------------------
; RAIKU KEYBOARD
; ----------------------------
; DEFAULT MAC FUNCTION KEYS
; Identify brightness keys (Scan codes may vary by keyboard)
;~ ; Brightness Down → F1
;~ SC130::Send {F1}
;~ ; Brightness Up → F2
;~ SC131::Send {F2}

;~ Media_Prev::F7
;~ Media_Play_Pause::F8
;~ Media_Next::F9
;~ Volume_Mute::F10
;~ Volume_Down::F11
;~ Volume_Up::F12

; RAIKU FN KEYS
;~ Music::
Volume_Down::F2
Volume_Up::F3
Volume_Mute::F4
Media_Stop::F5
Media_Prev::F6
Media_Play_Pause::F7
Media_Next::F8
;~ Mail::
Browser_Home::F10
;~ Lock
;~ Calculator::

; RAIKU NUMPAD
NumpadClear::PrintScreen
; REDRAGON
AppsKey::PrintScreen
^#i:: remapto("Up")
^#k:: remapto("Down")
^#j:: remapto("Left")
^#l:: remapto("Right")

-------------------------------------------------------------------------------
;~ MACBOOK
-------------------------------------------------------------------------------
#If isEditing()
!Left::SendInput ^{Left}
!Right::SendInput ^{Right}
!Up::SendInput {Home}
!Down::SendInput {End}
;~ NumLock::MsgBox % isEditing()
#if
#BS::
!BS::SendInput {Delete}
!-:: SendInput {Delete}
!=:: SendInput {Insert}

;~ --------------------------------------------------------------------------------
;~ TESTING AREA
;~ ----------------------------------------
^!+F5::
#Persistent
SetTimer, WatchCaret, 100
return
WatchCaret:
    ToolTip, %A_Cursor% X%A_CaretX% Y%A_CaretY%, A_CaretX, A_CaretY - 20
return



^+F3::
ClipSaved := ClipboardAll       ;- save clipboard
clipboard := ""                 ;- empty clipboard
Send, ^c                        ;- copy the selected file
ClipWait,5		                ;- wait for the clipboard to contain data
if (!ErrorLevel)                ;- if NOT ErrorLevel clipwait found data on the clipboard
{
If text_selected
  {
  IfWinNotActive ,%sc%,,WinActivate,%sc%
    WinWaitActive,%sc%
  send,^v`n-----------------------------`n
  clipboard=
  }
}
Sleep, 100
clipboard := ClipSaved        ;- restore original clipboard
ClipSaved := ""               ;- free the memory in case the clipboard was very large.
return

;~ --------------------------------------------------------------------------------