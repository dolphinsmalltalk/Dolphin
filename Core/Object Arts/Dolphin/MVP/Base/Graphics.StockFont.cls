"Filed out from Dolphin Smalltalk 7"!

Graphics.Font subclass: #'Graphics.StockFont'
	instanceVariableNames: 'id'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.StockFont guid: (Core.GUID fromString: '{87b4c63c-026e-11d3-9fd7-00a0cc3e4a32}')!
Graphics.StockFont comment: ''!
!Graphics.StockFont categoriesForClass!Graphics-Tools! !
!Graphics.StockFont methodsFor!

= aFont
	"Answer true if aFont is equal to (has the same id as) the receiver."

	^self species == aFont species and: [self id == aFont id]!

createHandle
	"Private - Get the handle for the stock font with id stockID."

	^self getStockObject: self id!

hash
	"Answer the SmallInteger hash value for the receiver."

	^self id hash!

id
	"Private - Answer the stock font id of the receiver"

	^id!

id: anInteger
	"Private - Set receiver's id to anInteger and obtain the handle."

	id := anInteger.
	self basicRealize!

ownedHandle: aHandle 
	"Private - Set the handle of the external graphics's tool object represented and owned by
	the receiver to be the argument."

	"Implementation Note: Stock objects should never be free'd"

	self handle: aHandle! !
!Graphics.StockFont categoriesFor: #=!comparing!public! !
!Graphics.StockFont categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.StockFont categoriesFor: #hash!comparing!public! !
!Graphics.StockFont categoriesFor: #id!accessing!private! !
!Graphics.StockFont categoriesFor: #id:!accessing!private! !
!Graphics.StockFont categoriesFor: #ownedHandle:!accessing!private! !

!Graphics.StockFont class methodsFor!

fromId: anInteger
	"Answer a new instance of the receiver representing the stock font id anInteger."

	^self new
		ownsHandle: false;
		id: anInteger;
		yourself! !
!Graphics.StockFont class categoriesFor: #fromId:!instance creation!public! !

