"Filed out from Dolphin Smalltalk"!

GdiplusTests subclass: #GdiplusStringFormatTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusStringFormatTest guid: (GUID fromString: '{be3a3a6c-6f04-4b76-b60c-bde35099c105}')!

GdiplusStringFormatTest comment: ''!

!GdiplusStringFormatTest categoriesForClass!Unclassified! !

!GdiplusStringFormatTest methodsFor!

subjectClass
	^GdiplusStringFormat!

testAlignment
	model := self subjectClass new.
	self assert: model alignment equals: StringAlignmentNear.
	model alignment: StringAlignmentCenter.
	self assert: model alignment equals: StringAlignmentCenter.
	self assertPersistedValid!

testFlags
	model := self subjectClass new.
	self assert: model flags equals: 0.
	model flags: StringFormatFlagsNoClip.
	self assert: model flags equals: StringFormatFlagsNoClip.
	self assertPersistedValid!

testFromHandle
	model := self subjectClass fromOwnedHandle: self subjectClass new detachHandle.
	self assert: model flags equals: 0.
	self assert: model alignment equals: StringAlignmentNear.
	self assert: model lineAlignment equals: StringAlignmentNear.
	self assert: model trimming equals: StringTrimmingCharacter!

testGenericDefault
	model := self subjectClass genericDefault.
	self deny: model isGenericTypographic.
	self assert: model isGenericDefault.
	self verifyGenericDefaultAttributes: model.
	self assertPersistedValid!

testGenericTypographic
	model := self subjectClass genericTypographic.
	self assert: model isGenericTypographic.
	self deny: model isGenericDefault.
	self verifyGenericTypographicAttributes: model.
	self assertPersistedValid!

testLineAlignment
	model := self subjectClass new.
	self assert: model lineAlignment equals: StringAlignmentNear.
	model lineAlignment: StringAlignmentFar.
	self assert: model lineAlignment equals: StringAlignmentFar.
	self assertPersistedValid!

testMeasurableCharacterRanges
	| charRanges bitmap graphics charRangeRegions rect font string rects |
	self assert: self subjectClass genericDefault measurableCharacterRangeCount equals: 0.
	self assert: self subjectClass genericTypographic measurableCharacterRangeCount equals: 0.
	bitmap := GdiplusBitmap
				width: 160
				height: 160
				format: PixelFormat32bppARGB.
	"Avoid DPI scaling differences by working with a 96-dpi surface"
	bitmap resolution: 96 @ 96.
	graphics := bitmap graphics.
	model := self subjectClass new.
	"Note that the char ranges are specified as UTF-16 code point positions"
	charRanges := {5 to: 9. 17 to: 18. 19 to: 19. 31 to: 48}.
	model measurableCharacterRanges: charRanges.
	self assert: model measurableCharacterRangeCount equals: charRanges size.
	rect := 20 @ 20 extent: 130 @ 130.
	font := GdiplusFont name: 'Segoe UI Emoji' pointSize: 14.0.
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
		brush: GdiplusSolidBrush blue.
	graphics drawRectangle: rect.
	charRangeRegions with: {Color red. Color green. Color yellow. Color blue}
		do: [:eachRegion :eachColor | graphics fillRegion: eachRegion brush: (GdiplusSolidBrush color: (eachColor alpha: 100))].
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
	model := self subjectClass genericDefault.
	self assert: model isGenericDefault.
	self assert: model tabOffsets equals: #().
	model := model clone.
	offsets := #(1.25 0.5 0.25 0.75).
	model tabOffsets: offsets.
	self assert: model tabOffsets equals: offsets.
	model := self subjectClass new.
	self assert: model tabOffsets equals: #().
	model tabOffsets: #(1.5).
	self assert: model tabOffsets equals: #(1.5).
	model tabOffsets: offsets.
	self assert: model tabOffsets equals: offsets!

testTrimming
	model := self subjectClass new.
	self assert: model trimming equals: StringTrimmingCharacter.
	model trimming: StringTrimmingEllipsisPath.
	self assert: model trimming equals: StringTrimmingEllipsisPath.
	self assertPersistedValid free!

verifyGenericDefaultAttributes: aStringFormat
	"Private - A generic default StringFormat object has the following characteristics:

	- String format flags: 0"

	self assert: aStringFormat flags equals: 0.

	"- Character alignment and line alignment are set to StringAlignmentNear."
	self assert: aStringFormat alignment equals: StringAlignmentNear.
	self assert: aStringFormat lineAlignment equals: StringAlignmentNear.
	"- Number of tab stops is set to zero."
	self assert: aStringFormat tabStopCount equals: 0.
	self assert: aStringFormat tabOffsets equals: #().
	"- String trimming is set to character."
	self assert: aStringFormat trimming equals: StringTrimmingCharacter.
	"No measurable character ranges set"
	self assert: aStringFormat measurableCharacterRangeCount equals: 0!

verifyGenericTypographicAttributes: aStringFormat
	"Private - A generic, typographic StringFormat object has the following characteristics:

	- String format flags StringFormatFlagsLineLimit, StringFormatFlagsNoClip, and StringFormatFlagsNoFitBlackBox are set."

	self assert: aStringFormat flags
		equals: StringFormatFlagsLineLimit | StringFormatFlagsNoClip | StringFormatFlagsNoFitBlackBox.

	"- Character alignment and line alignment are set to StringAlignmentNear."
	self assert: aStringFormat alignment equals: StringAlignmentNear.
	self assert: aStringFormat lineAlignment equals: StringAlignmentNear.
	"- Number of tab stops is set to zero."
	self assert: aStringFormat tabStopCount equals: 0.
	self assert: aStringFormat tabOffsets equals: #().
	"- String trimming is set to StringTrimmingNone."
	self assert: aStringFormat trimming equals: StringTrimmingNone.
	"No measurable character ranges set"
	self assert: aStringFormat measurableCharacterRangeCount equals: 0! !

!GdiplusStringFormatTest categoriesForMethods!
subjectClass!constants!private! !
testAlignment!public!unit tests! !
testFlags!public!unit tests! !
testFromHandle!public!unit tests! !
testGenericDefault!public!unit tests! !
testGenericTypographic!public!unit tests! !
testLineAlignment!public!unit tests! !
testMeasurableCharacterRanges!public!unit tests! !
testTabOffsets!public!unit tests! !
testTrimming!public!unit tests! !
verifyGenericDefaultAttributes:!private! !
verifyGenericTypographicAttributes:!private! !
!

