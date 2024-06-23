"Filed out from Dolphin Smalltalk"!

Kernel.STLInFiler
	subclass: #'Kernel.STLLegacyInFiler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.STLLegacyInFiler guid: (Core.GUID fromString: '{361093d2-9470-42cc-89e2-e5f378440a57}')!

Kernel.STLLegacyInFiler isNonInstantiable: true!

Kernel.STLLegacyInFiler comment: '`STBLegacyInFiler` is the abstract class of  `STLInFiler`s for previous STL versions.'!

!Kernel.STLLegacyInFiler categoriesForClass!System-Binary storage! !

!Kernel.STLLegacyInFiler methodsFor!

lastPredefined
	"Private - Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^LastPredefinedClassRef!

readExtensibleCollection: aClass format: anSTBClassConversion size: anInteger
	"Should not be received as this version emits proxied collections with STBCollectionProxy instances"

	^self shouldNotImplement!

readLookupTable: aClass format: anSTBClassConversion size: anInteger
	"Should not be received as this version emits STBIdentityDictionaryProxy for LookupTables"

	^self shouldNotImplement! !

!Kernel.STLLegacyInFiler categoriesForMethods!
lastPredefined!constants!private! !
readExtensibleCollection:format:size:!operations!public! !
readLookupTable:format:size:!operations!public! !
!

