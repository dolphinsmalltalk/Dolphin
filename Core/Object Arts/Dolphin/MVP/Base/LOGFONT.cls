"Filed out from Dolphin Smalltalk 7"!

AbstractLOGFONT subclass: #LOGFONT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LOGFONT guid: (GUID fromString: '{87b4c5f9-026e-11d3-9fd7-00a0cc3e4a32}')!
LOGFONT comment: '<LOGFONT> is an <ExternalStructure> class to wrap the Win32 structure of the same name.

LOGFONT contains information that describes a logical font, such as the face name and point size. See the Win32 documentation for further details.'!
!LOGFONT categoriesForClass!DxVBLibA-Structs! !
!LOGFONT methodsFor!

createFont
	^GDILibrary default createFontIndirectA: self!

faceName: aString
	"Set the receiver's lfFaceName field."
	
	self lfFaceName: aString asAnsiString!

lfFaceName
	"Answer the receiver's lfFaceName field as a Smalltalk object."

	^String fromAddress: bytes yourAddress + ##(self offsetOf: #lfFaceName)!

lfFaceName: anObject 
	"Set the receiver's lfFaceName field to the value of anObject."

	| size |
	size := anObject byteSize - 1 min: 31.
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #lfFaceName) + 1)
		to: ##(self offsetOf: #lfFaceName) + size
		startingAt: 1.
	bytes byteAtOffset: ##(self offsetOf: #lfFaceName) + size put: 0! !
!LOGFONT categoriesFor: #createFont!private!realizing/unrealizing! !
!LOGFONT categoriesFor: #faceName:!accessing!public! !
!LOGFONT categoriesFor: #lfFaceName!**compiled accessors**!public! !
!LOGFONT categoriesFor: #lfFaceName:!**compiled accessors**!public! !

!LOGFONT class methodsFor!

defineFields
	"Define the Win32 LOGFONT structure.
		LOGFONT compileDefinition.
	"

	super defineFields.
	self defineField: #lfFaceName type: (StringField length: LF_FACESIZE)! !
!LOGFONT class categoriesFor: #defineFields!initializing!public! !

