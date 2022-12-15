"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.ImageAttributesInitializer'
	instanceVariableNames: ''
	classVariableNames: 'Default'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.ImageAttributesInitializer guid: (Core.GUID fromString: '{88f79e30-7465-481e-afda-b77fcd6e29bd}')!
Graphics.Gdiplus.ImageAttributesInitializer comment: ''!
!Graphics.Gdiplus.ImageAttributesInitializer methodsFor!

basicCreateHandle
	"Private - 
	   ImageAttributes()
	    {
	        nativeImageAttr = NULL;
	        lastResult = DllExports::GdipCreateImageAttributes(&nativeImageAttr);
	    }"

	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipCreateImageAttributes: gpHandle.
	^gpHandle!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the Gdiplus native object it describes exactly as it was across Smalltalk image save/restore. This is generally true."

	"ImageAttributes are constructed on the fly when drawing images, so at the moment we have not made them persistent."

	^false!

printAttributesOn: aWriteStream 
	"No attributes are persisted"! !
!Graphics.Gdiplus.ImageAttributesInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
isPersistent!public!testing! !
printAttributesOn:!printing!private! !
!

!Graphics.Gdiplus.ImageAttributesInitializer class methodsFor!

cloneHandle: aHandle
	| clone |
	clone := Handle new.
	Gdip gdipCloneImageAttributes: aHandle cloneImageattr: clone.
	^clone!

default
	^Default ifNil: [Default := self basicNew]!

freeHandle: aHandle
	Gdip gdipDisposeImageAttributes: aHandle!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variable
	which holds an instance of the receiver."

	Default := nil! !
!Graphics.Gdiplus.ImageAttributesInitializer class categoriesForMethods!
cloneHandle:!private!realizing/unrealizing! !
default!instance creation!private! !
freeHandle:!private!realizing/unrealizing! !
new!development!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
!

