"Filed out from Dolphin Smalltalk X6.1"!

NMHDR subclass: #NMTVDISPINFO
	instanceVariableNames: 'item'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMTVDISPINFO guid: (GUID fromString: '{87B4C62B-026E-11D3-9FD7-00A0CC3E4A32}')!
NMTVDISPINFO comment: ''!
!NMTVDISPINFO categoriesForClass!External-Data-Structured-Win32! !
!NMTVDISPINFO methodsFor!

item
	"Answer the receiver's item member"

	item isNil ifTrue: [item := self tvItem] .
	^item!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self item hItem!

tvItem
	"Answer the receiver's tvItem field as a Smalltalk object."

	^TVITEM fromAddress: bytes yourAddress + ##(self offsetOf: #tvItem)! !
!NMTVDISPINFO categoriesFor: #item!accessing!public! !
!NMTVDISPINFO categoriesFor: #itemHandle!accessing!public! !
!NMTVDISPINFO categoriesFor: #tvItem!**compiled accessors**!public! !

!NMTVDISPINFO class methodsFor!

defineFields
	"Define the fields of the Win32 NMTVDISPINFO structure.
		NMTVDISPINFO compileDefinition
	"

	super defineFields.
	self defineField: #tvItem type: (StructureField type: TVITEM) beReadOnly! !
!NMTVDISPINFO class categoriesFor: #defineFields!initializing!public! !

