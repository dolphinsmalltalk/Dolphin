"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.StringFormat'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.StringFormat guid: (Core.GUID fromString: '{f4b7aa81-5fd1-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.StringFormat comment: 'GdiplusStringFormat contains text layout information (such as alignment, orientation, tab stops, and clipping) and display manipulations (such as trimming, font substitution for characters that are not supported by the requested font, and digit substitution for languages that do not use Western European digits). A GdiplusStringFormat instance can be passed to the GdiplusGraphics>>drawString methods to format a string.

'!
!Graphics.Gdiplus.StringFormat methodsFor!

alignment
	"Answer a StringAlignment constant that specifies how the receiver will align 
	characters of a string within a layout rectangle."

	^self initializer alignment!

alignment: aStringAlignmentConstant
	"Set how the receiver will align characters of a string horizontally within a layout rectangle."

	self alignment == aStringAlignmentConstant ifTrue: [^self].
	self initializer alignmentOf: self set: aStringAlignmentConstant!

centered
	"Set the receiver so that text will be centered horizontally and vertically in a layout rectangle."

	self
		alignment: StringAlignmentCenter;
		lineAlignment: StringAlignmentCenter!

characterRanges
	^self initializer characterRanges!

clone
	"Answer a copy of the receiver."

	"The 'measurable character ranges' attribute of StringFormats cannot be queried through the GDI+ API, so we cannot populate an initializer from the handle. Consequently we must copy over the initializer."

	^super clone
		initializer: initializer copy;
		yourself!

digitSubstitution
	^self initializer digitSubstitution!

digitSubstitution: aStringDigitSubstituteConstant
	self digitSubstitution == aStringDigitSubstituteConstant ifTrue: [^self].
	self initializer digitSubstitutionOf: self set: aStringDigitSubstituteConstant!

far
	"Set the receiver so that text will be horizontally far aligned in a layout rectangle."

	self alignment: StringAlignmentFar!

flags
	"Get the receiver's flags, which are from StringFormatFlags enumeration."

	^self initializer flags!

flags: anInteger
	"Set the receiver's flags to specify one or more of text layout information (such as orientation 
	and clipping) and display manipulations (such as ellipsis insertion, digit substitution, and 
	representation of characters that are not supported by a font).  anInteger represents zero or
	more StringFormatFlags constants."

	self flags == anInteger ifTrue: [^self].
	self initializer flagsOf: self set: anInteger!

hotkeyPrefix
	^self initializer hotkeyPrefix!

hotkeyPrefix: aHotkeyPrefixConstant
	self hotkeyPrefix == aHotkeyPrefixConstant ifTrue: [^self].
	self initializer hotkeyPrefixOf: self set: aHotkeyPrefixConstant!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^StringFormatFromFlagsInitializer!

isGenericDefault
	^self initializer isGenericDefault!

isGenericTypographic
	^self initializer isGenericTypographic!

language
	^self initializer language!

lineAlignment
	^self initializer lineAlignment!

lineAlignment: aStringAlignmentConstant
	"Set how the receiver will align a string vertically in a layout rectangle."

	self lineAlignment == aStringAlignmentConstant ifTrue: [^self].
	self initializer lineAlignmentOf: self set: aStringAlignmentConstant!

measurableCharacterRanges
	^self initializer characterRanges!

measurableCharacterRanges: aCollectionOfIntervals
	self initializer measurableCharacterRangesOf: self set: aCollectionOfIntervals!

near
	"Set the receiver so that text will be horizontally near aligned in a layout rectangle."

	self alignment: StringAlignmentNear!

tabOffsets
	"Answer an Array containing the receiver's tab offsets, including the initial offset."

	^self initializer tabOffsets!

tabOffsets: aSequenceOfNumbers
	"Set the receiver's tab-stops, including the initial offset."

	self initializer tabOffsetsOf: self set: aSequenceOfNumbers!

tabStopCount
	"Private - Answer the number of tab-stops in the receiver."

	| count |
	count := UInt32Bytes new.
	Gdip gdipGetStringFormatTabStopCount: self asParameter count: count.
	^count asSignedInteger!

trimming
	"Answer a StringTrimming constant that indicates how the receiver will trim characters 
	from a string that's too large to fit in a layout rectangle."

	^self initializer trimming!

trimming: aStringTrimmingConstant
	"Set the receiver's trimming style to aStringTrimmingConstant.  This indicates how the 
	receiver will trim characters from a string that's too large to fit in a layout rectangle."

	self trimming == aStringTrimmingConstant ifTrue: [^self].
	self initializer trimmingOf: self set: aStringTrimmingConstant! !
!Graphics.Gdiplus.StringFormat categoriesForMethods!
alignment!accessing!public! !
alignment:!accessing!public! !
centered!accessing!public! !
characterRanges!accessing!public! !
clone!copying!public! !
digitSubstitution!accessing!public! !
digitSubstitution:!accessing!public! !
far!accessing!public! !
flags!accessing!public! !
flags:!accessing!public! !
hotkeyPrefix!accessing!public! !
hotkeyPrefix:!accessing!public! !
initializerClass!private!realizing/unrealizing! !
isGenericDefault!public!testing! !
isGenericTypographic!public!testing! !
language!accessing!public! !
lineAlignment!accessing!public! !
lineAlignment:!accessing!public! !
measurableCharacterRanges!accessing!public! !
measurableCharacterRanges:!accessing!public! !
near!accessing!public! !
tabOffsets!accessing!public! !
tabOffsets:!accessing!public! !
tabStopCount!accessing!private! !
trimming!accessing!public! !
trimming:!accessing!public! !
!

!Graphics.Gdiplus.StringFormat class methodsFor!

centered
	"Answer an instance of the receiver with horizontal and vertical centering."

	^self new centered!

far
	"Answer an instance of the receiver with horizontal far alignment."

	^self new far!

flags: formatFlags
	"Answer an instance of the receiver specified by formatFlags and using the user's default language."

	^self flags: formatFlags language: OS.NlsConstants.LANG_NEUTRAL!

flags: formatFlags language: languageId
	"Answer an instance of the receiver whose characteristics are set by <integer> formatFlags (zero or more StringFormatFlags constants) and the specified <integer> language id."

	^self fromInitializer: (StringFormatInitializer flags: formatFlags language: languageId)!

genericDefault
	^self fromInitializer: StringFormatInitializer genericDefault!

genericTypographic
	^self fromInitializer: StringFormatInitializer genericTypographic!

near
	"Answer an instance of the receiver with horizontal near alignment."

	^self new near!

new
	"Answer an instance of the receiver with no format flags set and which uses the user's default language."

	^self flags: 0 language: OS.NlsConstants.LANG_NEUTRAL!

onPreStripImage
	"Private -  Allow the receiver and subclasses to be stripped by clearing lazy initialized class variables
	which hold sub-instance of the receiver."

	self uninitialize! !
!Graphics.Gdiplus.StringFormat class categoriesForMethods!
centered!instance creation!public! !
far!instance creation!public! !
flags:!instance creation!public! !
flags:language:!instance creation!public! !
genericDefault!instance creation!public! !
genericTypographic!instance creation!public! !
near!instance creation!public! !
new!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
!

