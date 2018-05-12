"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusImageAttributesInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusImageAttributesInitializer guid: (GUID fromString: '{88f79e30-7465-481e-afda-b77fcd6e29bd}')!
GdiplusImageAttributesInitializer comment: ''!
!GdiplusImageAttributesInitializer categoriesForClass!Unclassified! !
!GdiplusImageAttributesInitializer methodsFor!

createHandle
	"
	   ImageAttributes()
	    {
	        nativeImageAttr = NULL;
	        lastResult = DllExports::GdipCreateImageAttributes(&nativeImageAttr);
	    }"

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipCreateImageAttributes: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating ImageAttributes'! !
!GdiplusImageAttributesInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusImageAttributesInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

