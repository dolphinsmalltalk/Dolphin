"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.StringFormatInitializer subclass: #'Graphics.Gdiplus.StringFormatFromFlagsInitializer'
	instanceVariableNames: 'flags language alignment lineAlignment trimming digitSubstitution hotkeyPrefix tabOffsets characterRanges'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.StringFormatFromFlagsInitializer guid: (Core.GUID fromString: '{f4b7aa82-5fd1-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.StringFormatFromFlagsInitializer comment: ''!
!Graphics.Gdiplus.StringFormatFromFlagsInitializer methodsFor!

= anObject
	^self == anObject or: 
			[super = anObject and: 
					[flags = anObject flags and: 
							[language = anObject language and: 
									[alignment = anObject alignment and: 
											[lineAlignment = anObject lineAlignment and: 
													[trimming = anObject trimming and: 
															[digitSubstitution = anObject digitSubstitution and: 
																	[hotkeyPrefix = anObject hotkeyPrefix
																		and: [tabOffsets = anObject tabOffsets and: [characterRanges = anObject characterRanges]]]]]]]]]]!

alignment
	^alignment!

alignmentOf: aStringFormat set: aStringAlignmentConstant
	Gdip gdipSetStringFormatAlign: aStringFormat handle
		align: (alignment := aStringAlignmentConstant ?? StringAlignmentNear)!

applyAdditionalAttributes: aHandle
	alignment == StringAlignmentNear ifFalse: [Gdip gdipSetStringFormatAlign: aHandle align: alignment].
	lineAlignment == StringAlignmentNear
		ifFalse: [Gdip gdipSetStringFormatLineAlign: aHandle align: lineAlignment].
	trimming == StringTrimmingCharacter
		ifFalse: [Gdip gdipSetStringFormatTrimming: aHandle trimming: trimming].
	digitSubstitution == StringDigitSubstituteUser
		ifFalse: 
			[Gdip
				gdipSetStringFormatDigitSubstitution: aHandle
				language: language
				substitute: digitSubstitution].
	hotkeyPrefix == HotkeyPrefixNone
		ifFalse: [Gdip gdipSetStringFormatHotkeyPrefix: aHandle hotkeyPrefix: hotkeyPrefix].
	tabOffsets isEmpty
		ifFalse: 
			[Gdip
				gdipSetStringFormatTabStops: aHandle
				firstTabOffset: 0
				count: tabOffsets size
				tabStops: tabOffsets].
	characterRanges = #() ifFalse: [self setMeasurableCharacterRanges: aHandle]!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip
		gdipCreateStringFormat: flags
		language: language
		format: gpHandle.
	^gpHandle!

characterRanges
	^characterRanges!

digitSubstitution
	^digitSubstitution!

digitSubstitutionOf: aStringFormat set: aStringDigitSubstituteConstant
	Gdip
		gdipSetStringFormatDigitSubstitution: aStringFormat handle
		language: language
		substitute: (digitSubstitution := aStringDigitSubstituteConstant ?? StringDigitSubstituteUser)!

flags
	^flags!

flags: flagsInteger language: languageInteger
	flags := flagsInteger.
	language := languageInteger.
	lineAlignment := alignment := StringAlignmentNear.
	trimming := StringTrimmingCharacter.
	digitSubstitution := StringDigitSubstituteUser.
	hotkeyPrefix := HotkeyPrefixNone.
	tabOffsets := #().
	characterRanges := #().
	^self!

flagsOf: aStringFormat set: anInteger
	Gdip gdipSetStringFormatFlags: aStringFormat handle flags: (flags := anInteger ?? 0)!

hash
	^(((((((((super hash + tabOffsets hash) hashMultiply + characterRanges hash) hashMultiply
		+ digitSubstitution hash) hashMultiply
		+ hotkeyPrefix hash) hashMultiply
		+ trimming hash) hashMultiply
		+ language hash) hashMultiply
		+ alignment hash) hashMultiply
		+ lineAlignment hash) hashMultiply
		+ flags hash) hashMultiply!

hotkeyPrefix
	^hotkeyPrefix!

hotkeyPrefixOf: aStringFormat set: aHotkeyPrefixConstant
	Gdip gdipSetStringFormatHotkeyPrefix: aStringFormat handle
		hotkeyPrefix: (hotkeyPrefix := aHotkeyPrefixConstant ?? HotkeyPrefixNone)!

initializeFromHandle: aGpStringFormatHandle
	"Private - Cache all the attributes of the native Gdiplus StringFormat identified by the specified <External.Handle> into the receiver."

	| buf tabCount |
	buf := ByteArray newFixed: 8.
	Gdip gdipGetStringFormatFlags: aGpStringFormatHandle flags: buf.
	flags := buf dwordAtOffset: 0.
	Gdip gdipGetStringFormatAlign: aGpStringFormatHandle align: buf.
	alignment := buf sdwordAtOffset: 0.
	Gdip gdipGetStringFormatLineAlign: aGpStringFormatHandle align: buf.
	lineAlignment := buf sdwordAtOffset: 0.
	Gdip gdipGetStringFormatTrimming: aGpStringFormatHandle trimming: buf.
	trimming := buf sdwordAtOffset: 0.
	Gdip
		gdipGetStringFormatDigitSubstitution: aGpStringFormatHandle
		language: buf
		substitute: buf yourAddress + 4.
	language := buf wordAtOffset: 0.
	digitSubstitution := buf sdwordAtOffset: 4.
	Gdip gdipGetStringFormatHotkeyPrefix: aGpStringFormatHandle hotkeyPrefix: buf.
	hotkeyPrefix := buf sdwordAtOffset: 0.
	Gdip gdipGetStringFormatTabStopCount: aGpStringFormatHandle count: buf.
	tabCount := buf sdwordAtOffset: 0.
	tabCount == 0
		ifTrue: [tabOffsets := #()]
		ifFalse: 
			[| first |
			tabOffsets := FLOATArray new: tabCount.
			Gdip
				gdipGetStringFormatTabStops: aGpStringFormatHandle
				count: tabCount
				firstTabOffset: buf
				tabStops: tabOffsets.
			first := buf floatAtOffset: 0.
			first = 0 ifFalse: [tabOffsets := tabOffsets collect: [:each | each + first]]].
	"Hmmm, we can't retrieve character ranges, only the count, so this StringFormat attribute cannot be deduced from the handle."
	characterRanges := #()!

language
	^language!

lineAlignment
	^lineAlignment!

lineAlignmentOf: aStringFormat set: aStringAlignmentConstant
	Gdip gdipSetStringFormatLineAlign: aStringFormat handle
		align: (lineAlignment := aStringAlignmentConstant ?? StringAlignmentNear)!

measurableCharacterRangesOf: aGdiplusStringFormat set: aCollectionOfIntervals
	"Note adjustment from (assumed) Smalltalk convention of one-based starting index in the interval"

	characterRanges := aCollectionOfIntervals asArray.
	self setMeasurableCharacterRanges: aGdiplusStringFormat!

printAttributesOn: aStream
	| separator |
	separator := (flags == 0 and: [language == OS.NlsConstants.LANG_NEUTRAL])
				ifTrue: 
					[
					[separator := '; '.
					'']]
				ifFalse: 
					[aStream nextPutAll: 'flags: '.
					flags == 0
						ifTrue: [aStream nextPutAll: '0']
						ifFalse: 
							[| consts |
							consts := FormatFlagNames associations select: [:each | flags allMask: each key].
							consts size == 1
								ifTrue: [aStream nextPutAll: consts first value]
								ifFalse: 
									[aStream nextPutAll: '##('.
									consts do: [:each | aStream nextPutAll: each value] separatedBy: [aStream nextPut: $|].
									aStream nextPut: $)]].
					language == OS.NlsConstants.LANG_NEUTRAL
						ifFalse: 
							[aStream
								nextPutAll: ' language: ';
								print: language].
					'; '].
	alignment == StringAlignmentNear
		ifFalse: 
			[aStream
				nextPutAll: separator value;
				nextPutAll: #aligment:;
				space.
			self
				printEnum: alignment
				names: StringAlignmentNames
				on: aStream].
	lineAlignment == StringAlignmentNear
		ifFalse: 
			[aStream
				nextPutAll: separator value;
				nextPutAll: #lineAlignment:;
				space.
			self
				printEnum: lineAlignment
				names: StringAlignmentNames
				on: aStream].
	trimming == StringTrimmingCharacter
		ifFalse: 
			[aStream
				nextPutAll: separator value;
				nextPutAll: #trimming:;
				space.
			self
				printEnum: trimming
				names: StringTrimmingNames
				on: aStream].
	digitSubstitution == StringDigitSubstituteUser
		ifFalse: 
			[aStream
				nextPutAll: separator value;
				nextPutAll: #digitSubstitution:;
				space.
			self
				printEnum: digitSubstitution
				names: StringDigitSubstitutionNames
				on: aStream].
	hotkeyPrefix == HotkeyPrefixNone
		ifFalse: 
			[aStream
				nextPutAll: separator value;
				nextPutAll: #hotkeyPrefix:;
				space.
			self
				printEnum: hotkeyPrefix
				names: HotkeyPrefixNames
				on: aStream].
	tabOffsets isEmpty
		ifFalse: 
			[aStream
				nextPutAll: separator value;
				nextPutAll: #tabOffsets:;
				space;
				print: tabOffsets].
	characterRanges isEmpty
		ifFalse: 
			[aStream
				nextPutAll: separator value;
				nextPutAll: #measurableCharacterRanges:;
				space;
				print: characterRanges]!

setMeasurableCharacterRanges: aGpStringFormat
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
	Gdip
		gdipSetStringFormatMeasurableCharacterRanges: aGpStringFormat asParameter
		rangeCount: characterRanges size
		ranges: charRanges!

tabOffsets
	^tabOffsets!

tabOffsetsOf: aStringFormat set: aRealArray
	tabOffsets := FLOATArray marshal: aRealArray.
	Gdip
		gdipSetStringFormatTabStops: aStringFormat handle
		firstTabOffset: 0
		count: tabOffsets size
		tabStops: tabOffsets!

trimming
	^trimming!

trimmingOf: aStringFormat set: aStringTrimmingConstant
	Gdip gdipSetStringFormatTrimming: aStringFormat handle
		trimming: (trimming := aStringTrimmingConstant ?? StringTrimmingCharacter)! !
!Graphics.Gdiplus.StringFormatFromFlagsInitializer categoriesForMethods!
=!comparing!public! !
alignment!attributes!public! !
alignmentOf:set:!attributes!public! !
applyAdditionalAttributes:!attributes!private!realizing/unrealizing! !
basicCreateHandle!private!realizing/unrealizing! !
characterRanges!attributes!public! !
digitSubstitution!attributes!public! !
digitSubstitutionOf:set:!attributes!public! !
flags!attributes!public! !
flags:language:!initializing!private! !
flagsOf:set:!attributes!public! !
hash!comparing!public! !
hotkeyPrefix!attributes!public! !
hotkeyPrefixOf:set:!attributes!public! !
initializeFromHandle:!initializing!private! !
language!attributes!public! !
lineAlignment!attributes!public! !
lineAlignmentOf:set:!attributes!public! !
measurableCharacterRangesOf:set:!attributes!public! !
printAttributesOn:!printing!private! !
setMeasurableCharacterRanges:!helpers!private! !
tabOffsets!attributes!public! !
tabOffsetsOf:set:!attributes!public! !
trimming!attributes!public! !
trimmingOf:set:!attributes!public! !
!

!Graphics.Gdiplus.StringFormatFromFlagsInitializer class methodsFor!

flags: flagsNumber language: languageNumber
	^self new flags: flagsNumber language: languageNumber! !
!Graphics.Gdiplus.StringFormatFromFlagsInitializer class categoriesForMethods!
flags:language:!instance creation!public! !
!

