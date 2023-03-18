"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.FontCollection
	subclass: #'Graphics.Gdiplus.PrivateFontCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.PrivateFontCollection guid: (Core.GUID fromString: '{c09d8c05-5f28-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.PrivateFontCollection comment: 'GdiplusPrivateFontCollection is a collection class for fonts. This class keeps a collection of fonts specifically for an application. The fonts in the collection can include installed fonts as well as fonts that have not been installed on the system.

'!
!Graphics.Gdiplus.PrivateFontCollection methodsFor!

addFontFile: aFilename
	"Adds a font file to this private font collection."

	Gdip gdipPrivateAddFontFile: self asParameter filename: aFilename!

initializerClass
	^PrivateFontCollectionInitializer! !
!Graphics.Gdiplus.PrivateFontCollection categoriesForMethods!
addFontFile:!operations!public! !
initializerClass!constants!private! !
!

!Graphics.Gdiplus.PrivateFontCollection class methodsFor!

new
	^self fromInitializer: PrivateFontCollectionInitializer default! !
!Graphics.Gdiplus.PrivateFontCollection class categoriesForMethods!
new!instance creation!public! !
!

