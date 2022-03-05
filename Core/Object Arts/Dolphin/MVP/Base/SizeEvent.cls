"Filed out from Dolphin Smalltalk"!

WindowsEvent subclass: #SizeEvent
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SizeEvent guid: (GUID fromString: '{87b4c553-026e-11d3-9fd7-00a0cc3e4a32}')!
SizeEvent comment: ''!
!SizeEvent categoriesForClass!Events!MVP-Views-Events! !
!SizeEvent methodsFor!

extent
	"Answer the extent of the client area after the size event."

	^self width @ self height!

height
	"Answer the height of the client area after the size event."

	^self lParamY!

type
	"Answer the type of size event."

	^self wParam!

width
	"Answer the width of the client area after the size event."

	^self lParamX! !
!SizeEvent categoriesForMethods!
extent!accessing!public! !
height!accessing!public! !
type!accessing!public! !
width!accessing!public! !
!

