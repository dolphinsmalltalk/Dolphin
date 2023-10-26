"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Graphics.Tests.PALETTENTRYTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Tests.PALETTENTRYTest guid: (Core.GUID fromString: '{b9d1b1c9-fb62-46e9-a7d5-6807f64e5314}')!
Graphics.Tests.PALETTENTRYTest comment: ''!
!Graphics.Tests.PALETTENTRYTest methodsFor!

testFromColor
	| subject |
	subject := PALETTEENTRY fromColor: Color oldLace.
	self assert: subject color equals: Color oldLace.
	self assert: subject peRed equals: 253.
	self assert: subject peGreen equals: 245.
	self assert: subject peBlue equals: 230! !
!Graphics.Tests.PALETTENTRYTest categoriesForMethods!
testFromColor!public! !
!

