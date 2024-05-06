"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusInstalledFontCollectionInitializer
	instanceVariableNames: ''
	classVariableNames: 'Default'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusInstalledFontCollectionInitializer guid: (GUID fromString: '{c09d8c04-5f28-11d7-b609-00e0987e8081}')!

GdiplusInstalledFontCollectionInitializer comment: ''!

!GdiplusInstalledFontCollectionInitializer categoriesForClass!Unclassified! !

!GdiplusInstalledFontCollectionInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipNewInstalledFontCollection: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating InstalledFontCollection'! !

!GdiplusInstalledFontCollectionInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
gdiplusConstructorErrorDescription!constants!private! !
!

!GdiplusInstalledFontCollectionInitializer class methodsFor!

default
	^Default ifNil: [Default := self basicNew]!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variable
	which holds an instance of the receiver."

	Default := nil! !

!GdiplusInstalledFontCollectionInitializer class categoriesForMethods!
default!instance creation!private! !
new!development!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
!

