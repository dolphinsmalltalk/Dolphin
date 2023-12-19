"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Graphics.Tests.FontTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Tests.FontTest guid: (Core.GUID fromString: '{c9a96f0e-b8d4-491e-8f83-6916ec5fef04}')!
Graphics.Tests.FontTest comment: ''!
!Graphics.Tests.FontTest methodsFor!

testFromHandle
	| desktopFont systemFont |
	desktopFont := Canvas forDesktop font.
	systemFont := Font system.
	self assert: desktopFont logFont equals: systemFont logFont.
	systemFont free.
	self deny: desktopFont ownsHandle! !
!Graphics.Tests.FontTest categoriesForMethods!
testFromHandle!public! !
!

