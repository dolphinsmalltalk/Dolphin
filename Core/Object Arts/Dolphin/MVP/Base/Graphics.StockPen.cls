"Filed out from Dolphin Smalltalk 7"!

Pen subclass: #StockPen
	instanceVariableNames: 'id'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!StockPen categoriesFor: #createHandle!private!realizing/unrealizing! !
!StockPen categoriesFor: #id:!private!realizing/unrealizing! !
!StockPen categoriesFor: #ownedHandle:!accessing!private! !

!StockPen class methodsFor!

fromId: anInteger
	"Answer a new instance of the receiver representing the stock pen id anInteger."

	^self new
		ownsHandle: false;
		id: anInteger;
		yourself! !
!StockPen class categoriesFor: #fromId:!instance creation!public! !

