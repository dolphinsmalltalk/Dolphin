"Filed out from Dolphin Smalltalk"!

Kernel.STxInFiler
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
	^super initialize! !
!Kernel.STBInFiler categoriesForMethods!
classLocator!accessing!public! !
classLocator:!accessing!public! !
defaultClassLocatorClass!constants!private! !
initialize!initializing!private! !
!

!Kernel.STBInFiler class methodsFor!

policyClass
	"We deliberately reference the latest version to establish a dependency that prevents the latest version policy from being removed at app deployment time if the STBInFiler is used."

	^STBVersion6Policy! !
!Kernel.STBInFiler class categoriesForMethods!
policyClass!constants!private! !
!

