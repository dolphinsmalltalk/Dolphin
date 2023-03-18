"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer
	subclass: #'Graphics.Gdiplus.StringFormatInitializer'
	instanceVariableNames: ''
	classVariableNames: 'GenericDefault GenericTypographic'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'FormatFlagNames'
				-> (IdentityDictionary withAll: {
								-16r80000000 -> 'StringFormatFlagsBypassGDI'.
								16r1 -> 'StringFormatFlagsDirectionRightToLeft'.
								16r2 -> 'StringFormatFlagsDirectionVertical'.
								16r4 -> 'StringFormatFlagsNoFitBlackBox'.
								16r20 -> 'StringFormatFlagsDisplayFormatControl'.
								16r400 -> 'StringFormatFlagsNoFontFallback'.
								16r800 -> 'StringFormatFlagsMeasureTrailingSpaces'.
								16r1000 -> 'StringFormatFlagsNoWrap'.
								16r2000 -> 'StringFormatFlagsLineLimit'.
								16r4000 -> 'StringFormatFlagsNoClip'
							})
		}!
Graphics.Gdiplus.StringFormatInitializer guid: (Core.GUID fromString: '{14ad5dde-0284-402d-bbce-89611bcd32c4}')!
Graphics.Gdiplus.StringFormatInitializer isNonInstantiable: true!
Graphics.Gdiplus.StringFormatInitializer comment: ''!
!Graphics.Gdiplus.StringFormatInitializer methodsFor!

= anObject
	^self species == anObject species!

alignment
	^StringAlignmentNear!

alignmentOf: aStringFormat set: aStringAlignmentConstant
	self subclassResponsibility!

characterRanges
	^#()!

digitSubstitution
	^StringDigitSubstituteUser!

digitSubstitutionOf: aStringFormat set: aStringDigitSubstituteConstant
	self subclassResponsibility!

flags
	"Answer the <integer> StringFormat flags; a combination of flags from the StringFormatFlags enumeration."

	^0!

flagsOf: aStringFormat set: anInteger
	self subclassResponsibility!

hash
	^self species hash!

hotkeyPrefix
	^HotkeyPrefixNone!

hotkeyPrefixOf: aStringFormat set: aHotkeyPrefixConstant
	self subclassResponsibility!

isGenericDefault
	^false!

isGenericTypographic
	^false!

language
	^OS.NlsConstants.LANG_NEUTRAL!

lineAlignment
	^StringAlignmentNear!

lineAlignmentOf: aStringFormat set: aStringAlignmentConstant
	self subclassResponsibility!

measurableCharacterRangesOf: aGdiplusStringFormat set: aCollectionOfIntervals
	self subclassResponsibility!

tabOffsets
	^#()!

tabOffsetsOf: aStringFormat set: aRealArray
	self subclassResponsibility!

trimming
	^StringTrimmingCharacter!

trimmingOf: aStringFormat set: aStringTrimmingConstant
	self subclassResponsibility! !
!Graphics.Gdiplus.StringFormatInitializer categoriesForMethods!
=!comparing!public! !
alignment!accessing!public! !
alignmentOf:set:!attributes!public! !
characterRanges!attributes!public! !
digitSubstitution!accessing!public! !
digitSubstitutionOf:set:!attributes!public! !
flags!attributes!public! !
flagsOf:set:!attributes!public! !
hash!comparing!public! !
hotkeyPrefix!attributes!public! !
hotkeyPrefixOf:set:!attributes!public! !
isGenericDefault!public!testing! !
isGenericTypographic!public!testing! !
language!attributes!public! !
lineAlignment!attributes!public! !
lineAlignmentOf:set:!attributes!public! !
measurableCharacterRangesOf:set:!accessing!public! !
tabOffsets!attributes!public! !
tabOffsetsOf:set:!attributes!public! !
trimming!attributes!public! !
trimmingOf:set:!attributes!public! !
!

!Graphics.Gdiplus.StringFormatInitializer class methodsFor!

cloneHandle: aHandle
	| clone |
	clone := Handle new.
	Gdip gdipCloneStringFormat: aHandle newFormat: clone.
	^clone!

flags: flagsNumber language: languageNumber
	^StringFormatFromFlagsInitializer basicNew flags: flagsNumber language: languageNumber!

freeHandle: aHandle
	Gdip gdipDeleteStringFormat: aHandle!

genericDefault
	^GenericDefault ifNil: [GenericDefault := StringFormatGenericDefaultInitializer basicNew]!

genericTypographic
	^GenericTypographic
		ifNil: [GenericTypographic := StringFormatGenericTypographicInitializer basicNew]!

initialize
	"
		self initialize
	"

	| formatFlagNames |
	formatFlagNames := IdentityDictionary new.
	(Gdiplus associations select: [:each | each key beginsWith: 'StringFormatFlags'])
		do: [:each | formatFlagNames at: each value put: each key].
	self addClassConstant: 'FormatFlagNames' value: formatFlagNames!

onPreStripImage
	"Private -  Allow the receiver and subclasses to be stripped by clearing lazy initialized class variables
	which hold sub-instance of the receiver."

	self uninitialize!

stbConvertFrom: anSTBClassFormat
	^
	[:data |
	StringFormatFromFlagsInitializer flags: (data at: 2)
		language: (data at: 3) ?? OS.NlsConstants.LANG_NEUTRAL]!

stbVersion
	"1: pathPoints now stored as a POINTLArray to reduce marshalling/unmarshalling overhead."

	^1!

uninitialize
	GenericDefault := GenericTypographic := nil! !
!Graphics.Gdiplus.StringFormatInitializer class categoriesForMethods!
cloneHandle:!private!realizing/unrealizing! !
flags:language:!instance creation!public! !
freeHandle:!private!realizing/unrealizing! !
genericDefault!instance creation!public! !
genericTypographic!instance creation!public! !
initialize!class initialization!public! !
onPreStripImage!class hierarchy-removing!private! !
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
uninitialize!class hierarchy-removing!private! !
!

