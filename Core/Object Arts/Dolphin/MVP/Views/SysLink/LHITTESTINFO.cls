"Filed out from Dolphin Smalltalk"!

CCHITTESTINFO subclass: #LHITTESTINFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_item'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

LHITTESTINFO guid: (GUID fromString: '{1498d0d0-6502-4ce2-8cf9-caa0625685ef}')!

LHITTESTINFO addClassConstant: '_OffsetOf_item' value: 16r8!

LHITTESTINFO comment: ''!

!LHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !

!LHITTESTINFO methodsFor!

handle
	"Private - Answer the item 'handle' associated with the receiver."

	^(bytes sdwordAtOffset: ##(_OffsetOf_item + LITEM._OffsetOf_iLink)) + 1!

item
	"Answer the <LITEM> value of the receiver's 'item' field."

	^LITEM fromAddress: bytes yourAddress + _OffsetOf_item! !

!LHITTESTINFO categoriesForMethods!
handle!accessing!private! !
item!**compiled accessors**!public! !
!

!LHITTESTINFO class methodsFor!

defineFields
	"Define the fields of the Win32 LITEM structure

		LHITTESTINFO compileDefinition
	"

	super defineFields.
	self defineField: #item type: (StructureField type: LITEM) beReadOnly!

getFieldNames
	^#(#pt #item)! !

!LHITTESTINFO class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

