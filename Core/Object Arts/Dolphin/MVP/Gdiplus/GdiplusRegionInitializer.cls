"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusRegionInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusRegionInitializer guid: (GUID fromString: '{c8f38620-766b-11d7-b609-00e0987e8081}')!
GdiplusRegionInitializer comment: ''!
!GdiplusRegionInitializer categoriesForClass!Unclassified! !
!GdiplusRegionInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipCreateRegion: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Region'! !
!GdiplusRegionInitializer categoriesFor: #createHandle!public! !
!GdiplusRegionInitializer categoriesFor: #gdiplusConstructorErrorDescription!public! !

