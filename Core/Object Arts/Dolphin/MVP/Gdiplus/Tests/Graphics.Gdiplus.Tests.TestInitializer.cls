"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.Tests.TestInitializer'
	instanceVariableNames: 'mockHandle arg1'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.TestInitializer guid: (Core.GUID fromString: '{256bd680-0b78-486f-a0a0-99651f0b42a0}')!
Graphics.Gdiplus.Tests.TestInitializer comment: ''!
!Graphics.Gdiplus.Tests.TestInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.TestInitializer methodsFor!

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
!Graphics.Gdiplus.Tests.TestInitializer categoriesForMethods!
=!accessing!comparison!public! !
arg1!accessing!public! !
arg1:!accessing!public! !
createHandle!private!realizing/unrealizing! !
hash!accessing!public! !
initialize!initializing!public! !
!

!Graphics.Gdiplus.Tests.TestInitializer class methodsFor!

new
	^self basicNew initialize! !
!Graphics.Gdiplus.Tests.TestInitializer class categoriesForMethods!
new!instance creation!public! !
!

