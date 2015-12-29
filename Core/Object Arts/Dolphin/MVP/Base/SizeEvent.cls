"Filed out from Dolphin Smalltalk X6"!

WindowsEvent subclass: #SizeEvent
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SizeEvent guid: (GUID fromString: '{87B4C553-026E-11D3-9FD7-00A0CC3E4A32}')!
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

