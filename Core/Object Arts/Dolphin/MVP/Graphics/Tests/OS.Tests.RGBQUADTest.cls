"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.RGBQUADTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.RGBQUADTest guid: (Core.GUID fromString: '{744899d2-0c6a-42f3-9518-7c4ffb23e6aa}')!
OS.Tests.RGBQUADTest comment: ''!
!OS.Tests.RGBQUADTest methodsFor!

testFromColor
	| subject |
	subject := RGBQUAD fromColor: Graphics.Color oldLace.
	self assert: subject color equals: Graphics.Color oldLace.
	self assert: subject rgbRed equals: 253.
	self assert: subject rgbGreen equals: 245.
	self assert: subject rgbBlue equals: 230! !
!OS.Tests.RGBQUADTest categoriesForMethods!
testFromColor!public! !
!

