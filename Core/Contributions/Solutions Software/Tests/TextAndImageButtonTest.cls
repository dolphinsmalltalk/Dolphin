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
	| shell |
	super setUp.
	button := TextAndImageButton new.
	button font: (Font name: 'Segoe UI' pointSize: 8).
	button image: Icon warning.
	button hasBorder: true.
	shell := ShellView new create.
	shell layoutManager: BorderLayout new.
	shell addSubView: button.
	button arrangement: #center.
	shell rectangle: (100 @ 100 extent: 250 @ 100).
	shell show!

tearDown
	button topView destroy.
	button := nil.
	super tearDown!

testLabelWithAmpersand
	"Test that labels containing ampersands are not (normally) ellipsised.
	Inspired by TabViewXPTest>>testLabelWithAmpersand"

	| extent text textRect imageRect textPos |
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
	"The test button needs to be large enough"
	self assert: button extent > (extent + button imageExtent + (20@10)).
	button drawOn: canvas.
	"The text should not have been ellipsized, and the drawn extent should be
	the full extent needed to draw the text on a single line."
	self assert: (anon classPool at: 'DrawnText') trimNulls equals: text.
	self assert: (anon classPool at: 'Rect') extent = extent.
	"The text should not occlude the image"
	imageRect := (button imagePosOn: canvas) extent: button imageExtent.
	textRect := (button textPosOn: canvas) extent: extent.
	self deny: (imageRect intersects: textRect).
	canvas free.
! !
!TextAndImageButtonTest categoriesFor: #setUp!public!running! !
!TextAndImageButtonTest categoriesFor: #tearDown!public!running! !
!TextAndImageButtonTest categoriesFor: #testLabelWithAmpersand!public!unit tests! !

