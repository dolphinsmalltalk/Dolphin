"Filed out from Dolphin Smalltalk"!

Kernel.STLVersionPolicyForNamespaces
	subclass: #'Kernel.STLVersion5Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'PredefinedClassesV5' -> {
						AnsiString.
						Array.
						ByteArray.
						LargeInteger.
						#STBClassProxy.
						#STBMetaclassProxy.
						Symbol.
						STBCollectionProxy.
						OrderedCollection.
						STBIdentityDictionaryProxy.
						LookupTable.
						IdentityDictionary.
						Utf8String.
						Utf16String
					}
		}!
Kernel.STLVersion5Policy guid: (Core.GUID fromString: '{fd7ff8a8-b50f-4fa1-a6cc-07ee71373f69}')!
Kernel.STLVersion5Policy comment: ''!
!Kernel.STLVersion5Policy methodsFor!

lookupPredefinedClass: anInteger
	^PredefinedClassesV5 lookup: anInteger!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered for every STL stream. 
	There is relatively little benefit in pre-registering classes in STL, since we do not have the chicken-before-egg problem that STB has with, for example, Strings, since all the types that are required to support the format have a literal representation and will be instantiated by the compiler. The classes for objects with literal form do not need to be registered. We also do not need the STB class proxies in the STL representation. However, in all STL versions up to and including 5, the pre-registered classes were retained. We don't expect to encounter STBClassProxy or STBMetaclassProxy references, however, since these are internal implementation detail that is not used in STL."

	^PredefinedClassesV5! !
!Kernel.STLVersion5Policy categoriesForMethods!
lookupPredefinedClass:!accessing!public! !
predefinedClasses!constants!public! !
!

!Kernel.STLVersion5Policy class methodsFor!

initialize
	"
	self initialize
	"

	Versions at: 5+1 put: self!

uninitialize
	Versions at: 5+1 put: nil! !
!Kernel.STLVersion5Policy class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
!

