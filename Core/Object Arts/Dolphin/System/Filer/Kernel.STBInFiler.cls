"Filed out from Dolphin Smalltalk"!

Kernel.AbstractSTBInFiler
	subclass: #'Kernel.STBInFiler'
	instanceVariableNames: 'classLocator'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBInFiler guid: (Core.GUID fromString: '{87b4c6e7-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STBInFiler comment: ''!
!Kernel.STBInFiler categoriesForClass!System-Binary storage! !
!Kernel.STBInFiler methodsFor!

basicNext
	"Private - Answer the next object from the receiver's stream."

	^policy readObjectWithPrefix: stream nextInt32!

classLocator
	"Answer the receiver's classLocator inst var. This holds the context of any remote
	class references and provides the mechanism of resolving them."

	^classLocator!

classLocator: aClassLocator
	"Sets the receiver's classLocator instVar to aClassLocator.
	This is required to hold the context of any relative class reference and to provide
	the mechanism for resolving it."

	classLocator := aClassLocator!

defaultClassLocatorClass
	"Answer the class of Class Locator to use by default for finding and validating
	classes in the receiver's input stream."

	^ClassLocator!

initialize
	"Private - Initialize the receiver."

	classLocator := self defaultClassLocatorClass new.
	^super initialize!

readBytes: answer
	self stream
		basicNext: answer basicSize
		into: answer
		startingAt: 1! !
!Kernel.STBInFiler categoriesForMethods!
basicNext!accessing!private! !
classLocator!accessing!public! !
classLocator:!accessing!public! !
defaultClassLocatorClass!constants!private! !
initialize!initializing!private! !
readBytes:!binary filing!public! !
!

!Kernel.STBInFiler class methodsFor!

versionPolicyClass
	^STBVersion0Policy! !
!Kernel.STBInFiler class categoriesForMethods!
versionPolicyClass!constants!private! !
!

