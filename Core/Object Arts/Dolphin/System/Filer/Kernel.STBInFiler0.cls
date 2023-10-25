"Filed out from Dolphin Smalltalk"!

Kernel.STBInFiler
	subclass: #'Kernel.STBInFiler0'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBInFiler0 guid: (Core.GUID fromString: '{dafbcc07-56bb-4489-8d23-c09bd9d2a4eb}')!
Kernel.STBInFiler0 comment: '`STBInFiler0` is an `STBInFiler` for reading the first STB binary object serialization format, version 0.

This was the original format as used in the earliest betas prior to Dolphin 1.0, right through to Dolphin 4.x.
  - Proxy objects were serialised in the place of certain other objects in order to allow for special fixup behaviours. For example class objects were represented by instances of `STBClassProxy`, and `OrderedCollection`s, `Set`s and `Dictionary` instances by `STBCollectionProxy` instances.
  - There were no pre-registered classes. Later versions pre-registered some classes for both space efficiency, and to fix some obscure boundary cases representing String and STBClassProxy classes.
  - Strings stored in STB used the encoding of the code page where written. If decoded (i.e. deserialised) no a system with a different code page, the resulting String might contain different characters to the original. for any code points outside the ASCII range. This was inherent in the pre-unicode string representation.
'!
!Kernel.STBInFiler0 methodsFor!

characterValue: anIneger
	"Answer the <Character> for the specified <Integer> code from the object stream."

	"Prior to STB 4, the ANSI code unit was encoded, not the Unicode code point. This may mean that the Character does not read back correctly if the system code page is not the same as that when then Character was serialised."

	^Character ansiValue: anIneger!

lastPredefined
	"Private - Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^4!

locatorKeyFor: aClass
	"Answer a <String> name for the <Class> argument that receiver's class locator can use to resolve the class."

	"We need to use a backwards compatible name that would have been used for the class prior to the introduction of namespaces in Dolphin 8, and the addition of UTF-encoded strings in 7.1."

	^self preUtfStringsLocatorKeyFor: aClass!

readClassWithPrefix: anInteger
	| locatorString size |
	locatorString := AnsiString new: (size := (anInteger bitShift: PrefixLocatorLenUnshift)).
	self readBytes: size into: locatorString.
	^self classLocator locateClass: (RelativeBindingReference
				pathString: locatorString
				path: nil
				private: false
				scope: Smalltalk)!

readExtensibleCollection: aClass format: anSTBClassConversion size: anInteger
	"Should not be received as this version emits proxied collections with STBCollectionProxy instances"

	^self shouldNotImplement!

readLookupTable: aClass format: anSTBClassConversion size: anInteger
	"Should not be received as this version emits STBIdentityDictionaryProxy for LookupTables"

	^self shouldNotImplement!

readSizeOf: aClass
	"Read the indexable size of an object of the specified <Class> from the object stream."

	"Size was always written, even though it would be zero for non-indexable objects"

	^stream nextInt32!

readString: aClass format: aSTxClassConversion
	"Deserialize a <String> from the object stream."

	"In STB 0, strings were either in ANSI (code page) form, represented by instances of String, or UTF-16, represented by instances of UnicodeString. We read these now to AnsiString and Utf16String instances respectively, but return the former as a Utf8String to avoid continuing to propagate AnsiStrings since these are undesirable. Unfortunately the code page wasn't included in the STB content, so we may not read the ANSI strings correctly if they were originally written on a system that did not have the same system code page as the system deserializing the STB stream."

	| bytes size string |
	size := stream nextInt32.
	string := aClass == String
				ifTrue: 
					[bytes := AnsiString new: size.
					self readBytes: size into: bytes.
					"Convert to UTF-8 - characters may be garbled if the current code page is different to that active when the string was saved, but this is unavoidable as we do not know what that code page was."
					bytes asUtf8String]
				ifFalse: 
					[bytes := ByteArray new: size.
					self readBytes: size into: bytes.
					aClass fromByteArray: bytes].
	decorator register: string.
	^string!

readSymbol: aSTxClassConversion
	"Deserialize a <Symbol> from the object stream."

	"In STB versions 0 and 1, Symbols were proxied"

	^self shouldNotImplement! !
!Kernel.STBInFiler0 categoriesForMethods!
characterValue:!helpers!public! !
lastPredefined!constants!private! !
locatorKeyFor:!helpers!public! !
readClassWithPrefix:!operations!private! !
readExtensibleCollection:format:size:!operations!public! !
readLookupTable:format:size:!operations!public! !
readSizeOf:!deserializing!public! !
readString:format:!deserializing!public! !
readSymbol:!deserializing!public! !
!

!Kernel.STBInFiler0 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB file of the represented version.
	No classes were pre-registered in the original, version 0, STB format, and hence String and STBClassProxy classes could not be restored from STB, e.g. the following did not work:
		Object fromBinaryStoreBytes: String binaryStoreBytes
	"

	^#()!

uninitialize
	self unregister!

version
	"Answer the format version of the STB stream."

	^0! !
!Kernel.STBInFiler0 class categoriesForMethods!
initialize!class initialization!public! !
predefinedClasses!constants!public! !
uninitialize!class hierarchy-removing!public! !
version!accessing!public! !
!

