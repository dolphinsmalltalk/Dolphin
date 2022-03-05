"Filed out from Dolphin Smalltalk"!

Pen subclass: #StockPen
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

id: anInteger
	"Private - Set stockID to anInteger and obtain the handle."

	id := anInteger.
	self basicRealize!

ownedHandle: aHandle 
	"Private - Set the handle of the external graphics's tool object represented and owned by
	the receiver to be the argument."

	"Implementation Note: Stock objects should never be free'd"

	self handle: aHandle! !
!StockPen categoriesForMethods!
createHandle!private!realizing/unrealizing! !
id:!private!realizing/unrealizing! !
ownedHandle:!accessing!private! !
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

