"Filed out from Dolphin Smalltalk X6.1"!

NMHDR subclass: #NMLVDISPINFO
	instanceVariableNames: 'item'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLVDISPINFO guid: (GUID fromString: '{87B4C625-026E-11D3-9FD7-00A0CC3E4A32}')!
NMLVDISPINFO comment: ''!
!NMLVDISPINFO categoriesForClass!External-Data-Structured-Win32! !
!NMLVDISPINFO methodsFor!

item
	"Answer the receiver's item member"

	item isNil ifTrue: [item := self lvItem].
	^item!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self item iItem + 1!

lvItem
	"Answer the receiver's lvItem field as a Smalltalk object."

	^LVITEM fromAddress: bytes yourAddress + ##(self offsetOf: #lvItem)! !
!NMLVDISPINFO categoriesFor: #item!accessing!public! !
!NMLVDISPINFO categoriesFor: #itemHandle!accessing!public! !
!NMLVDISPINFO categoriesFor: #lvItem!**compiled accessors**!public! !

!NMLVDISPINFO class methodsFor!

defineFields
	"Define the fields of the Win32 NMLVDISPINFO structure.
		NMLVDISPINFO compileDefinition
	"

	super defineFields.
	self defineField: #lvItem type: (StructureField type: LVITEM) beReadOnly! !
!NMLVDISPINFO class categoriesFor: #defineFields!initializing!public! !

