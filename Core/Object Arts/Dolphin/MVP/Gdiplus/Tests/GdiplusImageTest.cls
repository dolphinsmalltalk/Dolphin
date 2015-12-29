"Filed out from Dolphin Smalltalk X6"!

GdiplusImageTests subclass: #GdiplusImageTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusImageTest guid: (GUID fromString: '{913D638B-B96F-42E7-9DD5-DA50E692D4B9}')!
GdiplusImageTest comment: ''!
!GdiplusImageTest categoriesForClass!Unclassified! !
!GdiplusImageTest methodsFor!

setUp
	super setUp.
	model := GdiplusImage fromFile: self fileResource pafFish32x32png!

testLoadingBmp
	model := GdiplusImage fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model handle.
	self assertPersistedValid! !
!GdiplusImageTest categoriesFor: #setUp!public!setup! !
!GdiplusImageTest categoriesFor: #testLoadingBmp!public!unit tests! !

