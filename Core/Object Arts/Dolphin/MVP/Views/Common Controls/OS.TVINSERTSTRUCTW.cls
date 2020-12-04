"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.TVINSERTSTRUCTW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_hInsertAfter' -> 16r4.
		'_OffsetOf_hParent' -> 16r0.
		'_OffsetOf_item' -> 16r8
	}!
OS.TVINSERTSTRUCTW guid: (Core.GUID fromString: '{87b4c618-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.TVINSERTSTRUCTW comment: ''!
!OS.TVINSERTSTRUCTW categoriesForClass!External-Data-Structured-Win32! !
!OS.TVINSERTSTRUCTW methodsFor!

hInsertAfter: anInteger
	"Set the receiver's 'hInsertAfter' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_hInsertAfter put: anInteger!

hParent: anInteger
	"Set the receiver's 'hParent' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_hParent put: anInteger!

item
	"Answer the <TVITEMEXW> value of the receiver's 'item' field."

	^TVITEMEXW fromAddress: bytes yourAddress + _OffsetOf_item!

item: aTVITEMEXW
	"Set the receiver's 'item' field to the value of the argument, aTVITEMEXW"

	aTVITEMEXW
		replaceBytesOf: bytes
		from: ##(_OffsetOf_item + 1)
		to: ##(_OffsetOf_item + TVITEMEXW basicByteSize)
		startingAt: 1! !
!OS.TVINSERTSTRUCTW categoriesFor: #hInsertAfter:!**compiled accessors**!public! !
!OS.TVINSERTSTRUCTW categoriesFor: #hParent:!**compiled accessors**!public! !
!OS.TVINSERTSTRUCTW categoriesFor: #item!**compiled accessors**!public! !
!OS.TVINSERTSTRUCTW categoriesFor: #item:!**compiled accessors**!public! !

!OS.TVINSERTSTRUCTW class methodsFor!

defineFields
	"Define the layout of the Win32 TVINSERTSTRUCT structure.
		self compileDefinition
	"

	self
		defineField: #hParent
			type: DWORDField writeOnly
			offset: 0;
		defineField: #hInsertAfter
			type: DWORDField writeOnly
			offset: 4;
		defineField: #item
			type: (StructureField type: TVITEMEXW)
			offset: 8	"read/write so can get pointer to embedded TVITEM"!

getFieldNames
	^#(#hParent #hInsertAfter #item)! !
!OS.TVINSERTSTRUCTW class categoriesFor: #defineFields!public!template definition! !
!OS.TVINSERTSTRUCTW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

