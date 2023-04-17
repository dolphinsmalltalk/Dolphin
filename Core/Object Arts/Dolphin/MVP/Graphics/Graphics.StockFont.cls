"Filed out from Dolphin Smalltalk"!

Graphics.SystemFont
	subclass: #'Graphics.StockFont'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'StockNames' -> (IdentityDictionary withAll: { 16rD -> #system. 16r11 -> #default })
		}!
Graphics.StockFont guid: (Core.GUID fromString: '{87b4c63c-026e-11d3-9fd7-00a0cc3e4a32}')!
Graphics.StockFont comment: ''!
!Graphics.StockFont categoriesForClass!Graphics-Tools! !
!Graphics.StockFont methodsFor!

basicFree
	"Private - Free up external resources held by the receiver. Ignore any errors which might arise."

	"[It is not necessary (but it is not harmful) to delete stock objects by calling DeleteObject](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-getstockobject)"

	!

basicRealize
	"Private - Realize (create) the external resource associated with the receiver, sent from
	the public method, #realize, if not already realized."

	"Override because we don't own the handle"

	self handle: (self getStockObject: id)!

logFont
	"Answer the receiver's logical attributes."

	^logfont
		ifNil: 
			[(logfont := LOGFONTW newBuffer)
				getData: self handle;
				yourself]!

ownedHandle: aHandle 
	"Private - Set the handle of the external graphics's tool object represented and owned by
	the receiver to be the argument."

	"Implementation Note: Stock objects should never be free'd"

	self handle: aHandle!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	(StockNames lookup: id)
		ifNil: 
			[aStream
				nextPut: $(;
				display: Font;
				nextPutAll: ' fromId: ';
				print: id;
				nextPut: $)]
		ifNotNil: 
			[:name |
			aStream
				display: Font;
				space;
				nextPutAll: name]!

resolution: aPoint
	"Sets the logical pixels per inch of the receiver"

	"Ignored"

	!

setId: anInteger
	id := anInteger.
	ownsHandle := false.
	^self! !
!Graphics.StockFont categoriesForMethods!
basicFree!private!realizing/unrealizing! !
basicRealize!private!realizing/unrealizing! !
logFont!accessing!public! !
ownedHandle:!accessing!private! !
printOn:!development!printing!public! !
resolution:!accessing!public! !
setId:!initializing!private! !
!

