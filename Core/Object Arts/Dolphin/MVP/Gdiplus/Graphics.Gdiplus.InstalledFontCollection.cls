"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.FontCollection subclass: #'Graphics.Gdiplus.InstalledFontCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.InstalledFontCollection guid: (Core.GUID fromString: '{c09d8c03-5f28-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.InstalledFontCollection comment: 'GdiplusInstalledFontCollection class represents the fonts installed on the system.'!
!Graphics.Gdiplus.InstalledFontCollection categoriesForClass!Unclassified! !
!Graphics.Gdiplus.InstalledFontCollection class methodsFor!

exampleGdipIFCEnumerating
	"MSDN:  GDI+ >  Using GDI+ >  Using Text and Fonts > Enumerating Installed Fonts
	This example displays the names of all installed fonts in a rectangle that's inset from
	the bounds of the bitmap.

		self exampleGdipIFCEnumerating showExample
	"

	| bitmap rect names stream |
	bitmap := Bitmap extent: 500 @ 400.
	rect := bitmap bounds insetBy: 40.
	names := InstalledFontCollection new families collect: [:e | e name].
	(stream := String new writeStream)
		display: 'There are ';
		display: names size;
		display: ' installed fonts.  The family names are: ';
		display: names first.
	(2 to: names size) do: [:i | stream display: ', ' , (names at: i)].
	bitmap graphics
		drawString: stream contents layoutRect: rect;
		drawRectangle: rect.
	^bitmap!

new
	^self fromInitializer: InstalledFontCollectionInitializer default! !
!Graphics.Gdiplus.InstalledFontCollection class categoriesFor: #exampleGdipIFCEnumerating!examples!public!sunit! !
!Graphics.Gdiplus.InstalledFontCollection class categoriesFor: #new!instance creation!public! !

