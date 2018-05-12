"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusInstalledFontCollectionInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusInstalledFontCollectionInitializer guid: (GUID fromString: '{c09d8c04-5f28-11d7-b609-00e0987e8081}')!
GdiplusInstalledFontCollectionInitializer comment: ''!
!GdiplusInstalledFontCollectionInitializer categoriesForClass!Unclassified! !
!GdiplusInstalledFontCollectionInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipNewInstalledFontCollection: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating InstalledFontCollection'! !
!GdiplusInstalledFontCollectionInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusInstalledFontCollectionInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

