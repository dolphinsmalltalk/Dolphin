"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TVINSERTSTRUCTW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TVINSERTSTRUCTW guid: (GUID fromString: '{87b4c618-026e-11d3-9fd7-00a0cc3e4a32}')!
TVINSERTSTRUCTW comment: ''!
!TVINSERTSTRUCTW categoriesForClass!External-Data-Structured-Win32! !
!TVINSERTSTRUCTW methodsFor!

hInsertAfter: anInteger
	"Set the receiver's 'hInsertAfter' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #hInsertAfter) put: anInteger!

hParent: anInteger
	"Set the receiver's 'hParent' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

item
	"Answer the <TVITEMEXW> value of the receiver's 'item' field."

	^TVITEMEXW fromAddress: bytes yourAddress + ##(self offsetOf: #item)!

item: aTVITEMEXW
	"Set the receiver's 'item' field to the value of the argument, aTVITEMEXW"

	aTVITEMEXW
		replaceBytesOf: bytes
		from: ##((self offsetOf: #item) + 1)
		to: ##((self offsetOf: #item) + TVITEMEXW basicByteSize)
		startingAt: 1! !
!TVINSERTSTRUCTW categoriesFor: #hInsertAfter:!**compiled accessors**!public! !
!TVINSERTSTRUCTW categoriesFor: #hParent:!**compiled accessors**!public! !
!TVINSERTSTRUCTW categoriesFor: #item!**compiled accessors**!public! !
!TVINSERTSTRUCTW categoriesFor: #item:!**compiled accessors**!public! !

!TVINSERTSTRUCTW class methodsFor!

defineFields
	"Define the layout of the Win32 TVINSERTSTRUCT structure.
		TVINSERTSTRUCT compileDefinition
	"

	self
		defineField: #hParent type: DWORDField writeOnly offset: 0;
		defineField: #hInsertAfter type: DWORDField writeOnly offset: 4;
		defineField: #item type: (StructureField type: TVITEMEXW) offset: 8 "read/write so can get pointer to embedded TVITEM"! !
!TVINSERTSTRUCTW class categoriesFor: #defineFields!initializing!public! !

