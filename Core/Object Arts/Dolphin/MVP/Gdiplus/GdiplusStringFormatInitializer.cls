"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusStringFormatInitializer
	instanceVariableNames: 'formatFlags language'
	classVariableNames: 'GenericDefault GenericTypographic'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusStringFormatInitializer guid: (GUID fromString: '{14ad5dde-0284-402d-bbce-89611bcd32c4}')!

GdiplusStringFormatInitializer isAbstract: true!

GdiplusStringFormatInitializer comment: ''!

!GdiplusStringFormatInitializer categoriesForClass!Unclassified! !

!GdiplusStringFormatInitializer methodsFor!

gdiplusConstructorErrorDescription
	^'Error creating StringFormat'!

isGenericDefault
	^false!

isGenericTypographic
	^false! !

!GdiplusStringFormatInitializer categoriesForMethods!
gdiplusConstructorErrorDescription!constants!private! !
isGenericDefault!public!testing! !
isGenericTypographic!public!testing! !
!

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

!GdiplusStringFormatInitializer class categoriesForMethods!
formatFlags:language:!instance creation!public! !
genericDefault!instance creation!public! !
genericTypographic!instance creation!public! !
new!development!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
uninitialize!class hierarchy-removing!private! !
!

