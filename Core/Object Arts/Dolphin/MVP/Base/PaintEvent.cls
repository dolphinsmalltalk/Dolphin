"Filed out from Dolphin Smalltalk X6"!

WindowsEvent subclass: #PaintEvent
	instanceVariableNames: 'hdc paintStruct'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PaintEvent guid: (GUID fromString: '{87B4C550-026E-11D3-9FD7-00A0CC3E4A32}')!
PaintEvent comment: ''!
!PaintEvent categoriesForClass!Events!MVP-Views-Events! !
!PaintEvent methodsFor!

canvas
	"Answer a Canvas using the hdc associated with the paint event."

	^Canvas withNonOwnedDC: hdc
!

handle: anExternalHandle wParam: anInteger hdc: dcExternalHandle paintStruct: aPAINTSTRUCT
	"Private - Initialize the receiver's instance variables. Answer the receiver."

	message := WM_PAINT.
	hWnd := anExternalHandle.
	wParam := anInteger.
	lParam := 0.
	hdc := dcExternalHandle.
	paintStruct := aPAINTSTRUCT!

hdc
	^hdc!

paintStruct
	"Answer the <PAINTSTRUCT> associated with the receiver."

	^paintStruct!

printOn: aStream
	"Append a textual representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self paintStruct;
		nextPut: $)! !
!PaintEvent categoriesFor: #canvas!accessing!public! !
!PaintEvent categoriesFor: #handle:wParam:hdc:paintStruct:!accessing!private! !
!PaintEvent categoriesFor: #hdc!accessing!public! !
!PaintEvent categoriesFor: #paintStruct!accessing!public! !
!PaintEvent categoriesFor: #printOn:!development!printing!public! !

!PaintEvent class methodsFor!

handle:  hWnd wParam: wParam hdc: hdc paintStruct: ps
	"Answer an instance of the receiver with the given properties."

	^self new handle: hWnd wParam: wParam hdc: hdc paintStruct: ps! !
!PaintEvent class categoriesFor: #handle:wParam:hdc:paintStruct:!instance creation!public! !

