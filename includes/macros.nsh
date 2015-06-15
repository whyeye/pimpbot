;macro not necessry, but it was easier replacing the old function :)
!macro ReplaceInFile SOURCE_FILE SEARCH_TEXT REPLACEMENT
	${textreplace::ReplaceInFile} "${SOURCE_FILE}" "${SOURCE_FILE}" "${SEARCH_TEXT}" "${REPLACEMENT}" "/S=1 /C=0" $DUMP
	${textreplace::unload}
!macroend
!define Replace "!insertmacro ReplaceInFile"

!if ${UNICODE} == 2
	!macro ANSI2Unicode LANGUAGE FILE
		nsExec::Exec '"$EXEDIR\bin\a2u.exe" ${LANGUAGE} "${FILE}"'
		Delete "${FILE}"
		Rename "${FILE}.u16" "${FILE}"
	!macroend
	!define A2U "!insertmacro ANSI2Unicode"
!endif

!macro DetectAPE Ape 
		StrCpy $1 $R0 1
		${If} $1 == 1
			${NSD_SetState} $Page5_${Ape} 1
			StrCpy $Detect_${Ape} 1
			IntOp $count_APEs $count_APEs + 1
		${EndIf}
		StrCpy $R0 $R0 "" 1
!macroend
!define DetectAPE "!insertmacro DetectAPE"

!if ${LOCATE_FUNCT} == 1
	!macro CountFiles CountId CountVar CountDir CountFiles 
			StrCpy ${CountVar} 0
			!if ${LOCATE_FUNCT} == 1
				${locate::Open} "${CountDir}" "/D=0 /M=${CountFiles} /G=1" $0
				StrCmp $0 0 closecount_${CountId} 0
				
				loopcount_${CountId}:
				${locate::Find} $0 $1 $2 $3 $4 $5 $6
				IfFileExists "$1" 0 closecount_${CountId}		
				IntOp ${CountVar} ${CountVar} + 1
				Goto loopcount_${CountId}
				
				closecount_${CountId}:
				${locate::Close} $0
				${locate::Unload}
			!endif
	!macroend
	!define Count "!insertmacro CountFiles"
!endif

!macro ShellExec verb app param workdir show exitoutvar ;only app and show must be != "", every thing else is optional
	#define SEE_MASK_NOCLOSEPROCESS 0x40 
	System::Store S
	System::Call '*(&i60)i.r0'
	System::Call '*$0(i 60,i 0x40,i $hwndparent,t "${verb}",t $\'${app}$\',t $\'${param}$\',t "${workdir}",i ${show})i.r0'
	System::Call 'shell32::ShellExecuteEx(ir0)i.r1 ?e'
	/*${If} $1 <> 0
		System::Call '*$0(is,i,i,i,i,i,i,i,i,i,i,i,i,i,i.r1)' ;stack value not really used, just a fancy pop ;)
		System::Call 'kernel32::WaitForSingleObject(ir1,i-1)'
		System::Call 'kernel32::GetExitCodeProcess(ir1,*i.s)'
		System::Call 'kernel32::CloseHandle(ir1)'
	${EndIf}*/
	System::Free $0
	!if "${exitoutvar}" == ""
		pop $0
	!endif
	System::Store L
	!if "${exitoutvar}" != ""
		pop ${exitoutvar}
	!endif
!macroend
!define ShellExec "!insertmacro ShellExec"