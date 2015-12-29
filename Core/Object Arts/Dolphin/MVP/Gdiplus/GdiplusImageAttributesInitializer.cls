"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializer subclass: #GdiplusImageAttributesInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusImageAttributesInitializer guid: (GUID fromString: '{88F79E30-7465-481E-AFDA-B77FCD6E29BD}')!
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

