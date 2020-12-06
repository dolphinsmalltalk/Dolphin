"Filed out from Dolphin Smalltalk 7"!

UI.WindowsEvent subclass: #'UI.PaintEvent'
	instanceVariableNames: 'hdc paintStruct'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.PaintEvent guid: (Core.GUID fromString: '{87b4c550-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.PaintEvent comment: ''!
!UI.PaintEvent categoriesForClass!Events!MVP-Views-Events! !
!UI.PaintEvent methodsFor!

canvas
	"Answer a Canvas using the hdc associated with the paint event."

	^Canvas withNonOwnedDC: hdc
!

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
		nextPut: $)!

window: aView wParam: anInteger hdc: dcExternalHandle paintStruct: aPAINTSTRUCT
	"Private - Initialize the receiver's instance variables. Answer the receiver."

	message := WM_PAINT.
	window := aView.
	wParam := anInteger.
	lParam := 0.
	hdc := dcExternalHandle.
	paintStruct := aPAINTSTRUCT! !
!UI.PaintEvent categoriesFor: #canvas!accessing!public! !
!UI.PaintEvent categoriesFor: #hdc!accessing!public! !
!UI.PaintEvent categoriesFor: #paintStruct!accessing!public! !
!UI.PaintEvent categoriesFor: #printOn:!development!printing!public! !
!UI.PaintEvent categoriesFor: #window:wParam:hdc:paintStruct:!accessing!private! !

!UI.PaintEvent class methodsFor!

window: aView wParam: wParam hdc: hdc paintStruct: ps
	"Answer an instance of the receiver with the given properties."

	^self new
		window: aView
		wParam: wParam
		hdc: hdc
		paintStruct: ps! !
!UI.PaintEvent class categoriesFor: #window:wParam:hdc:paintStruct:!instance creation!public! !

