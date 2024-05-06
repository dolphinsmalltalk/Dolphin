"Filed out from Dolphin Smalltalk"!

GdiplusImageTests subclass: #GdiplusImageTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusImageTest guid: (GUID fromString: '{913d638b-b96f-42e7-9dd5-da50e692d4b9}')!

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

!GdiplusImageTest categoriesForMethods!
setUp!public!setup! !
testLoadingBmp!public!unit tests! !
!

