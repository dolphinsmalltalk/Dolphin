"Filed out from Dolphin Smalltalk"!

Graphics.AbstractPen
	subclass: #'Graphics.StockPen'
	instanceVariableNames: 'id'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.StockPen guid: (Core.GUID fromString: '{87b4c642-026e-11d3-9fd7-00a0cc3e4a32}')!

Graphics.StockPen comment: ''!

!Graphics.StockPen categoriesForClass!Graphics-Tools! !

!Graphics.StockPen methodsFor!

createHandle
	"Private - Answer the handle for the stock pen with receiver's id."

	^self getStockObject: id!

id
	^id!

id: anInteger
	"Private - Set stockID to anInteger and obtain the handle."

	id := anInteger.
	self basicRealize!

name
	"Answer the symbolic name of this stock pen."

	^#('white' 'black' 'null') at: id - ##(WHITE_PEN - 1)!

ownedHandle: aHandle 
	"Private - Set the handle of the external graphics's tool object represented and owned by
	the receiver to be the argument."

	"Implementation Note: Stock objects should never be free'd"

	self handle: aHandle!

printOn: aPuttableStream
	"Append, to the <puttableStream> argument a string whose characters are a the same as those which would result from sending a #printString message to the receiver."

	aPuttableStream
		print: Pen;
		space;
		display: self name!

styleName
	^#solid! !

!Graphics.StockPen categoriesForMethods!
createHandle!private!realizing/unrealizing! !
id!public! !
id:!private!realizing/unrealizing! !
name!accessing!public! !
ownedHandle:!accessing!private! !
printOn:!printing!public! !
styleName!accessing!public! !
!

!Graphics.StockPen class methodsFor!

fromId: anInteger
	"Answer a new instance of the receiver representing the stock pen id anInteger."

	^self new
		ownsHandle: false;
		id: anInteger;
		yourself! !

!Graphics.StockPen class categoriesForMethods!
fromId:!instance creation!public! !
!

