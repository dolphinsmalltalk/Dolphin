"Filed out from Dolphin Smalltalk"!

AbstractPen subclass: #StockPen
	instanceVariableNames: 'id'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StockPen guid: (GUID fromString: '{87b4c642-026e-11d3-9fd7-00a0cc3e4a32}')!

StockPen comment: ''!

!StockPen categoriesForClass!Graphics-Tools! !

!StockPen methodsFor!

createHandle
	"Private - Answer the handle for the stock pen with receiver's id."

	^self getStockObject: id!

getData: aWinStruct
	"Private - Get the data bytes of the receiver's external resource object into	
	the specified structure. N.B. This only works for GDI objects."

	^GDILibrary default
		getObject: self asParameter
		cbBuffer: aWinStruct byteSize
		lpvObject: aWinStruct!

id
	^id!

id: anInteger
	"Private - Set stockID to anInteger and obtain the handle."

	id := anInteger.
	self basicRealize!

name
	"Answer the symbolic name of this stock pen."

	^#(#white #black #null) at: id - ##(WHITE_PEN - 1)!

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

!StockPen categoriesForMethods!
createHandle!private!realizing/unrealizing! !
getData:!accessing!private! !
id!accessing!public! !
id:!private!realizing/unrealizing! !
name!accessing!public! !
ownedHandle:!accessing!private! !
printOn:!printing!public! !
styleName!accessing!public! !
!

!StockPen class methodsFor!

fromId: anInteger
	"Answer a new instance of the receiver representing the stock pen id anInteger."

	^self new
		ownsHandle: false;
		id: anInteger;
		yourself! !

!StockPen class categoriesForMethods!
fromId:!instance creation!public! !
!

