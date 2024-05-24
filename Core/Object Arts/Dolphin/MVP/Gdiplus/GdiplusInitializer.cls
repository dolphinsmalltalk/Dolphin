"Filed out from Dolphin Smalltalk"!

Object subclass: #GdiplusInitializer
	instanceVariableNames: 'library'
	classVariableNames: ''
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: ''!

GdiplusInitializer guid: (GUID fromString: '{4687fd64-6607-4be7-b45b-f533ef511bc5}')!

GdiplusInitializer isAbstract: true!

GdiplusInitializer comment: 'An instance of GdiplusInitializer serves as a proxy for a GdiplusBase factory.  Instances of subclasses contain enough information to create and recreate a corresponding GdiplusBase subclass instance. '!

!GdiplusInitializer categoriesForClass!Unclassified! !

!GdiplusInitializer methodsFor!

createHandle
	^self subclassResponsibility!

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

	^library ifNil: [GdiplusLibrary default]!

library: anObject
	library := anObject! !

!GdiplusInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
isPersistent!public!testing! !
library!accessing!private! !
library:!private!test accessing! !
!

