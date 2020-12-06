"Filed out from Dolphin Smalltalk 7"!

Graphics.Pen subclass: #'Graphics.StockPen'
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

id: anInteger
	"Private - Set stockID to anInteger and obtain the handle."

	id := anInteger.
	self basicRealize!

ownedHandle: aHandle 
	"Private - Set the handle of the external graphics's tool object represented and owned by
	the receiver to be the argument."

	"Implementation Note: Stock objects should never be free'd"

	self handle: aHandle! !
!Graphics.StockPen categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.StockPen categoriesFor: #id:!private!realizing/unrealizing! !
!Graphics.StockPen categoriesFor: #ownedHandle:!accessing!private! !

!Graphics.StockPen class methodsFor!

fromId: anInteger
	"Answer a new instance of the receiver representing the stock pen id anInteger."

	^self new
		ownsHandle: false;
		id: anInteger;
		yourself! !
!Graphics.StockPen class categoriesFor: #fromId:!instance creation!public! !

