"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #TVINSERTSTRUCT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TVINSERTSTRUCT guid: (GUID fromString: '{87B4C618-026E-11D3-9FD7-00A0CC3E4A32}')!
TVINSERTSTRUCT comment: ''!
!TVINSERTSTRUCT categoriesForClass!External-Data-Structured-Win32! !
!TVINSERTSTRUCT methodsFor!

hInsertAfter: anObject 
	"Set the receiver's hInsertAfter field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #hInsertAfter) put: anObject!

hParent: anObject 
	"Set the receiver's hParent field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

item
	"Answer the receiver's item field as a Smalltalk object."

	^TVITEM fromAddress: bytes yourAddress + ##(self offsetOf: #item)!

item: anObject 
	"Set the receiver's item field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #item) + 1)
		to: ##((self offsetOf: #item) + TVITEM basicByteSize)
		startingAt: 1! !
!TVINSERTSTRUCT categoriesFor: #hInsertAfter:!**compiled accessors**!public! !
!TVINSERTSTRUCT categoriesFor: #hParent:!**compiled accessors**!public! !
!TVINSERTSTRUCT categoriesFor: #item!**compiled accessors**!public! !
!TVINSERTSTRUCT categoriesFor: #item:!**compiled accessors**!public! !

!TVINSERTSTRUCT class methodsFor!

defineFields
	"Define the layout of the Win32 TVINSERTSTRUCT structure.
		TVINSERTSTRUCT compileDefinition
	"

	self 
		defineField: #hParent type: DWORDField writeOnly;
		defineField: #hInsertAfter type: DWORDField writeOnly;
		defineField: #item type: (StructureField type: TVITEM) "read/write so can get pointer to embedded TV_ITEM"
	! !
!TVINSERTSTRUCT class categoriesFor: #defineFields!initializing!public! !

