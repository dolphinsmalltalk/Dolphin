"Filed out from Dolphin Smalltalk 7"!

Font subclass: #StockFont
	instanceVariableNames: 'id'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StockFont guid: (GUID fromString: '{87b4c63c-026e-11d3-9fd7-00a0cc3e4a32}')!
StockFont comment: ''!
!StockFont categoriesForClass!Graphics-Tools! !
!StockFont methodsFor!

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
!StockFont categoriesFor: #=!comparing!public! !
!StockFont categoriesFor: #createHandle!private!realizing/unrealizing! !
!StockFont categoriesFor: #hash!comparing!public! !
!StockFont categoriesFor: #id!accessing!private! !
!StockFont categoriesFor: #id:!accessing!private! !
!StockFont categoriesFor: #ownedHandle:!accessing!private! !

!StockFont class methodsFor!

fromId: anInteger
	"Answer a new instance of the receiver representing the stock font id anInteger."

	^self new
		ownsHandle: false;
		id: anInteger;
		yourself! !
!StockFont class categoriesFor: #fromId:!instance creation!public! !

