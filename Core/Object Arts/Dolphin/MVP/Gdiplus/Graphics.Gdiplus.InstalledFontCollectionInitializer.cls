"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.FontCollectionInitializer
	subclass: #'Graphics.Gdiplus.InstalledFontCollectionInitializer'
	instanceVariableNames: ''
	classVariableNames: 'Default'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.InstalledFontCollectionInitializer guid: (Core.GUID fromString: '{c09d8c04-5f28-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.InstalledFontCollectionInitializer comment: ''!
!Graphics.Gdiplus.InstalledFontCollectionInitializer methodsFor!

= anObject
	^self species == anObject species!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipNewInstalledFontCollection: gpHandle.
	^gpHandle!

hash
	^self species hash! !
!Graphics.Gdiplus.InstalledFontCollectionInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
hash!comparing!public! !
!

!Graphics.Gdiplus.InstalledFontCollectionInitializer class methodsFor!

default
	^Default ifNil: [Default := self basicNew]!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variable
	which holds an instance of the receiver."

	Default := nil! !
!Graphics.Gdiplus.InstalledFontCollectionInitializer class categoriesForMethods!
default!instance creation!private! !
new!development!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
!

