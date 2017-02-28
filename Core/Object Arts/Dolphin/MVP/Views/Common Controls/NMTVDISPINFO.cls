"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMTVDISPINFO
	instanceVariableNames: 'item'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMTVDISPINFO guid: (GUID fromString: '{87b4c62b-026e-11d3-9fd7-00a0cc3e4a32}')!
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
	self defineField: #tvItem type: (StructureField type: TVITEM) beReadOnly!

itemFromNMHDR: anExternalAddress
	^TVITEM fromAddress: anExternalAddress yourAddress + ##(self offsetOf: #tvItem)! !
!NMTVDISPINFO class categoriesFor: #defineFields!initializing!public! !
!NMTVDISPINFO class categoriesFor: #itemFromNMHDR:!public! !

