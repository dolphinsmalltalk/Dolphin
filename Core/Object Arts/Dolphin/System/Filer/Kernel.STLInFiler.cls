"Filed out from Dolphin Smalltalk"!

Kernel.STxInFiler
	subclass: #'Kernel.STLInFiler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLInFiler guid: (Core.GUID fromString: '{0eb5f19a-a120-4002-83d9-c520f502de6d}')!
Kernel.STLInFiler comment: ''!
!Kernel.STLInFiler categoriesForClass!System-Binary storage! !
!Kernel.STLInFiler methodsFor!

classLocator
	"Answer a <ClassLocator> for use in resolving classes from the receiver's input stream."

	"No longer required for STL, but older resources may contain STBClassProxy or STBMetaclassProxy objects"

	^ClassLocator new! !
!Kernel.STLInFiler categoriesForMethods!
classLocator!accessing!public! !
!

!Kernel.STLInFiler class methodsFor!

policyClass
	^STLVersionPolicy! !
!Kernel.STLInFiler class categoriesForMethods!
policyClass!constants!private! !
!

