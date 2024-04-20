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
	first := FLOAT newBuffer.
	array := FLOATArray new: count.
	(status := GdiplusLibrary default 
				gdipGetStringFormatTabStops: self asParameter
				count: count
				firstTabOffset: first
				tabStops: array) == Ok 
		ifFalse: [GdiplusError signal: 'GdipGetStringFormatTabStops failed' with: status].
	count == 0 ifTrue: [^{}].
	first := first value.
	first = 0 ifFalse: [array at: 1 put: (array at: 1) + first].
	^array!

isGenericDefault
	^initializer isGenericDefault!

isGenericTypographic
	^initializer isGenericTypographic!

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

measurableCharacterRangeCount
	| buf status |
	buf := ByteArray newFixed: 4.
	(status := GdiplusLibrary default
		gdipGetStringFormatMeasurableCharacterRangeCount: self asParameter
		count: buf) == Ok ifFalse: [GdiplusError signal: 'GdipSetStringFormatMeasurableCharacterRanges failed' with: status].
	^buf sdwordAtOffset: 0!

measurableCharacterRanges: characterRanges
	| charRanges count status |
	count := characterRanges size.
	charRanges := ByteArray new: count * 8.
	1 to: count
		do: 
			[:j |
			| each |
			each := characterRanges at: j.
			charRanges
				sdwordAtOffset: (j - 1) * 8 put: each start - 1;
				sdwordAtOffset: j * 8 - 4 put: each size].
	(status := GdiplusLibrary default
		gdipSetStringFormatMeasurableCharacterRanges: self asParameter
		rangeCount: characterRanges size
		ranges: charRanges) == Ok ifFalse: [GdiplusError signal: 'GdipSetStringFormatMeasurableCharacterRanges failed' with: status].!

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

	| status count first array |
	count := self tabStopCount.
	first := FLOAT newBuffer.
	array := FLOATArray new: count.
	(status := GdiplusLibrary default
				gdipGetStringFormatTabStops: self asParameter
				count: count
				firstTabOffset: first
				tabStops: array) == Ok
		ifFalse: [GdiplusError signal: 'GdipGetStringFormatTabStops failed' with: status].
	count == 0 ifTrue: [^{}].
	first := first value.
	first = 0 ifFalse: [array at: 1 put: (array at: 1) + first].
	^array!

tabOffsets: aRealArray
	"Set the receiver's tab-stops, including the initial offset."

	| status tabOffsets |
	tabOffsets := FLOATArray marshal: aRealArray.
	(status := GdiplusLibrary default
				gdipSetStringFormatTabStops: self asParameter
				firstTabOffset: 0
				count: tabOffsets size
				tabStops: tabOffsets) == Ok
		ifFalse: [GdiplusError signal: 'GdipSetStringFormatTabStops failed' with: status]!

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
isGenericDefault!public!testing! !
isGenericTypographic!public!testing! !
lineAlignment!accessing!public! !
lineAlignment:!accessing!public! !
measurableCharacterRangeCount!accessing!public! !
measurableCharacterRanges:!accessing!public! !
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

