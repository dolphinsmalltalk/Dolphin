"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GdiplusTest subclass: #'Graphics.Gdiplus.Tests.StringFormatTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.StringFormatTest guid: (Core.GUID fromString: '{fe02342a-86ba-4d11-91fa-53be23c8605e}')!
Graphics.Gdiplus.Tests.StringFormatTest comment: ''!
!Graphics.Gdiplus.Tests.StringFormatTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.StringFormatTest methodsFor!

testTabOffsets
	| offsets |
	self assert: StringFormat genericDefault tabOffsets equals: #(0.0).
	offsets := #(1.25 2.5 3.75 4).
	self assert: (StringFormat new tabOffsets: offsets) tabOffsets equals: offsets! !
!Graphics.Gdiplus.Tests.StringFormatTest categoriesForMethods!
testTabOffsets!public! !
!

