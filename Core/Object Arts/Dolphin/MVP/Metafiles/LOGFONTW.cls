"Filed out from Dolphin Smalltalk 7"!

AbstractLOGFONT subclass: #LOGFONTW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LOGFONTW guid: (GUID fromString: '{37140088-772d-4f72-aac2-27311f7805d8}')!
LOGFONTW comment: ''!
!LOGFONTW categoriesForClass!Win32-Structs! !
!LOGFONTW methodsFor!

lfFaceName
	"Answer the receiver's lfFaceName field as a Smalltalk object."

	^UnicodeString fromAddress: bytes yourAddress + ##(self offsetOf: #lfFaceName)!

lfFaceName: anObject 
	"Set the receiver's lfFaceName field to the value of anObject."

	| size |
	size := anObject byteSize - 2 min: ##(31 * 2).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #lfFaceName) + 1)
		to: ##(self offsetOf: #lfFaceName) + size
		startingAt: 1.
	bytes wordAtOffset: ##(self offsetOf: #lfFaceName) + size put: 0! !
!LOGFONTW categoriesFor: #lfFaceName!**compiled accessors**!public! !
!LOGFONTW categoriesFor: #lfFaceName:!**compiled accessors**!public! !

!LOGFONTW class methodsFor!

defineFields
	"Define the Win32 LOGFONTW structure.
		LOGFONTW compileDefinition.
	"

	super defineFields.
	self defineField: #lfFaceName type: (StringField type: UnicodeString length: LF_FACESIZE)! !
!LOGFONTW class categoriesFor: #defineFields!initializing!public! !

