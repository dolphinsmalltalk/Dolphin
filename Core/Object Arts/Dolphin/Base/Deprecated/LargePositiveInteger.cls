"Filed out from Dolphin Smalltalk"!

OldLargeInteger
	variableByteSubclass: #LargePositiveInteger
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
LargePositiveInteger guid: (Core.GUID fromString: '{be039142-e0dd-4467-b669-b0578409c254}')!
LargePositiveInteger comment: ''!
!LargePositiveInteger categoriesForClass!Magnitude-Numbers! !
!LargePositiveInteger class methodsFor!

stbConvertFrom: anSTBClassFormat
	"Private - Convert from version 0 sign-magnitude LargeIntegers with separate +ve/-ve classes
	to version 1 format LargeIntegers with 2's complement representation and a single class."

	^[:data | LargeInteger fromBytes: data]! !
!LargePositiveInteger class categoriesForMethods!
stbConvertFrom:!binary filing!private! !
!

