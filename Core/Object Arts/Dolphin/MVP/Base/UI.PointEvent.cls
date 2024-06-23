"Filed out from Dolphin Smalltalk"!

UI.WindowsEvent
	subclass: #'UI.PointEvent'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.PointEvent guid: (Core.GUID fromString: '{87b4c551-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.PointEvent comment: ''!

!UI.PointEvent categoriesForClass!Events!MVP-Views-Events! !

!UI.PointEvent methodsFor!

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

!UI.PointEvent categoriesForMethods!
position!accessing!public! !
printLParamOn:!printing!private! !
screenPosition!accessing!public! !
x!accessing!public! !
y!accessing!public! !
!

