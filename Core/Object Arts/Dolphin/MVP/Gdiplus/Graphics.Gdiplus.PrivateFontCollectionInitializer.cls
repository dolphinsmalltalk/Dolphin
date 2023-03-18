"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.FontCollectionInitializer
	subclass: #'Graphics.Gdiplus.PrivateFontCollectionInitializer'
	instanceVariableNames: ''
	classVariableNames: 'Default'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.PrivateFontCollectionInitializer guid: (Core.GUID fromString: '{c09d8c07-5f28-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.PrivateFontCollectionInitializer comment: ''!
!Graphics.Gdiplus.PrivateFontCollectionInitializer methodsFor!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipNewPrivateFontCollection: gpHandle.
	^gpHandle!

freeHandle: aHandle
	Gdip gdipDeletePrivateFontCollection: aHandle!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the Gdiplus native object it describes exactly as it was across Smalltalk image save/restore. This is generally true."

	^false! !
!Graphics.Gdiplus.PrivateFontCollectionInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
freeHandle:!private!realizing/unrealizing! !
isPersistent!public!testing! !
!

!Graphics.Gdiplus.PrivateFontCollectionInitializer class methodsFor!

default
	^Default ifNil: [Default := self basicNew]!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variable
	which holds an instance of the receiver."

	Default := nil! !
!Graphics.Gdiplus.PrivateFontCollectionInitializer class categoriesForMethods!
default!instance creation!private! !
new!development!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
!

