"Filed out from Dolphin Smalltalk 7"!

Brush subclass: #StockBrush
	instanceVariableNames: 'id'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StockBrush guid: (GUID fromString: '{87b4c63a-026e-11d3-9fd7-00a0cc3e4a32}')!
StockBrush comment: ''!
!StockBrush categoriesForClass!Graphics-Tools! !
!StockBrush methodsFor!

createHandle
	"Private - Get the handle for the stock brush with receiver's id."

	^self getStockObject: id!

id: anInteger
	"Private - Set receiver's stock brush id to anInteger and obtain the handle."

	id := anInteger.
	self basicRealize!

ownedHandle: aHandle 
	"Private - Set the handle of the external graphics's tool object represented and owned by
	the receiver to be the argument."

	"Implementation Note: Stock objects should never be free'd"

	self handle: aHandle! !
!StockBrush categoriesFor: #createHandle!private!realizing/unrealizing! !
!StockBrush categoriesFor: #id:!private!realizing/unrealizing! !
!StockBrush categoriesFor: #ownedHandle:!accessing!private! !

!StockBrush class methodsFor!

fromId: anInteger
	"Answer a new instance of the receiver representing the stock brush id anInteger."

	^super new
		ownsHandle: false;
		id: anInteger;
		yourself!

new
	"StockBrushes should only be instantiated with #fromID:"

	^self shouldNotImplement! !
!StockBrush class categoriesFor: #fromId:!instance creation!public! !
!StockBrush class categoriesFor: #new!instance creation!public! !

