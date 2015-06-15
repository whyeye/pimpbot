#var FONT_DIR

!ifndef CSIDL_FONTS
  !define CSIDL_FONTS '0x14' ;Fonts directory path constant
!endif
!ifndef CSIDL_FLAG_CREATE
  !define CSIDL_FLAG_CREATE 0x8000
!endif

!macro InstallTTF FontFile
  Push $0
  Push $R0
  Push $R1
  Push $R2
  
  !define Index 'Line${__LINE__}'

  StrCmp $OUTDIR $FONTS +2
  SetOutPath $FONTS
  IfFileExists "$FONTS\$File" ${Index}
  CopyFiles '${FontFile}' "$FONTS\$File"

${Index}:
  ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "CurrentVersion"
  IfErrors "${Index}-9x" "${Index}-NT"

"${Index}-NT:"
  StrCpy $R1 "Software\Microsoft\Windows NT\CurrentVersion\Fonts"
  goto "${Index}-GO"

"${Index}-9x:"
  StrCpy $R1 "Software\Microsoft\Windows\CurrentVersion\Fonts"
  goto "${Index}-GO"

"${Index}-GO:"
  ClearErrors
  !insertmacro FontName "${FontFile}"
  pop $R2
  IfErrors 0 "${Index}-Add"
    MessageBox MB_OK "$R2"
    Quit

"${Index}-Add:"
  StrCpy $R2 "$R2 (TrueType)"
  ClearErrors
  ReadRegStr $R0 HKLM "$R1" "$R2"
  IfErrors 0 "${Index}-End"
    System::Call "GDI32::AddFontResourceA(t) i ('$File') .s"
    WriteRegStr HKLM "$R1" "$R2" "$File"
    goto "${Index}-End"

"${Index}-End:"

  !undef Index

  pop $R2
  pop $R1
  Pop $R0
  Pop $0
!macroend

!macro InstallOTF FontFile
  Push $0
  Push $R0
  Push $R1
  Push $R2

  !define Index 'Line${__LINE__}'

  SetOutPath $FONTS
  IfFileExists "$FONTS\$File" ${Index}
  CopyFiles '${FontFile}' "$FONTS\$File"

${Index}:
  ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "CurrentVersion"
  IfErrors "${Index}-9x" "${Index}-NT"

"${Index}-NT:"
  StrCpy $R1 "Software\Microsoft\Windows NT\CurrentVersion\Fonts"
  goto "${Index}-GO"

"${Index}-9x:"
  StrCpy $R1 "Software\Microsoft\Windows\CurrentVersion\Fonts"
  goto "${Index}-GO"

"${Index}-GO:"
  StrCpy $R2 "$R2 (OpenType)"
  ClearErrors
  ReadRegStr $R0 HKLM "$R1" "$R2"
  IfErrors 0 "${Index}-End"
    System::Call "GDI32::AddFontResourceA(t) i ('$File') .s"
    WriteRegStr HKLM "$R1" "$R2" "$File"
    goto "${Index}-End"

"${Index}-End:"

  !undef Index

  pop $R2
  pop $R1
  Pop $R0
  Pop $0
!macroend
