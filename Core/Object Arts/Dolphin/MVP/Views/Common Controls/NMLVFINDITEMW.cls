"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMLVFINDITEMW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLVFINDITEMW guid: (GUID fromString: '{87b4c626-026e-11d3-9fd7-00a0cc3e4a32}')!
NMLVFINDITEMW comment: ''!
!NMLVFINDITEMW categoriesForClass!External-Data-Structured-Win32! !
!NMLVFINDITEMW methodsFor!

iStart
	"Answer the <Integer> value of the receiver's 'iStart' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iStart)!

lvfi
	"Answer the <LVFINDINFO> value of the receiver's 'lvfi' field."

	^LVFINDINFOW fromAddress: bytes yourAddress + ##(self offsetOf: #lvfi)! !
!NMLVFINDITEMW categoriesFor: #iStart!**compiled accessors**!public! !
!NMLVFINDITEMW categoriesFor: #lvfi!**compiled accessors**!public! !

!NMLVFINDITEMW class methodsFor!

defineFields
	"Define the fields of the Win32 NMLVFINDITEM structure.
		NMLVFINDITEM compileDefinition
	"

	super defineFields.
	self
		defineField: #iStart type: SDWORDField readOnly;
		defineField: #lvfi type: (StructureField type: LVFINDINFOW) beReadOnly! !
!NMLVFINDITEMW class categoriesFor: #defineFields!initializing!public! !

