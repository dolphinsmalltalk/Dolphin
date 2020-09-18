"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.ImageAttributesInitializer'
	instanceVariableNames: ''
	classVariableNames: 'Default'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.ImageAttributesInitializer guid: (Core.GUID fromString: '{88f79e30-7465-481e-afda-b77fcd6e29bd}')!
Graphics.Gdiplus.ImageAttributesInitializer comment: ''!
!Graphics.Gdiplus.ImageAttributesInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.ImageAttributesInitializer methodsFor!

createHandle
	"Private - 
	   ImageAttributes()
	    {
	        nativeImageAttr = NULL;
	        lastResult = DllExports::GdipCreateImageAttributes(&nativeImageAttr);
	    }"

	| gpHandle |
	gpHandle := Handle new.
	self library gdipCreateImageAttributes: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.ImageAttributesInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

!Graphics.Gdiplus.ImageAttributesInitializer class methodsFor!

default
	^Default ifNil: [Default := self basicNew]!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variable
	which holds an instance of the receiver."

	Default := nil! !
!Graphics.Gdiplus.ImageAttributesInitializer class categoriesFor: #default!instance creation!private! !
!Graphics.Gdiplus.ImageAttributesInitializer class categoriesFor: #new!development!instance creation!public! !
!Graphics.Gdiplus.ImageAttributesInitializer class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !

