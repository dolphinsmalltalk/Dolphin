"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #LHITTESTINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LHITTESTINFO guid: (GUID fromString: '{1498D0D0-6502-4CE2-8CF9-CAA0625685EF}')!
LHITTESTINFO comment: ''!
!LHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !
!LHITTESTINFO methodsFor!

item
	"Answer the receiver's item field as a Smalltalk object."

	^LITEM fromAddress: bytes yourAddress + ##(self offsetOf: #item)!

pt
	"Answer the receiver's pt field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress!

pt: anObject 
	"Set the receiver's pt field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: 1
		to: ##(POINTL basicByteSize)
		startingAt: 1! !
!LHITTESTINFO categoriesFor: #item!**compiled accessors**!public! !
!LHITTESTINFO categoriesFor: #pt!**compiled accessors**!public! !
!LHITTESTINFO categoriesFor: #pt:!**compiled accessors**!public! !

!LHITTESTINFO class methodsFor!

defineFields
	"Define the fields of the Win32 LITEM structure

		LHITTESTINFO compileDefinition
	"

	self
		defineField: #pt type: (StructureField type:  POINTL);
		defineField: #item type: (StructureField type: LITEM) beReadOnly! !
!LHITTESTINFO class categoriesFor: #defineFields!initializing!public! !

