"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.FontFamilyInitializer'
	instanceVariableNames: ''
	classVariableNames: 'GenericSansSerif GenericSerif'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.FontFamilyInitializer guid: (Core.GUID fromString: '{c09d8c09-5f28-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.FontFamilyInitializer isNonInstantiable: true!
Graphics.Gdiplus.FontFamilyInitializer comment: ''!
!Graphics.Gdiplus.FontFamilyInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.FontFamilyInitializer class methodsFor!

genericSansSerif
	^GenericSansSerif ifNil: [GenericSansSerif := FontFamilyGenericSansSerifInitializer basicNew]!

genericSerif
	^GenericSerif ifNil: [GenericSerif := FontFamilyGenericSerifInitializer basicNew]!

name: aString fontCollection: aFontCollection
	^FontFamilyFromNameInitializer basicNew name: aString fontCollection: aFontCollection!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver and subclasses to be stripped by clearing lazy initialized class variables
	which hold sub-instance of the receiver."

	GenericSansSerif := GenericSerif := nil! !
!Graphics.Gdiplus.FontFamilyInitializer class categoriesFor: #genericSansSerif!instance creation!public! !
!Graphics.Gdiplus.FontFamilyInitializer class categoriesFor: #genericSerif!instance creation!public! !
!Graphics.Gdiplus.FontFamilyInitializer class categoriesFor: #name:fontCollection:!instance creation!public! !
!Graphics.Gdiplus.FontFamilyInitializer class categoriesFor: #new!instance creation!public! !
!Graphics.Gdiplus.FontFamilyInitializer class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !

