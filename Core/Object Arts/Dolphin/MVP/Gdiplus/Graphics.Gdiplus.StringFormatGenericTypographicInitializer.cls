"Filed out from Dolphin Smalltalk 7"!

GdiplusStringFormatInitializer subclass: #GdiplusStringFormatGenericTypographicInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusStringFormatGenericTypographicInitializer guid: (GUID fromString: '{cbe1bbee-b46a-4c95-90e4-d4bec63775e9}')!
GdiplusStringFormatGenericTypographicInitializer comment: ''!
!GdiplusStringFormatGenericTypographicInitializer categoriesForClass!Unclassified! !
!GdiplusStringFormatGenericTypographicInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	(status := self library gdipStringFormatGetGenericTypographic: gpHandle) == Ok
		ifFalse: [self gdiplusErrorWith: status].
	^gpHandle! !
!GdiplusStringFormatGenericTypographicInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

!GdiplusStringFormatGenericTypographicInitializer class methodsFor!

uninitialize
	GenericTypographic := nil! !
!GdiplusStringFormatGenericTypographicInitializer class categoriesFor: #uninitialize!class hierarchy-removing!private! !

