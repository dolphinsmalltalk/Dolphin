"Filed out from Dolphin Smalltalk"!

Core.Object
	variableByteSubclass: #OldLargeInteger
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OldLargeInteger guid: (Core.GUID fromString: '{f307f1dc-858b-482a-9a22-90d0aae852d5}')!
OldLargeInteger comment: ''!
!OldLargeInteger categoriesForClass!Magnitude-Numbers! !
!OldLargeInteger class methodsFor!

stbConvertFrom: anSTBClassFormat
	"Private - Convert from version 0 sign-magnitude LargeIntegers with separate +ve/-ve classes
	to version 1 format LargeIntegers with 2's complement representation and a single class."

	^self subclassResponsibility!

stbVersion
	^1! !
!OldLargeInteger class categoriesForMethods!
stbConvertFrom:!binary filing!private! !
stbVersion!binary filing!private! !
!

