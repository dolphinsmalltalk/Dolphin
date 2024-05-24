"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusTestInitializer
	instanceVariableNames: 'mockHandle arg1'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

hash
	^arg1 hash!

initialize
	super initialize.
	mockHandle := self! !

!GdiplusTestInitializer categoriesForMethods!
=!accessing!comparison!public! !
arg1!accessing!public! !
arg1:!accessing!public! !
createHandle!private!realizing/unrealizing! !
hash!accessing!public! !
initialize!initializing!public! !
!

!GdiplusTestInitializer class methodsFor!

new
	^self basicNew initialize! !

!GdiplusTestInitializer class categoriesForMethods!
new!instance creation!public! !
!

