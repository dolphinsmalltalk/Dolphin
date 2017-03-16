"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusGraphicsFromHDCInitializer
	instanceVariableNames: 'canvas'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusGraphicsFromHDCInitializer guid: (GUID fromString: '{83cb0a86-604f-48a0-9336-619cfce00e47}')!
GdiplusGraphicsFromHDCInitializer comment: ''!
!GdiplusGraphicsFromHDCInitializer categoriesForClass!Unclassified! !
!GdiplusGraphicsFromHDCInitializer methodsFor!

canvas: aCanvas
	canvas := aCanvas!

createHandle
	" Graphics(IN HDC hdc)
    	{
	        GpGraphics *graphics = NULL;

	        lastResult = DllExports::GdipCreateFromHDC(hdc, &graphics);"

	"MSDN: When you use this constructor to create a Graphics object, make sure that the
	Graphics object is deleted or goes out of scope before the device context is released."

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipCreateFromHDC: canvas asParameter graphics: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Graphics'! !
!GdiplusGraphicsFromHDCInitializer categoriesFor: #canvas:!accessing!public! !
!GdiplusGraphicsFromHDCInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusGraphicsFromHDCInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

!GdiplusGraphicsFromHDCInitializer class methodsFor!

canvas: aCanvas
	"Creates a Graphics object that is associated with a specified device context."

	^self new canvas: aCanvas! !
!GdiplusGraphicsFromHDCInitializer class categoriesFor: #canvas:!instance creation!public! !

