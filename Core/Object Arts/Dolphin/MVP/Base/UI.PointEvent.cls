"Filed out from Dolphin Smalltalk 7"!

WindowsEvent subclass: #PointEvent
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PointEvent guid: (GUID fromString: '{87b4c551-026e-11d3-9fd7-00a0cc3e4a32}')!
PointEvent comment: ''!
!PointEvent categoriesForClass!Events!MVP-Views-Events! !
!PointEvent methodsFor!

position
	"Answer the point stored in the receiver's lParam."

	^self x @ self y!

printLParamOn: aStream 
	"Private - Append a textual representation of the receiver's lParam to aStream, in a format
	appropriate for the type of event."

	aStream print: self position!

screenPosition
	"Answer the point stored in the receiver's lParam mapped to screen coordinates"

	^self window mapPointToScreen: self position!

x
	"Answer the x-position of the pointer."

	^self lParamX!

y
	"Answer the y-position of the pointer."

	^self lParamY! !
!PointEvent categoriesFor: #position!accessing!public! !
!PointEvent categoriesFor: #printLParamOn:!printing!private! !
!PointEvent categoriesFor: #screenPosition!accessing!public! !
!PointEvent categoriesFor: #x!accessing!public! !
!PointEvent categoriesFor: #y!accessing!public! !

