"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializer subclass: #GdiplusTestInitializer
	instanceVariableNames: 'mockHandle arg1'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusTestInitializer guid: (GUID fromString: '{256BD680-0B78-486F-A0A0-99651F0B42A0}')!
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
!GdiplusTestInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusTestInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!public! !
!GdiplusTestInitializer categoriesFor: #hash!accessing!public! !
!GdiplusTestInitializer categoriesFor: #initialize!initializing!public! !

!GdiplusTestInitializer class methodsFor!

new
	^self basicNew initialize! !
!GdiplusTestInitializer class categoriesFor: #new!instance creation!public! !

