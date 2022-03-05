"Filed out from Dolphin Smalltalk"!

Brush subclass: #StockBrush
	instanceVariableNames: 'id'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StockBrush guid: (GUID fromString: '{87b4c63a-026e-11d3-9fd7-00a0cc3e4a32}')!
StockBrush comment: '`StockBrush` is type of `Brush` that wraps one of the standard (aka ''stock'') Windows GDI Brush objects, for example black and white brushes.

StockBrushes are normally instantiated using one of the relevant instance creation methods of the superclass, `Brush`. For example:

	`Brush black`

## Instance Variables:
  `id`		`<integer>` code identifying the brush pattern and colour

'!
!StockBrush categoriesForClass!Graphics-Tools! !
!StockBrush methodsFor!

createHandle
	"Private - Get the handle for the stock brush with receiver's id."

	^self getStockObject: id!

id: anInteger
	"Private - Set receiver's stock brush id to anInteger."

	id := anInteger.
	ownsHandle := false!

name
	"Answer the symbolic name of this stock brush."

	^#(#white #silver #gray #darkGray #black #transparent) at: id + 1!

ownedHandle: aHandle 
	"Private - Set the handle of the external graphics's tool object represented and owned by
	the receiver to be the argument."

	"Implementation Note: Stock objects should never be free'd"

	self handle: aHandle!

printOn: aPuttableStream
	"Append, to the <puttableStream> argument a string whose characters are a the same as those which would result from sending a #printString message to the receiver."

	aPuttableStream
		print: Brush;
		space;
		display: self name! !
!StockBrush categoriesForMethods!
createHandle!private!realizing/unrealizing! !
id:!private!realizing/unrealizing! !
name!accessing!public! !
ownedHandle:!accessing!private! !
printOn:!printing!public! !
!

!StockBrush class methodsFor!

fromId: anInteger
	"Answer a new instance of the receiver representing the stock brush id anInteger."

	^self basicNew
		id: anInteger;
		yourself!

new
	"StockBrushes should only be instantiated with #fromID:"

	^self shouldNotImplement! !
!StockBrush class categoriesForMethods!
fromId:!instance creation!public! !
new!instance creation!public! !
!

