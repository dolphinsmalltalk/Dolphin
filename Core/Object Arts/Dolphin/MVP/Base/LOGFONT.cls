"Filed out from Dolphin Smalltalk"!

Object subclass: #LOGFONT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_lfFaceName'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

LOGFONT guid: (GUID fromString: '{87b4c5f9-026e-11d3-9fd7-00a0cc3e4a32}')!

LOGFONT addClassConstant: '_OffsetOf_lfFaceName' value: 16r1C!

LOGFONT comment: '<LOGFONT> is an <ExternalStructure> class to wrap the Win32 structure LOGFONTA. 

LOGFONT has been replaced by LOGFONTW, but is retained due to references from pre-existing view resources (which contain Font instances that reference LOGFONT instances). It will be deprecated in a future release.'!

!LOGFONT categoriesForClass!Deprecated! !

!LOGFONT class methodsFor!

stbReadFrom: anSTBInFiler format: anSTBClassConversion
	"Replace the LOGFONT in the serialised data with an equivalent LOGFONTW"

	| logfontw lfbytes |
	anSTBInFiler readIndexableSizeFor: self.
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
stbReadFrom:format:!public! !
!

