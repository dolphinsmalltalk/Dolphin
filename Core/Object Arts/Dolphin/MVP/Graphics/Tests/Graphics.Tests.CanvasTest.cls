"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Graphics.Tests.CanvasTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Tests.CanvasTest guid: (Core.GUID fromString: '{f582d7b1-304e-45af-a9fd-315ee37dd609}')!

Graphics.Tests.CanvasTest comment: ''!

!Graphics.Tests.CanvasTest methodsFor!

testFont
	"#1390"

	| canvas font newFont oldFont |
	canvas := Canvas forDesktop.
	font := canvas font.
	self denyIsNil: font.
	self assert: font equals: Font system.
	newFont := Font name: 'Arial' pointSize: 10.
	oldFont := canvas font: newFont.
	self denyIsNil: oldFont.
	self assert: font equals: oldFont.
	self assert: canvas font equals: newFont.
	font := canvas font: oldFont.
	self assert: font series identicalTo: newFont series.
	self assert: canvas font identicalTo: oldFont!

testFontNames
	| subject fontFamilies |
	subject := Canvas forDesktop.
	fontFamilies := subject fontNames.
	self assert: (fontFamilies includes: 'Times New Roman')!

testOutlineTextMetrics
	"For #1349"

	| font canvas otm last |
	(Canvas canUnderstand: #outlineTextMetrics) ifFalse: [^self].
	font := Font name: 'Comic Sans MS' pointSize: 22.
	canvas := Canvas forDisplay.
	canvas font: font.
	"Get the outline text metrics"
	otm := canvas outlineTextMetrics.

	"Although the TEXTMETRIC structure is of size 60 bytes, its last field is a BYTE so the 
	last 3 bytes are actually padding. This means that they may contain random data, and
	so the structures may not be strictly equal based on a byte-by-byte comparison."
	last := TEXTMETRICW._OffsetOf_tmCharSet + 1.
	self assert: (canvas textMetrics bytes copyFrom: 1 to: last)
		equals: (otm otmTextMetrics bytes copyFrom: 1 to: last).
	"Canvas is no longer needed"
	canvas free.
	"The tricky bit about getting the OTM is the way that the structure varies in size and 
	the certain strings are then stored in the variable length portion at the end, the offset
	of the strings being specified by other fields."
	Locale systemDefault englishLanguageName = 'English'
		ifTrue: 
			[self assert: otm styleName equals: 'Regular'.
			self assert: otm fullName equals: 'Microsoft Comic Sans'].
	self assert: otm faceName equals: font name.
	self assert: otm familyName equals: font name! !

!Graphics.Tests.CanvasTest categoriesForMethods!
testFont!public!unit tests! !
testFontNames!public!unit tests! !
testOutlineTextMetrics!public!unit tests! !
!

