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

classLocator
	"Answer the receiver's classLocator inst var. This holds the context of any remote
	class references and provides the mechanism of resolving them."

	^classLocator!

classLocator: aClassLocator
	"Sets the receiver's classLocator instVar to aClassLocator.
	This is required to hold the context of any relative class reference and to provide
	the mechanism for resolving it."

	classLocator := aClassLocator!

initialize
	"Private - Initialize the receiver."

	classLocator := self defaultClassLocatorClass new.
	^super initialize!

newClassLocator
	^classLocator copyWithCodeBase!

readClassLocator: anIntegerFlags
	| locatorString |
	locatorString := (stream next: (anIntegerFlags bitShift: STBPrefix.LocatorLenShift)) asString.
	^(classLocator key: locatorString) locateClass! !
!Kernel.STBInFiler categoriesForMethods!
classLocator!accessing!public! !
classLocator:!accessing!public! !
initialize!initializing!private! !
newClassLocator!helpers!private! !
readClassLocator:!helpers!private! !
!

