"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusTestInitializer
	instanceVariableNames: 'mockHandle arg1'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusTestInitializer guid: (GUID fromString: '{256bd680-0b78-486f-a0a0-99651f0b42a0}')!
GdiplusTestInitializer comment: ''!
!GdiplusTestInitializer categoriesForClass!Unclassified! !
!GdiplusTestInitializer methodsFor!

= aGdiplusTestInitializer
	"Arbitrary test for equality"

	^self class == aGdiplusTestInitializer class and: [arg1 = aGdiplusTestInitializer arg1]!

arg1
	^arg1!

arg1: anObject
	arg1 := anObject!

createHandle
	^mockHandle!

gdiplusConstructorErrorDescription
	^'Error in Gdiplus TestConstructor'!

hash
	^arg1 hash!

initialize
	super initialize.
	mockHandle := self! !
!GdiplusTestInitializer categoriesFor: #=!accessing!comparison!public! !
!GdiplusTestInitializer categoriesFor: #arg1!accessing!public! !
!GdiplusTestInitializer categoriesFor: #arg1:!accessing!public! !
!GdiplusTestInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!GdiplusTestInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!public! !
!GdiplusTestInitializer categoriesFor: #hash!accessing!public! !
!GdiplusTestInitializer categoriesFor: #initialize!initializing!public! !

!GdiplusTestInitializer class methodsFor!

new
	^self basicNew initialize! !
!GdiplusTestInitializer class categoriesFor: #new!instance creation!public! !

