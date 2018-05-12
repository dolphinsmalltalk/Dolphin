"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #FORMATRANGE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FORMATRANGE guid: (GUID fromString: '{9bdca5bb-f238-4744-a903-f02b32617822}')!
FORMATRANGE comment: 'FORMATRANGE is an <ExternalStructure> class to represent the Win32 structure of the same name.

FORMATRANGE is used in conjunction with the Rich Edit control''s EM_FORMATRANGE message. See the Win32 SDK documentation for further information.'!
!FORMATRANGE categoriesForClass!Unclassified! !
!FORMATRANGE methodsFor!

cpMax: anObject 
	"Set the receiver's cpMax field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #cpMax) put: anObject!

cpMin: anObject 
	"Set the receiver's cpMin field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #cpMin) put: anObject!

hdc: anObject 
	"Set the receiver's hdc field to the value of anObject."

	bytes uintPtrAtOffset: 0 put: anObject!

hdcTarget: anObject 
	"Set the receiver's hdcTarget field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hdcTarget) put: anObject!

rc
	"Answer the receiver's rc field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rc)!

rc: anObject 
	"Set the receiver's rc field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rc) + 1)
		to: ##((self offsetOf: #rc) + RECT basicByteSize)
		startingAt: 1!

rcPage
	"Answer the receiver's rcPage field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rcPage)!

rcPage: anObject 
	"Set the receiver's rcPage field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rcPage) + 1)
		to: ##((self offsetOf: #rcPage) + RECT basicByteSize)
		startingAt: 1! !
!FORMATRANGE categoriesFor: #cpMax:!**compiled accessors**!public! !
!FORMATRANGE categoriesFor: #cpMin:!**compiled accessors**!public! !
!FORMATRANGE categoriesFor: #hdc:!**compiled accessors**!public! !
!FORMATRANGE categoriesFor: #hdcTarget:!**compiled accessors**!public! !
!FORMATRANGE categoriesFor: #rc!**compiled accessors**!public! !
!FORMATRANGE categoriesFor: #rc:!**compiled accessors**!public! !
!FORMATRANGE categoriesFor: #rcPage!**compiled accessors**!public! !
!FORMATRANGE categoriesFor: #rcPage:!**compiled accessors**!public! !

!FORMATRANGE class methodsFor!

defineFields
	"Define the fields of the Win32 FORMATRANGE structure.

		FORMATRANGE compileDefinition
	"

	self
		defineField: #hdc type: HANDLEField writeOnly;
		defineField: #hdcTarget type: HANDLEField writeOnly;
		defineField: #rc type: (StructureField type: RECT);
		defineField: #rcPage type: (StructureField type: RECT);

		"Expand CHARRANGE inline"
		defineField: #cpMin type: SDWORDField writeOnly;
		defineField: #cpMax type: SDWORDField writeOnly
! !
!FORMATRANGE class categoriesFor: #defineFields!initializing!public! !

