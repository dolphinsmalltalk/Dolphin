"Filed out from Dolphin Smalltalk"!

OldLargeInteger
	variableByteSubclass: #LargeNegativeInteger
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
LargeNegativeInteger guid: (Core.GUID fromString: '{132e61b2-490d-48d1-9747-050aeeda3815}')!
LargeNegativeInteger comment: ''!
!LargeNegativeInteger categoriesForClass!Magnitude-Numbers!No application! !
!LargeNegativeInteger class methodsFor!

stbConvertFrom: anSTBClassFormat
	"Private - Convert from version 0 sign-magnitude LargeIntegers with separate +ve/-ve classes
	to version 1 format LargeIntegers with 2's complement representation and a single class."

	^[:data | (LargeInteger fromBytes: data) negated]! !
!LargeNegativeInteger class categoriesForMethods!
stbConvertFrom:!binary filing!private! !
!

