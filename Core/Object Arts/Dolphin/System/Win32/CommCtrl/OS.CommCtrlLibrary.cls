"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary
	subclass: #'OS.CommCtrlLibrary'
	instanceVariableNames: ''
	classVariableNames: 'InitFlags'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

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

	^'COMCTL32'!

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

