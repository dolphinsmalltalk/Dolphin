"Filed out from Dolphin Smalltalk X6"!

GdiplusFontCollection subclass: #GdiplusPrivateFontCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusPrivateFontCollection guid: (GUID fromString: '{C09D8C05-5F28-11D7-B609-00E0987E8081}')!
GdiplusPrivateFontCollection comment: 'GdiplusPrivateFontCollection is a collection class for fonts. This class keeps a collection of fonts specifically for an application. The fonts in the collection can include installed fonts as well as fonts that have not been installed on the system.

'!
!GdiplusPrivateFontCollection categoriesForClass!Unclassified! !
!GdiplusPrivateFontCollection methodsFor!

addFontFile: aFilename 
	"Adds a font file to this private font collection."

	| status |
	(status := GdiplusLibrary default gdipPrivateAddFontFile: self asParameter
				filename: aFilename asUnicodeString) = Ok 
		ifFalse: [GdiplusError signal: 'GdipPrivateAddFontFile failed' with: status]! !
!GdiplusPrivateFontCollection categoriesFor: #addFontFile:!operations!public! !

!GdiplusPrivateFontCollection class methodsFor!

new
	^self fromInitializer: GdiplusPrivateFontCollectionInitializer new! !
!GdiplusPrivateFontCollection class categoriesFor: #new!instance creation!public! !

