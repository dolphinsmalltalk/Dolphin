"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.PrivateFontCollectionInitializer'
	instanceVariableNames: ''
	classVariableNames: 'Default'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.PrivateFontCollectionInitializer guid: (Core.GUID fromString: '{c09d8c07-5f28-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.PrivateFontCollectionInitializer comment: ''!
!Graphics.Gdiplus.PrivateFontCollectionInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.PrivateFontCollectionInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	self library gdipNewPrivateFontCollection: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.PrivateFontCollectionInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

!Graphics.Gdiplus.PrivateFontCollectionInitializer class methodsFor!

default
	^Default ifNil: [Default := self basicNew]!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variable
	which holds an instance of the receiver."

	Default := nil! !
!Graphics.Gdiplus.PrivateFontCollectionInitializer class categoriesFor: #default!instance creation!private! !
!Graphics.Gdiplus.PrivateFontCollectionInitializer class categoriesFor: #new!development!instance creation!public! !
!Graphics.Gdiplus.PrivateFontCollectionInitializer class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !

