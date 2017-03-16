"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusPrivateFontCollectionInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusPrivateFontCollectionInitializer guid: (GUID fromString: '{c09d8c07-5f28-11d7-b609-00e0987e8081}')!
GdiplusPrivateFontCollectionInitializer comment: ''!
!GdiplusPrivateFontCollectionInitializer categoriesForClass!Unclassified! !
!GdiplusPrivateFontCollectionInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipNewPrivateFontCollection: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating PrivateFontCollection'! !
!GdiplusPrivateFontCollectionInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusPrivateFontCollectionInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

