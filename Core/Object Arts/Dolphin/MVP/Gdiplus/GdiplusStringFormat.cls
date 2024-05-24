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

	| answer |
	answer := SDWORD new.
	GdiplusLibrary default gdipGetStringFormatAlign: self asParameter align: answer.
	^answer asInteger!

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
	gpHandle := ExternalHandle new.
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
	buf := DWORDBytes new.
	GdiplusLibrary default gdipGetStringFormatFlags: self asParameter flags: buf.
	^buf asSignedInteger!

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
	first := FLOAT newBuffer.
	array := FLOATArray new: count.
	GdiplusLibrary default
		gdipGetStringFormatTabStops: self asParameter
		count: count
		firstTabOffset: first
		tabStops: array.
	count == 0 ifTrue: [^{}].
	first := first value.
	first = 0 ifFalse: [array at: 1 put: (array at: 1) + first].
	^array!

isGenericDefault
	^initializer isGenericDefault!

isGenericTypographic
	^initializer isGenericTypographic!

lineAlignment
	| buf |
	buf := DWORDBytes new.
	GdiplusLibrary default gdipGetStringFormatLineAlign: self asParameter align: buf.
	^buf asSignedInteger!

lineAlignment: aStringAlignmentConstant
	"Set how the receiver will align a string vertically in a layout rectangle."

	GdiplusLibrary default gdipSetStringFormatLineAlign: self asParameter
		align: aStringAlignmentConstant!

measurableCharacterRangeCount
	| buf |
	buf := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetStringFormatMeasurableCharacterRangeCount: self asParameter count: buf.
	^buf sdwordAtOffset: 0!

measurableCharacterRanges: characterRanges
	| charRanges count |
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
	GdiplusLibrary default
		gdipSetStringFormatMeasurableCharacterRanges: self asParameter
		rangeCount: characterRanges size
		ranges: charRanges!

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

	| count first array |
	count := self tabStopCount.
	first := FLOAT newBuffer.
	array := FLOATArray new: count.
	GdiplusLibrary default
		gdipGetStringFormatTabStops: self asParameter
		count: count
		firstTabOffset: first
		tabStops: array.
	count == 0 ifTrue: [^{}].
	first := first value.
	first = 0 ifFalse: [array at: 1 put: (array at: 1) + first].
	^array!

tabOffsets: aRealArray
	"Set the receiver's tab-stops, including the initial offset."

	| status tabOffsets |
	tabOffsets := FLOATArray marshal: aRealArray.
	GdiplusLibrary default
		gdipSetStringFormatTabStops: self asParameter
		firstTabOffset: 0
		count: tabOffsets size
		tabStops: tabOffsets!

tabStopCount
	"Private - Answer the number of tab-stops in the receiver."

	| count |
	count := SDWORD new.
	GdiplusLibrary default gdipGetStringFormatTabStopCount: self asParameter count: count.
	^count asInteger!

trimming
	"Answer a StringTrimming constant that indicates how the receiver will trim characters 
	from a string that's too large to fit in a layout rectangle."

	| answer |
	answer := SDWORD new.
	GdiplusLibrary default gdipGetStringFormatTrimming: self asParameter trimming: answer.
	^answer asInteger!

trimming: aStringTrimmingConstant
	"Set the receiver's trimming style to aStringTrimmingConstant.  This indicates how the 
	receiver will trim characters from a string that's too large to fit in a layout rectangle."

	GdiplusLibrary default gdipSetStringFormatTrimming: self asParameter
		trimming: aStringTrimmingConstant! !

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

