"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #TextAndImageButtonTest
	instanceVariableNames: 'button canvas anon'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TextAndImageButtonTest guid: (GUID fromString: '{fdb7cc36-fd20-49e9-b512-b324a64641e3}')!
TextAndImageButtonTest comment: ''!
!TextAndImageButtonTest categoriesForClass!SUnit! !
!TextAndImageButtonTest methodsFor!

setUp
	super setUp.
	button := TextAndImageButton new.
	ShellView show addSubView: button!

tearDown
	button topView destroy.
	button := nil.
	super tearDown!

testLabelWithAmpersand
	"Test that labels containing ampersands are not (normally) ellipsised.
	Inspired by TabViewXPTest>>testLabelWithAmpersand"

	| extent text |
	text := '&Hello && World'.
	button text: text.
	anon := Canvas newAnonymousSubclass.
	anon basicClassPool: (anon classPool
				at: 'DrawnText' put: nil;
				at: 'Rect' put: nil;
				yourself).
	canvas := button canvas.
	canvas becomeAn: anon.
	canvas font: button actualFont.
	anon
		basicCompile: 'formatText: aString in: aRectangle flags: anInteger
		"Double the size to avoid any chance of buffer overrun"
		DrawnText := aString asUtf16String, (Utf16String new: aString size).
		Rect := aRectangle.
		^super formatText: DrawnText in: aRectangle flags: anInteger | DT_MODIFYSTRING'.
	extent := canvas
				textExtent: text
				width: 0
				flags: Win32Constants.DT_SINGLELINE.
	button drawTextOn: canvas.
	canvas free.
	"The text should not have been ellipsized, and the drawn extent should be
	the full extent needed to draw the text on a single line."
	self assert: (anon classPool at: 'DrawnText') trimNulls equals: text.
	self assert: (anon classPool at: 'Rect') extent = extent! !
!TextAndImageButtonTest categoriesFor: #setUp!public!running! !
!TextAndImageButtonTest categoriesFor: #tearDown!public!running! !
!TextAndImageButtonTest categoriesFor: #testLabelWithAmpersand!public!unit tests! !

