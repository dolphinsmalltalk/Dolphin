"Filed out from Dolphin Smalltalk 7"!

GdiplusStringFormatInitializer subclass: #GdiplusStringFormatGenericDefaultInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusStringFormatGenericDefaultInitializer guid: (GUID fromString: '{c8f38621-766b-11d7-b609-00e0987e8081}')!
GdiplusStringFormatGenericDefaultInitializer comment: ''!
!GdiplusStringFormatGenericDefaultInitializer categoriesForClass!Unclassified! !
!GdiplusStringFormatGenericDefaultInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	(status := self library gdipStringFormatGetGenericDefault: gpHandle) == Ok
		ifFalse: [self gdiplusErrorWith: status].
	^gpHandle! !
!GdiplusStringFormatGenericDefaultInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

!GdiplusStringFormatGenericDefaultInitializer class methodsFor!

uninitialize
	GenericDefault := nil! !
!GdiplusStringFormatGenericDefaultInitializer class categoriesFor: #uninitialize!class hierarchy-removing!private! !

