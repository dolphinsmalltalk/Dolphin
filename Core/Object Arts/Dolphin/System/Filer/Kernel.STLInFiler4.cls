"Filed out from Dolphin Smalltalk"!

Kernel.STLLegacyInFiler
	subclass: #'Kernel.STLInFiler4'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.STLInFiler4 guid: (Core.GUID fromString: '{20bbaf4d-fd4b-46a4-a73b-7b94062bfc63}')!

Kernel.STLInFiler4 comment: '`STBInFiler4` is an `STLInFiler` for reading the STL 4 literal object serialization format introduced in Dolphin 7.1.

STL 4 primarily differed from STL 3 in storing all strings as UTF-8 encoded literal strings. At some point in its history nil''s started being written in literal form rather than as a zero prefix code, but although this should have resulted in a version increment, that did not happen.'!

!Kernel.STLInFiler4 categoriesForClass!System-Binary storage! !

!Kernel.STLInFiler4 methodsFor!

readBytes: anInteger into: aByteObject
	1 to: anInteger do: [:i | aByteObject basicAt: i put: stream next].
	^aByteObject!

readClassDataWithPrefix: anInteger
	"Private - Deserialize the class data preceding the instance data of a class not previously seen in the object stream."

	^self
		registerVersion: ((anInteger allMask: PrefixNonZeroVersionMask) ifTrue: [stream next] ifFalse: [0])
		ofClass: stream next
		prefix: anInteger!

readObjectWithPrefix: anInteger
	"Private - Deserialize an object from the literal stream with the specified <Integer> prefix code."

	"In STL 4+ the input stream won't contain encoded Characters, as these are written as literals. SmallIntegers are still encoded though, as this is necessary to distinguish these from the prefix values. STL 4 streams from Dolphin 7.1 won't contain encoded nil's either, but some earlier streams with the same version will because the outer version wasn't incremented when the change was made to emit nil as a literal (i.e. it was backwards, though not forwards, compatible)."

	anInteger == 0 ifTrue: [^decorator readNil].
	^super readObjectWithPrefix: anInteger!

readString: aClass format: aSTxClassConversion
	"Deserialize a <String> from the object stream."

	"In STL 4, all Strings were serialized as literals, regardless of original encoding and whether printable or not. They were never saved in binary form"

	self shouldNotImplement! !

!Kernel.STLInFiler4 categoriesForMethods!
readBytes:into:!helpers!private! !
readClassDataWithPrefix:!operations!public! !
readObjectWithPrefix:!operations!private! !
readString:format:!deserializing!public! !
!

!Kernel.STLInFiler4 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered for every STL 4 stream."

	"There is relatively little benefit in pre-registering classes in STL, since we do not have the chicken-before-egg problem that STB has with, for example, Strings, since all the types that are required to support the format have a literal representation and will be instantiated by the compiler. The classes for objects with literal form do not need to be registered. We also do not need the STB class proxies in the STL representation. However, in all STL versions up to and including 4, all the pre-registered classes used by STB were retained."

	^##({
		AnsiString.
		Array.
		ByteArray.
		LargeInteger.
		STBClassProxy.
		STBMetaclassProxy.
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

	"STL 4 is the version in Dolphin 7.1."

	^4! !

!Kernel.STLInFiler4 class categoriesForMethods!
initialize!class initialization!public! !
predefinedClasses!constants!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!private! !
!

