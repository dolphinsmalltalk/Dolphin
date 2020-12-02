"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusStringFormatInitializer
	instanceVariableNames: 'formatFlags language'
	classVariableNames: 'GenericDefault GenericTypographic'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusStringFormatInitializer guid: (GUID fromString: '{14ad5dde-0284-402d-bbce-89611bcd32c4}')!
GdiplusStringFormatInitializer isAbstract: true!
GdiplusStringFormatInitializer comment: ''!
!GdiplusStringFormatInitializer categoriesForClass!Unclassified! !
!GdiplusStringFormatInitializer methodsFor!

gdiplusConstructorErrorDescription
	^'Error creating StringFormat'! !
!GdiplusStringFormatInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

!GdiplusStringFormatInitializer class methodsFor!

formatFlags: flagsNumber language: languageNumber
	^GdiplusStringFormatFromFlagsInitializer basicNew formatFlags: flagsNumber language: languageNumber!

genericDefault
	^GenericDefault ifNil: [GenericDefault := GdiplusStringFormatGenericDefaultInitializer basicNew]!

genericTypographic
	^GenericTypographic
		ifNil: [GenericTypographic := GdiplusStringFormatGenericTypographicInitializer basicNew]!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver and subclasses to be stripped by clearing lazy initialized class variables
	which hold sub-instance of the receiver."

	self uninitialize!

uninitialize
	GenericDefault := GenericTypographic := nil! !
!GdiplusStringFormatInitializer class categoriesFor: #formatFlags:language:!instance creation!public! !
!GdiplusStringFormatInitializer class categoriesFor: #genericDefault!instance creation!public! !
!GdiplusStringFormatInitializer class categoriesFor: #genericTypographic!instance creation!public! !
!GdiplusStringFormatInitializer class categoriesFor: #new!development!instance creation!public! !
!GdiplusStringFormatInitializer class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!GdiplusStringFormatInitializer class categoriesFor: #uninitialize!class hierarchy-removing!private! !

