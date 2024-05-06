"Filed out from Dolphin Smalltalk"!

GdiplusStringFormatInitializer subclass: #GdiplusStringFormatGenericDefaultInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!GdiplusStringFormatGenericDefaultInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
!

!GdiplusStringFormatGenericDefaultInitializer class methodsFor!

uninitialize
	GenericDefault := nil! !

!GdiplusStringFormatGenericDefaultInitializer class categoriesForMethods!
uninitialize!class hierarchy-removing!private! !
!

