;FontName include file for NSIS
;Written by Vytautas Krivickas (http://forums.winamp.com/member.php?s=&action=getinfo&userid=111891)
;
;If an error was generated the stack contains the translated error message
;and the error flag is set
;
;
;Translated To         - Translated By
;----------------------------------------------------------
;English (Default)     - Vytautas Krivickas
;Lithuanian            - Vytautas Krivickas
;German                - Jan T. Sott
;Hebrew                - kichik
;Portuguese (Brazil)   - deguix
;Arabic                - asdfuae
;Chinese (Traditional) - Kii Ali <kiiali@cpatch.org>
;Chinese (Simplified)  - Kii Ali <kiiali@cpatch.org>
;French                - evilO/Olive
;Spanish (Traditional) - Cecilio
;Macedonian            - Sasko Zdravkin <wingman2083@yahoo.com>

; Macros to use with FontName Plugin

!macro FontNameVer
  call TranslateFontName
  FontName::Version
!macroend

!macro FontName FONTFILE
  push ${FONTFILE}
  call TranslateFontName
  FontName::Name
  call CheckFontNameError
!macroend

; Private Functions - Called by the macros

Function TranslateFontName
  !define Index "LINE-${__LINE__}"

; Add your languages here

  ; Default English (1033) by Vytautas Krivickas - MUST REMAIN LAST!
  Push "Wrong Font Version"
  Push "MappedFile Address Error: %u"
  Push "MappedFile Error: %u"
  Push "Invalid file size: %u"
  Push "Invalid file handle %u"
  Push "FontName %s plugin for NSIS"
  goto ${Index}

${Index}:
  !undef Index
FunctionEnd

Function CheckFontNameError
  !define Index "LINE-${__LINE__}"

  exch $1
  strcmp $1 "*:*" 0 Index
    pop $1
    exch $1
    SetErrors

Index:
  exch $1
  !undef Index
FunctionEnd
