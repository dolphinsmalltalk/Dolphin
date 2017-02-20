"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMLVDISPINFO
	instanceVariableNames: 'item'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLVDISPINFO guid: (GUID fromString: '{87b4c625-026e-11d3-9fd7-00a0cc3e4a32}')!
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
	self defineField: #lvItem type: (StructureField type: LVITEM) beReadOnly!

itemFromNMHDR: anExternalAddress
	^LVITEM fromAddress: anExternalAddress yourAddress + (self offsetOf: #lvItem)! !
!NMLVDISPINFO class categoriesFor: #defineFields!initializing!public! !
!NMLVDISPINFO class categoriesFor: #itemFromNMHDR:!public! !

