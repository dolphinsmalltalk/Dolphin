"Filed out from Dolphin Smalltalk"!

External.WindowsSystemLibrary
	subclass: #'OS.CommCtrlLibrary'
	instanceVariableNames: ''
	classVariableNames: 'InitFlags'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'CCM_FIRST' -> 16r2000.
			'CCM_GETCOLORSCHEME' -> 16r2003.
			'CCM_GETUNICODEFORMAT' -> 16r2006.
			'CCM_GETVERSION' -> 16r2008.
			'CCM_SETBKCOLOR' -> 16r2001.
			'CCM_SETCOLORSCHEME' -> 16r2002.
			'CCM_SETUNICODEFORMAT' -> 16r2005.
			'CCM_SETVERSION' -> 16r2007.
			'CCM_SETWINDOWTHEME' -> 16r200B.
			'CCS_ADJUSTABLE' -> 16r20.
			'CCS_BOTTOM' -> 16r3.
			'CCS_LEFT' -> 16r81.
			'CCS_NODIVIDER' -> 16r40.
			'CCS_NOMOVEY' -> 16r2.
			'CCS_NOPARENTALIGN' -> 16r8.
			'CCS_NORESIZE' -> 16r4.
			'CCS_RIGHT' -> 16r83.
			'CCS_TOP' -> 16r1.
			'CCS_VERT' -> 16r80.
			'HINST_COMMCTRL' -> -16r1.
			'ICC_BAR_CLASSES' -> 16r4.
			'ICC_STANDARD_CLASSES' -> 16r4000.
			'INFOTIPSIZE' -> 16r400.
			'LPSTR_TEXTCALLBACK' -> -16r1.
			'NM_CHAR' -> -16r12.
			'NM_CLICK' -> -16r2.
			'NM_CUSTOMDRAW' -> -16rC.
			'NM_CUSTOMTEXT' -> -16r18.
			'NM_DBLCLK' -> -16r3.
			'NM_FIRST' -> 16r0.
			'NM_FONTCHANGED' -> -16r17.
			'NM_HOVER' -> -16rD.
			'NM_KEYDOWN' -> -16rF.
			'NM_KILLFOCUS' -> -16r8.
			'NM_LDOWN' -> -16r14.
			'NM_NCHITTEST' -> -16rE.
			'NM_OUTOFMEMORY' -> -16r1.
			'NM_RCLICK' -> -16r5.
			'NM_RDBLCLK' -> -16r6.
			'NM_RDOWN' -> -16r15.
			'NM_RELEASEDCAPTURE' -> -16r10.
			'NM_RETURN' -> -16r4.
			'NM_SETCURSOR' -> -16r11.
			'NM_SETFOCUS' -> -16r7.
			'NM_THEMECHANGED' -> -16r16.
			'NM_TOOLTIPSCREATED' -> -16r13.
			'TTN_GETDISPINFOA' -> -16r208.
			'TTN_GETDISPINFOW' -> -16r212
		}!

OS.CommCtrlLibrary guid: (Core.GUID fromString: '{64674056-3a82-101b-8181-00aa003743d3}')!

OS.CommCtrlLibrary comment: 'CommCtrlLibrary is an <ExternalLibrary> to represent the Windows Common Controls Library, COMCTL32.DLL. This library implements the "newer" (post-Windows 95) controls such as the ListView and TreeView, with recent additions (known collectively as the IE4 controls) such as the DateTimePicker. A notable exception is the RichEdit control, which is implemented in its own library.

Dolphin requires at least version 4.70 of this library (previous versions were supported by some older versions of Dolphin, but you must now upgrade to the latest DLL, which is available as a free download from Microsoft).'!

!OS.CommCtrlLibrary categoriesForClass!External-Libraries-Win32! !

!OS.CommCtrlLibrary methodsFor!

initCommonControlsEx: anINITCOMMONCONTROLSEX
	"Initialize the receiver as specified by the init struct argument."

	<stdcall: bool InitCommonControlsEx void*>
	^self invalidCall: _failureCode!

initialize
	"Private - Initialize and answer the receiver."

	| struct |
	struct := ByteArray new: 8.
	struct
		uint32AtOffset: 0 put: 8;
		uint32AtOffset: 4 put: self class initFlags.
	self initCommonControlsEx: struct! !

!OS.CommCtrlLibrary categoriesForMethods!
initCommonControlsEx:!initializing!primitives!public! !
initialize!initializing!private! !
!

!OS.CommCtrlLibrary class methodsFor!

addInitFlag: anInteger
	self initFlags: (self initFlags maskSet: anInteger)!

closeDefault
	"Private - Close the default instance of the receiver (if there is one)."

	"Implementation Note: As a temporary bodge, don't actually unload the library when discarding the default instance because to do so causes problems with the ImageStripperProgress dialog (which uses one of the common control classes). My guess is that unloading the library unregisters the common control window classes, which for some reason causes a subsequent GPF in the progress bar."

	default := nil!

fileName
	"Answer the host system file name for the library."

	^'comctl32'!

initFlags
	^InitFlags ifNil: [InitFlags := 0]!

initFlags: anInteger
	InitFlags = anInteger ifTrue: [^self].
	InitFlags := anInteger.
	(default notNil and: [default isOpen]) ifTrue: [default initialize]!

removeInitFlag: anInteger
	self initFlags: (self initFlags maskClear: anInteger)! !

!OS.CommCtrlLibrary class categoriesForMethods!
addInitFlag:!development!initializing!public! !
closeDefault!private!realizing/unrealizing! !
fileName!constants!public! !
initFlags!accessing!public! !
initFlags:!accessing!not an aspect!public! !
removeInitFlag:!public!uninitializing! !
!

