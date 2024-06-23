"Filed out from Dolphin Smalltalk"!

Object subclass: #LOGFONT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_lfFaceName'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

LOGFONT guid: (GUID fromString: '{87b4c5f9-026e-11d3-9fd7-00a0cc3e4a32}')!

LOGFONT addClassConstant: '_OffsetOf_lfFaceName' value: 16r1C!
LOGFONT comment: '`LOGFONT` was an `External.Structure` class to wrap the Win32 structure LOGFONTA.

LOGFONT was effectively replaced by LOGFONTW in Dolphin 7.1, but not deprecated. It is deprecated in Dolphin 8, but remains as a stub to load and upgrade pre-existing view resources, which may contain Font instances that still reference LOGFONT instances. When these old resources are loaded, the LOGFONTA instances are replaced by equivalent LOGFONTW instances.'!

!LOGFONT categoriesForClass!Deprecated! !

!LOGFONT class methodsFor!

stbReadFrom: anSTBInFiler format: anSTBClassConversion size: anInteger
	"Replace the LOGFONT in the serialised data with an equivalent LOGFONTW"

	| logfontw lfbytes |
	logfontw := LOGFONTW new.
	anSTBInFiler register: logfontw.
	lfbytes := anSTBInFiler basicNext.
	logfontw bytes
		replaceFrom: 1
		to: LOGFONTW._OffsetOf_lfFaceName - 1
		with: lfbytes
		startingAt: 1.
	logfontw faceName: (AnsiString fromAddress: lfbytes yourAddress + _OffsetOf_lfFaceName).
	^logfontw! !

!LOGFONT class categoriesForMethods!
stbReadFrom:format:size:!public! !
!

