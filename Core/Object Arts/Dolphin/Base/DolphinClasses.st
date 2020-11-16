"Filed out from Dolphin Smalltalk 7"!

"Class Definitions"!

Kernel.Namespace subclass: #Core
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Kernel private})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Namespace subclass: #External
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Core} #{Kernel private} #{OS private})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Namespace subclass: #Graphics
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Core private} #{OS private} #{External private} #{Kernel private})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Namespace subclass: #Kernel
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Core} #{OS private})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Namespace subclass: #OS
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Core} #{External} #{Kernel private})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Namespace subclass: #Root
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Namespace subclass: #'Kernel.SharedPool'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Namespace subclass: #Smalltalk
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Core} #{Kernel} #{Graphics} #{UI} #{OS} #{External})
	classInstanceVariableNames: 'events allRoots allClasses classesByGuid'
	classConstants: {}!
Kernel.Namespace subclass: #Tools
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Core} #{UI private} #{Kernel private})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Namespace subclass: #UI
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Core} #{Graphics} #{OS private} #{Kernel private})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.SharedPool subclass: #'Kernel._PrimitiveFailureCode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'AccessViolation' -> -16r3FF8FC1A.
		'AssertionFailure' -> -16r17FFFBE0.
		'ClassNotRegistered' -> -16r3FFBFEAC.
		'Completed' -> 16r80000FF.
		'Failed' -> -16r3FFFBFFB.
		'FloatInvalidOperation' -> -16r17FFFF70.
		'IllegalCharacter' -> -16r17FFFE9F.
		'IllegalStateChange' -> -16r3FFFFFF3.
		'IntegerOutOfRange' -> -16r3FCDFFD8.
		'IntegerOverflow' -> -16r17FFFF6B.
		'InternalError' -> -16r17FFFF1B.
		'InvalidParameter' -> -16r17FFFFF3.
		'InvalidParameter1' -> -16r17FFFF11.
		'InvalidParameter10' -> -16r17FFFF08.
		'InvalidParameter11' -> -16r17FFFF07.
		'InvalidParameter12' -> -16r17FFFF06.
		'InvalidParameter2' -> -16r17FFFF10.
		'InvalidParameter3' -> -16r17FFFF0F.
		'InvalidParameter4' -> -16r17FFFF0E.
		'InvalidParameter5' -> -16r17FFFF0D.
		'InvalidParameter6' -> -16r17FFFF0C.
		'InvalidParameter7' -> -16r17FFFF0B.
		'InvalidParameter8' -> -16r17FFFF0A.
		'InvalidParameter9' -> -16r17FFFF09.
		'InvalidParameterMix' -> -16r17FFFFD0.
		'InvalidPointer' -> -16r3FFFBFFD.
		'InvalidVariant' -> -16r17FFFDCE.
		'NoCallbackActive' -> -16r3FF8FD9A.
		'NoMemory' -> -16r3FF8FFF8.
		'NonInstantiable' -> -16r3FF8DF59.
		'NotImplemented' -> -16r3FFFBFFF.
		'NotSupported' -> -16r17FFFF45.
		'ObjectTypeMismatch' -> -16r17FFFFDC.
		'OutOfBounds' -> -16r3FFFFFF5.
		'Pending' -> -16r3FFFFFF6.
		'Retry' -> -16r17FFFDD3.
		'SignalPending' -> -16r3FF8FF5E.
		'ThreadIsTerminating' -> -16r17FFFFB5.
		'Timeout' -> -16r3FF8FA4C.
		'UndefinedCharacter' -> -16r17FFFE9D.
		'UnmappableCharacter' -> -16r17FFFE9E.
		'Unsuccessful' -> -16r17FFFFFF.
		'WrongNumberOfArgs' -> -16r3FFD735F
	}!
Kernel.SharedPool subclass: #'Kernel.CompilerFlags'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'DebugMethod' -> 16r40.
		'Interactive' -> 16r200.
		'NoOptimize' -> 16r8.
		'NotLogged' -> 16r1.
		'SendYourself' -> 16r400.
		'SyntaxCheckOnly' -> 16r2.
		'TempsMap' -> 16r20.
		'TextMap' -> 16r10
	}!
Kernel.SharedPool subclass: #'OS.CRTConstants'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_DN_FLUSH' -> 16r1000000.
		'_DN_FLUSH_OPERANDS_SAVE_RESULTS' -> 16r2000000.
		'_DN_SAVE' -> 16r0.
		'_DN_SAVE_OPERANDS_FLUSH_RESULTS' -> 16r3000000.
		'_EM_DENORMAL' -> 16r80000.
		'_EM_INEXACT' -> 16r1.
		'_EM_INVALID' -> 16r10.
		'_EM_OVERFLOW' -> 16r4.
		'_EM_UNDERFLOW' -> 16r2.
		'_EM_ZERODIVIDE' -> 16r8.
		'_FPCLASS_ND' -> 16r10.
		'_FPCLASS_NINF' -> 16r4.
		'_FPCLASS_NN' -> 16r8.
		'_FPCLASS_NZ' -> 16r20.
		'_FPCLASS_PD' -> 16r80.
		'_FPCLASS_PINF' -> 16r200.
		'_FPCLASS_PN' -> 16r100.
		'_FPCLASS_PZ' -> 16r40.
		'_FPCLASS_QNAN' -> 16r2.
		'_FPCLASS_SNAN' -> 16r1.
		'_IC_AFFINE' -> 16r40000.
		'_IC_PROJECTIVE' -> 16r0.
		'_MAX_DIR' -> 16r100.
		'_MAX_DRIVE' -> 16r3.
		'_MAX_EXT' -> 16r100.
		'_MAX_FNAME' -> 16r100.
		'_MAX_PATH' -> 16r104.
		'_MCW_DN' -> 16r3000000.
		'_MCW_EM' -> 16r8001F.
		'_MCW_IC' -> 16r40000.
		'_MCW_PC' -> 16r30000.
		'_MCW_RC' -> 16r300.
		'_O_APPEND' -> 16r8.
		'_O_BINARY' -> 16r8000.
		'_O_CREAT' -> 16r100.
		'_O_EXCL' -> 16r400.
		'_O_NOINHERIT' -> 16r80.
		'_O_OBTAIN_DIR' -> 16r2000.
		'_O_RANDOM' -> 16r10.
		'_O_RDONLY' -> 16r0.
		'_O_RDWR' -> 16r2.
		'_O_SEQUENTIAL' -> 16r20.
		'_O_SHORT_LIVED' -> 16r1000.
		'_O_TEMPORARY' -> 16r40.
		'_O_TEXT' -> 16r4000.
		'_O_TRUNC' -> 16r200.
		'_O_U16TEXT' -> 16r20000.
		'_O_U8TEXT' -> 16r40000.
		'_O_WRONLY' -> 16r1.
		'_O_WTEXT' -> 16r10000.
		'_PC_24' -> 16r20000.
		'_PC_53' -> 16r10000.
		'_PC_64' -> 16r0.
		'_RC_CHOP' -> 16r300.
		'_RC_DOWN' -> 16r100.
		'_RC_NEAR' -> 16r0.
		'_RC_UP' -> 16r200.
		'_S_IEXEC' -> 16r40.
		'_S_IREAD' -> 16r100.
		'_S_IWRITE' -> 16r80.
		'_SW_DENORMAL' -> 16r80000.
		'_SW_INEXACT' -> 16r1.
		'_SW_INVALID' -> 16r10.
		'_SW_OVERFLOW' -> 16r4.
		'_SW_UNDERFLOW' -> 16r1.
		'_SW_ZERODIVIDE' -> 16r8.
		'_TRUNCATE' -> -16r1.
		'EBADF' -> 16r9.
		'EINVAL' -> 16r16.
		'RAND_MAX' -> 16r7FFF.
		'SEEK_CUR' -> 16r1.
		'SEEK_END' -> 16r2.
		'SEEK_SET' -> 16r0
	}!
Kernel.SharedPool subclass: #'External.ExtCallArgTypes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'ExtCallArgBOOL' -> 16r9.
		'ExtCallArgBSTR' -> 16r15.
		'ExtCallArgBYTE' -> 16r3.
		'ExtCallArgCHAR' -> 16r2.
		'ExtCallArgCOMPTR' -> 16r37.
		'ExtCallArgDATE' -> 16r17.
		'ExtCallArgDOUBLE' -> 16rB.
		'ExtCallArgDWORD' -> 16r7.
		'ExtCallArgErrno' -> 16r1D.
		'ExtCallArgFLOAT' -> 16rE.
		'ExtCallArgGUID' -> 16r19.
		'ExtCallArgHANDLE' -> 16rA.
		'ExtCallArgHRESULT' -> 16r10.
		'ExtCallArgINTPTR' -> 16r1B.
		'ExtCallArgLP' -> 16r35.
		'ExtCallArgLPP' -> 16r36.
		'ExtCallArgLPPVOID' -> 16rF.
		'ExtCallArgLPSTR' -> 16rC.
		'ExtCallArgLPVOID' -> 16r1.
		'ExtCallArgLPWSTR' -> 16r11.
		'ExtCallArgMax' -> 16r3F.
		'ExtCallArgNTSTATUS' -> 16r1C.
		'ExtCallArgOOP' -> 16rD.
		'ExtCallArgOTE' -> 16r14.
		'ExtCallArgQWORD' -> 16r12.
		'ExtCallArgSBYTE' -> 16r4.
		'ExtCallArgSDWORD' -> 16r8.
		'ExtCallArgSQWORD' -> 16r13.
		'ExtCallArgSTRUCT' -> 16r32.
		'ExtCallArgSTRUCT4' -> 16r33.
		'ExtCallArgSTRUCT8' -> 16r34.
		'ExtCallArgSWORD' -> 16r6.
		'ExtCallArgUINTPTR' -> 16r1A.
		'ExtCallArgVARBOOL' -> 16r18.
		'ExtCallArgVARIANT' -> 16r16.
		'ExtCallArgVOID' -> 16r0.
		'ExtCallArgWORD' -> 16r5
	}!
Kernel.SharedPool subclass: #'OS.FacilityCodes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'FACILITY_CERT' -> 16rB.
		'FACILITY_CONTROL' -> 16rA.
		'FACILITY_DIRECTDRAW' -> 16r876.
		'FACILITY_DISPATCH' -> 16r2.
		'FACILITY_ITF' -> 16r4.
		'FACILITY_NULL' -> 16r0.
		'FACILITY_RPC' -> 16r1.
		'FACILITY_SSPI' -> 16r9.
		'FACILITY_STORAGE' -> 16r3.
		'FACILITY_WIN32' -> 16r7.
		'FACILITY_WINDOWS' -> 16r8
	}!
Kernel.SharedPool subclass: #'OS.MessageBoxConstants'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'IDTIMEOUT' -> 16r7D00.
		'MB_ABORTRETRYIGNORE' -> 16r2.
		'MB_APPLMODAL' -> 16r0.
		'MB_CANCELTRYCONTINUE' -> 16r6.
		'MB_DEFBUTTON1' -> 16r0.
		'MB_DEFBUTTON2' -> 16r100.
		'MB_DEFBUTTON3' -> 16r200.
		'MB_DEFBUTTON4' -> 16r300.
		'MB_DEFMASK' -> 16rF00.
		'MB_ICONERROR' -> 16r10.
		'MB_ICONINFORMATION' -> 16r40.
		'MB_ICONMASK' -> 16rF0.
		'MB_ICONQUESTION' -> 16r20.
		'MB_ICONWARNING' -> 16r30.
		'MB_MISCMASK' -> 16rC000.
		'MB_MODEMASK' -> 16r3000.
		'MB_OK' -> 16r0.
		'MB_OKCANCEL' -> 16r1.
		'MB_RETRYCANCEL' -> 16r5.
		'MB_SETFOREGROUND' -> 16r10000.
		'MB_SYSTEMMODAL' -> 16r1000.
		'MB_TASKMODAL' -> 16r2000.
		'MB_TYPEMASK' -> 16rF.
		'MB_USERICON' -> 16r80.
		'MB_YESNO' -> 16r4.
		'MB_YESNOCANCEL' -> 16r3
	}!
Kernel.SharedPool subclass: #'OS.NlsConstants'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'C1_ALPHA' -> 16r100.
		'C1_BLANK' -> 16r40.
		'C1_CNTRL' -> 16r20.
		'C1_DEFINED' -> 16r200.
		'C1_DIGIT' -> 16r4.
		'C1_LOWER' -> 16r2.
		'C1_PUNCT' -> 16r10.
		'C1_SPACE' -> 16r8.
		'C1_UPPER' -> 16r1.
		'C1_XDIGIT' -> 16r80.
		'CAL_ITWODIGITYEARMAX' -> 16r30.
		'CAL_IYEAROFFSETRANGE' -> 16r3.
		'CAL_RETURN_NUMBER' -> 16r20000000.
		'CAL_SABBREVERASTRING' -> 16r39.
		'CAL_SERASTRING' -> 16r4.
		'CAL_SNAME' -> 16r2.
		'CAL_SRELATIVELONGDATE' -> 16r3A.
		'CP_ACP' -> 16r0.
		'CP_INSTALLED' -> 16r1.
		'CP_SUPPORTED' -> 16r2.
		'CP_UNICODE' -> 16r4B0.
		'CP_UTF7' -> 16rFDE8.
		'CP_UTF8' -> 16rFDE9.
		'CSTR_EQUAL' -> 16r2.
		'CSTR_GREATER_THAN' -> 16r3.
		'CSTR_LESS_THAN' -> 16r1.
		'DATE_LONGDATE' -> 16r2.
		'DATE_MONTHDAY' -> 16r80.
		'DATE_SHORTDATE' -> 16r1.
		'DATE_USE_ALT_CALENDAR' -> 16r4.
		'DATE_YEARMONTH' -> 16r8.
		'LCID_INSTALLED' -> 16r1.
		'LCID_SUPPORTED' -> 16r2.
		'LCMAP_TITLECASE' -> 16r300.
		'LINGUISTIC_IGNORECASE' -> 16r10.
		'LINGUISTIC_IGNOREDIACRITIC' -> 16r20.
		'LOCALE_ALLOW_NEUTRAL_NAMES' -> 16r8000000.
		'LOCALE_CUSTOM_DEFAULT' -> 16rC00.
		'LOCALE_CUSTOM_UI_DEFAULT' -> 16r1400.
		'LOCALE_CUSTOM_UNSPECIFIED' -> 16r1000.
		'LOCALE_FONTSIGNATURE' -> 16r58.
		'LOCALE_ICALENDARTYPE' -> 16r1009.
		'LOCALE_ICURRDIGITS' -> 16r19.
		'LOCALE_ICURRENCY' -> 16r1B.
		'LOCALE_IDATE' -> 16r21.
		'LOCALE_IDIALINGCODE' -> 16r5.
		'LOCALE_IDIGITS' -> 16r11.
		'LOCALE_IDIGITSUBSTITUTION' -> 16r1014.
		'LOCALE_IFIRSTDAYOFWEEK' -> 16r100C.
		'LOCALE_IFIRSTWEEKOFYEAR' -> 16r100D.
		'LOCALE_ILZERO' -> 16r12.
		'LOCALE_IMEASURE' -> 16rD.
		'LOCALE_INEGATIVEPERCENT' -> 16r74.
		'LOCALE_INEGCURR' -> 16r1C.
		'LOCALE_INEGNUMBER' -> 16r1010.
		'LOCALE_INEGSEPBYSPACE' -> 16r57.
		'LOCALE_INEGSIGNPOSN' -> 16r53.
		'LOCALE_INEGSYMPRECEDES' -> 16r56.
		'LOCALE_INEUTRAL' -> 16r71.
		'LOCALE_INVARIANT' -> 16r7F.
		'LOCALE_IOPTIONALCALENDAR' -> 16r100B.
		'LOCALE_IPAPERSIZE' -> 16r100A.
		'LOCALE_IPOSITIVEPERCENT' -> 16r75.
		'LOCALE_IPOSSEPBYSPACE' -> 16r55.
		'LOCALE_IPOSSIGNPOSN' -> 16r52.
		'LOCALE_IPOSSYMPRECEDES' -> 16r54.
		'LOCALE_IREADINGLAYOUT' -> 16r70.
		'LOCALE_NEUTRAL' -> 16r0.
		'LOCALE_NOUSEROVERRIDE' -> -16r80000000.
		'LOCALE_RETURN_GENITIVE_NAMES' -> 16r10000000.
		'LOCALE_RETURN_NUMBER' -> 16r20000000.
		'LOCALE_SABBREVDAYNAME1' -> 16r31.
		'LOCALE_SABBREVDAYNAME2' -> 16r32.
		'LOCALE_SABBREVDAYNAME3' -> 16r33.
		'LOCALE_SABBREVDAYNAME4' -> 16r34.
		'LOCALE_SABBREVDAYNAME5' -> 16r35.
		'LOCALE_SABBREVDAYNAME6' -> 16r36.
		'LOCALE_SABBREVDAYNAME7' -> 16r37.
		'LOCALE_SABBREVMONTHNAME1' -> 16r44.
		'LOCALE_SABBREVMONTHNAME10' -> 16r4D.
		'LOCALE_SABBREVMONTHNAME11' -> 16r4E.
		'LOCALE_SABBREVMONTHNAME12' -> 16r4F.
		'LOCALE_SABBREVMONTHNAME13' -> 16r100F.
		'LOCALE_SABBREVMONTHNAME2' -> 16r45.
		'LOCALE_SABBREVMONTHNAME3' -> 16r46.
		'LOCALE_SABBREVMONTHNAME4' -> 16r47.
		'LOCALE_SABBREVMONTHNAME5' -> 16r48.
		'LOCALE_SABBREVMONTHNAME6' -> 16r49.
		'LOCALE_SABBREVMONTHNAME7' -> 16r4A.
		'LOCALE_SABBREVMONTHNAME8' -> 16r4B.
		'LOCALE_SABBREVMONTHNAME9' -> 16r4C.
		'LOCALE_SAM' -> 16r28.
		'LOCALE_SCONSOLEFALLBACKNAME' -> 16r6E.
		'LOCALE_SCURRENCY' -> 16r14.
		'LOCALE_SDATE' -> 16r1D.
		'LOCALE_SDAYNAME1' -> 16r2A.
		'LOCALE_SDAYNAME2' -> 16r2B.
		'LOCALE_SDAYNAME3' -> 16r2C.
		'LOCALE_SDAYNAME4' -> 16r2D.
		'LOCALE_SDAYNAME5' -> 16r2E.
		'LOCALE_SDAYNAME6' -> 16r2F.
		'LOCALE_SDAYNAME7' -> 16r30.
		'LOCALE_SDECIMAL' -> 16rE.
		'LOCALE_SDURATION' -> 16r5D.
		'LOCALE_SENGCURRNAME' -> 16r1007.
		'LOCALE_SENGLISHCOUNTRYNAME' -> 16r1002.
		'LOCALE_SENGLISHDISPLAYNAME' -> 16r72.
		'LOCALE_SENGLISHLANGUAGENAME' -> 16r1001.
		'LOCALE_SGROUPING' -> 16r10.
		'LOCALE_SINTLSYMBOL' -> 16r15.
		'LOCALE_SISO3166CTRYNAME' -> 16r5A.
		'LOCALE_SISO3166CTRYNAME2' -> 16r68.
		'LOCALE_SISO639LANGNAME' -> 16r59.
		'LOCALE_SISO639LANGNAME2' -> 16r67.
		'LOCALE_SLIST' -> 16rC.
		'LOCALE_SLOCALIZEDCOUNTRYNAME' -> 16r6.
		'LOCALE_SLOCALIZEDDISPLAYNAME' -> 16r2.
		'LOCALE_SLOCALIZEDLANGUAGENAME' -> 16r6F.
		'LOCALE_SLONGDATE' -> 16r20.
		'LOCALE_SMONDECIMALSEP' -> 16r16.
		'LOCALE_SMONGROUPING' -> 16r18.
		'LOCALE_SMONTHDAY' -> 16r78.
		'LOCALE_SMONTHNAME1' -> 16r38.
		'LOCALE_SMONTHNAME10' -> 16r41.
		'LOCALE_SMONTHNAME11' -> 16r42.
		'LOCALE_SMONTHNAME12' -> 16r43.
		'LOCALE_SMONTHNAME13' -> 16r100E.
		'LOCALE_SMONTHNAME2' -> 16r39.
		'LOCALE_SMONTHNAME3' -> 16r3A.
		'LOCALE_SMONTHNAME4' -> 16r3B.
		'LOCALE_SMONTHNAME5' -> 16r3C.
		'LOCALE_SMONTHNAME6' -> 16r3D.
		'LOCALE_SMONTHNAME7' -> 16r3E.
		'LOCALE_SMONTHNAME8' -> 16r3F.
		'LOCALE_SMONTHNAME9' -> 16r40.
		'LOCALE_SMONTHOUSANDSEP' -> 16r17.
		'LOCALE_SNAME' -> 16r5C.
		'LOCALE_SNAN' -> 16r69.
		'LOCALE_SNATIVECOUNTRYNAME' -> 16r8.
		'LOCALE_SNATIVECURRNAME' -> 16r1008.
		'LOCALE_SNATIVEDIGITS' -> 16r13.
		'LOCALE_SNATIVEDISPLAYNAME' -> 16r73.
		'LOCALE_SNATIVELANGUAGENAME' -> 16r4.
		'LOCALE_SNEGATIVESIGN' -> 16r51.
		'LOCALE_SNEGINFINITY' -> 16r6B.
		'LOCALE_SOPENTYPELANGUAGETAG' -> 16r7A.
		'LOCALE_SPARENT' -> 16r6D.
		'LOCALE_SPERCENT' -> 16r76.
		'LOCALE_SPERMILLE' -> 16r77.
		'LOCALE_SPM' -> 16r29.
		'LOCALE_SPOSINFINITY' -> 16r6A.
		'LOCALE_SPOSITIVESIGN' -> 16r50.
		'LOCALE_SRELATIVELONGDATE' -> 16r7C.
		'LOCALE_SSCRIPTS' -> 16r6C.
		'LOCALE_SSHORTDATE' -> 16r1F.
		'LOCALE_SSHORTESTAM' -> 16r7E.
		'LOCALE_SSHORTESTDAYNAME1' -> 16r60.
		'LOCALE_SSHORTESTDAYNAME2' -> 16r61.
		'LOCALE_SSHORTESTDAYNAME3' -> 16r62.
		'LOCALE_SSHORTESTDAYNAME4' -> 16r63.
		'LOCALE_SSHORTESTDAYNAME5' -> 16r64.
		'LOCALE_SSHORTESTDAYNAME6' -> 16r65.
		'LOCALE_SSHORTESTDAYNAME7' -> 16r66.
		'LOCALE_SSHORTESTPM' -> 16r7F.
		'LOCALE_SSHORTTIME' -> 16r79.
		'LOCALE_SSORTLOCALE' -> 16r7B.
		'LOCALE_SSORTNAME' -> 16r1013.
		'LOCALE_STHOUSAND' -> 16rF.
		'LOCALE_STIME' -> 16r1E.
		'LOCALE_STIMEFORMAT' -> 16r1003.
		'LOCALE_SYEARMONTH' -> 16r1006.
		'LOCALE_SYSTEM_DEFAULT' -> 16r800.
		'LOCALE_USER_DEFAULT' -> 16r400.
		'MUI_FULL_LANGUAGE' -> 16r1.
		'MUI_LANGUAGE_ID' -> 16r4.
		'MUI_LANGUAGE_INSTALLED' -> 16r20.
		'MUI_LANGUAGE_LICENSED' -> 16r40.
		'MUI_LANGUAGE_NAME' -> 16r8.
		'MUI_LIP_LANGUAGE' -> 16r4.
		'MUI_PARTIAL_LANGUAGE' -> 16r2.
		'NORM_IGNORECASE' -> 16r1.
		'NORM_IGNOREKANATYPE' -> 16r10000.
		'NORM_IGNORENONCASE' -> 16r2.
		'NORM_IGNORESYMBOLS' -> 16r4.
		'NORM_IGNOREWIDTH' -> 16r20000.
		'NORM_LINGUISTIC_CASING' -> 16r8000000
	}!
Kernel.SharedPool subclass: #'Kernel.OpcodePool'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'BlockCopy' -> 16rFC.
		'Break' -> 16r0.
		'DecPushTemp' -> 16rFB.
		'Decrement' -> 16r63.
		'DecTemp' -> 16rFA.
		'Dup' -> 16r64.
		'ExLongPushImmediate' -> 16rFF.
		'ExLongSend' -> 16rFD.
		'ExLongSupersend' -> 16rFE.
		'FirstDoubleByte' -> 16rCC.
		'FirstMultiByte' -> 16rFC.
		'FirstTripleByte' -> 16rEA.
		'IncPushTemp' -> 16rF9.
		'Increment' -> 16r62.
		'IncTemp' -> 16rF8.
		'IsZero' -> 16rC6.
		'LongJump' -> 16rF1.
		'LongJumpIfFalse' -> 16rF3.
		'LongJumpIfNil' -> 16rF4.
		'LongJumpIfNotNil' -> 16rF5.
		'LongJumpIfTrue' -> 16rF2.
		'LongPopStoreStatic' -> 16rED.
		'LongPushConst' -> 16rEA.
		'LongPushImmediate' -> 16rEE.
		'LongPushStatic' -> 16rEB.
		'LongSend' -> 16rEF.
		'LongStoreStatic' -> 16rEC.
		'LongSupersend' -> 16rF0.
		'NearJump' -> 16rDB.
		'NearJumpIfFalse' -> 16rDD.
		'NearJumpIfNil' -> 16rDE.
		'NearJumpIfNotNil' -> 16rDF.
		'NearJumpIfTrue' -> 16rDC.
		'Nop' -> 16r6D.
		'Pop' -> 16r61.
		'PopContextTemp' -> 16r4D.
		'PopDup' -> 16r4C.
		'PopInstVar' -> 16rD3.
		'PopOuterTemp' -> 16rE6.
		'PopPushSelf' -> 16r4B.
		'PopReturnSelf' -> 16r6C.
		'PopStatic' -> 16rD5.
		'PopTemp' -> 16rD4.
		'PushActiveFrame' -> 16rC7.
		'PushChar' -> 16rD7.
		'PushConst' -> 16rCE.
		'PushContextTemp' -> 16r19.
		'PushImmediate' -> 16rD6.
		'PushInstVar' -> 16rCC.
		'PushOuter' -> 16rF6.
		'PushOuterTemp' -> 16rE4.
		'PushPseudo' -> 16r3A.
		'PushSelf' -> 16r39.
		'PushSelfAndTemp' -> 16rE3.
		'PushStatic' -> 16rCF.
		'PushTemp' -> 16rCD.
		'PushTempPair' -> 16rE9.
		'ReturnFalse' -> 16r67.
		'ReturnFromBlock' -> 16r6A.
		'ReturnFromBlockHome' -> 16r6B.
		'ReturnFromMessage' -> 16r69.
		'ReturnNil' -> 16r68.
		'ReturnPseudo' -> 16r66.
		'ReturnSelf' -> 16r65.
		'Send' -> 16rD8.
		'SendSelfZeroArgs' -> 16rE7.
		'SendTempZeroArgs' -> 16rE2.
		'ShortJump' -> 16r6E.
		'ShortJumpIfFalse' -> 16r76.
		'ShortPopInstVar' -> 16r51.
		'ShortPopOuterTemp' -> 16r4F.
		'ShortPopPushTemp' -> 16r49.
		'ShortPopTemp' -> 16r59.
		'ShortPushConst' -> 16r1D.
		'ShortPushFalse' -> 16r3B.
		'ShortPushImmediate' -> 16r3D.
		'ShortPushInstVar' -> 16r1.
		'ShortPushNil' -> 16r3C.
		'ShortPushOne' -> 16r3F.
		'ShortPushOuterTemp' -> 16r1B.
		'ShortPushSelfAndTemp' -> 16r41.
		'ShortPushStatic' -> 16r2D.
		'ShortPushTemp' -> 16r11.
		'ShortPushTwo' -> 16r40.
		'ShortPushZero' -> 16r3E.
		'ShortSendIsNil' -> 16r9C.
		'ShortSendNotNil' -> 16r9D.
		'ShortSendOneArg' -> 16rB0.
		'ShortSendSelfZeroArgs' -> 16rAB.
		'ShortSendTwoArgs' -> 16rBE.
		'ShortSendZeroArgs' -> 16r9E.
		'ShortSpecialSend' -> 16r7E.
		'ShortSpecialSendEx' -> 16rC8.
		'ShortStoreTemp' -> 16r45.
		'SpecialSend' -> 16rDA.
		'StoreInstVar' -> 16rD0.
		'StoreOuter' -> 16rF7.
		'StoreOuterTemp' -> 16rE5.
		'StoreStatic' -> 16rD2.
		'StoreTemp' -> 16rD1.
		'Supersend' -> 16rD9
	}!
Kernel.SharedPool subclass: #'Kernel.ParseErrorCodes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'CErrArgTypeCannotBeVoid' -> 16r33.
		'CErrArrayNotClosed' -> 16r3D.
		'CErrAssignConstant' -> 16r48.
		'CErrAssignmentToArgument' -> 16r43.
		'CErrBadContext' -> 16r4C.
		'CErrBadExtTypeQualifier' -> 16r37.
		'CErrBadPools' -> 16r53.
		'CErrBadPrimCallType' -> 16r2F.
		'CErrBadPrimIdx' -> 16r2D.
		'CErrBadQualifiedRefModifier' -> 16r5A.
		'CErrBadSelector' -> 16r4A.
		'CErrBadTokenInArray' -> 16r3C.
		'CErrBadValueInByteArray' -> 16r3E.
		'CErrBadVfn' -> 16r3B.
		'CErrBlockArgListNotClosed' -> 16r2A.
		'CErrBlockNestingTooDeep' -> 16r51.
		'CErrBlockNotClosed' -> 16r2B.
		'CErrBraceNotClosed' -> 16r25.
		'CErrByteArrayNotClosed' -> 16r3F.
		'CErrDuplicateArgName' -> 16r56.
		'CErrDuplicateTempName' -> 16r55.
		'CErrEmptyConditionBlock' -> 16r58.
		'CErrErrorInStaticExpression' -> 16r40.
		'CErrExpectCloseTag' -> 16r2E.
		'CErrExpectExtType' -> 16r32.
		'CErrExpectFnName' -> 16r31.
		'CErrExpectLiteralBlock' -> 16r4E.
		'CErrExpectMessage' -> 16r27.
		'CErrExpectPrimIdx' -> 16r2C.
		'CErrExpectVariable' -> 16r29.
		'CErrExpectVfn' -> 16r3A.
		'CErrFirst' -> 16r21.
		'CErrIncorrectBlockArgCount' -> 16r4D.
		'CErrInsufficientArgTypes' -> 16r38.
		'CErrInternal' -> 16r42.
		'CErrInvalExprStart' -> 16r22.
		'CErrInvalidStructArg' -> 16r36.
		'CErrLast' -> 16r5A.
		'CErrMethodTooLarge' -> 16r4F.
		'CErrNonsenseAtExprEnd' -> 16r24.
		'CErrNonsenseAtMethodEnd' -> 16r23.
		'CErrNotIndirectable' -> 16r34.
		'CErrParenNotClosed' -> 16r26.
		'CErrQualifiedRefNotClosed' -> 16r59.
		'CErrRedefiningArg' -> 16r57.
		'CErrRedefiningPseudoVar' -> 16r46.
		'CErrStaticExprNotClosed' -> 16r49.
		'CErrTempListNotClosed' -> 16r21.
		'CErrTooManyArgs' -> 16r44.
		'CErrTooManyArgTypes' -> 16r39.
		'CErrTooManyIfNotNilBlockArgs' -> 16r41.
		'CErrTooManyLiterals' -> 16r50.
		'CErrTooManyTemps' -> 16r45.
		'CErrUndeclared' -> 16r47.
		'CErrUnsupportedCallConv' -> 16r30.
		'CErrUnterminatedStatement' -> 16r28.
		'CInfoFirst' -> 16r7D0.
		'CInfoHardBreakpoint' -> 16r7D2.
		'CInfoLast' -> 16r7D2.
		'CInfoSupersendsOther' -> 16r7D1.
		'CInfoUnreferencedArg' -> 16r7D0.
		'CWarnExpectMonadicBlockArg' -> 16r3F4.
		'CWarnExpectMonadicOrNiladicBlockArg' -> 16r3F5.
		'CWarnExpectNiladicBlockArg' -> 16r3F3.
		'CWarnExpectNiladicBlockReceiver' -> 16r3F6.
		'CWarnFirst' -> 16r3E8.
		'CWarnLast' -> 16r3F9.
		'CWarnMsgUnimplemented' -> 16r3EC.
		'CWarnMutableIgnored' -> 16r3FA.
		'CWarnReadBeforeWritten' -> 16r3F1.
		'CWarnReadNotWritten' -> 16r3F0.
		'CWarnRedefiningArg' -> 16r3E8.
		'CWarnRedefiningInstVar' -> 16r3EA.
		'CWarnRedefiningStatic' -> 16r3EB.
		'CWarnRedefiningTemp' -> 16r3E9.
		'CWarnRestrictedSelector' -> 16r3EE.
		'CWarnUndefinedSelector' -> 16r3ED.
		'CWarnUnimplementedAbstractMethod' -> 16r3F8.
		'CWarnUnreachable' -> 16r3F7.
		'CWarnUnreferencedTemp' -> 16r3EF.
		'CWarnUsesBooleanClass' -> 16r3F9.
		'CWarnWrittenNotRead' -> 16r3F2.
		'LErrBadChar' -> 16r1.
		'LErrBadCodePoint' -> 16rC.
		'LErrBadNumber' -> 16rA.
		'LErrCommentNotClosed' -> 16r2.
		'LErrExpectChar' -> 16r7.
		'LErrExpectCodePoint' -> 16rB.
		'LErrExpectConst' -> 16r4.
		'LErrExpectExtendedLiteral' -> 16r5.
		'LErrExpectMetaVariable' -> 16r6.
		'LErrFirst' -> 16r1.
		'LErrLast' -> 16rA.
		'LErrStringNotClosed' -> 16r3
	}!
Kernel.SharedPool subclass: #'Kernel.VMConstants'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'DoubleSize' -> 16r8.
		'FloatSize' -> 16r4.
		'HalfPtrBits' -> 16r10.
		'HalfPtrMask' -> 16rFFFF.
		'HalfPtrMax' -> 16r7FFF.
		'HashBits' -> 16r1E.
		'IntMax' -> 16r7FFFFFFF.
		'IntPtrBits' -> 16r20.
		'IntPtrMask' -> 16rFFFFFFFF.
		'IntPtrMax' -> 16r7FFFFFFF.
		'IntPtrSize' -> 16r4.
		'IntSize' -> 16r4.
		'IsWin64' -> false.
		'MaxBlockNesting' -> 16rFF.
		'MaxLiterals' -> 16r10000.
		'MaxMessageArgs' -> 16rFF.
		'MaxPrimitive' -> 16rFF.
		'MaxTemps' -> 16rFF.
		'MaxVirtualFunction' -> 16r400.
		'SmallIntegerMax' -> 16r3FFFFFFF.
		'SmallIntegerMin' -> -16r40000000.
		'UIntMax' -> 16rFFFFFFFF.
		'UIntPtrMax' -> 16rFFFFFFFF
	}!
Kernel.SharedPool subclass: #'OS.Win32Constants'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'ABOVE_NORMAL_PRIORITY_CLASS' -> 16r8000.
		'AC_SRC_ALPHA' -> 16r1.
		'AC_SRC_OVER' -> 16r0.
		'ASPECTX' -> 16r28.
		'ASPECTXY' -> 16r2C.
		'ASPECTY' -> 16r2A.
		'ATTACH_PARENT_PROCESS' -> 16rFFFFFFFF.
		'AW_ACTIVATE' -> 16r20000.
		'AW_BLEND' -> 16r80000.
		'AW_CENTER' -> 16r10.
		'AW_HIDE' -> 16r10000.
		'AW_HOR_NEGATIVE' -> 16r2.
		'AW_HOR_POSITIVE' -> 16r1.
		'AW_SLIDE' -> 16r40000.
		'AW_VER_NEGATIVE' -> 16r8.
		'AW_VER_POSITIVE' -> 16r4.
		'BELOW_NORMAL_PRIORITY_CLASS' -> 16r4000.
		'BF_ADJUST' -> 16r2000.
		'BF_BOTTOM' -> 16r8.
		'BF_BOTTOMLEFT' -> 16r9.
		'BF_BOTTOMRIGHT' -> 16rC.
		'BF_DIAGONAL' -> 16r10.
		'BF_DIAGONAL_ENDBOTTOMLEFT' -> 16r19.
		'BF_DIAGONAL_ENDBOTTOMRIGHT' -> 16r1C.
		'BF_DIAGONAL_ENDTOPLEFT' -> 16r13.
		'BF_DIAGONAL_ENDTOPRIGHT' -> 16r16.
		'BF_FLAT' -> 16r4000.
		'BF_LEFT' -> 16r1.
		'BF_MIDDLE' -> 16r800.
		'BF_MONO' -> 16r8000.
		'BF_RECT' -> 16rF.
		'BF_RIGHT' -> 16r4.
		'BF_SOFT' -> 16r1000.
		'BF_TOP' -> 16r2.
		'BF_TOPLEFT' -> 16r3.
		'BF_TOPRIGHT' -> 16r6.
		'BI_RGB' -> 16r0.
		'BITSPIXEL' -> 16rC.
		'BLACK_BRUSH' -> 16r4.
		'BLACK_PEN' -> 16r7.
		'BS_CHECKBOX' -> 16r2.
		'BS_DIBPATTERN' -> 16r5.
		'BS_DIBPATTERN8X8' -> 16r8.
		'BS_DIBPATTERNPT' -> 16r6.
		'BS_HATCHED' -> 16r2.
		'BS_HOLLOW' -> 16r1.
		'BS_INDEXED' -> 16r4.
		'BS_NULL' -> 16r1.
		'BS_PATTERN' -> 16r3.
		'BS_PATTERN8X8' -> 16r7.
		'BS_SOLID' -> 16r0.
		'CBM_INIT' -> 16r4.
		'CF_BITMAP' -> 16r2.
		'CF_DIB' -> 16r8.
		'CF_DIBV5' -> 16r11.
		'CF_DIF' -> 16r5.
		'CF_DSPBITMAP' -> 16r82.
		'CF_DSPENHMETAFILE' -> 16r8E.
		'CF_DSPMETAFILEPICT' -> 16r83.
		'CF_DSPTEXT' -> 16r81.
		'CF_ENHMETAFILE' -> 16rE.
		'CF_HDROP' -> 16rF.
		'CF_LOCALE' -> 16r10.
		'CF_METAFILEPICT' -> 16r3.
		'CF_OEMTEXT' -> 16r7.
		'CF_OWNERDISPLAY' -> 16r80.
		'CF_PALETTE' -> 16r9.
		'CF_PENDATA' -> 16rA.
		'CF_RIFF' -> 16rB.
		'CF_SYLK' -> 16r4.
		'CF_TEXT' -> 16r1.
		'CF_TIFF' -> 16r6.
		'CF_UNICODETEXT' -> 16rD.
		'CF_WAVE' -> 16rC.
		'CLR_DEFAULT' -> 16rFF000000.
		'CLR_INVALID' -> 16rFFFFFFFF.
		'CLR_NONE' -> 16rFFFFFFFF.
		'COLOR_3DDKSHADOW' -> 16r15.
		'COLOR_3DFACE' -> 16rF.
		'COLOR_3DHIGHLIGHT' -> 16r14.
		'COLOR_3DLIGHT' -> 16r16.
		'COLOR_3DSHADOW' -> 16r10.
		'COLOR_ACTIVEBORDER' -> 16rA.
		'COLOR_ACTIVECAPTION' -> 16r2.
		'COLOR_APPWORKSPACE' -> 16rC.
		'COLOR_BTNHIGHLIGHT' -> 16r14.
		'COLOR_BTNTEXT' -> 16r12.
		'COLOR_CAPTIONTEXT' -> 16r9.
		'COLOR_DESKTOP' -> 16r1.
		'COLOR_GRADIENTACTIVECAPTION' -> 16r1B.
		'COLOR_GRADIENTINACTIVECAPTION' -> 16r1C.
		'COLOR_GRAYTEXT' -> 16r11.
		'COLOR_HIGHLIGHT' -> 16rD.
		'COLOR_HIGHLIGHTTEXT' -> 16rE.
		'COLOR_HOTLIGHT' -> 16r1A.
		'COLOR_INACTIVEBORDER' -> 16rB.
		'COLOR_INACTIVECAPTION' -> 16r3.
		'COLOR_INACTIVECAPTIONTEXT' -> 16r13.
		'COLOR_INFOBK' -> 16r18.
		'COLOR_INFOTEXT' -> 16r17.
		'COLOR_MENU' -> 16r4.
		'COLOR_MENUBAR' -> 16r1E.
		'COLOR_MENUHILIGHT' -> 16r1D.
		'COLOR_MENUTEXT' -> 16r7.
		'COLOR_SCROLLBAR' -> 16r0.
		'COLOR_WINDOW' -> 16r5.
		'COLOR_WINDOWFRAME' -> 16r6.
		'COLOR_WINDOWTEXT' -> 16r8.
		'CREATE_ALWAYS' -> 16r2.
		'CREATE_DEFAULT_ERROR_MODE' -> 16r4000000.
		'CREATE_FORCEDOS' -> 16r2000.
		'CREATE_NEW' -> 16r1.
		'CREATE_NEW_CONSOLE' -> 16r10.
		'CREATE_NEW_PROCESS_GROUP' -> 16r200.
		'CREATE_NO_WINDOW' -> 16r8000000.
		'CREATE_SEPARATE_WOW_VDM' -> 16r800.
		'CREATE_SHARED_WOW_VDM' -> 16r1000.
		'CREATE_SUSPENDED' -> 16r4.
		'CREATE_UNICODE_ENVIRONMENT' -> 16r400.
		'CREATEPROCESS_MANIFEST_RESOURCE_ID' -> 16r1.
		'CS_BYTEALIGNCLIENT' -> 16r1000.
		'CS_BYTEALIGNWINDOW' -> 16r2000.
		'CS_CLASSDC' -> 16r40.
		'CS_DBLCLKS' -> 16r8.
		'CS_GLOBALCLASS' -> 16r4000.
		'CS_HREDRAW' -> 16r2.
		'CS_KEYCVTWINDOW' -> 16r4.
		'CS_NOCLOSE' -> 16r200.
		'CS_NOKEYCVT' -> 16r100.
		'CS_OWNDC' -> 16r20.
		'CS_PARENTDC' -> 16r80.
		'CS_SAVEBITS' -> 16r800.
		'CS_VREDRAW' -> 16r1.
		'CTRL_BREAK_EVENT' -> 16r1.
		'CTRL_C_EVENT' -> 16r0.
		'CTRL_CLOSE_EVENT' -> 16r2.
		'CTRL_LOGOFF_EVENT' -> 16r5.
		'CTRL_SHUTDOWN_EVENT' -> 16r6.
		'CW_USEDEFAULT' -> -16r80000000.
		'CWP_ALL' -> 16r0.
		'CWP_SKIPDISABLED' -> 16r2.
		'CWP_SKIPINVISIBLE' -> 16r1.
		'CWP_SKIPTRANSPARENT' -> 16r4.
		'DC_HASDEFID' -> 16r534B.
		'DCX_INTERSECTRGN' -> 16r80.
		'DCX_WINDOW' -> 16r1.
		'DEFAULT_GUI_FONT' -> 16r11.
		'DEFAULT_PALETTE' -> 16rF.
		'DESKTOPVERTRES' -> 16r76.
		'DETACHED_PROCESS' -> 16r8.
		'DEVICE_DEFAULT_FONT' -> 16rE.
		'DFC_BUTTON' -> 16r4.
		'DFC_CAPTION' -> 16r1.
		'DFC_MENU' -> 16r2.
		'DFC_POPUPMENU' -> 16r5.
		'DFC_SCROLL' -> 16r3.
		'DFCS_ADJUSTRECT' -> 16r2000.
		'DFCS_BUTTON3STATE' -> 16r8.
		'DFCS_BUTTONCHECK' -> 16r0.
		'DFCS_BUTTONPUSH' -> 16r10.
		'DFCS_BUTTONRADIO' -> 16r4.
		'DFCS_BUTTONRADIOIMAGE' -> 16r1.
		'DFCS_BUTTONRADIOMASK' -> 16r2.
		'DFCS_CAPTIONCLOSE' -> 16r0.
		'DFCS_CAPTIONHELP' -> 16r4.
		'DFCS_CAPTIONMAX' -> 16r2.
		'DFCS_CAPTIONMIN' -> 16r1.
		'DFCS_CAPTIONRESTORE' -> 16r3.
		'DFCS_CHECKED' -> 16r400.
		'DFCS_FLAT' -> 16r4000.
		'DFCS_INACTIVE' -> 16r100.
		'DFCS_MENUARROW' -> 16r0.
		'DFCS_MENUARROWRIGHT' -> 16r4.
		'DFCS_MENUBULLET' -> 16r2.
		'DFCS_MENUCHECK' -> 16r1.
		'DFCS_MONO' -> 16r8000.
		'DFCS_PUSHED' -> 16r200.
		'DFCS_SCROLLCOMBOBOX' -> 16r5.
		'DFCS_SCROLLDOWN' -> 16r1.
		'DFCS_SCROLLLEFT' -> 16r2.
		'DFCS_SCROLLRIGHT' -> 16r3.
		'DFCS_SCROLLSIZEGRIP' -> 16r8.
		'DFCS_SCROLLSIZEGRIPRIGHT' -> 16r10.
		'DFCS_SCROLLUP' -> 16r0.
		'DI_COMPAT' -> 16r4.
		'DI_DEFAULTSIZE' -> 16r8.
		'DI_IMAGE' -> 16r2.
		'DI_MASK' -> 16r1.
		'DI_NORMAL' -> 16r3.
		'DIB_PAL_COLORS' -> 16r1.
		'DIB_RGB_COLORS' -> 16r0.
		'DKGRAY_BRUSH' -> 16r3.
		'DLGC_BUTTON' -> 16r2000.
		'DLGC_DEFPUSHBUTTON' -> 16r10.
		'DLGC_HASSETSEL' -> 16r8.
		'DLGC_RADIOBUTTON' -> 16r40.
		'DLGC_STATIC' -> 16r100.
		'DLGC_UNDEFPUSHBUTTON' -> 16r20.
		'DLGC_WANTALLKEYS' -> 16r4.
		'DLGC_WANTARROWS' -> 16r1.
		'DLGC_WANTCHARS' -> 16r80.
		'DLGC_WANTMESSAGE' -> 16r4.
		'DLGC_WANTTAB' -> 16r2.
		'DM_GETDEFID' -> 16r400.
		'DM_SETDEFID' -> 16r401.
		'DONT_RESOLVE_DLL_REFERENCES' -> 16r1.
		'DS_3DLOOK' -> 16r4.
		'DSS_DISABLED' -> 16r20.
		'DSS_HIDEPREFIX' -> 16r200.
		'DSS_MONO' -> 16r80.
		'DSS_NORMAL' -> 16r0.
		'DSS_PREFIXONLY' -> 16r400.
		'DSS_RIGHT' -> 16r8000.
		'DSS_UNION' -> 16r10.
		'DST_BITMAP' -> 16r4.
		'DST_COMPLEX' -> 16r0.
		'DST_ICON' -> 16r3.
		'DST_PREFIXTEXT' -> 16r2.
		'DST_TEXT' -> 16r1.
		'DSTINVERT' -> 16r550009.
		'DT_BOTTOM' -> 16r8.
		'DT_CALCRECT' -> 16r400.
		'DT_CENTER' -> 16r1.
		'DT_EDITCONTROL' -> 16r2000.
		'DT_END_ELLIPSIS' -> 16r8000.
		'DT_EXPANDTABS' -> 16r40.
		'DT_EXTERNALLEADING' -> 16r200.
		'DT_HIDEPREFIX' -> 16r100000.
		'DT_INTERNAL' -> 16r1000.
		'DT_LEFT' -> 16r0.
		'DT_MODIFYSTRING' -> 16r10000.
		'DT_NOCLIP' -> 16r100.
		'DT_NOFULLWIDTHCHARBREAK' -> 16r80000.
		'DT_NOPREFIX' -> 16r800.
		'DT_PATH_ELLIPSIS' -> 16r4000.
		'DT_PREFIXONLY' -> 16r200000.
		'DT_RIGHT' -> 16r2.
		'DT_RTLREADING' -> 16r20000.
		'DT_SINGLELINE' -> 16r20.
		'DT_TABSTOP' -> 16r80.
		'DT_TOP' -> 16r0.
		'DT_VCENTER' -> 16r4.
		'DT_WORD_ELLIPSIS' -> 16r40000.
		'DT_WORDBREAK' -> 16r10.
		'DUPLICATE_SAME_ACCESS' -> 16r2.
		'DWL_MSGRESULT' -> 16r0.
		'EDGE_BUMP' -> 16r9.
		'EDGE_ETCHED' -> 16r6.
		'EDGE_RAISED' -> 16r5.
		'EDGE_SUNKEN' -> 16rA.
		'ELF_VENDOR_SIZE' -> 16r4.
		'EM_LINESCROLL' -> 16rB6.
		'EM_SCROLL' -> 16rB5.
		'EVENTLOG_ERROR_TYPE' -> 16r1.
		'EVENTLOG_INFORMATION_TYPE' -> 16r4.
		'EVENTLOG_SUCCESS' -> 16r0.
		'EVENTLOG_WARNING_TYPE' -> 16r2.
		'EXCEPTION_MAXIMUM_PARAMETERS' -> 16rF.
		'FALT' -> 16r10.
		'FCONTROL' -> 16r8.
		'FILE_ATTRIBUTE_DIRECTORY' -> 16r10.
		'FILE_ATTRIBUTE_NORMAL' -> 16r80.
		'FILE_ATTRIBUTE_READONLY' -> 16r1.
		'FILE_BEGIN' -> 16r0.
		'FILE_CURRENT' -> 16r1.
		'FILE_END' -> 16r2.
		'FILE_FLAG_BACKUP_SEMANTICS' -> 16r2000000.
		'FILE_FLAG_OVERLAPPED' -> 16r40000000.
		'FILE_LIST_DIRECTORY' -> 16r1.
		'FILE_SHARE_DELETE' -> 16r4.
		'FILE_SHARE_READ' -> 16r1.
		'FILE_SHARE_WRITE' -> 16r2.
		'FILE_SUPPORTS_SPARSE_FILES' -> 16r40.
		'FILE_TYPE_CHAR' -> 16r2.
		'FILE_TYPE_DISK' -> 16r1.
		'FILE_TYPE_PIPE' -> 16r3.
		'FILE_TYPE_REMOTE' -> 16r8000.
		'FILE_TYPE_UNKNOWN' -> 16r0.
		'FLASHW_ALL' -> 16r3.
		'FLASHW_CAPTION' -> 16r1.
		'FLASHW_STOP' -> 16r0.
		'FLASHW_TIMER' -> 16r4.
		'FLASHW_TIMERNOFG' -> 16rC.
		'FLASHW_TRAY' -> 16r2.
		'FNOINVERT' -> 16r2.
		'FORMAT_MESSAGE_ALLOCATE_BUFFER' -> 16r100.
		'FORMAT_MESSAGE_ARGUMENT_ARRAY' -> 16r2000.
		'FORMAT_MESSAGE_FROM_HMODULE' -> 16r800.
		'FORMAT_MESSAGE_FROM_STRING' -> 16r400.
		'FORMAT_MESSAGE_FROM_SYSTEM' -> 16r1000.
		'FORMAT_MESSAGE_IGNORE_INSERTS' -> 16r200.
		'FSCTL_SET_SPARSE' -> 16r900C4.
		'FSHIFT' -> 16r4.
		'FVIRTKEY' -> 16r1.
		'FW_BOLD' -> 16r2BC.
		'FW_DONTCARE' -> 16r0.
		'FW_EXTRABOLD' -> 16r320.
		'FW_EXTRALIGHT' -> 16rC8.
		'FW_HEAVY' -> 16r384.
		'FW_LIGHT' -> 16r12C.
		'FW_MEDIUM' -> 16r1F4.
		'FW_NORMAL' -> 16r190.
		'FW_SEMIBOLD' -> 16r258.
		'FW_THIN' -> 16r64.
		'GA_PARENT' -> 16r1.
		'GA_ROOT' -> 16r2.
		'GA_ROOTOWNER' -> 16r3.
		'GCL_WNDPROC' -> -16r18.
		'GENERIC_READ' -> 16r80000000.
		'GENERIC_WRITE' -> 16r40000000.
		'GHND' -> 16r42.
		'GMEM_DDESHARE' -> 16r2000.
		'GMEM_MOVEABLE' -> 16r2.
		'GMEM_ZEROINIT' -> 16r40.
		'GRADIENT_FILL_OP_FLAG' -> 16rFF.
		'GRADIENT_FILL_RECT_H' -> 16r0.
		'GRADIENT_FILL_RECT_V' -> 16r1.
		'GRADIENT_FILL_TRIANGLE' -> 16r2.
		'GRAY_BRUSH' -> 16r2.
		'GW_HWNDCHILD' -> 16r5.
		'GW_HWNDFIRST' -> 16r0.
		'GW_HWNDLAST' -> 16r1.
		'GW_HWNDNEXT' -> 16r2.
		'GW_HWNDOWNER' -> 16r4.
		'GW_HWNDPREV' -> 16r3.
		'GWL_EXSTYLE' -> -16r14.
		'GWL_ID' -> -16rC.
		'GWL_STYLE' -> -16r10.
		'GWL_WNDPROC' -> -16r4.
		'GWLP_HINSTANCE' -> -16r6.
		'GWLP_HWNDPARENT' -> -16r8.
		'GWLP_ID' -> -16rC.
		'GWLP_WNDPROC' -> -16r4.
		'HBMMENU_CALLBACK' -> -16r1.
		'HELP_COMMAND' -> 16r102.
		'HELP_CONTENTS' -> 16r3.
		'HELP_CONTEXT' -> 16r1.
		'HELP_CONTEXTPOPUP' -> 16r8.
		'HELP_FORCEFILE' -> 16r9.
		'HELP_HELPONHELP' -> 16r4.
		'HELP_INDEX' -> 16r3.
		'HELP_KEY' -> 16r101.
		'HELP_PARTIALKEY' -> 16r105.
		'HELP_QUIT' -> 16r2.
		'HELP_SETCONTENTS' -> 16r5.
		'HELP_SETINDEX' -> 16r5.
		'HELP_SETPOPUP_POS' -> 16rD.
		'HIGH_PRIORITY_CLASS' -> 16r80.
		'HINST_COMMCTRL' -> -16r1.
		'HOLLOW_BRUSH' -> 16r5.
		'HORZRES' -> 16r8.
		'HORZSIZE' -> 16r4.
		'HOVER_DEFAULT' -> -16r1.
		'HS_BDIAGONAL' -> 16r3.
		'HS_CROSS' -> 16r4.
		'HS_DIAGCROSS' -> 16r5.
		'HS_FDIAGONAL' -> 16r2.
		'HS_HORIZONTAL' -> 16r0.
		'HS_VERTICAL' -> 16r1.
		'HTBORDER' -> 16r12.
		'HTBOTTOM' -> 16rF.
		'HTBOTTOMLEFT' -> 16r10.
		'HTBOTTOMRIGHT' -> 16r11.
		'HTCAPTION' -> 16r2.
		'HTCLIENT' -> 16r1.
		'HTERROR' -> -16r2.
		'HTLEFT' -> 16rA.
		'HTRIGHT' -> 16rB.
		'HTTOP' -> 16rC.
		'HTTOPLEFT' -> 16rD.
		'HTTOPRIGHT' -> 16rE.
		'HTTRANSPARENT' -> -16r1.
		'HWND_BOTTOM' -> 16r1.
		'HWND_MESSAGE' -> -16r3.
		'HWND_NOTOPMOST' -> -16r2.
		'HWND_TOP' -> 16r0.
		'HWND_TOPMOST' -> -16r1.
		'I_IMAGECALLBACK' -> -16r1.
		'I_IMAGENONE' -> -16r2.
		'ICON_BIG' -> 16r1.
		'ICON_SMALL' -> 16r0.
		'IDABORT' -> 16r3.
		'IDC_APPSTARTING' -> 16r7F8A.
		'IDC_ARROW' -> 16r7F00.
		'IDC_CROSS' -> 16r7F03.
		'IDC_HAND' -> 16r7F89.
		'IDC_HELP' -> 16r7F8B.
		'IDC_IBEAM' -> 16r7F01.
		'IDC_ICON' -> 16r7F81.
		'IDC_NO' -> 16r7F88.
		'IDC_SIZE' -> 16r7F80.
		'IDC_SIZEALL' -> 16r7F86.
		'IDC_SIZENESW' -> 16r7F83.
		'IDC_SIZENS' -> 16r7F85.
		'IDC_SIZENWSE' -> 16r7F82.
		'IDC_SIZEWE' -> 16r7F84.
		'IDC_UPARROW' -> 16r7F04.
		'IDC_WAIT' -> 16r7F02.
		'IDCANCEL' -> 16r2.
		'IDCLOSE' -> 16r8.
		'IDCONTINUE' -> 16rB.
		'IDHELP' -> 16r9.
		'IDI_APPLICATION' -> 16r7F00.
		'IDI_ERROR' -> 16r7F01.
		'IDI_INFORMATION' -> 16r7F04.
		'IDI_QUESTION' -> 16r7F02.
		'IDI_WARNING' -> 16r7F03.
		'IDI_WINLOGO' -> 16r7F05.
		'IDIGNORE' -> 16r5.
		'IDLE_PRIORITY_CLASS' -> 16r40.
		'IDNO' -> 16r7.
		'IDOK' -> 16r1.
		'IDRETRY' -> 16r4.
		'IDTRYAGAIN' -> 16rA.
		'IDYES' -> 16r6.
		'IMAGE_BITMAP' -> 16r0.
		'IMAGE_CURSOR' -> 16r2.
		'IMAGE_ENHMETAFILE' -> 16r3.
		'IMAGE_ICON' -> 16r1.
		'INFINITE' -> -16r1.
		'INVALID_HANDLE_VALUE' -> 16rFFFFFFFF.
		'IS_TEXT_UNICODE_REVERSE_MASK' -> 16rF0.
		'IS_TEXT_UNICODE_REVERSE_STATISTICS' -> 16r20.
		'IS_TEXT_UNICODE_SIGNATURE' -> 16r8.
		'IS_TEXT_UNICODE_STATISTICS' -> 16r2.
		'IS_TEXT_UNICODE_UNICODE_MASK' -> 16rF.
		'ISOLATIONAWARE_MANIFEST_RESOURCE_ID' -> 16r2.
		'KF_EXTENDED' -> 16r100.
		'KL_NAMELENGTH' -> 16r9.
		'KLF_ACTIVATE' -> 16r1.
		'KLF_NOTELLSHELL' -> 16r80.
		'KLF_REORDER' -> 16r8.
		'KLF_REPLACELANG' -> 16r10.
		'KLF_RESET' -> 16r40000000.
		'KLF_SETFORPROCESS' -> 16r100.
		'KLF_SHIFTLOCK' -> 16r10000.
		'KLF_SUBSTITUTE_OK' -> 16r2.
		'LF_FACESIZE' -> 16r20.
		'LF_FULLFACESIZE' -> 16r40.
		'LIM_LARGE' -> 16r1.
		'LIM_SMALL' -> 16r1.
		'LOAD_LIBRARY_AS_DATAFILE' -> 16r2.
		'LOGPIXELSX' -> 16r58.
		'LOGPIXELSY' -> 16r5A.
		'LPSTR_TEXTCALLBACK' -> -16r1.
		'LR_COLOR' -> 16r2.
		'LR_COPYDELETEORG' -> 16r8.
		'LR_COPYFROMRESOURCE' -> 16r4000.
		'LR_COPYRETURNORG' -> 16r4.
		'LR_CREATEDIBSECTION' -> 16r2000.
		'LR_DEFAULTCOLOR' -> 16r0.
		'LR_DEFAULTSIZE' -> 16r40.
		'LR_LOADFROMFILE' -> 16r10.
		'LR_LOADMAP3DCOLORS' -> 16r1000.
		'LR_LOADTRANSPARENT' -> 16r20.
		'LR_MONOCHROME' -> 16r1.
		'LR_SHARED' -> 16r8000.
		'LR_VGACOLOR' -> 16r80.
		'LTGRAY_BRUSH' -> 16r1.
		'LWA_ALPHA' -> 16r2.
		'LWA_COLORKEY' -> 16r1.
		'MAPVK_VK_TO_VSC' -> 16r0.
		'MAPVK_VSC_TO_VK' -> 16r1.
		'MAPVK_VSC_TO_VK_CHAR' -> 16r2.
		'MAPVK_VSC_TO_VK_EX' -> 16r3.
		'MAX_COMPUTERNAME_LENGTH' -> 16rF.
		'MAX_UCSCHAR' -> 16r10FFFF.
		'MB_ERR_INVALID_CHARS' -> 16r8.
		'MEM_COMMIT' -> 16r1000.
		'MEM_DECOMMIT' -> 16r4000.
		'MEM_FREE' -> 16r10000.
		'MEM_IMAGE' -> 16r1000000.
		'MEM_MAPPED' -> 16r40000.
		'MEM_PRIVATE' -> 16r20000.
		'MEM_RELEASE' -> 16r8000.
		'MEM_RESERVE' -> 16r2000.
		'MEM_TOP_DOWN' -> 16r100000.
		'MERGECOPY' -> 16rC000CA.
		'MF_BYCOMMAND' -> 16r0.
		'MF_BYPOSITION' -> 16r400.
		'MF_POPUP' -> 16r10.
		'MFS_CHECKED' -> 16r8.
		'MFS_DEFAULT' -> 16r1000.
		'MFS_DISABLED' -> 16r1.
		'MFS_ENABLED' -> 16r0.
		'MFS_UNCHECKED' -> 16r0.
		'MFT_MENUBARBREAK' -> 16r20.
		'MFT_MENUBREAK' -> 16r40.
		'MFT_RADIOCHECK' -> 16r200.
		'MFT_SEPARATOR' -> 16r800.
		'MFT_STRING' -> 16r0.
		'MIIM_BITMAP' -> 16r80.
		'MIIM_CHECKMARKS' -> 16r8.
		'MIIM_DATA' -> 16r20.
		'MIIM_FTYPE' -> 16r100.
		'MIIM_ID' -> 16r2.
		'MIIM_STATE' -> 16r1.
		'MIIM_STRING' -> 16r40.
		'MIIM_SUBMENU' -> 16r4.
		'MIIM_TYPE' -> 16r10.
		'MIM_APPLYTOSUBMENUS' -> 16r80000000.
		'MIM_BACKGROUND' -> 16r2.
		'MIM_HELPID' -> 16r4.
		'MIM_MAXHEIGHT' -> 16r1.
		'MIM_MENUDATA' -> 16r8.
		'MIM_STYLE' -> 16r10.
		'MK_CONTROL' -> 16r8.
		'MK_LBUTTON' -> 16r1.
		'MK_MBUTTON' -> 16r10.
		'MK_RBUTTON' -> 16r2.
		'MK_SHIFT' -> 16r4.
		'MK_XBUTTON1' -> 16r20.
		'MK_XBUTTON2' -> 16r40.
		'MM_ANISOTROPIC' -> 16r8.
		'MM_HIENGLISH' -> 16r5.
		'MM_HIMETRIC' -> 16r3.
		'MM_ISOTROPIC' -> 16r7.
		'MM_LOENGLISH' -> 16r4.
		'MM_LOMETRIC' -> 16r2.
		'MM_TEXT' -> 16r1.
		'MM_TWIPS' -> 16r6.
		'MNS_AUTODISMISS' -> 16r10000000.
		'MNS_CHECKORBMP' -> 16r4000000.
		'MNS_DRAGDROP' -> 16r20000000.
		'MNS_MODELESS' -> 16r40000000.
		'MNS_NOCHECK' -> 16r80000000.
		'MNS_NOTIFYBYPOS' -> 16r8000000.
		'MOD_ALT' -> 16r1.
		'MOD_CONTROL' -> 16r2.
		'MOD_SHIFT' -> 16r4.
		'MOD_WIN' -> 16r8.
		'MSGF_MENU' -> 16r2.
		'MWMO_ALERTABLE' -> 16r2.
		'MWMO_INPUTAVAILABLE' -> 16r4.
		'MWMO_WAITALL' -> 16r1.
		'NIF_ICON' -> 16r2.
		'NIF_MESSAGE' -> 16r1.
		'NIF_TIP' -> 16r4.
		'NIM_ADD' -> 16r0.
		'NIM_DELETE' -> 16r2.
		'NIM_MODIFY' -> 16r1.
		'NORMAL_PRIORITY_CLASS' -> 16r20.
		'NOTSRCCOPY' -> 16r330008.
		'NULL_BRUSH' -> 16r5.
		'NULL_PEN' -> 16r8.
		'OBJ_BRUSH' -> 16r2.
		'OBJ_FONT' -> 16r6.
		'OBJ_PEN' -> 16r1.
		'ODS_GRAYED' -> 16r2.
		'ODS_SELECTED' -> 16r1.
		'ODT_BUTTON' -> 16r4.
		'ODT_COMBOBOX' -> 16r3.
		'ODT_LISTBOX' -> 16r2.
		'ODT_MENU' -> 16r1.
		'ODT_STATIC' -> 16r5.
		'OEM_FIXED_FONT' -> 16rA.
		'OPAQUE' -> 16r2.
		'OPEN_ALWAYS' -> 16r4.
		'OPEN_EXISTING' -> 16r3.
		'PAGE_EXECUTE' -> 16r10.
		'PAGE_EXECUTE_READ' -> 16r20.
		'PAGE_EXECUTE_READWRITE' -> 16r40.
		'PAGE_EXECUTE_WRITECOPY' -> 16r80.
		'PAGE_GUARD' -> 16r100.
		'PAGE_NOACCESS' -> 16r1.
		'PAGE_NOCACHE' -> 16r200.
		'PAGE_READONLY' -> 16r2.
		'PAGE_READWRITE' -> 16r4.
		'PAGE_WRITECOPY' -> 16r8.
		'PLANES' -> 16rE.
		'PM_NOREMOVE' -> 16r0.
		'PM_REMOVE' -> 16r1.
		'PRF_CHECKVISIBLE' -> 16r1.
		'PRF_CHILDREN' -> 16r10.
		'PRF_CLIENT' -> 16r4.
		'PRF_ERASEBKGND' -> 16r8.
		'PRF_NONCLIENT' -> 16r2.
		'PRF_OWNED' -> 16r20.
		'PROCESS_TERMINATE' -> 16r1.
		'PS_ALTERNATE' -> 16r8.
		'PS_COSMETIC' -> 16r0.
		'PS_DASH' -> 16r1.
		'PS_DASHDOT' -> 16r3.
		'PS_DASHDOTDOT' -> 16r4.
		'PS_DOT' -> 16r2.
		'PS_ENDCAPFLAT' -> 16r200.
		'PS_ENDCAPMASK' -> 16rF00.
		'PS_ENDCAPROUND' -> 16r0.
		'PS_ENDCAPSQUARE' -> 16r100.
		'PS_GEOMETRIC' -> 16r10000.
		'PS_INSIDEFRAME' -> 16r6.
		'PS_JOINBEVEL' -> 16r1000.
		'PS_JOINMASK' -> 16rF000.
		'PS_JOINMITER' -> 16r2000.
		'PS_JOINROUND' -> 16r0.
		'PS_NULL' -> 16r5.
		'PS_SOLID' -> 16r0.
		'PS_STYLEMASK' -> 16rF.
		'PS_TYPEMASK' -> 16rF0000.
		'PS_USERSTYLE' -> 16r7.
		'QS_ALLPOSTMESSAGE' -> 16r100.
		'QS_HOTKEY' -> 16r80.
		'QS_KEY' -> 16r1.
		'QS_MOUSE' -> 16r6.
		'QS_MOUSEBUTTON' -> 16r4.
		'QS_MOUSEMOVE' -> 16r2.
		'QS_PAINT' -> 16r20.
		'QS_POINTER' -> 16r1000.
		'QS_POSTMESSAGE' -> 16r8.
		'QS_RAWINPUT' -> 16r400.
		'QS_SENDMESSAGE' -> 16r40.
		'QS_TIMER' -> 16r10.
		'QS_TOUCH' -> 16r800.
		'RDW_ALLCHILDREN' -> 16r80.
		'RDW_ERASE' -> 16r4.
		'RDW_ERASENOW' -> 16r200.
		'RDW_FRAME' -> 16r400.
		'RDW_INTERNALPAINT' -> 16r2.
		'RDW_INVALIDATE' -> 16r1.
		'RDW_NOCHILDREN' -> 16r40.
		'RDW_NOERASE' -> 16r20.
		'RDW_NOFRAME' -> 16r800.
		'RDW_NOINTERNALPAINT' -> 16r10.
		'RDW_UPDATENOW' -> 16r100.
		'RDW_VALIDATE' -> 16r8.
		'REALTIME_PRIORITY_CLASS' -> 16r100.
		'RGN_AND' -> 16r1.
		'RGN_DIFF' -> 16r4.
		'RGN_OR' -> 16r2.
		'RGN_XOR' -> 16r3.
		'RT_ICON' -> 16r3.
		'RT_MANIFEST' -> 16r18.
		'RT_RCDATA' -> 16rA.
		'RT_STRING' -> 16r6.
		'RT_VERSION' -> 16r10.
		'SB_BOTH' -> 16r3.
		'SB_BOTTOM' -> 16r7.
		'SB_CTL' -> 16r2.
		'SB_ENDSCROLL' -> 16r8.
		'SB_HORZ' -> 16r0.
		'SB_LEFT' -> 16r6.
		'SB_LINEDOWN' -> 16r1.
		'SB_LINELEFT' -> 16r0.
		'SB_LINERIGHT' -> 16r1.
		'SB_LINEUP' -> 16r0.
		'SB_PAGEDOWN' -> 16r3.
		'SB_PAGELEFT' -> 16r2.
		'SB_PAGERIGHT' -> 16r3.
		'SB_PAGEUP' -> 16r2.
		'SB_RIGHT' -> 16r7.
		'SB_THUMBPOSITION' -> 16r4.
		'SB_THUMBTRACK' -> 16r5.
		'SB_TOP' -> 16r6.
		'SB_VERT' -> 16r1.
		'SC_CLOSE' -> 16rF060.
		'SIF_ALL' -> 16r17.
		'SIF_DISABLENOSCROLL' -> 16r8.
		'SIF_PAGE' -> 16r2.
		'SIF_POS' -> 16r4.
		'SIF_RANGE' -> 16r1.
		'SIF_TRACKPOS' -> 16r10.
		'SIZE_MAXHIDE' -> 16r4.
		'SIZE_MAXIMIZED' -> 16r2.
		'SIZE_MAXSHOW' -> 16r3.
		'SIZE_MINIMIZED' -> 16r1.
		'SIZE_RESTORED' -> 16r0.
		'SM_CXBORDER' -> 16r5.
		'SM_CXCURSOR' -> 16rD.
		'SM_CXDLGFRAME' -> 16r7.
		'SM_CXDRAG' -> 16r44.
		'SM_CXEDGE' -> 16r2D.
		'SM_CXHTHUMB' -> 16rA.
		'SM_CXICON' -> 16rB.
		'SM_CXMENUCHECK' -> 16r47.
		'SM_CXMENUSIZE' -> 16r36.
		'SM_CXSIZEFRAME' -> 16r20.
		'SM_CXSMICON' -> 16r31.
		'SM_CXVIRTUALSCREEN' -> 16r4E.
		'SM_CYBORDER' -> 16r6.
		'SM_CYCURSOR' -> 16rE.
		'SM_CYDLGFRAME' -> 16r7.
		'SM_CYDRAG' -> 16r45.
		'SM_CYEDGE' -> 16r2E.
		'SM_CYICON' -> 16rC.
		'SM_CYMENU' -> 16rF.
		'SM_CYMENUCHECK' -> 16r48.
		'SM_CYMENUSIZE' -> 16r37.
		'SM_CYSIZEFRAME' -> 16r21.
		'SM_CYSMICON' -> 16r32.
		'SM_CYVIRTUALSCREEN' -> 16r4F.
		'SM_CYVTHUMB' -> 16r9.
		'SM_SLOWMACHINE' -> 16r49.
		'SM_XVIRTUALSCREEN' -> 16r4C.
		'SM_YVIRTUALSCREEN' -> 16r4D.
		'SND_ALIAS' -> 16r10000.
		'SND_ASYNC' -> 16r1.
		'SND_FILENAME' -> 16r20000.
		'SND_LOOP' -> 16r8.
		'SND_MEMORY' -> 16r4.
		'SND_NODEFAULT' -> 16r2.
		'SND_NOSTOP' -> 16r10.
		'SND_NOWAIT' -> 16r2000.
		'SND_RESERVED' -> 16rFF000000.
		'SND_RESOURCE' -> 16r40004.
		'SND_SYNC' -> 16r0.
		'SND_TYPEMASK' -> 16r170007.
		'SND_VALIDFLAGS' -> 16r17201F.
		'SORT_DIGITSASNUMBERS' -> 16r8.
		'SORT_STRINGSORT' -> 16r1000.
		'SPI_GETFLATMENU' -> 16r1022.
		'SPI_GETICONTITLELOGFONT' -> 16r1F.
		'SPI_GETLISTBOXSMOOTHSCROLLING' -> 16r1006.
		'SPI_GETMOUSEHOVERTIME' -> 16r66.
		'SPI_GETNONCLIENTMETRICS' -> 16r29.
		'SPI_GETWHEELSCROLLLINES' -> 16r68.
		'SPI_GETWORKAREA' -> 16r30.
		'SPI_SETFLATMENU' -> 16r1023.
		'SPI_SETICONTITLELOGFONT' -> 16r22.
		'SPI_SETLISTBOXSMOOTHSCROLLING' -> 16r1007.
		'SPI_SETNONCLIENTMETRICS' -> 16r2A.
		'SPIF_SENDCHANGE' -> 16r2.
		'SPIF_UPDATEINIFILE' -> 16r1.
		'SRCAND' -> 16r8800C6.
		'SRCCOPY' -> 16rCC0020.
		'SRCINVERT' -> 16r660046.
		'SRCPAINT' -> 16rEE0086.
		'SS_BITMAP' -> 16rE.
		'SS_BLACKFRAME' -> 16r7.
		'SS_BLACKRECT' -> 16r4.
		'SS_CENTER' -> 16r1.
		'SS_CENTERIMAGE' -> 16r200.
		'SS_ENHMETAFILE' -> 16rF.
		'SS_ETCHEDFRAME' -> 16r12.
		'SS_ETCHEDHORZ' -> 16r10.
		'SS_ETCHEDVERT' -> 16r11.
		'SS_GRAYFRAME' -> 16r8.
		'SS_GRAYRECT' -> 16r5.
		'SS_ICON' -> 16r3.
		'SS_LEFT' -> 16r0.
		'SS_LEFTNOWORDWRAP' -> 16rC.
		'SS_NOPREFIX' -> 16r80.
		'SS_NOTIFY' -> 16r100.
		'SS_OWNERDRAW' -> 16rD.
		'SS_REALSIZEIMAGE' -> 16r800.
		'SS_RIGHT' -> 16r2.
		'SS_RIGHTJUST' -> 16r400.
		'SS_SIMPLE' -> 16rB.
		'SS_SUNKEN' -> 16r1000.
		'SS_TYPEMASK' -> 16r1F.
		'SS_USERITEM' -> 16rA.
		'SS_WHITEFRAME' -> 16r9.
		'SS_WHITERECT' -> 16r6.
		'STARTF_FORCEOFFFEEDBACK' -> 16r80.
		'STARTF_FORCEONFEEDBACK' -> 16r40.
		'STARTF_RUNFULLSCREEN' -> 16r20.
		'STARTF_USECOUNTCHARS' -> 16r8.
		'STARTF_USEFILLATTRIBUTE' -> 16r10.
		'STARTF_USEPOSITION' -> 16r4.
		'STARTF_USESHOWWINDOW' -> 16r1.
		'STARTF_USESIZE' -> 16r2.
		'STARTF_USESTDHANDLES' -> 16r100.
		'STATUS_ABANDONED_WAIT_0' -> 16r80.
		'STATUS_TIMEOUT' -> 16r102.
		'STATUS_WAIT_0' -> 16r0.
		'STD_ERROR_HANDLE' -> -16rC.
		'STD_INPUT_HANDLE' -> -16rA.
		'STD_OUTPUT_HANDLE' -> -16rB.
		'STILL_ACTIVE' -> 16r103.
		'STM_GETICON' -> 16r171.
		'STM_GETIMAGE' -> 16r173.
		'STM_SETICON' -> 16r170.
		'STM_SETIMAGE' -> 16r172.
		'STN_CLICKED' -> 16r0.
		'STN_DBLCLK' -> 16r1.
		'STN_DISABLE' -> 16r3.
		'STN_ENABLE' -> 16r2.
		'SW_ERASE' -> 16r4.
		'SW_HIDE' -> 16r0.
		'SW_INVALIDATE' -> 16r2.
		'SW_MAX' -> 16rA.
		'SW_MAXIMIZE' -> 16r3.
		'SW_MINIMIZE' -> 16r6.
		'SW_NORMAL' -> 16r1.
		'SW_RESTORE' -> 16r9.
		'SW_SCROLLCHILDREN' -> 16r1.
		'SW_SHOW' -> 16r5.
		'SW_SHOWDEFAULT' -> 16rA.
		'SW_SHOWMAXIMIZED' -> 16r3.
		'SW_SHOWMINIMIZED' -> 16r2.
		'SW_SHOWMINNOACTIVE' -> 16r7.
		'SW_SHOWNA' -> 16r8.
		'SW_SHOWNOACTIVATE' -> 16r4.
		'SW_SHOWNORMAL' -> 16r1.
		'SWP_FRAMECHANGED' -> 16r20.
		'SWP_HIDEWINDOW' -> 16r80.
		'SWP_NOACTIVATE' -> 16r10.
		'SWP_NOCOPYBITS' -> 16r100.
		'SWP_NOMOVE' -> 16r2.
		'SWP_NOOWNERZORDER' -> 16r200.
		'SWP_NOREDRAW' -> 16r8.
		'SWP_NOSIZE' -> 16r1.
		'SWP_NOZORDER' -> 16r4.
		'SWP_SHOWWINDOW' -> 16r40.
		'SYSTEM_FIXEDFONT' -> 16r10.
		'SYSTEM_FONT' -> 16rD.
		'TA_BASELINE' -> 16r18.
		'TA_BOTTOM' -> 16r8.
		'TA_CENTER' -> 16r6.
		'TA_LEFT' -> 16r0.
		'TA_NOUPDATECP' -> 16r0.
		'TA_RIGHT' -> 16r2.
		'TA_TOP' -> 16r0.
		'TA_UPDATECP' -> 16r1.
		'TEST' -> 16r59.
		'TME_CANCEL' -> -16r80000000.
		'TME_HOVER' -> 16r1.
		'TME_LEAVE' -> 16r2.
		'TME_QUERY' -> 16r40000000.
		'TPM_BOTTOMALIGN' -> 16r20.
		'TPM_CENTERALIGN' -> 16r4.
		'TPM_HORIZONTAL' -> 16r0.
		'TPM_LEFTALIGN' -> 16r0.
		'TPM_LEFTBUTTON' -> 16r0.
		'TPM_NONOTIFY' -> 16r80.
		'TPM_RETURNCMD' -> 16r100.
		'TPM_RIGHTALIGN' -> 16r8.
		'TPM_RIGHTBUTTON' -> 16r2.
		'TPM_TOPALIGN' -> 16r0.
		'TPM_VCENTERALIGN' -> 16r10.
		'TPM_VERTICAL' -> 16r40.
		'TRANSPARENT' -> 16r1.
		'TRUE' -> 16r1.
		'TRUNCATE_EXISTING' -> 16r5.
		'UIS_CLEAR' -> 16r2.
		'UIS_INITIALIZE' -> 16r3.
		'UIS_SET' -> 16r1.
		'UISF_ACTIVE' -> 16r4.
		'UISF_HIDEACCEL' -> 16r2.
		'UISF_HIDEFOCUS' -> 16r1.
		'VER_AND' -> 16r6.
		'VER_BUILDNUMBER' -> 16r4.
		'VER_EQUAL' -> 16r1.
		'VER_GREATER' -> 16r2.
		'VER_GREATER_EQUAL' -> 16r3.
		'VER_LESS' -> 16r4.
		'VER_LESS_EQUAL' -> 16r5.
		'VER_MAJORVERSION' -> 16r2.
		'VER_MINORVERSION' -> 16r1.
		'VER_NT_DOMAIN_CONTROLLER' -> 16r2.
		'VER_NT_SERVER' -> 16r3.
		'VER_NT_WORKSTATION' -> 16r1.
		'VER_OR' -> 16r7.
		'VER_PLATFORM_WIN32_NT' -> 16r2.
		'VER_PLATFORM_WIN32_WINDOWS' -> 16r1.
		'VER_PLATFORM_WIN32s' -> 16r0.
		'VER_PLATFORMID' -> 16r8.
		'VER_PRODUCT_TYPE' -> 16r80.
		'VER_SERVICEPACKMAJOR' -> 16r20.
		'VER_SERVICEPACKMINOR' -> 16r10.
		'VER_SUITENAME' -> 16r40.
		'VERTRES' -> 16rA.
		'VERTSIZE' -> 16r6.
		'VK_ADD' -> 16r6B.
		'VK_APPS' -> 16r5D.
		'VK_BACK' -> 16r8.
		'VK_CANCEL' -> 16r3.
		'VK_CAPITAL' -> 16r14.
		'VK_CLEAR' -> 16rC.
		'VK_CONTROL' -> 16r11.
		'VK_DECIMAL' -> 16r6E.
		'VK_DELETE' -> 16r2E.
		'VK_DIVIDE' -> 16r6F.
		'VK_DOWN' -> 16r28.
		'VK_END' -> 16r23.
		'VK_ESCAPE' -> 16r1B.
		'VK_EXECUTE' -> 16r2B.
		'VK_F1' -> 16r70.
		'VK_F10' -> 16r79.
		'VK_F11' -> 16r7A.
		'VK_F12' -> 16r7B.
		'VK_F2' -> 16r71.
		'VK_F3' -> 16r72.
		'VK_F4' -> 16r73.
		'VK_F5' -> 16r74.
		'VK_F6' -> 16r75.
		'VK_F7' -> 16r76.
		'VK_F8' -> 16r77.
		'VK_F9' -> 16r78.
		'VK_HOME' -> 16r24.
		'VK_INSERT' -> 16r2D.
		'VK_LBUTTON' -> 16r1.
		'VK_LEFT' -> 16r25.
		'VK_LSHIFT' -> 16rA0.
		'VK_LWIN' -> 16r5B.
		'VK_MBUTTON' -> 16r4.
		'VK_MENU' -> 16r12.
		'VK_MULTIPLY' -> 16r6A.
		'VK_NEXT' -> 16r22.
		'VK_NUMLOCK' -> 16r90.
		'VK_NUMPAD0' -> 16r60.
		'VK_NUMPAD1' -> 16r61.
		'VK_NUMPAD2' -> 16r62.
		'VK_NUMPAD3' -> 16r63.
		'VK_NUMPAD4' -> 16r64.
		'VK_NUMPAD5' -> 16r65.
		'VK_NUMPAD6' -> 16r66.
		'VK_NUMPAD7' -> 16r67.
		'VK_NUMPAD8' -> 16r68.
		'VK_NUMPAD9' -> 16r69.
		'VK_OEM_1' -> 16rBA.
		'VK_OEM_2' -> 16rBF.
		'VK_OEM_3' -> 16rC0.
		'VK_OEM_4' -> 16rDB.
		'VK_OEM_5' -> 16rDC.
		'VK_OEM_6' -> 16rDD.
		'VK_OEM_7' -> 16rDE.
		'VK_OEM_8' -> 16rDF.
		'VK_OEM_COMMA' -> 16rBC.
		'VK_OEM_MINUS' -> 16rBD.
		'VK_OEM_PERIOD' -> 16rBE.
		'VK_OEM_PLUS' -> 16rBB.
		'VK_PAUSE' -> 16r13.
		'VK_PRINT' -> 16r2A.
		'VK_PRIOR' -> 16r21.
		'VK_RBUTTON' -> 16r2.
		'VK_RETURN' -> 16rD.
		'VK_RIGHT' -> 16r27.
		'VK_RMENU' -> 16rA5.
		'VK_RWIN' -> 16r5C.
		'VK_SCROLL' -> 16r91.
		'VK_SELECT' -> 16r29.
		'VK_SHIFT' -> 16r10.
		'VK_SNAPSHOT' -> 16r2C.
		'VK_SPACE' -> 16r20.
		'VK_SUBTRACT' -> 16r6D.
		'VK_TAB' -> 16r9.
		'VK_UP' -> 16r26.
		'VK_XBUTTON1' -> 16r5.
		'VK_XBUTTON2' -> 16r6.
		'WA_ACTIVE' -> 16r1.
		'WA_CLICKACTIVE' -> 16r2.
		'WA_INACTIVE' -> 16r0.
		'WAIT_ABANDONED' -> 16r80.
		'WAIT_ABANDONED_0' -> 16r80.
		'WAIT_FAILED' -> -16r1.
		'WAIT_IO_COMPLETION' -> 16rC0.
		'WAIT_OBJECT_0' -> 16r0.
		'WAIT_TIMEOUT' -> 16r102.
		'WC_ERR_INVALID_CHARS' -> 16r80.
		'WHEEL_DELTA' -> 16r78.
		'WHEEL_PAGESCROLL' -> -16r1.
		'WHITE_BRUSH' -> 16r0.
		'WHITE_PEN' -> 16r6.
		'WHITENESS' -> 16rFF0062.
		'WM_ACTIVATE' -> 16r6.
		'WM_ACTIVATEAPP' -> 16r1C.
		'WM_APP' -> 16r8000.
		'WM_ASKCBFORMATNAME' -> 16r30C.
		'WM_BEGINDRAG' -> 16r22C.
		'WM_CANCELJOURNAL' -> 16r4B.
		'WM_CANCELMODE' -> 16r1F.
		'WM_CAPTURECHANGED' -> 16r215.
		'WM_CHANGECBCHAIN' -> 16r30D.
		'WM_CHANGEUISTATE' -> 16r127.
		'WM_CHAR' -> 16r102.
		'WM_CHARTOITEM' -> 16r2F.
		'WM_CHILDACTIVATE' -> 16r22.
		'WM_CLEAR' -> 16r303.
		'WM_CLOSE' -> 16r10.
		'WM_COMMAND' -> 16r111.
		'WM_COMMNOTIFY' -> 16r44.
		'WM_COMPACTING' -> 16r41.
		'WM_COMPAREITEM' -> 16r39.
		'WM_CONTEXTMENU' -> 16r7B.
		'WM_COPY' -> 16r301.
		'WM_COPYDATA' -> 16r4A.
		'WM_CREATE' -> 16r1.
		'WM_CTLCOLORBTN' -> 16r135.
		'WM_CTLCOLORDLG' -> 16r136.
		'WM_CTLCOLOREDIT' -> 16r133.
		'WM_CTLCOLORLISTBOX' -> 16r134.
		'WM_CTLCOLORMSGBOX' -> 16r132.
		'WM_CTLCOLORSCROLLBAR' -> 16r137.
		'WM_CTLCOLORSTATIC' -> 16r138.
		'WM_CUT' -> 16r300.
		'WM_DDE_INITIATE' -> 16r3E0.
		'WM_DEADCHAR' -> 16r103.
		'WM_DELETEITEM' -> 16r2D.
		'WM_DESTROY' -> 16r2.
		'WM_DESTROYCLIPBOARD' -> 16r307.
		'WM_DEVICECHANGE' -> 16r219.
		'WM_DEVMODECHANGE' -> 16r1B.
		'WM_DISPLAYCHANGE' -> 16r7E.
		'WM_DRAWCLIPBOARD' -> 16r308.
		'WM_DRAWITEM' -> 16r2B.
		'WM_DROPFILES' -> 16r233.
		'WM_ENABLE' -> 16rA.
		'WM_ENDSESSION' -> 16r16.
		'WM_ENTERIDLE' -> 16r121.
		'WM_ENTERMENULOOP' -> 16r211.
		'WM_ENTERSIZEMOVE' -> 16r231.
		'WM_ERASEBKGND' -> 16r14.
		'WM_EXITMENULOOP' -> 16r212.
		'WM_EXITSIZEMOVE' -> 16r232.
		'WM_FONTCHANGE' -> 16r1D.
		'WM_GETDLGCODE' -> 16r87.
		'WM_GETFONT' -> 16r31.
		'WM_GETHOTKEY' -> 16r33.
		'WM_GETICON' -> 16r7F.
		'WM_GETMINMAXINFO' -> 16r24.
		'WM_GETTEXT' -> 16rD.
		'WM_GETTEXTLENGTH' -> 16rE.
		'WM_HELP' -> 16r53.
		'WM_HOTKEY' -> 16r312.
		'WM_HSCROLL' -> 16r114.
		'WM_HSCROLLCLIPBOARD' -> 16r30E.
		'WM_ICONERASEBKGND' -> 16r27.
		'WM_IDLEUPDATECMDUI' -> 16r363.
		'WM_INITDIALOG' -> 16r110.
		'WM_INITMENU' -> 16r116.
		'WM_INITMENUPOPUP' -> 16r117.
		'WM_INPUTLANGCHANGE' -> 16r51.
		'WM_INPUTLANGCHANGEREQUEST' -> 16r50.
		'WM_KEYDOWN' -> 16r100.
		'WM_KEYFIRST' -> 16r100.
		'WM_KEYLAST' -> 16r108.
		'WM_KEYUP' -> 16r101.
		'WM_KILLFOCUS' -> 16r8.
		'WM_LBUTTONDBLCLK' -> 16r203.
		'WM_LBUTTONDOWN' -> 16r201.
		'WM_LBUTTONUP' -> 16r202.
		'WM_MBUTTONDBLCLK' -> 16r209.
		'WM_MBUTTONDOWN' -> 16r207.
		'WM_MBUTTONUP' -> 16r208.
		'WM_MEASUREITEM' -> 16r2C.
		'WM_MENUCHAR' -> 16r120.
		'WM_MENUCOMMAND' -> 16r126.
		'WM_MENUSELECT' -> 16r11F.
		'WM_MOUSEACTIVATE' -> 16r21.
		'WM_MOUSEFIRST' -> 16r200.
		'WM_MOUSEHOVER' -> 16r2A1.
		'WM_MOUSEHWHEEL' -> 16r20E.
		'WM_MOUSELAST' -> 16r20E.
		'WM_MOUSELEAVE' -> 16r2A3.
		'WM_MOUSEMOVE' -> 16r200.
		'WM_MOUSEWHEEL' -> 16r20A.
		'WM_MOVE' -> 16r3.
		'WM_MOVING' -> 16r216.
		'WM_NCACTIVATE' -> 16r86.
		'WM_NCCALCSIZE' -> 16r83.
		'WM_NCCREATE' -> 16r81.
		'WM_NCDESTROY' -> 16r82.
		'WM_NCHITTEST' -> 16r84.
		'WM_NCLBUTTONDBLCLK' -> 16rA3.
		'WM_NCLBUTTONDOWN' -> 16rA1.
		'WM_NCLBUTTONUP' -> 16rA2.
		'WM_NCMBUTTONDBLCLK' -> 16rA9.
		'WM_NCMBUTTONDOWN' -> 16rA7.
		'WM_NCMBUTTONUP' -> 16rA8.
		'WM_NCMOUSEMOVE' -> 16rA0.
		'WM_NCPAINT' -> 16r85.
		'WM_NCRBUTTONDBLCLK' -> 16rA6.
		'WM_NCRBUTTONDOWN' -> 16rA4.
		'WM_NCRBUTTONUP' -> 16rA5.
		'WM_NEXTDLGCTL' -> 16r28.
		'WM_NEXTMENU' -> 16r213.
		'WM_NOTIFY' -> 16r4E.
		'WM_NOTIFYFORMAT' -> 16r55.
		'WM_NULL' -> 16r0.
		'WM_PAINT' -> 16rF.
		'WM_PAINTCLIPBOARD' -> 16r309.
		'WM_PAINTICON' -> 16r26.
		'WM_PALETTECHANGED' -> 16r311.
		'WM_PALETTEISCHANGING' -> 16r310.
		'WM_PARENTNOTIFY' -> 16r210.
		'WM_PASTE' -> 16r302.
		'WM_POWER' -> 16r48.
		'WM_POWERBROADCAST' -> 16r218.
		'WM_PRINT' -> 16r317.
		'WM_PRINTCLIENT' -> 16r318.
		'WM_QUERYDRAGICON' -> 16r37.
		'WM_QUERYENDSESSION' -> 16r11.
		'WM_QUERYNEWPALETTE' -> 16r30F.
		'WM_QUERYOPEN' -> 16r13.
		'WM_QUERYUISTATE' -> 16r129.
		'WM_QUEUESYNC' -> 16r23.
		'WM_QUIT' -> 16r12.
		'WM_RBUTTONDBLCLK' -> 16r206.
		'WM_RBUTTONDOWN' -> 16r204.
		'WM_RBUTTONUP' -> 16r205.
		'WM_RENDERALLFORMATS' -> 16r306.
		'WM_RENDERFORMAT' -> 16r305.
		'WM_SETCURSOR' -> 16r20.
		'WM_SETEVENTMASK' -> 16r445.
		'WM_SETFOCUS' -> 16r7.
		'WM_SETFONT' -> 16r30.
		'WM_SETHOTKEY' -> 16r32.
		'WM_SETICON' -> 16r80.
		'WM_SETREDRAW' -> 16rB.
		'WM_SETTEXT' -> 16rC.
		'WM_SETTINGCHANGE' -> 16r1A.
		'WM_SHOWWINDOW' -> 16r18.
		'WM_SIZE' -> 16r5.
		'WM_SIZECLIPBOARD' -> 16r30B.
		'WM_SIZING' -> 16r214.
		'WM_SPOOLERSTATUS' -> 16r2A.
		'WM_STYLECHANGED' -> 16r7D.
		'WM_STYLECHANGING' -> 16r7C.
		'WM_SYSCHAR' -> 16r106.
		'WM_SYSCOLORCHANGE' -> 16r15.
		'WM_SYSCOMMAND' -> 16r112.
		'WM_SYSDEADCHAR' -> 16r107.
		'WM_SYSKEYDOWN' -> 16r104.
		'WM_SYSKEYUP' -> 16r105.
		'WM_TCARD' -> 16r52.
		'WM_THEMECHANGED' -> 16r31A.
		'WM_TIMECHANGE' -> 16r1E.
		'WM_TIMER' -> 16r113.
		'WM_UNDO' -> 16r304.
		'WM_UPDATEUISTATE' -> 16r128.
		'WM_USER' -> 16r400.
		'WM_USER_LAST' -> 16r7FFF.
		'WM_USERCHANGED' -> 16r54.
		'WM_VKEYTOITEM' -> 16r2E.
		'WM_VSCROLL' -> 16r115.
		'WM_VSCROLLCLIPBOARD' -> 16r30A.
		'WM_WINDOWPOSCHANGED' -> 16r47.
		'WM_WINDOWPOSCHANGING' -> 16r46.
		'WM_WININICHANGE' -> 16r1A.
		'WM_XBUTTONDBLCLK' -> 16r20D.
		'WM_XBUTTONDOWN' -> 16r20B.
		'WM_XBUTTONUP' -> 16r20C.
		'WS_BORDER' -> 16r800000.
		'WS_CAPTION' -> 16rC00000.
		'WS_CHILD' -> 16r40000000.
		'WS_CHILDWINDOW' -> 16r40000000.
		'WS_CLIPCHILDREN' -> 16r2000000.
		'WS_CLIPSIBLINGS' -> 16r4000000.
		'WS_DISABLED' -> 16r8000000.
		'WS_DLGFRAME' -> 16r400000.
		'WS_EX_ACCEPTFILES' -> 16r10.
		'WS_EX_APPWINDOW' -> 16r40000.
		'WS_EX_CLIENTEDGE' -> 16r200.
		'WS_EX_COMPOSITED' -> 16r2000000.
		'WS_EX_CONTEXTHELP' -> 16r400.
		'WS_EX_CONTROLPARENT' -> 16r10000.
		'WS_EX_DLGMODALFRAME' -> 16r1.
		'WS_EX_LAYERED' -> 16r80000.
		'WS_EX_LEFT' -> 16r0.
		'WS_EX_LEFTSCROLLBAR' -> 16r4000.
		'WS_EX_LTRREADING' -> 16r0.
		'WS_EX_NOACTIVATE' -> 16r8000000.
		'WS_EX_NOPARENTNOTIFY' -> 16r4.
		'WS_EX_NOTIFYDRAG' -> 16r2.
		'WS_EX_OVERLAPPEDWINDOW' -> 16r300.
		'WS_EX_PALETTEWINDOW' -> 16r188.
		'WS_EX_RIGHT' -> 16r1000.
		'WS_EX_RIGHTSCROLLBAR' -> 16r0.
		'WS_EX_RTLREADING' -> 16r2000.
		'WS_EX_STATICEDGE' -> 16r20000.
		'WS_EX_TOOLWINDOW' -> 16r80.
		'WS_EX_TOPMOST' -> 16r8.
		'WS_EX_TRANSPARENT' -> 16r20.
		'WS_EX_WINDOWEDGE' -> 16r100.
		'WS_GROUP' -> 16r20000.
		'WS_HSCROLL' -> 16r100000.
		'WS_ICONIC' -> 16r20000000.
		'WS_MAXIMIZE' -> 16r1000000.
		'WS_MAXIMIZEBOX' -> 16r10000.
		'WS_MINIMIZE' -> 16r20000000.
		'WS_MINIMIZEBOX' -> 16r20000.
		'WS_OVERLAPPED' -> 16r0.
		'WS_OVERLAPPEDWINDOW' -> 16rCF0000.
		'WS_POPUP' -> 16r80000000.
		'WS_POPUPWINDOW' -> -16r7F780000.
		'WS_SIZEBOX' -> 16r40000.
		'WS_SYSMENU' -> 16r80000.
		'WS_TABSTOP' -> 16r10000.
		'WS_THICKFRAME' -> 16r40000.
		'WS_TILED' -> 16r0.
		'WS_TILEDWINDOW' -> 16rCF0000.
		'WS_VISIBLE' -> 16r10000000.
		'WS_VSCROLL' -> 16r200000.
		'WVR_ALIGNBOTTOM' -> 16r40.
		'WVR_ALIGNLEFT' -> 16r20.
		'WVR_ALIGNRIGHT' -> 16r80.
		'WVR_ALIGNTOP' -> 16r10.
		'WVR_HREDRAW' -> 16r100.
		'WVR_REDRAW' -> 16r300.
		'WVR_VALIDRECTS' -> 16r400.
		'WVR_VREDRAW' -> 16r200
	}!
Kernel.SharedPool subclass: #'OS.Win32Errors'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'CLASS_E_CLASSNOTAVAILABLE' -> -16r7FFBFEEF.
		'CLASS_E_NOAGGREGATION' -> -16r7FFBFEF0.
		'CLASS_E_NOTLICENSED' -> -16r7FFBFEEE.
		'E_ABORT' -> -16r7FFFBFFC.
		'E_ACCESSDENIED' -> -16r7FF8FFFB.
		'E_FAIL' -> -16r7FFFBFFB.
		'E_HANDLE' -> -16r7FF8FFFA.
		'E_INVALIDARG' -> -16r7FF8FFA9.
		'E_NOINTERFACE' -> -16r7FFFBFFE.
		'E_NOTIMPL' -> -16r7FFFBFFF.
		'E_OUTOFMEMORY' -> -16r7FF8FFF2.
		'E_PENDING' -> -16r7FFFFFF6.
		'E_POINTER' -> -16r7FFFBFFD.
		'E_UNEXPECTED' -> -16r7FFF0001.
		'ERROR_ACCESS_DENIED' -> 16r5.
		'ERROR_ALREADY_EXISTS' -> 16rB7.
		'ERROR_FILE_NOT_FOUND' -> 16r2.
		'ERROR_HANDLE_EOF' -> 16r26.
		'ERROR_INSUFFICIENT_BUFFER' -> 16r7A.
		'ERROR_INVALID_DATA' -> 16rD.
		'ERROR_INVALID_HANDLE' -> 16r6.
		'ERROR_INVALID_NAME' -> 16r7B.
		'ERROR_INVALID_PARAMETER' -> 16r57.
		'ERROR_MORE_DATA' -> 16rEA.
		'ERROR_MR_MID_NOT_FOUND' -> 16r13D.
		'ERROR_NO_MORE_FILES' -> 16r12.
		'ERROR_NO_MORE_ITEMS' -> 16r103.
		'ERROR_NOACCESS' -> 16r3E6.
		'ERROR_OPERATION_ABORTED' -> 16r3E3.
		'ERROR_PROC_NOT_FOUND' -> 16r7F.
		'ERROR_STACK_OVERFLOW' -> 16r3E9.
		'ERROR_SUCCESS' -> 16r0.
		'NO_ERROR' -> 16r0.
		'S_FALSE' -> 16r1.
		'S_OK' -> 16r0.
		'SEVERITY_ERROR' -> 16r1.
		'SEVERITY_SUCCESS' -> 16r0.
		'STATUS_INVALID_PARAMETER' -> -16r3FFFFFF3.
		'STATUS_TIMER_RESOLUTION_NOT_SET' -> -16r3FFFFDBB.
		'STG_E_INVALIDFUNCTION' -> -16r7FFCFFFF.
		'WCODE_HRESULT_FIRST' -> -16r7FFBFE00.
		'WCODE_HRESULT_LAST' -> -16r7FFB0001
	}!
nil subclass: #'Core.Object'
	instanceVariableNames: ''
	classVariableNames: '_AssertionFailureSignal _DependentsRegister _EventsRegister _PropertyRegister'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
nil subclass: #'Kernel.ProtoObject'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.AbstractBindingReference'
	instanceVariableNames: ''
	classVariableNames: 'Undeclared'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'External.ArrayFieldLength'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.AttributeDescriptor'
	instanceVariableNames: 'flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'AccessorMask' -> 16r4.
		'MutableMask' -> 16r20.
		'MutatorMask' -> 16r8.
		'NonBrowsableMask' -> 16r80.
		'NullableMask' -> 16r40.
		'OverrideMask' -> 16r10.
		'ReadableMask' -> 16r1.
		'WriteableMask' -> 16r2
	}!
Core.Object subclass: #'Core.Behavior'
	instanceVariableNames: 'superclass methodDictionary instanceSpec'
	classVariableNames: '_NullMethodDictionary'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_BasicSpecMask' -> 16r7FFF.
		'_BytesSubMask' -> 16r4800.
		'_FundamentalShapeMask' -> 16r30FF.
		'_GetSpecialMask' -> 16rFF00.
		'_IndirectMask' -> 16r800.
		'_IsFinalizableMask' -> 16r8.
		'_IsPointersMask' -> 16r2.
		'_IsWeakMask' -> 16r12.
		'_MournerMask' -> 16r400.
		'_NonInstantiableMask' -> 16r200.
		'_NullTermMask' -> 16r4000.
		'_PointersMask' -> 16r2000.
		'_ShapeMask' -> 16r70FF.
		'_SizeMask' -> 16rFF.
		'_VariableMask' -> 16r1000
	}!
Core.Object subclass: #'Kernel.BindingContext'
	instanceVariableNames: 'source identifier visited'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object variableSubclass: #'Kernel.BlockClosure'
	instanceVariableNames: 'outer method initialIP info receiver'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.Boolean'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.ByteCodeDispatcher'
	instanceVariableNames: 'byteCodes method ip interpreter instructionLength byteCode instructions'
	classVariableNames: 'RunStarts'
	imports: #(#{Kernel.OpcodePool})
	classInstanceVariableNames: ''
	classConstants: {
		'FirstShowSpecialSend' -> 16r7E.
		'InstructionLengths' -> #[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 7 4 4 5].
		'Instructions' -> #(#break #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushTemp: #shortPushTemp: #shortPushTemp: #shortPushTemp: #shortPushTemp: #shortPushTemp: #shortPushTemp: #shortPushTemp: #pushContextTemp: #pushContextTemp: #shortPushOuterTemp: #shortPushOuterTemp: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #pushSelf #pushPseudo: #pushPseudo: #pushPseudo: #shortPushImmediate: #shortPushImmediate: #shortPushImmediate: #shortPushImmediate: #shortPushSelfAndTemp: #shortPushSelfAndTemp: #shortPushSelfAndTemp: #shortPushSelfAndTemp: #shortStoreTemp: #shortStoreTemp: #shortStoreTemp: #shortStoreTemp: #shortPopPushTemp: #shortPopPushTemp: #popPushSelf #popDup #popContextTemp: #popContextTemp: #shortPopOuterTemp: #shortPopOuterTemp: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopTemp: #shortPopTemp: #shortPopTemp: #shortPopTemp: #shortPopTemp: #shortPopTemp: #shortPopTemp: #shortPopTemp: #popStackTop #incrementStackTop #decrementStackTop #duplicateStackTop #returnSelf #returnPseudo: #returnPseudo: #returnPseudo: #returnFromMessage #returnFromBlock #returnFromBlockHome #popReturnSelf #nop #shortJump: #shortJump: #shortJump: #shortJump: #shortJump: #shortJump: #shortJump: #shortJump: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #isZero #pushActiveFrame #shortSpecialSendEx: #shortSpecialSendEx: #shortSpecialSendEx: #shortSpecialSendEx: #pushInstVar: #pushTemp: #pushConst: #pushStatic: #storeInstVar: #storeTemp: #storeStatic: #popInstVar: #popTemp: #popStatic: #pushImmediate: #pushChar: #send: #supersend: #specialSend: #nearJump: #nearJumpIfTrue: #nearJumpIfFalse: #nearJumpIfNil: #nearJumpIfNotNil: #unused: #unused: #sendTempZeroArgs: #pushSelfAndTemp: #pushOuterTemp: #storeOuterTemp: #popOuterTemp: #sendSelfZeroArgs: #unused: #pushTempPair: #longPushConst:with: #longPushStatic:with: #longStoreStatic:with: #longPopStoreStatic:with: #longPushImmediate:with: #longSend:with: #longSupersend:with: #longJump:with: #longJumpIfTrue:with: #longJumpIfFalse:with: #longJumpIfNil:with: #longJumpIfNotNil:with: #pushOuter:temp: #storeOuter:temp: #incTemp:temp: #incPushTemp:temp: #decTemp:temp: #decPushTemp:temp: #blockCopy:stack:env:copy:offset1:offset2: #exLongSend:with:with: #exLongSupersend:with:with: #exLongPushImmediate:byte2:byte3:byte4:)
	}!
Core.Object subclass: #'External.Callback'
	instanceVariableNames: 'thunk cookie descriptor'
	classVariableNames: 'Registry ThunkBase'
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {
		'ArgSizeOffset' -> 16rE.
		'MaxThunks' -> 16r100.
		'ThunkSize' -> 16r10
	}!
Core.Object subclass: #'Core.Category'
	instanceVariableNames: 'name'
	classVariableNames: 'PermanentCategories'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.ChunkReader'
	instanceVariableNames: 'chunkBlock endAction context'
	classVariableNames: 'Null'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.ClassBuilder'
	instanceVariableNames: 'currentClass className instanceVariables superclass instanceSpec classVariables imports comment flags categories classConstants environment'
	classVariableNames: 'FixedInitialLayout FixedLayout Unsubclassable'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'IgnoreInstsMask' -> 16r2.
		'RecompileMask' -> 16r1
	}!
Core.Object subclass: #'Core.Collection'
	instanceVariableNames: ''
	classVariableNames: 'AbsentCookie'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.CompilationResult'
	instanceVariableNames: 'method rawTextMap rawTempsMap textMap tempsMap oldMethod package'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object variableSubclass: #'Kernel.CompiledCode'
	instanceVariableNames: 'header methodClass selector sourceDescriptor byteCodes'
	classVariableNames: 'InfoCacheKeys InfoCacheValues'
	imports: #(#{Kernel.OpcodePool})
	classInstanceVariableNames: ''
	classConstants: {
		'PrivateMask' -> 16r1
	}!
Core.Object subclass: #'Kernel.Compiler'
	instanceVariableNames: ''
	classVariableNames: 'DefaultFlags DisabledWarnings'
	imports: #(#{Kernel.CompilerFlags} #{Kernel.ParseErrorCodes})
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object variableSubclass: #'Kernel.Context'
	instanceVariableNames: 'outer block'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.DeadObject'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.DeafObject'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.DeferredValue'
	instanceVariableNames: 'valueAvailable value exception'
	classVariableNames: 'ValuePending'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.Delay'
	instanceVariableNames: 'duration resumptionTime waitSemaphore'
	classVariableNames: 'AccessProtect Current HighestResolution ImageClock LowestResolution Pending Resolution TicksToNanos TimingProcess TimingSemaphore'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'DefaultResolution' -> 16r3D09
	}!
Core.Object subclass: #'External.DynamicLinkLibrary'
	instanceVariableNames: 'handle'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants private} #{OS.Win32Errors private} #{Kernel._PrimitiveFailureCode private})
	classInstanceVariableNames: 'default'
	classConstants: {}!
Core.Object subclass: #'Core.Exception'
	instanceVariableNames: 'tag messageText _activeHandler _process _signalFrame _environmentWhenRaised _continueBlock _resignalBlock _resignalException'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants private} #{OS.Win32Errors private} #{OS.MessageBoxConstants private})
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.ExceptionHandlerAbstract'
	instanceVariableNames: 'outer protectedBlock returnContinuation'
	classVariableNames: 'RetryCookie'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.ExceptionSet'
	instanceVariableNames: 'selectors'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.File'
	instanceVariableNames: 'handle spec flags shareFlags intBuffer'
	classVariableNames: 'CheckModes NoCheckModes ShareModes'
	imports: #(#{OS.Win32Constants private} #{OS private})
	classInstanceVariableNames: ''
	classConstants: {
		'AccessFlagsMask' -> -16r8.
		'OpenFlagsMask' -> 16r7
	}!
Core.Object subclass: #'Core.FileLocator'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object variableSubclass: #'External.FunctionDescriptor'
	instanceVariableNames: 'descriptor'
	classVariableNames: 'CallingConventions ReferenceTypes TypeNames TypeSizes ValueTypes'
	imports: #(#{External.ExtCallArgTypes})
	classInstanceVariableNames: ''
	classConstants: {
		'RetClassIndex' -> 16r4.
		'RetTypeMask' -> 16r3F
	}!
Core.Object variableByteSubclass: #'Core.GUID'
	instanceVariableNames: ''
	classVariableNames: 'Null'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.InputState'
	instanceVariableNames: 'inputSemaphore idler idleTimer main windows deferredActions lastWindow wakeupEvent msgWindow queueStatusMask'
	classVariableNames: 'MaxIdleSleep SamplingInterval UserInterruptSignal'
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.InstructionInterpreter'
	instanceVariableNames: 'dispatcher'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.Link'
	instanceVariableNames: 'nextLink'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.Locale'
	instanceVariableNames: 'numberFormat'
	classVariableNames: 'InstalledUILanguages Invariant SystemDefault TimeZoneInfo UserDefault'
	imports: #(#{OS.NlsConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.Magnitude'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.MemoryManager'
	instanceVariableNames: 'finalizer lastRequests hospice hospiceHighWater maxObjects undertaker bereavements bereaved bereavedHighWater gcInterval lastGCTime lastGCDuration objectHeaderSize events'
	classVariableNames: 'Current GCInterval'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.Message'
	instanceVariableNames: 'selector args'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.MessageSequenceAbstract'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.MethodName'
	instanceVariableNames: 'className selector'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.MethodProtocol'
	instanceVariableNames: 'name comment selectors flags'
	classVariableNames: 'ANSIMask Protocols ReadOnlyMask StubAddedSignal'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.ModalMsgLoop'
	instanceVariableNames: 'loop'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.Model'
	instanceVariableNames: 'events'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.Mutex'
	instanceVariableNames: 'owner semaphore'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.Namespace'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.ObjectRegistry'
	instanceVariableNames: 'registry'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.Package'
	instanceVariableNames: 'name packagePathname comment classNames methodNames variableNames prerequisiteNames events scripts doNotReuse imageStripperBytes aboutBlock packageVersion manualPrerequisites timestamp untracedVariables changeIndex properties preDeclareClassesOnLoad'
	classVariableNames: '_Uncommitted BinaryPacLoader ChangedIcon CheckTimestamps ClashSignal PreDeclareClassesOnLoad SourcePackageIcon UnsaveableSignal'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.PackageManager'
	instanceVariableNames: 'packages processEvents packagedVariables looseMethods events defaultPackage basePackages'
	classVariableNames: 'Current DuplicatePackageSignal PackageNotFoundSignal PrerequisiteNotFoundSignal SystemPackage'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.PostedActionWindow'
	instanceVariableNames: 'handle actions'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.ProcessorScheduler'
	instanceVariableNames: 'processLists activeProcess pendingReturns comStubs _reserved pendingTerminations'
	classVariableNames: 'ConstWriteSignal InterruptSelectors'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.PropertyManager'
	instanceVariableNames: 'register'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'UI.ResourceIdentifier'
	instanceVariableNames: 'owningClass selector'
	classVariableNames: 'SelectorPrefix'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.SearchPolicy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.SessionManager'
	instanceVariableNames: 'inputState resourceLibrary imagePath servers argv cmdLineFlags state sentry startupArgs consoleHandler stdioStreams eventLogHandle flags sessionId hConsole settingsChanged events'
	classVariableNames: 'Current PreStartFile'
	imports: #(#{OS.Win32Constants private} #{OS.Win32Errors private} #{OS private})
	classInstanceVariableNames: ''
	classConstants: {
		'EmbeddingMask' -> 16r1.
		'SettingsChangeTimerId' -> 16r2
	}!
Core.Object subclass: #'Core.SharedQueue'
	instanceVariableNames: 'accessProtect valueAvailable contents'
	classVariableNames: 'AbsentCookie'
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.Signal'
	instanceVariableNames: 'description resumable'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.SortAlgorithm'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.Sound'
	instanceVariableNames: 'name location type fileLocator'
	classVariableNames: 'Registry'
	imports: #(#{OS.Win32Constants} #{OS.MessageBoxConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.SourceFiler'
	instanceVariableNames: 'stream evaluationContext flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'SourceOnlyMask' -> 16r1
	}!
Core.Object subclass: #'Kernel.SourceManager'
	instanceVariableNames: 'mutex'
	classVariableNames: 'ChangesIndex DefaultInstance SourcesIndex'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.StackFrame'
	instanceVariableNames: 'process index'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'BPOffset' -> 16r5.
		'EnvOffset' -> 16r1.
		'FrameSize' -> 16r6.
		'IPOffset' -> 16r3.
		'MethodOffset' -> 16r0.
		'ReturnOffset' -> 16r2.
		'SPOffset' -> 16r4
	}!
Core.Object subclass: #'Kernel.STBClassConversion'
	instanceVariableNames: 'version instSize dataClass isVariable converterBlock filer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Kernel.STBFiler'
	instanceVariableNames: 'stream context version'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'MaxPredefinedRef' -> 16r18
	}!
Core.Object subclass: #'Kernel.STBPrefix'
	instanceVariableNames: 'dword'
	classVariableNames: 'DataPrefix ProxyPrefix'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'BytesMask' -> 16r10.
		'CharacterMask' -> 16r4.
		'ClassPrefixMask' -> 16r4.
		'DataPrefixMask' -> 16r2.
		'IndexShift' -> -16r4.
		'InstSizeMask' -> 16rFF.
		'InstSizeShift' -> -16r8.
		'LiteralPrefixMask' -> 16r8.
		'LocatorLenShift' -> -16r10.
		'MaxPredefinedRef' -> 16r18.
		'NonZeroVersionMask' -> 16r40.
		'ProxyMask' -> 16r8.
		'SmallIntegerMask' -> 16r1.
		'VariableMask' -> 16r20
	}!
Core.Object subclass: #'Kernel.STBProxy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.Stream'
	instanceVariableNames: ''
	classVariableNames: 'EndOfStreamSignal'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'External.Structure'
	instanceVariableNames: 'bytes'
	classVariableNames: 'RecordClasses'
	imports: #()
	classInstanceVariableNames: 'template flags alignment'
	classConstants: {
		'CompiledMask' -> 16r1
	}!
Core.Object subclass: #'Kernel.UndeclaredVariable'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'Core.UndefinedObject'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Object subclass: #'OS.VersionInfo'
	instanceVariableNames: 'fileInfo prefix fixedInfo'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.AbstractBindingReference subclass: #'Kernel.BindingReference'
	instanceVariableNames: 'pathString path context flags binding generation'
	classVariableNames: 'Generation'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'MetaMask' -> 16r1.
		'PrivateMask' -> 16r2
	}!
Kernel.AbstractBindingReference subclass: #'Kernel.MetaBindingReference'
	instanceVariableNames: 'instance'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ArrayFieldLength subclass: #'External.FixedArrayFieldLength'
	instanceVariableNames: 'elementCount'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.AttributeDescriptor subclass: #'External.Field'
	instanceVariableNames: 'offset structClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Field subclass: #'External.EmbeddedField'
	instanceVariableNames: 'fieldClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Field subclass: #'External.FillerField'
	instanceVariableNames: 'byteSize'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Field subclass: #'External.PointerField'
	instanceVariableNames: 'pointerClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Field subclass: #'External.ScalarField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.EmbeddedField subclass: #'External.ArrayField'
	instanceVariableNames: 'arrayLength'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.EmbeddedField subclass: #'External.StructureField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ArrayField subclass: #'External.StringField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ArrayField subclass: #'External.StructureArrayField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.StructureArrayField subclass: #'External.PointerArrayField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.PointerField subclass: #'External.ArrayPointerField'
	instanceVariableNames: 'arrayLength'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ArrayPointerField subclass: #'External.StructureArrayPointerField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.StructureArrayPointerField subclass: #'External.PointerArrayPointerField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ScalarField subclass: #'External.AbstractCHARField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ScalarField subclass: #'External.BOOLField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ScalarField subclass: #'External.BYTEField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ScalarField subclass: #'External.DOUBLEField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ScalarField subclass: #'External.DWORDField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ScalarField subclass: #'External.FLOATField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ScalarField subclass: #'External.INT_PTRField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ScalarField subclass: #'External.QWORDField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ScalarField subclass: #'External.SBYTEField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ScalarField subclass: #'External.SDWORDField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ScalarField subclass: #'External.SQWORDField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ScalarField subclass: #'External.SWORDField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ScalarField subclass: #'External.UINT_PTRField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ScalarField subclass: #'External.WORDField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.AbstractCHARField subclass: #'External.CHARField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.AbstractCHARField subclass: #'External.WCHARField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.BOOLField subclass: #'External.BOOLEANField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UINT_PTRField subclass: #'External.HANDLEField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UINT_PTRField subclass: #'External.LPVOIDField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Behavior subclass: #'Core.ClassDescription'
	instanceVariableNames: 'instanceVariables methodsCatalogue protocols'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.ClassDescription subclass: #'Core.Class'
	instanceVariableNames: 'subclasses name fullName classPool imports environment comment classCategories _guid'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.ClassDescription subclass: #'Core.Metaclass'
	instanceVariableNames: 'instanceClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Boolean subclass: #'Core.False'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Boolean subclass: #'Core.True'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Callback subclass: #'External.BlockCallback'
	instanceVariableNames: 'block'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Callback subclass: #'External.MessageCallback'
	instanceVariableNames: 'receiver selector closure'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Category subclass: #'Core.ClassCategory'
	instanceVariableNames: ''
	classVariableNames: 'Table Unclassified'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Category subclass: #'Core.MethodCategory'
	instanceVariableNames: ''
	classVariableNames: 'Private Pseuds Public Table'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Collection subclass: #'Core.Bag'
	instanceVariableNames: 'contents'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Collection subclass: #'Core.SequenceableCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Collection variableSubclass: #'Core.Set'
	instanceVariableNames: 'tally'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'MaxOffsetIndex' -> 16r402.
		'PrimeSizes' -> #(16r815 16r8BD 16r977 16rA39 16rAED 16rBB7 16rC5F 16rD1F 16rDD3 16rE8F 16rF47 16r1159 16r12B3 16r13FF 16r155F 16r16A9 16r17FF 16r1979 16r1AAB 16r1C09 16r1D5D 16r1EAD 16r224F 16r2581 16r2803 16r2A73 16r2D1D 16r2FCF 16r3277 16r356F 16r37D5 16r3AA5 16r3D73 16r44A1 16r4A6B 16r4FDB 16r5507 16r5A77 16r6023 16r64F7 16r6B05 16r6F9B 16r755F 16r7AA5 16r8BBB 16r9539 16r9F89 16rABC5 16rB629 16rBF5D 16rC9AF 16rD463 16rE005 16rEAEB 16rF5F9 16r113BD 16r1293B 16r139DB 16r14F53 16r16249 16r1762F 16r18AA3 16r19F15 16r1B227 16r1C441 16r1D773 16r1ED67 16r2263F 16r24BFB 16r274C9 16r29A3D 16r2C3FB 16r2E8FD 16r313B5 16r33BB3 16r36043 16r38C8F 16r3B4B9 16r3D633 16r44DE9 16r49745 16r4E99D 16r534EB 16r58771 16r5DAC1 16r62003 16r6740F 16r6C35F 16r71837 16r75AF1 16r7B0CB 16r895BD 16r93E53 16r9E1EB 16rA6687 16rB0AA7 16rBA5AB 16rC5545 16rCE3A5 16rD8593 16rE239F 16rEC23D 16rF7B59).
		'SmallPrimeOffsets' -> #[0 0 0 8 6 4 2 0 0 2 0 4 2 0 0 4 2 0 2 0 0 2 0 4 2 0 4 2 0 0 4 2 0 2 0 0 4 2 0 8 6 4 2 0 6 4 2 0 2 0 0 2 0 0 2 0 12 10 8 6 4 2 0 2 0 4 2 0 0 8 6 4 2 0 0 4 2 0 4 2 0 2 0 4 2 0 4 2 0 0 8 6 4 2 0 0 2 0 0 10 8 6 4 2 0 10 8 6 4 2 0 2 0 0 2 0 4 2 0 0 8 6 4 2 0 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 52 50 48 46 44 42 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 0 16 14 12 10 8 6 4 2 0 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 52 50 48 46 44 42 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 2 0 10 8 6 4 2 0 10 8 6 4 2 0 10 8 6 4 2 0 4 2 0 12 10 8 6 4 2 0 16 14 12 10 8 6 4 2 0 14 12 10 8 6 4 2 0 4 2 0 6 4 2 0 14 12 10 8 6 4 2 0 10 8 6 4 2 0 16 14 12 10 8 6 4 2 0 0 22 20 18 16 14 12 10 8 6 4 2 0 2 0 10 8 6 4 2 0 16 14 12 10 8 6 4 2 0 22 20 18 16 14 12 10 8 6 4 2 0 6 4 2 0 8 6 4 2 0 6 4 2 0 10 8 6 4 2 0 2 0 6 4 2 0 4 2 0 2 0 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 12 10 8 6 4 2 0 14 12 10 8 6 4 2 0 0 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 2 0 12 10 8 6 4 2 0 4 2 0 2 0 18 16 14 12 10 8 6 4 2 0 2 0 16 14 12 10 8 6 4 2 0 6 4 2 0 2 0 4 2 0 4 2 0 12 10 8 6 4 2 0 2 0 4 2 0 4 2 0 6 4 2 0 16 14 12 10 8 6 4 2 0 10 8 6 4 2 0 8 6 4 2 0 0 14 12 10 8 6 4 2 0 0 8 6 4 2 0 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 0 2 0 18 16 14 12 10 8 6 4 2 0 10 8 6 4 2 0 20 18 16 14 12 10 8 6 4 2 0 0 8 6 4 2 0 6 4 2 0 8 6 4 2 0 10 8 6 4 2 0 6 4 2 0 14 12 10 8 6 4 2 0 4 2 0 4 2 0 0 26 24 22 20 18 16 14 12 10 8 6 4 2 0 18 16 14 12 10 8 6 4 2 0 2 0 4 2 0 0 4 2 0 2 0 0 2 0 10 8 6 4 2 0 6 4 2 0 44 42 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 6 4 2 0 26 24 22 20 18 16 14 12 10 8 6 4 2 0 18 16 14 12 10 8 6 4 2 0 2 0 12 10 8 6 4 2 0 2 0 0 16 14 12 10 8 6 4 2 0 8 6 4 2 0 0 2 0 4 2 0 16 14 12 10 8 6 4 2 0 18 16 14 12 10 8 6 4 2 0 10 8 6 4 2 0 8 6 4 2 0 4 2 0 6 4 2 0 2 0 6 4 2 0 2 0 16 14 12 10 8 6 4 2 0 4 2 0 10 8 6 4 2 0 0 4 2 0 8 6 4 2 0 24 22 20 18 16 14 12 10 8 6 4 2 0 2 0 0 22 20 18 16 14 12 10 8 6 4 2 0 2 0 0 8 6 4 2 0 10 8 6 4 2 0 0 8 6 4 2 0 6 4 2 0 4 2 0 4 2 0 4 2 0 22 20 18 16 14 12 10 8 6 4 2 0 2 0 12 10 8 6 4 2 0 8 6 4 2 0 10 8 6 4 2 0 6 4 2 0 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 4 2 0 8 6 4 2 0 0 8 6 4 2 0 16 14 12 10 8 6 4 2 0 4 2 0 18 16 14 12 10 8 6 4 2 0 14 12 10 8 6 4 2 0 0 26 24 22 20 18 16 14 12 10 8 6 4 2 0 6 4 2 0 4 2 0 4 2 0 2 0 6 4 2 0 4 2 0 8 6 4 2 0 0 8 6 4 2 0 12 10 8 6 4 2 0]
	}!
Core.SequenceableCollection subclass: #'Core.ArrayedCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SequenceableCollection subclass: #'Core.Interval'
	instanceVariableNames: 'start stop step'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SequenceableCollection subclass: #'Core.SequencedGrowableCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.ArrayedCollection variableSubclass: #'Core.Array'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.ArrayedCollection variableByteSubclass: #'Core.ByteArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.ArrayedCollection subclass: #'Core.RunArray'
	instanceVariableNames: 'values runs'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.ArrayedCollection variableByteSubclass: #'Core.String'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'empty'
	classConstants: {
		'EncodingAnsi' -> 16r0.
		'Encodings' -> #(#ansi #utf8 #utf16le #utf32).
		'EncodingUtf16' -> 16r2.
		'EncodingUtf32' -> 16r3.
		'EncodingUtf8' -> 16r1.
		'LineDelimiter' -> '
'
	}!
Core.ArrayedCollection variableSubclass: #'Core.WeakArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.ByteArray variableByteSubclass: #'External.IntegerBytes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.IntegerBytes variableByteSubclass: #'External.DWORDBytes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.IntegerBytes variableByteSubclass: #'External.UIntPtrBytes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UIntPtrBytes variableByteSubclass: #'External.Address'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UIntPtrBytes variableByteSubclass: #'External.Handle'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Address variableByteSubclass: #'External.Memory'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
External.Address variableByteSubclass: #'External.REFGUID'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.String variableByteSubclass: #'Core.AnsiString'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.String variableByteSubclass: #'Core.UtfEncodedString'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.UtfEncodedString variableByteSubclass: #'Core.Utf16String'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'Bom' -> #[255 254].
		'LeadOffset' -> 16rD7C0.
		'SurrogateOffset' -> 16r35FDC00
	}!
Core.UtfEncodedString variableByteSubclass: #'Core.Utf8String'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'Bom' -> #[239 187 191].
		'LeadByteMask2' -> 16rC0.
		'LeadByteMask3' -> 16rE0.
		'LeadByteMask4' -> 16rF0.
		'TrailByteMask' -> 16r80
	}!
Core.Utf8String variableByteSubclass: #'Core.Symbol'
	instanceVariableNames: ''
	classVariableNames: 'Table'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'CharClassifications' -> #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #binary nil nil nil #binary #binary nil nil nil #binary #binary #binary #binary nil #binary #digit #digit #digit #digit #digit #digit #digit #digit #digit #digit #colon nil #binary #binary #binary #binary #binary #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic nil #binary nil nil #alphabetic nil #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic nil #binary nil #binary nil)
	}!
Core.WeakArray variableSubclass: #'Core.MourningWeakArray'
	instanceVariableNames: 'pathologist'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SequencedGrowableCollection subclass: #'Core.LinkedList'
	instanceVariableNames: 'firstLink lastLink'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SequencedGrowableCollection variableSubclass: #'Core.OrderedCollection'
	instanceVariableNames: 'firstIndex lastIndex'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.LinkedList subclass: #'Core.Semaphore'
	instanceVariableNames: 'signals'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.OrderedCollection variableSubclass: #'Core.SortedCollection'
	instanceVariableNames: 'algorithm'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Set variableSubclass: #'Core.Dictionary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Set variableSubclass: #'Core.IdentitySet'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Set variableSubclass: #'Core.PluggableSet'
	instanceVariableNames: 'searchPolicy'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Set variableSubclass: #'Core.SharedSet'
	instanceVariableNames: 'mutex'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Dictionary variableSubclass: #'Core.LookupTable'
	instanceVariableNames: 'values'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Dictionary variableSubclass: #'Kernel.PoolDictionary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.LookupTable variableSubclass: #'Core.IdentityDictionary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.LookupTable variableSubclass: #'Core.PluggableLookupTable'
	instanceVariableNames: 'searchPolicy'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.LookupTable variableSubclass: #'Core.SharedLookupTable'
	instanceVariableNames: 'mutex'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.IdentityDictionary variableSubclass: #'Kernel.MethodDictionary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SharedLookupTable variableSubclass: #'Core.DeferredValueTable'
	instanceVariableNames: 'priority'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SharedLookupTable variableSubclass: #'Core.SharedIdentityDictionary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SharedLookupTable variableSubclass: #'Core.WeakLookupTable'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SharedIdentityDictionary variableSubclass: #'Kernel.EventsCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.EventsCollection variableSubclass: #'Kernel.NullEventsCollection'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.WeakLookupTable variableSubclass: #'Core.WeakIdentityDictionary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SharedSet variableSubclass: #'Core.SharedIdentitySet'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SharedSet variableSubclass: #'Core.WeakSet'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.WeakSet variableSubclass: #'Core.WeakIdentitySet'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.CompiledCode variableSubclass: #'Kernel.CompiledExpression'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.CompiledCode variableSubclass: #'Kernel.CompiledMethod'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.CompiledMethod variableSubclass: #'Kernel.CompileFailedMethod'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.CompiledMethod variableSubclass: #'External.ExternalMethod'
	instanceVariableNames: ''
	classVariableNames: 'ArgsLenIndex ArgumentStartIndex CallingConventionIndex ReturnParmIndex ReturnTypeIndex'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.DynamicLinkLibrary subclass: #'OS.AdvApiLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.DynamicLinkLibrary subclass: #'Kernel.CompilerLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.DynamicLinkLibrary subclass: #'External.PermanentLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.DynamicLinkLibrary subclass: #'External.ResourceLibrary'
	instanceVariableNames: 'fileName loadFlags'
	classVariableNames: 'Libraries'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.DynamicLinkLibrary subclass: #'OS.RPCLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.DynamicLinkLibrary subclass: #'OS.ShlwapiLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.DynamicLinkLibrary subclass: #'OS.VersionLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.DynamicLinkLibrary subclass: #'OS.WinMMLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.PermanentLibrary subclass: #'OS.CRTLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.PermanentLibrary subclass: #'OS.KernelLibrary'
	instanceVariableNames: ''
	classVariableNames: 'WinVerOrGreaterMask'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.PermanentLibrary subclass: #'OS.NTLibrary'
	instanceVariableNames: ''
	classVariableNames: 'IsWine'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.PermanentLibrary subclass: #'OS.UserLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.MessageBoxConstants private})
	classInstanceVariableNames: ''
	classConstants: {}!
External.PermanentLibrary subclass: #'Kernel.VMLibrary'
	instanceVariableNames: 'wndProc dlgProc genericCallback vtable specialSelectorStart'
	classVariableNames: 'Registry RegistryKeys'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.CRTLibrary subclass: #'OS.CRTLibraryNonBlocking'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Exception subclass: #'Core.Error'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Exception subclass: #'Core.Notification'
	instanceVariableNames: 'isSuppressible'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Exception subclass: #'Kernel.ProcessTermination'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Exception subclass: #'Kernel.StackOverflow'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error subclass: #'Core.ArithmeticError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error subclass: #'Core.BoundsError'
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error subclass: #'Kernel.CannotReturnError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error subclass: #'Kernel.ClassRemovalError'
	instanceVariableNames: 'originalError'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error subclass: #'OS.CRTError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error subclass: #'OS.HRESULTError'
	instanceVariableNames: 'errorInfo osErrorMessage'
	classVariableNames: 'FacilityClasses'
	imports: #(#{OS.FacilityCodes private})
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error subclass: #'Core.InvalidArgumentError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error subclass: #'External.InvalidExternalCall'
	instanceVariableNames: 'argument type'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error subclass: #'Core.InvalidFormat'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error subclass: #'Core.MessageNotUnderstood'
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error subclass: #'Core.NotFoundError'
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error subclass: #'Core.OperationAborted'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error subclass: #'Kernel.RaisedSignal'
	instanceVariableNames: 'signalType'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error subclass: #'Kernel.STBError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error subclass: #'Kernel.SubclassResponsibilityError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.ArithmeticError subclass: #'Core.FloatingPointException'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.ArithmeticError subclass: #'Core.ZeroDivide'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.HRESULTError subclass: #'OS.Win32Error'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Win32Error subclass: #'Core.FileException'
	instanceVariableNames: 'file resumable'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Win32Error subclass: #'Kernel.OutOfMemoryError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Win32Error subclass: #'OS.RPCError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Win32Error subclass: #'OS.Win32Fault'
	instanceVariableNames: 'exceptionRecord'
	classVariableNames: 'ExceptionNames'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Win32Fault subclass: #'OS.GPFault'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Notification subclass: #'Kernel.CompilerNotification'
	instanceVariableNames: 'position ranges line extras methodClass source selector offset'
	classVariableNames: 'ErrorFormats'
	imports: #(#{Kernel.ParseErrorCodes private})
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Notification subclass: #'OS.HRESULTNotification'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Notification subclass: #'Kernel.MethodCompileFailed'
	instanceVariableNames: 'compilerErrorNotification'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Notification subclass: #'Kernel.RaisedNotificationSignal'
	instanceVariableNames: 'signalType'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Notification subclass: #'Core.Warning'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.CompilerNotification subclass: #'Kernel.CompilerErrorNotification'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.CompilerNotification subclass: #'Kernel.CompilerInfoNotification'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.CompilerNotification subclass: #'Kernel.CompilerWarningNotification'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.ExceptionHandlerAbstract subclass: #'Kernel.ExceptionHandler'
	instanceVariableNames: 'selector handler'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.ExceptionHandlerAbstract subclass: #'Kernel.ExceptionHandlerSet'
	instanceVariableNames: 'handlers'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.FileLocator subclass: #'Kernel.AbsoluteFileLocator'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.FileLocator subclass: #'Kernel.ClassLocator'
	instanceVariableNames: 'packageName codeBase key'
	classVariableNames: 'Aliases DefaultFileLocator ImportedClasses ImportedClassesMutex InstallationFileLocator'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.FileLocator subclass: #'Kernel.RelativeFileLocator'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.ClassLocator subclass: #'Kernel.ValidatingClassLocator'
	instanceVariableNames: 'validationBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.RelativeFileLocator subclass: #'Kernel.FolderRelativeFileLocator'
	instanceVariableNames: 'basePath'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.RelativeFileLocator subclass: #'Kernel.ImageRelativeFileLocator'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.RelativeFileLocator subclass: #'Kernel.InstallRelativeFileLocator'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.InstructionInterpreter subclass: #'Kernel.MessageSendCollector'
	instanceVariableNames: 'messageBlock superMessageBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'SendInstructions' -> #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: nil nil #shortSpecialSendEx: #shortSpecialSendEx: #shortSpecialSendEx: #shortSpecialSendEx: nil nil nil nil nil nil nil nil nil nil nil nil #send: #supersend: #specialSend: nil nil nil nil nil nil nil #sendTempZeroArgs: nil nil nil nil #sendSelfZeroArgs: nil nil nil nil nil nil nil #longSend:with: #longSupersend:with: nil nil nil nil nil nil nil nil nil nil nil nil #exLongSend:with:with: #exLongSupersend:with:with: nil)
	}!
Core.Link variableSubclass: #'Core.Process'
	instanceVariableNames: 'suspendedFrame priority myList callbackDepth _unused6 _unused7 fpControl threadSync thread exceptionEnvironment _unused12 _unused13 debugger name debugStream'
	classVariableNames: 'DefaultMaxStack'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'DefaultFpControl' -> 16r80007.
		'DefaultStack' -> 16r1
	}!
Core.Locale subclass: #'Kernel.SmalltalkLocale'
	instanceVariableNames: 'integerBase'
	classVariableNames: 'Current Hex'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Locale subclass: #'OS.WindowsLocale'
	instanceVariableNames: 'lcid info'
	classVariableNames: 'EnumNamesDescriptor'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Magnitude subclass: #'Core.ArithmeticValue'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Magnitude subclass: #'Core.Association'
	instanceVariableNames: 'key value'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Magnitude subclass: #'Core.Character'
	instanceVariableNames: 'code'
	classVariableNames: 'AnsiCharacters AnsiCodePage AnsiCodePoints CharacterSet Utf8Default'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'EncodingMask' -> 16r3F000000.
		'EscapeChars' -> #($0 nil nil nil nil nil nil $a $b $t $n $v $f $r).
		'Utf16LeadMask' -> 16rD800.
		'Utf16Mask' -> 16r2000000.
		'Utf16SurrogateMask' -> 16rFC00.
		'Utf16TrailMask' -> 16rDC00.
		'Utf32Mask' -> 16r3000000.
		'Utf8Mask' -> 16r1000000.
		'Utf8SurrogateMask' -> 16rC0
	}!
Core.Magnitude subclass: #'Core.DateAndTime'
	instanceVariableNames: 'rataDie seconds offset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'FiletimeEpochSeconds' -> -16r234474600.
		'JulianDateOffset' -> 16r22A11020C0.
		'LilianDayOffset' -> -16r8D0C7.
		'SmalltalkEpochRD' -> 16rA96C9
	}!
Core.Magnitude subclass: #'Core.Duration'
	instanceVariableNames: 'seconds'
	classVariableNames: 'Zero'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'SecondsPerDay' -> 16r15180.
		'SecondsPerHour' -> 16rE10
	}!
Core.ArithmeticValue subclass: #'Core.Number'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Number variableByteSubclass: #'Core.Float'
	instanceVariableNames: ''
	classVariableNames: 'DefaultDecimalExponents FMinDenormalized Infinity NaN NegativeInfinity'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'EMax' -> 16r3FF.
		'EMin' -> -16r3FE.
		'EMinDenormalized' -> -16r432.
		'FMax' -> 1.7976931348623157e308.
		'FMin' -> 2.2250738585072014e-308.
		'FpClassDenormal' -> 16r90.
		'FpClassFinite' -> 16r1F8.
		'FpClassInfinite' -> 16r204.
		'FpClassNaN' -> 16r3.
		'FpClassNegative' -> 16r3C.
		'FpClassNormal' -> 16r108.
		'FpClassStrictlyPositive' -> 16r380.
		'FpClassZero' -> 16r60.
		'InvalidOperationFlag' -> 16r1.
		'Ln2' -> 0.6931471805599453.
		'MantissaHighBit' -> 16r10000000000000.
		'MantissaMask' -> 16rFFFFFFFFFFFFF.
		'Precision' -> 16r35.
		'SignificantDifference' -> 1.0e-9
	}!
Core.Number subclass: #'Core.Fraction'
	instanceVariableNames: 'numerator denominator'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Number subclass: #'Core.Integer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Number subclass: #'Core.ScaledDecimal'
	instanceVariableNames: 'fraction scale'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Integer variableByteSubclass: #'Core.LargeInteger'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Integer subclass: #'Core.SmallInteger'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Association subclass: #'Kernel.VariableBinding'
	instanceVariableNames: 'environment flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'ClassMask' -> 16r2.
		'PrivateMask' -> 16r1
	}!
Core.Message subclass: #'Core.MessageSendAbstract'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.MessageSendAbstract variableSubclass: #'Kernel.EventMessageSend'
	instanceVariableNames: 'expectedArgCount'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.MessageSendAbstract subclass: #'Core.MessageSend'
	instanceVariableNames: 'receiver'
	classVariableNames: 'EmptySend'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.MessageSequenceAbstract subclass: #'Kernel.EventMessageSequence'
	instanceVariableNames: 'receivers messages tally'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.MessageSequenceAbstract subclass: #'Core.MessageSequence'
	instanceVariableNames: 'list'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.ObjectRegistry subclass: #'Kernel.PermanentRegistry'
	instanceVariableNames: 'freeHead'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.ObjectRegistry subclass: #'Kernel.WeakRegistry'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SearchPolicy subclass: #'Core.PluggableSearchPolicy'
	instanceVariableNames: 'compareBlock hashBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SearchPolicy subclass: #'Kernel.SingletonSearchPolicy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'current'
	classConstants: {}!
Kernel.SingletonSearchPolicy subclass: #'Kernel.AlwaysSearchPolicy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.SingletonSearchPolicy subclass: #'Kernel.CaseInsensitiveSearchPolicy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.SingletonSearchPolicy subclass: #'Kernel.EqualitySearchPolicy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.SingletonSearchPolicy subclass: #'Kernel.IdentitySearchPolicy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.SingletonSearchPolicy subclass: #'Kernel.NeverSearchPolicy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SessionManager subclass: #'Kernel.BootSessionManager'
	instanceVariableNames: 'productDetails startTime'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Signal subclass: #'Core.NotificationSignal'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.NotificationSignal subclass: #'Core.WarningSignal'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SortAlgorithm subclass: #'Kernel.DefaultSortAlgorithm'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SortAlgorithm subclass: #'Kernel.PluggableSortAlgorithm'
	instanceVariableNames: 'sortBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.PluggableSortAlgorithm subclass: #'Kernel.IntrosortAlgorithm'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.SourceFiler subclass: #'Kernel.ChunkSourceFiler'
	instanceVariableNames: 'sourceFileIndex'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'NormalizeEolsMask' -> 16r2
	}!
Kernel.StackFrame subclass: #'Kernel.BlockFrame'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBFiler subclass: #'Kernel.STBInFiler'
	instanceVariableNames: 'readMap converters classLocator deferredActions flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'UpgradingMask' -> 16r1
	}!
Kernel.STBFiler subclass: #'Kernel.STBOutFiler'
	instanceVariableNames: 'writeMap globals globalNils proxyOverrides refOffset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBInFiler subclass: #'Kernel.STBValidatingInFiler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBProxy subclass: #'Kernel.STBClassProxy'
	instanceVariableNames: 'packageName locatorKey'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBProxy subclass: #'Kernel.STBCollectionProxy'
	instanceVariableNames: 'class array'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBProxy subclass: #'Kernel.STBExternalResourceLibraryProxy'
	instanceVariableNames: 'fileName _reserved1'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBProxy subclass: #'Kernel.STBGlobalObjectProxy'
	instanceVariableNames: 'symbol object'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBProxy subclass: #'Kernel.STBSingletonProxy'
	instanceVariableNames: 'class selector'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBClassProxy subclass: #'Kernel.STBMetaclassProxy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBCollectionProxy subclass: #'Kernel.STBIdentityDictionaryProxy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBCollectionProxy subclass: #'Kernel.STBSortedCollectionProxy'
	instanceVariableNames: 'sortAlgorithm'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Stream subclass: #'Core.SequencedStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SequencedStream subclass: #'Core.LimitedWriteStream'
	instanceVariableNames: 'stream limit limitBlock start visited visitedBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SequencedStream subclass: #'Core.PositionableStream'
	instanceVariableNames: 'collection position readLimit locale'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SequencedStream subclass: #'OS.StdioFileStream'
	instanceVariableNames: 'stream flags name oldFd fd crtlib locale'
	classVariableNames: 'ClassForEncoding'
	imports: #(#{OS.CRTConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'DeviceMask' -> 16r40.
		'NonBlockingMask' -> 16r2.
		'ReadOnlyMask' -> 16r1
	}!
Core.PositionableStream subclass: #'Core.ReadStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.PositionableStream subclass: #'Core.WriteStream'
	instanceVariableNames: 'writeLimit'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.WriteStream subclass: #'Core.ReadWriteStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.ReadWriteStream subclass: #'Core.FileStream'
	instanceVariableNames: 'file flags pageBase logicalFileSize offset'
	classVariableNames: 'BufferClasses'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'BufferUpdatedMask' -> 16r3.
		'DirtyBufferMask' -> 16r2.
		'LimitsChangedMask' -> 16r1.
		'OwnsFileMask' -> 16r100.
		'PageSize' -> 16r2000
	}!
OS.StdioFileStream subclass: #'OS.StdioBinaryFileStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.StdioFileStream subclass: #'OS.StdioTextFileStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.StdioTextFileStream subclass: #'OS.StdioAnsiFileStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.StdioTextFileStream subclass: #'OS.StdioUnicodeFileStream'
	instanceVariableNames: 'offset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.StdioUnicodeFileStream subclass: #'OS.StdioUtf16FileStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.StdioUnicodeFileStream subclass: #'OS.StdioUtf8FileStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Structure subclass: #'OS._FPIEEE_RECORD'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cause' -> 16r4.
		'_OffsetOf_enable' -> 16r8.
		'_OffsetOf_flags' -> 16r0.
		'_OffsetOf_operand1' -> 16r10.
		'_OffsetOf_operand2' -> 16r28.
		'_OffsetOf_result' -> 16r40.
		'_OffsetOf_status' -> 16rC
	}!
External.Structure subclass: #'OS._FPIEEE_VALUE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_filler' -> 16r14.
		'_OffsetOf_flags' -> 16r10.
		'_OffsetOf_value' -> 16r0
	}!
External.Structure subclass: #'OS.CPINFOEXW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_codepage' -> 16r14.
		'_OffsetOf_CodePageName' -> 16r18.
		'_OffsetOf_DefaultChar' -> 16r4.
		'_OffsetOf_LeadByte' -> 16r6.
		'_OffsetOf_MaxCharSize' -> 16r0.
		'_OffsetOf_UnicodeDefaultChar' -> 16r12
	}!
External.Structure subclass: #'External.ExternalArray'
	instanceVariableNames: 'length'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Structure subclass: #'External.SCALAR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_value' -> 16r0
	}!
External.Structure subclass: #'External.StructurePointer'
	instanceVariableNames: 'elementClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Structure subclass: #'External.VOID'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Structure subclass: #'OS.Win32Structure'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Constants private})
	classInstanceVariableNames: ''
	classConstants: {}!
External.ExternalArray subclass: #'External.DOUBLEArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ExternalArray subclass: #'External.DWORDArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ExternalArray subclass: #'External.FLOATArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ExternalArray subclass: #'External.GenericExternalArray'
	instanceVariableNames: 'elementClass owner'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ExternalArray subclass: #'External.INT_PTRArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ExternalArray subclass: #'External.SBYTEArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ExternalArray subclass: #'External.SDWORDArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ExternalArray subclass: #'External.SWORDArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ExternalArray subclass: #'External.UINT_PTRArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ExternalArray subclass: #'External.WORDArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.GenericExternalArray subclass: #'External.StructureArray'
	instanceVariableNames: 'elementSpacing'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UINT_PTRArray subclass: #'External.HandleArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UINT_PTRArray subclass: #'External.PointerArray'
	instanceVariableNames: 'elementClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.SCALAR subclass: #'External.DOUBLE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.SCALAR subclass: #'External.FLOAT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.SCALAR subclass: #'External.INTEGER'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.SCALAR subclass: #'External.LPVOID'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.INTEGER subclass: #'External.BYTE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.INTEGER subclass: #'External.DWORD'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.INTEGER subclass: #'OS.HRESULT'
	instanceVariableNames: ''
	classVariableNames: 'Facilities Fail'
	imports: #(#{OS.Win32Constants} #{OS.Win32Errors} #{OS.FacilityCodes})
	classInstanceVariableNames: ''
	classConstants: {
		'FACILITY_NT_BIT' -> 16r10000000
	}!
External.INTEGER subclass: #'External.QWORD'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_highPart' -> 16r4.
		'_OffsetOf_lowPart' -> 16r0
	}!
External.INTEGER subclass: #'External.UINT_PTR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.INTEGER subclass: #'External.WORD'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.BYTE subclass: #'External.BOOLEAN'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.BYTE subclass: #'External.SBYTE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.DWORD subclass: #'External.SDWORD'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.SDWORD subclass: #'External.BOOL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.QWORD subclass: #'OS.LARGE_INTEGER'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.QWORD subclass: #'OS.ULARGE_INTEGER'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UINT_PTR subclass: #'External.INT_PTR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.WORD subclass: #'External.SWORD'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.LPVOID subclass: #'External.LPSTR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.LPVOID subclass: #'External.LPWSTR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.LPVOID subclass: #'External.Pointer'
	instanceVariableNames: 'byteSize'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Win32Structure subclass: #'OS.EXCEPTION_RECORD'
	instanceVariableNames: 'info'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_ExceptionAddress' -> 16rC.
		'_OffsetOf_ExceptionCode' -> 16r0.
		'_OffsetOf_ExceptionFlags' -> 16r4.
		'_OffsetOf_ExceptionInformation' -> 16r14.
		'_OffsetOf_ExceptionRecord' -> 16r8.
		'_OffsetOf_NumberParameters' -> 16r10
	}!
OS.Win32Structure subclass: #'OS.FILETIME'
	instanceVariableNames: ''
	classVariableNames: 'UnixEpoch'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwHighDateTime' -> 16r4.
		'_OffsetOf_dwLowDateTime' -> 16r0
	}!
OS.Win32Structure subclass: #'OS.MSG'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_hwnd' -> 16r0.
		'_OffsetOf_lParam' -> 16rC.
		'_OffsetOf_message' -> 16r4.
		'_OffsetOf_time' -> 16r10.
		'_OffsetOf_wParam' -> 16r8.
		'_OffsetOf_x' -> 16r14.
		'_OffsetOf_y' -> 16r18
	}!
OS.Win32Structure subclass: #'OS.MSGBOXPARAMSW'
	instanceVariableNames: 'text caption'
	classVariableNames: ''
	imports: #(#{OS.MessageBoxConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwContextHelpId' -> 16r1C.
		'_OffsetOf_dwLanguageId' -> 16r24.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_dwStyle' -> 16r14.
		'_OffsetOf_hInstance' -> 16r8.
		'_OffsetOf_hwndOwner' -> 16r4.
		'_OffsetOf_lpfnMsgBoxCallback' -> 16r20.
		'_OffsetOf_lpszCaption' -> 16r10.
		'_OffsetOf_lpszIcon' -> 16r18.
		'_OffsetOf_lpszText' -> 16rC
	}!
OS.Win32Structure subclass: #'OS.NUMBERFMTW'
	instanceVariableNames: 'decimalSeparator numberGrouping groupSeparator'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Grouping' -> 16r8.
		'_OffsetOf_LeadingZero' -> 16r4.
		'_OffsetOf_lpDecimalSep' -> 16rC.
		'_OffsetOf_lpThousandSep' -> 16r10.
		'_OffsetOf_NegativeOrder' -> 16r14.
		'_OffsetOf_NumDigits' -> 16r0
	}!
OS.Win32Structure subclass: #'OS.OSVERSIONINFOEXW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwBuildNumber' -> 16rC.
		'_OffsetOf_dwMajorVersion' -> 16r4.
		'_OffsetOf_dwMinorVersion' -> 16r8.
		'_OffsetOf_dwPlatformId' -> 16r10.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_szCSDVersion' -> 16r14.
		'_OffsetOf_wProductType' -> 16r11A.
		'_OffsetOf_wReserved' -> 16r11B.
		'_OffsetOf_wServicePackMajor' -> 16r114.
		'_OffsetOf_wServicePackMinor' -> 16r116.
		'_OffsetOf_wSuiteMask' -> 16r118
	}!
OS.Win32Structure subclass: #'OS.SECURITY_ATTRIBUTES'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_bInheritHandle' -> 16r8.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_lpSecurityDescriptor' -> 16r4
	}!
OS.Win32Structure subclass: #'OS.SYSTEMTIME'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_wDay' -> 16r6.
		'_OffsetOf_wDayOfWeek' -> 16r4.
		'_OffsetOf_wHour' -> 16r8.
		'_OffsetOf_wMilliseconds' -> 16rE.
		'_OffsetOf_wMinute' -> 16rA.
		'_OffsetOf_wMonth' -> 16r2.
		'_OffsetOf_wSecond' -> 16rC.
		'_OffsetOf_wYear' -> 16r0
	}!
OS.Win32Structure subclass: #'OS.TIME_ZONE_INFORMATION'
	instanceVariableNames: 'zoneId offset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_bias' -> 16r0.
		'_OffsetOf_daylightBias' -> 16rA8.
		'_OffsetOf_daylightDate' -> 16r98.
		'_OffsetOf_daylightName' -> 16r58.
		'_OffsetOf_standardBias' -> 16r54.
		'_OffsetOf_standardDate' -> 16r44.
		'_OffsetOf_standardName' -> 16r4.
		'TIME_ZONE_ID_DAYLIGHT' -> 16r2.
		'TIME_ZONE_ID_STANDARD' -> 16r1.
		'TIME_ZONE_ID_UNKNOWN' -> 16r0
	}!
OS.Win32Structure subclass: #'OS.VS_FIXEDFILEINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwFileDateLS' -> 16r30.
		'_OffsetOf_dwFileDateMS' -> 16r2C.
		'_OffsetOf_dwFileFlags' -> 16r1C.
		'_OffsetOf_dwFileFlagsMask' -> 16r18.
		'_OffsetOf_dwFileOS' -> 16r20.
		'_OffsetOf_dwFileSubtype' -> 16r28.
		'_OffsetOf_dwFileType' -> 16r24.
		'_OffsetOf_dwFileVersionLS' -> 16rC.
		'_OffsetOf_dwFileVersionMS' -> 16r8.
		'_OffsetOf_dwProductVersionLS' -> 16r14.
		'_OffsetOf_dwProductVersionMS' -> 16r10.
		'_OffsetOf_dwSignature' -> 16r0.
		'_OffsetOf_dwStrucVersion' -> 16r4
	}!
OS.Win32Structure subclass: #'OS.WIN32_FIND_DATAW'
	instanceVariableNames: 'directory'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cAlternateFileName' -> 16r234.
		'_OffsetOf_cFileName' -> 16r2C.
		'_OffsetOf_dwFileAttributes' -> 16r0.
		'_OffsetOf_dwReserved0' -> 16r24.
		'_OffsetOf_dwReserved1' -> 16r28.
		'_OffsetOf_ftCreationTime' -> 16r4.
		'_OffsetOf_ftLastAccessTime' -> 16rC.
		'_OffsetOf_ftLastWriteTime' -> 16r14.
		'_OffsetOf_nFileSizeHigh' -> 16r1C.
		'_OffsetOf_nFileSizeLow' -> 16r20
	}!
OS.FILETIME subclass: #'OS.LocalFILETIME'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

