"Filed out from Dolphin Smalltalk"!

Font subclass: #StockFont
	instanceVariableNames: 'id'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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
	"Private - Initialize the receiver to represent the stock font with the specified <integer> id."

	id := anInteger.
	ownsHandle := false.
	dpi := SystemMetrics current dpi.
	logfont := LOGFONTW newBuffer.
	self basicRealize.
	^self!

ownedHandle: aHandle 
	"Private - Set the handle of the external graphics's tool object represented and owned by
	the receiver to be the argument."

	"Implementation Note: Stock objects should never be free'd"

	self handle: aHandle! !

!StockFont categoriesForMethods!
=!comparing!public! !
createHandle!private!realizing/unrealizing! !
hash!comparing!public! !
id!accessing!private! !
id:!initializing!private! !
ownedHandle:!accessing!private! !
!

!StockFont class methodsFor!

fromId: anInteger
	"Answer a new instance of the receiver representing the stock font id anInteger."

	^self basicNew id: anInteger! !

!StockFont class categoriesForMethods!
fromId:!instance creation!public! !
!

