; PimpBot Compiler by Jan T. Sott
; http://pimpbot.googlecode.com

; Add document icon to executable
  !packhdr "$%TEMP%\exehead.tmp" "_reshacker\ResHacker.exe -addoverwrite $%TEMP%\exehead.tmp,$%TEMP%\exehead.tmp,_ui\pimpdoc.ico,icongroup,104,"
  #!packhdr "$%TEMP%\exehead.tmp" "bin\upx.exe --lzma --keep-resource=104 $%TEMP%\exehead.tmp"

 ; Public Source Code
  !if ${BRANDED} != 1
	!define PUBLIC_SOURCE 1
  !endif
 
;Definitions
  !define PB_NAME "PimpBot Compiler"
  !define PB_VERSION "4.4.5.0"
  !define PB_CAPTION "${PB_NAME}"
  !ifndef UNICODE ;compiler override
	;0=ANSI | 1=(not yet implemented) | 2=Unicode
	!define UNICODE 2
  !endif
  !define COL_REQ "0xfff799"
  !define COL_VAL "0xd8eabd"
  !define COL_INV "0xffbfbf"
  !define TIMEOUT "1500"
  !define NUMERIC "1234567890"
  !define ILLCHARS "\/:*?$\"<>|"
  !define MUI_ABORTWARNING
  !define MUI_ABORTWARNING_TEXT "Are you sure you want to quit ${PB_NAME}?" #change
  !define MUI_CUSTOMFUNCTION_UNABORT "MyUserAbort"
  !define PAGE1
  !define PAGE2
  !define PAGE3
  !define PAGE4
  !define PAGE5
  !define PAGE6  
  
;Definitions for debugging
  #!define INCLUDE_APE
  !define APE_SOURCE "$EXEDIR\ape"
  !define LOCATE_FUNCT 2 # 1=Locate plugin (performance) # 2=Locate macro (reliability) - as of 4.4.4.2 the 2nd method is default
  
;Header
  !if ${UNICODE} == 2
	  Name "${PB_NAME} (Unicode)"
	  Caption "${PB_CAPTION} (Unicode)"
  !else
	Name "${PB_NAME}"
	Caption "${PB_CAPTION}"
  !endif
  OutFile "compiler.exe"
  SetDatablockOptimize on
  SetCompress force
  SetCompressor /SOLID lzma
  CRCCheck on
  BrandingText "whyEye.org"
  XPStyle on 
  RequestExecutionLevel user
  #TargetMinimalOS 5.0
  #InstallButtonText "Quit"
  MiscButtonText "" "" "" "Quit" #[back button text [next button text] [cancel button text] [close button text]]
  InstallDir "$PROGRAMFILES\whyEye.org\PimpBot"
  InstallDirRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PimpBot" "UninstallString"
  
  ;Version Resources
  VIProductVersion "${PB_VERSION}"
  VIAddVersionKey "ProductName" "${PB_NAME}"
  VIAddVersionKey "FileVersion" "${PB_VERSION}"
  VIAddVersionKey "ProductVersion" "${PB_VERSION}"
  VIAddVersionKey "LegalCopyright" "Jan T. Sott"
  VIAddVersionKey "OriginalFilename" "compiler.exe"
  !if ${UNICODE} == 2
	VIAddVersionKey "FileDescription" "${PB_NAME} ${PB_VERSION} (Unicode)"
  !else
	VIAddVersionKey "FileDescription" "${PB_NAME} ${PB_VERSION}"
  !endif
  VIAddVersionKey "Comments" "http://pimpbot.whyeye.org"
  
  !ifndef PUBLIC_SOURCE
	  BrandingText "whyEye.org"
	  !define MUI_ICON "_pimpbot.ico"
	  !define MUI_INSTFILESPAGE_COLORS "000000 FFFFFF"
	  !define MUI_INSTFILESPAGE_PROGRESSBAR "colored smooth"
	  
	  !define MUI_HEADERIMAGE
	  !define MUI_HEADERIMAGE_BITMAP "_pimpbot.bmp"
	  !define MUI_BGCOLOR "0x1b1b1b"
	  
	  !include "_passphrase.nsh" ;or use !define PASSPHRASE "Your password here"
  !else
	  BrandingText "http://pimpbot.googlecode.com"
  !endif ;PUBLIC_SOURCE

;Variables
	Var DUMP
	Var MyTempDir
	Var Parameter
	Var Switches
	Var BabelScript
	Var Input
	Var InputExt
	Var InputPath
	Var InputFile
	Var Passphrase
	Var Passive
	Var autoAPE
	Var autoRes
	Var injectSkin
	Var injectSkinName
	Var noAvs
	Var noExe
	Var noOutput
	Var noPimp
	Var noMUI
	Var customNSI
	Var customScript
	Var customUI
	Var mkZip
	Var visDir
	Var Caption
	Var NSIS
	Var 7zip
	Var settingsINI
	Var defaultsINI
	Var pimpINI
	Var OutputFile
	Var OutputFileParam
	Var OutputDir
	Var FileDetails
	Var Legacy
	Var DebugLevel
	Var LastPack
	Var count_Presets
	Var count_AltPresets
	Var count_AddFiles
	Var count_Fonts
	Var count_APEs
	Var count_AllFiles
	Var pimpGoBack
	Var TexerMega_Warning
	Var ComponentsWarning
	Var tempFile
	Var apeCounter
	!if ${LOCATE_FUNCT} == 2
		Var preVal
		Var arrayDir
		Var arrayFile
		#Var deepLevel
		#Var flatLevel
	!endif
	
	#Status
	!ifdef PAGE1
	Var State_PresetType
	!ifndef PUBLIC_SOURCE
		Var State_UpdateCheck
		Var State_LatestURL
		Var State_LatestAltURL
		Var State_LatestVersion
	!endif ;PUBLIC_SOURCE
	Var State_Project
	Var State_NewProject_Button
	Var State_LoadProject_Button
	Var State_PimpList
	Var State_TypeListLoad
	Var State_TypeListNew
	Var State_TypeEnable
	Var State_Defaults
	Var State_UIListLoad
	Var State_UIListNew
	Var State_UIEnable
	Var State_UI
	Var State_Recompile
	!endif ;PAGE1
	
	!ifdef PAGE2
	Var State_Name
	Var State_Version
	Var State_PresetDir
	Var State_Subfolders
	Var State_AltPresetDir
	Var State_AltSubfolders
	Var State_PresetFile
	Var State_AddFiles
	Var State_AddBMP
	Var State_AddJPG
	Var State_AddAVI
	Var State_AddGVM
	Var State_AddSVP
	Var State_AddUVS
	Var State_AddCFF
	Var State_AddCLM
	!endif ;PAGE2
	
	!ifdef PAGE3
	Var State_SplashBitmap
	Var State_Transparency
	Var State_SplashTime
	Var State_SplashSound
	Var State_Icon
	Var State_Checks
	Var State_Wizard
	!endif ;PAGE3
	
	!ifdef PAGE4
	Var State_License	
	Var State_CreativeCommons	
	Var State_Fonts	
	Var State_WebsiteURL
	Var State_WebsiteName
	Var State_Settings
	Var State_Components
	Var State_Multilingual
	Var State_AutoClose
	!endif ;PAGE4
	
	!ifdef PAGE5
	Var State_AddBorder
	Var State_BufferBlend
	Var State_ChannelShift
	Var State_ColorMap
	Var State_ColorReduction
	Var State_ConvolutionFilter
	Var State_FramerateLimiter
	Var State_GlobalVarMan
	Var State_Multiplier
	Var State_MultiFilter
	Var State_NegativeStrobe
	Var State_Normalise
	Var State_Picture2
	Var State_RGBFilter
	Var State_ScreenReverse
	Var State_Texer
	Var State_Texer2
	Var State_TransAuto
	Var State_Triangle
	Var State_VfxAVIPlayer
	Var State_VideoDelay
	
	Var Detect_AddBorder
	Var Detect_BufferBlend
	Var Detect_ChannelShift
	Var Detect_ColorMap
	Var Detect_ColorReduction
	Var Detect_ConvolutionFilter
	Var Detect_FramerateLimiter
	Var Detect_GlobalVarMan
	Var Detect_Multiplier
	Var Detect_MultiFilter
	Var Detect_NegativeStrobe
	Var Detect_Normalise
	Var Detect_Picture2
	Var Detect_RGBFilter
	Var Detect_ScreenReverse
	Var Detect_Texer
	Var Detect_Texer2
	Var Detect_TransAuto
	Var Detect_Triangle
	Var Detect_VfxAVIPlayer
	Var Detect_VideoDelay
	
	Var State_TexerTug
	Var State_TexerYat
	Var State_TexerMega
	!endif ;PAGE5
	
	!ifdef PAGE1
	Var Page1_Dialog
	Var Page1_NewProject_Button
	Var Page1_LoadProject_Button
	!ifndef PUBLIC_SOURCE
		Var Page1_Update_Link
	!endif
	Var Page1_GroupBox
	Var Page1_StartLabel
	Var Page1_PimpList
	#Var Page1_PimpLoad
	Var Page1_TypeLabelNew
	Var Page1_TypeLabelLoad
	Var Page1_TypeEnable
	Var Page1_TypeListLoad
	Var Page1_TypeListNew
	Var Page1_Defaults
	Var Page1_UILabelLoad
	Var Page1_UILabelNew
	Var Page1_UIEnable
	Var Page1_UIListLoad
	Var Page1_UIListNew
	Var Page1_Recompile
	#Var Page1_CBNew
	#Var Page1_CBOld
	#Var Page1_PimpList
	!endif ;PAGE1
	
	!ifdef PAGE2
	Var Page2_Dialog
	Var Page2_Name_Label
	Var Page2_Name
	Var Page2_Version_Label
	Var Page2_Version
	Var Page2_PresetDir_Label
	Var Page2_PresetDir
	Var Page2_PresetDir_Button
	Var Page2_PresetFile
	Var Page2_PresetFile_Button
	Var Page2_Subfolders
	Var Page2_AltPresetDir
	Var Page2_AltPresetDir_Button
	#Var Page2_Country
	Var Page2_AltSubfolders
	Var Page2_AddFiles_Label
	Var Page2_AddFiles
	Var Page2_AddFiles_Button
	Var Page2_CB_BMP
	Var Page2_CB_JPG
	Var Page2_CB_AVI
	Var Page2_CB_GVM
	Var Page2_CB_SVP
	Var Page2_CB_UVS
	Var Page2_CB_CFF
	Var Page2_CB_CLM
	Var Page2_ScanResources
	Var Page2_ScanResources_Label
	!endif ;PAGE2
	
	!ifdef PAGE3
	Var Page3_Dialog
	Var Page3_Splash
	Var Page3_Splash_Label
	Var Page3_Splash_Button	
	Var Page3_Transparency
	Var Page3_Transparency_Label
	Var Page3_SplashTime_Label
	Var Page3_SplashTime
	Var Page3_SplashSound
	Var Page3_SplashSound_Button
	Var Page3_SplashSound_Label
	Var Page3_Icon
	Var Page3_Icon_Button
	Var Page3_Icon_Label
	Var Page3_Icon_Error
	Var Page3_Checks
	Var Page3_Checks_Button
	Var Page3_Checks_Label
	Var Page3_Checks_Error
	Var Page3_Wizard
	Var Page3_Wizard_Button
	Var Page3_Wizard_Label
	!endif ;PAGE3
	
	!ifdef PAGE4
	Var Page4_Dialog
	Var Page4_LicenseFile
	Var Page4_LicenseFile_Label
	Var Page4_LicenseFile_Button
	Var Page4_CC
	Var Page4_CC_Label
	Var Page4_CC_Button
	Var Page4_Fonts
	Var Page4_Fonts_Label
	Var Page4_Fonts_Button
	Var Page4_Website
	Var Page4_Website_Label
	Var Page4_WebsiteName
	Var Page4_WebsiteName_Label
	Var Page4_Multilingual
	Var Page4_Settings
	Var Page4_Components
	Var Page4_AutoClose
	!endif ;$PAGE4
	
	!ifdef PAGE5
	Var Page5_Dialog
	Var Page5_SelectAPEs
	Var Page5_DetectAPEs
	Var Page5_AddBorder
	Var Page5_BufferBlend
	Var Page5_ChannelShift
	Var Page5_ColorMap
	Var Page5_ColorReduction
	Var Page5_ConvolutionFilter
	Var Page5_FramerateLimiter
	Var Page5_GlobalVarMan
	Var Page5_Multiplier
	Var Page5_MultiFilter
	Var Page5_NegativeStrobe
	Var Page5_Normalise
	Var Page5_Picture2
	Var Page5_RGBFilter
	Var Page5_ScreenReverse
	Var Page5_Texer
	Var Page5_Texer2
	Var Page5_TransAuto
	Var Page5_Triangle
	Var Page5_VfxAVIPlayer
	Var Page5_VideoDelay
	Var Page5_TexerGroup
	Var Page5_TexerTug
	Var Page5_TexerYat
	Var Page5_TexerMega
	!endif ;PAGE5
	
	!ifdef PAGE6
	Var Page6_Dialog
	Var Page6_MakeInstaller_Button
	Var Page6_CompileStatus_Label
	Var Page6_LogFile_Link
	Var Page6_GroupBox
	Var Page6_Open_Button
	Var Page6_Show_Button
	Var Page6_OpenLabel
	Var Page6_Backup_Button
	Var Page6_Backup_Label
	Var Page6_Zip_Button
	Var Page6_Zip_Label
	Var Page6_TagCheckbox
	Var Page6_TagFile
	Var Page6_TagFile_Button
	
	Var State_TagFile
	Var State_TagCheckbox
	!endif ;PAGE6
	
	Var pimpDir
	Var NextButton
	Var CancelButton
	Var BackButton
	Var Valid_PresetDir
	Var Valid_PresetFile
	Var Valid_AltPresetDir
	Var SubFolder
	Var AltSubFolder

;Includes
	!include "MUI2.nsh"
	!include "nsDialogs.nsh"
	!include "LogicLib.nsh"
	!include "WinVer.nsh"
	!include "StrFunc.nsh"
	#!include "StdUtils.nsh"
	!include "nsProcess.nsh"
	!include "WordFunc.nsh"
		!insertmacro "WordReplace"
	!include "FileFunc.nsh"
		!insertmacro "GetFileName"
		!insertmacro "GetParent"
		!insertmacro "GetFileExt"
		!insertmacro "GetSize"
		!insertmacro "GetParameters"
		!insertmacro "GetOptions"
		!if ${LOCATE_FUNCT} == 2
			!insertmacro "Locate"
		!endif
	!include "includes\Validate.nsh"
	!include "TextReplace.nsh"
	!include "includes\FileSearch.nsh"
	#!include "includes\SearchByteFile.nsh"
	#!include "includes\SearchInBinary.nsh"
	!include "includes\macros.nsh"
		
	!ifndef NSDIALOGS_createDroplistSorted_INCLUDED
		!define NSDIALOGS_createDroplistSorted_INCLUDED
		!verbose push
		!verbose 3
	 
		!include WinMessages.nsh
	 
		!define __NSD_DropListSorted_CLASS COMBOBOX
		!define __NSD_DropListSorted_STYLE ${DEFAULT_STYLES}|${WS_TABSTOP}|${WS_VSCROLL}|${WS_CLIPCHILDREN}|${CBS_AUTOHSCROLL}|${CBS_HASSTRINGS}|${CBS_DROPDOWNLIST}|${CBS_SORT}
		!define __NSD_DropListSorted_EXSTYLE ${WS_EX_WINDOWEDGE}|${WS_EX_CLIENTEDGE}
	 
		!insertmacro __NSD_DefineControl DropListSorted
	 
		!verbose pop
	!endif
	
;Pages
	!ifdef PAGE1
	Page custom Page1 Page1_Leave # temp? rename to Page1_LoadStatus?
	!endif ;PAGE1
	
	!ifdef PAGE2
	Page custom Page2 Page2_Leave
	!endif ;PAGE2
	
	!ifdef PAGE3
	Page custom Page3 Page3_Leave
	!endif ;PAGE3
	
	!ifdef PAGE4
	Page custom Page4 Page4_Leave
	!endif ;PAGE4
	
	!ifdef PAGE5
	Page custom Page5 Page5_Leave
	!endif ;PAGE5
	
	!ifdef PAGE6
	Page custom Page6 Page6_Leave
	!endif ;PAGE6
	
	!define MUI_CUSTOMFUNCTION_GUIINIT nxsInit
	!define MUI_CUSTOMFUNCTION_ABORT clearTemp
	
	#!insertmacro MUI_PAGE_INSTFILES

;Languages
LangString Settings ${LANG_ENGLISH} "Settings"
LangString Settings_SubCap ${LANG_ENGLISH} "Choose your Migration Settings below."
!insertmacro MUI_LANGUAGE "English"

;Sections
	Section
		Quit
		/*
		DetailPrint "### PAGE 2 ###"
		DetailPrint "Name=$State_Name"
		DetailPrint "Version=$State_Version"
		DetailPrint "Preset Directory=$State_PresetDir"
		DetailPrint "Include Subfolders=$State_Subfolders"
		${If} $BabelScript == "multi"
			DetailPrint "Alt Preset Directory=$State_AltPresetDir"
			DetailPrint "Alt Include Subfolders=$State_AltSubfolders"
		${EndIf}
		DetailPrint "Additional Files Directory=$State_AddFiles"
		DetailPrint "Additional Bitmaps=$State_AddBMP"
		DetailPrint "Additional JPEGs=$State_AddJPG"
		DetailPrint "Additional AVIs=$State_AddAVI"
		DetailPrint "Additional GVMs=$State_AddGVM"
		DetailPrint "Additional SVPs=$State_AddSVP"
		DetailPrint "Additional SVPs=$State_AddUVS"
		DetailPrint "Additional CFFs=$State_AddCFF"
		DetailPrint "Additional CLMs=$State_AddCLM"
		DetailPrint ""
		DetailPrint "### PAGE 3 ###"
		DetailPrint "Splash Bitmap=$State_SplashBitmap"
		DetailPrint "Splash Transparency=$State_Transparency"
		DetailPrint "Splash Time=$State_SplashTime"
		DetailPrint "SplashSound=$State_SplashSound"
		DetailPrint "Icon=$State_Icon"
		DetailPrint "Checks=$State_Checks"
		DetailPrint "Wizard Bitmap=$State_Wizard"
		DetailPrint ""
		DetailPrint "### PAGE 4 ###"
		DetailPrint "License File=$State_License"	
		DetailPrint "Creative Commons=$State_CreativeCommons"
		DetailPrint "Font Directory=$State_Fonts"
		DetailPrint "Website URL=$State_WebsiteURL"
		DetailPrint "Websit Name=$State_WebsiteName"
		DetailPrint "Include Settings=$State_Settings"
		DetailPrint "Multilingual Setup=$State_Multilingual"
		DetailPrint "AutoClose$State_AutoClose"
		DetailPrint ""
		DetailPrint "### PAGE 5 ###"
		DetailPrint "AddBorder=$State_AddBorder"
		DetailPrint "BufferBlend=$State_BufferBlend"
		DetailPrint "ChannelShift=$State_ChannelShift"
		DetailPrint "ColorMap=$State_ColorMap"
		DetailPrint "ColorReduction=$State_ColorReduction"
		DetailPrint "ConvolutionFilter=$State_ConvolutionFilter"
		DetailPrint "FramerateLimiter=$State_FramerateLimiter"
		DetailPrint "GlobalVarMan=$State_GlobalVarMan"
		DetailPrint "Multiplier=$State_Multiplier"
		DetailPrint "MultiFilter=$State_MultiFilter"
		DetailPrint "NegativeStrobe=$State_NegativeStrobe"
		DetailPrint "Normalise=$State_Normalise"
		DetailPrint "Picture2=$State_Picture2"
		DetailPrint "RGBFilter=$State_RGBFilter"
		DetailPrint "ScreenReverse=$State_ScreenReverse"
		DetailPrint "Texer=$State_Texer"
		DetailPrint "Texer2=$State_Texer2"
		DetailPrint "TransAutomation=$State_TransAuto"
		DetailPrint "Triangle=$State_Triangle"
		DetailPrint "VfxAVIPlayer=$State_VfxAVIPlayer"
		DetailPrint "VideoDelay=$State_VideoDelay"
		DetailPrint "Tuggummi's Texer Resources=$State_TexerTug"
		DetailPrint "Yathosho's Texer Resources=$State_TexerYat"
		DetailPrint "Yathosho's Texer Resources=$State_TexerMega"
		*/
	SectionEnd

;Functions
	Function nxsInit
		; plug-in requires this to be called in .onGUIInit
		; if you use it in the .onInit function.
		; If you leave it out the installer dialog will be minimized.

		!ifndef PUBLIC_SOURCE
			Aero::Apply ;causes infrequent crashes
			Call HeaderColor
		!endif
		
		ShowWindow $HWNDPARENT 2
	FunctionEnd

	Function .onInit
				
		#get default ini locations
		${If} ${FileExists} "$EXEDIR\settings.ini" #portable has priority
			StrCpy $settingsINI "$EXEDIR\settings.ini"
		${ElseIf} ${FileExists} "$APPDATA\PimpBot\settings.ini" #default
			StrCpy $settingsINI "$APPDATA\PimpBot\settings.ini"
		${ElseIf} ${FileExists} "$APPDATA\pimpbot.ini" #unlikelyness fallback
			StrCpy $settingsINI "$APPDATA\pimpbot.ini"
		${ElseIf} ${FileExists} "$EXEDIR\pimpbot.ini" #oldskool fallback
			StrCpy $settingsINI "$EXEDIR\pimpbot.ini"
		${EndIf}
		
		#requires multiuser windows
		ReadINIStr $0 "$settingsINI" "Settings" "RunOnWin9x"
		${IfNot} ${AtLeastWin2000}
		${AndIfNot} $0 == "1"
			MessageBox MB_YESNO|MB_ICONEXCLAMATION|MB_DEFBUTTON2 "${PB_NAME} runs best on Windows 2000 or later. Continue anyway?" IDYES +2
			Quit
			WriteINIStr "$settingsINI" "Settings" "RunOnWin9x" "1"
		${EndIf}
		
		#all aboard?
		Call ComponentsCheck
		
		${If} ${FileExists} "$EXEDIR\defaults.ini" #portable has priority
			StrCpy $defaultsINI "$EXEDIR\defaults.ini"
		${ElseIf} ${FileExists} "$APPDATA\PimpBot\defaults.ini" #default
			StrCpy $defaultsINI "$APPDATA\PimpBot\defaults.ini"
		${EndIf}
		
		ReadINIStr $pimpDir "$settingsINI" "Settings" "PimpDir"
		
		Push $pimpDir
		Call SwapConst
		Pop $pimpDir
		
		ReadINIStr $visDir "$settingsINI" "Settings" "AVSDir"
		
		#initialize temporary folder		
		#InitPluginsDir
		
		ReadINIStr $0 $settingsINI "Settings" "TempDir"
		${If} $0 != ""
		${AndIf} ${FileExists} "$0\*.*"
			GetTempFileName $tempFile		
			${GetBaseName} $tempFile $1
			StrCpy $MyTempDir "$0\$1"
			SetOutPath "$MyTempDir"
		${Else}
			InitPluginsDir
			StrCpy $MyTempDir $PLUGINSDIR
		${EndIf}
			
		#get parameters
		${GetParameters} $Parameter
		
		#help?
		${If} $Parameter == "/help"
		${OrIf} $Parameter == "/?"
		${OrIf} $Parameter == "-?"
			StrCpy $Switches "$Switches$\r$\n/help$\tshow this dialog"
			StrCpy $Switches "$Switches$\r$\n/defaults$\tedit your default settings"
			StrCpy $Switches "$Switches$\r$\n/flush$\treset all settings"
			StrCpy $Switches "$Switches$\r$\n/loaddir$\tload files from folder"
			StrCpy $Switches "$Switches$\r$\n/loadfile$\tload .pimp file"
			StrCpy $Switches "$Switches$\r$\n/loadui$\tuse custom UI file"
			StrCpy $Switches "$Switches$\r$\n/noexe$\tskips creation of installer"
			StrCpy $Switches "$Switches$\r$\n/noout$\tskips creation of installer and .pimp file"
			StrCpy $Switches "$Switches$\r$\n/nopimp$\tskips creation of .pimp file"
			StrCpy $Switches "$Switches$\r$\n/passive$\trun quietly, requires /loadfile"
			StrCpy $Switches "$Switches$\r$\n/portable$\tenables portable/single user mode"
			StrCpy $Switches "$Switches$\r$\n/outdir$\toverrides the default output directory"
			StrCpy $Switches "$Switches$\r$\n/outfile$\toverrides the default filename"
			StrCpy $Switches "$Switches$\r$\n/ziptag$\tzips installer and adds tag-file"
			StrCpy $Switches "$Switches$\r$\n$\r$\nbuilt with NSIS ${NSIS_VERSION}/${NSIS_MAX_STRLEN} [${__DATE__}]"
			!ifdef PUBLIC_SOURCE
				!if ${UNICODE} == 2
					MessageBox MB_OK|MB_ICONINFORMATION "${PB_NAME} v${PB_VERSION} (Unicode) Switches:$\r$\n$Switches"
				!else
					MessageBox MB_OK|MB_ICONINFORMATION "${PB_NAME} v${PB_VERSION} (ANSI) Switches:$\r$\n$Switches"
				!endif
			!else ;PUBLIC_SOURCE
				!if ${UNICODE} == 2
					MessageBox MB_OK|MB_USERICON "${PB_NAME} v${PB_VERSION} (Unicode) Switches:$\r$\n$Switches"
				!else
					MessageBox MB_OK|MB_USERICON "${PB_NAME} v${PB_VERSION} (ANSI) Switches:$\r$\n$Switches"
				!endif
			!endif ;PUBLIC_SOURCE
			Quit
		${ElseIf} $Parameter == "/defaults"
			${If} ${FileExists} "$APPDATA\PimpBot\defaults.ini"
				ExecShell open "$APPDATA\PimpBot\defaults.ini"
			${ElseIf} ${FileExists} "$APPDATA\PimpBot\defaults.dummy.ini"				
				Rename "$APPDATA\PimpBot\defaults.dummy.ini" "$APPDATA\PimpBot\defaults.ini"
				ExecShell open "$APPDATA\PimpBot\defaults.ini"
			${Else}
				SetOutPath "$APPDATA\PimpBot"
				File /oname=defaults.ini "defaults.dummy.ini"
				ExecShell open "$APPDATA\PimpBot\defaults.ini"
			${EndIf}
			Quit
		#${ElseIf} $Parameter == "/nopimp" #make no .pimp file
		#${OrIf} $Parameter == "/noexe" #no installer? how bizarre!
		#	Goto function_End
		${ElseIf} $Parameter == "/flush"
			WriteINIStr "$settingsINI" "Settings" "OutputFile" "%%TITLE%%"
			WriteINIStr "$settingsINI" "Settings" "OutputDir" "%%DESKTOP%%"
			WriteINIStr "$settingsINI" "Settings" "Passphrase" ""
			WriteINIStr "$settingsINI" "Settings" "LastPack" ""
			WriteINIStr "$settingsINI" "Settings" "Tag" ""
			WriteINIStr "$settingsINI" "Settings" "Update" "1"
			WriteINIStr "$settingsINI" "Settings" "Cheats" "1"
			WriteINIStr "$settingsINI" "Settings" "TempDir" ""
			Delete "$APPDATA\PimpBot\defaults.ini"
			MessageBox MB_OK|MB_ICONINFORMATION "All default settings have been reset."
			Quit
		${ElseIf} $Parameter == "/portable"
			Goto do_portable
		${EndIf}

		#remote control
		${GetOptions} $Parameter "@script=" $State_PresetType #required
		
		${If} $State_PresetType == "avs"
		${OrIf} $State_PresetType == "milk"
		${OrIf} $State_PresetType == "sps"
		${OrIf} $State_PresetType == "dll"
			StrCpy $Caption "@script=$State_PresetType"
			
			${GetOptions} $Parameter "@ui=" $State_UI
			
			#Page2
			${GetOptions} $Parameter "@title=" $State_Name
			${If} $State_Name == ""
				${GetOptions} $Parameter "@name=" $State_Name #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@version=" $State_Version
			${If} $State_PresetType != "dll"
				${GetOptions} $Parameter "@presets=" $State_PresetDir
				IfFileExists "$EXEDIR\$State_PresetDir" 0 +2
				StrCpy $State_PresetDir "$EXEDIR\$State_PresetDir"
				
				${GetOptions} $Parameter "@presets_sub=" $State_Subfolders
				
				${GetOptions} $Parameter "@alt_presets=" $State_AltPresetDir
				IfFileExists "$EXEDIR\$State_AltPresetDir" 0 +2
				StrCpy $State_AltPresetDir "$EXEDIR\$State_AltPresetDir"
				
				${If} ${FileExists} "$State_AltPresetDir\*.*"
				${AndIf} $State_AltPresetDir != ""
					StrCpy $BabelScript "multi"
				${EndIf}
				
				${GetOptions} $Parameter "@alt_presets_sub=" $State_AltSubfolders
			${Else}
				${GetOptions} $Parameter "@plugin=" $State_PresetFile
				IfFileExists "$EXEDIR\$State_PresetFile" 0 +2
				StrCpy $State_PresetFile "$EXEDIR\$State_PresetFile"
			${EndIf}
			
			${GetOptions} $Parameter "@resources=" $State_AddFiles
			IfFileExists "$EXEDIR\$State_AddFiles" 0 +2
			StrCpy $State_AddFiles "$EXEDIR\$State_AddFiles"
			${If} $State_PresetType != "dll"
				${GetOptions} $Parameter "@bmp=" $State_AddBMP
				${GetOptions} $Parameter "@jpg=" $State_AddJPG
				${GetOptions} $Parameter "@avi=" $State_AddAVI
				${GetOptions} $Parameter "@gvm=" $State_AddGVM
				${GetOptions} $Parameter "@svp=" $State_AddSVP
				${GetOptions} $Parameter "@uvs=" $State_AddUVS
				${GetOptions} $Parameter "@cff=" $State_AddCFF
				${GetOptions} $Parameter "@clm=" $State_AddCLM
			${EndIf}
			
			#Page3
			${GetOptions} $Parameter "@splash_screen=" $State_SplashBitmap
			${If} $State_SplashBitmap == ""
				${GetOptions} $Parameter "@splash=" $State_SplashBitmap #tolerance
			${EndIf}
			IfFileExists "$EXEDIR\$State_SplashBitmap" 0 +2
			StrCpy $State_SplashBitmap "$EXEDIR\$State_SplashBitmap"
			
			
			${GetOptions} $Parameter "@splash_alpha=" $State_Transparency
			${If} $State_Transparency == ""
				${GetOptions} $Parameter "@splash_transparency=" $State_Transparency #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@splash_sound=" $State_SplashSound
			IfFileExists "$EXEDIR\$State_SplashSound" 0 +2
			StrCpy $State_SplashSound "$EXEDIR\$State_SplashSound"
			
			${GetOptions} $Parameter "@splash_time=" $State_SplashTime
			
			${GetOptions} $Parameter "@icon=" $State_Icon
			IfFileExists "$EXEDIR\$State_Icon" 0 +2
			StrCpy $State_Icon "$EXEDIR\$State_Icon"
			
			${GetOptions} $Parameter "@checks=" $State_Checks
			${If} $State_Checks == ""
				${GetOptions} $Parameter "@checkboxes=" $State_Checks #tolerance
			${EndIf}
			IfFileExists "$EXEDIR\$State_Checks" 0 +2
			StrCpy $State_Checks "$EXEDIR\$State_Checks"
			
			${GetOptions} $Parameter "@wizard=" $State_Wizard
			IfFileExists "$EXEDIR\$State_Wizard" 0 +2
			StrCpy $State_Wizard "$EXEDIR\$State_Wizard"			
		
			#inject skin
			${GetOptions} $Parameter "@skin=" $0
			${If} $0 == ""
				${GetOptions} $Parameter "@waskin=" $0 #tolerance
			${EndIf}
			IfFileExists "$EXEDIR\$State_Wizard" 0 +2
			StrCpy $State_Wizard "$EXEDIR\$State_Wizard"
			
			${If} $0 != ""
			${AndIf} ${FileExists} "$0"
				${GetBaseName} $0 $1
				StrCpy $injectSkin "$0"
				StrCpy $injectSkinName "$1"
			${EndIf}
			
			#Page4
			${GetOptions} $Parameter "@license=" $State_License
			IfFileExists "$EXEDIR\$State_License" 0 +2
			StrCpy $State_License "$EXEDIR\$State_License"
			
			${GetOptions} $Parameter "@cc="$State_CreativeCommons
			${If} $State_CreativeCommons == ""
				${GetOptions} $Parameter "@license_cc=" $State_CreativeCommons #tolerance
			${EndIf}
			IfFileExists "$EXEDIR\$State_CreativeCommons" 0 +2
			StrCpy $State_CreativeCommons "$EXEDIR\$State_CreativeCommons"
			
			${If} $State_CreativeCommons == "by"
			${OrIf} $State_CreativeCommons == "by-sa"
			${OrIf} $State_CreativeCommons == "by-nd"
			${OrIf} $State_CreativeCommons == "by-nc"
			${OrIf} $State_CreativeCommons == "by-nc-sa"
			${OrIf} $State_CreativeCommons == "by-nc-nd"
				StrCpy $State_CreativeCommons "cc $State_CreativeCommons"
			${EndIf}			
			
			${GetOptions} $Parameter "@fonts=" $State_Fonts
			IfFileExists "$EXEDIR\$State_Fonts\*.*" 0 +2
			StrCpy $State_Fonts "$EXEDIR\$State_Fonts"
			
			${GetOptions} $Parameter "@web_url=" $State_WebsiteURL
			${GetOptions} $Parameter "@web_name=" $State_WebsiteName
			${GetOptions} $Parameter "@multilingual=" $State_Multilingual
			${GetOptions} $Parameter "@components=" $State_Components
			${If} $State_Components == ""
				${GetOptions} $Parameter "@components_page=" $State_Components #tolerance
			${EndIf}
			${GetOptions} $Parameter "@settings=" $State_Settings
			${If} $State_Settings == ""
				${GetOptions} $Parameter "@settings_page=" $State_Settings #tolerance
			${EndIf}
			${GetOptions} $Parameter "@autoclose=" $State_AutoClose
			
			#APEs
			${GetOptions} $Parameter "@addborder=" $State_AddBorder
			${If} $State_AddBorder == ""
				${GetOptions} $Parameter "@add_border=" $State_AddBorder #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@buffer=" $State_BufferBlend
			${If} $State_BufferBlend == ""
				${GetOptions} $Parameter "@buffer_blend=" $State_BufferBlend #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@channelshift=" $State_ChannelShift
			${If} $State_ChannelShift == ""
				${GetOptions} $Parameter "@channel_shift=" $State_ChannelShift #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@colormap=" $State_ColorMap
			${If} $State_ColorMap == ""
				${GetOptions} $Parameter "@color_map=" $State_ColorMap #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@colorreduction=" $State_ColorReduction
			${If} $State_ColorReduction == ""
				${GetOptions} $Parameter "@color_reduction=" $State_ColorReduction #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@convolution=" $State_ConvolutionFilter
			${If} $State_ConvolutionFilter == ""
				${GetOptions} $Parameter "@convolution_filter=" $State_ConvolutionFilter #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@frameratelimiter=" $State_FramerateLimiter
			${If} $State_FramerateLimiter == ""
				${GetOptions} $Parameter "@framerate_limiter=" $State_FramerateLimiter #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@globmgr=" $State_GlobalVarMan
			${If} $State_GlobalVarMan == ""
				${GetOptions} $Parameter "@global_var_manager=" $State_GlobalVarMan #tolerance
			${EndIf}
			${If} $State_GlobalVarMan == ""
				${GetOptions} $Parameter "@global_variables_manager=" $State_GlobalVarMan #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@multifilter=" $State_MultiFilter
			${If} $State_MultiFilter == ""
				${GetOptions} $Parameter "@multi_filter=" $State_MultiFilter #tolerance
			${EndIf}			
			
			${GetOptions} $Parameter "@multiplier=" $State_Multiplier
			
			${GetOptions} $Parameter "@negativestrobe=" $State_NegativeStrobe
			${If} $State_NegativeStrobe == ""
				${GetOptions} $Parameter "@negative_strobe=" $State_NegativeStrobe #tolerance
			${EndIf}	
			
			${GetOptions} $Parameter "@normalise=" $State_Normalise
			
			${GetOptions} $Parameter "@picture2=" $State_Picture2
			${If} $State_Picture2 == ""
				${GetOptions} $Parameter "@picture_ii=" $State_Picture2 #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@rgbfilter=" $State_RGBFilter
			${If} $State_RGBFilter == ""
				${GetOptions} $Parameter "@rgb_filter=" $State_RGBFilter #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@screenreverse=" $State_ScreenReverse
			${If} $State_ScreenReverse == ""
				${GetOptions} $Parameter "@screen_reverse=" $State_ScreenReverse #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@texer=" $State_Texer
			
			${GetOptions} $Parameter "@texer2=" $State_Texer2
			${If} $State_Texer2 == ""
				${GetOptions} $Parameter "@texer_2=" $State_Texer2 #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@eeltrans=" $State_TransAuto
			${If} $State_TransAuto == ""
				${GetOptions} $Parameter "@trans_automation=" $State_TransAuto #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@triangle=" $State_Triangle
			
			${GetOptions} $Parameter "@vfxaviplayer=" $State_VfxAVIPlayer
			${If} $State_VfxAVIPlayer == ""
				${GetOptions} $Parameter "@vfx_avi_player=" $State_VfxAVIPlayer #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@delay=" $State_VideoDelay
			${If} $State_VideoDelay == ""
				${GetOptions} $Parameter "@videodelay=" $State_VideoDelay #tolerance
			${EndIf}
			${If} $State_VideoDelay == ""
				${GetOptions} $Parameter "@video_delay=" $State_VideoDelay #tolerance
			${EndIf}
			
			
			#Texer Packs
			${GetOptions} $Parameter "@tx_tuggummi=" $State_TexerTug
			${If} $State_TexerTug == ""
				${GetOptions} $Parameter "@texer_tuggummi=" $State_TexerTug #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@tx_yathosho=" $State_TexerYat
			${If} $State_TexerYat == ""
				${GetOptions} $Parameter "@texer_yathosho=" $State_TexerYat #tolerance
			${EndIf}
			
			${GetOptions} $Parameter "@tx_mega=" $State_TexerMega
			${If} $State_TexerMega == ""
				${GetOptions} $Parameter "@texer_mega=" $State_TexerMega #tolerance
			${EndIf}
			Goto function_End
		${EndIf}
		
		#NUI temp
		/*
		${GetOptions} $Parameter "/nui=" $0
		${If} $0 == 1
			StrCpy $noMUI 1
			StrCpy $customUI "$NSIS\Contrib\UIs\nui.exe"
			StrCpy $FileDetails 1
		${EndIf}
		*/
		
		#Portable
		${GetOptions} $Parameter "/portable=" $0
		${If} $0 == ""
			${GetOptions} $Parameter "-pt=" $0
		${EndIf}
		
		${If} $0 == 1 #portable
			do_portable:
			${If} ${FileExists} "$APPDATA\PimpBot\settings.ini"
				CopyFiles /SILENT "$APPDATA\PimpBot\settings.ini" $EXEDIR
				IfFileExists "$APPDATA\PimpBot\defaults.ini" 0 +2
				CopyFiles /SILENT "$APPDATA\PimpBot\defaults.ini" $EXEDIR
			${ElseIfNot} ${FileExists} "$EXEDIR\settings.ini"
				WriteINIStr "$EXEDIR\settings.ini" "PimpBot" "Version" "${PB_VERSION}"
			${EndIf}
			IfSilent +2
			MessageBox MB_OK|MB_ICONINFORMATION "${PB_NAME} has been set up for portable mode, please restart the application."
			Quit
		${ElseIf} $0 == 0 #default setting
			${If} ${FileExists} "$EXEDIR\settings.ini"
				CopyFiles /SILENT "$EXEDIR\settings.ini" "$APPDATA\PimpBot"
				IfFileExists "$EXEDIR\defaults.ini" 0 +2
				CopyFiles /SILENT "$EXEDIR\defaults.ini" "$APPDATA\PimpBot"
				Delete "$EXEDIR\settings.ini"
			${ElseIfNot} ${FileExists} "$APPDATA\PimpBot\settings.ini"
				WriteINIStr "$APPDATA\PimpBot\settings.ini" "PimpBot" "Version" "${PB_VERSION}"
			${EndIf}
			IfSilent +2
			MessageBox MB_OK|MB_ICONINFORMATION "${PB_NAME} has been set up for normal mode, please restart the application."
			Quit
		${EndIf}
		
		#BabelScript
		${GetOptions} $Parameter "/babel=" $0
		${If} $0 == "s"
			StrCpy $BabelScript "single"
		${ElseIf} $0 == "m"
			StrCpy $BabelScript "multi"
		${EndIf}
		
		#detect APEs
		${GetOptions} $Parameter "/scanape=" $0		
		${If} $0 == ""
			${GetOptions} $Parameter "-sa=" $0
		${EndIf}
		
		${If} $0 == 1
			StrCpy $autoAPE "1"
		${EndIf}
		
		#detect Resource files
		${GetOptions} $Parameter "/scanres=" $0		
		${If} $0 == ""
			${GetOptions} $Parameter "-sr=" $0
		${EndIf}
		
		${If} $0 == 1
		${AndIf} ${FileExists} "$visDir\*.*"
		${AndIf} $visDir != ""
			StrCpy $autoRes "1"
		${EndIf}
		
		#inject Winamp skin
		${GetOptions} $Parameter "/waskin=" $0		
		${If} $0 == ""
			${GetOptions} $Parameter "-ws=" $0
		${EndIf}
		
		${GetBaseName} $0 $1
		
		${If} $0 != ""
		${AndIf} ${FileExists} "$0"
			StrCpy $injectSkin "$0"
			StrCpy $injectSkinName "$1"
		${ElseIf} $0 != ""
		${AndIf} ${FileExists} "$EXEDIR\$0"
			StrCpy $injectSkin "$EXEDIR\$0"
			StrCpy $injectSkinName "$1"
		${ElseIf} $0 != ""
		${AndIf} ${FileExists} "$0.wsz"
			StrCpy $injectSkin "$0.wsz"
			StrCpy $injectSkinName "$1"
		${ElseIf} $0 != ""
		${AndIf} ${FileExists} "$EXEDIR\$0.wsz"
			StrCpy $injectSkin "$EXEDIR\$0.wsz"
			StrCpy $injectSkinName "$1"
		${EndIf}

		#create a avs resource pack (no avs presets required)
		${GetOptions} $Parameter "/noavs=" $0		
		${If} $0 == ""
			${GetOptions} $Parameter "-na" $0
		${EndIf}
		
		${If} $0  == 1
			StrCpy $noAVS "1"
		${ElseIf} $0  == 2
			StrCpy $noAVS "2"
		${EndIf}
		
		#skip creation of .exe
		${GetOptions} $Parameter "/noexe=" $0		
		${If} $0 == ""
			${GetOptions} $Parameter "-nx=" $0
		${EndIf}
		
		${If} $0  == 1
			StrCpy $noExe "1"
		${EndIf}
			
		#skip creation of .pimp
		${GetOptions} $Parameter "/nopimp=" $0		
		${If} $0 == ""
			${GetOptions} $Parameter "-np=" $0
		${EndIf}
		
		${If} $0 == 1
			StrCpy $noPimp "1"
		${EndIf}
		
		#conflict?
		${If} $noExe == "1"
		${AndIf} $noPimp == "1"
			Goto invalid_Input
		${EndIf}
		
		#no output
		${GetOptions} $Parameter "/noout=" $0		
		${If} $0 == ""
			${GetOptions} $Parameter "-no=" $0
		${EndIf}
		
		${If} $0  == 1
			StrCpy $noOutput "1"
		${EndIf}
			
		#enable/disable Modern UI (enabled by default)
		${GetOptions} $Parameter "/nomui=" $0	
		${If} $0 == ""
			${GetOptions} $Parameter "-nm=" $0
		${EndIf}
		
		${If} $0  == 1
			StrCpy $noMUI "1"
		${Else}
			StrCpy $noMUI "0"
		${EndIf}
		
		#custom script
		${GetOptions} $Parameter "/script=" $0	
		${If} $0 == ""
			${GetOptions} $Parameter "-ls=" $0
		${EndIf}
		
		${If} $0  != ""
		${AndIf} ${FileExists} "$0"
			StrCpy $customNSI $0
		${ElseIf} $0  != ""
		${AndIf} ${FileExists} "$EXEDIR\$0"
			StrCpy $customNSI "$EXEDIR\$0"
		${ElseIf} $0  != ""
		${AndIf} ${FileExists} "$EXEDIR\$0.nsi"
			StrCpy $customNSI "$EXEDIR\$0.nsi"
		${EndIf}
		
		#load UI
		${GetOptions} $Parameter "/loadui=" $0	
		${If} $0 == ""
			${GetOptions} $Parameter "-ui=" $0
		${EndIf}
		
		${If} $0  != ""
			${GetFileName} $0 $1
			
			${If} ${FileExists} "$EXEDIR\$1"
			${OrIf} ${FileExists} "$NSIS\Contrib\UIs\$1"
			${OrIf} ${FileExists} "$EXEDIR\$1.exe"
			${OrIf} ${FileExists} "$NSIS\Contrib\UIs\$1.exe"
			${OrIf} ${FileExists} "$0"
				
				; is MUI?				
				StrCpy $2 $1 6
				
				${If} $2 == "modern"
					StrCpy $noMUI "0"

					assignUI:
					${If} ${FileExists} "$NSIS\Contrib\UIs\$1"
						StrCpy $customUI "$NSIS\Contrib\UIs\$1"
					${ElseIf} ${FileExists} "$EXEDIR\$1"
						StrCpy $customUI "$EXEDIR\$1"
					${ElseIf} ${FileExists} "$NSIS\Contrib\UIs\$1.exe"
						StrCpy $customUI "$NSIS\Contrib\UIs\$1.exe"
					${ElseIf} ${FileExists} "$EXEDIR\$1.exe"
						StrCpy $customUI "$EXEDIR\$1.exe"
					${ElseIf} ${FileExists} "$0"
						StrCpy $customUI "$0"
					${EndIf}
				${Else}
					StrCpy $noMUI "1"
					Goto assignUI
				${EndIf}
			${EndIf}			
		${EndIf}
		
		#override output directory
		${GetOptions} $Parameter "/outdir=" $0		
		${If} $0 == ""
			${GetOptions} $Parameter "-od=" $0
		${EndIf}
		
		${If} $0 != ""
		${AndIf} ${FileExists} "$0\*.*"
			set_OutDir:
			StrCpy $OutputDir "$0"
		${ElseIf} ${FileExists} "$0"
			${GetParent} $0 $0
			Goto set_OutDir
		${EndIf}
		
		#override output file
		${GetOptions} $Parameter "/outfile=" $0
		${If} $0 == ""
			${GetOptions} $Parameter "-of=" $0
		${EndIf}
		
		${If} $0 != ""
			StrCpy $OutputFile "$0"
			StrCpy $OutputFileParam 1
		${EndIf}
		
		#detailed file list in installer
		${GetOptions} $Parameter "/filelist=" $0
		${If} $0 == ""
			${GetOptions} $Parameter "-fl=" $0
		${EndIf}
		${If} $0 == "0"
			StrCpy $FileDetails 0
		${Else}
			StrCpy $FileDetails 1
		${EndIf}
		
		#disable APEs coming with winamp5
		${GetOptions} $Parameter "/nolegacy=" $0
		${If} $0 == ""
			${GetOptions} $Parameter "-nl=" $0
		${EndIf}
		${If} $0 == "1"
			StrCpy $Legacy 0
		${EndIf}
		
		#set debug level (1=edit script, 2=show all states)
		${GetOptions} $Parameter "/debug=" $0
		${If} $0 == ""
			${GetOptions} $Parameter "-db=" $0
		${EndIf}
		
		${If} $0 == "1"
			StrCpy $DebugLevel 1
		${ElseIf} $0 == "2"
			StrCpy $DebugLevel 2
		${EndIf}
		
		#passive mode
		${GetOptions} $Parameter "/passive=" $0		
		${If} $0 == ""
			${GetOptions} $Parameter "-pv=" $0
		${EndIf}
		
		${If} $0 == "1"
			StrCpy $Passive 1
		${EndIf}
		
		#load dropfolder (useful when requiring multiple switches)
		${GetOptions} $Parameter "/loaddir=" $0
		${If} $0 == ""
			${GetOptions} $Parameter "-ld=" $0
		${EndIf}
		
		${If} $0 != ""
		${AndIf} ${FileExists} "$0\*.*"
			StrCpy $Input $0
			Call DropFolder
			Goto function_End
		${ElseIf} $0 != ""
		${AndIf} ${FileExists} "$EXEDIR\$0\*.*"
			StrCpy $Input "$EXEDIR\$0"
			Call DropFolder
			Goto function_End
		${EndIf}
		
		#load .pimp file (useful when requiring multiple switches)
		${GetOptions} $Parameter "/loadfile=" $0
		${If} $0 == ""
			${GetOptions} $Parameter "-lf=" $0
		${EndIf}		
		
		${If} $0 != ""
		${AndIf} ${FileExists} "$0"
		${AndIfNot} ${FileExists} "$0\*.*" #it helps, but i'm not sure why :)
			StrCpy $Input $0
			Goto file_Input
		${ElseIf} $0 != ""
		${AndIf} ${FileExists} "$EXEDIR\$0"
		${AndIfNot} ${FileExists} "$EXEDIR\$0\*.*" #it helps, but i'm not sure why :)
			StrCpy $Input "$EXEDIR\$0"
			Goto file_Input	
		${ElseIf} $0 != ""
		${AndIf} ${FileExists} "$pimpDir\$0"
			StrCpy $Input "$pimpDir\$0"
			Goto file_Input	
		${ElseIf} $0 != ""
		${AndIf} ${FileExists} "$0.pimp"
			StrCpy $Input "$0.pimp"
			Goto file_Input
		${ElseIf} $0 != ""
		${AndIf} ${FileExists} "$EXEDIR\$0.pimp"
			StrCpy $Input "$EXEDIR\$0.pimp"
			Goto file_Input	
		${ElseIf} $0 != ""
		${AndIf} ${FileExists} "$pimpDir\$0.pimp"
			StrCpy $Input "$pimpDir\$0.pimp"
			Goto file_Input	
		${ElseIf} $0 != ""
			Goto invalid_Input
		${EndIf}
		
		#force zip+tag feature (useful when using multitool)
		${GetOptions} $Parameter "/ziptag=" $0		
		${If} $0 == ""
			${GetOptions} $Parameter "-zt=" $0
		${EndIf}
		
		${If} $0 != ""
		${AndIf} ${FileExists} $0
			StrCpy $State_TagCheckbox 1
			StrCpy $State_TagFile $0
			StrCpy $mkZip 1
		${ElseIf} $0 != ""
		${AndIf} ${FileExists} "$EXEDIR\$0"
			StrCpy $State_TagCheckbox 1
			StrCpy $State_TagFile "$EXEDIR\$0"
			StrCpy $mkZip 1
		${EndIf}
		
				
		#no params, maybe a file?
		${If} $Parameter != ""
			${WordReplace} $Parameter '"' "" "+" $Input
			
			${IfNot} ${FileExists} "$Input\*.*" #file-input
			${AndIf} ${FileExists} "$Input"
				file_Input:
				${GetFileExt} $Input $InputExt
				
				${If} $InputExt == "pimp"
				${OrIf} $InputExt == "7z"
					Call LoadPimp					
					Goto function_End
				${Else}
					Goto invalid_Input
				${EndIf}
			${ElseIf} ${FileExists} "$Input\*.*" #dir-input "dropfolder"
				
				${If} ${FileExists} "$Input\*.avs"
				${OrIf} ${FileExists} "$Input\*.milk"
				${OrIf} ${FileExists} "$Input\*.sps"
					Call FuzzyDrop
				${EndIf}
				
				Push $Input
				Call ConvertPimp #old folder-format?
								
				Call DropFolder
				Goto function_End
			${EndIf}			
				
			invalid_Input:		
			StrCmp $BabelScript "" 0 function_End
			StrCmp $autoAPE "" 0 function_End
			StrCmp $autoRes "" 0 function_End
			StrCmp $injectSkin "" 0 function_End
			StrCmp $noAvs "" 0 function_End
			StrCmp $noExe "" 0 function_End
			StrCmp $noOutput "" 0 function_End
			StrCmp $noPimp "" 0 function_End
			StrCmp $noMUI "" 0 function_End
			StrCmp $OutputDir "" 0 function_End
			StrCmp $OutputDir "" 0 function_End
			StrCmp $OutputFile "" 0 function_End
			StrCmp $FileDetails "" 0 function_End
			StrCmp $DebugLevel "" 0 function_End
			StrCmp $Passive "" 0 function_End
			StrCmp $mkZip "" 0 function_End
			MessageBox MB_OK|MB_ICONEXCLAMATION "Invalid input file/folder or parameter."
			Quit
		${EndIf}
		
		function_End:
	FunctionEnd
	
	!ifdef PAGE1
	Function Page1
		
		${If} $Caption != "" #temp
		${AndIf} $pimpGoBack != 1
			Abort
		${EndIf}
		
		!insertmacro MUI_HEADER_TEXT "The Crossroads" "Create a new installer or load an old project"
		
		nsDialogs::Create /NOUNLOAD 1018
		
		Pop $Page1_Dialog

		${If} $Page1_Dialog == error
			Abort
		${EndIf}
		
				GetDlgItem $NextButton $HWNDPARENT 1 ; next=1, cancel=2, back=3
		GetDlgItem $CancelButton $HWNDPARENT 2 ; next=1, cancel=2, back=3
		#GetDlgItem $BackButton $HWNDPARENT 3 ; next=1, cancel=2, back=3
				
		ReadINIStr $LastPack "$settingsINI" "Settings" "LastPack"
		#ReadINIStr $pimpDir "$settingsINI" "Settings" "PimpDir"
		
		#New Project
		${NSD_CreateButton} 8 0 120 30 "New &Project"
		Pop $Page1_NewProject_Button
		GetFunctionAddress $0 onClick_NewProject
		nsDialogs::OnClick /NOUNLOAD $Page1_NewProject_Button $0
		EnableWindow $Page1_NewProject_Button 1
		
		#Load Project
		${NSD_CreateButton} 130 0 120 30 "&Load Project"
		Pop $Page1_LoadProject_Button
		GetFunctionAddress $0 onClick_LoadProject
		nsDialogs::OnClick /NOUNLOAD $Page1_LoadProject_Button $0
		
		${If} ${FileExists} "$pimpDir\*.pimp"
		${AndIf} $7zip != ""
			EnableWindow $Page1_LoadProject_Button 1
		${Else}
			EnableWindow $Page1_LoadProject_Button 0
		${EndIf}
		
		!ifndef PUBLIC_SOURCE
			#Online?
			System::Call 'wininet.dll::InternetGetConnectedState(*i .r0, i 0) i.r1'

			#Update
			ReadINIStr $0 "$settingsINI" "Settings" "Update"
			
			${If} $DebugLevel >= 2
				MessageBox MB_OK|MB_ICONINFORMATION "Internet Connection=$1$\nUpdate Check=$0"
			${EndIf}
			
			${If} $0 == 1
			${AndIf} $1 != 0
				${NSD_CreateLink} 360 8 120 15 "&Update available"
				Pop $Page1_Update_Link
				${NSD_OnClick} $Page1_Update_Link onClick_Update
				ShowWindow $Page1_Update_Link 0
				
				${If} $State_UpdateCheck != 1
					nxs::Show /NOUNLOAD "${PB_NAME}" /top "Looking for available updates" /sub "" /h 0 /marquee 20 /end
					
					#InetLoad::load /TIMEOUT 5000 "http://pimpbot.whyeye.org/.latest" "$PLUGINSDIR\update.ini"
					!if ${UNICODE} == 2
						inetc::get /CONNECTTIMEOUT ${TIMEOUT} /SILENT "http://pimpbot.whyeye.org/.latest-unicode" "$PLUGINSDIR\update.ini" /END
					!else
						inetc::get /CONNECTTIMEOUT ${TIMEOUT} /SILENT "http://pimpbot.whyeye.org/.latest" "$PLUGINSDIR\update.ini" /END
					!endif
					Pop $0
					
					nxs::Destroy
					StrCpy $State_UpdateCheck 1
				${EndIf}
				
				${If} $0 == "OK"
					ReadINIStr $State_LatestVersion "$PLUGINSDIR\update.ini" "Update" "Version"
					ReadINIStr $State_LatestURL "$PLUGINSDIR\update.ini" "Update" "URL"
					ReadINIStr $State_LatestAltURL "$PLUGINSDIR\update.ini" "Update" "AltURL"
									
					${VersionCompare} "$State_LatestVersion" "${PB_VERSION}" $0 #$var=0  Versions are equal, $var=1  Version1 is newer
					
					${If} $DebugLevel >= 2
						MessageBox MB_OK|MB_ICONINFORMATION "Current Version=${PB_VERSION}$\nLatest Version=$State_LatestVersion"
					${EndIf}
					
					${If} $0 == 1
						${If} $State_LatestURL != ""
						${AndIf} $State_LatestAltURL != ""
							ShowWindow $Page1_Update_Link 1
						${EndIf}
					${EndIf}
				${EndIf}			
			${EndIf}
		!endif ;PUBLIC_SOURCE
		
		#Start-up Text
		${NSD_CreateLabel} 8 105 420 30 "Please specify whether you want to start a new project or load an existing one. The load-button might remain inactive if you haven't used ${PB_NAME} before."
		Pop $Page1_StartLabel
		EnableWindow $Page1_StartLabel 0
		
		${If} $State_Project == "load"
			Call onClick_LoadProject
			ShowWindow $Page1_StartLabel 0
		${ElseIf} $State_Project == "new"
			Call NewProject
			ShowWindow $Page1_StartLabel 0
		${EndIf}
				
		#Groupbox
		${NSD_CreateGroupBox} 0 40 100% 180 ""
		Pop $Page1_GroupBox		
		
		#Droplist
		${NSD_CreateDroplistSorted} 8 67 365 25 0 #0 80 350 18 0
		Pop $Page1_PimpList
		
		${If} $LastPack != ""
		${AndIf} ${FileExists} "$pimpDir\$LastPack"
			SendMessage $Page1_PimpList ${CB_ADDSTRING} 0 "STR:(last pack - $LastPack)"
			SendMessage $Page1_PimpList ${CB_FINDSTRINGEXACT} -1 "STR:(last pack - $LastPack)" $0
			SendMessage $Page1_PimpList ${CB_SETCURSEL} $0 ""	
		${EndIf}
							
		${Locate} "$pimpDir" "/L=F /M=*.pimp /G=0" "scan_PimpDir"
		
		GetFunctionAddress $0 onChange_PimpList
		nsDialogs::OnChange /NOUNLOAD $Page1_PimpList $0
		
		${If} $State_PimpList != ""
			SendMessage $Page1_PimpList ${CB_FINDSTRINGEXACT} -1 "STR:$State_PimpList" $0
			SendMessage $Page1_PimpList ${CB_SETCURSEL} $0 ""
			EnableWindow $NextButton 1
		${ElseIf} $State_PimpList == ""
		${AndIf} $State_Project == "load"
			EnableWindow $NextButton 0
		${EndIf}
		
		/*
		#PIMP Browse
		${NSD_CreateButton} 420 67 25 20 "..."
		Pop $Page1_PimpLoad
		GetFunctionAddress $0 PimpFile_Browse
		nsDialogs::OnClick /NOUNLOAD $Page1_PimpLoad $0
		*/
		
		#Label Type NEW
		${NSD_CreateLabel} 8 67 300 15 "Please choose an install script"
		Pop $Page1_TypeLabelNew
		
		#Type Droplist NEW
		${NSD_CreateDroplistSorted} 8 89 145 25 0 #0 110 350 18 0
		Pop $Page1_TypeListNew
		SendMessage $Page1_TypeListNew ${CB_ADDSTRING} 0 "STR:AVS Installer"
		SendMessage $Page1_TypeListNew ${CB_ADDSTRING} 0 "STR:MilkDrop Installer"
		SendMessage $Page1_TypeListNew ${CB_ADDSTRING} 0 "STR:SPS Installer"
		SendMessage $Page1_TypeListNew ${CB_ADDSTRING} 0 "STR:Winamp Plugin Installer"
		
		${If} $State_TypeListNew != ""
			SendMessage $Page1_TypeListNew ${CB_FINDSTRINGEXACT} -1 "STR:$State_TypeListNew" $0
		${Else}
			SendMessage $Page1_TypeListNew ${CB_FINDSTRINGEXACT} -1 "STR:AVS Installer" $0 #default
		${EndIf}
		SendMessage $Page1_TypeListNew ${CB_SETCURSEL} $0 ""
		
		${If} $customUI == ""
			#Label UI NEW
			${NSD_CreateLabel} 8 122 300 15 "Please choose an user interface"
			Pop $Page1_UILabelNew
			
			#UI Droplist NEW
			${NSD_CreateDroplist} 8 144 145 25 0 #0 110 350 18 0
			Pop $Page1_UIListNew
			SendMessage $Page1_UIListNew ${CB_ADDSTRING} 0 "STR:Modern UI (default)"
			SendMessage $Page1_UIListNew ${CB_ADDSTRING} 0 "STR:Basic UI"
			IfFileExists "$NSIS\Contrib\UIs\nui.exe" 0 +2
			SendMessage $Page1_UIListNew ${CB_ADDSTRING} 0 "STR:Artwork UI"
			
			${If} $State_UIListNew != ""
				SendMessage $Page1_UIListNew ${CB_FINDSTRINGEXACT} -1 "STR:$State_UIListNew" $0
			${Else}
				SendMessage $Page1_UIListNew ${CB_FINDSTRINGEXACT} -1 "STR:Modern UI (default)" $0 #default
			${EndIf}
			SendMessage $Page1_UIListNew ${CB_SETCURSEL} $0 ""
		${EndIf}
		
		#Load Defaults
		${NSD_CreateCheckbox} 8 180 85 15 "Use &Defaults"
		Pop $Page1_Defaults
		ToolTips::Classic $Page1_Defaults "Load your previously defined default values"
		
		${If} ${FileExists} "$defaultsINI"
			EnableWindow $Page1_Defaults 1
		${Else}
			EnableWindow $Page1_Defaults 0
		${EndIf}
						
		#Label LOAD
		${NSD_CreateLabel} 8 105 300 15 "Change the installer script in use"
		Pop $Page1_TypeLabelLoad
		
		#Checkbox PresetType
		${NSD_CreateCheckbox} 8 120 15 25 ""
		Pop $Page1_TypeEnable
		ToolTips::Classic $Page1_TypeEnable "Lets you override the used install script"
		GetFunctionAddress $0 onClick_TypeEnable
		nsDialogs::OnClick /NOUNLOAD $Page1_TypeEnable $0
		
		#Type Droplist LOAD
		${NSD_CreateDroplistSorted} 30 122 135 25 0 #0 110 350 18 0
		Pop $Page1_TypeListLoad
		SendMessage $Page1_TypeListLoad ${CB_ADDSTRING} 0 "STR:AVS Installer"
		SendMessage $Page1_TypeListLoad ${CB_ADDSTRING} 0 "STR:MilkDrop Installer"
		SendMessage $Page1_TypeListLoad ${CB_ADDSTRING} 0 "STR:SPS Installer"
		SendMessage $Page1_TypeListLoad ${CB_ADDSTRING} 0 "STR:Winamp Plugin Installer"
		
		${If} $State_TypeListLoad != ""
			SendMessage $Page1_TypeListLoad ${CB_FINDSTRINGEXACT} -1 "STR:$State_TypeListLoad" $0
			SendMessage $Page1_TypeListLoad ${CB_SETCURSEL} $0 ""
		${Else}
			Call onChange_PimpList
			#SendMessage $Page1_TypeListLoad ${CB_FINDSTRINGEXACT} -1 "STR:AVS Installer" $0
		${EndIf}
		
		${If} $customUI == ""
			#Label UI LOAD
			${NSD_CreateLabel} 8 160 300 15 "Change user interface in use"
			Pop $Page1_UILabelLoad
			
			#Checkbox UI
			${NSD_CreateCheckbox} 8 175 15 25 ""
			Pop $Page1_UIEnable
			ToolTips::Classic $Page1_UIEnable "Lets you override the used interface"
			GetFunctionAddress $0 onClick_UIEnable
			nsDialogs::OnClick /NOUNLOAD $Page1_UIEnable $0
			
			#Drolist UI LOAD
			${NSD_CreateDroplist} 30 177 135 25 0 #0 110 350 18 0
			Pop $Page1_UIListLoad
			SendMessage $Page1_UIListLoad ${CB_ADDSTRING} 0 "STR:Modern UI (default)" #default
			SendMessage $Page1_UIListLoad ${CB_ADDSTRING} 0 "STR:Basic UI" #remember minIS?
			IfFileExists "$NSIS\Contrib\UIs\nui.exe" 0 +2 #temp?
			SendMessage $Page1_UIListLoad ${CB_ADDSTRING} 0 "STR:Artwork UI"
			
			${If} $State_UIListLoad != ""
				SendMessage $Page1_UIListLoad ${CB_FINDSTRINGEXACT} -1 "STR:$State_UIListLoad" $0
				#SendMessage $Page1_UIListLoad ${CB_SETCURSEL} $0 ""
			${Else}
				SendMessage $Page1_UIListLoad ${CB_FINDSTRINGEXACT} -1 "STR:Modern UI (default)" $0
				#Call onChange_PimpList
			${EndIf}
			SendMessage $Page1_UIListLoad ${CB_SETCURSEL} $0 ""
		${EndIf}
		
		${NSD_CreateCheckbox} 380 65 68 25 "Recompile"
		Pop $Page1_Recompile
		
		#		
		${If} $State_Project == "load"
			ShowWindow $Page1_PimpList 1
			ShowWindow $Page1_TypeLabelLoad 1
			ShowWindow $Page1_TypeListLoad 1
			ShowWindow $Page1_UILabelLoad 1	#temp? unsure
			ShowWindow $Page1_UIListLoad 1	#temp? unsure			
			ShowWindow $Page1_Recompile 1	#temp? unsure			
			ShowWindow $Page1_TypeLabelNew 0
			ShowWindow $Page1_TypeListNew 0
			ShowWindow $Page1_TypeEnable 1
			ShowWindow $Page1_Defaults 0
			ShowWindow $Page1_UILabelNew 0	
			ShowWindow $Page1_UIListNew 0	
			
			${If} $State_TypeEnable == 1
				${NSD_SetState} $Page1_TypeEnable 1
			${EndIf}
			
			${If} $State_UIEnable == 1
				 ${NSD_SetState} $Page1_UIEnable 1
			${EndIf}
			
			ShowWindow $Page1_UILabelLoad 1
			ShowWindow $Page1_UIListLoad 1
			ShowWindow $Page1_Recompile 1
			
		${Else} # $State_Project == "new"
			ShowWindow $Page1_TypeLabelLoad 0
			ShowWindow $Page1_TypeListLoad 0
			ShowWindow $Page1_UILabelLoad 0
			ShowWindow $Page1_UIListLoad 0
			ShowWindow $Page1_Recompile 0
			ShowWindow $Page1_UIEnable 0
			${If} $State_Project == "new"
				ShowWindow $Page1_TypeListNew 1
				ShowWindow $Page1_TypeLabelNew 1
				ShowWindow $Page1_Defaults 1	
				ShowWindow $Page1_UILabelNew 1	
				ShowWindow $Page1_UIListNew 1
				
				${If} $State_Defaults == 1
					${NSD_SetState} $Page1_Defaults 1
				${Else}
					${NSD_SetState} $Page1_Defaults 0
				${EndIf}
				
			${Else}
				ShowWindow $Page1_TypeListNew 0
				ShowWindow $Page1_TypeLabelNew 0
				ShowWindow $Page1_Defaults 0
				ShowWindow $Page1_UILabelNew 0
				ShowWindow $Page1_UIListNew 0							
			${EndIf}
			ShowWindow $Page1_TypeEnable 0			
			ShowWindow $Page1_PimpList 0
		${EndIf}
		
		${If} $State_TypeEnable == 1
			EnableWindow $Page1_TypeEnable 1
			EnableWindow $Page1_TypeListLoad 1
		${Else}
			EnableWindow $Page1_TypeListLoad 0
		${EndIf}
		
		${If} $State_UIEnable == 1
			EnableWindow $Page1_UIEnable 1
			EnableWindow $Page1_UIListLoad 1
		${Else}
			EnableWindow $Page1_UIListLoad 0
		${EndIf}
				
		StrCmp $State_Project "" 0 +2
		EnableWindow $NextButton 0

		SendMessage $Page1_Dialog ${WM_SETFOCUS} $HWNDPARENT 0 #shortcuts
		nsDialogs::Show
	FunctionEnd
	
	Function Page1_Leave
		Call Page1_LoadStatus
		
		${If} $State_Recompile == 1	
			StrCpy $Passive 1
		${EndIf}
	FunctionEnd
	
	Function Page1_LoadStatus
				
		${NSD_GetState} $Page1_NewProject_Button $State_NewProject_Button
		${NSD_GetState} $Page1_LoadProject_Button $State_LoadProject_Button
		${NSD_GetText} $Page1_PimpList $State_PimpList			
		${NSD_GetState} $Page1_TypeEnable $State_TypeEnable		
		${NSD_GetText} $Page1_TypeListLoad $State_TypeListLoad
		${NSD_GetText} $Page1_TypeListNew $State_TypeListNew
		${NSD_GetState} $Page1_Defaults $State_Defaults
		${NSD_GetState} $Page1_UIEnable $State_UIEnable		
		${NSD_GetText} $Page1_UIListLoad $State_UIListLoad
		${NSD_GetText} $Page1_UIListNew $State_UIListNew
		${NSD_GetState} $Page1_Recompile $State_Recompile
		
		#${If} $pimpGoBack != "1"
		#	Call BlankState
		#${EndIf}
				
		${If} $State_Project == "load"			
			Call BlankState
			${If} $State_PimpList == "(last pack - $LastPack)"
				StrCpy $Input '$pimpDir\$LastPack'
				Call LoadPimp
			${ElseIf} ${FileExists} "$pimpDir\$State_PimpList"
				StrCpy $Input '$pimpDir\$State_PimpList'
				Call LoadPimp
			#${Else}
			#	MessageBox MB_OK "error" #temp
			${EndIf}			
						
			StrCpy $State_UI $State_UIListLoad
			
			${NSD_GetText} $Page1_TypeListLoad $State_TypeListLoad
			StrCmp $State_TypeListLoad "AVS Installer" 0 +2
			StrCpy $State_PresetType "avs"
			StrCmp $State_TypeListLoad "MilkDrop Installer" 0 +2
			StrCpy $State_PresetType "milk"
			StrCmp $State_TypeListLoad "SPS Installer" 0 +2
			StrCpy $State_PresetType "sps"
			StrCmp $State_TypeListLoad "Winamp Plugin Installer" 0 +2
			StrCpy $State_PresetType "dll"
		${ElseIf} $State_Project == "new"	
			StrCpy $State_UI $State_UIListNew
			${NSD_GetText} $Page1_TypeListNew $State_TypeListNew
			StrCmp $State_TypeListNew "AVS Installer" 0 +2
			StrCpy $State_PresetType "avs"
			StrCmp $State_TypeListNew "MilkDrop Installer" 0 +2
			StrCpy $State_PresetType "milk"
			StrCmp $State_TypeListNew "SPS Installer" 0 +2
			StrCpy $State_PresetType "sps"
			StrCmp $State_TypeListNew "Winamp Plugin Installer" 0 +2
			StrCpy $State_PresetType "dll"
			
			${If} $State_Defaults == 1
				Call LoadDefaults
			#${Else}
			#	Call BlankState
			${EndIf}
		${EndIf}	
		
	FunctionEnd
	
	Function onClick_NewProject
		Call NewProject
		Call BlankState #temp?
		
		#${If} $Parameter == "/noexe"
		#${OrIf} $Parameter == "/nopimp"
		#	StrCpy $Caption "$Parameter"
		#${If}
			StrCpy $Caption ""
			SendMessage $HWNDPARENT ${WM_SETTEXT} 0 `STR:${PB_CAPTION}`
		#${EndIf}		
	FunctionEnd
	
	Function NewProject
		EnableWindow $NextButton 1
		
		EnableWindow $Page1_NewProject_Button 0
		StrCpy $State_Project "new"
		StrCpy $pimpGoBack ""
				
		${NSD_SetText} $Page1_GroupBox "New Project"
		${If} ${FileExists} "$pimpDir\*.pimp"
		${AndIf} $7zip != ""
			EnableWindow $Page1_LoadProject_Button 1
		${EndIf}
		ShowWindow $Page1_StartLabel 0
		ShowWindow $Page1_PimpList 0
		ShowWindow $Page1_TypeLabelLoad 0
		ShowWindow $Page1_TypeEnable 0
		ShowWindow $Page1_TypeListLoad 0
		ShowWindow $Page1_UILabelLoad 0
		ShowWindow $Page1_UIEnable 0
		ShowWindow $Page1_UIListLoad 0
		ShowWindow $Page1_Recompile 0
		ShowWindow $Page1_TypeListNew 1
		ShowWindow $Page1_TypeLabelNew 1
		ShowWindow $Page1_Defaults 1			
		ShowWindow $Page1_UILabelNew 1			
		ShowWindow $Page1_UIListNew 1
		LockWindow off
	FunctionEnd
	
	Function onClick_LoadProject		
		EnableWindow $NextButton 1
		
		EnableWindow $Page1_LoadProject_Button 0
		StrCpy $State_Project "load"
		Call onChange_PimpList		
		
		${NSD_SetText} $Page1_GroupBox "Load Project"
		EnableWindow $Page1_NewProject_Button 1
		ShowWindow $Page1_StartLabel 0
		ShowWindow $Page1_PimpList 1
		ShowWindow $Page1_TypeLabelLoad 1
		ShowWindow $Page1_TypeEnable 1
		ShowWindow $Page1_TypeListLoad 1
		ShowWindow $Page1_UILabelLoad 1
		ShowWindow $Page1_UIEnable 1
		ShowWindow $Page1_UIListLoad 1
		ShowWindow $Page1_Recompile 1
		ShowWindow $Page1_TypeListNew 0
		ShowWindow $Page1_TypeLabelNew 0
		ShowWindow $Page1_Defaults 0
		ShowWindow $Page1_UILabelNew 0
		ShowWindow $Page1_UIListNew 0
		
		StrCpy $Caption ""
		SendMessage $HWNDPARENT ${WM_SETTEXT} 0 `STR:${PB_CAPTION}`
	FunctionEnd
	
	!ifndef PUBLIC_SOURCE
		Function onClick_Update
			Pop $1
			Pop $0
			
			StrCpy $1 $State_LatestVersion "" -2
			StrCmp $1 ".0" 0 +2
			StrCpy $State_LatestVersion $State_LatestVersion -2
			
			MessageBox MB_YESNO|MB_ICONQUESTION "Do you want to download and install PimpBot $State_LatestVersion?" IDYES +2
			Abort
			
			ShowWindow $Page1_Update_Link 0
			
			;lock controls
			EnableWindow $Page1_LoadProject_Button 0
			EnableWindow $Page1_NewProject_Button 0
			EnableWindow $CancelButton 0
			
			${If} $State_Project == "new"
				EnableWindow $NextButton 0
				EnableWindow $Page1_TypeListNew 0
				EnableWindow $Page1_TypeLabelNew 0
				EnableWindow $Page1_Defaults 0
				EnableWindow $Page1_UILabelNew 0
				EnableWindow $Page1_UIListNew 0
			${ElseIf} $State_Project == "load"
				EnableWindow $NextButton 0
				EnableWindow $Page1_PimpList 0
				EnableWindow $Page1_TypeLabelLoad 0
				EnableWindow $Page1_TypeListLoad 0
				EnableWindow $Page1_TypeEnable 0
				EnableWindow $Page1_UILabelLoad 0
				EnableWindow $Page1_UIEnable 0
				EnableWindow $Page1_UIListLoad 0
				EnableWindow $Page1_Recompile 0
			${EndIf}
			
			#InetLoad::load /BANNER "${PB_NAME}" "Downloading latest version of PimpBot" "$State_LatestURL" "$PLUGINSDIR\pimpbot-latest.exe"
			inetc::get /CONNECTTIMEOUT ${TIMEOUT} /RESUME "" /CAPTION "${PB_NAME}" /BANNER "Downloading latest version of PimpBot" "$State_LatestURL" "$PLUGINSDIR\pimpbot-latest.exe" /END
			Pop $0
			
			${If} $DebugLevel >= 1
				MessageBox MB_OK|MB_ICONINFORMATION "Latest Version=$State_LatestVersion$\nURL=$State_LatestURL$\nDownload Status=$0"
			${EndIf}
			
			#Secondary Download Link
			${If} $0 != "OK"
				MessageBox MB_YESNO|MB_ICONQUESTION "Download failed, do you want to retry using another mirror?" IDNO +3
				
				#InetLoad::load /BANNER "${PB_NAME}" "Downloading latest version of PimpBot" "$State_LatestAltURL" "$PLUGINSDIR\pimpbot-latest.exe"
				inetc::get /CONNECTTIMEOUT ${TIMEOUT} /CAPTION "${PB_NAME}" /BANNER "Downloading latest version of PimpBot" "$State_LatestAltURL" "$PLUGINSDIR\pimpbot-latest.exe" /END
				Pop $0
				
				${If} $DebugLevel >= 1
					MessageBox MB_OK|MB_ICONINFORMATION "Latest Version=$State_LatestVersion$\nURL=$State_LatestAltURL$\nDownload Status=$0"
				${EndIf}
			${EndIf}
			
			${If} $0 == "OK"
			${OrIf} ${FileExists} "$PLUGINSDIR\pimpbot-latest.exe" #is this such a good idea?
				${If} ${AtLeastWinVista}
					${ShellExec} "" '"$PLUGINSDIR\pimpbot-latest.exe"' '"/D=$EXEDIR"' "" ${SW_SHOW} $1
				${Else}
					Exec '"$PLUGINSDIR\pimpbot-latest.exe" /D=$EXEDIR'
				${EndIf}
				${nsProcess::KillProcess} "compiler.exe" $R0 #unfortunate, but necessary
			${Else}
				MessageBox MB_OK|MB_ICONEXCLAMATION "Download failed, please get the update from the website or try again later."
				ExecShell open "$State_LatestURL"
				
				#bring back those controls
				ShowWindow $Page1_Update_Link 1
				EnableWindow $Page1_LoadProject_Button 1
				EnableWindow $Page1_NewProject_Button 1
				EnableWindow $CancelButton 1
			${EndIf}
			
			;unlock controls
			${If} $State_Project == "new"
				EnableWindow $NextButton 1
				EnableWindow $Page1_TypeListNew 1
				EnableWindow $Page1_TypeLabelNew 1
				EnableWindow $Page1_Defaults 1
				EnableWindow $Page1_UILabelNew 1
				EnableWindow $Page1_UIListNew 1
			${ElseIf} $State_Project == "load"
				EnableWindow $NextButton 1
				EnableWindow $Page1_PimpList 1
				EnableWindow $Page1_TypeLabelLoad 1
				EnableWindow $Page1_TypeListLoad 1
				EnableWindow $Page1_TypeEnable 1
				EnableWindow $Page1_UILabelLoad 1
				EnableWindow $Page1_UIEnable 1
				EnableWindow $Page1_UIListLoad 1			
				EnableWindow $Page1_Recompile 1			
			${EndIf}
			
		FunctionEnd
	!endif

	/*
	Function PimpFile_Browse
		nsDialogs::SelectFileDialog LOAD "" "All supported types|*.pimp;*.7z;*.lzma"
		Pop $0
		${If} $0 == error
			Abort
		${EndIf}
		
		SendMessage $Page1_PimpList ${CB_ADDSTRING} 0 "STR:$0"
		SendMessage $Page1_PimpList ${CB_FINDSTRINGEXACT} -1 "STR:$0" $0
		SendMessage $Page1_PimpList ${CB_SETCURSEL} $0 ""
	FunctionEnd
	*/
	
	Function onChange_PimpList
		Pop $0

		${NSD_GetText} $Page1_PimpList $0
		
		${If} $0 == "" #when disaster strikes
			${If} $State_Project == "load"
				EnableWindow $NextButton 0
			${EndIf}
			EnableWindow $Page1_TypeEnable 0
			EnableWindow $Page1_UIEnable 0
		${Else}
			EnableWindow $NextButton 1
			EnableWindow $Page1_TypeEnable 1
			EnableWindow $Page1_UIEnable 1
		${EndIf}
		
		Delete "$MyTempDir\$pimpINI"
		${If} $0 == "(last pack - $LastPack)"
			nsExec::Exec '"$7zip" e "$pimpDir\$LastPack" -i!pimp.ini -i!pimp.xml -o"$MyTempDir" -w"$MyTempDir"'
		${ElseIf} ${FileExists} "$pimpDir\$0"
			nsExec::Exec '"$7zip" e "$pimpDir\$0" -i!pimp.ini -i!pimp.xml -o"$MyTempDir" -w"$MyTempDir"'
		#${ElseIf} ${FileExists} "$0"
		#${AndIf} $0 != ""
		#	nsExec::Exec '"$7zip" e "$0" -i!pimp.ini -i!pimp.xml -o"$MyTempDir" -w"$MyTempDir"'
		${EndIf}		
		
		#change order once full implemented?
		${If} ${FileExists} "$MyTempDir\pimp.ini"
		${AndIf} $pimpINI == ""
			StrCpy $pimpINI "pimp.ini"
		${ElseIf} ${FileExists} "$MyTempDir\pimp.xml"
		${AndIf} $pimpINI == ""
			StrCpy $pimpINI "pimp.xml"
		${EndIf}
		
		ReadINIStr $0 "$MyTempDir\$pimpINI" "Installer" "Script"
		${If} $0 == "AVS Installer"
		${OrIf} $0 == "AVS Installer (Legacy Winamp)"
		${OrIf} $0 == "MilkDrop Installer"
		${OrIf} $0 == "SPS Installer"
		${OrIf} $0 == "Winamp Plugin Installer"
			StrCmp $0 "AVS Installer (Legacy Winamp)" 0 +2
			StrCpy $0 "AVS Installer"
			SendMessage $Page1_TypeListLoad ${CB_FINDSTRINGEXACT} -1 "STR:$0" $0
			SendMessage $Page1_TypeListLoad ${CB_SETCURSEL} $0 ""
		${EndIf}

		ReadINIStr $0 "$MyTempDir\$pimpINI" "Installer" "UI"
		StrCmp $0 "" 0 +2
		StrCpy $0 "Modern UI"
		${If} $0 == "Modern UI"
		${OrIf} $0 == "Basic UI"
		${OrIf} $0 == "Artwork UI"
			StrCmp $0 "Modern UI" 0 +2
			StrCpy $0 "Modern UI (default)"
			${If} $0 == "Artwork UI"
			${AndIfNot} ${FileExists} "$NSIS\Contrib\UIs\nui.exe"
				StrCpy $0 "Modern UI (default)"
			${EndIf}
			SendMessage $Page1_UIListLoad ${CB_FINDSTRINGEXACT} -1 "STR:$0" $0
			SendMessage $Page1_UIListLoad ${CB_SETCURSEL} $0 ""
		${EndIf}		
		

		${NSD_SetState} $Page1_TypeEnable 0
		EnableWindow $Page1_TypeListLoad 0
		
		${NSD_SetState} $Page1_UIEnable 0
		EnableWindow $Page1_UIListLoad 0

		
		LockWindow off
	FunctionEnd
	
	Function onClick_TypeEnable
		Pop $0
		
		${NSD_GetState} $Page1_TypeEnable $0
		
		${If} $0 == "1"
			EnableWindow $Page1_TypeListLoad 1
		${Else}
			EnableWindow $Page1_TypeListLoad 0
			ReadINIStr $0 "$MyTempDir\$pimpINI" "Installer" "Script"
			StrCmp $0 "AVS Installer (Legacy Winamp)" 0 +2
			StrCpy $0 "AVS Installer"
			SendMessage $Page1_TypeListLoad ${CB_FINDSTRINGEXACT} -1 "STR:$0" $0
			SendMessage $Page1_TypeListLoad ${CB_SETCURSEL} $0 ""
		${EndIf}
	FunctionEnd
	
	Function onClick_UIEnable
		Pop $0
		
		${NSD_GetState} $Page1_UIEnable $0
		
		${If} $0 == "1"
			EnableWindow $Page1_UIListLoad 1
		${Else}
			EnableWindow $Page1_UIListLoad 0
			ReadINIStr $0 "$MyTempDir\$pimpINI" "Installer" "UI"
			${If} $0 == ""
				StrCpy $0 "Modern UI (default)"
			${ElseIf} $0 == "Modern UI"
				StrCpy $0 "Modern UI (default)"
			${EndIf}
			SendMessage $Page1_UIListLoad ${CB_FINDSTRINGEXACT} -1 "STR:$0" $0
			SendMessage $Page1_UIListLoad ${CB_SETCURSEL} $0 ""
		${EndIf}
	FunctionEnd
	!endif ;PAGE1
	
	!ifdef PAGE2
	Function Page2
	
		${If} $Passive == 1
			Abort
		${EndIf}
		
		${If} $Caption != "" #temp
			SendMessage $HWNDPARENT ${WM_SETTEXT} 0 `STR:${PB_CAPTION} - [$Caption]`
			StrCpy $pimpGoBack 1
		${EndIf}
		
		!insertmacro MUI_HEADER_TEXT "The Basics" "Specify a name and the required files for your installer"
		
		nsDialogs::Create /NOUNLOAD 1018
		Pop $Page2_Dialog
		
		${If} $Page2_Dialog == error
			Abort
		${EndIf}
		
		GetDlgItem $NextButton $HWNDPARENT 1 ; next=1, cancel=2, back=3
		GetDlgItem $BackButton $HWNDPARENT 3 ; next=1, cancel=2, back=3
		
		#${If} $State_PresetType == "dll"
		#	EnableWindow $BackButton 0
		#${EndIf}
		
		/*
		${If} $InputFile != ""
			ShowWindow $BackButton 0
		${Else}
			EnableWindow $BackButton 1
		${EndIf}
		*/
		${NSD_OnBack} Page2_LoadStatus
		
		LockWindow on
	
		### ROW 1 ###
		
		${NSD_CreateLabel} 0 0 450 20 "Title:"
		Pop $Page2_Name_Label
		
		${NSD_CreateText} 0 20 345 20 ""
		Pop $Page2_Name
		#Call OnChange_Title
		${NSD_OnChange} $Page2_Name OnChange_Title
		
		${If} $State_Name != ""
			${NSD_SetText} $Page2_Name "$State_Name"
			Call OnChange_Title
			#SetCtlColors $Page2_Name "" ${COL_VAL}
		${Else}
			SetCtlColors $Page2_Name "" ${COL_REQ}
		${EndIf}
		
		${NSD_CreateLabel} 355 0 55 20 "Version:"
		Pop $Page2_Version_Label
		
		${NSD_CreateText} 355 20 55 20 ""
		Pop $Page2_Version
		
		${If} $State_Version != ""
			${NSD_SetText} $Page2_Version "$State_Version"
		${EndIf}
		
		### ROW 2 ###
		
		${If} $State_PresetType != "dll"
			${NSD_CreateLabel} 0 50 315 20 "Presets:"			
		${Else}
			${NSD_CreateLabel} 0 50 315 20 "Plugin File:"	
		${EndIf}
		Pop $Page2_PresetDir_Label
		
		${If} $State_PresetType != "dll"
			${NSD_CreateDirRequest} 0 70 320 20 ""
			Pop $Page2_PresetDir
			${If} $noAVS != 1
			${AndIf} $noAVS != 2
				${NSD_OnChange} $Page2_PresetDir OnChange_PresetDir
					
				${If} $State_PresetDir != ""
				${AndIf} ${FileExists} "$State_PresetDir\*.*"
					${NSD_SetText} $Page2_PresetDir "$State_PresetDir"
					Call OnChange_PresetDir
					#SetCtlColors $Page2_PresetDir "" ${COL_VAL}
				${ElseIf} $State_PresetDir == ""
					SetCtlColors $Page2_PresetDir "" ${COL_REQ}
				${EndIf}
			${Else}
				StrCpy $Valid_PresetDir 1
			${EndIf}
			
			${NSD_CreateButton} 320 70 25 20 "..."
			Pop $Page2_PresetDir_Button
					
			${If} $noAVS != 1
			${AndIf} $noAVS != 2
				GetFunctionAddress $0 PresetDir_Browse
				nsDialogs::OnClick /NOUNLOAD $Page2_PresetDir_Button $0
			${EndIf}
		${Else} # == "dll"
			${NSD_CreateFileRequest} 0 70 320 20 ""
			Pop $Page2_PresetFile
			
			${NSD_CreateButton} 320 70 25 20 "..."
			Pop $Page2_PresetFile_Button
			
			${NSD_OnChange} $Page2_PresetFile OnChange_PresetFile
					
				${If} $State_PresetFile != ""
				${AndIf} ${FileExists} "$State_PresetFile"
					${NSD_SetText} $Page2_PresetFile "$State_PresetFile"
					Call OnChange_PresetFile
					#SetCtlColors $Page2_PresetDir "" ${COL_VAL}
				${ElseIf} $State_PresetFile == ""
					SetCtlColors $Page2_PresetFile "" ${COL_REQ}
				${EndIf}
			
			GetFunctionAddress $0 PresetFile_Browse
			nsDialogs::OnClick /NOUNLOAD $Page2_PresetFile_Button $0
		${EndIf}
									
		
		${If} $State_PresetType != "dll"			
			${NSD_CreateCheckbox} 355 70 95 20 "Include Subdirs"
			Pop $Page2_Subfolders
			${If} $noAVS != 1
			${AndIf} $noAVS != 2
				${NSD_OnClick} $Page2_Subfolders OnClick_PresetDir
			
				${If} $State_PresetDir == ""
					EnableWindow $Page2_Subfolders 0
				${Else}
					#Call OnClick_PresetDir
					EnableWindow $Page2_Subfolders 1
				${EndIf}
				
				${If} $State_Subfolders == 1
					${NSD_SetState} $Page2_Subfolders 1
					EnableWindow $Page2_Subfolders 1
					${If} $Subfolder == 1
						EnableWindow $Page2_Subfolders 1
					${EndIf}
				${Else}
					${NSD_SetState} $Page2_Subfolders 0
					${If} $Subfolder != 1
						EnableWindow $Page2_Subfolders 0
					${EndIf}
				${EndIf}

			${Else}
				EnableWindow $Page2_PresetDir 0
				EnableWindow $Page2_PresetDir_Button 0
				EnableWindow $Page2_Subfolders 0
			${EndIf}
			
				
			### ROW 3 ###
			${If} $BabelScript == "multi"
				${NSD_CreateDirRequest} 0 91 320 20 ""
				Pop $Page2_AltPresetDir
				${If} $noAVS != 1
				${AndIf} $noAVS != 2
					${NSD_OnChange} $Page2_AltPresetDir OnChange_AltPresetDir
					
					${If} $State_AltPresetDir != ""
					${AndIf} ${FileExists} "$State_AltPresetDir\*.*"
						${NSD_SetText} $Page2_AltPresetDir "$State_AltPresetDir"
						SetCtlColors $Page2_AltPresetDir "" ${COL_VAL}
					${ElseIf} $State_AltPresetDir == ""
						SetCtlColors $Page2_AltPresetDir "" ""
					${EndIf}
				${Else}
					StrCpy $Valid_AltPresetDir 1
				${EndIf}
				
				${NSD_CreateButton} 320 91 25 20 "..."
				Pop $Page2_AltPresetDir_Button
				
				${If} $noAVS != 1
				${AndIf} $noAVS != 2
					GetFunctionAddress $0 AltPresetDir_Browse
					nsDialogs::OnClick /NOUNLOAD $Page2_AltPresetDir_Button $0
				${EndIf}
				
				#${NSD_CreateDroplistSorted} 355 90 90 18 "Japanese"
				${NSD_CreateCheckbox} 355 91 95 20 "Include Subdirs"
				Pop $Page2_AltSubfolders
				
				${If} $noAVS != 1
				${AndIf} $noAVS != 2
					${NSD_OnClick} $Page2_AltSubfolders OnClick_AltPresetDir
					
					${If} $State_AltPresetDir == ""
						EnableWindow $Page2_AltSubfolders 0
					${Else}
						EnableWindow $Page2_AltSubfolders 1
					${EndIf}
					
					${If} $State_AltSubfolders == 1
						${NSD_SetState} $Page2_AltSubfolders 1
						EnableWindow $Page2_AltSubfolders 1
						${If} $AltSubfolder == 1
							EnableWindow $Page2_AltSubfolders 1
						${EndIf}
					${Else}
						${NSD_SetState} $Page2_AltSubfolders 0
						${If} $AltSubfolder != 1
							EnableWindow $Page2_AltSubfolders 0
						${EndIf}
					${EndIf}
				${Else}
					EnableWindow $Page2_AltPresetDir 0
					EnableWindow $Page2_AltPresetDir_Button 0
					EnableWindow $Page2_AltSubfolders 0
				${EndIf}
			${EndIf}
		${EndIf}
		
		### ROW 4 ###
		${If} $State_PresetType != "sps"
			${If} $State_PresetType != "dll"
				${NSD_CreateLabel} 0 120 315 20 "Resource Files:"
			${Else}
				${NSD_CreateLabel} 0 100 315 20 "Resource Files:"
			${EndIf}
			Pop $Page2_AddFiles_Label
			
			${If} $State_PresetType != "dll"
				${NSD_CreateDirRequest} 0 140 320 20 ""
			${Else}
				${NSD_CreateDirRequest} 0 120 320 20 ""
			${EndIf}
			Pop $Page2_AddFiles
			${NSD_OnChange} $Page2_AddFiles OnChange_FilesDir

			${If} $State_AddFiles != ""
			${AndIf} ${FileExists} "$State_AddFiles\*.*"
				${NSD_SetText} $Page2_AddFiles "$State_AddFiles"
				Call OnChange_FilesDir
			${EndIf}
					
			${If} $State_PresetType != "dll"
				${NSD_CreateButton} 320 140 25 20 "..."
			${Else}
				${NSD_CreateButton} 320 120 25 20 "..."
			${EndIf}
			Pop $Page2_AddFiles_Button
			GetFunctionAddress $0 FilesDir_Browse
			nsDialogs::OnClick /NOUNLOAD $Page2_AddFiles_Button $0
			
			${If} $State_PresetType != "dll"
				${NSD_CreateCheckBox} 5 160 40 20 "bmp"
				Pop $Page2_CB_BMP
				ToolTips::Classic $Page2_CB_BMP "Bitmap image"
				${If} $State_AddBMP == 1
					${NSD_SetState} $Page2_CB_BMP 1
				${Else}
					${NSD_SetState} $Page2_CB_BMP 0
				${EndIf}
				${NSD_OnClick} $Page2_CB_BMP OnClick_FilesDir
				
				${NSD_CreateCheckBox} 45 160 35 20 "jpg"
				Pop $Page2_CB_JPG
				ToolTips::Classic $Page2_CB_JPG "JPEG image"
				${If} $State_AddJPG == 1
					${NSD_SetState} $Page2_CB_JPG 1
				${Else}
					${NSD_SetState} $Page2_CB_JPG 0
				${EndIf}
				${NSD_OnClick} $Page2_CB_JPG OnClick_FilesDir
			${EndIf}
			
			${If} $State_PresetType == "avs"
				${NSD_CreateCheckBox} 80 160 35 20 "avi"
				Pop $Page2_CB_AVI
				ToolTips::Classic $Page2_CB_AVI "Video file"
				${If} $State_AddAVI == 1
					${NSD_SetState} $Page2_CB_AVI 1
				${Else}
					${NSD_SetState} $Page2_CB_AVI 0
				${EndIf}
				${NSD_OnClick} $Page2_CB_AVI OnClick_FilesDir
			
				${NSD_CreateCheckBox} 115 160 40 20 "gvm"
				Pop $Page2_CB_GVM
				ToolTips::Classic $Page2_CB_GVM "Global Variables Model"
				${If} $State_AddGVM == 1
					${NSD_SetState} $Page2_CB_GVM 1
				${Else}
					${NSD_SetState} $Page2_CB_GVM 0
				${EndIf}
				${NSD_OnClick} $Page2_CB_GVM OnClick_FilesDir
				
				${NSD_CreateCheckBox} 155 160 37 20 "svp"
				Pop $Page2_CB_SVP
				ToolTips::Classic $Page2_CB_SVP "Sonique Visualization Plugins"
				${If} $State_AddSVP == 1
					${NSD_SetState} $Page2_CB_SVP 1
				${Else}
					${NSD_SetState} $Page2_CB_SVP 0
				${EndIf}
				${NSD_OnClick} $Page2_CB_SVP OnClick_FilesDir
				
				${NSD_CreateCheckBox} 192 160 38 20 "uvs" #temp
				Pop $Page2_CB_UVS
				ToolTips::Classic $Page2_CB_UVS "...but what is it?!"
				${If} $State_AddUVS == 1
					${NSD_SetState} $Page2_CB_UVS 1
				${Else}
					${NSD_SetState} $Page2_CB_UVS 0
				${EndIf}
				${NSD_OnClick} $Page2_CB_UVS OnClick_FilesDir
				
				${NSD_CreateCheckBox} 252 160 35 20 "cff"
				Pop $Page2_CB_CFF
				ToolTips::Classic $Page2_CB_CFF "Convolution Filter files"
				${If} $State_AddCFF == 1
					${NSD_SetState} $Page2_CB_CFF 1
				${Else}
					${NSD_SetState} $Page2_CB_CFF 0
				${EndIf}
				${NSD_OnClick} $Page2_CB_CFF OnClick_FilesDir
				
				${NSD_CreateCheckBox} 287 160 35 20 "clm"
				Pop $Page2_CB_CLM
				ToolTips::Classic $Page2_CB_CLM "ColorMap files"				
				${If} $State_AddCLM == 1
					${NSD_SetState} $Page2_CB_CLM 1
				${Else}
					${NSD_SetState} $Page2_CB_CLM 0
				${EndIf}
				${NSD_OnClick} $Page2_CB_CLM OnClick_FilesDir
			${EndIf}
		${EndIf}
		
		Call Disable_FilesDirTypes			
		
		${If} $State_AddFiles != ""
			${If} ${FileExists} "$State_AddFiles\*.bmp"
			${OrIf} ${FileExists} "$State_AddFiles\*.jpg"
			${OrIf} ${FileExists} "$State_AddFiles\*.avi"
			${OrIf} ${FileExists} "$State_AddFiles\*.gvm"
			${OrIf} ${FileExists} "$State_AddFiles\*.svp"
			${OrIf} ${FileExists} "$State_AddFiles\*.uvs"
			${OrIf} ${FileExists} "$State_AddFiles\*.cff"
			${OrIf} ${FileExists} "$State_AddFiles\*.clm"
				${NSD_SetText} $Page2_AddFiles "$State_AddFiles"
				SetCtlColors $Page2_AddFiles "" ${COL_VAL}
				Call Enable_FilesDirTypes
			${EndIf}
		${ElseIf} $State_AddFiles != ""
		${AndIf} $State_PresetType == "dll"
		${AndIf} ${FileExists} "$State_AddFiles\*.*"
			SetCtlColors $Page2_AddFiles "" ${COL_VAL}
		${ElseIf} $State_AddFiles == ""
			SetCtlColors $Page2_AddFiles "" ""
			Call Disable_FilesDirTypes
		${Else} #${FileExists} "$State_AddFiles\*.*"
			#${NSD_SetText} $Page2_AddFiles "$State_AddFiles"
			SetCtlColors $Page2_AddFiles "" ${COL_INV}	
			Call Disable_FilesDirTypes	
		#${Else}
		#	SetCtlColors $Page2_AddFiles "" ""
		${EndIf}
		
		${If} ${AtLeastWin2000} # Magic button not working on Windows 9x
			${If} $State_PresetType == "avs"
			${AndIf} ${FileExists} "$visDir\*.*"
			${AndIf} $visDir != ""
				${NSD_CreateLabel} 355 120 315 20 "..or try some"
				Pop $Page2_ScanResources_Label
				
				${NSD_CreateButton} 355 140 55 20 "&Magic"
				Pop $Page2_ScanResources
				GetFunctionAddress $0 OnClick_ScanResources
				nsDialogs::OnClick /NOUNLOAD $Page2_ScanResources $0
				
				ToolTips::Classic $Page2_ScanResources "Scan presets for required resource files and copy them automatically"
				
			${EndIf}
			
			${NSD_GetText} $Page2_PresetDir $0
			
			${If} $autoRes == 1
			${AndIf} $0 != ""
				Call OnClick_ScanResources
			${EndIf}
		${EndIf}
		
		
		
		#Call Disable_FilesDirTypes		
		Call Page2_Next
		
		nsDialogs::Show
	FunctionEnd
	
	Function Page2_Leave
		Call Page2_LoadStatus
		
		${If} $DebugLevel >= 2
			MessageBox MB_OK|MB_ICONINFORMATION "Title=$State_Name$\nVersion=$State_Version$\nPlugin=$State_PresetFile$\nPresets=$State_PresetDir$\nSubdirs=$State_Subfolders$\nResource Files=$State_AddFiles$\nbmp=$State_AddBMP$\njpg=$State_AddJPG$\navi=$State_AddAVI$\ngvm=$State_AddGVM$\nsvp=$State_AddSVP$\nuvs=$State_AddUVS$\ncff=$State_AddCFF$\nclm=$State_AddCLM"
		${EndIf}
	FunctionEnd
	
	Function Page2_LoadStatus
		${NSD_GetText} $Page2_Name $State_Name
		${NSD_GetText} $Page2_Version $State_Version
		${If} $State_PresetType != "dll"
			${NSD_GetText} $Page2_PresetDir $State_PresetDir
			${NSD_GetState} $Page2_Subfolders $State_Subfolders
			${If} $BabelScript == "multi"
				${NSD_GetText} $Page2_AltPresetDir $State_AltPresetDir
				${NSD_GetState} $Page2_AltSubfolders $State_AltSubfolders
			${EndIf}
		${Else}
			${NSD_GetText} $Page2_PresetFile $State_PresetFile
		${EndIf}
		${NSD_GetText} $Page2_AddFiles $State_AddFiles
		${NSD_GetState} $Page2_CB_BMP $State_AddBMP
		${NSD_GetState} $Page2_CB_JPG $State_AddJPG
		${NSD_GetState} $Page2_CB_AVI $State_AddAVI
		${NSD_GetState} $Page2_CB_GVM $State_AddGVM
		${NSD_GetState} $Page2_CB_SVP $State_AddSVP
		${NSD_GetState} $Page2_CB_UVS $State_AddUVS
		${NSD_GetState} $Page2_CB_CFF $State_AddCFF
		${NSD_GetState} $Page2_CB_CLM $State_AddCLM
	FunctionEnd
		
	Function OnChange_Title
		Pop $0 # HWND
		Pop $1 # HWND
		${NSD_GetText} $Page2_Name $0
						
		${If} $0 == ""
			SetCtlColors $Page2_Name "" ${COL_REQ}
		${Else}
			SetCtlColors $Page2_Name "" ${COL_VAL}
		${EndIf}		
		Call Page2_Next
	FunctionEnd
	
	Function Page2_Next
		Pop $R0 # HWND
		Pop $2 # HWND
		Pop $3 # HWND
		Pop $4 # HWND
		
		${If} $BabelScript == "multi"
			Pop $5 # HWND
			${NSD_GetText} $Page2_AltPresetDir $5
		${EndIf}
		
		${If} $State_PresetType != "dll"
			${NSD_GetText} $Page2_PresetDir $2	#optional
		${Else}
			${NSD_GetText} $Page2_PresetFile $2	#optional
		${EndIf}
		${NSD_GetText} $Page2_AddFiles $3		#optional
		${NSD_GetText} $Page2_Name $4
		
		StrCpy $R0 0
		
		${If} $State_PresetType != "dll"
			${If} $Valid_PresetDir == 1
				StrCpy $R1 1
			${Else}
				StrCpy $R1 0
			${EndIf}
		${Else}
			${If} $Valid_PresetFile == 1
				StrCpy $R1 1
			${Else}
				StrCpy $R1 0
			${EndIf}
		${EndIf}
		
		${If} $State_PresetType != "dll"
			${If} ${FileExists} "$2\*.*"
			${OrIf} $2 == "" #mmh, no second check?
				StrCpy $R2 1
			${Else}
				StrCpy $R2 0
			${EndIf}
		${Else}
			${If} ${FileExists} "$2"
			${OrIf} $2 != ""
				StrCpy $R2 1
			${Else}
				StrCpy $R2 0
			${EndIf}
		${EndIf}
		
		${If} ${FileExists} "$3\*.bmp"
		${OrIf} ${FileExists} "$3\*.jpg"
		${OrIf} ${FileExists} "$3\*.avi"
		${OrIf} ${FileExists} "$3\*.gvm"
		${OrIf} ${FileExists} "$3\*.svp"
		${OrIf} ${FileExists} "$3\*.uvs"
		${OrIf} ${FileExists} "$3\*.cff"
		${OrIf} ${FileExists} "$3\*.clm"
		${OrIf} $3 == ""
			StrCpy $R3 1
		${Else}
			StrCpy $R3 0
		${EndIf}
		
		${If} $4 == ""
			StrCpy $R4 0
		${Else}
			StrCpy $R4 1
		${EndIf}		

		${If} $BabelScript == "multi"
			${If} $Valid_AltPresetDir == 1
				StrCpy $R6 1
			${Else}
				StrCpy $R6 0
			${EndIf}
			
			${If} ${FileExists} "$5\*.*"
			${OrIf} $5 == ""
				StrCpy $R5 1
			${Else}
				StrCpy $R5 0
			${EndIf}
		${EndIf}
				
		IntOp $R0 $R0 + $R1
		IntOp $R0 $R0 + $R2
		IntOp $R0 $R0 + $R3
		IntOp $R0 $R0 + $R4
		
		${If} $BabelScript == "multi"
			IntOp $R0 $R0 + $R5
			IntOp $R0 $R0 + $R6
			${If} $R0 == 6
				EnableWindow $NextButton 1
				EnableWindow $BackButton 1
				EnableWindow $Page2_ScanResources 1
			${Else}
				EnableWindow $NextButton 0
				EnableWindow $Page2_ScanResources 0
			${EndIf}
		${ElseIf} $State_PresetType == "dll" #unfortunate, but necessary
			EnableWindow $BackButton 0
			Goto do_enable
		${Else}
			do_enable:
			${If} $R0 == 4
				EnableWindow $NextButton 1
				EnableWindow $BackButton 1
				EnableWindow $Page2_ScanResources 1
			${Else}
				EnableWindow $NextButton 0
				EnableWindow $Page2_ScanResources 0
			${EndIf}
			
		${EndIf}
		
		LockWindow off
	FunctionEnd
			
	Function OnChange_PresetDir
		Pop $0 # HWND
		Pop $1 # HWND
		
		${NSD_GetText} $Page2_PresetDir $0
		StrLen $1 $0
		
		${If} $1 < "4"
			${If} $1 == "0"
				SetCtlColors $Page2_PresetDir "" ${COL_REQ}
			${Else}
				set_Invalid:
				SetCtlColors $Page2_PresetDir "" ${COL_INV}
			${EndIf}
			EnableWindow $Page2_Subfolders 0
			${NSD_SetState} $Page2_Subfolders 0
			StrCpy $Valid_PresetDir 0
			Call Page2_Next
			Abort
		${ElseIfNot} ${FileExists} "$0\*.*"
			Goto set_Invalid
		${EndIf}
		
		Call OnChange_PresetDir_Subs
		
		${NSD_GetText} $Page2_PresetDir $0
		
		/*
		${If} $0 == "" #empty
			SetCtlColors $Page2_PresetDir "" ${COL_REQ}
			${NSD_SetState} $Page2_Subfolders 0
			StrCpy $Valid_PresetDir 0
		*/
		${If} ${FileExists} "$0\*.$State_PresetType" #exists in dir
		${AndIf} $0 != ""
			SetCtlColors $Page2_PresetDir "" ${COL_VAL}
			StrCpy $Valid_PresetDir 1
			${If} $SubFolder == "1"	
				#there's a bug sleeping
				SetCtlColors $Page2_PresetDir "" ${COL_INV}
				EnableWindow $Page2_Subfolders 1
				${NSD_SetState} $Page2_Subfolders 1
			#${ElseIf} $SubFolder == "2"	#mixed
			#	SetCtlColors $Page2_PresetDir "" ${COL_REQ}
			#	EnableWindow $Page2_Subfolders 1
				${NSD_SetState} $Page2_Subfolders 1
			${Else}
				EnableWindow $Page2_Subfolders 0
				${NSD_SetState} $Page2_Subfolders 0
			${EndIf}			
		${ElseIf} ${FileExists} "$0\*.*" # only in subdir
		${AndIf} $0 != ""
		${AndIf} $Subfolder = 1
			SetCtlColors $Page2_PresetDir "" ${COL_VAL}
			StrCpy $Valid_PresetDir 1
			EnableWindow $Page2_Subfolders 1
			${NSD_SetState} $Page2_Subfolders 1
		${Else} # invalid dir
			SetCtlColors $Page2_PresetDir "" ${COL_INV}
			EnableWindow $Page2_Subfolders 0
			${NSD_SetState} $Page2_Subfolders 0
			StrCpy $Valid_PresetDir 0
		${EndIf}	
		
		Call Page2_Next
	FunctionEnd
	

	Function OnClick_PresetDir
		Pop $0 # HWND
		Pop $1 # HWND
		
		${NSD_GetText} $Page2_PresetDir $0
		${NSD_GetState} $Page2_Subfolders $1
		
		${If} $0 == ""
			SetCtlColors $Page2_PresetDir "" "${REQ}"
			StrCpy $Valid_PresetDir 0
		${ElseIf} $1 == "1"
		${AndIf} $SubFolder == "1"
			SetCtlColors $Page2_PresetDir "" ${COL_VAL}
			StrCpy $Valid_PresetDir 1
		${Else}
			SetCtlColors $Page2_PresetDir "" ${COL_INV}
			StrCpy $Valid_PresetDir 0
		${EndIf}
		Call Page2_next
	FunctionEnd
	
	Function OnChange_PresetDir_Subs
		Pop $R0 # HWND
		
		${NSD_GetText} $Page2_PresetDir $R0
		
		${If} ${FileExists} "$R0\*.*"
			${Locate} "$R0" "/L=F /M=*.$State_PresetType /G=1" "scan_PresetType"
		${Else}
			Abort
		${EndIf}
	FunctionEnd
	
	Function OnChange_PresetFile
		Pop $0 # HWND
		Pop $1 # HWND
		
		${NSD_GetText} $Page2_PresetFile $0
		StrLen $1 $0
		
		${If} $1 < "4"
			${If} $1 == "0"
				SetCtlColors $Page2_PresetFile "" ${COL_REQ}
			${Else}
				SetCtlColors $Page2_PresetFile "" ${COL_INV}
			${EndIf}
			StrCpy $Valid_PresetFile 0
			Call Page2_Next
			Abort
		${EndIf}
		
		${NSD_GetText} $Page2_PresetFile $0
		
		${If} ${FileExists} "$0" #exists in dir
			SetCtlColors $Page2_PresetFile "" ${COL_VAL}
			StrCpy $Valid_PresetFile 1
		${Else} # invalid dir
			SetCtlColors $Page2_PresetFile "" ${COL_INV}
			StrCpy $Valid_PresetFile 0
		${EndIf}	
		Call Page2_Next
	FunctionEnd
	
	Function OnChange_AltPresetDir
		Pop $0 # HWND
		Pop $1 # HWND
		Pop $2 # HWND
		
		${NSD_GetText} $Page2_AltPresetDir $0
		${NSD_GetText} $Page2_PresetDir $1
		StrLen $2 $0
				
		${If} $2 < "4"
			${If} $2 == "0"
				SetCtlColors $Page2_AltPresetDir "" ${COL_REQ}
			${Else}
				set_Invalid:
				SetCtlColors $Page2_AltPresetDir "" ${COL_INV}
			${EndIf}
			EnableWindow $Page2_AltSubfolders 0
			${NSD_SetState} $Page2_AltSubfolders 0
			#abort:
			StrCpy $Valid_AltPresetDir 0
			Call Page2_Next
			Abort
		/*${ElseIf} $0 == $1
		${OrIf} $0 == "$1\" #don't let them fool you
		${OrIf} "$0\" == "$1" #don't let them fool you
			SetCtlColors $Page2_AltPresetDir "" ${COL_INV}
			Goto abort
		*/
		${ElseIfNot} ${FileExists} "$0\*.*"
			Goto set_Invalid
		${EndIf}
		
		Call OnChange_AltPresetDir_Subs
		
		${NSD_GetText} $Page2_AltPresetDir $0
		
		/*
		${If} $0 == "" #empty
			SetCtlColors $Page2_PresetDir "" ${COL_REQ}
			${NSD_SetState} $Page2_Subfolders 0
			StrCpy $Valid_PresetDir 0
		*/
		${If} ${FileExists} "$0\*.$State_PresetType" #exists in dir
		${AndIf} $0 != ""
			SetCtlColors $Page2_AltPresetDir "" ${COL_VAL}
			StrCpy $Valid_AltPresetDir 1
			${If} $AltSubFolder == "1"		
				EnableWindow $Page2_AltSubfolders 1
				${NSD_SetState} $Page2_AltSubfolders 1
			${Else}
				EnableWindow $Page2_AltSubfolders 0
				${NSD_SetState} $Page2_AltSubfolders 0
			${EndIf}			
		${ElseIf} ${FileExists} "$0\*.*" # only in subdir
		${AndIf} $0 != ""
		${AndIf} $AltSubfolder = "1"
			SetCtlColors $Page2_AltPresetDir "" ${COL_VAL}
			StrCpy $Valid_AltPresetDir 1
			EnableWindow $Page2_AltSubfolders 1
			${NSD_SetState} $Page2_AltSubfolders 1
		${Else} # invalid dir
			SetCtlColors $Page2_AltPresetDir "" ${COL_INV}
			EnableWindow $Page2_AltSubfolders 0
			${NSD_SetState} $Page2_AltSubfolders 0
			StrCpy $Valid_AltPresetDir 0
		${EndIf}	
		Call Page2_Next
	FunctionEnd
	
	Function OnClick_AltPresetDir
		Pop $0 # HWND
		Pop $1 # HWND
		Pop $2 # HWND
		
		${NSD_GetText} $Page2_AltPresetDir $0
		${NSD_GetText} $Page2_PresetDir $1
		${NSD_GetState} $Page2_AltSubfolders $2
				
		${If} $0 == ""
			SetCtlColors $Page2_AltPresetDir "" "${COL_REQ}"
			StrCpy $Valid_AltPresetDir 0
		${ElseIf} $2 == "1"
		${AndIf} $AltSubFolder == "1"
			SetCtlColors $Page2_AltPresetDir "" ${COL_VAL}
			StrCpy $Valid_AltPresetDir 1
		${ElseIf} $0 == $1
		${OrIf} $0 == "$1\" #don't let them fool you
		${OrIf} "$0\" == "$1" #don't let them fool you
			SetCtlColors $Page2_AltPresetDir "" ${COL_INV}
			StrCpy $Valid_AltPresetDir 0
		${Else}
			SetCtlColors $Page2_AltPresetDir "" ${COL_INV}
			StrCpy $Valid_AltPresetDir 0
		${EndIf}
		Call Page2_next
	FunctionEnd
	
	Function OnChange_AltPresetDir_Subs
		Pop $R0 # HWND
		
		${NSD_GetText} $Page2_AltPresetDir $R0
		
		${If} ${FileExists} "$R0\*.*"
			${Locate} "$R0" "/L=F /M=*.$State_PresetType /G=1" "scan_AltPresetType"
		${Else}
			Abort
		${EndIf}
	FunctionEnd

	Function OnChange_FilesDir
		Pop $0 # HWND
		Pop $1 # HWND
		#Pop $2 # HWND
		
		${NSD_GetText} $Page2_AddFiles $0
		StrLen $1 $0
		
		#${NSD_GetState} $Page2_CB_AVI $2
		
		${If} $0 == ""
			SetCtlColors $Page2_AddFiles "" ""
			Call Disable_FilesDirTypes
			EnableWindow $Page2_ScanResources 1
		${ElseIf} $1 < "4"
		${AndIf} $1 != "0"
			SetCtlColors $Page2_AddFiles "" ${COL_INV}
			Call Disable_FilesDirTypes
			EnableWindow $Page2_ScanResources 0
			EnableWindow $NextButton 0
			Abort
		${ElseIf} ${FileExists} "$0\*.bmp"
		${OrIf} ${FileExists} "$0\*.jpg"
		${OrIf} ${FileExists} "$0\*.avi"
		${OrIf} ${FileExists} "$0\*.gvm"
		${OrIf} ${FileExists} "$0\*.svp"
		${OrIf} ${FileExists} "$0\*.uvs"
		${OrIf} ${FileExists} "$0\*.cff"
		${OrIf} ${FileExists} "$0\*.clm"
			SetCtlColors $Page2_AddFiles "" ${COL_VAL}
			Call Disable_FilesDirTypes
			EnableWindow $Page2_ScanResources 1
			${If} ${FileExists} "$0\*.bmp"
			${AndIf} $State_AddBMP != "0"
				${NSD_SetState} $Page2_CB_BMP 1
				EnableWindow $Page2_CB_BMP 1
			${Else}
				${NSD_SetState} $Page2_CB_BMP 0
				#EnableWindow $Page2_CB_BMP 0
			${EndIf}
			
			${If} ${FileExists} "$0\*.jpg"
			${AndIf} $State_AddJPG != "0"
				${NSD_SetState} $Page2_CB_JPG 1
				EnableWindow $Page2_CB_JPG 1
			${Else}
				${NSD_SetState} $Page2_CB_JPG 0
				#EnableWindow $Page2_CB_JPG 0
			${EndIf}
			
			#${If} $2 == "1"
			${If} ${FileExists} "$0\*.avi"
			${AndIf} $State_AddAVI != "0"
				${NSD_SetState} $Page2_CB_AVI 1
				EnableWindow $Page2_CB_AVI 1
			${Else}
				${NSD_SetState} $Page2_CB_AVI 0
				#EnableWindow $Page2_CB_AVI 0
			${EndIf}
			
			${If} ${FileExists} "$0\*.gvm"
			${AndIf} $State_AddGVM != "0"
				${NSD_SetState} $Page2_CB_GVM 1
				EnableWindow $Page2_CB_GVM 1
			${Else}
				${NSD_SetState} $Page2_CB_GVM 0
				#EnableWindow $Page2_CB_GVM 0
			${EndIf}
			
			${If} ${FileExists} "$0\*.svp"
			${AndIf} $State_AddSVP != "0"
				${NSD_SetState} $Page2_CB_SVP 1
				EnableWindow $Page2_CB_SVP 1
			${Else}
				${NSD_SetState} $Page2_CB_SVP 0
				#EnableWindow $Page2_CB_SVP 0
			${EndIf}
			
			${If} ${FileExists} "$0\*.uvs"
			${AndIf} $State_AddUVS != "0"
				${NSD_SetState} $Page2_CB_UVS 1
				EnableWindow $Page2_CB_UVS 1
			${Else}
				${NSD_SetState} $Page2_CB_UVS 0
				#EnableWindow $Page2_CB_UVS 0
			${EndIf}
			
			${If} ${FileExists} "$0\*.cff"
			${AndIf} $State_AddCFF != "0"
				${NSD_SetState} $Page2_CB_CFF 1
				EnableWindow $Page2_CB_CFF 1
			${Else}
				${NSD_SetState} $Page2_CB_CFF 0
				#EnableWindow $Page2_CB_CFF 0
			${EndIf}
			
			${If} ${FileExists} "$0\*.clm"
			${AndIf} $State_AddCLM != "0"
				${NSD_SetState} $Page2_CB_CLM 1
				EnableWindow $Page2_CB_CLM 1
			${Else}
				${NSD_SetState} $Page2_CB_CLM 0
				#EnableWindow $Page2_CB_CLM 0
			${EndIf}
			#Call Enable_FilesDirTypes
		${ElseIf} $State_PresetType == "dll"
		${AndIf} ${FileExists} "$0\*.*"
			SetCtlColors $Page2_AddFiles "" ${COL_VAL}
			EnableWindow $Page2_ScanResources 1
		${Else} #${FileExists} "$0\*.*"
			SetCtlColors $Page2_AddFiles "" ${COL_INV}
			Call Disable_FilesDirTypes
			EnableWindow $Page2_ScanResources 0
		${EndIf}
		Call Page2_Next		
	FunctionEnd	
	
	Function OnClick_FilesDir
	FunctionEnd
	
	Function Enable_FilesDirTypes
		Pop $0
		
		${NSD_GetText} $Page2_AddFiles $0
		IfFileExists "$0\*.bmp" 0 +2
		EnableWindow $Page2_CB_BMP 1
		IfFileExists "$0\*.jpg" 0 +2
		EnableWindow $Page2_CB_JPG 1
		IfFileExists "$0\*.avi" 0 +2
		EnableWindow $Page2_CB_AVI 1
		IfFileExists "$0\*.gvm" 0 +2
		EnableWindow $Page2_CB_GVM 1
		IfFileExists "$0\*.svp" 0 +2
		EnableWindow $Page2_CB_SVP 1
		IfFileExists "$0\*.uvs" 0 +2
		EnableWindow $Page2_CB_UVS 1
		IfFileExists "$0\*.cff" 0 +2
		EnableWindow $Page2_CB_CFF 1
		IfFileExists "$0\*.clm" 0 +2
		EnableWindow $Page2_CB_CLM 1
	FunctionEnd
	
	Function Disable_FilesDirTypes
		EnableWindow $Page2_CB_BMP 0
		${NSD_SetState} $Page2_CB_BMP 0
		EnableWindow $Page2_CB_JPG 0
		${NSD_SetState} $Page2_CB_JPG 0
		EnableWindow $Page2_CB_AVI 0
		${NSD_SetState} $Page2_CB_AVI 0
		EnableWindow $Page2_CB_GVM 0
		${NSD_SetState} $Page2_CB_GVM 0
		EnableWindow $Page2_CB_SVP 0
		${NSD_SetState} $Page2_CB_SVP 0
		EnableWindow $Page2_CB_UVS 0
		${NSD_SetState} $Page2_CB_UVS 0
		EnableWindow $Page2_CB_CFF 0
		${NSD_SetState} $Page2_CB_CFF 0
		EnableWindow $Page2_CB_CLM 0
		${NSD_SetState} $Page2_CB_CLM 0
		LockWindow off
	FunctionEnd
		
	Function PresetDir_Browse
		nsDialogs::SelectFolderDialog /NOUNLOAD "Please select a target directory" ""
		Pop $0
		${If} $0 == error
			Abort
		${EndIf}
		SendMessage $Page2_PresetDir ${WM_SETTEXT} 0 "STR:$0"
	FunctionEnd
		
	Function PresetFile_Browse #dll only
		#nsDialogs::SelectFolderDialog /NOUNLOAD "Please select a plugin file" "All Icons|*.ico|PimpBot Icons|icon*.ico"
		nsDialogs::SelectFileDialog LOAD "" "All Plugins|dsp_*.dll;enc_*.dll;gen_*.dll;in_*.dll;out_*.dll;vis_*.dll"
		Pop $0
		${If} $0 == error
			Abort
		${EndIf}
		SendMessage $Page2_PresetFile ${WM_SETTEXT} 0 "STR:$0"
	FunctionEnd
	
	Function AltPresetDir_Browse
		nsDialogs::SelectFolderDialog /NOUNLOAD "Please select a target directory" ""
		Pop $0
		${If} $0 == error
			Abort
		${EndIf}
		SendMessage $Page2_AltPresetDir ${WM_SETTEXT} 0 "STR:$0"
	FunctionEnd
	
	Function FilesDir_Browse
		nsDialogs::SelectFolderDialog /NOUNLOAD "Please select a target directory" ""
		Pop $0
		${If} $0 == error
			Abort
		${EndIf}
		SendMessage $Page2_AddFiles ${WM_SETTEXT} 0 "STR:$0"
	FunctionEnd	
	
	Function OnClick_ScanResources
		Pop $0
		Pop $1
		Pop $R0
		Pop $R1
		
		${NSD_GetText} $Page2_PresetDir $0
		${NSD_GetText} $Page2_AddFiles $1
		
		nxs::Show /NOUNLOAD "${PB_NAME}" /top "Scanning for resource files..." /sub "" /h 0 /marquee 20 /end

		StrCpy $R1 0
		
		Scan:
		ClearErrors
		avstools::listresourcefiles "$0" "$visDir"
		${Do}
			Pop $R0
			${If} ${FileExists} "$visDir\$R0"
				${If} $1 == ""
					StrCmp $OUTDIR "$MyTempDir\etc" +2
					SetOutPath "$MyTempDir\etc"
				${ElseIf} $1 != "" #copy to existing addfiles dir
				${AndIf} ${FileExists} "$1\*.*"
					StrCmp $OUTDIR "$1" +2
					SetOutPath $1
				${EndIf}
			#${AndIfNot} ${FileExists} "$OUTDIR\$R0"
				IntOp $R1 $R1 + 1
				CopyFiles /SILENT "$visDir\$R0" "$OUTDIR\$R0"
			${EndIf}
		${LoopUntil} ${Errors}
		
		${If} $BabelScript == "multi"
			${NSD_GetText} $Page2_PresetDir $0
			Goto Scan
		${EndIf}
		
		nxs::Destroy
				
		${If} $1 == ""
		${AndIf} $R1 > 0 #???
			${NSD_SetText} $Page2_AddFiles "$MyTempDir\etc" 
		${EndIf}
		
		Call OnChange_FilesDir
	FunctionEnd
	
	!endif ;PAGE2
	
	!ifdef PAGE3
	Function Page3
	
		${If} $Passive == 1
			Abort
		${EndIf}
		
		${If} $Caption != "" #temp
			SendMessage $HWNDPARENT ${WM_SETTEXT} 0 `STR:${PB_CAPTION} - [$Caption]`
		${EndIf}
		
		!insertmacro MUI_HEADER_TEXT "Looking Good" "Specify icons, checkboxes and other visual elements"
		
		nsDialogs::Create /NOUNLOAD 1018
		
		Pop $Page3_Dialog

		${If} $Page3_Dialog == error
			Abort
		${EndIf}
				
		GetDlgItem $NextButton $HWNDPARENT 1 ; next=1, cancel=2, back=3
		GetDlgItem $BackButton $HWNDPARENT 3 ; next=1, cancel=2, back=3
		${NSD_OnBack} Page3_LoadStatus
		
		${If} $State_UI == "Artwork UI"
			${NSD_CreateLabel} 0 0 305 15 "Cover Artwork (300x300):"
		${Else}
			${NSD_CreateLabel} 0 0 305 15 "Splash Screen:"
		${EndIf}
		Pop $Page3_Splash_Label
			
		${NSD_CreateFileRequest} 0 17 305 20 ""
		Pop $Page3_Splash
		GetFunctionAddress $0 OnChange_Splash
		nsDialogs::OnChange /NOUNLOAD $Page3_Splash $0
		
		${If} $State_SplashBitmap != ""
		${AndIf} ${FileExists} $State_SplashBitmap
			${NSD_SetText} $Page3_Splash "$State_SplashBitmap"
			SetCtlColors $Page3_Splash "" ${COL_VAL}
		${Else}
			
			${If} $State_UI == "Artwork UI"
				SetCtlColors $Page3_Splash "" ${COL_REQ}
				EnableWindow $NextButton 0
				#EnableWindow $BackButton 0			
			${Else}
				SetCtlColors $Page3_Splash "" ""
			${EndIf}
		${EndIf}		
			
		${NSD_CreateButton} 305 17 25 20 "..."
		Pop $Page3_Splash_Button
		GetFunctionAddress $0 Splash_Browse
		nsDialogs::OnClick /NOUNLOAD $Page3_Splash_Button $0
		
		${NSD_CreateLabel} 340 0 110 15 "Transparency:"
		Pop $Page3_Transparency_Label
		
		${NSD_CreateDroplist} 339 17 111 20 ""
		Pop $Page3_Transparency
		SendMessage $Page3_Transparency ${CB_ADDSTRING} 0 "STR:(none)"
		SendMessage $Page3_Transparency ${CB_ADDSTRING} 0 "STR:#ff0000 - Red"
		SendMessage $Page3_Transparency ${CB_ADDSTRING} 0 "STR:#00ff00 - Green"
		SendMessage $Page3_Transparency ${CB_ADDSTRING} 0 "STR:#0000ff - Blue"
		SendMessage $Page3_Transparency ${CB_ADDSTRING} 0 "STR:#00ffff - Cyan"
		SendMessage $Page3_Transparency ${CB_ADDSTRING} 0 "STR:#ff00ff - Magenta"
		SendMessage $Page3_Transparency ${CB_ADDSTRING} 0 "STR:#ffff00 - Yellow"
		
		${If} $State_Transparency == ""
			SendMessage $Page3_Transparency ${CB_FINDSTRINGEXACT} -1 "STR:(none)" $0
			EnableWindow $Page3_Transparency 0
		${Else}
			SendMessage $Page3_Transparency ${CB_FINDSTRINGEXACT} -1 "STR:$State_Transparency" $0
			EnableWindow $Page3_Transparency 1
		${EndIf}
		SendMessage $Page3_Transparency ${CB_SETCURSEL} $0 ""
		
		### ROW 2 ###
		
		${NSD_CreateLabel} 0 45 305 15 "Splash Sound:"
		Pop $Page3_SplashSound_Label
		
		${NSD_CreateDirRequest} 0 62 305 20 ""
		Pop $Page3_SplashSound
		GetFunctionAddress $0 OnChange_SplashSound
		nsDialogs::OnChange /NOUNLOAD $Page3_SplashSound $0
		
		${If} $State_SplashSound != ""
		${AndIf} ${FileExists} $State_SplashSound
			${NSD_SetText} $Page3_SplashSound "$State_SplashSound"
			SetCtlColors $Page3_SplashSound "" ${COL_VAL}
		${EndIf}
	
		${If} $State_SplashBitmap == ""
			EnableWindow $Page3_SplashSound 0
			EnableWindow $Page3_SplashSound_Button 0
			SetCtlColors $Page3_SplashSound "" ""
		${ElseIf} $State_SplashBitmap != ""
		${AndIf} ${FileExists} $State_SplashBitmap
			EnableWindow $Page3_SplashSound 1
			EnableWindow $Page3_SplashSound_Button 1
			EnableWindow $Page3_Transparency 1
		${EndIf}
		
		
		${NSD_CreateButton} 305 62 25 20 "..."
		Pop $Page3_SplashSound_Button
		GetFunctionAddress $0 SplashSound_Browse
		nsDialogs::OnClick /NOUNLOAD $Page3_SplashSound_Button $0
		
		${If} $State_SplashBitmap != ""
		${AndIf} ${FileExists} $State_SplashBitmap
			EnableWindow $Page3_SplashSound_Button 1
		${Else}
			EnableWindow $Page3_SplashSound_Button 0
		${EndIf}		
				
		${NSD_CreateLabel} 340 45 110 15 "Display Time (ms):"
		Pop $Page3_SplashTime_Label
		
		${NSD_CreateText} 340 62 110 20 "2000"
		Pop $Page3_SplashTime
		#EnableWindow $Page3_SplashTime 0
		GetFunctionAddress $0 OnChange_SplashTime
		nsDialogs::OnChange /NOUNLOAD $Page3_SplashTime $0
				
		${If} $State_SplashBitmap == ""
		${AndIf} ${FileExists} $State_SplashBitmap
			EnableWindow $Page3_SplashTime 0
		${Else}
			EnableWindow $Page3_SplashTime 1
		${EndIf}
				
		${If} $State_SplashTime != ""
			${NSD_SetText} $Page3_SplashTime "$State_SplashTime"
		${EndIf}

		Call OnChange_SplashTime
		
		${If} $State_UI == "Artwork UI"
			EnableWindow $Page3_Transparency 0
			SetCtlColors $Page3_Transparency "" ""
			EnableWindow $Page3_SplashSound 0
			SetCtlColors $Page3_SplashSound "" ""
			EnableWindow $Page3_SplashSound_Button 0
			EnableWindow $Page3_SplashTime 0
			SetCtlColors $Page3_SplashTime "" ""
		${EndIf}
		
		### ROW 3 ###
		
		${NSD_CreateLabel} 0 90 305 15 "Icon:"
		Pop $Page3_Icon_Label
		
		${NSD_CreateDirRequest} 0 107 305 20 ""
		Pop $Page3_Icon
		GetFunctionAddress $0 OnChange_Icon
		nsDialogs::OnChange /NOUNLOAD $Page3_Icon $0
		
		${If} $State_Icon != ""
		${AndIf} ${FileExists} $State_Icon
			${NSD_SetText} $Page3_Icon "$State_Icon"
			SetCtlColors $Page3_Icon "" ${COL_VAL}
		${Else}
			SetCtlColors $Page3_Icon "" ""
		${EndIf}	
		
		${NSD_CreateButton} 305 107 25 20 "..."
		Pop $Page3_Icon_Button
		GetFunctionAddress $0 Icon_Browse
		nsDialogs::OnClick /NOUNLOAD $Page3_Icon_Button $0
		
		#.pcicon
		${NSD_CreateLink} 340 110 120 15 ""
		Pop $Page3_Icon_Error
		${NSD_OnClick} $Page3_Icon_Error onClick_IconError
		#ShowWindow $Page3_Icon_Error 0
			
		### ROW 4 ###
		
		${NSD_CreateLabel} 0 135 305 15 "Checkbox Bitmaps:"
		Pop $Page3_Checks_Label
		
		${NSD_CreateDirRequest} 0 152 305 20 ""
		Pop $Page3_Checks
		GetFunctionAddress $0 OnChange_Checks
		nsDialogs::OnChange /NOUNLOAD $Page3_Checks $0
		
		${If} $State_Checks != ""
		${AndIf} ${FileExists} $State_Checks
			${NSD_SetText} $Page3_Checks "$State_Checks"
			SetCtlColors $Page3_Checks "" ${COL_VAL}
		${Else}
			SetCtlColors $Page3_Checks "" ""
		${EndIf}
		
		${NSD_CreateButton} 305 152 25 20 "..."
		Pop $Page3_Checks_Button
		GetFunctionAddress $0 Checks_Browse
		nsDialogs::OnClick /NOUNLOAD $Page3_Checks_Button $0
		
		#.pcchecks
		${NSD_CreateLink} 340 155 120 15 ""
		Pop $Page3_Checks_Error
		${NSD_OnClick} $Page3_Checks_Error onClick_ChecksError
		
		#${NSD_OnClick} $Page6_LogFile_Link onClick_LogFile
		#ShowWindow $Page6_LogFile_Link 0
	
		
		### ROW 5 ###
		
		${NSD_CreateLabel} 0 180 305 15 "Wizard Bitmap:"
		Pop $Page3_Wizard_Label
		
		${NSD_CreateDirRequest} 0 197 305 20 ""
		Pop $Page3_Wizard
		GetFunctionAddress $0 OnChange_Wizard
		nsDialogs::OnChange /NOUNLOAD $Page3_Wizard $0
		
		${If} $State_Wizard != ""
		${AndIf} ${FileExists} $State_Wizard
			${NSD_SetText} $Page3_Wizard "$State_Wizard"
			SetCtlColors $Page3_Wizard "" ${COL_VAL}
		${Else}
			SetCtlColors $Page3_Wizard "" ""
		${EndIf}
				
		${NSD_CreateButton} 305 197 25 20 "..."
		Pop $Page3_Wizard_Button
		GetFunctionAddress $0 Wizard_Browse
		nsDialogs::OnClick /NOUNLOAD $Page3_Wizard_Button $0
		
		${If} $noMUI == 1
			SetCtlColors $Page3_Wizard "" ""
			EnableWindow $Page3_Wizard 0
			EnableWindow $Page3_Wizard_Button 0
		${EndIf}
		
		${If} $State_UI == "Artwork UI"
			SetCtlColors $Page3_Checks "" ""
			EnableWindow $Page3_Checks 0
			EnableWindow $Page3_Checks_Button 0
			SetCtlColors $Page3_Wizard "" ""
			EnableWindow $Page3_Wizard 0
			EnableWindow $Page3_Wizard_Button 0
		${EndIf}
		
		nsDialogs::Show
	FunctionEnd
	
	Function Page3_Leave
		Call Page3_LoadStatus
				
		#PreCompile
		${If} $State_Icon != ""
		${OrIf} $State_Checks != ""
			Delete "$MyTempDir\.pc.*"	
			
			SetOutPath $MyTempDir
			#Icon
			nxs::Show /NOUNLOAD "${PB_NAME}" /top "Pre-compile: validating icon" /sub "" /h 0 /marquee 20 /end
			${If} ${FileExists} $State_Icon
			${AndIf} $State_Icon != ""
				CreateDirectory "$MyTempDir\ui"
				CopyFiles /SILENT "$State_Icon" "$MyTempDir\ui\icon.ico"
			${Else}
				SetOutPath "$MyTempDir\ui"
				!ifndef PUBLIC_SOURCE
					File /oname=icon.ico "ui\icon-nubox_rmx.ico"
				!else
					File /oname=icon.ico "${NSISDIR}\Contrib\Graphics\Icons\classic-install.ico"
				!endif
			${EndIf}
			#SetOutPath $MyTempDir #moved up in 4.1
			File /oname=.pcicon.nsi "_pcicon.nsi"
			!if ${UNICODE} == 2 ;convert script
				${A2U} ENGLISH "$MyTempDir\.pcicon.nsi"
			!endif
			nsExec::Exec '"$NSIS\makensis.exe" /V1 /O"$MyTempDir\.pcicon.log" "$MyTempDir\.pcicon.nsi"'
			
			
			#Checks
			nxs::Update /NOUNLOAD "${PB_NAME}" /top "Pre-compile: validating checkboxes"
			${If} ${FileExists} $State_Checks
			${AndIf} $State_Checks != ""
				CreateDirectory "$MyTempDir\ui"
				CopyFiles /SILENT "$State_Checks" "$MyTempDir\ui\checks.bmp"
			${Else}
				SetOutPath "$MyTempDir\ui"
				!ifndef PUBLIC_SOURCE
					File /oname=checks.bmp "ui\checks-glossy_rmx.bmp"
				!else
					File /oname=checks.bmp "${NSISDIR}\Contrib\Graphics\Checks\modern.bmp"
				!endif
			${EndIf}	
			SetOutPath $MyTempDir			
			File /oname=.pcchecks.nsi "_pcchecks.nsi"	
			!if ${UNICODE} == 2 ;convert script
				${A2U} ENGLISH "$MyTempDir\.pcchecks.nsi"
			!endif
			nsExec::Exec '"$NSIS\makensis.exe" /V1 /O"$MyTempDir\.pcchecks.log" "$MyTempDir\.pcchecks.nsi"'
			
			nxs::Destroy
			
			#Checks Log
			${IfNot} ${FileExists} "$MyTempDir\.pcchecks.exe"
				${FileSearch} "$MyTempDir\.pcchecks.log" "Error: bitmap has more than 8bpp"	
				${If} $0 >= 1
					${NSD_SetText} $Page3_Checks_Error "not 256 colors (8bpp)"
					SetCtlColors $Page3_Checks "" ${COL_INV}
					LockWindow off
				${EndIf}
				
				${FileSearch} "$MyTempDir\.pcchecks.log" "Error: bitmap isn't 96x16 in size"	
				${If} $0 >= 1
					${NSD_SetText} $Page3_Checks_Error "not 96x16 in size"
					SetCtlColors $Page3_Checks "" ${COL_INV}
					LockWindow off
				${EndIf}
				
				${FileSearch} "$MyTempDir\.pcchecks.log" "Error: invalid bitmap file - corrupted or not a bitmap"	
				${If} $0 >= 1
					${NSD_SetText} $Page3_Checks_Error "invalid bitmap file"
					SetCtlColors $Page3_Checks "" ${COL_INV}
					LockWindow off
				${EndIf}
			${EndIf}
			
			#Icon Log
			${IfNot} ${FileExists} "$MyTempDir\.pcicon.exe"
				${FileSearch} "$MyTempDir\.pcicon.log" "invalid icon file"	
				${If} $0 >= 1
					nxs::Destroy
					${NSD_SetText} $Page3_Icon_Error "invalid icon"
					SetCtlColors $Page3_Icon "" ${COL_INV}
					LockWindow off
				${EndIf}
			${EndIf}
			
			${IfNot} ${FileExists} "$MyTempDir\.pcchecks.exe"
			${OrIfNot} ${FileExists} "$MyTempDir\.pcicon.exe"
				EnableWindow $NextButton 0
				EnableWindow $BackButton 0
				Abort
			${EndIf}		
			
			Delete "$MyTempDir\.pc*.*"
		${EndIf}
		
		${If} $DebugLevel >= 2
			MessageBox MB_OK|MB_ICONINFORMATION "Splash Screen=$State_SplashBitmap$\nTransparency=$State_Transparency$\nSplash Sound=$State_SplashSound$\nDisplay Time=$State_SplashTime$\nIcon=$State_Icon$\nCheckbox=$State_Checks$\nWizard=$State_Wizard"
		${EndIf}
	FunctionEnd
	
	Function Page3_LoadStatus
		${NSD_GetText} $Page3_Splash $State_SplashBitmap
		${NSD_GetText} $Page3_Transparency $State_Transparency
		${NSD_GetText} $Page3_SplashSound $State_SplashSound
		${NSD_GetText} $Page3_SplashTime $State_SplashTime
		${NSD_GetText} $Page3_Icon $State_Icon
		${NSD_GetText} $Page3_Checks $State_Checks
		${NSD_GetText} $Page3_Wizard $State_Wizard
		
		/*
		Push "${NUMERIC}"
		Push "$State_SplashTime"
		Call StrCSpnReverse
		Pop $0
		${If} $0 != ""
			MessageBox MB_OK|MB_ICONEXCLAMATION "The specified Splash Time is not an integer."
			SetCtlColors $Page3_SplashTime "" ${COL_INV}
			Abort
		${EndIf}
		*/
	FunctionEnd
		
		
	Function OnChange_Splash
		Pop $0 # HWND
		Pop $1 # HWND
		Pop $2 # HWND
		Pop $R0 # HWND
		
		${NSD_GetText} $Page3_Splash $0
		${NSD_GetText} $Page3_SplashTime $1
		#${NSD_GetText} $Page3_Transparency $2
		
		${If} $0 == ""
			${If} $State_UI == "Artwork UI"
				SetCtlColors $Page3_Splash "" ${COL_REQ}
				EnableWindow $NextButton 0
				#EnableWindow $BackButton 0
			${Else}
				SetCtlColors $Page3_Splash "" ""
				Call Disable_Splash
			${EndIf}
		${ElseIf} ${FileExists} "$0"
			${GetFileExt} $0 $R0
			StrCmp $R0 "bmp" 0 invalid_Splash
			SetCtlColors $Page3_Splash "" ${COL_VAL}
			${If} $State_UI == "Artwork UI"
				EnableWindow $NextButton 1
				EnableWindow $BackButton 1
			${Else}
				${If} $1 == ""
					SetCtlColors $Page3_SplashTime "" ${COL_REQ}
				${ElseIf} $1 != ""
					SetCtlColors $Page3_SplashTime "" ${COL_VAL}
		
					#Transparency
					${GetBaseName} $0 $2
					${If} $2 == "#f00" #red
					${OrIf} $2 == "#ff0000"
						SendMessage $Page3_Transparency ${CB_FINDSTRINGEXACT} -1 "STR:#ff0000 - Red" $2
					${ElseIf} $2 == "#0f0" #green
					${OrIf} $2 == "#00ff00"
						SendMessage $Page3_Transparency ${CB_FINDSTRINGEXACT} -1 "STR:#00ff00 - Green" $2
					${ElseIf} $2 == "#00f" #blue
					${OrIf} $2 == "#0000ff"
						SendMessage $Page3_Transparency ${CB_FINDSTRINGEXACT} -1 "STR:#0000ff - Blue" $2			
					${ElseIf} $2 == "#0ff" #cyan
					${OrIf} $2 == "#00ffff"
						SendMessage $Page3_Transparency ${CB_FINDSTRINGEXACT} -1 "STR:#00ffff - Cyan" $2
					${ElseIf} $2 == "#f0f" #magenta
					${OrIf} $2 == "#ff00ff"
						SendMessage $Page3_Transparency ${CB_FINDSTRINGEXACT} -1 "STR:#ff00ff - Magenta" $2
					${ElseIf} $2 == "#ff0" #yellow
					${OrIf} $2 == "#ffff00"
						SendMessage $Page3_Transparency ${CB_FINDSTRINGEXACT} -1 "STR:#ffff00 - Yellow" $2
					${Else}
						Goto enable_Splash
					${EndIf}
					SendMessage $Page3_Transparency ${CB_SETCURSEL} $2 ""
				${EndIf}
			${EndIf}
			
						
			enable_Splash:
			StrCmp $State_UI "Artwork UI" +2
			Call Enable_Splash
		${ElseIfNot} ${FileExists} "$0"
			invalid_Splash:
			SetCtlColors $Page3_Splash "" ${COL_INV}
			Call Disable_Splash
		${EndIf}
		Call Page3_Next		
	FunctionEnd	
	
	Function Enable_Splash
		EnableWindow $Page3_Transparency 1
		#${NSD_SetState} $Page3_Transparency 1
		EnableWindow $Page3_SplashSound 1
		EnableWindow $Page3_SplashSound_Button 1
		#${NSD_SetState} $Page3_SplashSound 1
		EnableWindow $Page3_SplashTime 1
		#${NSD_SetState} $Page3_SplashTime 1	
	FunctionEnd
	
	Function Disable_Splash
		EnableWindow $Page3_Transparency 0
		#${NSD_SetState} $Page3_Transparency 0
		EnableWindow $Page3_SplashSound 0
		EnableWindow $Page3_SplashSound_Button 0
		SetCtlColors $Page3_SplashSound "" ""
		#${NSD_SetState} $Page3_SplashSound 0
		EnableWindow $Page3_SplashTime 0
		SetCtlColors $Page3_SplashTime "" ""
		#${NSD_SetState} $Page3_SplashTime 0
	FunctionEnd
	
	Function Splash_Browse
		nsDialogs::SelectFileDialog LOAD "" "All Bitmaps|*.bmp"
		Pop $0
		${If} $0 == error
			Abort
		${EndIf}
		SendMessage $Page3_Splash ${WM_SETTEXT} 0 "STR:$0"
	FunctionEnd
	
	Function OnChange_SplashSound
		Pop $0 # HWND
		Pop $1 # HWND
		Pop $2 # HWND
		
		${NSD_GetText} $Page3_SplashSound $0
		
		${If} $0 == ""
			SetCtlColors $Page3_SplashSound "" ""
			#Call Disable_Splash
		${ElseIf} ${FileExists} "$0"
			${GetFileExt} $0 $1
			StrCmp $1 "wav" 0 invalid_Sound
			SetCtlColors $Page3_SplashSound "" ${COL_VAL}
			${GetBasename} $0 $1
			Push "${NUMERIC}"
			Push "$1"
			Call StrCSpnReverse
			Pop $2
			${If} $2 == ""
				SendMessage $Page3_SplashTime ${WM_SETTEXT} 0 "STR:$1"
			${EndIf}
			#Call Enable_Splash
		${ElseIfNot} ${FileExists} "$0"
			invalid_Sound:
			SetCtlColors $Page3_SplashSound "" ${COL_INV}
			#Call Disable_Splash
		${EndIf}
		Call Page3_Next		
	FunctionEnd	
	
	Function SplashSound_Browse
		nsDialogs::SelectFileDialog LOAD "" "All Wave Files|*.wav"
		Pop $0
		${If} $0 == error
			Abort
		${EndIf}
		SendMessage $Page3_SplashSound ${WM_SETTEXT} 0 "STR:$0"
	FunctionEnd
	
	Function OnChange_SplashTime
		Pop $0 # HWND
		Pop $1 # HWND
		Pop $2 # HWND
		${NSD_GetText} $Page3_SplashTime $0
		${NSD_GetText} $Page3_Splash $1
		
		StrCpy $2 $0 1
		
		${If} $1 == ""
		${AndIf} $0 == ""
			SetCtlColors $Page3_SplashTime "" ""
			#Call Disable_Splash
		${ElseIf} ${FileExists} "$1"
		#${AndIf} $1 != ""
		${AndIf} $0 != ""
			Push "${NUMERIC}"
			Push "$0"
			Call StrCSpnReverse
			Pop $0
			${If} $0 != ""
			${OrIf} $2 == "0"
				SetCtlColors $Page3_SplashTime "" ${COL_INV}
				EnableWindow $NextButton 0
				EnableWindow $BackButton 0
				LockWindow off
				Abort
			${Else}
				SetCtlColors $Page3_SplashTime "" ${COL_VAL}
				EnableWindow $NextButton 1
				EnableWindow $BackButton 1
			${EndIf}
			
			#Call Enable_Splash
		${ElseIf} ${FileExists} "$1"
		${AndIf} $0 == ""
			SetCtlColors $Page3_SplashTime "" ${COL_REQ}
		${EndIf}
		Call Page3_Next		
	FunctionEnd	
	
	Function Icon_Browse
		Pop $0
		
		${NSD_GetText} $Page3_Icon $0
		
		${If} $0 == ""
			nsDialogs::SelectFileDialog LOAD "$EXEDIR\ui\" "All Icons|*.ico|PimpBot Icons|icon*.ico" #order on purpose!
		${Else}
			nsDialogs::SelectFileDialog LOAD "$0" "All Icons|*.ico|PimpBot Icons|icon*.ico"
		${EndIf}
		
		Pop $1
		${If} $1 == ""
			Abort
		${EndIf}

		SendMessage $Page3_Icon ${WM_SETTEXT} 0 "STR:$1"
	FunctionEnd
	
	Function OnChange_Icon
		Pop $0 # HWND
		${NSD_GetText} $Page3_Icon $0
			
		${If} $0 == ""
			SetCtlColors $Page3_Icon "" ""
			${NSD_SetText} $Page3_Icon_Error ""
			Delete "$MyTempDir\ui\icon.ico" #temp?
			#Call Disable_Splash
		${ElseIf} ${FileExists} "$0"
			${GetFileExt} $0 $0
			StrCmp $0 "ico" 0 invalid_Icon
			SetCtlColors $Page3_Icon "" ${COL_VAL}
			${NSD_SetText} $Page3_Icon_Error ""
			#Call Enable_Splash
		${ElseIfNot} ${FileExists} "$0"
		${OrIf} $1 != "ico"
			invalid_Icon:
			SetCtlColors $Page3_Icon "" ${COL_INV}
			#Call Disable_Splash
		${EndIf}
		Call Page3_Next		
	FunctionEnd	
	
	Function onClick_IconError
		Pop $0
		ExecShell open "http://nsis.sourceforge.net/Docs/Chapter4.html#4.8.1.18"
	FunctionEnd
	
	Function Checks_Browse
		Pop $0
		
		${NSD_GetText} $Page3_Checks $0
		
		${If} $0 == ""
			nsDialogs::SelectFileDialog LOAD "$EXEDIR\ui\" "PimpBot Bitmaps|check*.bmp|All Bitmaps|*.bmp"
		${Else}
			nsDialogs::SelectFileDialog LOAD "$0" "All Bitmaps|*.bmp|PimpBot Bitmaps|check*.bmp"
		${EndIf}
		
		Pop $1
		${If} $1 == ""
			Abort
		${EndIf}

		SendMessage $Page3_Checks ${WM_SETTEXT} 0 "STR:$1"
	FunctionEnd
	
	Function OnChange_Checks
		Pop $0 # HWND
		${NSD_GetText} $Page3_Checks $0
		
		${If} $0 == ""
			SetCtlColors $Page3_Checks "" ""
			${NSD_SetText} $Page3_Checks_Error ""
			Delete "$MyTempDir\ui\checks.bmp" #temp?
			#Call Disable_Splash
		${ElseIf} ${FileExists} "$0"
			${GetFileExt} $0 $0
			StrCmp $0 "bmp" 0 invalid_Checks
			SetCtlColors $Page3_Checks "" ${COL_VAL}
			${NSD_SetText} $Page3_Checks_Error ""
			#Call Enable_Splash
		${ElseIfNot} ${FileExists} "$0"
			invalid_Checks:
			SetCtlColors $Page3_Checks "" ${COL_INV}
			#Call Disable_Splash
		${EndIf}
		Call Page3_Next		
	FunctionEnd	
	
	Function onClick_ChecksError
		Pop $0
		ExecShell open "http://nsis.sourceforge.net/Docs/Chapter4.html#4.8.1.9"
	FunctionEnd
	
	Function Wizard_Browse
		Pop $0
		
		${NSD_GetText} $Page3_Wizard $0
		
		${If} $0 == ""
			nsDialogs::SelectFileDialog LOAD "$EXEDIR\ui\" "PimpBot Wizard Bitmaps|wizard*.bmp|All Bitmaps|*.bmp"
		${Else}
			nsDialogs::SelectFileDialog LOAD "$0" "All Bitmaps|*.bmp|PimpBot Wizard Bitmaps|wizard*.bmp"
		${EndIf}
		
		Pop $1
		${If} $1 == ""
			Abort
		${EndIf}

		SendMessage $Page3_Wizard ${WM_SETTEXT} 0 "STR:$1"
	FunctionEnd
	
	Function OnChange_Wizard
		Pop $0 # HWND
		${NSD_GetText} $Page3_Wizard $0
		
		${If} $0 == ""
			SetCtlColors $Page3_Wizard "" ""
			#Call Disable_Splash
		${ElseIf} ${FileExists} "$0"
			${GetFileExt} $0 $0
			StrCmp $0 "bmp" 0 invalid_Wizard
			SetCtlColors $Page3_Wizard "" ${COL_VAL}
			#Call Enable_Splash
		${ElseIfNot} ${FileExists} "$0"
			invalid_Wizard:
			SetCtlColors $Page3_Wizard "" ${COL_INV}
			#Call Disable_Splash
		${EndIf}
		Call Page3_Next		
	FunctionEnd
	
	Function Page3_Next
		Pop $R0 # HWND
		Pop $R1 # HWND
		Pop $R2 # HWND
		Pop $R3 # HWND
		Pop $R4 # HWND
		Pop $R5 # HWND
		Pop $R6 # HWND
		Pop $1 # HWND
		Pop $2 # HWND
		Pop $3 # HWND
		Pop $4 # HWND
		Pop $5 # HWND
		Pop $6 # HWND
		
		#StrCpy $1 $V
		${NSD_GetText} $Page3_Splash $1
		${NSD_GetText} $Page3_SplashSound $2		#optional
		${NSD_GetText} $Page3_SplashTime $3
		${NSD_GetText} $Page3_Icon $4
		${NSD_GetText} $Page3_Checks $5
		${NSD_GetText} $Page3_Wizard $6
		

		${GetFileExt} $1 $R1
		${GetFileExt} $2 $R2
		${GetFileExt} $4 $R4
		${GetFileExt} $5 $R5
		${GetFileExt} $6 $R6
		
		StrCpy $R0 0
		
		${If} ${FileExists} "$1" #Splash
		${AndIf} $R1 == "bmp"
		${OrIf} $1 == ""
			${If} $State_UI == "Artwork UI"
			${AndIf} $1 == ""
				StrCpy $R1 0
			${Else}
				StrCpy $R1 1
			${EndIf}
		${Else}
			StrCpy $R1 0
		${EndIf}
		
		${If} ${FileExists} "$2" #SplashSound
		${AndIf} $R2 == "wav"
		${OrIf} $2 == ""
			StrCpy $R2 1
		${Else}
			StrCpy $R2 0
		${EndIf}
				
		${If} $3 == "" #SplashTime
			StrCpy $R3 0
		${Else}
			StrCpy $R3 1
		${EndIf}
		
		${If} ${FileExists} "$4" #Icon
		${AndIf} $R4 == "ico"
		${OrIf} $4 == ""
			StrCpy $R4 1
		${Else}
			StrCpy $R4 0
		${EndIf}
		
		${If} ${FileExists} "$5" #Checks
		${AndIf} $R5 == "bmp"
		${OrIf} $5 == ""
			StrCpy $R5 1
		${Else}
			StrCpy $R5 0
		${EndIf}
		
		${If} ${FileExists} "$6" #Wizard
		${AndIf} $R6 == "bmp"
		${OrIf} $6 == ""
			StrCpy $R6 1
		${Else}
			StrCpy $R6 0
		${EndIf}
				
		IntOp $R0 $R0 + $R1
		IntOp $R0 $R0 + $R2
		IntOp $R0 $R0 + $R3
		IntOp $R0 $R0 + $R4
		IntOp $R0 $R0 + $R5
		IntOp $R0 $R0 + $R6
		
		${If} $R0 == 6
			EnableWindow $NextButton 1
			EnableWindow $BackButton 1
		${Else}
			EnableWindow $NextButton 0
			EnableWindow $BackButton 0
		${EndIf}
		LockWindow off
	FunctionEnd
	
	!endif ;PAGE3
	
	!ifdef PAGE4
	Function Page4
	
		${If} $Passive == 1
			Abort
		${EndIf}
		
		${If} $Caption != "" #temp
			SendMessage $HWNDPARENT ${WM_SETTEXT} 0 `STR:${PB_CAPTION} - [$Caption]`
		${EndIf}
		
		!insertmacro MUI_HEADER_TEXT "This && That" "Choose additional files and settings for your installer"
		
		nsDialogs::Create /NOUNLOAD 1018
		
		Pop $Page4_Dialog

		${If} $Page4_Dialog == error
			Abort
		${EndIf}
		
		GetDlgItem $NextButton $HWNDPARENT 1 ; next=1, cancel=2, back=3
		GetDlgItem $BackButton $HWNDPARENT 3 ; next=1, cancel=2, back=3
		${NSD_OnBack} Page4_LoadStatus
		
		### ROW 1 ###
		
		${NSD_CreateLabel} 0 0 305 15 "License Text:"
		Pop $Page4_LicenseFile_Label
		
		${NSD_CreateFileRequest} 0 17 305 20 ""
		Pop $Page4_LicenseFile
		GetFunctionAddress $0 OnChange_LicenseFile
		nsDialogs::OnChange /NOUNLOAD $Page4_LicenseFile $0
		
		${If} $State_License != ""
		${AndIf} ${FileExists} $State_License
			${NSD_SetText} $Page4_LicenseFile "$State_License"
			#SetCtlColors $Page4_LicenseFile "" ${COL_VAL}
			Call OnChange_LicenseFile
		${Else}
			SetCtlColors $Page4_LicenseFile "" ""
		${EndIf}
		
		${NSD_CreateButton} 305 17 25 20 "..."
		Pop $Page4_LicenseFile_Button
		GetFunctionAddress $0 LicenseFile_Browse
		nsDialogs::OnClick /NOUNLOAD $Page4_LicenseFile_Button $0
		
		${NSD_CreateLabel} 340 0 110 15 "Creative Commons:"
		Pop $Page4_CC_Label
				
		${NSD_CreateDroplist} 339 16 80 20 ""
		Pop $Page4_CC
		ToolTips::Classic $Page4_CC "Choose from a list of available licenses"
		GetFunctionAddress $0 OnChange_CC
		nsDialogs::OnChange /NOUNLOAD $Page4_CC $0
		
		SendMessage $Page4_CC ${CB_ADDSTRING} 0 "STR:(none)"
		IfFileExists "$EXEDIR\licenses\by.rtf" 0 +2
		SendMessage $Page4_CC ${CB_ADDSTRING} 0 "STR:cc by"
		IfFileExists "$EXEDIR\licenses\by-sa.rtf" 0 +2
		SendMessage $Page4_CC ${CB_ADDSTRING} 0 "STR:cc by-sa"
		IfFileExists "$EXEDIR\licenses\by-nd.rtf" 0 +2
		SendMessage $Page4_CC ${CB_ADDSTRING} 0 "STR:cc by-nd"
		IfFileExists "$EXEDIR\licenses\by-nc.rtf" 0 +2
		SendMessage $Page4_CC ${CB_ADDSTRING} 0 "STR:cc by-nc"
		IfFileExists "$EXEDIR\licenses\by-nc-sa.rtf" 0 +2
		SendMessage $Page4_CC ${CB_ADDSTRING} 0 "STR:cc by-nc-sa"
		IfFileExists "$EXEDIR\licenses\by-nc-nd.rtf" 0 +2
		SendMessage $Page4_CC ${CB_ADDSTRING} 0 "STR:cc by-nc-nd"
		
		
		#SendMessage $Page4_CC ${CB_FINDSTRINGEXACT} -1 "STR:(none)" $0
		#SendMessage $Page4_CC ${CB_SETCURSEL} $0 ""
		
		${NSD_CreateButton} 424 17 25 20 "?"
		Pop $Page4_CC_Button
		ToolTips::Classic $Page4_CC_Button "More information on the selected license"		
		GetFunctionAddress $0 OnClick_CC_Button
		nsDialogs::OnClick /NOUNLOAD $Page4_CC_Button $0
		
		${If} $State_CreativeCommons == "cc by"
		${OrIf} $State_CreativeCommons == "cc by-sa"
		${OrIf} $State_CreativeCommons == "cc by-nd"
		${OrIf} $State_CreativeCommons == "cc by-nc"
		${OrIf} $State_CreativeCommons == "cc by-nc-sa"
		${OrIf} $State_CreativeCommons == "cc by-nc-nd"
			SendMessage $Page4_CC ${CB_FINDSTRINGEXACT} -1 "STR:$State_CreativeCommons" $0
			SendMessage $Page4_CC ${CB_SETCURSEL} $0 ""
			EnableWindow $Page4_CC_Button 1
			Call OnChange_CC
		${Else}
			SendMessage $Page4_CC ${CB_FINDSTRINGEXACT} -1 "STR:(none)" $0
			SendMessage $Page4_CC ${CB_SETCURSEL} $0 ""
			EnableWindow $Page4_CC_Button 0
		${EndIf}
		
		### ROW 2 ###
		
		${NSD_CreateLabel} 0 45 305 15 "Fonts:"
		Pop $Page4_Fonts_Label
		
		${NSD_CreateFileRequest} 0 62 305 20 ""
		Pop $Page4_Fonts
		GetFunctionAddress $0 OnChange_Fonts
		nsDialogs::OnChange /NOUNLOAD $Page4_Fonts $0
		
		${If} $State_Fonts != ""
		${AndIf} ${FileExists} "$State_Fonts\*.ttf"
		${OrIf} ${FileExists} "$State_Fonts\*.otf"
			${NSD_SetText} $Page4_Fonts "$State_Fonts"
			#SetCtlColors $Page4_Fonts "" ${COL_VAL}
			Call OnChange_Fonts
		${Else}
			SetCtlColors $Page4_Fonts "" ""
		${EndIf}
		
		${NSD_CreateButton} 305 62 25 20 "..."
		Pop $Page4_Fonts_Button
		GetFunctionAddress $0 Fonts_Browse
		nsDialogs::OnClick /NOUNLOAD $Page4_Fonts_Button $0
		
		${IfNot} ${FileExists} "$NSIS\Plugins\FontName.dll"
			EnableWindow $Page4_Fonts 0
			EnableWindow $Page4_Fonts_Button 0
			${NSD_SetText} $Page4_Fonts ""
		${Else} ;allows fixing on runtime
			EnableWindow $Page4_Fonts 1
			EnableWindow $Page4_Fonts_Button 1
		${EndIf}
		
		### ROW 3 ###
		
		${NSD_CreateLabel} 0 90 223 15 "Website Address:"
		Pop $Page4_Website_Label
		
		${NSD_CreateText} 0 107 223 20 "http://"
		Pop $Page4_Website
		GetFunctionAddress $0 OnChange_Website
		nsDialogs::OnChange /NOUNLOAD $Page4_Website $0
		
		StrLen $0 $State_WebsiteURL
		
		/*
		${If} $State_WebsiteURL != ""
		${AndIf} $0 >= 12
			${NSD_SetText} $Page4_Website "$State_WebsiteURL"
			SetCtlColors $Page4_Website "" ${COL_VAL}
		${Else}
			SetCtlColors $Page4_Website "" ""
		${EndIf}
		*/
		
		${NSD_CreateLabel} 227 90 223 15 "Website Name:"
		Pop $Page4_WebsiteName_Label
		
		${NSD_CreateText} 227 107 223 20 "My Website"
		Pop $Page4_WebsiteName
		GetFunctionAddress $0 OnChange_Website
		nsDialogs::OnChange /NOUNLOAD $Page4_WebsiteName $0
		
		${If} $State_WebsiteURL != ""
		${AndIf} $State_WebsiteURL != "http://"
			${NSD_SetText} $Page4_Website "$State_WebsiteURL"
			#SetCtlColors $Page4_Website "" ${COL_VAL}
			Call OnChange_Website
			${If} $State_WebsiteName != ""
			${AndIf} $State_WebsiteURL != "http://"
			#${AndIf} $State_UI != "Artwork UI"
				${NSD_SetText} $Page4_WebsiteName "$State_WebsiteName"
				StrCmp $State_UI "Artwork UI" +2
				SetCtlColors $Page4_WebsiteName "" ${COL_VAL}
			${Else}
				${NSD_SetText} $Page4_WebsiteName "Visit My Website"
				${If} $State_WebsiteURL != ""
				${AndIf} $State_WebsiteURL != "http://"
					SetCtlColors $Page4_WebsiteName "" ${COL_VAL}
				${Else}
					SetCtlColors $Page4_WebsiteName "" ${COL_REQ}
				${EndIf}
			${EndIf}
		${Else}
			SetCtlColors $Page4_Website "" ""
			SetCtlColors $Page4_WebsiteName "" ""
			EnableWindow $Page4_WebsiteName 0
		${EndIf}
		
		### ROW 4 & 5 ###
		
		${NSD_CreateCheckbox} 0 152 115 15 "&Multilingual Setup"
		Pop $Page4_Multilingual
		${If} $State_Multilingual == 1
			${NSD_SetState} $Page4_Multilingual 1
		${Else}
			${NSD_SetState} $Page4_Multilingual 0
		${EndIf}
				
		${If} $State_PresetType == "avs"
			${NSD_CreateCheckbox} 115 172 120 15 "&Settings Page"
			Pop $Page4_Settings
			ToolTips::Classic $Page4_Settings "Include a page to tweak AVS settings"
			${If} $State_Settings == 1
				${NSD_SetState} $Page4_Settings 1
			${Else}
				${NSD_SetState} $Page4_Settings 0
			${EndIf}
		${EndIf}	

		${NSD_CreateCheckbox} 230 152 100 15 "&AutoClose"
		
		Pop $Page4_AutoClose
		ToolTips::Classic $Page4_AutoClose "Installer will close the log window and jump to the final page"
		${If} $State_AutoClose == 1
			${NSD_SetState} $Page4_AutoClose 1
		${Else}
			${NSD_SetState} $Page4_AutoClose 0
		${EndIf}
		
		${NSD_CreateCheckbox} 115 152 120 15 "&Components Page"
		Pop $Page4_Components
		ToolTips::Classic $Page4_Components "Include a page to choose which components to install"
		${If} $State_Components == 1
		${OrIf} $State_Components == ""
			${NSD_SetState} $Page4_Components 1
		${Else}
			${NSD_SetState} $Page4_Components 0
		${EndIf}
		
		/*
		${If} $noMUI == 1
			EnableWindow $Page4_Settings 0
		${Else}
			EnableWindow $Page4_Settings 1
		${EndIf}
		*/
		
		${If} $State_UI == "Artwork UI"
			EnableWindow $Page4_Website 0
			EnableWindow $Page4_WebsiteName 0
			EnableWindow $Page4_Multilingual 0
			EnableWindow $Page4_Components 0
			EnableWindow $Page4_Settings 0
			EnableWindow $Page4_AutoClose 0
		/*
		${ElseIf} $State_UI == "Basic UI"
			EnableWindow $Page4_Multilingual 1
			EnableWindow $Page4_Components 1
			EnableWindow $Page4_Settings 1
			EnableWindow $Page4_AutoClose 1
		*/
		${Else}
			EnableWindow $Page4_Website 1
			EnableWindow $Page4_WebsiteName 1
			${If} $BabelScript == "single"
				EnableWindow $Page4_Multilingual 0
			${Else} ;not sure if this line will ever get called
				EnableWindow $Page4_Multilingual 1
			${EndIf}
			EnableWindow $Page4_Components 1
			EnableWindow $Page4_Settings 1
			EnableWindow $Page4_AutoClose 1
		${EndIf}
			
		SendMessage $Page4_Dialog ${WM_SETFOCUS} $HWNDPARENT 0 #shortcuts
		nsDialogs::Show
	FunctionEnd
	
	Function Page4_Leave		
		Call Page4_LoadStatus
		
		${If} $DebugLevel >= 2
			MessageBox MB_OK|MB_ICONINFORMATION "License=$State_License$\nCreative Commons=$State_CreativeCommons$\nFonts=$State_Fonts$\nWeb URL=$State_WebsiteURL$\nWeb Name=$State_WebsiteURL$\nMultilingual=$State_Multilingual$\nComponents Page=$State_Components$\nSettings Page=$State_Settings$\nAutoClose=$State_AutoClose"
		${EndIf}
	FunctionEnd
	
	Function Page4_LoadStatus
		${NSD_GetText} $Page4_LicenseFile $State_License 
		${NSD_GetText} $Page4_CC $State_CreativeCommons
		${NSD_GetText} $Page4_Fonts $State_Fonts
		${NSD_GetText} $Page4_Website $State_WebsiteURL
		${NSD_GetText} $Page4_WebsiteName $State_WebsiteName
		${NSD_GetState} $Page4_Multilingual $State_Multilingual
		${NSD_GetState} $Page4_Components $State_Components
		${NSD_GetState} $Page4_Settings $State_Settings
		${NSD_GetState} $Page4_AutoClose $State_AutoClose
	FunctionEnd
	
	Function OnChange_LicenseFile
		Pop $0 #HWND
		Pop $R0 #HWND
		
		${NSD_GetText} $Page4_LicenseFile $0
		
		${If} $0 == ""
			SetCtlColors $Page4_LicenseFile "" ""
			SendMessage $Page4_CC ${CB_FINDSTRINGEXACT} -1 "STR:(none)" $0
			SendMessage $Page4_CC ${CB_SETCURSEL} $0 ""
			EnableWindow $Page4_CC_Button 0
			#Call Disable_Splash
		${ElseIf} ${FileExists} "$0"
			${GetFileExt} $0 $R0
			${If} $R0 != "txt"
			${AndIf} $R0 != "rtf"
				Goto invalid_License
			${EndIf}
			SetCtlColors $Page4_LicenseFile "" ${COL_VAL}
			#Call Enable_Splash
		${ElseIfNot} ${FileExists} "$0"
			invalid_License:
			 SetCtlColors $Page4_LicenseFile "" ${COL_INV}
			#Call Disable_Splash
		${EndIf}
		
		${If} $0 == "$EXEDIR\licenses\by.rtf"
			SendMessage $Page4_CC ${CB_FINDSTRINGEXACT} -1 "STR:cc by" $0
			SendMessage $Page4_CC ${CB_SETCURSEL} $0 ""
		${ElseIf} $0 == "$EXEDIR\licenses\by-sa.rtf"
			SendMessage $Page4_CC ${CB_FINDSTRINGEXACT} -1 "STR:cc by-sa" $0
			SendMessage $Page4_CC ${CB_SETCURSEL} $0 ""
		${ElseIf} $0 == "$EXEDIR\licenses\by-nd.rtf"
			SendMessage $Page4_CC ${CB_FINDSTRINGEXACT} -1 "STR:cc by-nd" $0
			SendMessage $Page4_CC ${CB_SETCURSEL} $0 ""
		${ElseIf} $0 == "$EXEDIR\licenses\by-nc.rtf"
			SendMessage $Page4_CC ${CB_FINDSTRINGEXACT} -1 "STR:cc by-nc" $0
			SendMessage $Page4_CC ${CB_SETCURSEL} $0 ""
		${ElseIf} $0 == "$EXEDIR\licenses\by-nc-sa.rtf"
			SendMessage $Page4_CC ${CB_FINDSTRINGEXACT} -1 "STR:cc by-nc-sa" $0
			SendMessage $Page4_CC ${CB_SETCURSEL} $0 ""
		${ElseIf} $0 == "$EXEDIR\licenses\by-nc-nd.rtf"
			SendMessage $Page4_CC ${CB_FINDSTRINGEXACT} -1 "STR:cc by-nc-nd" $0
			SendMessage $Page4_CC ${CB_SETCURSEL} $0 ""
		${Else}
			SendMessage $Page4_CC ${CB_FINDSTRINGEXACT} -1 "STR:(none)" $0
			SendMessage $Page4_CC ${CB_SETCURSEL} $0 ""
			EnableWindow $Page4_CC_Button 0
		${EndIf}
		
		Call Page4_Next
	FunctionEnd
	
	Function LicenseFile_Browse	
		nsDialogs::SelectFileDialog LOAD "" "Supported files|*.rtf;*.txt"
		Pop $0
	
		${If} $0 == ""
			Abort
		${EndIf}
		
		SendMessage $Page4_LicenseFile ${WM_SETTEXT} 0 "STR:$0"
	FunctionEnd
	
	Function OnChange_CC
		Pop $0 #HWND
		${NSD_GetText} $Page4_CC $0
				
		${If} $0 == (none)
			EnableWindow $Page4_CC_Button 0
			${NSD_SetText} $Page4_LicenseFile ""
		${Else}
			EnableWindow $Page4_CC_Button 1
		${EndIf}
		
		${If} $0 == "cc by"
			${NSD_SetText} $Page4_LicenseFile "$EXEDIR\licenses\by.rtf"
		${ElseIf} $0 == "cc by-sa"
			${NSD_SetText} $Page4_LicenseFile "$EXEDIR\licenses\by-sa.rtf"
		${ElseIf} $0 == "cc by-nd"
			${NSD_SetText} $Page4_LicenseFile "$EXEDIR\licenses\by-nd.rtf"
		${ElseIf} $0 == "cc by-nc"
			${NSD_SetText} $Page4_LicenseFile "$EXEDIR\licenses\by-nc.rtf"
		${ElseIf} $0 == "cc by-nc-sa"
			${NSD_SetText} $Page4_LicenseFile "$EXEDIR\licenses\by-nc-sa.rtf"
		${ElseIf} $0 == "cc by-nc-nd"
			${NSD_SetText} $Page4_LicenseFile "$EXEDIR\licenses\by-nc-nd.rtf"
		${EndIf}
		
	FunctionEnd
	
	Function OnClick_CC_Button
		Pop $0 #HWND
		${NSD_GetText} $Page4_CC $0
		
		${If} $0 == "cc by"
			MessageBox MB_YESNO|MB_DEFBUTTON2|MB_ICONINFORMATION "Creative Commons Attribution 3.0$\n$\nDo you want to view the license?" IDNO +2
			ExecShell open "$EXEDIR\licenses\by.rtf"
		${ElseIf} $0 == "cc by-sa"
			MessageBox MB_YESNO|MB_DEFBUTTON2|MB_ICONINFORMATION "Creative Commons Attribution Share Alike 3.0$\n$\nDo you want to view the license?" IDNO +2
			ExecShell open "$EXEDIR\licenses\by-sa.rtf"
		${ElseIf} $0 == "cc by-nd"
			MessageBox MB_YESNO|MB_DEFBUTTON2|MB_ICONINFORMATION "Creative Commons Attribution No Derivatives 3.0$\n$\nDo you want to view the license?" IDNO +2
			ExecShell open "$EXEDIR\licenses\by-nd.rtf"
		${ElseIf} $0 == "cc by-nc"
			MessageBox MB_YESNO|MB_DEFBUTTON2|MB_ICONINFORMATION "Creative Commons Attribution Non-Commercial 3.0$\n$\nDo you want to view the license?" IDNO +2
			ExecShell open "$EXEDIR\licenses\by-nc.rtf"
		${ElseIf} $0 == "cc by-nc-sa"
			MessageBox MB_YESNO|MB_DEFBUTTON2|MB_ICONINFORMATION "Creative Commons Attribution Non-Commercial Share Alike 3.0$\n$\nDo you want to view the license?" IDNO +2
			ExecShell open "$EXEDIR\licenses\by-nc-sa.rtf"
		${ElseIf} $0 == "cc by-nc-nd"
			MessageBox MB_YESNO|MB_DEFBUTTON2|MB_ICONINFORMATION "Creative Commons Attribution Non-Commercial No Derivatives 3.0$\n$\nDo you want to view the license?" IDNO +2
			ExecShell open "$EXEDIR\licenses\by-nc-nd.rtf"
		${EndIf}
	FunctionEnd
	
	Function OnChange_Fonts
		Pop $0 #HWND
		${NSD_GetText} $Page4_Fonts $0
		
		${If} $0 == ""
			SetCtlColors $Page4_Fonts "" ""
			#Call Disable_Splash
		${ElseIf} ${FileExists} "$0\*.ttf"
		${OrIf} ${FileExists} "$0\*.otf"
			SetCtlColors $Page4_Fonts "" ${COL_VAL}
			#Call Enable_Splash
		${ElseIfNot} ${FileExists} "$0\*.ttf"
		${AndIfNot} ${FileExists} "$0\*.otf"
			SetCtlColors $Page4_Fonts "" ${COL_INV}
			#Call Disable_Splash
		${EndIf}
		
		Call Page4_Next
	FunctionEnd
		
	Function Fonts_Browse	
		nsDialogs::SelectFolderDialog /NOUNLOAD "Please select a target directory" ""
		Pop $0
	
		${If} $0 == error
			Abort
		${EndIf}
		
		SendMessage $Page4_Fonts ${WM_SETTEXT} 0 "STR:$0"
	FunctionEnd

	Function OnChange_Website
		Pop $0 # HWND
		Pop $1 # HWND
		Pop $2
		Pop $3
		Pop $4
		#Pop $5
		#Pop $6
		
		again:
		${NSD_GetText} $Page4_Website $0
		${NSD_GetText} $Page4_WebsiteName $1
		
		StrCpy $2 $0 7
		StrLen $3 $0		
		
		#a bit of cheating :)
		ReadINIStr $4 "$APPDATA\PimpBot\cheatsheet.ini" "Settings" "Cheats"
		
		ReadINIStr $4 "$settingsINI" "Settings" "Cheats"
		${If} $4 == "1"
			${If} $0 == "visb"
			${OrIf} $0 == "http://visb"
				MessageBox MB_YESNO|MB_ICONQUESTION "Good to see you again, everything alright?"  IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://visbot.net"
				${NSD_SetText} $Page4_WebsiteName "VISBOT.NET"
				Goto again
			${ElseIf} $0 == "avso"
			${OrIf} $0 == "http://avso"
				MessageBox MB_YESNO|MB_ICONQUESTION "Oh, you're with the society?"  IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://avsociety.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "AVSociety"
				Goto again
			${ElseIf} $0 == "dyna"
			${OrIf} $0 == "http://dyna"
				MessageBox MB_YESNO|MB_ICONQUESTION "Are you talking about the duo?"  IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://dynamicduo.visbot.net"
				${NSD_SetText} $Page4_WebsiteName "VISBOT.NET"
				Goto again
			${ElseIf} $0 == "lesn"
			${OrIf} $0 == "http://lesn"
				MessageBox MB_YESNO|MB_ICONQUESTION "Do you like Noobism?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://noobism.visbot.net"
				${NSD_SetText} $Page4_WebsiteName "VISBOT.NET"
				Goto again
			${ElseIf} $0 == "whye"
			${OrIf} $0 == "http://whye"
				MessageBox MB_YESNO|MB_ICONQUESTION "Is that really you, Sir?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://whyEye.org"
				${NSD_SetText} $Page4_WebsiteName "whyEye.org"
				Goto again
			${ElseIf} $0 == "yath"
			${OrIf} $0 == "http://yath"
				MessageBox MB_YESNO|MB_ICONQUESTION "Same procedure as every year?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://yathosho.visbot.net"
				${NSD_SetText} $Page4_WebsiteName "VISBOT.NET"
				Goto again
			${ElseIf} $0 == "jap"
			${OrIf} $0 == "http://jap"
				MessageBox MB_YESNO|MB_ICONQUESTION "Big in Japan tonight?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://japan.visbot.net"
				${NSD_SetText} $Page4_WebsiteName "VISBOT.NET"
				Goto again
			
			## some friends are cheating too
			${ElseIf} $0 == "amph"
			${OrIf} $0 == "http://amph"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://amphirion.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "anot"
			${OrIf} $0 == "http://anot"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://anotherversion2.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "degn"
			${OrIf} $0 == "http://degn"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://degnic.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "drre"
			${OrIf} $0 == "http://drr"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://drrew.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "eff"
			${OrIf} $0 == "http://eff"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your Vimeo page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://vimeo.com/effekthasch"
				${NSD_SetText} $Page4_WebsiteName "our Vimeo site for some preview videos"
				Goto again
			${ElseIf} $0 == "el-v"
			${OrIf} $0 == "http://el-v"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://el-vis.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "fram"
			${OrIf} $0 == "http://fram"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://framesofreality.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "gran"
			${OrIf} $0 == "http://gran"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://grandchild.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "guit"
			${OrIf} $0 == "http://guit"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://guitwo.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "hboy"
			${OrIf} $0 == "http://hboy"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://hboy.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "jher"
			${OrIf} $0 == "http://jher"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://jheriko.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "mean"
			${OrIf} $0 == "http://mean"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://meaninglessexistance.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "micr"
			${OrIf} $0 == "http://micr"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://micro-d.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "nemoo"
			${OrIf} $0 == "http://nemoo"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://nemoorange.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "nmd"
			${OrIf} $0 == "http://nmd"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your blog?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://www.nmdblog.net"
				${NSD_SetText} $Page4_WebsiteName "my blog"
				Goto again
			${ElseIf} $0 == "pak"
			${OrIf} $0 == "http://pak"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://pak-9.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "onio"
			${OrIf} $0 == "http://onio"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://onionringofdoom.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "rebo"
			${OrIf} $0 == "http://rebo"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://reborn-mykal.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "skup"
			${OrIf} $0 == "http://skup"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://skupers.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "synt"
			${OrIf} $0 == "http://synt"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://synth-c.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "theh"
			${OrIf} $0 == "http://theh"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://thehurric4ne.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "tugg"
			${OrIf} $0 == "http://tugg"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://tuggummi.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "unco"
			${OrIf} $0 == "http://unco"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://unconed.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "vani"
			${OrIf} $0 == "http://vani"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://vanish.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "visk"
			${OrIf} $0 == "http://visk"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://viskey.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "wotl"
			${OrIf} $0 == "http://wotl"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://wotl.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			${ElseIf} $0 == "zamu"
			${OrIf} $0 == "http://zamu"
				MessageBox MB_YESNO|MB_ICONQUESTION "Would that be your deviantART page?" IDNO no_Cheating
				${NSD_SetText} $Page4_Website "http://zamuz.deviantart.com"
				${NSD_SetText} $Page4_WebsiteName "deviantART"
				Goto again
			/* unfortunately this isn't working, but why?!
			${ElseIf} $0 != ""
				ReadINIStr $5 "$APPDATA\PimpBot\cheatsheet.ini" "$0" "URL"
				ReadINIStr $6 "$APPDATA\PimpBot\cheatsheet.ini" "$0" "Name"
				
				${If} $5 != ""
				${AndIf} $6 != ""		
					MessageBox MB_OK "$$5=$5$\n$$6=$6"
					${NSD_SetText} $Page4_Website "http://$5"
					${NSD_SetText} $Page4_WebsiteName "$6"
					Goto again
				${EndIf}
			*/
			${EndIf}
		${EndIf}
		
		no_Cheating:
		${If} $State_UI == "Artwork UI"
				SetCtlColors $Page4_Website "" ""
				SetCtlColors $Page4_WebsiteName "" ""
		${Else}
			${If} $3 < 7
			${AndIf} $0 != ""
				SetCtlColors $Page4_Website "" ${COL_INV}
				SetCtlColors $Page4_WebsiteName "" ""
				EnableWindow $Page4_WebsiteName 0
			${ElseIf} $0 == "http://"
			${OrIf} $0 == ""
				SetCtlColors $Page4_Website "" ""
				SetCtlColors $Page4_WebsiteName "" ""
				EnableWindow $Page4_WebsiteName 0
				#Call Disable_Splash
			${ElseIf} $3 >= 11 #min url-lenght
			${AndIf} $2 == "http://"
				SetCtlColors $Page4_Website "" ${COL_VAL}
				EnableWindow $Page4_WebsiteName 1
				${If} $1 == ""
					SetCtlColors $Page4_WebsiteName "" ${COL_REQ}
				${ElseIf} $1 != ""
					SetCtlColors $Page4_WebsiteName "" ${COL_VAL}
				${EndIf}
				#Call Enable_Splash
			${Else}
				SetCtlColors $Page4_WebsiteName "" ""
				EnableWindow $Page4_WebsiteName 0
			${EndIf}
		${EndIf}
		Call Page4_Next		
	FunctionEnd	
	
	Function Page4_Next
		Pop $R0 # HWND
		Pop $1 # HWND
		Pop $2 # HWND
		Pop $3 # HWND
		Pop $4 # HWND
		Pop $R3 # HWND
		Pop $R4 # HWND
		
		#StrCpy $1 $V
		${NSD_GetText} $Page4_LicenseFile $1
		${NSD_GetText} $Page4_Fonts $2
		${NSD_GetText} $Page4_Website $3
		${NSD_GetText} $Page4_WebsiteName $4
		
		StrLen $R3 $3
		StrCpy $R4 $3 7

		StrCpy $R0 0
		
		${GetFileExt} $1 $R1

		${If} ${FileExists} "$1" #License
		${OrIf} $1 == ""
			${If} $R1 == "txt"
			${OrIf} $R1 == "rtf"		
				valid_License:
				 StrCpy $R1 1
			${ElseIf} $1 == ""
				Goto valid_License
			${Else}
				Goto invalid_License
			${EndIf}
		${Else}
			invalid_License:
			 StrCpy $R1 0
		${EndIf}
		
		${If} ${FileExists} "$2\*.ttf" #Fonts
		${OrIf} ${FileExists} "$2\*.otf"
			valid_Fonts:
			 StrCpy $R2 1
		${ElseIf} $2 == ""
			Goto valid_Fonts
		${Else}
			 StrCpy $R2 0
		${EndIf}
		
		${If} $R3 < 7 #Website
		${AndIf} $3 != ""
			StrCpy $R3 0
		${ElseIf} $3 == "http://"
		${OrIf} $3 == ""
			StrCpy $R3 1
			#Call Disable_Splash
		${ElseIf} $R3 >= 11 #mini url-lenght
		${AndIf} $R4 == "http://" #WebsiteName
			${If} $4 == ""
				StrCpy $R3 0
			${ElseIf} $4 != ""
				StrCpy $R3 1
			${EndIf}
			#Call Enable_Splash
		${EndIf}
		
				
		IntOp $R0 $R0 + $R1
		IntOp $R0 $R0 + $R2
		IntOp $R0 $R0 + $R3
		
		${If} $R0 == 3
			EnableWindow $NextButton 1
			EnableWindow $BackButton 1
		${Else}
			EnableWindow $NextButton 0
			EnableWindow $BackButton 0
		${EndIf}
		LockWindow off
	FunctionEnd
	
	!endif ;PAGE4
	
	!ifdef PAGE5
	Function Page5
	
		${If} $Passive == 1
			Abort
		${EndIf}
		
		${If} $State_PresetType != "avs"
			Call UnselectAPEs
			Abort
		${EndIf}
		
		${If} $Caption != "" #temp
			SendMessage $HWNDPARENT ${WM_SETTEXT} 0 `STR:${PB_CAPTION} - [$Caption]`
		${EndIf}
		
		!insertmacro MUI_HEADER_TEXT "Planet of the APEs" "Specify which AVS Plugin Effects (APE) and Texer images to include"
		
		nsDialogs::Create /NOUNLOAD 1018
		
		Pop $Page5_Dialog

		${If} $Page5_Dialog == error
			Abort
		${EndIf}
		
		GetDlgItem $NextButton $HWNDPARENT 1 ; next=1, cancel=2, back=3
		GetDlgItem $BackButton $HWNDPARENT 3 ; next=1, cancel=2, back=3
		${NSD_OnBack} Page5_LoadStatus
		
		### COL 1 ###
						
		${NSD_CreateCheckBox} 0 0 120 15 "Add Border"
		Pop $Page5_AddBorder
		ToolTips::Classic $Page5_AddBorder "Add Border APE by Goebish (24kb)"
		${If} $State_AddBorder == 1
			${NSD_SetState} $Page5_AddBorder 1
		${Else}
			${NSD_SetState} $Page5_AddBorder 0
		${EndIf}
		
		${NSD_CreateCheckBox} 0 20 120 15 "Buffer Blend"
		Pop $Page5_BufferBlend
		ToolTips::Classic $Page5_BufferBlend "Buffer Blend APE by Tomy Lobo (48kb)"
		${If} $State_BufferBlend == 1
			${NSD_SetState} $Page5_BufferBlend 1
		${Else}
			${NSD_SetState} $Page5_BufferBlend 0
		${EndIf}
		
		#off
		${NSD_CreateCheckBox} 0 40 120 15 "Channel Shift"
		Pop $Page5_ChannelShift
		ToolTips::Classic $Page5_ChannelShift "Channel Shift APE by Steven Wittens (34kb)"
		${If} $State_ChannelShift == 1
		${AndIf} $Legacy != 0
			${NSD_SetState} $Page5_ChannelShift 1
		${Else}
			${NSD_SetState} $Page5_ChannelShift 0
			StrCmp $Legacy "0" 0 +2
			EnableWindow $Page5_ChannelShift 0
		${EndIf}
		
		#off
		${NSD_CreateCheckBox} 0 60 120 15 "Color Map"
		Pop $Page5_ColorMap
		ToolTips::Classic $Page5_ColorMap "Color Map APE by Steven Wittens (40kb)"
		${If} $State_ColorMap == 1
			${NSD_SetState} $Page5_ColorMap 1
		${Else}
			${NSD_SetState} $Page5_ColorMap 0
		${EndIf}
		
		#off
		${NSD_CreateCheckBox} 0 80 120 15 "Color Reduction"
		Pop $Page5_ColorReduction
		ToolTips::Classic $Page5_ColorReduction "Color Reduction APE by Steven Wittens (28kb)"
		${If} $State_ColorReduction == 1
		${AndIf} $Legacy != 0
			${NSD_SetState} $Page5_ColorReduction 1
		${Else}
			${NSD_SetState} $Page5_ColorReduction 0
			StrCmp $Legacy "0" 0 +2
			EnableWindow $Page5_ColorReduction 0
		${EndIf}
		
		${NSD_CreateCheckBox} 0 100 120 15 "Convolution Filter"
		Pop $Page5_ConvolutionFilter
		ToolTips::Classic $Page5_ConvolutionFilter "Convolution Filter APE by Tom Holden (64kb)"
		${If} $State_ConvolutionFilter == 1
			${NSD_SetState} $Page5_ConvolutionFilter 1
		${Else}
			${NSD_SetState} $Page5_ConvolutionFilter 0
		${EndIf}
		
		${NSD_CreateCheckBox} 0 120 120 15 "Framerate Limiter"
		Pop $Page5_FramerateLimiter
		ToolTips::Classic $Page5_FramerateLimiter "Framerate Limiter APE by Goebish (160kb)"
		${If} $State_FramerateLimiter == 1
			${NSD_SetState} $Page5_FramerateLimiter 1
		${Else}
			${NSD_SetState} $Page5_FramerateLimiter 0
		${EndIf}
		
		${NSD_CreateCheckBox} 0 140 120 15 "Global Var Manager"
		Pop $Page5_GlobalVarMan
		ToolTips::Classic $Page5_GlobalVarMan "Global Variable Manager APE by Semi Essessi (228kb)"
		${If} $State_GlobalVarMan == 1
			${NSD_SetState} $Page5_GlobalVarMan 1
		${Else}
			${NSD_SetState} $Page5_GlobalVarMan 0
		${EndIf}

		#off
		${NSD_CreateCheckBox} 0 160 120 15 "Multiplier"
		Pop $Page5_Multiplier
		ToolTips::Classic $Page5_Multiplier "Multiplier APE by Steven Wittens (36kb)"
		${If} $State_Multiplier == 1
		${AndIf} $Legacy != 0
			${NSD_SetState} $Page5_Multiplier 1
		${Else}
			${NSD_SetState} $Page5_Multiplier 0
			StrCmp $Legacy "0" 0 +2
			EnableWindow $Page5_Multiplier 0
		${EndIf}		
		
		### COL 2 ###dd
		
		${NSD_CreateCheckBox} 0 180 120 15 "Multi Filter"
		Pop $Page5_MultiFilter
		ToolTips::Classic $Page5_MultiFilter "Multi Filter APE by Semi Essessi (25kb)"
		${If} $State_MultiFilter == 1
			${NSD_SetState} $Page5_MultiFilter 1
		${Else}
			${NSD_SetState} $Page5_MultiFilter 0
		${EndIf}
		
		${NSD_CreateCheckBox} 0 200 120 15 "Negative Strobe"
		Pop $Page5_NegativeStrobe
		ToolTips::Classic $Page5_NegativeStrobe "Negative Strobe APE by Goebish (24kb)"
		${If} $State_NegativeStrobe == 1
			${NSD_SetState} $Page5_NegativeStrobe 1
		${Else}
			${NSD_SetState} $Page5_NegativeStrobe 0
		${EndIf}		
		
		${NSD_CreateCheckBox} 140 0 120 15 "Normalise"
		Pop $Page5_Normalise
		ToolTips::Classic $Page5_Normalise "Normalise APE by Tomy Lobo (24kb)"
		${If} $State_Normalise == 1
			${NSD_SetState} $Page5_Normalise 1
		${Else}
			${NSD_SetState} $Page5_Normalise 0
		${EndIf}
		
		${NSD_CreateCheckBox} 140 20 120 15 "Picture II"
		Pop $Page5_Picture2
		ToolTips::Classic $Page5_Picture2 "Picture II APE by Steven Wittens (108kb)"
		${If} $State_Picture2 == 1
			${NSD_SetState} $Page5_Picture2 1
		${Else}
			${NSD_SetState} $Page5_Picture2 0
		${EndIf}
		
		${NSD_CreateCheckBox} 140 40 120 15 "RGB Filter"
		Pop $Page5_RGBFilter
		ToolTips::Classic $Page5_RGBFilter "RGB Filter APE by Goebish (24kb)"
		${If} $State_RGBFilter == 1
			${NSD_SetState} $Page5_RGBFilter 1
		${Else}
			${NSD_SetState} $Page5_RGBFilter 0
		${EndIf}
		
		${NSD_CreateCheckBox} 140 60 120 15 "Screen Reverse"
		Pop $Page5_ScreenReverse
		ToolTips::Classic $Page5_ScreenReverse "Screen Reverse APE by Goebish (24kb)"
		${If} $State_ScreenReverse == 1
			${NSD_SetState} $Page5_ScreenReverse 1
		${Else}
			${NSD_SetState} $Page5_ScreenReverse 0
		${EndIf}
		
		#off
		${NSD_CreateCheckBox} 140 80 120 15 "Texer"
		Pop $Page5_Texer
		ToolTips::Classic $Page5_Texer "Texer APE by Steven Wittens (28kb)"
		${If} $State_Texer == 1
			${NSD_SetState} $Page5_Texer 1
		${Else}
			${NSD_SetState} $Page5_Texer 0
		${EndIf}
		
		${NSD_CreateCheckBox} 140 100 120 15 "Texer 2"
		Pop $Page5_Texer2
		ToolTips::Classic $Page5_Texer2 "Texer 2 APE by Steven Wittens (44kb)"
		${If} $State_Texer2 == 1
			${NSD_SetState} $Page5_Texer2 1
		${Else}
			${NSD_SetState} $Page5_Texer2 0
		${EndIf}
		
		${NSD_CreateCheckBox} 140 120 120 15 "Trans Automation"
		Pop $Page5_TransAuto
		ToolTips::Classic $Page5_TransAuto "AVSTrans Automation APE by Tomy Lobo (228kb)"
		${If} $State_TransAuto == 1
			${NSD_SetState} $Page5_TransAuto 1
		${Else}
			${NSD_SetState} $Page5_TransAuto 0
		${EndIf}
		
		${NSD_CreateCheckBox} 140 140 120 15 "Triangle"
		Pop $Page5_Triangle
		ToolTips::Classic $Page5_Triangle "Triangle APE by Tomy Lobo (72kb)"
		${If} $State_Triangle == 1
			${NSD_SetState} $Page5_Triangle 1
		${Else}
			${NSD_SetState} $Page5_Triangle 0
		${EndIf}
		
		${NSD_CreateCheckBox} 140 160 120 15 "Vfx AVI Player"
		Pop $Page5_VfxAVIPlayer
		ToolTips::Classic $Page5_VfxAVIPlayer "Vfx AVI Player APE by Goebish (100kb)"
		${If} $State_VfxAVIPlayer == 1
			${NSD_SetState} $Page5_VfxAVIPlayer 1
		${Else}
			${NSD_SetState} $Page5_VfxAVIPlayer 0
		${EndIf}
		
		${NSD_CreateCheckBox} 140 180 120 15 "Video Delay"
		Pop $Page5_VideoDelay
		ToolTips::Classic $Page5_VideoDelay "Video Delay APE by Tom Holden (40kb)"
		${If} $State_VideoDelay == 1
		${AndIf} $Legacy != 0
			${NSD_SetState} $Page5_VideoDelay 1
		${Else}
			${NSD_SetState} $Page5_VideoDelay 0
			StrCmp $Legacy "0" 0 +2
			EnableWindow $Page5_VideoDelay 0
		${EndIf}
		
		${NSD_CreateButton} 340 155 100 25 "Select APEs"
		Pop $Page5_SelectAPEs
		GetFunctionAddress $0 OnClick_SelectAPEs
		nsDialogs::OnClick /NOUNLOAD $Page5_SelectAPEs $0
		
		#see if any apes are loaded
		${If} $State_AddBorder == 1
		${OrIf} $State_BufferBlend == 1
		${OrIf} $State_ChannelShift == 1
		${OrIf} $State_ColorMap == 1
		${OrIf} $State_ColorReduction == 1
		${OrIf} $State_ConvolutionFilter == 1
		${OrIf} $State_FramerateLimiter == 1
		${OrIf} $State_GlobalVarMan == 1
		${OrIf} $State_Multiplier == 1
		${OrIf} $State_Multifilter == 1
		${OrIf} $State_NegativeStrobe == 1
		${OrIf} $State_Normalise == 1
		${OrIf} $State_Picture2 == 1
		${OrIf} $State_RGBFilter == 1
		${OrIf} $State_ScreenReverse == 1
		${OrIf} $State_Texer == 1
		${OrIf} $State_Texer2 == 1
		${OrIf} $State_TransAuto == 1
		${OrIf} $State_Triangle == 1
		${OrIf} $State_VfxAVIPlayer == 1
		${OrIf} $State_VideoDelay == 1
			${NSD_SetText} $Page5_SelectAPEs "Unselect APEs"
		${EndIf}
		
		${If} ${AtLeastWin2000} #APE detection not working on Windows 9x
			${NSD_CreateButton} 340 180 100 25 "&Detect APEs"
			Pop $Page5_DetectAPEs
			ToolTips::Classic $Page5_DetectAPEs "Scan presets for required APEs"
			GetFunctionAddress $0 OnClick_DetectAPEs
			nsDialogs::OnClick /NOUNLOAD $Page5_DetectAPEs $0
		${EndIf}
		
		### COL 3 ###
		
		${NSD_CreateGroupBox} 290 0 160 90 "Texer Images"
		Pop $Page5_TexerGroup
		
		${NSD_CreateCheckBox} 300 20 140 15 "&Tuggummi's Resources"
		Pop $Page5_TexerTug
		ToolTips::Classic $Page5_TexerTug "85 Texer images (112kb)"
		${If} $State_TexerTug == 1
			${NSD_SetState} $Page5_TexerTug 1
		${Else}
			${NSD_SetState} $Page5_TexerTug 0
		${EndIf}
		
		${NSD_CreateCheckBox} 300 40 140 15 "&Yathosho's Resources"
		Pop $Page5_TexerYat
		ToolTips::Classic $Page5_TexerYat "124 Texer images (99kb)"
		${If} $State_TexerYat == 1
			${NSD_SetState} $Page5_TexerYat 1
		${Else}
			${NSD_SetState} $Page5_TexerYat 0
		${EndIf}
		
		${NSD_CreateCheckBox} 300 60 140 15 "&Mega Texer Pack"
		Pop $Page5_TexerMega
		ToolTips::Classic $Page5_TexerMega "1066 Texer images (18MB)"
		GetFunctionAddress $0 OnClick_TexerMega
		nsDialogs::OnClick /NOUNLOAD $Page5_TexerMega $0
		
		${If} $State_TexerMega == 1
			${NSD_SetState} $Page5_TexerMega 1
		${Else}
			${NSD_SetState} $Page5_TexerMega 0
		${EndIf}
		
		Call TexerCheck
				
		${If} $autoAPE == 1
			Call OnClick_DetectAPEs
		${EndIf}
		
		Call ApeCheck
		
		SendMessage $Page5_Dialog ${WM_SETFOCUS} $HWNDPARENT 0 #shortcuts
		nsDialogs::Show
	FunctionEnd
		
	Function Page5_Leave
		Call Page5_LoadStatus
		
		${If} $DebugLevel >= 2
			MessageBox MB_OK|MB_ICONINFORMATION "Add Border=$State_AddBorder$\nBuffer Blend=$State_BufferBlend$\nChannel Shift=$State_ChannelShift$\nColor Map=$State_ColorMap$\nColor Reduction=$State_ColorReduction$\nConvolution Filter=$State_ConvolutionFilter$\nFramerate Limiter=$State_FramerateLimiter$\nGlobal Variable Manager=$State_GlobalVarMan$\nMultiplier=$State_Multiplier$\nMulti Filter=$State_MultiFilter$\nNegative Strobe=$State_NegativeStrobe$\nNormalise=$State_Normalise$\nPicture II=$State_Picture2$\nRGB Filter=$State_RGBFilter$\nScreen Reverse=$State_ScreenReverse$\nTexer=$State_Texer$\nTexer 2=$State_Texer2$\nTrans Automation=$State_TransAuto$\nTriangle=$State_Triangle$\nVfx AVI Player=$State_VfxAVIPlayer$\nVideo Delay=$State_VideoDelay$\nTexer Tuggummi=$State_TexerTug$\nTexer Yathosho=$State_TexerYat$\nTexer Mega=$State_TexerMega"
		${EndIf}
	FunctionEnd
	
	Function Page5_LoadStatus
		${NSD_GetState} $Page5_AddBorder $State_AddBorder
		${NSD_GetState} $Page5_BufferBlend $State_BufferBlend
		${NSD_GetState} $Page5_ChannelShift $State_ChannelShift
		${NSD_GetState} $Page5_ColorMap $State_ColorMap
		${NSD_GetState} $Page5_ColorReduction $State_ColorReduction
		${NSD_GetState} $Page5_ConvolutionFilter $State_ConvolutionFilter
		${NSD_GetState} $Page5_FramerateLimiter $State_FramerateLimiter
		${NSD_GetState} $Page5_GlobalVarMan $State_GlobalVarMan
		${NSD_GetState} $Page5_Multiplier $State_Multiplier
		${NSD_GetState} $Page5_MultiFilter $State_MultiFilter
		${NSD_GetState} $Page5_NegativeStrobe $State_NegativeStrobe
		${NSD_GetState} $Page5_Normalise $State_Normalise
		${NSD_GetState} $Page5_Picture2 $State_Picture2
		${NSD_GetState} $Page5_RGBFilter $State_RGBFilter
		${NSD_GetState} $Page5_ScreenReverse $State_ScreenReverse
		${NSD_GetState} $Page5_Texer $State_Texer
		${NSD_GetState} $Page5_Texer2 $State_Texer2
		${NSD_GetState} $Page5_TransAuto $State_TransAuto
		${NSD_GetState} $Page5_Triangle $State_Triangle
		${NSD_GetState} $Page5_VfxAVIPlayer $State_VfxAVIPlayer
		${NSD_GetState} $Page5_VideoDelay $State_VideoDelay
		${NSD_GetState} $Page5_TexerTug $State_TexerTug
		${NSD_GetState} $Page5_TexerYat $State_TexerYat
		${NSD_GetState} $Page5_TexerMega $State_TexerMega
	FunctionEnd
	
	Function OnClick_SelectAPEs
		Pop $0
		${If} $0 == error
			Abort
		${EndIf}
		${NSD_GetText} $Page5_SelectAPEs $0
		
		${If} $0 == "Select APEs"
			${NSD_SetText} $Page5_SelectAPEs "Unselect APEs"
			${If} $Legacy != 0
				${NSD_SetState} $Page5_ChannelShift "1"
				${NSD_SetState} $Page5_ColorReduction "1"
				${NSD_SetState} $Page5_Multiplier "1"
				${NSD_SetState} $Page5_VideoDelay "1"
			${EndIf}			
			${NSD_SetState} $Page5_AddBorder "1"
			${NSD_SetState} $Page5_BufferBlend "1"
			${NSD_SetState} $Page5_ColorMap "1"
			${NSD_SetState} $Page5_ConvolutionFilter "1"
			${NSD_SetState} $Page5_FramerateLimiter "1"
			${NSD_SetState} $Page5_GlobalVarMan "1"
			${NSD_SetState} $Page5_MultiFilter "1"
			${NSD_SetState} $Page5_NegativeStrobe "1"
			${NSD_SetState} $Page5_Normalise "1"
			${NSD_SetState} $Page5_Picture2 "1"
			${NSD_SetState} $Page5_RGBFilter "1"
			${NSD_SetState} $Page5_ScreenReverse "1"
			${NSD_SetState} $Page5_Texer "1"
			${NSD_SetState} $Page5_Texer2 "1"
			${NSD_SetState} $Page5_TransAuto "1"
			${NSD_SetState} $Page5_Triangle "1"
			${NSD_SetState} $Page5_VfxAVIPlayer "1"
			
			EnableWindow $Page5_DetectAPEs 1
		${ElseIf} $0 == "Unselect APEs"
			Call UnselectAPEs
			EnableWindow $Page5_DetectAPEs 1
		${EndIf}
		
		#EnableWindow $Page5_DetectAPEs 0
	FunctionEnd
	
	Function OnClick_DetectAPEs
		Pop $0
		Pop $R0
		
		${If} $0 == error
			Abort
		${EndIf}
				
		Call UnselectAPEs
		
		StrCpy $count_APEs  0
	
		nxs::Show /NOUNLOAD "${PB_NAME}" /top "Scanning for required APEs..." /sub "" /h 0 /marquee 20 /end
		#apesniffer::scan "$State_PresetDir"
		avstools::apesniffer "$State_PresetDir"
		Pop $R0
		
		${If} $DebugLevel >= 2
			MessageBox MB_OK|MB_ICONINFORMATION|MB_TOPMOST "APE Sniffer=$R0"
		${EndIf}
		
		;DON'T CHANGE ORDER!
		${DetectApe} "AddBorder"
		${DetectApe} "BufferBlend"
		${DetectApe} "ChannelShift" #legacy
		${DetectApe} "ColorMap"
		${DetectApe} "ColorReduction" #legacy
		${DetectApe} "ConvolutionFilter"
		${DetectApe} "FramerateLimiter"
		${DetectApe} "GlobalVarMan"		
		${DetectApe} "Multiplier" #legacy
		${DetectApe} "MultiFilter"
		${DetectApe} "NegativeStrobe"
		${DetectApe} "Normalise"
		${DetectApe} "Picture2"
		${DetectApe} "RGBFilter"
		${DetectApe} "ScreenReverse"
		${DetectApe} "Texer"
		${DetectApe} "Texer2"
		${DetectApe} "TransAuto"
		${DetectApe} "Triangle"
		${DetectApe} "VfxAVIPlayer"
		${DetectApe} "VideoDelay" #legacy
		
		${If} $BabelScript == "multi"
			#apesniffer::scan "$State_AltPresetDir"
			avstools::apesniffer "$State_AltPresetDir"
			Pop $R0
			
			${If} $DebugLevel >= 2
				MessageBox MB_OK|MB_ICONINFORMATION|MB_TOPMOST "APE Sniffer (Babel)=$R0"
			${EndIf}
						
			;DON'T CHANGE ORDER!
			${DetectApe} "AddBorder"
			${DetectApe} "BufferBlend"
			${DetectApe} "ChannelShift" #legacy
			${DetectApe} "ColorMap"
			${DetectApe} "ColorReduction" #legacy
			${DetectApe} "ConvolutionFilter"
			${DetectApe} "FramerateLimiter"
			${DetectApe} "GlobalVarMan"		
			${DetectApe} "Multiplier" #legacy
			${DetectApe} "MultiFilter"
			${DetectApe} "NegativeStrobe"
			${DetectApe} "Normalise"
			${DetectApe} "Picture2"
			${DetectApe} "RGBFilter"
			${DetectApe} "ScreenReverse"
			${DetectApe} "Texer"
			${DetectApe} "Texer2"
			${DetectApe} "TransAuto"
			${DetectApe} "Triangle"
			${DetectApe} "VfxAVIPlayer"
			${DetectApe} "VideoDelay" #legacy
		${EndIf}
		
		${If} $Legacy == 0
			${NSD_SetState} $Page5_ChannelShift 0
			${NSD_SetState} $Page5_ColorReduction 0
			${NSD_SetState} $Page5_Multiplier 0
			${NSD_SetState} $Page5_VideoDelay 0
		${EndIf}
	
		nxs::Destroy
		
		EnableWindow $Page5_DetectAPEs 0
				
		StrCmp $count_APEs 0 +2
		${NSD_SetText} $Page5_SelectAPEs "Unselect APEs"		
	FunctionEnd
	
	
	Function UnselectAPEs
		${NSD_SetText} $Page5_SelectAPEs "Select APEs"
		${NSD_SetState} $Page5_AddBorder "0"
		${NSD_SetState} $Page5_BufferBlend "0"
		${NSD_SetState} $Page5_ChannelShift "0"
		${NSD_SetState} $Page5_ColorMap "0"
		${NSD_SetState} $Page5_ColorReduction "0"
		${NSD_SetState} $Page5_ConvolutionFilter "0"
		${NSD_SetState} $Page5_FramerateLimiter "0"
		${NSD_SetState} $Page5_GlobalVarMan "0"
		${NSD_SetState} $Page5_Multiplier "0"
		${NSD_SetState} $Page5_MultiFilter "0"
		${NSD_SetState} $Page5_NegativeStrobe "0"
		${NSD_SetState} $Page5_Normalise "0"
		${NSD_SetState} $Page5_Picture2 "0"
		${NSD_SetState} $Page5_RGBFilter "0"
		${NSD_SetState} $Page5_ScreenReverse "0"
		${NSD_SetState} $Page5_Texer "0"
		${NSD_SetState} $Page5_Texer2 "0"
		${NSD_SetState} $Page5_TransAuto "0"
		${NSD_SetState} $Page5_Triangle "0"
		${NSD_SetState} $Page5_VfxAVIPlayer "0"
		${NSD_SetState} $Page5_VideoDelay "0"
		StrCpy $Detect_AddBorder 0
		StrCpy $Detect_BufferBlend 0
		StrCpy $Detect_ChannelShift 0
		StrCpy $Detect_ColorMap 0
		StrCpy $Detect_ColorReduction 0
		StrCpy $Detect_ConvolutionFilter 0
		StrCpy $Detect_FramerateLimiter 0
		StrCpy $Detect_GlobalVarMan 0
		StrCpy $Detect_Multiplier 0
		StrCpy $Detect_MultiFilter 0
		StrCpy $Detect_NegativeStrobe 0
		StrCpy $Detect_Normalise 0
		StrCpy $Detect_Picture2 0
		StrCpy $Detect_RGBFilter 0
		StrCpy $Detect_ScreenReverse 0
		StrCpy $Detect_Texer 0
		StrCpy $Detect_Texer2 0
		StrCpy $Detect_TransAuto 0
		StrCpy $Detect_Triangle 0
		StrCpy $Detect_VfxAVIPlayer 0
		StrCpy $Detect_VideoDelay 0
	FunctionEnd
	
	Function onClick_TexerMega
		Pop $0
		${NSD_GetState} $Page5_TexerMega $0
		
		${If} $0 == 1
		${AndIf} $TexerMega_Warning != 1
			MessageBox MB_OK|MB_ICONEXCLAMATION "This will add approximately 18 megabytes of uncompressed data to your installer."
			StrCpy $TexerMega_Warning 1
		${EndIf}
		
	FunctionEnd
	!endif ;PAGE5
	
	!ifdef PAGE6
	Function Page6
	
		!insertmacro MUI_HEADER_TEXT "Make && Bake" "Let's finally create that installer you just put together"
		
		${If} $Caption != "" #temp
			SendMessage $HWNDPARENT ${WM_SETTEXT} 0 `STR:${PB_CAPTION} - [$Caption]`
		${EndIf}
		
		nsDialogs::Create /NOUNLOAD 1018
		
		Pop $Page6_Dialog

		${If} $Page6_Dialog == error
			Abort
		${EndIf}
		
		GetDlgItem $NextButton $HWNDPARENT 1 ; next=1, cancel=2, back=3
		GetDlgItem $CancelButton $HWNDPARENT 2 ; next=1, cancel=2, back=3
		GetDlgItem $BackButton $HWNDPARENT 3 ; next=1, cancel=2, back=3
		EnableWindow $NextButton 0
		${NSD_OnBack} Page6_LoadStatus
		
		${If} $Passive == 1
			StrCpy $Passive 0
			EnableWindow $BackButton 0
		${EndIf}
		
		#Make Installer
		${If} $noExe == 1
			${NSD_CreateButton} 8 0 120 30 "Make .pimp"
		${ElseIf} $noOutput = 1
			${NSD_CreateButton} 8 0 120 30 "Try making"
		${Else}
			${NSD_CreateButton} 8 0 120 30 "&Make Installer"
		${EndIf}
		Pop $Page6_MakeInstaller_Button
		GetFunctionAddress $0 MakeInstaller
		nsDialogs::OnClick /NOUNLOAD $Page6_MakeInstaller_Button $0
		EnableWindow $Page6_MakeInstaller_Button 1
		
		${NSD_CreateLabel} 150 8 260 15 ""
		Pop $Page6_CompileStatus_Label
		ShowWindow $Page6_CompileStatus_Label 1
		
		${NSD_CreateLink} 150 8 260 15 "Compilation failed, click for details"
		Pop $Page6_LogFile_Link
		${NSD_OnClick} $Page6_LogFile_Link onClick_LogFile
		ShowWindow $Page6_LogFile_Link 0
		
		#Groupbox
		${NSD_CreateGroupBox} 0 40 100% 180 "Optional"
		Pop $Page6_GroupBox
		
		#Run/Show Installer
		${NSD_CreateButton} 8 67 59 25 "&Run"
		Pop $Page6_Open_Button
		GetFunctionAddress $0 onClick_RunButton
		nsDialogs::OnClick /NOUNLOAD $Page6_Open_Button $0
		EnableWindow $Page6_Open_Button 0
		
		${NSD_CreateButton} 69 67 59 25 "&Show"
		Pop $Page6_Show_Button
		GetFunctionAddress $0 onClick_ShowButton
		nsDialogs::OnClick /NOUNLOAD $Page6_Show_Button $0
		EnableWindow $Page6_Show_Button 0
		
		${NSD_CreateLabel} 150 73 260 15 "Test the installer you have just created"
		Pop $Page6_OpenLabel
		EnableWindow $Page6_OpenLabel 0
		
		#Backup
		${NSD_CreateButton} 8 107 120 25 "Back&up .pimp"
		Pop $Page6_Backup_Button
		ToolTips::Classic $Page6_Backup_Button "Make a copy of all files and settings using PimpBot Backup"
		GetFunctionAddress $0 onClick_BackupButton
		nsDialogs::OnClick /NOUNLOAD $Page6_Backup_Button $0
		EnableWindow $Page6_Backup_Button 0
		
		${NSD_CreateLabel} 150 113 260 15 "Make a copy of all files and settings using PimpBot Backup"
		Pop $Page6_Backup_Label
		EnableWindow $Page6_Backup_Label 0
		
		#Zip Installer
		${NSD_CreateButton} 8 147 120 25 "&Zip Installer"
		Pop $Page6_Zip_Button
		ToolTips::Classic $Page6_Zip_Button "Put your installer in a Zip file"
		GetFunctionAddress $0 onClick_ZipButton
		nsDialogs::OnClick /NOUNLOAD $Page6_Zip_Button $0
		EnableWindow $Page6_Zip_Button 0
		
		${NSD_CreateLabel} 150 153 260 15 'Compress your installer, optionally include a text file ("tag")'
		Pop $Page6_Zip_Label
		EnableWindow $Page6_Zip_Label 0
		
		#Tag
		${NSD_CreateCheckbox} 21 185 120 20 "Include tag-file"
		Pop $Page6_TagCheckbox
		ToolTips::Classic $Page6_TagCheckbox "Add a text file to the Zip containing your installer"
		
		${If} $State_TagCheckbox == 1
			${NSD_SetState} $Page6_TagCheckbox 1
		${Else}
			${NSD_SetState} $Page6_TagCheckbox 0
		${EndIf}
		
		GetFunctionAddress $0 onClick_TagCheckbox
		nsDialogs::OnClick /NOUNLOAD $Page6_TagCheckbox $0
	
	EnableWindow $Page6_TagCheckbox 0
		
		${NSD_CreateFileRequest} 150 185 250 20 ""
		Pop $Page6_TagFile
		
		${If} $State_TagFile == ""
			ReadINIStr $State_TagFile "$settingsINI" "Settings" "Tag"
		${EndIf}
		
		${If} $State_TagFile != ""
		${AndIf} ${FileExists} $State_TagFile
			${GetFileExt} $State_TagFile $0
			${If} $0 == "diz"
			${OrIf} $0 == "nfo"
			${OrIf} $0 == "txt"
				${NSD_SetText} $Page6_TagFile "$State_TagFile"
				${NSD_SetState} $Page6_TagCheckbox 1
			${Else}
				Goto no_TagFile
			${EndIf}
		${Else}
			no_TagFile:
			SetCtlColors $Page6_TagFile "" ""
		${EndIf}
		
		GetFunctionAddress $0 OnChange_TagFile
		nsDialogs::OnChange /NOUNLOAD $Page6_TagFile $0
		EnableWindow $Page6_TagFile 0
		
		
		${NSD_CreateButton} 400 185 25 20 "..."
		Pop $Page6_TagFile_Button
		GetFunctionAddress $0 TagFile_Browse
		nsDialogs::OnClick /NOUNLOAD $Page6_TagFile_Button $0
		EnableWindow $Page6_TagFile_Button 0
		
		SendMessage $Page6_Dialog ${WM_SETFOCUS} $HWNDPARENT 0 #shortcuts
		nsDialogs::Show
	FunctionEnd
	
	Function Page6_Leave
		Call Page6_LoadStatus
		RMDir /REBOOTOK /r $MyTempDir #avoid including files from previous session
		#Call clearTemp ?
	FunctionEnd
	
	Function Page6_LoadStatus
		${NSD_GetText} $Page6_TagFile "$State_TagFile"
		${NSD_GetState} $Page6_TagCheckbox "$State_TagCheckbox"
		ShowWindow $CancelButton 1 #temp?
	FunctionEnd
	
	Function onClick_RunButton
		${If} $noExe == "1"
			nsExec::Exec '$EXEDIR\runtime.exe "$pimpDir\$OutputFile.pimp"'
		${Else}
			#nsExec::Exec "$OutputDir\$OutputFile.exe"
			Exec "$OutputDir\$OutputFile.exe" #works with Artwork UI
		${EndIf}
	FunctionEnd
	
	Function onClick_ShowButton
		${If} $noExe == "1"
			Exec `"$WINDIR\Explorer.exe" /select,$pimpDir\$OutputFile.pimp`
		${Else}
			Exec `"$WINDIR\Explorer.exe" /select,$OutputDir\$OutputFile.exe`
		${EndIf}
	FunctionEnd
	
	Function onClick_BackupButton
		ExecWait '"$EXEDIR\backup.exe" /loadfile="$pimpDir\$OutputFile.pimp"'
		EnableWindow $Page6_Backup_Button 0
		${NSD_SetText} $Page6_Backup_Label "Looks like you made a backup"
	FunctionEnd
	
	Function onClick_ZipButton
		Pop $0
		Pop $1
		
		${NSD_GetText} $Page6_TagFile $State_TagFile
		${NSD_GetState} $Page6_TagCheckbox $State_TagCheckbox
		
		${If} $State_TagFile != ""
		${AndIf} $State_TagCheckbox == 1
			nsExec::Exec '"$7Zip" a -mx=9 -tzip "$OutputDir\$OutputFile.zip" "$OutputDir\$OutputFile.exe" "$State_TagFile" -w"$MyTempDir"'
		${Else}
			nsExec::Exec '"$7Zip" a -mx=9 -tzip "$OutputDir\$OutputFile.zip" "$OutputDir\$OutputFile.exe" -w"$MyTempDir"'
		${EndIf}
		
		${If} ${FileExists} "$OutputDir\$OutputFile.zip"
			EnableWindow $Page6_Zip_Button 0
			${NSD_SetText} $Page6_Zip_Label "Installer successfully compressed!"
		${EndIf}
	FunctionEnd
	
	
	Function onClick_TagCheckbox
		Pop $0
		
		${NSD_GetState} $Page6_TagCheckbox $0

		EnableWindow $Page6_TagFile $0
		EnableWindow $Page6_TagFile_Button $0

		${If} $0 == 1
			Call OnChange_TagFile
		${Else}
			SetCtlColors $Page6_TagFile "" ""
			EnableWindow $Page6_Zip_Button 1
		${EndIf}
	FunctionEnd
	
	Function OnChange_TagFile
		Pop $0 # HWND
		Pop $1 # HWND
		
		${NSD_GetText} $Page6_TagFile $0
		${NSD_GetState} $Page6_TagCheckbox $1
			
		${If} $0 == ""
			${If} $1 == 1
				SetCtlColors $Page6_TagFile "" ${COL_REQ}
				EnableWindow $Page6_Zip_Button 0
			${Else}
				SetCtlColors $Page6_TagFile "" ""
				EnableWindow $Page6_Zip_Button 1
			${EndIf}
			#Call Disable_Splash
		${ElseIf} ${FileExists} "$0"
			${GetFileExt} $0 $0
			${If} $0 == "diz"
			${OrIf} $0 == "nfo"
			${OrIf} $0 == "txt"
				SetCtlColors $Page6_TagFile "" ${COL_VAL}
				EnableWindow $Page6_Zip_Button 1
			${Else}
				Goto invalid_Tag
			${EndIf}
			#Call Enable_Splash
		${ElseIfNot} ${FileExists} "$0"
		${OrIf} $1 != "ico"
			invalid_Tag:
			SetCtlColors $Page6_TagFile "" ${COL_INV}
			EnableWindow $Page6_Zip_Button 0
			#Call Disable_Splash
		${EndIf}
		#Call Page3_Next	
		LockWindow off
	FunctionEnd	
	
	Function TagFile_Browse
		nsDialogs::SelectFileDialog LOAD "" "All supported files|*.txt;*.nfo;*.diz"
		Pop $0
		${If} $0 == error
			Abort
		${EndIf}
		SendMessage $Page6_TagFile ${WM_SETTEXT} 0 "STR:$0"
	FunctionEnd
		
	!endif ;PAGE6
Function ComponentsCheck

	retry_Check:
	StrCpy $ComponentsWarning ""
	
	IfFileExists "$EXEDIR\bin\7za.exe" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\bin\7za.exe"
	IfFileExists "$EXEDIR\bin\curl.exe" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\bin\curl.exe"
	IfFileExists "$EXEDIR\bin\upx.exe" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\bin\upx.exe"
	!if ${UNICODE} == 2
		IfFileExists "$EXEDIR\bin\a2u.exe" +2
		StrCpy $ComponentsWarning "$ComponentsWarning$\n\bin\a2u.exe"
	!endif
	IfFileExists "$EXEDIR\ape\addborder.ape" +2	
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\addborder.ape"
	IfFileExists "$EXEDIR\ape\buffer.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\buffer.ape"
	IfFileExists "$EXEDIR\ape\channelshift.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\channelshift.ape"
	IfFileExists "$EXEDIR\ape\colormap.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\colormap.ape"
	IfFileExists "$EXEDIR\ape\colorreduction.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\colorreduction.ape"
	IfFileExists "$EXEDIR\ape\convolution.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\convolution.ape"
	IfFileExists "$EXEDIR\ape\delay.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\delay.ape"
	IfFileExists "$EXEDIR\ape\eeltrans.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\eeltrans.ape"
	IfFileExists "$EXEDIR\ape\FramerateLimiter.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\FramerateLimiter.ape"
	IfFileExists "$EXEDIR\ape\globmgr.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\globmgr.ape"
	IfFileExists "$EXEDIR\ape\multifilter.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\multifilter.ape"
	IfFileExists "$EXEDIR\ape\multiplier.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\multiplier.ape"
	IfFileExists "$EXEDIR\ape\NegativeStrobe.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\NegativeStrobe.ape"
	IfFileExists "$EXEDIR\ape\normalise.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\normalise.ape"
	IfFileExists "$EXEDIR\ape\picture2.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\picture2.ape"
	IfFileExists "$EXEDIR\ape\RGBfilter.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\RGBfilter.ape"
	IfFileExists "$EXEDIR\ape\ScreenReverse.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\ScreenReverse.ape"
	IfFileExists "$EXEDIR\ape\texer.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\texer.ape"
	IfFileExists "$EXEDIR\ape\texer2.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\texer2.ape"
	IfFileExists "$EXEDIR\ape\triangle.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\triangle.ape"
	IfFileExists "$EXEDIR\ape\VfxAviPlayer.ape" +2
	StrCpy $ComponentsWarning "$ComponentsWarning$\n\ape\VfxAviPlayer.ape"
	
	${If} $ComponentsWarning != ""
		MessageBox MB_ABORTRETRYIGNORE|MB_ICONEXCLAMATION "${PB_NAME} is missing one or more components:$\n$ComponentsWarning$\n$\nPlease re-install ${PB_NAME} to fix this!" IDRETRY retry_Check IDIGNORE +2
		Quit
	${EndIf}

	!if ${UNICODE} == 2
		ReadRegStr $NSIS HKLM "Software\NSIS\Unicode" ""
	!else
		ReadRegStr $NSIS HKLM "Software\NSIS" ""
	!endif
	
	${If} $NSIS == ""
		error_NSIS:
		MessageBox MB_OK|MB_ICONEXCLAMATION "You need to install NSIS 2.42 (or later) before you can continue."
		Quit
	${Else}
		!if ${UNICODE} == 2
			ReadRegDWORD $0 HKLM "Software\NSIS\Unicode" "VersionMajor"
		!else
			ReadRegDWORD $0 HKLM "Software\NSIS" "VersionMajor"
		!endif
		IntCmp $0 "2" 0 error_NSIS +3
		
		!if ${UNICODE} == 2
			ReadRegDWORD $0 HKLM "Software\NSIS\Unicode" "VersionMinor"
		!else
			ReadRegDWORD $0 HKLM "Software\NSIS" "VersionMinor"
		!endif
		IntCmp $0 "42" 0 error_NSIS 0
	${EndIf}
	
	${If} ${FileExists} "$EXEDIR\bin\7za.exe"
		StrCpy $7zip "$EXEDIR\bin\7za.exe"
	${Else}
		StrCpy $noPimp 1
	${EndIf}
FunctionEnd

Function MakeInstaller
		
		;lock GUI
		EnableWindow $Page6_MakeInstaller_Button 0
		EnableWindow $CancelButton 0
		EnableWindow $BackButton 0
		
		CopyFiles /SILENT "$EXEDIR\bin\upx.exe" "$MyTempDir"
		WriteINIStr "$settingsINI" "PimpBot" "Version" "${PB_VERSION}"

		${If} $customNSI != ""
			${GetFileName} $customNSI $0
			StrCpy $customScript " [/script=$0]"
		${ElseIf} $injectSkin != ""
			StrCpy $customScript " [/waskin=$injectSkinName.wsz]"
		${EndIf}
		nxs::Show /NOUNLOAD "${PB_NAME}$customScript" /top "Preparing '$State_Name'" /sub "Adjusting Installer Settings" /h 0 /marquee 20 /end
		
		SetOutPath "$MyTempDir"
		${If} $customNSI == ""
			!ifndef PUBLIC_SOURCE
				File /oname=script.nsi "_script.nsi"
			!else
				File /nonfatal /oname=script.nsi "_script.nsi"
			!endif
		${Else}
			CopyFiles /SILENT "$customNSI" "$MyTempDir\script.nsi"
		${EndIf}
		
		# plugin there?
		${If} ${FileExists} "$NSIS\Plugins\UAC.dll"
			${Replace} "$MyTempDir\script.nsi" "##PRE_PLUGIN_UAC##" ""
		${EndIf}
		
		#W7 Taskbar Progress plugin there?
		${If} ${FileExists} "$NSIS\Plugins\w7tbp.dll"
			${Replace} "$MyTempDir\script.nsi" "##PRE_PLUGIN_W7TASKBAR##" ""
		${EndIf}
				
		#Aero plugin there?
		ReadINIStr $0 "$settingsINI" "Settings" "AeroStyle"
		${If} ${FileExists} "$NSIS\Plugins\Aero.dll"
		${AndIf} $0 == 1
			${Replace} "$MyTempDir\script.nsi" "##PRE_PLUGIN_AERO##" ""
			
			/*
			#inverted header?
			ReadINIStr $0 "$settingsINI" "Settings" "AeroInvHead"
			${If} $0 == 1
				${Replace} "$MyTempDir\script.nsi" "##PRE_AERO_INVHEAD##" ""
			${EndIf}
			*/
		${EndIf}		
		
		#temp
		${Replace} "$MyTempDir\script.nsi" "##PLUGINTYPE##" "$State_PresetType"
		${If} $State_PresetType == "dll"
			${GetFileName} $State_PresetFile $0
			${Replace} "$MyTempDir\script.nsi" "##DLL_FILENAME##" "$0"
		${EndIf}
		
		#resourcepack?
		${If} $noAVS >= 1
			${Replace} "$MyTempDir\script.nsi" "##PRE_RESOURCEPACK##" ""
		${EndIf}
		
		#name & version		
		${WordReplace} '$State_Name' "$\"" "$$\$\"" "+" "$0"
		${Replace} "$MyTempDir\script.nsi" "##INSTALLER_NAME##" "$0"
		
		Push "&"
		Push "$0"
		Call StrCSpn
		Pop $1	
		
		${If} $1 == "&"
			${WordReplace} '$State_Name' "$\"" "$$\$\"" "+" "$0"
			${WordReplace} '$0' "&" "&&" "+" "$0"
			${Replace} "$MyTempDir\script.nsi" "##INSTALLER_NAME_AMPERSAND##" "$\"$0 $State_Version$\""
		${EndIf}
		
		${Replace} "$MyTempDir\script.nsi" "##INSTALLER_VERSION##" "$State_Version"
		${Replace} "$MyTempDir\script.nsi" "##PIMPBOT_VERSION##" "${PB_VERSION}"
		
		/*${If} $noMUI != "1"
			${Replace} "$MyTempDir\script.nsi" "##INTERFACE##" ""
		${EndIf}
		*/
		
		#ui
		${If} $State_UI == "Modern UI"
		${OrIf} $State_UI == "Modern UI (default)"
			StrCpy $noMUI 0
		${ElseIf} $State_UI == "Basic UI"
			StrCpy $noMUI 1
		${ElseIf} $State_UI == "Artwork UI"
			StrCpy $noMUI 1
			StrCpy $FileDetails 1
			StrCpy $customUI "$NSIS\Contrib\UIs\nui.exe"
			${Replace} "$MyTempDir\script.nsi" "##PRE_ARTWORK_UI##" ""
		${EndIf}
		
		
		${If} $noMUI != 1 ;Modern UI
			${If} $customUI == "" ;no custom UI
				${Replace} "$MyTempDir\script.nsi" "##PRE_IS_MUI##" ""			
			${ElseIf} $customUI != ""
			${AndIf} ${FileExists} "$customUI"
				${Replace} "$MyTempDir\script.nsi" "##PRE_IS_MUI##" ""	
				${Replace} "$MyTempDir\script.nsi" "##PRE_MUI_FILE##" ""
				${Replace} "$MyTempDir\script.nsi" "##MUI_FILE##" "$customUI"
			${Else}
			${EndIf}
		${Else} ;defauilt NSIS UI
			${If} $customUI != ""
			${AndIf} ${FileExists} "$customUI"
				${Replace} "$MyTempDir\script.nsi" "##PRE_UI_FILE##" ""
				${Replace} "$MyTempDir\script.nsi" "##UI_FILE##" "$customUI"
			${EndIf}
		${EndIf}
		
		#FileName
		StrCmp $OutputFileParam 1 +2
		ReadINIStr $OutputFile "$settingsINI" "Settings" "OutputFile" #temp

		${If} $OutputFile != ""
			${If} $OutputFile == "_INPUT"
			${AndIf} ${FileExists} $Input
			${AndIf} $OutputFile != ""
				${GetBaseName} $Input $0
				${WordReplace} "$OutputFile" "_INPUT" "$0" "+1" $OutputFile
				StrCmp $OutputFile "_INPUT" default_OutFile #fallback: avoid _INPUT.exe
			${Else}
				${WordReplace} "$OutputFile" "%%TITLE%%" "$State_Name" "+1" $OutputFile
				${WordReplace} "$OutputFile" "%%NAME%%" "$State_Name" "+1" $OutputFile #as i never seem to remember it actually should be %%TITLE%%
				${If} $State_Version != ""
					${WordReplace} "$OutputFile" "%%VERSION%%" "$State_Version" "+1" $OutputFile
				${EndIf}
				StrCmp $OutputFile "%%TITLE%%" default_OutFile #fallback: avoid %%TITLE%%.exe
				StrCmp $OutputFile "%%NAME%%" default_OutFile #fallback: avoid %%NAME%%.exe
				StrCmp $OutputFile "%%VERSION%%" default_OutFile #fallback: avoid %%VERSION%%.exe
			${EndIf}
		${Else}
			default_OutFile:
			StrCpy $OutputFile $State_Name
		${EndIf}
		
		${WordReplace} '$OutputFile' '"' "$\"" "+" '$OutputFile'
		
		loop_OutputFile:
		Push '${ILLCHARS}'
		Push '$OutputFile'
		Call StrCSpn
		Pop $0
		
		${If} $0 != ''
			${WordReplace} '$OutputFile' '$0' "" "+" '$OutputFile'
			Goto loop_OutputFile
		${EndIf}
				
		${Replace} "$MyTempDir\script.nsi" "##OUTFILE##" "$OutputFile"
		
		#Presets		
		${If} $noAVS != 1
		${AndIf} $noAVS != 2
		#${AndIf} $State_PresetDir != "$MyTempDir\$State_PresetType" #nocopy
			IfFileExists "$MyTempDir\$State_PresetType"	+2
			CreateDirectory "$MyTempDir\$State_PresetType"
	
			${If} $FileDetails != "1"
			
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying presets"
				
				${If} $State_Subfolders == 1
					CopyFiles /SILENT "$State_PresetDir\*.*" "$MyTempDir\$State_PresetType" #temp?
					
					${Replace} "$MyTempDir\script.nsi" "##PRE_PRESET_FILES##" ""
					${Replace} "$MyTempDir\script.nsi" "##PRE_SUBDIRS##" ""
					
					#delete files that are not of $State_PresetType
					${Locate} "$MyTempDir\$State_PresetType" "/L=F /G=1" "delete_Files"
				${Else}				
					${If} $State_PresetType != "dll"
						StrCmp "$State_PresetDir" "$MyTempDir\$State_PresetType" +2 #nocopy
						CopyFiles /SILENT "$State_PresetDir\*.$State_PresetType" "$MyTempDir\$State_PresetType"
						${Replace} "$MyTempDir\script.nsi" "##PRE_PRESET_FILES##" ""
					${Else}
						copy_DLL:
						${GetFileName} "$State_PresetFile" $0
						CopyFiles /SILENT "$State_PresetFile" "$MyTempDir\$State_PresetType\$0"
					${EndIf}
				${EndIf}
				
			${Else} ;$FileDetails == "1"
				
				${If} $State_Subfolders == 1 
					${Replace} "$MyTempDir\script.nsi" "##PRE_SUBDIRS##" ""
				${EndIf}
				
				${If} $State_PresetType == "dll"
					Goto copy_DLL
					#${locate::Open} "$State_PresetDir" "/D=0 /G=0 /M=*.$State_PresetType /SD=NAME /SF=NAME " $0
				${Else}
					StrCpy $arrayDir 0
					${Locate} "$State_PresetDir" "/L=FD /G=$State_Subfolders /M=*.$State_PresetType" "write_arrayDir" #/SD=NAME /SF=NAME"	
					nsArray::Sort avsFolders 16			
					StrCpy $arrayDir 0
					ClearErrors
					outerLoop:
					#nsArray::Get avsFolders /at=$arrayDir
					nsArray::GetAt avsFolders $arrayDir
					Pop $R0 
					Pop $R1
					IfErrors outerEnd
					
					${WordReplace} "$R1" "$State_PresetDir\" "" "+1" $7
					${WordReplace} "$7" "$State_PresetDir" "" "+1" $7
																	
					${If} $State_UI == "Artwork UI"
						${Replace} "$MyTempDir\script.nsi" "##ARTWORK_PRESET_FILE##" "$\t$\t$\t SetOutPath $\"$$0\$7$\"$\n##ARTWORK_PRESET_FILE##"
					${Else}
						${Replace} "$MyTempDir\script.nsi" "##PRESET_FILE##" "$\t$\t$\t SetOutPath $\"$$0\$7$\"$\n##PRESET_FILE##"
					${EndIf}
					
					###
						StrCpy $arrayFile 0
						${Locate} "$R1" "/L=F /G=0 /M=*.$State_PresetType" "write_arrayFile"
						
						nsArray::Sort avsFiles 16
						StrCpy $arrayFile 0
						ClearErrors
						innerLoop:
						#nsArray::Get avsFiles /at=$arrayFile
						nsArray::GetAt avsFiles $arrayFile
						Pop $R0 
						Pop $R2
						IfErrors innerEnd
						
						#DetailPrint "file-$arrayFile: $R1"
						${If} $State_UI == "Artwork UI"
							${Replace} "$MyTempDir\script.nsi" "##ARTWORK_PRESET_FILE##" "$\t$\t$\t $${FileProgress} $\"$R2$\"$\n##ARTWORK_PRESET_FILE##"
						${Else}
							${Replace} "$MyTempDir\script.nsi" "##PRESET_FILE##" "$\t$\t$\t File $\"$R2$\"$\n##PRESET_FILE##"
						${EndIf}
						
						${GetFileName} $R2 $3
						${If} $State_PresetDir != "$MyTempDir\$State_PresetType" #nocopy
							nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying presets: $3"
							CopyFiles /SILENT "$R2" "$MyTempDir\$State_PresetType\$7\$3"
						${Else}
							nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including presets: $3"
						${EndIf}
						
						IntOp $arrayFile $arrayFile + 1
						Goto innerLoop
						
						innerEnd:
					###
					nsArray::Length avsFiles
					Pop $count_Presets
					
					#nsArray::Clear avsFiles
					nsArray::Delete avsFiles
					
					IntOp $arrayDir $arrayDir + 1
					Goto outerLoop
					outerEnd:
					
					#nsArray::Clear avsFolders
					nsArray::Delete avsFolders
				${EndIf} ;moved from 5835
			${EndIf}
			
			${If} $State_UI == "Artwork UI"
				StrCpy $count_AllFiles 0			
				
				${If} $State_PresetType == "dll"
					StrCpy $count_Presets 1
				${EndIf}
				IntOp $count_AllFiles $count_AllFiles + $count_Presets
			${EndIf}
			
			#BabelScript
			${If} $BabelScript == "single"
				${Replace} "$MyTempDir\script.nsi" "##PRE_BABEL_S##" ""
			${ElseIf} $BabelScript == "multi"
				
				IfFileExists "$MyTempDir\babel_$State_PresetType" +2
				CreateDirectory "$MyTempDir\babel_$State_PresetType"
				
				${Replace} "$MyTempDir\script.nsi" "##PRE_BABEL_M##" ""
				
				${If} $FileDetails != "1"
				
					nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying presets"
					
					${If} $State_AltSubfolders == 1
						StrCmp "$State_AltPresetDir" "$MyTempDir\babel_$State_PresetType" +3 #nocopy
						CopyFiles /SILENT "$State_AltPresetDir\*.*" "$MyTempDir\babel_$State_PresetType" #temp
						
						${Replace} "$MyTempDir\script.nsi" "##PRE_BABEL_PRESET_FILES##" ""
						${Replace} "$MyTempDir\script.nsi" "##PRE_BABEL_SUBDIRS##" ""
						
						#delete files that are not of $State_PresetType
						${Locate} "$MyTempDir\babel_$State_PresetType" "/L=F /G=1" "delete_Files"
					${Else}	
						StrCmp "$State_AltPresetDir" "$MyTempDir\babel_$State_PresetType" +2 #nocopy
						CopyFiles /SILENT "$State_AltPresetDir\*.$State_PresetType" "$MyTempDir\babel_$State_PresetType"
						${Replace} "$MyTempDir\script.nsi" "##PRE_BABEL_PRESET_FILES##" ""
					${EndIf}
					
				${Else} ;$FileDetails == "1"
					
					${If} $State_AltSubfolders == 1 
						${Replace} "$MyTempDir\script.nsi" "##PRE_BABEL_SUBDIRS##" ""
					${EndIf}
					
					StrCpy $7 ""
					StrCpy $8 ""
									
					${If} $State_AltSubfolders == 1 
						${Replace} "$MyTempDir\script.nsi" "##PRE_BABEL_SUBDIRS##" ""
					${EndIf}
						
					StrCpy $arrayDir 0
					${Locate} "$State_AltPresetDir" "/L=FD /G=$State_AltSubfolders /M=*.$State_PresetType" "write_arrayDir" #/SD=NAME /SF=NAME"	
					nsArray::Sort avsFolders 16			
					StrCpy $arrayDir 0
					ClearErrors
					babel_outerLoop:
					#nsArray::Get avsFolders /at=$arrayDir
					nsArray::GetAt avsFolders $arrayDir
					Pop $R0 
					Pop $R1
					IfErrors babel_outerEnd
					
					${WordReplace} "$R1" "$State_AltPresetDir\" "" "+1" $7
					${WordReplace} "$R1" "$State_AltPresetDir" "" "+1" $7

					${Replace} "$MyTempDir\script.nsi" "##BABEL_PRESET_FILE##" "$\t$\t$\t SetOutPath $\"$$0\$7$\"$\n##BABEL_PRESET_FILE##"

					###
						StrCpy $arrayFile 0
						${Locate} "$R1" "/L=F /G=0 /M=*.$State_PresetType" "write_arrayFile"
						
						nsArray::Sort avsFiles 16
						StrCpy $arrayFile 0
						ClearErrors
						babel_innerLoop:
						#nsArray::Get avsFiles /at=$arrayFile
						nsArray::GetAt avsFiles $arrayFile
						Pop $R0 
						Pop $R2
						IfErrors babel_innerEnd
						
						${Replace} "$MyTempDir\script.nsi" "##BABEL_PRESET_FILE##" "$\t$\t$\t File $\"$R2$\"$\n##BABEL_PRESET_FILE##"
						
						${GetFileName} $R2 $3
						${If} $State_AltPresetDir != "$MyTempDir\babel_$State_PresetType" #nocopy
							nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying presets: $3"
							CopyFiles /SILENT "$R2" "$MyTempDir\babel_$State_PresetType\$7\$3"
						${Else}
							nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including presets: $3"
						${EndIf}

						
						IntOp $arrayFile $arrayFile + 1
						Goto babel_innerLoop
						
						babel_innerEnd:
					###
					nsArray::Length avsFiles
					Pop $count_AltPresets
					
					#nsArray::Clear avsFiles
					nsArray::Delete avsFiles
					
					IntOp $arrayDir $arrayDir + 1
					Goto babel_outerLoop
					babel_outerEnd:
					
					#nsArray::Clear avsFolders
					nsArray::Delete avsFolders
				${EndIf}
			${EndIf}
			
			${If} $State_UI == "Artwork UI"					
				IntOp $count_AllFiles $count_AllFiles + $count_AltPresets
			${EndIf}
		${EndIf}
		
		#Additional Files		
		${If} $FileDetails != 1
			${If} $State_AddFiles != ""			
			${AndIf} ${FileExists} "$State_AddFiles\*.*"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying resource files"
				
				${Replace} "$MyTempDir\script.nsi" "##PRE_RESOURCE_DIR##" ""
				${Replace} "$MyTempDir\script.nsi" "##PRE_RESOURCE_FILES##" ""
				IfFileExists "$MyTempDir\etc" +2
				CreateDirectory "$MyTempDir\etc"
				
				${If} $State_PresetType != "dll"
				#${AndIf} "$State_AddFiles" != "$MyTempDir\etc" #nocopy
					${If} $State_AddBMP == "1"
						StrCmp "$State_AddFiles" "$MyTempDir\etc" +2 #nocopy
						CopyFiles /SILENT "$State_AddFiles\*.bmp" "$MyTempDir\etc"
					${ElseIf} $State_AddBMP == "0"
					${AndIf} ${FileExists} "$MyTempDir\etc\*.bmp"
					#${AndIfNot} $State_AddFiles == "$MyTempDir\etc"
						Delete "$MyTempDir\etc\*.bmp"
					${EndIf}
					
					${If} $State_AddJPG == "1"
						StrCmp "$State_AddFiles" "$MyTempDir\etc" +2 #nocopy
						CopyFiles /SILENT "$State_AddFiles\*.jpg" "$MyTempDir\etc"
					${ElseIf} $State_AddJPG == "0"
					${AndIf} ${FileExists}  "$MyTempDir\etc\*.jpg"
					#${AndIfNot} $State_AddFiles == "$MyTempDir\etc"
						Delete "$MyTempDir\etc\*.jpg"
					${EndIf}
					
					${If} $State_AddAVI == "1"
						StrCmp "$State_AddFiles" "$MyTempDir\etc" +2 #nocopy
						CopyFiles /SILENT "$State_AddFiles\*.avi" "$MyTempDir\etc"
					${ElseIf} $State_AddAVI == "0"
					${AndIf} ${FileExists}  "$MyTempDir\etc\*.avi"
					#${AndIfNot} $State_AddFiles == "$MyTempDir\etc"
						Delete "$MyTempDir\etc\*.avi"
					${EndIf}
					
					${If} $State_AddGVM == "1"
						StrCmp "$State_AddFiles" "$MyTempDir\etc" +2 #nocopy
						CopyFiles /SILENT "$State_AddFiles\*.gvm" "$MyTempDir\etc"
					${ElseIf} $State_AddGVM == "0"
					${AndIf} ${FileExists}  "$MyTempDir\etc\*.gvm"
					#${AndIfNot} $State_AddFiles == "$MyTempDir\etc"
						Delete "$MyTempDir\etc\*.gvm"
					${EndIf}
					
					${If} $State_AddSVP == "1"
						StrCmp "$State_AddFiles" "$MyTempDir\etc" +2 #nocopy
						CopyFiles /SILENT "$State_AddFiles\*.svp" "$MyTempDir\etc"
					${ElseIf} $State_AddSVP == "0"
					${AndIf} ${FileExists}  "$MyTempDir\etc\*.svp"
					#${AndIfNot} $State_AddFiles == "$MyTempDir\etc"
						Delete "$MyTempDir\etc\*.svp"
					${EndIf}
					
					${If} $State_AddUVS == "1"
						StrCmp "$State_AddFiles" "$MyTempDir\etc" +2 #nocopy
						CopyFiles /SILENT "$State_AddFiles\*.uvs" "$MyTempDir\etc"
					${ElseIf} $State_AddUVS == "0"
					${AndIf} ${FileExists}  "$MyTempDir\etc\*.uvs"
					#${AndIfNot} $State_AddFiles == "$MyTempDir\etc"
						Delete "$MyTempDir\etc\*.uvs"
					${EndIf}
					
					${If} $State_AddCFF == "1"
						StrCmp "$State_AddFiles" "$MyTempDir\etc" +2 #nocopy
						CopyFiles /SILENT "$State_AddFiles\*.cff" "$MyTempDir\etc"
					${ElseIf} $State_AddCFF == "0"
					${AndIf} ${FileExists}  "$MyTempDir\etc\*.cff"
					#${AndIfNot} $State_AddFiles == "$MyTempDir\etc"
						Delete "$MyTempDir\etc\*.cff"
					${EndIf}
					
					${If} $State_AddCLM == "1"
						StrCmp "$State_AddFiles" "$MyTempDir\etc" +2 #nocopy
						CopyFiles /SILENT "$State_AddFiles\*.clm" "$MyTempDir\etc"
					${ElseIf} $State_AddCLM == "0"
					${AndIf} ${FileExists}  "$MyTempDir\etc\*."
					#${AndIfNot} $State_AddFiles == "$MyTempDir\etc"
						Delete "$MyTempDir\etc\*.clm"
					${EndIf}
				${Else}
					${If} ${FileExists} "$MyTempDir\etc\*.*"
						Delete "$MyTempDir\etc\*.bmp"
					${EndIf}
					StrCmp "$State_AddFiles" "$MyTempDir\etc" +2 #nocopy
					CopyFiles /SILENT "$State_AddFiles\*.*" "$MyTempDir\etc"
				${EndIf}
			${EndIf}
		${ElseIf} $FileDetails == 1
		${AndIf} ${FileExists} "$State_AddFiles\*.*"
		${AndIf} "$State_AddFiles" != ""
		#${AndIf} "$State_AddFiles" != "$MyTempDir\etc" #nocopy
					nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying resource files"
				
					${Replace} "$MyTempDir\script.nsi" "##PRE_RESOURCE_DIR##" ""
																
					StrCpy $arrayFile 0
					${Locate} "$MyTempDir\etc" "/L=F /M=*.* /G=1" "write_arrayResource"
						
					nsArray::Sort avsFiles 16
					StrCpy $arrayFile 0
					ClearErrors
					res_innerLoop:
					#nsArray::Get avsFiles /at=$arrayFile
					nsArray::GetAt avsFiles $arrayFile
					Pop $R0 
					Pop $R2
					IfErrors res_innerEnd
					
					###
					${Replace} "$MyTempDir\script.nsi" "##RESOURCE_FILE##" "File $\"$R2$\"$\n##RESOURCE_FILE##"
		
					${WordReplace} "$R2" "$State_AddFiles\" "" "+1" $7
					${GetFileName} $R2 $3
					
					${If} "$State_AddFiles" != "$MyTempDir\etc" #nocopy
						nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying resource files: $3"
						CopyFiles /SILENT "$1" "$MyTempDir\etc\$7\$3"
						MessageBox MB_OK "$$3=$3 /// $$7=$7"
					${Else}
						nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including resource files: $3"
					${EndIf}
					###
					
					IntOp $arrayFile $arrayFile + 1
					Goto res_innerLoop
					
					res_innerEnd:
				
					nsArray::Length avsFiles
					Pop $count_AddFiles
					IntOp $count_AllFiles $count_AllFiles + $count_AddFiles
					
					#nsArray::Clear avsFiles
					nsArray::Delete avsFiles
		${EndIf}
		
		#Inject Skin
		${If} ${FileExists} "$injectSkin"
		${AndIf} $injectSkin != ""
			IfFileExists "$MyTempDir\wsz" +2
			CreateDirectory "$MyTempDir\wsz"
			StrCmp "$injectSkin" "$MyTempDir\wsz\$injectSkinName.wsz" +2
			CopyFiles /SILENT "$injectSkin" "$MyTempDir\wsz\$injectSkinName.wsz"
			${Replace} "$MyTempDir\script.nsi" "##PRE_WA_SKIN##" ""
			#${Replace} "$MyTempDir\script.nsi" "##WA_SKIN##" "$injectSkin"
			${Replace} "$MyTempDir\script.nsi" "##WA_SKIN##" "wsz\$injectSkinName.wsz"
			${Replace} "$MyTempDir\script.nsi" "##PRE_WA_SKIN_NAME##" ""
			${Replace} "$MyTempDir\script.nsi" "##WA_SKIN_NAME##" "$injectSkinName"
		${EndIf}
		
		SetOverwrite ifdiff
		
		IfFileExists "$MyTempDir\ui" +2
		CreateDirectory "$MyTempDir\ui"
		
		#SplashBitmap
		${If} ${FileExists} $State_SplashBitmap
		${AndIf} $State_SplashBitmap != ""
			StrCmp "$State_SplashBitmap" "$MyTempDir\ui\splash.bmp" +3 #nocopy
			nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying UI files: Splash screen"
			CopyFiles /SILENT "$State_SplashBitmap" "$MyTempDir\ui\splash.bmp"
			${Replace} "$MyTempDir\script.nsi" "##PRE_SPLASH_BITMAP##" ""
		${ElseIf} $State_SplashBitmap == ""
		${AndIf} ${FileExists} "$MyTempDir\ui\splash.bmp"
			Delete "$MyTempDir\ui\splash.bmp"
		${EndIf}
		
		#SplashTransparency
		${If} $State_Transparency == "#ff0000 - Red"
			${Replace} "$MyTempDir\script.nsi" "##SPLASH_TRANSPARENCY##" "0xFF0000"
		${ElseIf} $State_Transparency == "#00ff00 - Green"
			${Replace} "$MyTempDir\script.nsi" "##SPLASH_TRANSPARENCY##" "0x00FF00"
		${ElseIf} $State_Transparency == "#0000ff - Blue"
			${Replace} "$MyTempDir\script.nsi" "##SPLASH_TRANSPARENCY##" "0x0000FF"
		${ElseIf} $State_Transparency == "#00ffff - Cyan"
			${Replace} "$MyTempDir\script.nsi" "##SPLASH_TRANSPARENCY##" "0x00FFFF"
		${ElseIf} $State_Transparency == "#ff00ff - Magenta"
			${Replace} "$MyTempDir\script.nsi" "##SPLASH_TRANSPARENCY##" "0xFF00FF"
		${ElseIf} $State_Transparency == "#ffff00 - Yellow"
			${Replace} "$MyTempDir\script.nsi" "##SPLASH_TRANSPARENCY##" "0xFFFF00"
		${Else}
			${Replace} "$MyTempDir\script.nsi" "##SPLASH_TRANSPARENCY##" "-1"
		${EndIf}
		
		#SplashSound
		${If} ${FileExists} $State_SplashSound
		${AndIf} $State_SplashBitmap != ""
			StrCmp "$State_SplashSound" "$MyTempDir\ui\splash.wav" +3 #nocopy
			nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying UI files: Splash sound"
			CopyFiles /SILENT "$State_SplashSound" "$MyTempDir\ui\splash.wav"
			${Replace} "$MyTempDir\script.nsi" "##PRE_SPLASH_SOUND##" ""
		${ElseIf} $State_SplashBitmap == ""
		${AndIf} ${FileExists} "$MyTempDir\ui\splash.wav"
			Delete "$MyTempDir\ui\splash.wav"
		${EndIf}
		
		#SplashTime
		${If} $State_SplashTime != ""
			${Replace} "$MyTempDir\script.nsi" "##SPLASH_TIME##" "$State_SplashTime"
		${Else}
			${Replace} "$MyTempDir\script.nsi" "##SPLASH_TIME##" "2000"
		${EndIf}
		
		
		#Icon -> precompile?
		${IfNot} ${FileExists} "$MyTempDir\ui\icon.ico"
			${If} ${FileExists} $State_Icon
			${AndIf} $State_Icon != ""
				StrCmp "$State_Icon" "$MyTempDir\ui\icon.ico" +3 #nocopy
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying UI files: Icon"
				CopyFiles /SILENT "$State_Icon" "$MyTempDir\ui\icon.ico"
			${Else}
				SetOutPath "$MyTempDir\ui"
				!ifndef PUBLIC_SOURCE
					File /oname=icon.ico "ui\icon-nubox_rmx.ico"
				!else
					File /oname=icon.ico "${NSISDIR}\Contrib\Graphics\Icons\classic-install.ico"
				!endif
			${EndIf}
		${EndIf}
		
		#Checks -> precompile?
		${IfNot} ${FileExists} "$MyTempDir\ui\checks.bmp"
			${If} ${FileExists} $State_Checks
			${AndIf} $State_Checks != ""
				StrCmp "$State_Checks" "$MyTempDir\ui\checks.bmp" +3 #nocopy
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying UI files: Checkboxes image"
				CopyFiles /SILENT "$State_Checks" "$MyTempDir\ui\checks.bmp"
			${Else}
				SetOutPath "$MyTempDir\ui"
				!ifndef PUBLIC_SOURCE
					File /oname=checks.bmp "ui\checks-glossy_rmx.bmp"
				!else
					File /oname=checks.bmp "${NSISDIR}\Contrib\Graphics\Checks\modern.bmp"
				!endif
			${EndIf}
		${EndIf}
				
		#Wizard
		${If} ${FileExists} $State_Wizard
		${AndIf} $State_Wizard != ""
			StrCmp "$State_Wizard" "$MyTempDir\ui\wizard.bmp" +3 #nocopy
			nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying UI files: Wizard image"
			CopyFiles /SILENT "$State_Wizard" "$MyTempDir\ui\wizard.bmp"
		${Else}
			SetOutPath "$MyTempDir\ui"
			!ifndef PUBLIC_SOURCE
				File /oname=wizard.bmp "ui\wizard-pimpbot.bmp"
			!else
				File /oname=wizard.bmp "${NSISDIR}\Contrib\Graphics\Wizard\win.bmp"
			!endif
		${EndIf}
		
		#License
		${If} ${FileExists} $State_License
		${AndIf} $State_License != ""
			${GetFileExt} $State_License $0
			StrCmp "$State_License" "$MyTempDir\license.$0" +3 #nocopy
			nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying License"
			CopyFiles /SILENT "$State_License" "$MyTempDir\license.$0"
			${Replace} "$MyTempDir\script.nsi" "##PRE_LICENSE##" ""
			${Replace} "$MyTempDir\script.nsi" "##LICENSETEXT##" "$0"
		${ElseIf} $State_License == ""
		${AndIf} ${FileExists} "$MyTempDir\license.rtf"
		${OrIf} ${FileExists} "$MyTempDir\license.txt"
			Delete "$MyTempDir\license.rtf"
			Delete "$MyTempDir\license.txt"
		${EndIf}
		
		#Fonts
		${If} ${FileExists} "$State_Fonts\*.ttf"
		${OrIf} ${FileExists} "$State_Fonts\*.otf"
		${AndIf} $State_Fonts != ""
			IfFileExists "$MyTempDir\inc\*.*" +2
			SetOutPath "$MyTempDir\inc"
			File "includes\FontName.nsh"
			File "includes\FontRegAdv.nsh"
			${If} $State_Fonts != "$MyTempDir\fonts" #nocopy
				IfFileExists "$MyTempDir\fonts" +2
				CreateDirectory "$MyTempDir\fonts"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying Fonts"
				IfFileExists "$State_Fonts\*.ttf" 0 +2
				CopyFiles /SILENT "$State_Fonts\*.ttf" "$MyTempDir\fonts"
				IfFileExists "$State_Fonts\*.otf" 0 +2
				CopyFiles /SILENT "$State_Fonts\*.otf" "$MyTempDir\fonts"
			${EndIf}
			${Replace} "$MyTempDir\script.nsi" "##PRE_FONTS##" ""
			
			StrCpy $count_Fonts 0
			
			StrCpy $arrayFile 0
			${Locate} "$MyTempDir\fonts" "/L=F /M=*.*tf /G=0" "write_arrayFonts"
						
			nsArray::Sort avsFiles 16
			StrCpy $arrayFile 0
			ClearErrors
			font_innerLoop:
			#nsArray::Get avsFiles /at=$arrayFile
			nsArray::GetAt avsFiles $arrayFile
			Pop $R0 
			Pop $R2
			IfErrors font_innerEnd
			
			###
			#IntOp $count_Fonts $count_Fonts + 1
			${GetFileName} "$R2" $R0
			${GetFileExt} "$R2" $R1
			${If} $R1 == "ttf"
			${OrIf} $R1 == "otf"
				${Replace} "$MyTempDir\script.nsi" "##FONTMACRO##"  "!insertmacro InstallTTF $\"$MyTempDir\fonts\$R0$\"$\r$\n##FONTMACRO##"
				${Replace} "$MyTempDir\script.nsi" "##FONT_FILENAME##"  "IfFileExists $\"$FONTS\$R0$\" 0 install_Font$\r$\n##FONT_FILENAME##"
			${EndIf}
			###
			
			IntOp $arrayFile $arrayFile + 1
			Goto font_innerLoop
			
			font_innerEnd:
			nsArray::Length avsFiles
			Pop $count_Fonts
			
			#nsArray::Clear avsFiles
			nsArray::Delete avsFiles
			IntOp $count_AllFiles $count_AllFiles + $count_Fonts

		${ElseIf} "$State_Fonts" == ""
		${AndIf} ${FileExists} "$MyTempDir\fonts\*.ttf"
		${OrIf} ${FileExists} "$MyTempDir\fonts\*.otf"
			Delete  "$MyTempDir\fonts\*.ttf"
			Delete  "$MyTempDir\fonts\*.otf"
		${EndIf}
		
		#Website
		${If} $State_WebsiteURL != ""
		${AndIf} $State_WebsiteURL != "http://"
			${Replace} "$MyTempDir\script.nsi" "##WEBURL##" "$State_WebsiteURL"
			${Replace} "$MyTempDir\script.nsi" "##WEBNAME##" "$State_WebsiteName"
			${Replace} "$MyTempDir\script.nsi" "##PRE_WWW##" ""
		${EndIf}
		
		#Components	
		${Replace} "$MyTempDir\script.nsi" "##PAGE_COMPONENTS##" "$State_Components"
		
		#Settings		
		SetOutPath $MyTempDir
		File /oname=settings.nsh "_settings.nsi"
		${Replace} "$MyTempDir\script.nsi" "##PAGE_SETTINGS##" "$State_Settings"
		
		${If} $State_Settings == "1"
			StrCpy $8 "0"
			#!warning "function not yet implemented: settings page"
			#${Locate} "$MyTempDir\$State_PresetType" "/L=D /G=$State_Subfolders" "write_PresetFolders" 
			
			StrCpy $arrayDir 0	
			${Locate} "$State_PresetDir" "/L=FD /G=$State_Subfolders" "write_arrayDir" #/SD=NAME /SF=NAME"	
			nsArray::Sort avsFolders 16		
			StrCpy $arrayDir 0
			ClearErrors
			dirstruc_outerLoop:
			#nsArray::Get avsFolders /at=$arrayDir
			nsArray::GetAt avsFolders $arrayDir
			Pop $R0 
			Pop $R1
			IfErrors dirstruc_outerEnd
			#IfErrors 0 +3
			#MessageBox MB_OK "ERROR: $$R0=$R0 | $$R1=$R1"
			#Goto dirstruc_outerEnd
			
			${WordReplace} "$R1" "$MyTempDir\$State_PresetType\" "" "+1" $1
			${WordReplace} "$1" "$MyTempDir\$State_PresetType" "" "+1" $1
			${If} $1 != ""
				${Replace} "$MyTempDir\settings.nsh" "##DIRSTRUC##" "SendMessage $$Settings_PresetDir ${CB_ADDSTRING} 0 $\"STR:$1$\"$\r$\n##DIRSTRUC##"
			${EndIf}
			
			IntOp $arrayDir $arrayDir + 1
			Goto dirstruc_outerLoop
			dirstruc_outerEnd:
			
			#nsArray::Clear avsFolders
			nsArray::Delete avsFolders
		${EndIf}	
		
		SetOutPath "$MyTempDir\languages"
		#Multilingual
		${If} $State_Multilingual == "1"
			nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying language files"
			!ifndef PUBLIC_SOURCE
				File "languages\_language_english.nsh"
				File "languages\language_*.nsh"
				!if ${UNICODE} == 2
					File "languages\unicode\language_*.nsh"
				!endif
			!else
				File /nonfatal "languages\_language_english.nsh"
				File /nonfatal "languages\language_*.nsh"
				!if ${UNICODE} == 2
					File /nonfatal "languages\unicode\language_*.nsh"
				!endif
			!endif
			
			${Replace} "$MyTempDir\script.nsi" "##PRE_MULTILINGUAL##" ""
		${Else}
			!if ${UNICODE} == 2
				${If} $BabelScript == "single"
					File "languages\unicode\language_japanese.nsh"
				${Else}
					File "languages\_language_english.nsh"
				${EndIf}
			!else
				File "languages\_language_english.nsh"
			!endif
		${EndIf}
		
		#Autoclose
		${If} $State_AutoClose == "1"
			StrCpy $0 "SetAutoClose true"
		${Else}
			StrCpy $0 "SetAutoClose false"
		${EndIf}
		${Replace} "$MyTempDir\script.nsi" "##AUTOCLOSE##" "$0"
		
		SetOutPath "$MyTempDir" #unlocks /languages
				
		#APEs
		${If} $State_PresetType == "avs"
			!ifdef INCLUDE_APE
				SetOutPath "$MyTempDir\ape"
			!else
				IfFileExists "$MyTempDir\ape\*.*" +2
				CreateDirectory "$MyTempDir\ape"
			!endif
			
			StrCpy $apeCounter 0 #APE counter
			
			#Call ApeCheck ;make sure no restricted person gets in
			
			${Replace} "$MyTempDir\script.nsi" "##APE_DIRECTORY##" "$EXEDIR\ape"			
					
			${If} $State_AddBorder == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: addborder.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_ADDBORDER##" ""
				${GetFileVersion} "${APE_SOURCE}\addborder.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_ADDBORDER##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_BufferBlend == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: buffer.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_BUFFERBLEND##" ""
				${GetFileVersion} "${APE_SOURCE}\buffer.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_BUFFERBLEND##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_ChannelShift == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: channelshift.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_CHANNELSHIFT##" ""
				${GetFileVersion} "${APE_SOURCE}\channelshift.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_CHANNELSHIFT##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_ColorMap == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: colormap.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_COLORMAP##" ""
				${GetFileVersion} "${APE_SOURCE}\colormap.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_COLORMAP##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_ColorReduction == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: colorreduction.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_COLORREDUCTION##" ""
				${GetFileVersion} "${APE_SOURCE}\colorreduction.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_COLORREDUCTION##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_ConvolutionFilter == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: convolution.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_CONVOLUTION##" ""
				${GetFileVersion} "${APE_SOURCE}\convolution.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_CONVOLUTION##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_FramerateLimiter == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: FramerateLimiter.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_FRAMERATE##" ""
				${GetFileVersion} "${APE_SOURCE}\FramerateLimiter.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_FRAMERATE##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_GlobalVarMan == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: globmgr.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_GLOBALVARMAN##" ""
				${GetFileVersion} "${APE_SOURCE}\globmgr.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_GLOBALVARMAN##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_Multiplier == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: multiplier.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_MULTIPLIER##" ""
				${GetFileVersion} "${APE_SOURCE}\multiplier.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_MULTIPLIER##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_MultiFilter == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: multifilter.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_MULTIFILTER##" ""
				${GetFileVersion} "${APE_SOURCE}\multifilter.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_MULTIFILTER##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_NegativeStrobe == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: NegativeStrobe.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_NEGATIVESTROBE##" ""
				${GetFileVersion} "${APE_SOURCE}\NegativeStrobe.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_NEGATIVESTROBE##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_Normalise == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: normalise.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_NORMALISE##" ""
				${GetFileVersion} "${APE_SOURCE}\normalise.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_NORMALISE##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_Picture2 == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: picture2.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_PICTURE2##" ""
				${GetFileVersion} "${APE_SOURCE}\picture2.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_PICTURE2##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_RGBFilter == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: RGBfilter.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_RGBFILTER##" ""
				${GetFileVersion} "${APE_SOURCE}\RGBfilter.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_RGBFILTER##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_ScreenReverse == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: ScreenReverse.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_SCREENREVERSE##" ""
				${GetFileVersion} "${APE_SOURCE}\ScreenReverse.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_SCREENREVERSE##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_Texer == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: texer.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_TEXER##" ""
				${GetFileVersion} "${APE_SOURCE}\texer.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_TEXER##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_Texer2 == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: texer2.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_TEXER2##" ""
				${GetFileVersion} "${APE_SOURCE}\texer2.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_TEXER2##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_TransAuto == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: eeltrans.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_TRANSAUTO##" ""
				${GetFileVersion} "${APE_SOURCE}\eeltrans.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_TRANSAUTO##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_Triangle == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: triangle.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_TRIANGLE##" ""
				${GetFileVersion} "${APE_SOURCE}\triangle.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_TRIANGLE##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_VfxAVIPlayer == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: VfxAviPlayer.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_VFXPLAYER##" ""
				${GetFileVersion} "${APE_SOURCE}\VfxAviPlayer.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_VFXPLAYER##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $State_VideoDelay == "1"
				nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including APE: delay.ape"
				${Replace} "$MyTempDir\script.nsi" "##APE_VIDEODELAY##" ""
				${GetFileVersion} "$EXEDIR\ape\delay.ape" $1
				StrCmp $1 "" 0 +2
				StrCpy $1 "0.0.0.0"
				${Replace} "$MyTempDir\script.nsi" "##APE_VERSION_VIDEODELAY##" $1
				IntOp $apeCounter $apeCounter + 1
			${EndIf}
			
			${If} $apeCounter != "0"
				${Replace} "$MyTempDir\script.nsi" "##PRE_PLUGINS##" ""
			${EndIf}
			
			${If} $State_UI == "Artwork UI"					
				${If} $State_PresetType == "avs"
					StrCpy $count_APEs $apeCounter
					IntOp $count_AllFiles $count_AllFiles + $count_APEs
				${EndIf}
			${EndIf}
		${EndIf}
				
		Call TexerCheck ;make sure no restricted person gets in
		
		${If} $State_TexerTug == 1
		${OrIf} $State_TexerYat == 1
		${OrIf} $State_TexerMega == 1
			IfFileExists "$MyTempDir\etc" +2
			CreateDirectory "$MyTempDir\etc"
			${Replace} "$MyTempDir\script.nsi" "##PRE_RESOURCE_DIR##" ""
			${Replace} "$MyTempDir\script.nsi" "##PRE_RESOURCE_FILES##" ""
		${EndIf}
		
		${If} $State_TexerTug == "1"
			nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying Tuggummi's Texer Images"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_11x11.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_13x13.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_15x15.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_17x17.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_19x19.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_21x21.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_23x23.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_25x25.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_27x27.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_29x29.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_fade_11x11.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_fade_13x13.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_fade_15x15.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_fade_17x17.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_fade_19x19.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_fade_21x21.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_fade_23x23.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_fade_25x25.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_fade_27x27.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_fade_29x29.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_11x11.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_13x13.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_15x15.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_17x17.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_19x19.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_21x21.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_23x23.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_25x25.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_27x27.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_29x29.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_05x05.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_07x07.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_09x09.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_11x11.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_13x13.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_15x15.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_17x17.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_19x19.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_21x21.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_23x23.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_25x25.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_27x27.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_29x29.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_11x11.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_13x13.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_15x15.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_17x17.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_19x19.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_21x21.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_23x23.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_25x25.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_27x27.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_29x29.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_10x10.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_14x14.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_18x18.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_24x24.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_28x28.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_30x30.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_4x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_6x6.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_8x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_fade_10x10.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_fade_12x12.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_fade_14x14.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_fade_16x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_fade_18x18.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_fade_20x20.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_fade_22x22.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_fade_24x24.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_fade_28x28.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_fade_30x30.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_04x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_06x06.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_08x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_10x10.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_12x12.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_14x14.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_16x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_18x18.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_20x20.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_22x22.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_24x24.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_28x28.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_30x30.bmp" "$MyTempDir\etc"

			IntOp $count_AllFiles $count_AllFiles + 85
		${EndIf}
		
		${If} $State_TexerYat == "1"
			nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying Yathosho's Texer Images"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_11x11.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_13x13.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_15x15.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_17x17.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_19x19.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_21x21.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_23x23.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_25x25.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_27x27.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_29x29.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_31x31.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_33x33.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_35x35.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_37x37.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_39x39.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_11x11.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_13x13.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_15x15.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_17x17.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_19x19.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_21x21.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_23x23.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_25x25.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_27x27.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_29x29.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_31x31.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_33x33.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_35x35.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_37x37.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_39x39.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_11x11.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_13x13.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_15x15.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_17x17.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_19x19.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_21x21.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_23x23.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_25x25.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_27x27.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_29x29.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_31x31.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_33x33.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_35x35.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_37x37.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_39x39.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_120x120.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_40x40.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_64x64.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_96x96.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_11x11.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_13x13.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_15x15.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_17x17.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_19x19.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_21x21.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_23x23.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_25x25.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_27x27.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_29x29.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_31x31.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_33x33.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_35x35.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_37x37.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_39x39.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_11x11.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_13x13.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_15x15.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_17x17.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_19x19.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_21x21.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_23x23.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_25x25.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_27x27.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_29x29.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_31x31.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_33x33.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_35x35.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_37x37.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_39x39.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_11x11.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_13x13.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_15x15.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_17x17.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_19x19.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_21x21.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_23x23.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_25x25.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_27x27.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_29x29.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_31x31.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_33x33.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_35x35.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_37x37.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_39x39.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_11x11.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_13x13.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_15x15.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_17x17.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_19x19.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_21x21.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_23x23.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_25x25.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_27x27.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_29x29.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_31x31.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_33x33.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_35x35.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_37x37.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_39x39.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_11x11.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_13x13.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_15x15.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_17x17.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_19x19.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_21x21.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_23x23.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_25x25.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_27x27.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_29x29.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_31x31.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_33x33.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_35x35.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_37x37.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_39x39.bmp" "$MyTempDir\etc"
			IntOp $count_AllFiles $count_AllFiles + 124
		${EndIf}

		${If} $State_TexerMega == "1"
			nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying Yathosho's Mega Texer Images"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_109x109.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_119x119.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_129x129.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_139x139.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_149x149.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_159x159.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_179x179.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_199x199.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_225x225.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_249x249.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_31x31.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_33x33.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_35x35.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_37x37.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_39x39.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_41x41.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_43x43.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_45x45.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_47x47.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_49x49.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_55x55.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_59x59.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_65x65.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_69x69.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_75x75.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_79x79.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_85x85.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_89x89.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_95x95.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_blur_99x99.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_109x109x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_109x109x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_109x109x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_109x109x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_109x109x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_109x109x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_119x119x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_119x119x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_119x119x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_119x119x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_119x119x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_119x119x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_129x129x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_129x129x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_129x129x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_129x129x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_129x129x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_129x129x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_139x139x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_139x139x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_139x139x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_139x139x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_139x139x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_139x139x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_149x149x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_149x149x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_149x149x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_149x149x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_149x149x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_149x149x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_159x159x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_159x159x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_159x159x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_159x159x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_159x159x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_159x159x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_159x159x64.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_179x179x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_179x179x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_179x179x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_179x179x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_179x179x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_179x179x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_179x179x64.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_199x199x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_199x199x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_199x199x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_199x199x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_199x199x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_199x199x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_199x199x64.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_225x225x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_225x225x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_225x225x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_225x225x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_225x225x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_225x225x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_225x225x64.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_249x249x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_249x249x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_249x249x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_249x249x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_249x249x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_249x249x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_249x249x64.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_31x31x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_31x31x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_31x31x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_31x31x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_33x33x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_33x33x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_33x33x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_33x33x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_35x35x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_35x35x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_35x35x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_35x35x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_37x37x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_37x37x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_37x37x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_37x37x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_39x39x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_39x39x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_39x39x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_39x39x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_41x41x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_41x41x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_41x41x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_41x41x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_43x43x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_43x43x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_43x43x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_43x43x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_45x45x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_45x45x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_45x45x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_45x45x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_47x47x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_47x47x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_47x47x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_47x47x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_49x49x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_49x49x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_49x49x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_49x49x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_49x49x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_55x55x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_55x55x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_55x55x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_55x55x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_55x55x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_59x59x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_59x59x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_59x59x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_59x59x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_59x59x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_65x65x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_65x65x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_65x65x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_65x65x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_65x65x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_69x69x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_69x69x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_69x69x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_69x69x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_69x69x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_75x75x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_75x75x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_75x75x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_75x75x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_75x75x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_79x79x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_79x79x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_79x79x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_79x79x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_79x79x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_85x85x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_85x85x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_85x85x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_85x85x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_85x85x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_89x89x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_89x89x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_89x89x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_89x89x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_89x89x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_95x95x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_95x95x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_95x95x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_95x95x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_95x95x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_99x99x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_99x99x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_99x99x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_99x99x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_99x99x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_99x99x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_109x109.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_119x119.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_129x129.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_139x139.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_149x149.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_159x159.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_179x179.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_199x199.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_225x225.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_249x249.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_31x31.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_33x33.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_35x35.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_37x37.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_39x39.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_41x41.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_43x43.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_45x45.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_47x47.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_49x49.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_55x55.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_59x59.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_65x65.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_69x69.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_75x75.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_79x79.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_85x85.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_89x89.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_95x95.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_99x99.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_100x100x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_100x100x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_100x100x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_100x100x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_100x100x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_110x110x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_110x110x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_110x110x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_110x110x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_110x110x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_120x120x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_120x120x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_120x120x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_120x120x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_120x120x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_130x130x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_130x130x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_130x130x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_130x130x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_130x130x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_140x140x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_140x140x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_140x140x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_140x140x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_140x140x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_150x150x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_150x150x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_150x150x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_150x150x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_150x150x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_160x160x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_160x160x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_160x160x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_160x160x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_160x160x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_170x170x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_170x170x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_170x170x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_170x170x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_170x170x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_170x170x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_180x180x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_180x180x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_180x180x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_180x180x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_180x180x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_180x180x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_190x190x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_190x190x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_190x190x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_190x190x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_190x190x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_190x190x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_200x200x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_200x200x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_200x200x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_200x200x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_200x200x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_200x200x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_210x210x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_210x210x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_210x210x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_210x210x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_210x210x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_210x210x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_220x220x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_220x220x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_220x220x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_220x220x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_220x220x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_220x220x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_230x230x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_230x230x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_230x230x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_230x230x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_230x230x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_230x230x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_240x240x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_240x240x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_240x240x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_240x240x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_240x240x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_240x240x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_250x250x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_250x250x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_250x250x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_250x250x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_250x250x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_250x250x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_32x32x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_32x32x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_32x32x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_36x36x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_36x36x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_36x36x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_40x40x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_40x40x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_40x40x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_40x40x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_48x48x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_48x48x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_48x48x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_48x48x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_54x54x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_54x54x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_54x54x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_54x54x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_60x60x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_60x60x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_60x60x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_60x60x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_64x64x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_64x64x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_64x64x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_64x64x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_72x72x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_72x72x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_72x72x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_72x72x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_80x80x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_80x80x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_80x80x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_80x80x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_80x80x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_90x90x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_90x90x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_90x90x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_90x90x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_90x90x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_96x96x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_96x96x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_96x96x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_96x96x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_96x96x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_100x100.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_110x110.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_120x120.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_130x130.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_140x140.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_150x150.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_160x160.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_170x170.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_180x180.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_190x190.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_200x200.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_210x210.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_220x220.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_230x230.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_240x240.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_250x250.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_32x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_36x36.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_40x40.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_48x48.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_54x54.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_60x60.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_64x64.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_72x72.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_80x80.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_90x90.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_SQUARE_sharp_96x96.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_109.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_119.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_129.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_139.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_149.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_159.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_179.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_199.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_225.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_249.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_41.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_43.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_45.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_47.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_49.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_55.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_59.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_65.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_69.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_75.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_79.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_85.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_89.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_95.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_99.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_109x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_109x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_109x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_109x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_109x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_119x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_119x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_119x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_119x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_119x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_129x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_129x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_129x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_129x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_129x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_139x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_139x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_139x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_139x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_139x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_149x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_149x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_149x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_149x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_149x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_149x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_159x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_159x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_159x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_159x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_159x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_159x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_179x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_179x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_179x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_179x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_179x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_179x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_199x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_199x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_199x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_199x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_199x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_199x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_199x48.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_225x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_225x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_225x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_225x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_225x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_225x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_225x48.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_249x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_249x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_249x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_249x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_249x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_249x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_249x48.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_41x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_41x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_41x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_41x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_43x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_43x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_43x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_43x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_45x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_45x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_45x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_45x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_47x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_47x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_47x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_47x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_49x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_49x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_49x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_49x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_55x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_55x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_55x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_55x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_59x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_59x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_59x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_59x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_65x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_65x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_65x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_65x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_69x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_69x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_69x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_69x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_75x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_75x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_75x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_75x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_75x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_79x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_79x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_79x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_79x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_79x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_85x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_85x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_85x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_85x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_85x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_89x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_89x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_89x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_89x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_89x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_95x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_95x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_95x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_95x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_95x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_99x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_99x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_99x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_99x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_99x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_109.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_119.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_129.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_139.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_149.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_159.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_179.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_199.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_225.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_249.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_41.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_43.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_45.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_47.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_49.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_55.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_59.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_65.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_69.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_75.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_79.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_85.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_89.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_95.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_99.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_109x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_109x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_109x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_109x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_109x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_119x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_119x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_119x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_119x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_119x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_129x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_129x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_129x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_129x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_129x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_139x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_139x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_139x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_139x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_139x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_149x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_149x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_149x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_149x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_149x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_149x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_159x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_159x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_159x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_159x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_159x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_159x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_179x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_179x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_179x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_179x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_179x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_179x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_199x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_199x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_199x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_199x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_199x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_199x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_199x48.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_225x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_225x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_225x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_225x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_225x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_225x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_225x48.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_249x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_249x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_249x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_249x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_249x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_249x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_249x48.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_41x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_41x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_41x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_41x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_43x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_43x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_43x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_43x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_45x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_45x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_45x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_45x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_47x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_47x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_47x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_47x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_49x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_49x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_49x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_49x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_55x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_55x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_55x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_55x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_59x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_59x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_59x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_59x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_65x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_65x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_65x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_65x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_69x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_69x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_69x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_69x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_75x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_75x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_75x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_75x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_75x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_79x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_79x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_79x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_79x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_79x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_85x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_85x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_85x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_85x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_85x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_89x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_89x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_89x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_89x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_89x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_95x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_95x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_95x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_95x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_95x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_99x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_99x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_99x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_99x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_99x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_109.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_119.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_129.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_139.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_149.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_159.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_179.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_199.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_225.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_249.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_41.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_43.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_45.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_47.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_49.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_55.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_59.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_65.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_69.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_75.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_79.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_85.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_89.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_95.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_99.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_109x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_109x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_109x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_109x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_109x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_119x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_119x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_119x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_119x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_119x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_129x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_129x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_129x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_129x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_129x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_139x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_139x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_139x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_139x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_139x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_149x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_149x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_149x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_149x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_149x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_149x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_159x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_159x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_159x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_159x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_159x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_159x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_179x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_179x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_179x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_179x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_179x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_179x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_199x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_199x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_199x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_199x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_199x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_199x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_199x48.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_225x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_225x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_225x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_225x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_225x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_225x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_225x48.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_249x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_249x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_249x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_249x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_249x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_249x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_249x48.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_41x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_41x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_41x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_41x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_43x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_43x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_43x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_43x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_45x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_45x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_45x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_45x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_47x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_47x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_47x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_47x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_49x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_49x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_49x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_49x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_55x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_55x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_55x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_55x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_59x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_59x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_59x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_59x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_65x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_65x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_65x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_65x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_69x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_69x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_69x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_69x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_75x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_75x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_75x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_75x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_75x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_79x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_79x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_79x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_79x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_79x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_85x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_85x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_85x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_85x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_85x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_89x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_89x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_89x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_89x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_89x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_95x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_95x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_95x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_95x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_95x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_99x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_99x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_99x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_99x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_99x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_109.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_119.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_129.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_139.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_149.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_159.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_179.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_199.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_225.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_249.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_41.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_43.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_45.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_47.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_49.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_55.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_59.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_65.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_69.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_75.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_79.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_85.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_89.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_95.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_99.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_109x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_109x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_109x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_109x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_109x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_119x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_119x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_119x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_119x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_119x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_129x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_129x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_129x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_129x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_129x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_139x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_139x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_139x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_139x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_139x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_149x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_149x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_149x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_149x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_149x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_149x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_159x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_159x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_159x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_159x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_159x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_159x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_179x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_179x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_179x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_179x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_179x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_179x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_199x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_199x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_199x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_199x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_199x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_199x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_199x48.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_225x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_225x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_225x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_225x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_225x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_225x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_225x48.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_249x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_249x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_249x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_249x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_249x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_249x32.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_249x48.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_41x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_41x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_41x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_41x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_43x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_43x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_43x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_43x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_45x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_45x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_45x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_45x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_47x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_47x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_47x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_47x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_49x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_49x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_49x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_49x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_55x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_55x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_55x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_55x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_59x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_59x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_59x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_59x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_65x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_65x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_65x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_65x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_69x1.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_69x2.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_69x4.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_69x8.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_75x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_75x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_75x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_75x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_75x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_79x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_79x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_79x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_79x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_79x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_85x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_85x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_85x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_85x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_85x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_89x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_89x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_89x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_89x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_89x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_95x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_95x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_95x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_95x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_95x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_99x01.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_99x02.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_99x04.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_99x08.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_99x16.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_109x109.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_119x119.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_129x129.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_139x139.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_149x149.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_159x159.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_179x179.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_199x199.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_225x225.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_249x249.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_45x45.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_49x49.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_55x55.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_59x59.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_65x65.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_69x69.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_75x75.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_79x79.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_85x85.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_89x89.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_95x95.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_DIAMOND_blur_99x99.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_109x109.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_119x119.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_129x129.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_139x139.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_149x149.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_159x159.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_179x179.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_199x199.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_225x225.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_249x249.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_45x45.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_49x49.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_55x55.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_59x59.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_65x65.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_69x69.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_75x75.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_79x79.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_85x85.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_89x89.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_95x95.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_99x99.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_109x109.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_119x119.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_129x129.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_139x139.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_149x149.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_159x159.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_179x179.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_199x199.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_225x225.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_249x249.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_45x45.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_49x49.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_55x55.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_59x59.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_65x65.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_69x69.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_75x75.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_79x79.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_85x85.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_89x89.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_95x95.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_99x99.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_109x109.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_119x119.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_129x129.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_139x139.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_149x149.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_159x159.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_179x179.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_199x199.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_225x225.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_249x249.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_45x45.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_49x49.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_55x55.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_59x59.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_65x65.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_69x69.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_75x75.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_79x79.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_85x85.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_89x89.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_95x95.bmp" "$MyTempDir\etc"
			CopyFiles /SILENT "$EXEDIR\texer\avsres_texer_STAR_blur_99x99.bmp" "$MyTempDir\etc"
			IntOp $count_AllFiles $count_AllFiles + 1066
		${EndIf}
		
		${If} $State_UI == "Artwork UI"					
			${Replace} "$MyTempDir\script.nsi" "##COUNTFILES##" "$count_AllFiles"
			${Replace} "$MyTempDir\script.nsi" "##BABEL_COUNTFILES##" "$count_AltPresets"
		${EndIf}
		
		;last ${Replace} performed
		#${textreplace::Unload}
		
		!if ${UNICODE} == 2 ;convert script
			nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Converting ANSI files to Unicode"
			${A2U} ENGLISH "$MyTempDir\script.nsi"
			${If} $State_Settings == "1"
				${A2U} ENGLISH "$MyTempDir\settings.nsh"
			${EndIf}
			${If} $State_Multilingual == "1"
				${A2U} DUTCH "$MyTempDir\languages\language_dutch.nsh"
				${A2U} FRENCH "$MyTempDir\languages\language_french.nsh"
				${A2U} GERMAN "$MyTempDir\languages\language_german.nsh"
				${A2U} HUNGARIAN "$MyTempDir\languages\language_hungarian.nsh"
				${A2U} PORTUGUESE "$MyTempDir\languages\language_portuguese.nsh"
				${A2U} RUSSIAN "$MyTempDir\languages\language_russian.nsh"
				${A2U} CHINESE_SIMPLIFIED "$MyTempDir\languages\language_simpchinese.nsh"
				${A2U} SPANISH "$MyTempDir\languages\language_spanish.nsh"
			${EndIf}
		!endif
		
		${If} $DebugLevel >= 1
		${AndIfNot} $Passive == 1
			ExecShell open $MyTempDir
			Sleep 500
			StrCmp $noOutput 1 +2
			MessageBox MB_YESNO|MB_ICONEXCLAMATION|MB_DEFBUTTON1|MB_TOPMOST "Do you want to compile your installer '$State_Name' now?" IDYES do_Compile
			${NSD_SetText} $Page6_LogFile_Link "Compilation skipped"
			nxs::Destroy
			#ShowWindow $CancelButton 0 #temp?
			EnableWindow $NextButton 0
			;unlock GUI
			EnableWindow $Page6_MakeInstaller_Button 1
			EnableWindow $CancelButton 1
			EnableWindow $BackButton 1
			Abort
		${EndIf}
		
		do_Compile:
		${If} $noExe != 1
		${AndIf} $noOutput != 1
			nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /top "Compiling '$State_Name' as $OutputFile.exe" /sub " "
			!if ${PUBLIC_SOURCE} == 1
				${If} $DebugLevel >= 2
					nsExec::Exec '"$NSIS\makensis.exe" /V4 /DPUBLIC_SOURCE=1 /O"$MyTempDir\compiler.log" "$MyTempDir\script.nsi"'
				${Else} ;default
					nsExec::Exec '"$NSIS\makensis.exe" /V1 /DPUBLIC_SOURCE=1  /O"$MyTempDir\error.log" "$MyTempDir\script.nsi"'
				${Endif}
			!else
				${If} $DebugLevel >= 2
					nsExec::Exec '"$NSIS\makensis.exe" /V4 /O"$MyTempDir\compiler.log" "$MyTempDir\script.nsi"'
				${Else} ;default
					nsExec::Exec '"$NSIS\makensis.exe" /V1 /O"$MyTempDir\error.log" "$MyTempDir\script.nsi"'
				${Endif}
			!endif
		${EndIf}
		
		${IfNot} ${FileExists} "$MyTempDir\$OutputFile.exe"
		${AndIf} $noExe != "1"
		${AndIf} $noOutput != "1"
			nxs::Destroy
			ShowWindow $Page6_CompileStatus_Label 0
			${NSD_SetText} $Page6_LogFile_Link "Compilation failed, click for details"
			ShowWindow $Page6_LogFile_Link 1
			;unlock GUI
			EnableWindow $Page6_MakeInstaller_Button 1
			EnableWindow $CancelButton 1
			EnableWindow $BackButton 1
			Abort
		${ElseIf} $noExe == 1
		${AndIf} $noOutput != 1
			#${NSD_SetText} $Page6_CompileStatus_Label "No installer requested"
			Call MakePimp 
			${If} ${FileExists} "$MyTempDir\$OutputFile.pimp"
				${NSD_SetText} $Page6_CompileStatus_Label "Creation successful!"
			${Else}
				${NSD_SetText} $Page6_CompileStatus_Label "Mmmmmh"
			${EndIf}
		${ElseIf} $noOutput != 1
			${NSD_SetText} $Page6_CompileStatus_Label "Compilation successful!"
			StrCmp $noPimp "1" +2
			Call MakePimp
		${EndIf}
				
		ShowWindow $CancelButton 0 #temp?	
		EnableWindow $NextButton 1
		EnableWindow $BackButton 1 ;unlock GUI
		
		StrCmp $OutputDir "" 0 +2
		ReadINIStr $OutputDir "$settingsINI" "Settings" "OutputDir" #temp
		
		${If} $OutputDir == "%%DESKTOP%%"
		${OrIf} $OutputDir == ""
		${OrIfNot} ${FileExists} "$OutputDir\*.*"
			StrCpy $OutputDir $DESKTOP
		${ElseIf} $OutputDir == "%%EXEDIR%%"
			StrCpy $OutputDir $EXEDIR
		${EndIf}
		
		nxs::Destroy
		
		${If} ${FileExists} "$OutputDir\$OutputFile.exe"
		${AndIf} $noOutput != 1
			MessageBox MB_YESNO|MB_ICONEXCLAMATION|MB_TOPMOST|MB_DEFBUTTON1 "An installer of the same name already exists. Overwrite?" IDYES overwrite_Installer #topmost for multitool.exe
			${NSD_SetText} $Page6_CompileStatus_Label "You decided to keep the old installer!"
			;unlock GUI
			EnableWindow $Page6_MakeInstaller_Button 1
			EnableWindow $CancelButton 1
			EnableWindow $BackButton 1
			Abort
		${ElseIf} $noOutput == 1
			Call clearTemp
			Abort
		${Else}
			overwrite_Installer:
			CopyFiles /SILENT "$MyTempDir\$OutputFile.exe" "$OutputDir"
		${EndIf}
		
		#temp
		${If} $mkZip == 1
			Call onClick_ZipButton
		${EndIf}
		
		ReadINIStr $pimpDir "$settingsINI" "Settings" "PimpDir" #temp
		
		Push $pimpDir
		Call SwapConst
		Pop $pimpDir
		
		CopyFiles /SILENT "$MyTempDir\$OutputFile.pimp" "$pimpDir\$OutputFile.pimp"
		IfFileExists "$pimpDir\$OutputFile.pimp" 0 +2 
		WriteINIStr "$settingsINI" "Settings" "LastPack" "$OutputFile.pimp"
	
		ShowWindow $Page6_CompileStatus_Label 1 #successful
		EnableWindow $Page6_MakeInstaller_Button 0
		
		#${If} $State_Fonts != ""
		#${AndIf} ${FileExists} "$NSIS\Plugins\UAC.dll"
			EnableWindow $Page6_Open_Button 1
		#${EndIf}
		EnableWindow $Page6_Show_Button 1
		EnableWindow $Page6_OpenLabel 1
		
		${If} ${FileExists} "$EXEDIR\backup.exe"
		${AndIf} $noPimp != 1
		${AndIf} $noOutput != 1
		${AndIf} ${FileExists} "$EXEDIR\bin\curl.exe"
		${AndIf} ${FileExists} "$pimpDir\$OutputFile.pimp" #you never can be too sure ;)
			EnableWindow $Page6_Backup_Button 1	
		${EndIf}
		
		EnableWindow $Page6_Backup_Label 1
		
		${If} ${FileExists} "$7zip"
		${AndIf} ${FileExists} "$OutputDir\$OutputFile.exe" #you never can be too sure ;)
			EnableWindow $Page6_Zip_Button 1
		${EndIf}
		
		EnableWindow $Page6_Zip_Label 1
		EnableWindow $Page6_TagCheckbox 1
		${NSD_GetState} $Page6_TagCheckbox $0
		StrCmp $0 "0" +3
		EnableWindow $Page6_TagFile 1
		EnableWindow $Page6_TagFile_Button 1
		Call OnChange_TagFile
FunctionEnd

Function MakePimp

		nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /top "Configuring PIMP file"
		RMDir /r "$MyTempDir\ape"
		
		!ifdef PASSPHRASE
			${If} $BabelScript == "multi"
				Delete "$MyTempDir\.babel" #careful
				nsExec::Exec '"$7zip" a -mx=9 -r -p"${PASSPHRASE}" -mhe "$MyTempDir\babel" "$MyTempDir\babel_$State_PresetType\*.*" -w"$MyTempDir"'		
				Rename "$MyTempDir\babel.7z" "$MyTempDir\.babel"
				SetFileAttributes "$MyTempDir\.babel" HIDDEN
			${EndIf}
		!endif
		
		RMDir /r "$MyTempDir\babel_$State_PresetType"
		RMDir /r "$MyTempDir\inc"
		RMDir /r "$MyTempDir\languages"
		Delete "$MyTempDir\*.pimp" #previous pimp file
		#Delete "$MyTempDir\etc" #delete 'etc' file - why is this this even necessary?!
		
		/*
		#write? pimp.xml?
		ReadINIStr $0 "$settingsINI" "Settings" "XMLini"
		
		${If} $0 == "1"
		${OrIf} $pimpINI == "pimp.xml"
			
		${EndIf}
		*/
		StrCpy $pimpINI "pimp.ini" #temporary
				
		#first write creates file
		WriteINIStr  "$MyTempDir\$pimpINI" "PimpBot" "Version" "${PB_VERSION}"
		
		ReadINIStr $0 "$MyTempDir\$pimpINI" "PimpBot" "DateCreated"
		${If} $0 == ""
			${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6
			WriteINIStr  "$MyTempDir\$pimpINI" "PimpBot" "DateCreated" "$2-$1-$0 $4:$5:$6"
		${EndIf}
		
		${If} $State_PresetType == "avs"
			WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Script" "AVS Installer"
		${ElseIf} $State_PresetType == "milk"
			WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Script" "MilkDrop Installer"
		${ElseIf} $State_PresetType == "sps"
			WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Script" "SPS Installer"
		${ElseIf} $State_PresetType == "dll"
			WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Script" "Winamp Plugin Installer"
		${EndIf}
		
		WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "UI" "$State_UI"
		WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "PresetType" "$State_PresetType"
		WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Name" "$State_Name"
		WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Version" "$State_Version"
		WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "SubFolders" "$State_Subfolders"
		
		${If} $BabelScript == "single"
			WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Babel" "s"
		${EndIf}
		
		${If} $State_Transparency == "#ff0000 - Red"
			WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Transparency" "0xFF0000"
		${ElseIf} $State_Transparency == "#00ff00 - Green"
			WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Transparency" "0x00FF00"
		${ElseIf} $State_Transparency == "#0000ff - Blue"
			WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Transparency" "0x0000FF"
		${ElseIf} $State_Transparency == "#00ffff - Cyan"
			WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Transparency" "0x00FFFF"
		${ElseIf} $State_Transparency == "#ff00ff - Magenta"
			WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Transparency" "0xFF00FF"
		${ElseIf} $State_Transparency == "#ffff00 - Yellow"
			WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Transparency" "0xFFFF00"
		${Else}
			WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Transparency" "-1"
		${EndIf}
		
		WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "SplashTime" "$State_SplashTime"
		
		${GetFileExt} "$State_License" $0
		WriteINIStr "$MyTempDir\$pimpINI" "Installer" "LicenseType" "$0"
		
		WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "WebsiteURL" "$State_WebsiteURL"
		WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "WebsiteName" "$State_WebsiteName"
		WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Components" "$State_Components"
		WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Settings" "$State_Settings"
		WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "Multilingual" "$State_Multilingual"
		WriteINIStr  "$MyTempDir\$pimpINI" "Installer" "AutoClose" "$State_AutoClose"
		
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "AddBorder" "$State_AddBorder"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "BufferBlend" "$State_BufferBlend"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "ChannelShift" "$State_ChannelShift"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "ColorMap" "$State_ColorMap"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "ColorReduction" "$State_ColorReduction"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "ConvolutionFilter" "$State_ConvolutionFilter"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "FramerateLimiter" "$State_FramerateLimiter"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "GlobalVarMan" "$State_GlobalVarMan"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "Multiplier" "$State_Multiplier"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "MultiFilter" "$State_MultiFilter"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "NegativeStrobe" "$State_NegativeStrobe"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "Normalise" "$State_Normalise"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "Picture2" "$State_Picture2"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "RGBFilter" "$State_RGBFilter"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "ScreenReverse" "$State_ScreenReverse"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "Texer" "$State_Texer"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "Texer2" "$State_Texer2"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "TransAuto" "$State_TransAuto"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "Triangle" "$State_Triangle"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "VfxAVIPlayer" "$State_VfxAVIPlayer"
		WriteINIStr  "$MyTempDir\$pimpINI" "APEs" "VideoDelay" "$State_VideoDelay"
		
		WriteINIStr  "$MyTempDir\$pimpINI" "TexerPacks" "Tuggummi" "$State_TexerTug"
		WriteINIStr  "$MyTempDir\$pimpINI" "TexerPacks" "Yathosho" "$State_TexerYat"
		WriteINIStr  "$MyTempDir\$pimpINI" "TexerPacks" "MegaTexer" "$State_TexerMega"
		
		${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6	
		WriteINIStr  "$MyTempDir\$pimpINI" "PimpBot" "DateModified" "$2-$1-$0 $4:$5:$6"
		
		${If} $DebugLevel >= 2
			MessageBox MB_YESNO|MB_ICONEXCLAMATION|MB_DEFBUTTON1|MB_TOPMOST "Do you want to compress '$OutputFile.pimp' now?" IDYES do_Compress
			Goto no_Compress
		${EndIf}
			
		do_Compress:
		SetOutPath $MyTempDir #temp
		nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /top "Compressing '$State_Name' as $OutputFile.pimp"

		#nsExec::Exec '"$7zip" a -mx=9 -r "$MyTempDir\$OutputFile.pimp" -x!ns*.* -x!*.7z -x!*.ape -x!*.ns* -x!*.old -x!*.exe -x!*.pimp -x!*_gen.bmp -x!*_genex.bmp -x!*header.bmp -x!*.dll -x!*.diz -x!*.nfo -x!*.txt -x!*.log -x!*.nsh -x!*.zip" -x!license.txt" -w"$MyTempDir" "$MyTempDir\*.*"'
		nsExec::Exec '"$7zip" a -mx=9 "$MyTempDir\$OutputFile.pimp" -ir!"$MyTempDir\$State_PresetType\" -i!"$MyTempDir\fonts\"  -i!"$MyTempDir\etc\" -i!"$MyTempDir\ui\" -i!"$MyTempDir\wsz\" -i!"$MyTempDir\.babel" -i!"$MyTempDir\license.rtf" -i!"$MyTempDir\license.txt" -i!"$MyTempDir\pimp.ini" -i!"$MyTempDir\pimp.xml" -w"$MyTempDir"'

		no_Compress:
FunctionEnd

Function onClick_LogFile
	Pop $0 ; don't forget to pop HWND of the stack
	
	${If} $DebugLevel >= 2
		ExecShell open "$MyTempDir\compiler.log"
	${Else}
		ExecShell open "$MyTempDir\error.log"
	${EndIf}
FunctionEnd

Function LoadPimp
	Call BlankState #temp?
	
	${GetParent} "$Input" $InputPath
	${GetFileName} "$Input" $InputFile
	
	#${If} $Parameter == "/noexe"
	#${OrIf} $Parameter == "/nopimp"
	#	StrCpy $Caption "$Parameter $InputFile"
	#${Else}
		StrCpy $Caption "$InputFile"
	#${EndIf}
	
	${GetSize} "$InputPath" "/M=$InputFile /S=0K /G=0" $0 $1 $2
	
	SetOutPath $MyTempDir #temp? just in case
	
	${If} $0 >= 120
		nxs::Show /NOUNLOAD "${PB_NAME}" /top "Please wait while ${PB_NAME} is extracting all files..." /sub "$\r$\nExtracting files from $InputFile ($0kb)" /h 0 /marquee 20 /end
		nsExec::Exec '"$7zip" x -o"$MyTempDir" -w"$MyTempDir" "$Input"'
		nxs::Destroy
	${Else}
		nsExec::Exec '"$7zip" x -o"$MyTempDir" -w"$MyTempDir" "$Input"'
	${EndIf}
	
	Push $MyTempDir
	Call ConvertPimp #old pimp-format?
	
	!ifdef PAGE2
	ReadINIStr $State_Name "$MyTempDir\$pimpINI" "Installer" "Name"
	ReadINIStr $State_Version "$MyTempDir\$pimpINI" "Installer" "Version"
	
	ReadINIStr $State_UI "$MyTempDir\$pimpINI" "Installer" "UI"
	${If} $State_UI == "Modern UI"
	${OrIf} $State_UI == ""
		StrCpy $State_UI "Modern UI (default)"
	${ElseIf} $State_UI == "Artwork UI"
	${AndIfNot} ${FileExists} "$NSIS\Contrib\UIs\nui.exe"
		StrCpy $State_UI "Modern UI (default)"
	${EndIf}
	
	ReadINIStr $State_PresetType "$MyTempDir\$pimpINI" "Installer" "PresetType"
	
	#Resource Installer?
	ClearErrors
	${GetSize} "$MyTempDir\$State_PresetType" "/M=*.$State_PresetType /G=1" $0 $1 $2
	
	${If} $1 == "" 
	${OrIf} $1 == 0 
		MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON1 "Is this an installer for resources only?" IDNO +2
		StrCpy $noAVS "2" #maybe keep it at 1?
	${EndIf}
	
	#Babel
	${If} $BabelScript == ""
		ReadINIStr $0 "$MyTempDir\$pimpINI" "Installer" "JScript" #only exists if manually added to $pimpINI
		ReadINIStr $1 "$MyTempDir\$pimpINI" "Installer" "Babel"
		
		${If} $0 == 1
		${OrIf} $1 == "s"
			StrCpy $BabelScript "single"
		${EndIf}
	${EndIf}
	
	ReadINIStr $Passphrase "$settingsINI" "Settings" "Passphrase"
	
	${If} ${FileExists} "$MyTempDir\.babel"
	${AndIf} $Passphrase != ""
		
		nsExec::Exec '"$7zip" x -o"$MyTempDir\babel_$State_PresetType" -p"$Passphrase" -w"$MyTempDir" "$MyTempDir\.babel"'	
		
		${GetSize} "$MyTempDir\babel_$State_PresetType" "/M=*.$State_PresetType /S=0K /G=1" $0 $1 $2
		
		${If} ${FileExists} "$MyTempDir\babel_$State_PresetType\*.*"
		${AndIf} $0 > "0"
			StrCpy $BabelScript "multi"
			StrCpy $State_AltPresetDir "$MyTempDir\babel_$State_PresetType"
			Delete "$MyTempDir\.babel"
		${ElseIf} $0 == 0 #wrong PASSPHRASE
			RMDir /r "$MyTempDir\babel_$State_PresetType"
		${EndIf}
	${EndIf}
	
	#<wtf?>
	!ifdef PAGE1
		ReadINIStr $State_TypeListNew "$MyTempDir\$pimpINI" "Installer" "Script"
		#StrCmp $State_Project "" 0 +2
		StrCmp $State_TypeListNew "" 0 +2
		StrCpy $State_Project "new"
	!endif	
	#</wtf?>
	
	${If} $State_PresetType != "dll"
		IfFileExists "$MyTempDir\$State_PresetType\*.*" 0 +3
		StrCpy $State_PresetDir "$MyTempDir\$State_PresetType"
		ReadINIStr $State_Subfolders "$MyTempDir\$pimpINI" "Installer" "SubFolders"
		StrCpy $State_AltSubfolders $State_Subfolders
	${Else}
		FindFirst $0 $1 "$MyTempDir\$State_PresetType\*.$State_PresetType"
		IfFileExists "$MyTempDir\$State_PresetType\$1" 0 +2
		StrCpy $State_PresetFile "$MyTempDir\$State_PresetType\$1"
	${EndIf}
	
	${If} $State_PresetType != "sps"
	${AndIf} ${FileExists} "$MyTempDir\etc\*.*"
		StrCpy $State_AddFiles "$MyTempDir\etc"
	${EndIf}
	!endif ;PAGE2
	
	!ifdef PAGE3
	IfFileExists "$MyTempDir\ui\splash.bmp" 0 no_Splash
	StrCpy $State_SplashBitmap "$MyTempDir\ui\splash.bmp"
	
	ReadINIStr $0 "$MyTempDir\$pimpINI" "Installer" "Transparency"
	${If} $0 == "0xFF0000"
		StrCpy $State_Transparency "#ff0000 - Red"
	${ElseIf} $0 == "0xFFFF00"
		StrCpy $State_Transparency "#ffff00 - Yellow"
	${ElseIf} $0 == "0x00FF00"
		StrCpy $State_Transparency "#00ff00 - Green"
	${ElseIf} $0 == "0x00FFFF"
		StrCpy $State_Transparency "#00ffff - Cyan"
	${ElseIf} $0 == "0x0000FF"
		StrCpy $State_Transparency "#0000ff - Blue"
	${ElseIf} $0 == "0xFF00FF"
		StrCpy $State_Transparency "#ff00ff - Magenta"
	${Else}
		StrCpy $State_Transparency "(none)"
	${EndIf}
	
	ReadINIStr $State_SplashTime "$MyTempDir\$pimpINI" "Installer" "SplashTime"
	IfFileExists "$MyTempDir\ui\splash.wav" 0 no_Splash
	StrCpy $State_SplashSound "$MyTempDir\ui\splash.wav"
	
	no_Splash:
	
	#Icon
	IfFileExists "$MyTempDir\ui\icon.ico" 0 +2
	StrCpy $State_Icon "$MyTempDir\ui\icon.ico"
	
	#Checks
	IfFileExists "$MyTempDir\ui\checks.bmp" 0 +2
	StrCpy $State_Checks "$MyTempDir\ui\checks.bmp"
	
	#Wizard
	IfFileExists "$MyTempDir\ui\wizard.bmp" 0 +2
	StrCpy $State_Wizard "$MyTempDir\ui\wizard.bmp"
	!endif ;PAGE3
	
	!ifdef PAGE4
	ReadINIStr $0 "$MyTempDir\$pimpINI" "Installer" "LicenseType"
	IfFileExists "$MyTempDir\license.$0" 0 +2
	StrCpy $State_License "$MyTempDir\license.$0"
	
	#Winamp Skin
	${If} ${FileExists} "$MyTempDir\wsz\*.wsz"
	
		FindFirst $0 $1 "$MyTempDir\wsz\*.wsz"	
		
		${GetBaseName} $1 $0
		
		${If} $1 != ""
		${AndIf} ${FileExists} "$MyTempDir\wsz\$1"
			StrCpy $injectSkin "$MyTempDir\wsz\$1"
			StrCpy $injectSkinName "$0"
		${EndIf}
	${EndIf}
	
	#Fonts				
	${If} ${FileExists} "$MyTempDir\fonts\*.ttf"
	${OrIf} ${FileExists} "$MyTempDir\fonts\*.otf"
		StrCpy $State_Fonts "$MyTempDir\fonts"
	${EndIf}
	
	ReadINIStr $State_WebsiteURL "$MyTempDir\$pimpINI" "Installer" "WebsiteURL"
	StrCmp $State_WebsiteURL "" +2
	ReadINIStr $State_WebsiteName "$MyTempDir\$pimpINI" "Installer" "WebsiteName"
	
	ReadINIStr $State_Components "$MyTempDir\$pimpINI" "Installer" "Components"
	StrCmp $State_Components "" 0 +2 #backwards compatibility
	StrCpy $State_Components 1
	
	ReadINIStr $State_Settings "$MyTempDir\$pimpINI" "Installer" "Settings"
	ReadINIStr $State_Multilingual "$MyTempDir\$pimpINI" "Installer" "Multilingual"
	ReadINIStr $State_AutoClose "$MyTempDir\$pimpINI" "Installer" "AutoClose"
	!endif ;PAGE4
	
	!ifdef PAGE5
	ReadINIStr $State_AddBorder "$MyTempDir\$pimpINI" "APEs" "AddBorder"
	ReadINIStr $State_BufferBlend "$MyTempDir\$pimpINI" "APEs" "BufferBlend"
	ReadINIStr $State_ChannelShift "$MyTempDir\$pimpINI" "APEs" "ChannelShift"
	ReadINIStr $State_ColorMap "$MyTempDir\$pimpINI" "APEs" "ColorMap"
	ReadINIStr $State_ColorReduction "$MyTempDir\$pimpINI" "APEs" "ColorReduction"
	ReadINIStr $State_ConvolutionFilter "$MyTempDir\$pimpINI" "APEs" "ConvolutionFilter"
	ReadINIStr $State_FramerateLimiter "$MyTempDir\$pimpINI" "APEs" "FramerateLimiter"
	ReadINIStr $State_GlobalVarMan "$MyTempDir\$pimpINI" "APEs" "GlobalVarMan"
	ReadINIStr $State_Multiplier "$MyTempDir\$pimpINI" "APEs" "Multiplier"
	ReadINIStr $State_MultiFilter "$MyTempDir\$pimpINI" "APEs" "MultiFilter"
	ReadINIStr $State_NegativeStrobe "$MyTempDir\$pimpINI" "APEs" "NegativeStrobe"
	ReadINIStr $State_Normalise "$MyTempDir\$pimpINI" "APEs" "Normalise"
	ReadINIStr $State_Picture2 "$MyTempDir\$pimpINI" "APEs" "Picture2"
	ReadINIStr $State_RGBFilter "$MyTempDir\$pimpINI" "APEs" "RGBFilter"
	ReadINIStr $State_ScreenReverse "$MyTempDir\$pimpINI" "APEs" "ScreenReverse"
	ReadINIStr $State_Texer "$MyTempDir\$pimpINI" "APEs" "Texer"
	ReadINIStr $State_Texer2 "$MyTempDir\$pimpINI" "APEs" "Texer2"
	ReadINIStr $State_TransAuto "$MyTempDir\$pimpINI" "APEs" "TransAuto"
	ReadINIStr $State_Triangle "$MyTempDir\$pimpINI" "APEs" "Triangle"
	ReadINIStr $State_VfxAVIPlayer "$MyTempDir\$pimpINI" "APEs" "VfxAVIPlayer"
	ReadINIStr $State_VideoDelay "$MyTempDir\$pimpINI" "APEs" "VideoDelay"
	ReadINIStr $State_TexerTug "$MyTempDir\$pimpINI" "TexerPacks" "Tuggummi"
	ReadINIStr $State_TexerYat "$MyTempDir\$pimpINI" "TexerPacks" "Yathosho"
	ReadINIStr $State_TexerMega "$MyTempDir\$pimpINI" "TexerPacks" "MegaTexer"
	!endif
	
	StrCmp $Passive "1" 0 +4
	Call MakeInstaller
	Call clearTemp
	Quit
FunctionEnd

Function DropFolder
	#StrCpy $DropFolder 1
	StrCpy $State_Project "new"
	
	#Name
	${GetFileName} "$Input" $State_Name
	StrCpy $Caption "/loaddir=$State_Name"
	
	#Presets
	${If} ${FileExists} "$Input\avs\*.*"
		!ifdef PAGE1
			StrCpy $State_TypeListNew "AVS Installer"
		!endif
		StrCpy $State_PresetType "avs"
	${ElseIf} ${FileExists} "$Input\milk\*.*"
		!ifdef PAGE1
			StrCpy $State_TypeListNew "MilkDrop Installer"
		!endif
		StrCpy $State_PresetType "milk"
	${ElseIf} ${FileExists} "$Input\sps\*.*"
		!ifdef PAGE1
			StrCpy $State_TypeListNew "SPS Installer"
		!endif
		StrCpy $State_PresetType "sps"
	${ElseIf} ${FileExists} "$Input\dll\*.dll"
		!ifdef PAGE1
			StrCpy $State_TypeListNew "Winamp Plugin Installer"
		!endif
		StrCpy $State_PresetType "dll"
	${Else}
		MessageBox MB_OK|MB_ICONEXCLAMATION "Not a valid folder."
		Abort
	${EndIf}	
	
	StrCpy $State_PresetDir "$Input\$State_PresetType"
	${IfNot} ${FileExists} "$Input\$State_PresetType\*.$State_PresetType"
	#${AndIf} $State_PresetType != "dll"
		StrCpy $State_Subfolders 1
	${EndIf}
	
	ReadINIStr $Passphrase "$settingsINI" "Settings" "Passphrase"
	
	${If} ${FileExists} "$Input\babel_$State_PresetType\*.*"
		scan_BabelM:
		StrCpy $BabelScript "multi"
		StrCpy $State_AltPresetDir "$Input\babel_$State_PresetType"
		${IfNot} ${FileExists}  "$Input\babel_$State_PresetType\*.$State_PresetType"
				StrCpy $State_AltSubfolders 1
		${EndIf}
	${ElseIf} ${FileExists} "$Input\.babel"
	${AndIf} $Passphrase != ""
		nsExec::Exec '"$7zip" x -o"$Input\babel_$State_PresetType" -w"$MyTempDir" -p"$Passphrase" "$Input\.babel"'	
		Goto scan_BabelM
	${EndIf}
	
	#Additional Files
	${If} ${FileExists} "$Input\etc\*.*"
		StrCpy $State_AddFiles "$Input\etc"
		
		IfFileExists "$Input\etc\*.bmp" 0 +2
		StrCpy $State_AddBMP 1
		
		IfFileExists "$Input\etc\*.jpg" 0 +2
		StrCpy $State_AddJPG 1
		
		IfFileExists "$Input\etc\*.avi" 0 +2
		StrCpy $State_AddAVI 1
		
		IfFileExists "$Input\etc\*.gvm" 0 +2
		StrCpy $State_AddGVM 1
		
		IfFileExists "$Input\etc\*.svp" 0 +2
		StrCpy $State_AddSVP 1
		
		IfFileExists "$Input\etc\*.uvs" 0 +2
		StrCpy $State_AddUVS 1
		
		IfFileExists "$Input\etc\*.cff" 0 +2
		StrCpy $State_AddCFF 1
		
		IfFileExists "$Input\etc\*.clm" 0 +2
		StrCpy $State_AddCLM 1
	${EndIf}
	
	#SplashScreen
	FindFirst $0 $1 "$Input\ui\*.bmp"
	${If} ${FileExists} "$Input\ui\splash.bmp" #default name
		StrCpy $State_SplashBitmap "$Input\ui\splash.bmp"
	${ElseIf} ${FileExists} "$Input\splash\splash.bmp"
		StrCpy $State_SplashBitmap "$Input\splash\splash.bmp"
	${ElseIf} $1 != ""
	${AndIf} $1 != "checks.bmp"
	${AndIf} $1 != "wizard.bmp"
		${If} $1 == "#FF0000.bmp" ;red
		${OrIf} $1 == "#F00.bmp"
			StrCpy $State_Transparency "#FF0000 - Red" 
		${ElseIf} $1 == "#FFFF00.bmp" ;yellow
		${OrIf} $1 == "#FF0.bmp"
			StrCpy $State_Transparency "#FFFF00 - Yellow"
		${ElseIf} $1 == "#00FF00.bmp" ;green
		${OrIf} $1 == "#0F0.bmp"
			StrCpy $State_Transparency "#00FF00 - Green"
		${ElseIf} $1 == "#00FFFF.bmp" ;cyan
		${OrIf} $1 == "#0FF.bmp"
			StrCpy $State_Transparency "#00FFFF - Cyan"
		${ElseIf} $1 == "#0000FF.bmp" ;blue
		${OrIf} $1 == "#00F.bmp"
			StrCpy $State_Transparency "#0000FF - Blue"
		${ElseIf} $1 == "#FF00FF.bmp" ;magenta
		${OrIf} $1 == "#F0F.bmp"
			StrCpy $State_Transparency "#FF00FF - Magenta"
		${Else}
			StrCpy $State_Transparency "(none)"
		${EndIf}
		StrCpy $State_SplashBitmap "$Input\ui\$1"
	${ElseIf} ${FileExists} "$Input\splash.bmp" # <--TOLERANCE BEGINS HERE	
		StrCpy $State_SplashBitmap "$Input\splash.bmp"
	${ElseIf} ${FileExists} "$Input\spltmp.bmp"
		StrCpy $State_SplashBitmap "$Input\spltmp.bmp"
	${EndIf} # TOLDERANCE ENDS HERE-->
	
	#SplashSound
	${If} $State_SplashBitmap != ""
		FindFirst $0 $1 "$Input\ui\*.wav"
		${If} ${FileExists} "$Input\ui\splash.wav"
			StrCpy $State_SplashSound "$Input\ui\splash.wav"
		${ElseIf} ${FileExists} "$Input\splash\splash.wav" # <--TOLERANCE BEGINS HERE
			StrCpy $State_SplashSound "$Input\splash\splash.wav"
		${ElseIf} $1 != ""
			StrCpy $State_SplashSound "$Input\ui\$1"
			${GetBaseName} "$1" $R1
			Push "${NUMERIC}"
			Push "$R1"
			Call StrCSpnReverse
			Pop $0
			StrCmp $0 "" 0 Icon
			StrCpy $State_SplashTime "$R1"
		${ElseIf} ${FileExists} "$Input\splash.wav" # <--TOLERANCE BEGINS HERE
			StrCpy $State_SplashSound "$Input\splash.wav"
		${ElseIf} ${FileExists} "$Input\spltmp.wav"
			StrCpy $State_SplashSound "$Input\spltmp.wav"
		${EndIf} # TOLDERANCE ENDS HERE-->
	${EndIf}
	
	Icon:
	FindFirst $0 $1 "$Input\ui\*.ico"
	${If} ${FileExists} "$Input\ui\icon.ico" #default name
		StrCpy $State_Icon "$Input\ui\icon.ico"
	${ElseIf} ${FileExists} "$Input\icon.ico" # <--TOLERANCE BEGINS HERE
		StrCpy $State_Icon "$Input\icon.ico"
	${ElseIf} $1 != ""
		StrCpy $State_Icon "$Input\ui\$1"
	${EndIf} # TOLDERANCE ENDS HERE-->

	#NoIcon:
	${If} ${FileExists} "$Input\ui\checks.bmp" #default name
		StrCpy $State_Checks "$Input\ui\checks.bmp"
	${ElseIf} ${FileExists} "$Input\checks.bmp"
		StrCpy $State_Checks "$Input\checks.bmp"
	${EndIf}
	
	#Wizard:
	${If} ${FileExists} "$Input\ui\wizard.bmp"
		StrCpy $State_Wizard "$Input\ui\wizard.bmp"
	${ElseIf} ${FileExists} "$Input\wizard.bmp"
		StrCpy $State_Wizard "$InputFolder\wizard.bmp"
	${EndIf}
	
	${If} ${FileExists} "$Input\license.txt"
		StrCpy $State_License "$Input\license.txt"
	${ElseIf} ${FileExists} "$Input\license.rtf"
		StrCpy $State_License "$Input\license.rtf"
	${ElseIf} ${FileExists} "$Input\readme.txt" # <--TOLERANCE BEGINS HERE
		StrCpy $State_License "$Input\readme.txt"
	${ElseIf} ${FileExists} "$Input\readme.rtf"
		StrCpy $State_License "$Input\readme.rtf"
	${EndIf} # TOLDERANCE ENDS HERE-->
	
	#Fonts
	${If} ${FileExists} "$Input\fonts\*.ttf"
	${OrIf} ${FileExists} "$Input\fonts\*.otf"
		StrCpy $State_Fonts "$Input\fonts\"
	${ElseIf} ${FileExists} "$Input\ttf\*.ttf"
	${OrIf} ${FileExists} "$Input\ttf\*.otf"
		StrCpy $State_Fonts "$Input\ttf\"
	${EndIf}
	
	#Tag
	${If} ${FileExists} "$Input\file_id.diz"
		StrCpy $State_TagFile "$Input\file_id.diz"
	${EndIf}
FunctionEnd

Function FuzzyDrop
	#cluttered?
	${If} ${FileExists} "$Input\*.avs"
	${OrIf} ${FileExists} "$Input\*.milk"
	${OrIf} ${FileExists} "$Input\*.sps"
	${OrIf} ${FileExists} "$Input\*.ico"
	${OrIf} ${FileExists} "$Input\*.bmp"
	${OrIf} ${FileExists} "$Input\*.jpg"
	${OrIf} ${FileExists} "$Input\*.avi"
	${OrIf} ${FileExists} "$Input\*.gvm"
	${OrIf} ${FileExists} "$Input\*.svp"
	${OrIf} ${FileExists} "$Input\*.uvs"
	${OrIf} ${FileExists} "$Input\*.cff"
	${OrIf} ${FileExists} "$Input\*.clm"
	${OrIf} ${FileExists} "$Input\*.wav"

		#Presets
		${If} ${FileExists} "$Input\*.avs"
			StrCpy $State_PresetType "avs"
		${ElseIf} ${FileExists} "$Input\*.milk"
			StrCpy $State_PresetType "milk"
		${ElseIf} ${FileExists} "$Input\*.sps"
			StrCpy $State_PresetType "sps"
		${ElseIf} ${FileExists} "$Input\*.dll"
			StrCpy $State_PresetType "dll"
		${EndIf}
			
		${If} $State_PresetType == ""
		${AndIfNot} ${FileExists} "$Input\$State_PresetType\*.*" #fallback
			MessageBox MB_OK|MB_ICONEXCLAMATION "No supported file type found."
			Abort
		${ElseIf} ${FileExists} "$Input\*.$State_PresetType"		
			MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON1 "This looks like a cluttered folder. Do you want to put it in order?" IDYES +2
			Abort
			CreateDirectory "$Input\$State_PresetType"
			CopyFiles /SILENT "$Input\*.$State_PresetType" "$Input\$State_PresetType"
			Delete "$Input\*.$State_PresetType"
		${EndIf}
	${EndIf}	
	
	#UI Directory
	${If} ${FileExists} "$Input\splash.bmp"
	${OrIf} ${FileExists} "$Input\#*.bmp"
	${OrIf} ${FileExists} "$Input\*.wav"
	${OrIf} ${FileExists} "$Input\*.ico"
	${OrIf} ${FileExists} "$Input\*check*.bmp"
	${OrIf} ${FileExists} "$Input\*wiz*.bmp"
		CreateDirectory "$Input\ui"
	${EndIf}
	
	#Splash Screen
	${If} ${FileExists} "$Input\splash.bmp"
		Rename "$Input\splash.bmp" "$Input\ui\splash.bmp"
		#Delete "$Input\splash.bmp"
	${ElseIf} ${FileExists} "$Input\#f00.bmp"
		Rename "$Input\#f00.bmp" "$Input\ui\#f00.bmp"
		#Delete "$Input\#f00.bmp"
	${ElseIf} ${FileExists} "$Input\#0f0.bmp"
		Rename "$Input\#0f0.bmp" "$Input\ui\#0f0.bmp"
		#Delete "$Input\#0f0.bmp"
	${ElseIf} ${FileExists} "$Input\#00f.bmp"
		Rename "$Input\#00f.bmp" "$Input\ui\#00f.bmp"
		#Delete "$Input\#00f.bmp"
	${ElseIf} ${FileExists} "$Input\#ff0.bmp"
		Rename "$Input\#ff0.bmp" "$Input\ui\#ff0.bmp"
		#Delete "$Input\#ff0.bmp"
	${ElseIf} ${FileExists} "$Input\#0ff.bmp"
		Rename "$Input\#0ff.bmp" "$Input\ui\#0ff.bmp"
		#Delete "$Input\#0ff.bmp"
	${ElseIf} ${FileExists} "$Input\#f0f.bmp"
		Rename "$Input\#f0f.bmp" "$Input\ui\#f0f.bmp"
		#Delete "$Input\#f0f.bmp"
	${ElseIf} ${FileExists} "$Input\*splash*.bmp"
		FindFirst $0 $1 "$Input\*splash*.bmp"
		Rename "$Input\$1" "$Input\ui\splash.bmp"
	${EndIf}
	
	#Splash Sound
	${If} ${FileExists} "$Input\splash.wav"
		Rename "$Input\splash.wav" "$Input\ui\splash.wav"
		#Delete "$Input\splash.wav"
	${ElseIf} ${FileExists} "$Input\*.wav"
		FindFirst $0 $1 "$Input\*.wav"
		StrCpy $2 $1 -4		
		
		Push "${NUMERIC}"
		Push $2
		Call StrCSpnReverse
		Pop $0
		
		${If} $0 == ""
			Rename "$Input\$1" "$Input\ui\$1"
			#Delete "$Input\$1"
		${Else}
			Rename "$Input\$1" "$Input\ui\splash.wav"
			#Delete "$Input\$1"
		${EndIf}
	${EndIf}
	
	#Icon
	${If} ${FileExists} "$Input\icon.ico"
		Rename "$Input\icon.ico" "$Input\ui\icon.ico"
		#Delete "$Input\icon.ico"
	${ElseIf} ${FileExists} "$Input\*.ico"
		FindFirst $0 $1 "$Input\*.ico"
		Rename "$Input\$1" "$Input\ui\icon.ico"
		#Delete "$Input\$1"
	${EndIf}
	
	#Checks
	${If} ${FileExists} "$Input\checks.bmp"
		Rename "$Input\checks.bmp" "$Input\ui\checks.bmp"
		#Delete "$Input\checks.bmp"
	${ElseIf} ${FileExists} "$Input\*check*.bmp"
		FindFirst $0 $1 "$Input\*check*.bmp"
		Rename "$Input\$1" "$Input\ui\checks.bmp"
		#Delete "$Input\$1"
	${EndIf}
	
	#Wizard
	${If} ${FileExists} "$Input\wizard.bmp"
		Rename "$Input\wizard.bmp" "$Input\ui\wizard.bmp"
		#Delete "$Input\wizard.bmp"
	${ElseIf} ${FileExists} "$Input\*wiz*.bmp"
		FindFirst $0 $1 "$Input\*wiz*.bmp"
		Rename "$Input\$1" "$Input\ui\wizard.bmp"
		#Delete "$Input\$1"
	${EndIf}
	
	#License
	${IfNot} ${FileExists} "$Input\license.txt"
	${AndIf} ${FileExists} "$Input\*.txt"
		FindFirst $0 $1 "$Input\*.txt"
		Rename "$Input\$1" "$Input\license.txt"
	${ElseIfNot} ${FileExists} "$Input\license.rtf"
	${AndIf} ${FileExists} "$Input\*.rtf"
		FindFirst $0 $1 "$Input\*.rtf"
		Rename "$Input\$1" "$Input\license.rtf"
	${EndIf}
	
	#Fonts
	${If} ${FileExists} "$Input\*.ttf"
		CreateDirectory "$Input\fonts"
		Rename "$Input\*.ttf" "$Input\fonts"
		#Delete "$Input\*.ttf"
	${EndIf}
	${If} ${FileExists} "$Input\*.otf"
		CreateDirectory "$Input\fonts"
		Rename "$Input\*.otf" "$Input\fonts"
		#Delete "$Input\*.otf"
	${EndIf}
	
	#Additional Files
	${If} ${FileExists} "$Input\*.bmp"
	${OrIf} ${FileExists} "$Input\*.jpg"
	${OrIf} ${FileExists} "$Input\*.avi"
	${OrIf} ${FileExists} "$Input\*.gvm"
	${OrIf} ${FileExists} "$Input\*.svp"
	${OrIf} ${FileExists} "$Input\*.uvs"
	${OrIf} ${FileExists} "$Input\*.cff"
	${OrIf} ${FileExists} "$Input\*.clm"
		CreateDirectory "$Input\etc"
		CopyFiles /SILENT "$Input\*.bmp" "$Input\etc"
		CopyFiles /SILENT "$Input\*.jpg" "$Input\etc"
		CopyFiles /SILENT "$Input\*.avi" "$Input\etc"
		CopyFiles /SILENT "$Input\*.gvm" "$Input\etc"
		CopyFiles /SILENT "$Input\*.svp" "$Input\etc"
		CopyFiles /SILENT "$Input\*.uvs" "$Input\etc"
		CopyFiles /SILENT "$Input\*.cff" "$Input\etc"
		CopyFiles /SILENT "$Input\*.clm" "$Input\etc"
		Delete "$Input\*.bmp"
		Delete "$Input\*.jpg"
		Delete "$Input\*.avi"
		Delete "$Input\*.gvm"
		Delete "$Input\*.svp"
		Delete "$Input\*.uvs"
		Delete "$Input\*.cff"
		Delete "$Input\*.clm"
	${EndIf}
	
FunctionEnd

Function ConvertPimp
	Exch $0
	Push $1
	
	#change order once full implemented?
	${If} ${FileExists} "$0\pimp.ini"
	${AndIf} $pimpINI == ""
		StrCpy $pimpINI "pimp.ini"
	${ElseIf} ${FileExists} "$0\pimp.xml"
	${AndIf} $pimpINI == ""
		StrCpy $pimpINI "pimp.xml"
	${EndIf}
	
	${If} ${FileExists} "$0\add\*.*"
		#SetOutPath "$0\etc"
		Rename "$0\add" "$0\etc"
		#RMDir /r "$0\add"
	${EndIf}
	
	${IfNot} ${FileExists} "$0\ui\*.*"
		CreateDirectory "$0\ui"
	${EndIf}
	
	IfFileExists "$0\splash\splash.bmp" 0 +3
	Rename "$0\splash\splash.bmp" "$0\ui\splash.bmp"
	#Delete "$0\splash\splash.bmp"
	
	IfFileExists "$0\splash\splash.wav" 0 +3
	Rename "$0\splash\splash.wav" "$0\ui\splash.wav"
	#Delete "$0\splash\splash.wav"
	
	RMDir /r "$0\splash"
	
	IfFileExists "$0\icon.ico" 0 +3
	Rename "$0\icon.ico" "$0\ui\icon.ico"
	#Delete "$0\icon.ico"
	
	IfFileExists "$0\checks.bmp" 0 +3
	CopyFiles /SILENT "$0\checks.bmp" "$0\ui\checks.bmp"
	Delete "$0\checks.bmp" 
	${If} ${FileExists} "$0\ttf\*.*"
		Rename "$0\ttf" "$0\fonts"
	${EndIf}
	
	${If} ${FileExists} "$0\$pimpINI"
		ReadINIStr $1 "$0\$pimpINI" "Installer" "Script"
		${If} $1 == "AVS Installer"
		${OrIf} $1 == "AVS Installer (Legacy Winamp)"
			WriteINIStr "$0\$pimpINI" "Installer" "PresetType" "avs"
		${ElseIf} $1 == "MilkDrop Installer"
			WriteINIStr "$0\$pimpINI" "Installer" "PresetType" "milk"
		${ElseIf} $1 == "SPS Installer"
			WriteINIStr "$0\$pimpINI" "Installer" "PresetType" "sps"
		${ElseIf} $1 == "Winamp Plugin Installer"
			WriteINIStr "$0\$pimpINI" "Installer" "PresetType" "dll"
		${EndIf}	
	
		ReadINIStr $1 "$0\$pimpINI" "Installer" "License"
		StrCmp $1 "" +2
		WriteINIStr "$0\$pimpINI" "Installer" "LicenseType" $1
		
		ReadINIStr $1 "$0\$pimpINI" "Settings" "Multilingual"
		StrCmp $1 "" +2
		WriteINIStr "$0\$pimpINI" "Installer" "Multilingual" $1
		
		ReadINIStr $1 "$0\$pimpINI" "Settings" "Settings"
		StrCmp $1 "" +2
		WriteINIStr "$0\$pimpINI" "Installer" "Settings" $1
		
		ReadINIStr $1 "$0\$pimpINI" "Settings" "AutoClose"
		StrCmp $1 "" +2
		WriteINIStr "$0\$pimpINI" "Installer" "AutoClose" $1
		
		DeleteINISec "$0\$pimpINI" "Settings"
	${EndIf}
	
	#beta left-overs
	RMDir /r "$0\languages"
	Delete "$0\*.nsh"
	Delete "$0\*.old"
	
	Pop $1
	Pop $0 ;necessary?
FunctionEnd

!ifdef PAGE1
Function BlankState
	/*
	StrCpy $State_Project ""
	StrCpy $State_NewProject_Button ""
	StrCpy $State_LoadProject_Button ""
	StrCpy $State_PimpList ""
	StrCpy $State_TypeListLoad ""
	StrCpy $State_TypeEnable ""
	*/

	/* #alternative to RMDir /r - not working!
	RMDir /r "$MyTempDir\$State_PresetType"
	RMDir /r "$MyTempDir\etc"
	RMDir /r "$MyTempDir\fonts"
	RMDir /r "$MyTempDir\languages"
	RMDir /r "$MyTempDir\ui"
	Delete  "$MyTempDir\*.*"
	*/
	
	RMDir /REBOOTOK /r "$MyTempDir"

	StrCpy $State_Name ""
	StrCpy $State_Version ""
	StrCpy $State_UI ""
	${If} $State_PresetType != "dll"
		StrCpy $State_PresetDir ""
		StrCpy $State_Subfolders ""
		StrCpy $State_AltPresetDir ""
		StrCpy $State_AltSubfolders ""
	${Else}
		StrCpy $State_PresetFile ""
	${EndIf}	
	StrCpy $State_AddFiles ""
	StrCpy $State_AddBMP ""
	StrCpy $State_AddJPG ""
	StrCpy $State_AddAVI ""
	StrCpy $State_AddGVM ""
	StrCpy $State_AddSVP ""
	StrCpy $State_AddUVS ""
	StrCpy $State_AddCFF ""
	StrCpy $State_AddCLM ""

	StrCpy $State_SplashBitmap ""
	StrCpy $State_Transparency ""
	StrCpy $State_SplashTime ""
	StrCpy $State_SplashSound ""
	StrCpy $State_Icon ""
	StrCpy $State_Checks ""
	StrCpy $State_Wizard ""

	StrCpy $State_License ""
	StrCpy $State_CreativeCommons ""
	StrCpy $State_Fonts ""
	StrCpy $State_WebsiteURL ""
	StrCpy $State_WebsiteName ""
	StrCpy $State_Components ""
	StrCpy $State_Settings ""
	StrCpy $State_Multilingual ""
	StrCpy $State_AutoClose ""

	StrCpy $State_AddBorder ""
	StrCpy $State_BufferBlend ""
	StrCpy $State_ChannelShift ""
	StrCpy $State_ColorMap ""
	StrCpy $State_ColorReduction ""
	StrCpy $State_ConvolutionFilter ""
	StrCpy $State_FramerateLimiter ""
	StrCpy $State_GlobalVarMan ""
	StrCpy $State_Multiplier ""
	StrCpy $State_MultiFilter ""
	StrCpy $State_NegativeStrobe ""
	StrCpy $State_Normalise ""
	StrCpy $State_Picture2 ""
	StrCpy $State_RGBFilter ""
	StrCpy $State_ScreenReverse ""
	StrCpy $State_Texer ""
	StrCpy $State_Texer2 ""
	StrCpy $State_TransAuto ""
	StrCpy $State_Triangle ""
	StrCpy $State_VfxAVIPlayer ""
	StrCpy $State_VideoDelay ""
FunctionEnd
!endif ;PAGE1

Function LoadDefaults

	!ifdef PAGE2
	ReadINIStr $State_Name "$defaultsINI" "Defaults" "Name"
	ReadINIStr $State_Version "$defaultsINI" "Defaults" "Version"
	
	ReadINIStr $State_UI "$defaultsINI" "Defaults" "UI"

	/*
	
	${If} $customUI == ""
	${AndIf} $State_UI != ""
		${If} ${FileExists} "$NSIS\Contrib\UIs\$0"
			StrCpy $customUI "$NSIS\Contrib\UIs\$0"
		${ElseIf} ${FileExists} "$0"
			StrCpy $customUI "$0"
		${EndIf}
		
		${GetFileName} $0 $0
		StrCpy $1 $0 6
		${If} $1 == "modern"
			StrCpy $noMUI "0"
		${Else}
			StrCpy $noMUI "1"
		${EndIf}
	${EndIf}
	
	*/
	
	${If} $State_PresetType != "dll"
		ReadINIStr $State_PresetDir "$defaultsINI" "Defaults" "PresetDir"
	${Else}
		ReadINIStr $State_PresetFile "$defaultsINI" "Defaults" "PresetDir" #temp?
	${EndIf}
	ReadINIStr $State_AddFiles "$defaultsINI" "Defaults" "AddFiles"
	!endif ;PAGE2
	
	!ifdef PAGE3
	ReadINIStr $State_SplashBitmap "$defaultsINI" "Defaults" "SplashScreen"
	ReadINIStr $State_Transparency "$defaultsINI" "Defaults" "Transparency"
	ReadINIStr $State_SplashTime "$defaultsINI" "Defaults" "SplashTime"
	ReadINIStr $State_SplashSound "$defaultsINI" "Defaults" "SplashSound"
	ReadINIStr $State_Icon "$defaultsINI" "Defaults" "Icon"
	ReadINIStr $State_Checks "$defaultsINI" "Defaults" "Checks"
	ReadINIStr $State_Wizard "$defaultsINI" "Defaults" "Wizard"
	ReadINIStr $State_License "$defaultsINI" "Defaults" "License"
	ReadINIStr $State_Fonts "$defaultsINI" "Defaults" "FontsDir"
	ReadINIStr $State_WebsiteName "$defaultsINI" "Defaults" "WebsiteName"
	ReadINIStr $State_WebsiteURL "$defaultsINI" "Defaults" "WebsiteURL"	
	
	ReadINIStr $State_Components "$defaultsINI" "Defaults" "Components"
	ReadINIStr $State_Settings "$defaultsINI" "Defaults" "Settings"
	ReadINIStr $State_Multilingual "$defaultsINI" "Defaults" "Multilingual"
	ReadINIStr $State_AutoClose "$defaultsINI" "Defaults" "AutoClose"
	!endif ;PAGE4
	
	!ifdef PAGE5
	ReadINIStr $State_AddBorder "$defaultsINI" "Defaults" "AddBorder_APE"
	ReadINIStr $State_BufferBlend "$defaultsINI" "Defaults" "BufferBlend_APE"
	ReadINIStr $State_ChannelShift "$defaultsINI" "Defaults" "ChannelShift_APE"
	ReadINIStr $State_ColorMap "$defaultsINI" "Defaults" "ColorMap_APE"
	ReadINIStr $State_ColorReduction "$defaultsINI" "Defaults" "ColorReduction_APE"
	ReadINIStr $State_ConvolutionFilter "$defaultsINI" "Defaults" "ConvolutionFilter_APE"
	ReadINIStr $State_FramerateLimiter "$defaultsINI" "Defaults" "FramerateLimiter_APE"
	ReadINIStr $State_GlobalVarMan "$defaultsINI" "Defaults" "GlobalVarMan_APE"
	ReadINIStr $State_Multiplier "$defaultsINI" "Defaults" "Multiplier_APE"
	ReadINIStr $State_MultiFilter "$defaultsINI" "Defaults" "MultiFilter_APE"
	ReadINIStr $State_NegativeStrobe "$defaultsINI" "Defaults" "NegativeStrobe_APE"
	ReadINIStr $State_Normalise "$defaultsINI" "Defaults" "Normalise_APE"
	ReadINIStr $State_Picture2 "$defaultsINI" "Defaults" "Picture2_APE"
	ReadINIStr $State_RGBFilter "$defaultsINI" "Defaults" "RGBFilter_APE"
	ReadINIStr $State_ScreenReverse "$defaultsINI" "Defaults" "ScreenReverse_APE"
	ReadINIStr $State_Texer "$defaultsINI" "Defaults" "Texer_APE"
	ReadINIStr $State_Texer2 "$defaultsINI" "Defaults" "Texer2_APE"
	ReadINIStr $State_TransAuto "$defaultsINI" "Defaults" "TransAuto_APE"
	ReadINIStr $State_Triangle "$defaultsINI" "Defaults" "Triangle_APE"
	ReadINIStr $State_VfxAVIPlayer "$defaultsINI" "Defaults" "VfxAVIPlayer_APE"
	ReadINIStr $State_VideoDelay "$defaultsINI" "Defaults" "VideoDelay_APE"
	
	ReadINIStr $State_TexerTug "$defaultsINI" "Defaults" "Tuggummi_Texer"
	ReadINIStr $State_TexerYat "$defaultsINI" "Defaults" "Yathosho_Texer"
	ReadINIStr $State_TexerYat "$defaultsINI" "Defaults" "Mega_Texer"
	!endif ;PAGE5
FunctionEnd

!ifndef PUBLIC_SOURCE
	Function HeaderColor
		GetDlgItem $0 $HWNDPARENT 1037 #Caption
		SetCtlColors $0 0xFFFFFF 0x1b1b1b
		GetDlgItem $0 $HWNDPARENT 1038 #Subcaption
		SetCtlColors $0 0xFFFFFF 0x1b1b1b
	FunctionEnd
!endif

Function ApeCheck
		StrCpy $count_APEs 21
		
		${IfNot} ${FileExists} "$EXEDIR\ape\addborder.ape"
			EnableWindow $Page5_AddBorder 0
			${NSD_SetState} $Page5_AddBorder 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_AddBorder 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\buffer.ape"
			EnableWindow $Page5_BufferBlend 0
			${NSD_SetState} $Page5_BufferBlend 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_BufferBlend 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\channelshift.ape"
			EnableWindow $Page5_ChannelShift 0
			${NSD_SetState} $Page5_ChannelShift 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_ChannelShift 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\colormap.ape"
			EnableWindow $Page5_ColorMap 0
			${NSD_SetState} $Page5_ColorMap 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_ColorMap 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\colorreduction.ape"
			EnableWindow $Page5_ColorReduction 0
			${NSD_SetState} $Page5_ColorReduction 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_ColorReduction 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\convolution.ape"
			EnableWindow $Page5_ConvolutionFilter 0
			${NSD_SetState} $Page5_ConvolutionFilter 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_ConvolutionFilter 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\delay.ape"
			EnableWindow $Page5_VideoDelay 0
			${NSD_SetState} $Page5_VideoDelay 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_VideoDelay 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\eeltrans.ape"
			EnableWindow $Page5_TransAuto 0
			${NSD_SetState} $Page5_TransAuto 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_TransAuto 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\FramerateLimiter.ape"
			EnableWindow $Page5_FramerateLimiter 0
			${NSD_SetState} $Page5_FramerateLimiter 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_FramerateLimiter 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\globmgr.ape"
			EnableWindow $Page5_GlobalVarMan 0
			${NSD_SetState} $Page5_GlobalVarMan 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_GlobalVarMan 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\multifilter.ape"
			EnableWindow $Page5_MultiFilter 0
			${NSD_SetState} $Page5_MultiFilter 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_MultiFilter 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\multiplier.ape"
			EnableWindow $Page5_Multiplier 0
			${NSD_SetState} $Page5_Multiplier 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_Multiplier 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\NegativeStrobe.ape"
			EnableWindow $Page5_NegativeStrobe 0
			${NSD_SetState} $Page5_NegativeStrobe 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_NegativeStrobe 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\normalise.ape"
			EnableWindow $Page5_Normalise 0
			${NSD_SetState} $Page5_Normalise 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_Normalise 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\picture2.ape"
			EnableWindow $Page5_Picture2 0
			${NSD_SetState} $Page5_Picture2 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_Picture2 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\RGBfilter.ape"
			EnableWindow $Page5_RGBFilter 0
			${NSD_SetState} $Page5_RGBFilter 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_RGBFilter 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\ScreenReverse.ape"
			EnableWindow $Page5_ScreenReverse 0
			${NSD_SetState} $Page5_ScreenReverse 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_ScreenReverse 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\texer.ape"
			EnableWindow $Page5_Texer 0
			${NSD_SetState} $Page5_Texer 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_Texer 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\texer2.ape"
			EnableWindow $Page5_Texer2 0
			${NSD_SetState} $Page5_Texer2 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_Texer2 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\triangle.ape"
			EnableWindow $Page5_Triangle 0
			${NSD_SetState} $Page5_Triangle 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_Triangle 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\ape\VfxAviPlayer.ape"
			EnableWindow $Page5_VfxAVIPlayer 0
			${NSD_SetState} $Page5_VfxAVIPlayer 0
			IntOp $count_APEs $count_APEs - 1
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_VfxAVIPlayer 1
		${EndIf}
						
		${If} $count_APEs == "0"
			EnableWindow $Page5_SelectAPEs 0
			EnableWindow $Page5_DetectAPEs 0
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_SelectAPEs 1
			EnableWindow $Page5_DetectAPEs 1
		${EndIf}
FunctionEnd

Function TexerCheck
		${IfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_11x11.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_13x13.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_15x15.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_17x17.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_19x19.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_21x21.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_23x23.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_25x25.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_27x27.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_edgeonly_29x29.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_fade_11x11.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_fade_13x13.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_fade_15x15.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_fade_17x17.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_fade_19x19.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_fade_21x21.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_fade_23x23.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_fade_25x25.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_fade_27x27.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_fade_29x29.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_11x11.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_13x13.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_15x15.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_17x17.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_19x19.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_21x21.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_23x23.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_25x25.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_27x27.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_heavyblur_29x29.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_05x05.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_07x07.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_09x09.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_11x11.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_13x13.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_15x15.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_17x17.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_19x19.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_21x21.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_23x23.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_25x25.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_27x27.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_29x29.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_11x11.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_13x13.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_15x15.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_17x17.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_19x19.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_21x21.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_23x23.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_25x25.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_27x27.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_slightblur_29x29.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_10x10.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_14x14.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_18x18.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_24x24.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_28x28.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_30x30.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_4x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_6x6.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_edgeonly_8x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_fade_10x10.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_fade_12x12.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_fade_14x14.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_fade_16x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_fade_18x18.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_fade_20x20.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_fade_22x22.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_fade_24x24.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_fade_28x28.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_fade_30x30.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_04x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_06x06.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_08x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_10x10.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_12x12.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_14x14.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_16x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_18x18.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_20x20.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_22x22.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_24x24.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_28x28.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_30x30.bmp"
			EnableWindow $Page5_TexerTug 0
			${NSD_SetState} $Page5_TexerTug 0
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_TexerTug 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_11x11.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_13x13.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_15x15.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_17x17.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_19x19.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_21x21.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_23x23.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_25x25.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_27x27.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_29x29.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_31x31.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_33x33.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_35x35.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_37x37.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_39x39.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_11x11.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_13x13.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_15x15.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_17x17.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_19x19.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_21x21.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_23x23.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_25x25.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_27x27.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_29x29.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_31x31.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_33x33.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_35x35.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_37x37.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-h_blur_39x39.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_11x11.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_13x13.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_15x15.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_17x17.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_19x19.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_21x21.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_23x23.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_25x25.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_27x27.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_29x29.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_31x31.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_33x33.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_35x35.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_37x37.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-v_blur_39x39.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_120x120.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_40x40.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_64x64.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_96x96.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_11x11.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_13x13.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_15x15.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_17x17.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_19x19.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_21x21.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_23x23.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_25x25.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_27x27.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_29x29.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_31x31.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_33x33.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_35x35.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_37x37.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_39x39.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_11x11.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_13x13.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_15x15.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_17x17.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_19x19.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_21x21.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_23x23.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_25x25.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_27x27.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_29x29.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_31x31.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_33x33.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_35x35.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_37x37.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_39x39.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_11x11.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_13x13.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_15x15.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_17x17.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_19x19.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_21x21.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_23x23.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_25x25.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_27x27.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_29x29.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_31x31.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_33x33.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_35x35.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_37x37.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_39x39.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_11x11.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_13x13.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_15x15.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_17x17.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_19x19.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_21x21.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_23x23.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_25x25.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_27x27.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_29x29.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_31x31.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_33x33.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_35x35.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_37x37.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_39x39.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_11x11.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_13x13.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_15x15.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_17x17.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_19x19.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_21x21.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_23x23.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_25x25.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_27x27.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_29x29.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_31x31.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_33x33.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_35x35.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_37x37.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_39x39.bmp"
			EnableWindow $Page5_TexerYat 0
			${NSD_SetState} $Page5_TexerYat 0
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_TexerYat 1
		${EndIf}
		
		${IfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_109x109.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_119x119.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_129x129.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_139x139.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_149x149.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_159x159.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_179x179.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_199x199.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_225x225.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_249x249.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_31x31.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_33x33.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_35x35.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_37x37.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_39x39.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_41x41.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_43x43.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_45x45.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_47x47.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_49x49.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_55x55.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_59x59.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_65x65.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_69x69.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_75x75.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_79x79.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_85x85.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_89x89.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_95x95.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_blur_99x99.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_109x109x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_109x109x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_109x109x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_109x109x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_109x109x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_109x109x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_119x119x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_119x119x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_119x119x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_119x119x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_119x119x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_119x119x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_129x129x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_129x129x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_129x129x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_129x129x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_129x129x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_129x129x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_139x139x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_139x139x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_139x139x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_139x139x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_139x139x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_139x139x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_149x149x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_149x149x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_149x149x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_149x149x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_149x149x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_149x149x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_159x159x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_159x159x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_159x159x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_159x159x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_159x159x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_159x159x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_159x159x64.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_179x179x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_179x179x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_179x179x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_179x179x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_179x179x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_179x179x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_179x179x64.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_199x199x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_199x199x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_199x199x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_199x199x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_199x199x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_199x199x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_199x199x64.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_225x225x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_225x225x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_225x225x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_225x225x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_225x225x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_225x225x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_225x225x64.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_249x249x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_249x249x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_249x249x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_249x249x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_249x249x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_249x249x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_249x249x64.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_31x31x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_31x31x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_31x31x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_31x31x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_33x33x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_33x33x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_33x33x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_33x33x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_35x35x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_35x35x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_35x35x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_35x35x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_37x37x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_37x37x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_37x37x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_37x37x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_39x39x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_39x39x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_39x39x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_39x39x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_41x41x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_41x41x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_41x41x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_41x41x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_43x43x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_43x43x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_43x43x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_43x43x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_45x45x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_45x45x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_45x45x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_45x45x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_47x47x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_47x47x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_47x47x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_47x47x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_49x49x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_49x49x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_49x49x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_49x49x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_49x49x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_55x55x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_55x55x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_55x55x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_55x55x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_55x55x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_59x59x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_59x59x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_59x59x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_59x59x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_59x59x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_65x65x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_65x65x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_65x65x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_65x65x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_65x65x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_69x69x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_69x69x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_69x69x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_69x69x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_69x69x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_75x75x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_75x75x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_75x75x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_75x75x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_75x75x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_79x79x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_79x79x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_79x79x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_79x79x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_79x79x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_85x85x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_85x85x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_85x85x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_85x85x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_85x85x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_89x89x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_89x89x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_89x89x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_89x89x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_89x89x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_95x95x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_95x95x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_95x95x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_95x95x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_95x95x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_99x99x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_99x99x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_99x99x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_99x99x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_99x99x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_gaussblur_99x99x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_109x109.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_119x119.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_129x129.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_139x139.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_149x149.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_159x159.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_179x179.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_199x199.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_225x225.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_249x249.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_31x31.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_33x33.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_35x35.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_37x37.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_39x39.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_41x41.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_43x43.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_45x45.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_47x47.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_49x49.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_55x55.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_59x59.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_65x65.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_69x69.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_75x75.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_79x79.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_85x85.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_89x89.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_95x95.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_CIRCLE_sharp_99x99.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_109x109.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_119x119.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_129x129.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_139x139.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_149x149.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_159x159.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_179x179.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_199x199.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_225x225.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_249x249.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_45x45.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_49x49.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_55x55.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_59x59.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_65x65.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_69x69.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_75x75.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_79x79.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_85x85.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_89x89.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_95x95.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_DIAMOND_blur_99x99.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_109x109.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_119x119.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_129x129.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_139x139.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_149x149.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_159x159.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_179x179.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_199x199.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_225x225.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_249x249.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_45x45.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_49x49.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_55x55.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_59x59.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_65x65.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_69x69.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_75x75.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_79x79.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_85x85.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_89x89.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_95x95.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-H_blur_99x99.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_109x109.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_119x119.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_129x129.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_139x139.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_149x149.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_179x179.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_199x199.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_225x225.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_249x249.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_45x45.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_49x49.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_55x55.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_59x59.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_65x65.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_69x69.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_75x75.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_79x79.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_85x85.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_89x89.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_95x95.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_HEXAGON-V_blur_99x99.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_100x100x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_100x100x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_100x100x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_100x100x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_100x100x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_110x110x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_110x110x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_110x110x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_110x110x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_110x110x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_120x120x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_120x120x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_120x120x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_120x120x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_120x120x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_130x130x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_130x130x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_130x130x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_130x130x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_130x130x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_140x140x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_140x140x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_140x140x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_140x140x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_140x140x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_150x150x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_150x150x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_150x150x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_150x150x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_150x150x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_160x160x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_160x160x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_160x160x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_160x160x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_160x160x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_170x170x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_170x170x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_170x170x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_170x170x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_170x170x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_170x170x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_180x180x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_180x180x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_180x180x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_180x180x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_180x180x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_180x180x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_190x190x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_190x190x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_190x190x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_190x190x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_190x190x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_190x190x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_200x200x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_200x200x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_200x200x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_200x200x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_200x200x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_200x200x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_210x210x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_210x210x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_210x210x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_210x210x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_210x210x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_210x210x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_220x220x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_220x220x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_220x220x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_220x220x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_220x220x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_220x220x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_230x230x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_230x230x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_230x230x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_230x230x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_230x230x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_230x230x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_240x240x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_240x240x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_240x240x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_240x240x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_240x240x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_240x240x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_250x250x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_250x250x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_250x250x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_250x250x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_250x250x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_250x250x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_32x32x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_32x32x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_32x32x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_36x36x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_36x36x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_36x36x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_40x40x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_40x40x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_40x40x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_40x40x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_48x48x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_48x48x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_48x48x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_48x48x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_54x54x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_54x54x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_54x54x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_54x54x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_60x60x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_60x60x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_60x60x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_60x60x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_64x64x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_64x64x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_64x64x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_64x64x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_72x72x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_72x72x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_72x72x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_72x72x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_80x80x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_80x80x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_80x80x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_80x80x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_80x80x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_90x90x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_90x90x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_90x90x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_90x90x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_90x90x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_96x96x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_96x96x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_96x96x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_96x96x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_gaussblur_96x96x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_100x100.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_110x110.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_120x120.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_130x130.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_140x140.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_150x150.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_160x160.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_170x170.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_180x180.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_190x190.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_200x200.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_210x210.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_220x220.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_230x230.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_240x240.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_250x250.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_32x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_36x36.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_40x40.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_48x48.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_54x54.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_60x60.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_64x64.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_72x72.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_80x80.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_90x90.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_SQUARE_sharp_96x96.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_109x109.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_119x119.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_129x129.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_139x139.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_149x149.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_159x159.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_179x179.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_199x199.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_225x225.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_249x249.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_45x45.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_49x49.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_55x55.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_59x59.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_65x65.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_69x69.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_75x75.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_79x79.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_85x85.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_89x89.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_95x95.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_STAR_blur_99x99.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_109.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_119.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_129.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_139.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_149.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_159.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_179.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_199.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_225.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_249.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_41.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_43.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_45.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_47.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_49.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_55.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_59.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_65.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_69.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_75.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_79.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_85.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_89.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_95.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_blur_99.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_109x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_109x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_109x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_109x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_109x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_119x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_119x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_119x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_119x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_119x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_129x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_129x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_129x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_129x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_129x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_139x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_139x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_139x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_139x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_139x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_149x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_149x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_149x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_149x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_149x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_149x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_159x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_159x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_159x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_159x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_159x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_159x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_179x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_179x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_179x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_179x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_179x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_179x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_199x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_199x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_199x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_199x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_199x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_199x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_199x48.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_225x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_225x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_225x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_225x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_225x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_225x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_225x48.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_249x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_249x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_249x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_249x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_249x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_249x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_249x48.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_41x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_41x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_41x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_41x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_43x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_43x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_43x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_43x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_45x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_45x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_45x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_45x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_47x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_47x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_47x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_47x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_49x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_49x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_49x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_49x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_55x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_55x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_55x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_55x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_59x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_59x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_59x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_59x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_65x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_65x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_65x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_65x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_69x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_69x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_69x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_69x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_75x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_75x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_75x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_75x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_75x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_79x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_79x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_79x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_79x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_79x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_85x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_85x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_85x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_85x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_85x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_89x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_89x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_89x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_89x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_89x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_95x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_95x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_95x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_95x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_95x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_99x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_99x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_99x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_99x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-DOWN_gaussblur_99x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_109.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_119.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_129.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_139.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_149.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_159.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_179.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_199.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_225.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_249.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_41.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_43.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_45.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_47.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_49.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_55.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_59.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_65.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_69.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_75.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_79.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_85.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_89.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_95.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_blur_99.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_109x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_109x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_109x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_109x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_109x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_119x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_119x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_119x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_119x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_119x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_129x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_129x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_129x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_129x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_129x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_139x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_139x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_139x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_139x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_139x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_149x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_149x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_149x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_149x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_149x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_149x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_159x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_159x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_159x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_159x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_159x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_159x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_179x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_179x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_179x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_179x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_179x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_179x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_199x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_199x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_199x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_199x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_199x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_199x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_199x48.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_225x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_225x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_225x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_225x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_225x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_225x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_225x48.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_249x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_249x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_249x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_249x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_249x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_249x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_249x48.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_41x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_41x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_41x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_41x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_43x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_43x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_43x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_43x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_45x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_45x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_45x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_45x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_47x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_47x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_47x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_47x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_49x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_49x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_49x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_49x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_55x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_55x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_55x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_55x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_59x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_59x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_59x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_59x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_65x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_65x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_65x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_65x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_69x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_69x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_69x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_69x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_75x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_75x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_75x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_75x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_75x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_79x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_79x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_79x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_79x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_79x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_85x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_85x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_85x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_85x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_85x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_89x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_89x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_89x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_89x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_89x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_95x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_95x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_95x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_95x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_95x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_99x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_99x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_99x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_99x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-LEFT_gaussblur_99x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_109.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_119.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_129.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_139.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_149.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_159.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_179.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_199.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_225.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_249.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_41.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_43.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_45.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_47.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_49.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_55.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_59.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_65.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_69.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_75.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_79.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_85.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_89.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_95.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_blur_99.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_109x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_109x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_109x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_109x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_109x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_119x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_119x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_119x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_119x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_119x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_129x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_129x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_129x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_129x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_129x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_139x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_139x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_139x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_139x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_139x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_149x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_149x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_149x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_149x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_149x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_149x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_159x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_159x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_159x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_159x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_159x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_159x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_179x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_179x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_179x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_179x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_179x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_179x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_199x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_199x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_199x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_199x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_199x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_199x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_199x48.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_225x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_225x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_225x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_225x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_225x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_225x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_225x48.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_249x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_249x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_249x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_249x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_249x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_249x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_249x48.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_41x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_41x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_41x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_41x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_43x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_43x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_43x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_43x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_45x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_45x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_45x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_45x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_47x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_47x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_47x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_47x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_49x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_49x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_49x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_49x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_55x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_55x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_55x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_55x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_59x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_59x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_59x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_59x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_65x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_65x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_65x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_65x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_69x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_69x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_69x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_69x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_75x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_75x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_75x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_75x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_75x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_79x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_79x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_79x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_79x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_79x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_85x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_85x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_85x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_85x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_85x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_89x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_89x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_89x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_89x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_89x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_95x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_95x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_95x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_95x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_95x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_99x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_99x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_99x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_99x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-RIGHT_gaussblur_99x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_109.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_119.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_129.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_139.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_149.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_159.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_179.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_199.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_225.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_249.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_41.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_43.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_45.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_47.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_49.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_55.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_59.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_65.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_69.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_75.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_79.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_85.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_89.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_95.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_blur_99.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_109x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_109x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_109x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_109x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_109x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_119x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_119x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_119x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_119x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_119x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_129x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_129x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_129x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_129x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_129x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_139x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_139x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_139x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_139x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_139x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_149x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_149x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_149x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_149x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_149x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_149x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_159x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_159x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_159x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_159x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_159x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_159x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_179x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_179x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_179x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_179x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_179x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_179x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_199x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_199x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_199x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_199x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_199x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_199x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_199x48.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_225x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_225x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_225x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_225x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_225x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_225x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_225x48.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_249x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_249x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_249x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_249x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_249x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_249x32.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_249x48.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_41x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_41x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_41x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_41x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_43x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_43x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_43x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_43x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_45x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_45x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_45x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_45x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_47x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_47x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_47x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_47x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_49x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_49x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_49x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_49x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_55x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_55x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_55x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_55x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_59x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_59x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_59x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_59x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_65x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_65x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_65x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_65x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_69x1.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_69x2.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_69x4.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_69x8.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_75x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_75x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_75x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_75x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_75x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_79x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_79x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_79x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_79x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_79x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_85x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_85x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_85x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_85x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_85x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_89x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_89x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_89x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_89x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_89x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_95x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_95x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_95x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_95x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_95x16.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_99x01.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_99x02.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_99x04.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_99x08.bmp"
		${OrIfNot} ${FileExists} "$EXEDIR\texer\avsres_texer_TRIANGLE-UP_gaussblur_99x16.bmp"
			EnableWindow $Page5_TexerMega 0
			${NSD_SetState} $Page5_TexerMega 0
		${Else} ;allows fixing problem on runtime
			EnableWindow $Page5_TexerMega 1
		${EndIf}
FunctionEnd

Function SwapConst
	Exch $0
	Push $1
	
	StrCpy $1 $0 5
	
	${If} $1 == "%%DES"
		${WordReplace} "$0" "%%DESKTOP%%" "$DESKTOP" "+" "$0"
	${ElseIf} $1 == "%%EXE"
		${WordReplace} "$0" "%%EXEDIR%%" "$EXEDIR" "+" "$0"
	${ElseIf} $1 == "%%MYD"
		${WordReplace} "$0" "%%MYDOCS%%" "$DOCUMENTS" "+" "$0"
	${ElseIf} $1 == "%%OUT"
		${WordReplace} "$pimpDir" "%%OUTDIR%%" "$OUTDIR" "+" "$pimpDir"
	${EndIf}
	
	Pop $1
	Exch $0
FunctionEnd

Function clearTemp
	SetOutPath $PLUGINSDIR
	RMDir /r /REBOOTOK "$MyTempDir"
	Delete "$tempFile"
FunctionEnd

Function .onGUIEnd
	Call clearTemp
FunctionEnd

Function scan_PimpDir
	; $R9 = $0   "path\name"
	; $R8 = $1   "path"
	; $R7 = $2   "name"
	; $R6 = $3   "size"  ($R6="" if directory, $R6="0" if file with /S=)
	#MessageBox MB_OK "$$R9=$R9 $$R8=$R8 $$R7=$R7 $$R6=$R6"
	IfFileExists "$R9" 0 End
	StrCmp "$R7" "$LastPack" End
	SendMessage $Page1_PimpList ${CB_ADDSTRING} 0 "STR:$R7"
	End:
	Push $0
FunctionEnd

Function scan_PresetType
	#${Locate} "$R0" "/L=F /M=*.$State_PresetType /G=1" "scan_PresetType"
	
	${If} $R8 != $R0
		#StrCpy $deepLevel 1
		${If} ${FileExists} "$R8\*.$State_PresetType"
			EnableWindow $Page2_Subfolders 1
			StrCpy $SubFolder 1
		${Else}
			EnableWindow $Page2_Subfolders 0
			StrCpy $SubFolder 0
		${EndIf}
	#${Else}
		#StrCpy $flatLevel 1
	${EndIf}
	
	Push $0
FunctionEnd

Function scan_AltPresetType
	${If} $R8 != $R0							
		${If} ${FileExists} "$R8\*.$State_PresetType"
			EnableWindow $Page2_AltSubfolders 1
			StrCpy $AltSubFolder 1
		${Else}
			EnableWindow $Page2_AltSubfolders 0
			StrCpy $AltSubFolder 0
		${EndIf}
	${EndIf}
	Push $0
FunctionEnd

;$FileDetails != 1
Function delete_Files
	IfFileExists "$R9" 0 End
	${GetFileExt} $R9 $R0
	StrCmp $R0 $State_PresetType End 0
	Delete "$R9"
	End:
	Push $0
FunctionEnd

Function write_arrayDir
	StrCmp $R8 $preVal End
	nsArray::Set avsFolders /key=$arrayDir $R8 /end
	IntOp $arrayDir $arrayDir + 1
	StrCpy $preVal $R8
	
	End:
	Push $0
FunctionEnd

Function write_arrayFile
	nsArray::Set avsFiles /key=$arrayFile $R9 /end
	IntOp $arrayFile $arrayFile + 1

	#End:
	Push $0
FunctionEnd

Function write_arrayResource
	${GetFileExt} "$R9" $R0
	
	${If} $R0 == "bmp"
	${OrIf} $R0 == "jpg"
	${OrIf} $R0 == "avi"
	${OrIf} $R0 == "gvm"
	${OrIf} $R0 == "svp"
	${OrIf} $R0 == "uvs"
	${OrIf} $R0 == "cff"
	${OrIf} $R0 == "clm"
		nsArray::Set avsFiles /key=$arrayFile $R9 /end
		IntOp $arrayFile $arrayFile + 1
	${EndIf}
	Push $0
FunctionEnd

Function write_arrayFonts
	${GetFileExt} "$R9" $R0
	
	${If} $R0 == "ttf"
	${OrIf} $R0 == "otf"
		nsArray::Set avsFiles /key=$arrayFile $R9 /end
		IntOp $arrayFile $arrayFile + 1
	${EndIf}
	Push $0
FunctionEnd

/*
Function write_Resources
	MessageBox MB_OK meep
	IfFileExists "$R9" 0 End	
	${GetFileExt} "$R9" $R0
	${If} $R0 == "bmp"
	${OrIf} $R0 == "jpg"
	${OrIf} $R0 == "avi"
	${OrIf} $R0 == "gvm"
	${OrIf} $R0 == "svp"
	${OrIf} $R0 == "uvs"
	${OrIf} $R0 == "cff"
	${OrIf} $R0 == "clm"
		${Replace} "$MyTempDir\script.nsi" "##RESOURCE_FILE##" "File $\"$R9$\"$\n  ##RESOURCE_FILE##"
		
		${GetFileName} $R9 $3
		${If} "$State_AddFiles" != "$MyTempDir\etc" #nocopy
			nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Copying resource files: $3"
			#CopyFiles /SILENT "$1" "$MyTempDir\etc\$7\$3"
			MessageBox MB_OK "$$3=$3 /// $$7=$7"
		${Else}
			nxs::Update /NOUNLOAD "${PB_NAME}$customScript" /sub "Including resource files: $3"
		${EndIf}
		
	${EndIf}
	
	End:
	Push $0
FunctionEnd

Function write_Fonts
	IfFileExists "$R9" 0 End	
	IntOp $count_Fonts $count_Fonts + 1
	${GetFileName} "$R7" $R0
	${GetFileExt} "$R7" $R1
	${If} $R1 == "ttf"
	${OrIf} $R1 == "otf"
		${Replace} "$MyTempDir\script.nsi" "##FONTMACRO##"  "!insertmacro InstallTTF $\"$MyTempDir\fonts\$R0$\"$\r$\n##FONTMACRO##"
		${Replace} "$MyTempDir\script.nsi" "##FONT_FILENAME##"  "IfFileExists $\"$FONTS\$R0$\" 0 install_Font$\r$\n##FONT_FILENAME##"
	${EndIf}
	
	End:
	Push $0
FunctionEnd
*/