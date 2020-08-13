"Filed out from Dolphin Smalltalk 7"!

TabViewTest subclass: #TabViewXPTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TabViewXPTest guid: (GUID fromString: '{f55d0ba3-f595-4d2c-bfc2-65de737b4fcb}')!
TabViewXPTest comment: ''!
!TabViewXPTest categoriesForClass!Unclassified! !
!TabViewXPTest methodsFor!

classToTest
	^TabViewXP!

testLabelWithAmpersand
	"Test that labels containing ampersands are not (normally) ellipsised.
	We have to use a bit of sleight of hand to test this, as the public effect is purely visual. Luckily the underlying API is able to modify the drawn text in place with any ellipsis that it adds. We can exploit this capability to capture the actual text it decides to draw."

	| rect anon canvas actual expected |
	self addTestTabs.
	rect := presenter itemRect: 3.
	"About time we did a port of MethodWrappers really"
	anon := Canvas newAnonymousSubclass.
	anon basicClassPool: (anon classPool
				at: 'DrawnText' put: nil;
				yourself).
	anon
		basicCompile: 'formatText: aString in: aRectangle flags: anInteger
		"Double the size to avoid any chance of buffer overrun"
		DrawnText := aString asUtf16String, (Utf16String new: aString size).
		^super formatText: DrawnText in: aRectangle flags: anInteger | DT_MODIFYSTRING'.
	canvas := presenter canvas.
	canvas becomeAn: anon.
	canvas font: presenter actualFont.
	presenter
		paintLabel: 3
		on: canvas
		in: rect.
	canvas free.
	actual := (anon classPool at: 'DrawnText') upTo: Character null.
	expected := self objectsToTest at: 3.
	self assert: actual equals: expected! !
!TabViewXPTest categoriesFor: #classToTest!helpers!private! !
!TabViewXPTest categoriesFor: #testLabelWithAmpersand!public! !

