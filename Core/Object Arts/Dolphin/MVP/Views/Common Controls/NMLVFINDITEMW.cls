"Filed out from Dolphin Smalltalk"!

NMHDR subclass: #NMLVFINDITEMW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_iStart _OffsetOf_lvfi'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLVFINDITEMW guid: (GUID fromString: '{87b4c626-026e-11d3-9fd7-00a0cc3e4a32}')!
NMLVFINDITEMW addClassConstant: '_OffsetOf_iStart' value: 16rC!
NMLVFINDITEMW addClassConstant: '_OffsetOf_lvfi' value: 16r10!
NMLVFINDITEMW comment: ''!
!NMLVFINDITEMW categoriesForClass!External-Data-Structured-Win32! !
!NMLVFINDITEMW methodsFor!

iStart
	"Answer the <Integer> value of the receiver's 'iStart' field."

	^bytes sdwordAtOffset: _OffsetOf_iStart!

lvfi
	"Answer the <LVFINDINFOW> value of the receiver's 'lvfi' field."

	^LVFINDINFOW fromAddress: bytes yourAddress + _OffsetOf_lvfi! !
!NMLVFINDITEMW categoriesForMethods!
iStart!**compiled accessors**!public! !
lvfi!**compiled accessors**!public! !
!

!NMLVFINDITEMW class methodsFor!

defineFields
	"Define the fields of the Win32 NMLVFINDITEM structure.
		self compileDefinition
	"

	super defineFields.
	self
		defineField: #iStart type: SDWORDField readOnly;
		defineField: #lvfi type: (StructureField type: LVFINDINFOW) beReadOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #iStart #lvfi)! !
!NMLVFINDITEMW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

