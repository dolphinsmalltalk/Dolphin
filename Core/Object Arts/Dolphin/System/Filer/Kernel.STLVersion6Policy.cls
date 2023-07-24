"Filed out from Dolphin Smalltalk"!

Kernel.STLVersionPolicyForNamespaces
	subclass: #'Kernel.STLVersion6Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLVersion6Policy guid: (Core.GUID fromString: '{a35a81bf-a3ab-47d8-b465-801124261aab}')!
Kernel.STLVersion6Policy comment: ''!
!Kernel.STLVersion6Policy methodsFor!

lastPredefined
	"Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^0!

lookupPredefinedClass: anInteger 
	^nil!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered for every STL stream of this version.
	There is relatively little benefit in pre-registering classes in STL, since we do not have the chicken-before-egg problem that STB has with, for example, Strings, since all the types that are required to support the format have a literal representation and will be instantiated by the compiler. The classes for objects with literal form do not need to be registered. We also do not need the STB class proxies in the STL representation. The downside of pre-registering is that the references to the class are not visible as normal references (although the STLClassCollector will find them). Given the hidden references downside, and limited advantages in STL, we drop all pre-registered classes in STL 6."

	^#()! !
!Kernel.STLVersion6Policy categoriesForMethods!
lastPredefined!constants!public! !
lookupPredefinedClass:!public! !
predefinedClasses!constants!public! !
!

