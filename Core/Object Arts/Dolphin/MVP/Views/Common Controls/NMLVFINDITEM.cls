"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMLVFINDITEM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLVFINDITEM guid: (GUID fromString: '{87b4c626-026e-11d3-9fd7-00a0cc3e4a32}')!
NMLVFINDITEM comment: ''!
!NMLVFINDITEM categoriesForClass!External-Data-Structured-Win32! !
!NMLVFINDITEM methodsFor!

iStart
	"Answer the receiver's iStart field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iStart)!

lvfi
	"Answer the receiver's lvfi field as a Smalltalk object."

	^LVFINDINFO fromAddress: bytes yourAddress + ##(self offsetOf: #lvfi)! !
!NMLVFINDITEM categoriesFor: #iStart!**compiled accessors**!public! !
!NMLVFINDITEM categoriesFor: #lvfi!**compiled accessors**!public! !

!NMLVFINDITEM class methodsFor!

defineFields
	"Define the fields of the Win32 NMLVFINDITEM structure.
		NMLVFINDITEM compileDefinition
	"

	super defineFields.
	self
		defineField: #iStart type: SDWORDField readOnly;
		defineField: #lvfi type: (StructureField type: LVFINDINFO) beReadOnly! !
!NMLVFINDITEM class categoriesFor: #defineFields!initializing!public! !

