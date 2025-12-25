#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force

ico_main := "main.ico"
ico_pause := "pause.ico"
ico_suspend := "suspend.ico"
IfExist, %ico_main%
	Menu, Tray, Icon, %ico_main%
else
	Menu, Tray, Icon, shell32.dll, 145


; --- Vietnamese Telex input script ---
; Supports: a/ă/â/e/ê/o/ô/ơ/u/ư/i/y
; Tones: s (sắc), f (huyền), r (hỏi), x (ngã), j (nặng), z (remove tone)

; Define mapping for diacritics
telexMap := {}
telexMap["a"] := {"w":"ă", "aa":"â"}
telexMap["o"] := {"w":"ơ", "oo":"ô"}
telexMap["u"] := {"w":"ư"}
telexMap["d"] := {"d":"đ"}
telexMap["e"] := {"ee":"ê"}

; Tone marks
toneMap := {}
toneMap["s"] := {"a":"á","ă":"ắ","â":"ấ","e":"é","ê":"ế","i":"í","o":"ó","ô":"ố","ơ":"ớ","u":"ú","ư":"ứ","y":"ý"}
toneMap["f"] := {"a":"à","ă":"ằ","â":"ầ","e":"è","ê":"ề","i":"ì","o":"ò","ô":"ồ","ơ":"ờ","u":"ù","ư":"ừ","y":"ỳ"}
toneMap["r"] := {"a":"ả","ă":"ẳ","â":"ẩ","e":"ẻ","ê":"ể","i":"ỉ","o":"ỏ","ô":"ổ","ơ":"ở","u":"ủ","ư":"ử","y":"ỷ"}
toneMap["x"] := {"a":"ã","ă":"ẵ","â":"ẫ","e":"ẽ","ê":"ễ","i":"ĩ","o":"õ","ô":"ỗ","ơ":"ỡ","u":"ũ","ư":"ữ","y":"ỹ"}
toneMap["j"] := {"a":"ạ","ă":"ặ","â":"ậ","e":"ẹ","ê":"ệ","i":"ị","o":"ọ","ô":"ộ","ơ":"ợ","u":"ụ","ư":"ự","y":"ỵ"}

; Capture hotkeys for telex tones
~s::HandleTone("s")
~f::HandleTone("f")
~r::HandleTone("r")
~x::HandleTone("x")
~j::HandleTone("j")
~z::HandleTone("z") ; remove tone

;~ ~^Shift:: Suspend
;~ ^AppsKey:: Suspend
^RCtrl:: Suspend
^+k:: Suspend
!+e::Suspend, On    ; only affects hotkeys, hotstrings still run
!+v::Suspend, Off


HandleTone(tone) {

    global toneMap
    ; Get last character before caret
    SendInput {ShiftDown}{Left 2}{ShiftUp}   ; select previous char
    ClipSaved := ClipboardAll
    Clipboard := ""
    SendInput ^c
    ClipWait, 0.1
    lastChar := SubStr(Clipboard, 1, 1)      ; ensure just first char
    Clipboard := ClipSaved

    ; If no character is selected, just type the tone key
    if (lastChar = "") {
        SendInput % tone
        return
    }

    ; Check if the last char is already toned (for example, 'á' should return 'a')
    baseChar := RemoveTone(lastChar)   ; Assuming you have RemoveTone() implemented

    ; Apply tone
    if (tone = "z") {
        ; Remove tone: restore base char
        base := RemoveTone(lastChar)
        if (base != "")
            SendInput % "{BS}" base
        else
            SendInput {Right}
    } else if (baseChar != lastChar) {
        ;~ ToolTip %baseChar%+%lastChar%
        ; The char is toned, so we remove the tone and return to base char
        SendInput {BS}        ; Delete the current (toned) character
        SendInput %baseChar%%tone%%tone% ; Insert the base character (no tone)
        return
    } else if (toneMap.HasKey(tone) && toneMap[tone].HasKey(lastChar)) {
        newChar := toneMap[tone][lastChar]
        SendInput % "{BS}" newChar
    } else {
        SendInput {Right}
    }
}

RemoveTone(char) {
    ; Strip tones back to plain letter
    toneStr := "áàảãạắằẳẵặấầẩẫậéèẻẽẹếềểễệíìỉĩịóòỏõọốồổỗộớờởỡợúùủũụứừửữựýỳỷỹỵ"
    baseStr := "aaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyy"
    pos := InStr(toneStr, char)
    if (pos > 0)
        return SubStr(baseStr, pos, 1)
    else
        ;~ return ""
        return char
}

; Telex consonant/letter mappings like "dd" -> "đ"
:*:dd::đ
:?*:aw::ă
:?*:aa::â
:?*:ee::ê
:?*:oo::ô
:?*:ow::ơ
:?*:uw::ư

return
