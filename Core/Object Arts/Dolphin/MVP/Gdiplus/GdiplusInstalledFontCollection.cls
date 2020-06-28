"Filed out from Dolphin Smalltalk 7"!

GdiplusFontCollection subclass: #GdiplusInstalledFontCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusInstalledFontCollection guid: (GUID fromString: '{c09d8c03-5f28-11d7-b609-00e0987e8081}')!
GdiplusInstalledFontCollection comment: 'GdiplusInstalledFontCollection class represents the fonts installed on the system.'!
!GdiplusInstalledFontCollection categoriesForClass!Unclassified! !
!GdiplusInstalledFontCollection class methodsFor!

exampleGdipIFCEnumerating
	"MSDN:  GDI+ >  Using GDI+ >  Using Text and Fonts > Enumerating Installed Fonts
	This example displays the names of all installed fonts in a rectangle that's inset from
	the bounds of the bitmap.

		self exampleGdipIFCEnumerating showExample
	"

	| bitmap rect names stream |
	bitmap := GdiplusBitmap extent: 500 @ 400.
	rect := bitmap bounds insetBy: 40.
	names := GdiplusInstalledFontCollection new families collect: [:e | e name].
	(stream := String new writeStream)
		display: 'There are ';
		display: names size;
		display: ' installed fonts.  The family names are: ';
		display: names first.
	(2 to: names size) do: [:i | stream display: ', ' , (names at: i)].
	(bitmap graphics)
		drawString: stream contents layoutRect: rect;
		drawRectangle: rect.
	^bitmap!

new
	^self fromInitializer: GdiplusInstalledFontCollectionInitializer default! !
!GdiplusInstalledFontCollection class categoriesFor: #exampleGdipIFCEnumerating!examples!public!sunit! !
!GdiplusInstalledFontCollection class categoriesFor: #new!instance creation!public! !

