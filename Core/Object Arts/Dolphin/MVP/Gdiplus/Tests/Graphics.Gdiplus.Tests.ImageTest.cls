"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.ImageTests subclass: #'Graphics.Gdiplus.Tests.ImageTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.ImageTest guid: (Core.GUID fromString: '{913d638b-b96f-42e7-9dd5-da50e692d4b9}')!
Graphics.Gdiplus.Tests.ImageTest comment: ''!
!Graphics.Gdiplus.Tests.ImageTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.ImageTest methodsFor!

setUp
	super setUp.
	model := Image fromFile: self fileResource pafFish32x32png!

testLoadingBmp
	model := Image fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model handle.
	self assertPersistedValid! !
!Graphics.Gdiplus.Tests.ImageTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.ImageTest categoriesFor: #testLoadingBmp!public!unit tests! !

