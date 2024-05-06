"Filed out from Dolphin Smalltalk"!

GdiplusBase subclass: #GdiplusStringFormat
	instanceVariableNames: ''
	classVariableNames: 'GenericDefault GenericTypographic'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusStringFormat guid: (GUID fromString: '{f4b7aa81-5fd1-11d7-b609-00e0987e8081}')!

GdiplusStringFormat comment: 'GdiplusStringFormat contains text layout information (such as alignment, orientation, tab stops, and clipping) and display manipulations (such as trimming, font substitution for characters that are not supported by the requested font, and digit substitution for languages that do not use Western European digits). A GdiplusStringFormat instance can be passed to the GdiplusGraphics>>drawString methods to format a string.

'!

!GdiplusStringFormat categoriesForClass!Unclassified! !

!GdiplusStringFormat methodsFor!

alignment
	"Answer a StringAlignment constant  that specifies how the receiver will align 
	characters of a string within a layout rectangle."

	| status answer |
	answer := SDWORD new.
	(status := GdiplusLibrary default gdipGetStringFormatAlign: self asParameter align: answer) == Ok 
		ifFalse: [GdiplusError signal: 'GdipGetStringFormatAlign failed' with: status].
	^answer asInteger!

alignment: aStringAlignmentConstant 
	"Set how the receiver will align characters of a string horizontally within a layout rectangle."

	| status |
	(status := GdiplusLibrary default gdipSetStringFormatAlign: self asParameter
				align: aStringAlignmentConstant) == Ok 
		ifFalse: [GdiplusError signal: 'GdipSetStringFormatAlign failed' with: status]!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	GdiplusLibrary default gdipDeleteStringFormat: handle!

centered
	"Set the receiver so that text will be centered horizontally and vertically in a layout rectangle."

	self
		alignment: StringAlignmentCenter;
		lineAlignment: StringAlignmentCenter!

clone
	"Answer a copy of the receiver."

	| status gpHandle |
	gpHandle := ExternalHandle new.
	(status := GdiplusLibrary default gdipCloneStringFormat: self asParameter newFormat: gpHandle) == Ok 
		ifFalse: [GdiplusError signal: 'GdipCloneStringFormat failed' with: status].
	^(self class fromOwnedHandle: gpHandle)
		initializer: initializer;
		yourself!

far
	"Set the receiver so that text will be horizontally far aligned in a layout rectangle."

	self alignment: StringAlignmentFar!

flags
	"Get the receiver's flags, which are from StringFormatFlags enumeration."

	| buf status |
	buf := DWORDBytes new.
	(status := GdiplusLibrary default gdipGetStringFormatFlags: self asParameter flags: buf) == Ok 
		ifFalse: [GdiplusError signal: 'GdipSetStringFormatFlags failed' with: status].
	^buf asSignedInteger!

flags: anInteger 
	"Set the receiver's flags to specify one or more of text layout information (such as orientation 
	and clipping) and display manipulations (such as ellipsis insertion, digit substitution, and 
	representation of characters that are not supported by a font).  anInteger represents zero or
	more StringFormatFlags constants."

	| status |
	(status := GdiplusLibrary default gdipSetStringFormatFlags: self asParameter flags: anInteger) == Ok 
		ifFalse: [GdiplusError signal: 'GdipSetStringFormatFlags failed' with: status]!

getTabOffsets
	"Private - Answer a two-element Array, the first element containing the receiver's initial 
	tab offset, the second element containing an array of additional tab offsets."

	| status count first array |
	count := self tabStopCount.
	first := SDWORD new.
	array := FLOATArray new: count.
	(status := GdiplusLibrary default 
				gdipGetStringFormatTabStops: self asParameter
				count: count
				firstTabOffset: first
				tabStops: array) == Ok 
		ifFalse: [GdiplusError signal: 'GdipGetStringFormatTabStops failed' with: status].
	^Array with: first value with: array asArray!

lineAlignment
	| buf status |
	buf := DWORDBytes new.
	(status := GdiplusLibrary default gdipGetStringFormatLineAlign: self asParameter align: buf) == Ok
		ifFalse: [GdiplusError signal: 'GdipSetStringFormatLineAlign failed' with: status].
	^buf asSignedInteger!

lineAlignment: aStringAlignmentConstant 
	"Set how the receiver will align a string vertically in a layout rectangle."

	| status |
	(status := GdiplusLibrary default gdipSetStringFormatLineAlign: self asParameter
				align: aStringAlignmentConstant) == Ok 
		ifFalse: [GdiplusError signal: 'GdipSetStringFormatLineAlign failed' with: status]!

near
	"Set the receiver so that text will be horizontally near aligned in a layout rectangle."

	self alignment: StringAlignmentNear!

printOn: aStream
	| alignments trimmings |
	alignments := #(#near #centered #far).
	trimmings := #(#none #character #word #ellipsisCharacter #ellipsisWord #ellipsisPath).
	self basicPrintOn: aStream.
	aStream nextPut: $(.
	handle isNull
		ifFalse: 
			[aStream nextPutAll: 'Flags: '.
			self flags printOn: aStream base: 16 showRadix: true.
			aStream
				nextPutAll: ', Alignment: ';
				print: (alignments at: self alignment + 1);
				nextPutAll: ', LineAlignment: ';
				print: (alignments at: self lineAlignment + 1);
				nextPutAll: ', Trimming: ';
				print: (trimmings at: self trimming + 1)].
	aStream nextPut: $)!

setTabStops: aRealArray first: aReal 
	"Private - Set the receiver's tab-stops."

	| status |
	(status := GdiplusLibrary default 
				gdipSetStringFormatTabStops: self asParameter
				firstTabOffset: aReal asParameter
				count: aRealArray size
				tabStops: (FLOATArray withAll: aRealArray)) == Ok 
		ifFalse: [GdiplusError signal: 'GdipSetStringFormatTabStops failed' with: status]!

tabOffsets
	"Answer an Array containing the receiver's tab offsets, including the initial offset."

	| array |
	array := self getTabOffsets.
	^((OrderedCollection with: array first) , array second asOrderedCollection) asArray!

tabOffsets: aRealArray
	"Set the receiver's tab-stops, including the initial offset."

	self setTabStops: ((aRealArray asOrderedCollection)
				removeFirst;
				yourself)
		first: aRealArray first!

tabStopCount
	"Private - Answer the number of tab-stops in the receiver."

	| status count |
	count := SDWORD new.
	(status := GdiplusLibrary default gdipGetStringFormatTabStopCount: self asParameter count: count) 
		== Ok ifFalse: [GdiplusError signal: 'GdipGetStringFormatTabStopCount failed' with: status].
	^count asInteger!

trimming
	"Answer a StringTrimming constant that indicates how the receiver will trim characters 
	from a string that's too large to fit in a layout rectangle."

	| status answer |
	answer := SDWORD new.
	(status := GdiplusLibrary default gdipGetStringFormatTrimming: self asParameter trimming: answer) 
		== Ok ifFalse: [GdiplusError signal: 'GdipGetStringFormatTrimming failed' with: status].
	^answer asInteger!

trimming: aStringTrimmingConstant 
	"Set the receiver's trimming style to aStringTrimmingConstant.  This indicates how the 
	receiver will trim characters from a string that's too large to fit in a layout rectangle."

	| status |
	(status := GdiplusLibrary default gdipSetStringFormatTrimming: self asParameter
				trimming: aStringTrimmingConstant) == Ok 
		ifFalse: [GdiplusError signal: 'GdipSetStringFormatTrimming failed' with: status]! !

!GdiplusStringFormat categoriesForMethods!
alignment!accessing!public! !
alignment:!accessing!public! !
basicFree!private!realizing/unrealizing! !
centered!accessing!public! !
clone!copying!public! !
far!accessing!public! !
flags!accessing!public! !
flags:!accessing!public! !
getTabOffsets!accessing!private! !
lineAlignment!accessing!public! !
lineAlignment:!accessing!public! !
near!accessing!public! !
printOn:!public! !
setTabStops:first:!accessing!private! !
tabOffsets!accessing!public! !
tabOffsets:!accessing!public! !
tabStopCount!accessing!private! !
trimming!accessing!public! !
trimming:!accessing!public! !
!

!GdiplusStringFormat class methodsFor!

centered
	"Answer an instance of the receiver with horizontal and vertical centering."

	^self new centered!

exampleGdipSFFormatText
	"MSDN:  GDI+ >  Using GDI+ >  Using Text and Fonts > Formatting Text
	This example displays a string centered within a rectangle.

		self exampleGdipSFFormatText showExample
	"

	| bitmap font rect |
	bitmap := GdiplusBitmap extent: 300 @ 300.
	font := GdiplusFont 
				name: 'Arial'
				emSize: 12
				style: FontStyleBold
				unit: UnitPoint.
	rect := bitmap bounds insetBy: 75.
	(bitmap graphics)
		drawString: 'Use StringFormat and Rectangle objects to center text in a rectangle.'
			font: font
			rect: rect
			format: GdiplusStringFormat centered
			brush: GdiplusSolidBrush blue;
		drawRectangle: rect.
	^bitmap!

exampleGdipSFGenerics
	" GDI+ >  GDI+ Reference >  Classes >  StringFormat >  StringFormat Methods
	This example draws a string three times, using different GdiplusStringFormat creation methods.
 
		self exampleGdipSFGenerics showExample
	"

	| bitmap graphics brush font rect stringFormat pen |
	bitmap := GdiplusBitmap extent: 300 @ 350.
	graphics := bitmap graphics.
	brush := GdiplusSolidBrush blue.
	font := GdiplusFont name: 'Times New Roman' pointSize: 12.
	rect := 30 @ 30 extent: 160 @ 50.
	pen := GdiplusPen blue.
	stringFormat := GdiplusStringFormat genericDefault.
	graphics
		drawString: 'This text was formatted by a generic StringFormat object.'
		font: font
		rect: rect
		format: stringFormat
		brush: brush.
	graphics drawRectangle: rect pen: pen.
	rect moveBy: 0 @ 100.
	pen color: Color red.
	brush color: Color red.
	stringFormat := GdiplusStringFormat genericTypographic.
	graphics
		drawString: 'This text was formatted by a typographic StringFormat object.'
		font: font
		rect: rect
		format: stringFormat
		brush: brush.
	graphics drawRectangle: rect pen: pen.
	rect moveBy: 0 @ 100.
	pen color: Color black.
	brush color: Color black.
	stringFormat := GdiplusStringFormat new.
	graphics
		drawString: 'This text was formatted by a new StringFormat object.'
		font: font
		rect: rect
		format: stringFormat
		brush: brush.
	graphics drawRectangle: rect pen: pen.
	^bitmap!

exampleGdipSFTabs
	"This example creates a GdiplusStringFormat instance, sets its tab-stops, and then draws a
	string that contains embedded tabs.

		self exampleGdipSFTabs showExample
	"

	| bitmap graphics font rect stringFormat |
	bitmap := GdiplusBitmap extent: 550 @ 200.
	graphics := bitmap graphics.
	font := GdiplusFont name: 'Courier New' pointSize: 12.
	stringFormat := GdiplusStringFormat new tabOffsets: #(0 150 100 100).
	rect := 20 @ 20 extent: 500 @ 100.
	graphics
		drawString: 'Name	Test 1	Test 2	Test 3'
			font: font
			rect: rect
			format: stringFormat
			brush: GdiplusSolidBrush blue;
		drawString: 'Tabs set at: ' , (stringFormat tabOffsets collect: [:e | e asInteger]) displayString
			font: font
			at: 20 @ 50
			format: stringFormat
			brush: GdiplusSolidBrush red;
		drawRectangle: rect.
	^bitmap!

exampleGdipSFTrimming
	"This example draws a string, using each of the available trimming styles.

		self exampleGdipSFTrimming showExample
	"

	| bitmap graphics string font stringFormat row rect |
	bitmap := GdiplusBitmap extent: 550 @ 450.
	graphics := bitmap graphics.
	string := 'One two three four five six seven eight nine'.
	self enumsStringTrimming keysAndValuesDo: 
			[:i :e |
			stringFormat := GdiplusStringFormat new trimming: e value.
			font := GdiplusFont name: 'Times New Roman' pointSize: 24.
			row := (i - 1) // 2.
			rect := ((i - 1 - (row * 2)) * 250 + 30) @ (row * 130 + 30) extent: 200 @ 80.
			graphics
				drawRectangle: rect pen: GdiplusPen black;
				drawString: e key at: rect origin x @ rect origin y - 20;
				drawString: string
					font: font
					rect: rect
					format: stringFormat
					brush: GdiplusSolidBrush red].
	^bitmap!

far
	"Answer an instance of the receiver with horizontal far alignment."

	^self new far!

flags: formatFlags
	"Answer an instance of the receiver specified by formatFlags and using the user's default language."

	^self flags: formatFlags language: nil!

flags: formatFlags language: language
	"Answer an instance of the receiver whose characteristics are set by formatFlags (zero or more
	StringFormatFlags constants) and the specified <Integer> language."

	^self fromInitializer: (GdiplusStringFormatInitializer formatFlags: formatFlags language: language)!

genericDefault
	^GenericDefault
		ifNil: [GenericDefault := self fromInitializer: GdiplusStringFormatInitializer genericDefault]!

genericTypographic
	^GenericTypographic
		ifNil: [GenericTypographic := self fromInitializer: GdiplusStringFormatInitializer genericTypographic]!

near
	"Answer an instance of the receiver with horizontal near alignment."

	^self new near!

new
	"Answer an instance of the receiver with no format flags set and which uses the user's default language."

	^self flags: nil language: nil!

onPreStripImage
	"Private -  Allow the receiver and subclasses to be stripped by clearing lazy initialized class variables
	which hold sub-instance of the receiver."

	self uninitialize!

uninitialize
	GenericDefault := GenericTypographic := nil! !

!GdiplusStringFormat class categoriesForMethods!
centered!instance creation!public! !
exampleGdipSFFormatText!examples!public!sunit! !
exampleGdipSFGenerics!examples!public!sunit! !
exampleGdipSFTabs!examples!public!sunit! !
exampleGdipSFTrimming!examples!public!sunit! !
far!instance creation!public! !
flags:!instance creation!public! !
flags:language:!instance creation!public! !
genericDefault!instance creation!public! !
genericTypographic!instance creation!public! !
near!instance creation!public! !
new!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
uninitialize!class hierarchy-removing!private! !
!

