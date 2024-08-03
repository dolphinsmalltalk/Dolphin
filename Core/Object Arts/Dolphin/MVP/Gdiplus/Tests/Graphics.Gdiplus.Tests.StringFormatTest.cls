"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GdiplusObjectTest
	subclass: #'Graphics.Gdiplus.Tests.StringFormatTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.StringFormatTest guid: (Core.GUID fromString: '{fe02342a-86ba-4d11-91fa-53be23c8605e}')!

Graphics.Gdiplus.Tests.StringFormatTest comment: ''!

!Graphics.Gdiplus.Tests.StringFormatTest methodsFor!

subjectClass
	^StringFormat!

tabOffsetsOf: aStringFormat
	| count array first |
	count := aStringFormat tabStopCount.
	first := FLOAT new.
	array := FLOATArray new: count.
	Gdip
		gdipGetStringFormatTabStops: aStringFormat asParameter
		count: count
		firstTabOffset: first
		tabStops: array.
	count == 0 ifTrue: [^{}].
	first := first value.
	first = 0 ifFalse: [array at: 1 put: (array at: 1) + first].
	^array!

testAlignment
	model := StringFormat new.
	self assert: model alignment equals: StringAlignmentNear.
	model alignment: StringAlignmentCenter.
	self assert: model alignment equals: StringAlignmentCenter.
	self assertPersistedValid free.
	self assertClonedValid free.
	model alignment: nil.
	self assert: model alignment equals: StringAlignmentNear!

testDigitSubstitution
	model := StringFormat new.
	self assert: model digitSubstitution equals: StringDigitSubstituteUser.
	model digitSubstitution: StringDigitSubstituteNational.
	self assert: model digitSubstitution equals: StringDigitSubstituteNational.
	self assertPersistedValid free.
	self assertClonedValid free.
	model digitSubstitution: nil.
	self assert: model lineAlignment equals: StringDigitSubstituteUser!

testFlags
	model := StringFormat new.
	self assert: model flags equals: 0.
	model flags: StringFormatFlagsNoClip.
	self assert: model flags equals: StringFormatFlagsNoClip.
	self assertPersistedValid free.
	self assertClonedValid free.
	model flags: nil.
	self assert: model flags equals: 0!

testFromHandle
	model := StringFormat fromOwnedHandle: StringFormat new detachHandle.
	self assert: model flags equals: 0.
	self assert: model alignment equals: StringAlignmentNear.
	self assert: model lineAlignment equals: StringAlignmentNear.
	self assert: model trimming equals: StringTrimmingCharacter!

testGenericDefault
	| genericHandle |
	model := StringFormat genericDefault.
	self deny: model isGenericTypographic.
	self assert: model isGenericDefault.
	self verifyGenericDefaultAttributes: model.
	"If we now modify it, we should get an equivalent - in theory"
	genericHandle := model handle.
	model alignment: nil.
	self deny: model handle equals: genericHandle.
	self verifyGenericDefaultAttributes: model.
	self assertPersistedValid free.
	self assertClonedValid free!

testGenericDerived
	| generic temp |
	generic := StringFormat genericTypographic.
	self verifyGenericTypographicAttributes: generic.
	model := StringFormat genericTypographic.
	self verifyGenericTypographicAttributes: model.
	model flags: (model flags maskClear: StringFormatFlagsLineLimit).
	temp := model handle.
	self deny: temp equals: generic handle.
	self deny: model initializer identicalTo: generic initializer.
	model alignment: StringAlignmentCenter.
	self assert: model handle equals: temp.
	self verifyGenericTypographicAttributes: generic.
	"The derived format has all the generic typographic attribute values, except the flags"
	self assert: model flags equals: StringFormatFlagsNoFitBlackBox | StringFormatFlagsNoClip.
	self assert: model alignment equals: StringAlignmentCenter.
	self assert: model lineAlignment equals: StringAlignmentNear.
	self assert: model language equals: NlsConstants.LANG_NEUTRAL.
	self assert: model digitSubstitution equals: StringDigitSubstituteUser.
	self assert: model hotkeyPrefix equals: HotkeyPrefixNone.
	self assert: model tabStopCount equals: 0.
	self assert: model tabOffsets equals: #().
	self assert: model trimming equals: StringTrimmingNone.
	self assert: model measurableCharacterRanges equals: #().
	"Free the format so we can check that the attributes are restored when re-realized"
	model free.
	"Create a temporary initializer to query all the attributes from the recreated handle."
	self deny: model handle equals: generic handle.
	temp := StringFormatFromFlagsInitializer fromHandle: model handle.
	self assert: temp flags equals: StringFormatFlagsNoFitBlackBox | StringFormatFlagsNoClip.
	self assert: temp alignment equals: StringAlignmentCenter.
	self assert: temp lineAlignment equals: StringAlignmentNear.
	self assert: temp language equals: NlsConstants.LANG_NEUTRAL.
	self assert: temp digitSubstitution equals: StringDigitSubstituteUser.
	self assert: temp hotkeyPrefix equals: HotkeyPrefixNone.
	self assert: temp tabOffsets equals: #().
	self assert: temp trimming equals: StringTrimmingNone.
	self assert: temp characterRanges equals: #().
	self assertPersistedValid free.
	self assertClonedValid free!

testGenericTypographic
	| genericHandle |
	model := StringFormat genericTypographic.
	self assert: model isGenericTypographic.
	self deny: model isGenericDefault.
	self verifyGenericTypographicAttributes: model.
	"If we now modify it, we should get an equivalent - in theory"
	genericHandle := model handle.
	model alignment: nil.
	self deny: model handle equals: genericHandle.
	self verifyGenericTypographicAttributes: model.
	self assertPersistedValid free.
	self assertClonedValid free!

testHotkeyPrefix
	model := StringFormat new.
	self assert: model hotkeyPrefix equals: HotkeyPrefixNone.
	model hotkeyPrefix: HotkeyPrefixShow.
	self assert: model hotkeyPrefix equals: HotkeyPrefixShow.
	self assertPersistedValid free.
	self assertClonedValid free.
	model hotkeyPrefix: nil.
	self assert: model hotkeyPrefix equals: HotkeyPrefixNone!

testLineAlignment
	model := StringFormat new.
	self assert: model lineAlignment equals: StringAlignmentNear.
	model lineAlignment: StringAlignmentFar.
	self assert: model lineAlignment equals: StringAlignmentFar.
	self assertPersistedValid free.
	self assertClonedValid free.
	model lineAlignment: nil.
	self assert: model lineAlignment equals: StringAlignmentNear!

testMeasurableCharacterRanges
	| charRanges bitmap graphics charRangeRegions rect font string rects |
	self assert: StringFormat genericDefault characterRanges equals: #().
	self assert: StringFormat genericTypographic characterRanges equals: #().
	bitmap := Bitmap
				width: 160
				height: 160
				format: PixelFormat32bppARGB.
	"Avoid DPI scaling differences by working with a 96-dpi surface"
	bitmap resolution: 96 @ 96.
	graphics := bitmap graphics.
	model := StringFormat new.
	"Note that the char ranges are specified as UTF-16 code point positions"
	charRanges := {5 to: 9. 17 to: 18. 19 to: 19. 31 to: 48}.
	model measurableCharacterRanges: charRanges.
	self assert: model characterRanges equals: charRanges.
	rect := 20 @ 20 extent: 130 @ 130.
	font := Font name: 'Segoe UI Emoji' pointSize: 14.0.
	"Embedded null should not be displayed, but should not terminate the text (which is why we include it)"
	string := 'The quick, blue 🐬' , Character null , 'easily jumps over the lazy 🐕.'.
	charRangeRegions := graphics
				measureCharacterRanges: string
				font: font
				rect: rect
				format: model.
	graphics
		drawString: string
		font: font
		rect: rect
		format: model
		brush: Brush blue.
	graphics drawRectangle: rect.
	charRangeRegions with: {Color red. Color green. Color yellow. Color blue}
		do: [:eachRegion :eachColor | graphics fillRegion: eachRegion brush: (Brush color: (eachColor alpha: 100))].
	false ifTrue: [bitmap clone showExample].
	rects := charRangeRegions collect: [:each | each bounds: graphics].
	self assert: rects first equals: (59 @ 20 corner: 104 @ 45).
	self assert: rects second origin equals: 66 @ 45.
	"Some variability, depending on host"
	self assert: (rects second corner x between: 89 and: 92).
	self assert: rects second corner y equals: 70.
	self assert: rects third equals: Rectangle new.
	self assert: rects fourth equals: (23 @ 70 corner: 120 @ 120).
	"Should be retained and restored"
	self assertClonedValid.
	self assertPersistedValid.
	self assert: (graphics
				measureCharacterRanges: string
				font: font
				rect: rect
				format: model)
		equals: charRangeRegions.
	graphics free.
	bitmap free!

testTabOffsets
	| offsets copy |
	model := StringFormat genericDefault.
	self assert: model isGenericDefault.
	self assert: model tabOffsets equals: #().
	offsets := #(1.25 0.5 0.25 0.75).
	model tabOffsets: offsets.
	self deny: model isGenericDefault.
	self assert: model tabOffsets equals: offsets.
	self assert: (self tabOffsetsOf: model) equals: offsets.
	model := StringFormat new.
	self assert: model tabOffsets equals: #().
	self assert: (self tabOffsetsOf: model) equals: #().
	model tabOffsets: #(1.5).
	self assert: model tabOffsets equals: #(1.5).
	self assert: (self tabOffsetsOf: model) equals: #(1.5).
	model tabOffsets: offsets.
	self assert: model tabOffsets equals: offsets.
	self assert: (self tabOffsetsOf: model) equals: offsets.
	copy := self assertPersistedValid.
	self assert: (self tabOffsetsOf: model) equals: offsets.
	copy free.
	offsets := #(1.5).
	model tabOffsets: offsets.
	self assert: (self tabOffsetsOf: model) equals: offsets.
	self assert: model tabOffsets equals: offsets.
	copy := self assertClonedValid.
	self assert: (self tabOffsetsOf: model) equals: offsets.
	copy free!

testTrimming
	model := StringFormat new.
	self assert: model trimming equals: StringTrimmingCharacter.
	model trimming: StringTrimmingEllipsisPath.
	self assert: model trimming equals: StringTrimmingEllipsisPath.
	self assertPersistedValid free.
	self assertClonedValid free.
	model trimming: nil.
	self assert: model trimming equals: StringTrimmingCharacter!

verifyEqualToModel: aStringFormat
	super verifyEqualToModel: aStringFormat.
	self assert: aStringFormat alignment equals: model alignment.
	self assert: aStringFormat lineAlignment equals: model lineAlignment.
	self assert: aStringFormat trimming equals: model trimming.
	self assert: aStringFormat digitSubstitution equals: model digitSubstitution.
	self assert: aStringFormat hotkeyPrefix equals: model hotkeyPrefix.
	self assert: aStringFormat tabOffsets equals: model tabOffsets.
	self assert: aStringFormat characterRanges equals: model characterRanges!

verifyGenericDefaultAttributes: aStringFormat
	"Private - A generic default StringFormat object has the following characteristics:

	- String format flags: 0"

	self assert: aStringFormat flags equals: 0.

	"- Character alignment and line alignment are set to StringAlignmentNear."
	self assert: aStringFormat alignment equals: StringAlignmentNear.
	self assert: aStringFormat lineAlignment equals: StringAlignmentNear.
	"- Language ID is set to neutral language, which means that the current language associated with the calling thread is used."
	self assert: aStringFormat language equals: OS.NlsConstants.LANG_NEUTRAL.
	"- String digit substitution is set to StringDigitSubstituteUser."
	self assert: aStringFormat digitSubstitution equals: StringDigitSubstituteUser.
	"- Hot key prefix is set to HotkeyPrefixNone."
	self assert: aStringFormat hotkeyPrefix equals: HotkeyPrefixNone.
	"- Number of tab stops is set to zero."
	self assert: aStringFormat tabStopCount equals: 0.
	self assert: aStringFormat tabOffsets equals: #().
	"- String trimming is set to character."
	self assert: aStringFormat trimming equals: StringTrimmingCharacter.
	"No measurable character ranges set"
	self assert: aStringFormat measurableCharacterRanges equals: #()!

verifyGenericTypographicAttributes: aStringFormat
	"Private - A generic, typographic StringFormat object has the following characteristics:

	- String format flags StringFormatFlagsLineLimit, StringFormatFlagsNoClip, and StringFormatFlagsNoFitBlackBox are set."

	self assert: aStringFormat flags
		equals: StringFormatFlagsLineLimit | StringFormatFlagsNoClip | StringFormatFlagsNoFitBlackBox.

	"- Character alignment and line alignment are set to StringAlignmentNear."
	self assert: aStringFormat alignment equals: StringAlignmentNear.
	self assert: aStringFormat lineAlignment equals: StringAlignmentNear.
	"- Language ID is set to neutral language, which means that the current language associated with the calling thread is used."
	self assert: aStringFormat language equals: OS.NlsConstants.LANG_NEUTRAL.
	"- String digit substitution is set to StringDigitSubstituteUser."
	self assert: aStringFormat digitSubstitution equals: StringDigitSubstituteUser.
	"- Hot key prefix is set to HotkeyPrefixNone."
	self assert: aStringFormat hotkeyPrefix equals: HotkeyPrefixNone.
	"- Number of tab stops is set to zero."
	self assert: aStringFormat tabStopCount equals: 0.
	self assert: aStringFormat tabOffsets equals: #().
	"- String trimming is set to StringTrimmingNone."
	self assert: aStringFormat trimming equals: StringTrimmingNone.
	"No measurable character ranges set"
	self assert: aStringFormat measurableCharacterRanges equals: #()! !

!Graphics.Gdiplus.Tests.StringFormatTest categoriesForMethods!
subjectClass!constants!private! !
tabOffsetsOf:!helpers!private! !
testAlignment!public!unit tests! !
testDigitSubstitution!public!unit tests! !
testFlags!public!unit tests! !
testFromHandle!public!unit tests! !
testGenericDefault!public!unit tests! !
testGenericDerived!public!unit tests! !
testGenericTypographic!public!unit tests! !
testHotkeyPrefix!public!unit tests! !
testLineAlignment!public!unit tests! !
testMeasurableCharacterRanges!public!unit tests! !
testTabOffsets!public!unit tests! !
testTrimming!public!unit tests! !
verifyEqualToModel:!helpers!private!unit tests! !
verifyGenericDefaultAttributes:!helpers!private! !
verifyGenericTypographicAttributes:!helpers!private! !
!

