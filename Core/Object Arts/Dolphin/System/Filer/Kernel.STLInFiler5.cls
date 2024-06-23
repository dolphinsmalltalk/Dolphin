"Filed out from Dolphin Smalltalk"!

Kernel.STLLegacyInFiler
	subclass: #'Kernel.STLInFiler5'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.STLInFiler5 guid: (Core.GUID fromString: '{c9a0f94d-4ac4-47c4-8f2c-6516e4cf2ba8}')!

Kernel.STLInFiler5 comment: '`STBInFiler5` is an `STBInFiler` for reading the STL 5 literal object serialization format introduced in Dolphin 8 but has been superceded by STL 6.

STL 5 primarily differed from STL 4 in supporting namespaced classes. Classes are stored in the literal array as `BindingReference`s rather than requiring ##() expressions.'!

!Kernel.STLInFiler5 categoriesForClass!System-Binary storage! !

!Kernel.STLInFiler5 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered for every STL 5 stream."

	"STL 5 was an interim D8 format and the pre-registration was largely the same as STL 4, but the unused class proxies are 'removed'. These should never appear in STL streams anyway."

	^##({
		AnsiString.
		Array.
		ByteArray.
		LargeInteger.
		#{Kernel.STBClassProxy}.
		#{Kernel.STBMetaclassProxy}.
		Symbol.
		STBCollectionProxy.
		OrderedCollection.
		STBIdentityDictionaryProxy.
		LookupTable.
		IdentityDictionary.
		Utf8String.
		Utf16String
	})!

uninitialize
	self unregister!

version
	"Private - Answer the version number of the format read by the receiver."

	^5! !

!Kernel.STLInFiler5 class categoriesForMethods!
initialize!class initialization!public! !
predefinedClasses!constants!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!private! !
!

