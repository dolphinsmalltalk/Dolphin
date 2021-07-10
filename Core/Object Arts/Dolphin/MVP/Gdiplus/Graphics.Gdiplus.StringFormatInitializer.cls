"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.StringFormatInitializer'
	instanceVariableNames: 'formatFlags language'
	classVariableNames: 'GenericDefault GenericTypographic'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.StringFormatInitializer guid: (Core.GUID fromString: '{14ad5dde-0284-402d-bbce-89611bcd32c4}')!
Graphics.Gdiplus.StringFormatInitializer isNonInstantiable: true!
Graphics.Gdiplus.StringFormatInitializer comment: ''!
!Graphics.Gdiplus.StringFormatInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.StringFormatInitializer class methodsFor!

formatFlags: flagsNumber language: languageNumber
	^StringFormatFromFlagsInitializer basicNew formatFlags: flagsNumber language: languageNumber!

genericDefault
	^GenericDefault ifNil: [GenericDefault := StringFormatGenericDefaultInitializer basicNew]!

genericTypographic
	^GenericTypographic
		ifNil: [GenericTypographic := StringFormatGenericTypographicInitializer basicNew]!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver and subclasses to be stripped by clearing lazy initialized class variables
	which hold sub-instance of the receiver."

	self uninitialize!

uninitialize
	GenericDefault := GenericTypographic := nil! !
!Graphics.Gdiplus.StringFormatInitializer class categoriesForMethods!
formatFlags:language:!instance creation!public! !
genericDefault!instance creation!public! !
genericTypographic!instance creation!public! !
new!development!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
uninitialize!class hierarchy-removing!private! !
!

