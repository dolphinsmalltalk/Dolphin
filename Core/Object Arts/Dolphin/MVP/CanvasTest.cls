"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #CanvasTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CanvasTest guid: (GUID fromString: '{f582d7b1-304e-45af-a9fd-315ee37dd609}')!
CanvasTest comment: ''!
!CanvasTest categoriesForClass!Unclassified! !
!CanvasTest methodsFor!

testFont
	"#1390"

	| canvas font newFont oldFont |
	canvas := Canvas forDesktop.
	font := canvas font.
	self assert: font notNil.
	newFont := Font name: 'Arial' pointSize: 10.
	oldFont := canvas font: newFont.
	self assert: oldFont notNil.
	self assert: font = oldFont.
	self assert: canvas font = newFont.
	font := canvas font: oldFont.
	self assert: font == newFont.
	self assert: canvas font == oldFont!

testOutlineTextMetrics
	"For #1349"

	| font canvas otm |
	(Canvas canUnderstand: #outlineTextMetrics) ifFalse: [^self].
	font := Font name: 'Comic Sans MS' pointSize: 22.
	canvas := Canvas forDisplay.
	canvas font: font.
	"Get the outline text metrics"
	otm := canvas outlineTextMetrics.
	"Although the TEXTMETRIC structure is of size 56 bytes, its last field is a BYTE so the 
	last 3 bytes are actually padding. This means that they may contain random data, and
	so the structures may not be strictly equal based on a byte-by-byte comparison."
	self assert: (canvas textMetrics bytes copyFrom: 1 to: 53) 
				= (otm otmTextMetrics bytes copyFrom: 1 to: 53).
	"Canvas is no longer needed"
	canvas free.
	"The tricky bit about getting the OTM is the way that the structure varies in size and 
	the certain strings are then stored in the variable length portion at the end, the offset
	of the strings being specified by other fields."
	self assert: otm styleName = 'Regular'.
	self assert: otm fullName = 'Microsoft Comic Sans'.
	self assert: otm faceName = font name.
	self assert: otm familyName = font name! !
!CanvasTest categoriesFor: #testFont!public!unit tests! !
!CanvasTest categoriesFor: #testOutlineTextMetrics!public!unit tests! !

