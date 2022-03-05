"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusPrivateFontCollectionInitializer
	instanceVariableNames: ''
	classVariableNames: 'Default'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusPrivateFontCollectionInitializer guid: (GUID fromString: '{c09d8c07-5f28-11d7-b609-00e0987e8081}')!
GdiplusPrivateFontCollectionInitializer comment: ''!
!GdiplusPrivateFontCollectionInitializer categoriesForClass!Unclassified! !
!GdiplusPrivateFontCollectionInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipNewPrivateFontCollection: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating PrivateFontCollection'! !
!GdiplusPrivateFontCollectionInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
gdiplusConstructorErrorDescription!constants!private! !
!

!GdiplusPrivateFontCollectionInitializer class methodsFor!

default
	^Default ifNil: [Default := self basicNew]!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variable
	which holds an instance of the receiver."

	Default := nil! !
!GdiplusPrivateFontCollectionInitializer class categoriesForMethods!
default!instance creation!private! !
new!development!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
!

