"Filed out from Dolphin Smalltalk 7"!

WindowsEvent subclass: #SizeEvent
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!SizeEvent categoriesFor: #extent!accessing!public! !
!SizeEvent categoriesFor: #height!accessing!public! !
!SizeEvent categoriesFor: #type!accessing!public! !
!SizeEvent categoriesFor: #width!accessing!public! !

