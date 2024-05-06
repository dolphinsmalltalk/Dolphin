"Filed out from Dolphin Smalltalk"!

AbstractLOGFONT subclass: #LOGFONT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_lfFaceName'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

LOGFONT guid: (GUID fromString: '{87b4c5f9-026e-11d3-9fd7-00a0cc3e4a32}')!

LOGFONT addClassConstant: '_OffsetOf_lfFaceName' value: 16r1C!

LOGFONT comment: '<LOGFONT> is an <ExternalStructure> class to wrap the Win32 structure LOGFONTA. 

LOGFONT has been replaced by LOGFONTW, but is retained due to references from pre-existing view resources (which contain Font instances that reference LOGFONT instances). It will be deprecated in a future release.'!

!LOGFONT categoriesForClass!DxVBLibA-Structs! !

!LOGFONT methodsFor!

createFont
	^GDILibrary default createFontIndirectA: self!

faceName
	"Answer the receiver's lfFaceName ANSI string field, having trimmed any extra nulls."
	
	^self lfFaceName trimNulls!

faceName: aString
	"Set the receiver's lfFaceName field."
	
	self lfFaceName: aString asAnsiString!

getData: hFont
	GDILibrary default
		getObject: hFont
		cbBuffer: self byteSize
		lpvObject: self!

lfFaceName
	"Answer the <AnsiString> value of the receiver's 'lfFaceName' field."

	^AnsiString fromAddress: bytes yourAddress + _OffsetOf_lfFaceName!

lfFaceName: anAnsiString
	"Set the receiver's 'lfFaceName' field to the value of the argument, anAnsiString"

	| size |
	size := anAnsiString byteSize - 1 min: 31.
	anAnsiString
		replaceBytesOf: bytes
		from: ##(_OffsetOf_lfFaceName + 1)
		to: _OffsetOf_lfFaceName + size
		startingAt: 1.
	bytes byteAtOffset: _OffsetOf_lfFaceName + size put: 0! !

!LOGFONT categoriesForMethods!
createFont!private!realizing/unrealizing! !
faceName!accessing!public! !
faceName:!accessing!public! !
getData:!helpers!private! !
lfFaceName!**compiled accessors**!public! !
lfFaceName:!**compiled accessors**!public! !
!

!LOGFONT class methodsFor!

defineFields
	"Define the Win32 LOGFONT structure.
		LOGFONT compileDefinition.
	"

	super defineFields.
	self defineField: #lfFaceName type: (StringField type: AnsiString length: LF_FACESIZE)! !

!LOGFONT class categoriesForMethods!
defineFields!public!template definition! !
!

