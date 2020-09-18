"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.InstalledFontCollectionInitializer'
	instanceVariableNames: ''
	classVariableNames: 'Default'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.InstalledFontCollectionInitializer guid: (Core.GUID fromString: '{c09d8c04-5f28-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.InstalledFontCollectionInitializer comment: ''!
!Graphics.Gdiplus.InstalledFontCollectionInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.InstalledFontCollectionInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	self library gdipNewInstalledFontCollection: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.InstalledFontCollectionInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

!Graphics.Gdiplus.InstalledFontCollectionInitializer class methodsFor!

default
	^Default ifNil: [Default := self basicNew]!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variable
	which holds an instance of the receiver."

	Default := nil! !
!Graphics.Gdiplus.InstalledFontCollectionInitializer class categoriesFor: #default!instance creation!private! !
!Graphics.Gdiplus.InstalledFontCollectionInitializer class categoriesFor: #new!development!instance creation!public! !
!Graphics.Gdiplus.InstalledFontCollectionInitializer class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !

