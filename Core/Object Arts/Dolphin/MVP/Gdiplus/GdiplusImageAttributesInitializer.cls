"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusImageAttributesInitializer
	instanceVariableNames: ''
	classVariableNames: 'Default'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!GdiplusImageAttributesInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
gdiplusConstructorErrorDescription!constants!private! !
!

!GdiplusImageAttributesInitializer class methodsFor!

default
	^Default ifNil: [Default := self basicNew]!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variable
	which holds an instance of the receiver."

	Default := nil! !

!GdiplusImageAttributesInitializer class categoriesForMethods!
default!instance creation!private! !
new!development!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
!

