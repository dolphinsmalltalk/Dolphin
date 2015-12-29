"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializer subclass: #GdiplusRegionInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusRegionInitializer guid: (GUID fromString: '{C8F38620-766B-11D7-B609-00E0987E8081}')!
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

