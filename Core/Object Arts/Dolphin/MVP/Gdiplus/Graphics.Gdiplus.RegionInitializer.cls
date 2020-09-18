"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.RegionInitializer'
	instanceVariableNames: ''
	classVariableNames: 'Default'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.RegionInitializer guid: (Core.GUID fromString: '{c8f38620-766b-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.RegionInitializer comment: ''!
!Graphics.Gdiplus.RegionInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.RegionInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	self library gdipCreateRegion: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.RegionInitializer categoriesFor: #createHandle!private! !

!Graphics.Gdiplus.RegionInitializer class methodsFor!

default
	^Default ifNil: [Default := self basicNew]!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variable
	which holds an instance of the receiver."

	Default := nil! !
!Graphics.Gdiplus.RegionInitializer class categoriesFor: #default!instance creation!private! !
!Graphics.Gdiplus.RegionInitializer class categoriesFor: #new!development!instance creation!public! !
!Graphics.Gdiplus.RegionInitializer class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !

