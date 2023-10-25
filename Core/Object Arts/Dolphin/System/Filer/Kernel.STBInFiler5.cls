"Filed out from Dolphin Smalltalk"!

Kernel.STBInFiler
	subclass: #'Kernel.STBInFiler5'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBInFiler5 guid: (Core.GUID fromString: '{1858465b-b0c0-4a5c-9eca-884d83dbeb49}')!
Kernel.STBInFiler5 comment: '`STBInFiler5` is an `STBInFiler` for deserializing STB object streams created by a version 5 `STBOutFiler`. 

STB 5 was an interim format used in early versions of Dolphin 8. It introduced support for classes located by fully-qualified names (i.e. for namespaces). Classes are expected to implement `#stbReadFrom:format:size:`, rather than `#stbReadFrom:format:`.'!
!Kernel.STBInFiler5 methodsFor!

readExtensibleCollection: aClass format: anSTBClassConversion size: anInteger
	"Should not be received as this version emits proxied collections with STBCollectionProxy instances"

	^self shouldNotImplement!

readLookupTable: aClass format: anSTBClassConversion size: anInteger
	"Should not be received as this version emits STBIdentityDictionaryProxy for LookupTables"

	^self shouldNotImplement! !
!Kernel.STBInFiler5 categoriesForMethods!
readExtensibleCollection:format:size:!operations!public! !
readLookupTable:format:size:!operations!public! !
!

!Kernel.STBInFiler5 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB 5 file."

	^STBInFiler4 predefinedClasses!

uninitialize
	self unregister!

version
	^5! !
!Kernel.STBInFiler5 class categoriesForMethods!
initialize!class initialization!public! !
predefinedClasses!constants!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

