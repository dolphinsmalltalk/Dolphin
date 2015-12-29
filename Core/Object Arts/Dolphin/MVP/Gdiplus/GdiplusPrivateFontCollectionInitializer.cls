"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializer subclass: #GdiplusPrivateFontCollectionInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusPrivateFontCollectionInitializer guid: (GUID fromString: '{C09D8C07-5F28-11D7-B609-00E0987E8081}')!
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

