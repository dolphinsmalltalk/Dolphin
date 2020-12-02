"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusImageAttributesInitializer
	instanceVariableNames: ''
	classVariableNames: 'Default'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusImageAttributesInitializer guid: (GUID fromString: '{88f79e30-7465-481e-afda-b77fcd6e29bd}')!
GdiplusImageAttributesInitializer comment: ''!
!GdiplusImageAttributesInitializer categoriesForClass!Unclassified! !
!GdiplusImageAttributesInitializer methodsFor!

createHandle
	"Private - 
	   ImageAttributes()
	    {
	        nativeImageAttr = NULL;
	        lastResult = DllExports::GdipCreateImageAttributes(&nativeImageAttr);
	    }"

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipCreateImageAttributes: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating ImageAttributes'! !
!GdiplusImageAttributesInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!GdiplusImageAttributesInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

!GdiplusImageAttributesInitializer class methodsFor!

default
	^Default ifNil: [Default := self basicNew]!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variable
	which holds an instance of the receiver."

	Default := nil! !
!GdiplusImageAttributesInitializer class categoriesFor: #default!instance creation!private! !
!GdiplusImageAttributesInitializer class categoriesFor: #new!development!instance creation!public! !
!GdiplusImageAttributesInitializer class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !

