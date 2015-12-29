"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializer subclass: #GdiplusInstalledFontCollectionInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusInstalledFontCollectionInitializer guid: (GUID fromString: '{C09D8C04-5F28-11D7-B609-00E0987E8081}')!
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

