"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TVINSERTSTRUCT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TVINSERTSTRUCT guid: (GUID fromString: '{87b4c618-026e-11d3-9fd7-00a0cc3e4a32}')!
TVINSERTSTRUCT comment: ''!
!TVINSERTSTRUCT categoriesForClass!External-Data-Structured-Win32! !
!TVINSERTSTRUCT methodsFor!

hInsertAfter: anInteger
	"Set the receiver's 'hInsertAfter' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #hInsertAfter) put: anInteger!

hParent: anInteger
	"Set the receiver's 'hParent' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

item
	"Answer the <TVITEMEX> value of the receiver's 'item' field."

	^TVITEMEX fromAddress: bytes yourAddress + ##(self offsetOf: #item)!

item: aTVITEMEX
	"Set the receiver's 'item' field to the value of the argument, aTVITEMEX"

	aTVITEMEX
		replaceBytesOf: bytes
		from: ##((self offsetOf: #item) + 1)
		to: ##((self offsetOf: #item) + TVITEMEX basicByteSize)
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
		defineField: #item type: (StructureField type: TVITEMEX)	"read/write so can get pointer to embedded TVITEM"! !
!TVINSERTSTRUCT class categoriesFor: #defineFields!initializing!public! !

