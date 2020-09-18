"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Graphics.Gdiplus.Initializer'
	instanceVariableNames: 'library'
	classVariableNames: ''
	imports: #(#{Graphics.Gdiplus.GdiplusConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Initializer guid: (Core.GUID fromString: '{4687fd64-6607-4be7-b45b-f533ef511bc5}')!
Graphics.Gdiplus.Initializer isNonInstantiable: true!
Graphics.Gdiplus.Initializer comment: 'An instance of GdiplusInitializer serves as a proxy for a GdiplusBase factory.  Instances of subclasses contain enough information to create and recreate a corresponding GdiplusBase subclass instance. '!
!Graphics.Gdiplus.Initializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Initializer methodsFor!

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
!Graphics.Gdiplus.Initializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.Initializer categoriesFor: #isPersistent!public!testing! !
!Graphics.Gdiplus.Initializer categoriesFor: #library!accessing!private! !
!Graphics.Gdiplus.Initializer categoriesFor: #library:!private!test accessing! !

