"Filed out from Dolphin Smalltalk X6.1"!

AbstractLOGFONT subclass: #LOGFONT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LOGFONT guid: (GUID fromString: '{87B4C5F9-026E-11D3-9FD7-00A0CC3E4A32}')!
LOGFONT comment: '<LOGFONT> is an <ExternalStructure> class to wrap the Win32 structure of the same name.

LOGFONT contains information that describes a logical font, such as the face name and point size. See the Win32 documentation for further details.'!
!LOGFONT categoriesForClass!DxVBLibA-Structs! !
!LOGFONT methodsFor!

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

