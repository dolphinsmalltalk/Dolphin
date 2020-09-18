"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.StringFormat'
	instanceVariableNames: ''
	classVariableNames: 'GenericDefault GenericTypographic'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.StringFormat guid: (Core.GUID fromString: '{f4b7aa81-5fd1-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.StringFormat comment: 'GdiplusStringFormat contains text layout information (such as alignment, orientation, tab stops, and clipping) and display manipulations (such as trimming, font substitution for characters that are not supported by the requested font, and digit substitution for languages that do not use Western European digits). A GdiplusStringFormat instance can be passed to the GdiplusGraphics>>drawString methods to format a string.

'!
!Graphics.Gdiplus.StringFormat categoriesForClass!Unclassified! !
!Graphics.Gdiplus.StringFormat methodsFor!

alignment
	"Answer a StringAlignment constant  that specifies how the receiver will align 
	characters of a string within a layout rectangle."

	| answer |
	answer := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetStringFormatAlign: self asParameter align: answer.
	^answer sdwordAtOffset: 0!

alignment: aStringAlignmentConstant
	"Set how the receiver will align characters of a string horizontally within a layout rectangle."

	GdiplusLibrary default gdipSetStringFormatAlign: self asParameter align: aStringAlignmentConstant!

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

	| gpHandle |
	gpHandle := Handle new.
	GdiplusLibrary default gdipCloneStringFormat: self asParameter newFormat: gpHandle.
	^(self class fromOwnedHandle: gpHandle)
		initializer: initializer;
		yourself!

far
	"Set the receiver so that text will be horizontally far aligned in a layout rectangle."

	self alignment: StringAlignmentFar!

flags
	"Get the receiver's flags, which are from StringFormatFlags enumeration."

	| buf |
	buf := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetStringFormatFlags: self asParameter flags: buf.
	^buf sdwordAtOffset: 0!

flags: anInteger
	"Set the receiver's flags to specify one or more of text layout information (such as orientation 
	and clipping) and display manipulations (such as ellipsis insertion, digit substitution, and 
	representation of characters that are not supported by a font).  anInteger represents zero or
	more StringFormatFlags constants."

	GdiplusLibrary default gdipSetStringFormatFlags: self asParameter flags: anInteger!

getTabOffsets
	"Private - Answer a two-element Array, the first element containing the receiver's initial 
	tab offset, the second element containing an array of additional tab offsets."

	| count first array |
	count := self tabStopCount.
	first := ByteArray newFixed: 4.
	array := FLOATArray new: count.
	GdiplusLibrary default
		gdipGetStringFormatTabStops: self asParameter
		count: count
		firstTabOffset: first
		tabStops: array.
	^{first sdwordAtOffset: 0. array asArray}!

lineAlignment
	| buf |
	buf := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetStringFormatLineAlign: self asParameter align: buf.
	^buf sdwordAtOffset: 0!

lineAlignment: aStringAlignmentConstant
	"Set how the receiver will align a string vertically in a layout rectangle."

	GdiplusLibrary default gdipSetStringFormatLineAlign: self asParameter
		align: aStringAlignmentConstant!

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

	GdiplusLibrary default
		gdipSetStringFormatTabStops: self asParameter
		firstTabOffset: aReal asParameter
		count: aRealArray size
		tabStops: (FLOATArray withAll: aRealArray)!

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

	| count |
	count := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetStringFormatTabStopCount: self asParameter count: count.
	^count sdwordAtOffset: 0!

trimming
	"Answer a StringTrimming constant that indicates how the receiver will trim characters 
	from a string that's too large to fit in a layout rectangle."

	| answer |
	answer := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetStringFormatTrimming: self asParameter trimming: answer.
	^answer sdwordAtOffset: 0!

trimming: aStringTrimmingConstant
	"Set the receiver's trimming style to aStringTrimmingConstant.  This indicates how the 
	receiver will trim characters from a string that's too large to fit in a layout rectangle."

	GdiplusLibrary default gdipSetStringFormatTrimming: self asParameter
		trimming: aStringTrimmingConstant! !
!Graphics.Gdiplus.StringFormat categoriesFor: #alignment!accessing!public! !
!Graphics.Gdiplus.StringFormat categoriesFor: #alignment:!accessing!public! !
!Graphics.Gdiplus.StringFormat categoriesFor: #basicFree!private!realizing/unrealizing! !
!Graphics.Gdiplus.StringFormat categoriesFor: #centered!accessing!public! !
!Graphics.Gdiplus.StringFormat categoriesFor: #clone!copying!public! !
!Graphics.Gdiplus.StringFormat categoriesFor: #far!accessing!public! !
!Graphics.Gdiplus.StringFormat categoriesFor: #flags!accessing!public! !
!Graphics.Gdiplus.StringFormat categoriesFor: #flags:!accessing!public! !
!Graphics.Gdiplus.StringFormat categoriesFor: #getTabOffsets!accessing!private! !
!Graphics.Gdiplus.StringFormat categoriesFor: #lineAlignment!accessing!public! !
!Graphics.Gdiplus.StringFormat categoriesFor: #lineAlignment:!accessing!public! !
!Graphics.Gdiplus.StringFormat categoriesFor: #near!accessing!public! !
!Graphics.Gdiplus.StringFormat categoriesFor: #printOn:!public! !
!Graphics.Gdiplus.StringFormat categoriesFor: #setTabStops:first:!accessing!private! !
!Graphics.Gdiplus.StringFormat categoriesFor: #tabOffsets!accessing!public! !
!Graphics.Gdiplus.StringFormat categoriesFor: #tabOffsets:!accessing!public! !
!Graphics.Gdiplus.StringFormat categoriesFor: #tabStopCount!accessing!private! !
!Graphics.Gdiplus.StringFormat categoriesFor: #trimming!accessing!public! !
!Graphics.Gdiplus.StringFormat categoriesFor: #trimming:!accessing!public! !

!Graphics.Gdiplus.StringFormat class methodsFor!

centered
	"Answer an instance of the receiver with horizontal and vertical centering."

	^self new centered!

exampleGdipSFFormatText
	"MSDN:  GDI+ >  Using GDI+ >  Using Text and Fonts > Formatting Text
	This example displays a string centered within a rectangle.

		self exampleGdipSFFormatText showExample
	"

	| bitmap font rect |
	bitmap := Bitmap extent: 300 @ 300.
	font := Font
				name: 'Arial'
				emSize: 12
				style: FontStyleBold
				unit: UnitPoint.
	rect := bitmap bounds insetBy: 75.
	bitmap graphics
		drawString: 'Use StringFormat and Rectangle objects to center text in a rectangle.'
			font: font
			rect: rect
			format: StringFormat centered
			brush: SolidBrush blue;
		drawRectangle: rect.
	^bitmap!

exampleGdipSFGenerics
	" GDI+ >  GDI+ Reference >  Classes >  StringFormat >  StringFormat Methods
	This example draws a string three times, using different GdiplusStringFormat creation methods.
 
		self exampleGdipSFGenerics showExample
	"

	| bitmap graphics brush font rect stringFormat pen |
	bitmap := Bitmap extent: 300 @ 350.
	graphics := bitmap graphics.
	brush := SolidBrush blue.
	font := Font name: 'Times New Roman' pointSize: 12.
	rect := 30 @ 30 extent: 160 @ 50.
	pen := Pen blue.
	stringFormat := StringFormat genericDefault.
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
	stringFormat := StringFormat genericTypographic.
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
	stringFormat := StringFormat new.
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
	bitmap := Bitmap extent: 550 @ 200.
	graphics := bitmap graphics.
	font := Font name: 'Courier New' pointSize: 12.
	stringFormat := StringFormat new tabOffsets: #(0 150 100 100).
	rect := 20 @ 20 extent: 500 @ 100.
	graphics
		drawString: 'Name	Test 1	Test 2	Test 3'
			font: font
			rect: rect
			format: stringFormat
			brush: SolidBrush blue;
		drawString: 'Tabs set at: ' , (stringFormat tabOffsets collect: [:e | e asInteger]) displayString
			font: font
			at: 20 @ 50
			format: stringFormat
			brush: SolidBrush red;
		drawRectangle: rect.
	^bitmap!

exampleGdipSFTrimming
	"This example draws a string, using each of the available trimming styles.

		self exampleGdipSFTrimming showExample
	"

	| bitmap graphics string font stringFormat row rect |
	bitmap := Bitmap extent: 550 @ 450.
	graphics := bitmap graphics.
	string := 'One two three four five six seven eight nine'.
	self enumsStringTrimming keysAndValuesDo: 
			[:i :e |
			stringFormat := StringFormat new trimming: e value.
			font := Font name: 'Times New Roman' pointSize: 24.
			row := (i - 1) // 2.
			rect := ((i - 1 - (row * 2)) * 250 + 30) @ (row * 130 + 30) extent: 200 @ 80.
			graphics
				drawRectangle: rect pen: Pen black;
				drawString: e key at: rect origin x @ rect origin y - 20;
				drawString: string
					font: font
					rect: rect
					format: stringFormat
					brush: SolidBrush red].
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

	^self fromInitializer: (StringFormatInitializer formatFlags: formatFlags language: language)!

genericDefault
	^GenericDefault
		ifNil: [GenericDefault := self fromInitializer: StringFormatInitializer genericDefault]!

genericTypographic
	^GenericTypographic
		ifNil: [GenericTypographic := self fromInitializer: StringFormatInitializer genericTypographic]!

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
!Graphics.Gdiplus.StringFormat class categoriesFor: #centered!instance creation!public! !
!Graphics.Gdiplus.StringFormat class categoriesFor: #exampleGdipSFFormatText!examples!public!sunit! !
!Graphics.Gdiplus.StringFormat class categoriesFor: #exampleGdipSFGenerics!examples!public!sunit! !
!Graphics.Gdiplus.StringFormat class categoriesFor: #exampleGdipSFTabs!examples!public!sunit! !
!Graphics.Gdiplus.StringFormat class categoriesFor: #exampleGdipSFTrimming!examples!public!sunit! !
!Graphics.Gdiplus.StringFormat class categoriesFor: #far!instance creation!public! !
!Graphics.Gdiplus.StringFormat class categoriesFor: #flags:!instance creation!public! !
!Graphics.Gdiplus.StringFormat class categoriesFor: #flags:language:!instance creation!public! !
!Graphics.Gdiplus.StringFormat class categoriesFor: #genericDefault!instance creation!public! !
!Graphics.Gdiplus.StringFormat class categoriesFor: #genericTypographic!instance creation!public! !
!Graphics.Gdiplus.StringFormat class categoriesFor: #near!instance creation!public! !
!Graphics.Gdiplus.StringFormat class categoriesFor: #new!instance creation!public! !
!Graphics.Gdiplus.StringFormat class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Graphics.Gdiplus.StringFormat class categoriesFor: #uninitialize!class hierarchy-removing!private! !

