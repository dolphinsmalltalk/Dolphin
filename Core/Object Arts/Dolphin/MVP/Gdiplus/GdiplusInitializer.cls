"Filed out from Dolphin Smalltalk X6"!

Object subclass: #GdiplusInitializer
	instanceVariableNames: 'library'
	classVariableNames: ''
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: ''!
GdiplusInitializer guid: (GUID fromString: '{4687FD64-6607-4BE7-B45B-F533EF511BC5}')!
GdiplusInitializer comment: 'An instance of GdiplusInitializer serves as a proxy for a GdiplusBase factory.  Instances of subclasses contain enough information to create and recreate a corresponding GdiplusBase subclass instance. '!
!GdiplusInitializer categoriesForClass!Unclassified! !
!GdiplusInitializer methodsFor!

assertStatusOk: status
	status = Ok ifFalse: [self gdiplusErrorWith: status]!

createHandle
	^self subclassResponsibility!

gdiplusConstructorErrorDescription
	^'Error in Gdiplus Constructor'!

gdiplusErrorWith: status
	^GdiplusError signal: self gdiplusConstructorErrorDescription with: status!

isPersistent
	"Answer true if the receiver holds sufficient information such that
	it can recreate itself when the image is saved and restored. This is also
	an indication as to whether the receiver can be filed out/in using the STB
	mechanism. Generally this ability corresponds to a useful implemenation
	of #basicRealize"

	^true!

library
	"Private - Answer the library.
		Making this a parameter allows a MockLibrary to be used for UnitTesting.
		(Not sure how important the tests will be, so may remove this at a later date"

	library ifNil: [^GdiplusLibrary default].
	^library!

library: anObject
	library := anObject! !
!GdiplusInitializer categoriesFor: #assertStatusOk:!asserting!public! !
!GdiplusInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusInitializer categoriesFor: #gdiplusErrorWith:!exceptions!private! !
!GdiplusInitializer categoriesFor: #isPersistent!public!testing! !
!GdiplusInitializer categoriesFor: #library!accessing!private! !
!GdiplusInitializer categoriesFor: #library:!private!test accessing! !

!GdiplusInitializer class methodsFor!

new
	^super new initialize! !
!GdiplusInitializer class categoriesFor: #new!instance creation!public! !

