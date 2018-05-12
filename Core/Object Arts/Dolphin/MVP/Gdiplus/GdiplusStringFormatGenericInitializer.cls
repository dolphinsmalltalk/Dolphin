"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusStringFormatGenericInitializer
	instanceVariableNames: 'genericType'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusStringFormatGenericInitializer guid: (GUID fromString: '{c8f38621-766b-11d7-b609-00e0987e8081}')!
GdiplusStringFormatGenericInitializer comment: ''!
!GdiplusStringFormatGenericInitializer categoriesForClass!Unclassified! !
!GdiplusStringFormatGenericInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := genericType = #default 
				ifTrue: [self library gdipStringFormatGetGenericDefault: gpHandle]
				ifFalse: [self library gdipStringFormatGetGenericTypographic: gpHandle].
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating StringFormat'!

genericType: aSymbol
	self assert: [#(#default #typographic) includes: aSymbol].
	genericType := aSymbol! !
!GdiplusStringFormatGenericInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusStringFormatGenericInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusStringFormatGenericInitializer categoriesFor: #genericType:!accessing!public! !

!GdiplusStringFormatGenericInitializer class methodsFor!

new
	^super new genericType: #default!

typographic
	^self new genericType: #typographic! !
!GdiplusStringFormatGenericInitializer class categoriesFor: #new!instance creation!public! !
!GdiplusStringFormatGenericInitializer class categoriesFor: #typographic!instance creation!public! !

