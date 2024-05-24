"Filed out from Dolphin Smalltalk"!

GdiplusStringFormatInitializer subclass: #GdiplusStringFormatGenericTypographicInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusStringFormatGenericTypographicInitializer guid: (GUID fromString: '{cbe1bbee-b46a-4c95-90e4-d4bec63775e9}')!

GdiplusStringFormatGenericTypographicInitializer comment: ''!

!GdiplusStringFormatGenericTypographicInitializer categoriesForClass!Unclassified! !

!GdiplusStringFormatGenericTypographicInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	self library gdipStringFormatGetGenericTypographic: gpHandle.
	^gpHandle!

isGenericTypographic
	^true! !

!GdiplusStringFormatGenericTypographicInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
isGenericTypographic!public!testing! !
!

!GdiplusStringFormatGenericTypographicInitializer class methodsFor!

uninitialize
	GenericTypographic := nil! !

!GdiplusStringFormatGenericTypographicInitializer class categoriesForMethods!
uninitialize!class hierarchy-removing!private! !
!

