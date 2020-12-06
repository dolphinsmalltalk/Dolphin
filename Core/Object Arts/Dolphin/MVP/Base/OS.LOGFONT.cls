"Filed out from Dolphin Smalltalk 7"!

OS.AbstractLOGFONT subclass: #'OS.LOGFONT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_lfFaceName' -> 16r1C
	}!
OS.LOGFONT guid: (Core.GUID fromString: '{87b4c5f9-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.LOGFONT comment: '<LOGFONT> is an <ExternalStructure> class to wrap the Win32 structure LOGFONTA. 

LOGFONT has been replaced by LOGFONTW, but is retained due to references from pre-existing view resources (which contain Font instances that reference LOGFONT instances). It will be deprecated in a future release.'!
!OS.LOGFONT categoriesForClass!DxVBLibA-Structs! !
!OS.LOGFONT methodsFor!

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
!OS.LOGFONT categoriesFor: #createFont!private!realizing/unrealizing! !
!OS.LOGFONT categoriesFor: #faceName!accessing!public! !
!OS.LOGFONT categoriesFor: #faceName:!accessing!public! !
!OS.LOGFONT categoriesFor: #getData:!helpers!private! !
!OS.LOGFONT categoriesFor: #lfFaceName!**compiled accessors**!public! !
!OS.LOGFONT categoriesFor: #lfFaceName:!**compiled accessors**!public! !

!OS.LOGFONT class methodsFor!

defineFields
	"Define the Win32 LOGFONT structure.
		LOGFONT compileDefinition.
	"

	super defineFields.
	self defineField: #lfFaceName type: (StringField type: AnsiString length: LF_FACESIZE)! !
!OS.LOGFONT class categoriesFor: #defineFields!public!template definition! !

