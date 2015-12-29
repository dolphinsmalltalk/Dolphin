"Filed out from Dolphin Smalltalk X6"!

WindowsEvent subclass: #PointEvent
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PointEvent guid: (GUID fromString: '{87B4C551-026E-11D3-9FD7-00A0CC3E4A32}')!
PointEvent comment: ''!
!PointEvent categoriesForClass!Events!MVP-Views-Events! !
!PointEvent methodsFor!

position
	"Answer the point stored in the receiver's lParam."

	^self x @ self y!

screenPosition
	"Answer the point stored in the receiver's lParam mapped to screen coordinates"

	^self window mapPoint: self position to: View desktop!

x
	"Answer the x-position of the pointer."

	^self lParamX!

y
	"Answer the y-position of the pointer."

	^self lParamY! !
!PointEvent categoriesFor: #position!accessing!public! !
!PointEvent categoriesFor: #screenPosition!accessing!public! !
!PointEvent categoriesFor: #x!accessing!public! !
!PointEvent categoriesFor: #y!accessing!public! !

