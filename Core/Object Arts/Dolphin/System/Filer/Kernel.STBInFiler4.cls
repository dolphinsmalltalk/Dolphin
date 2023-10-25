"Filed out from Dolphin Smalltalk"!

Kernel.STBInFiler3
	subclass: #'Kernel.STBInFiler4'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBInFiler4 guid: (Core.GUID fromString: '{ac8e1276-e734-4f62-856f-c6bc1d34dfc4}')!
Kernel.STBInFiler4 comment: '`STBInFiler4` is an `STBInFiler` for reading the STB 4 binary object serialization format.

STB 4 was introduced in Dolphin 7.1, primarily to support UTF-encoded strings.'!
!Kernel.STBInFiler4 methodsFor!

characterValue: anInteger
	"Answer the <Character> for the specified <Integer> code from the object stream."

	"From STB 4, the Unicode code point was encoded. This is guaranteed to round-trip correctly regardless of system code page."

	^Character codePoint: anInteger!

locatorKeyFor: aClass
	"Answer a <String> name for the <Class> argument that receiver's class locator can use to resolve the class."

	"We need to use a backwards compatible name that would have been used for the class prior to the introduction of namespaces in Dolphin 8. This will be the unqualified name that would have appeared in the Smalltalk dictionary."

	^self preNamespaceLocatorKeyFor: aClass!

readString: aClass format: aSTxClassConversion
	"Deserialize a <String> from the object stream."

	"STB4 is from Dolphin 7.1 and writes Utf16Strings as Utf8String equivalents. AnsiStrings were still written, however."

	| size string |
	size := stream nextInt32.
	string := aClass new: size.
	decorator register: string.
	^self readBytes: size into: string!

readSymbol: aSTxClassConversion
	"Deserialize a <Symbol> from the object stream."

	"In STB 4 Symbols were saved without proxy as UTF-8 encoded strings."

	| size symbol |
	size := stream nextInt32.
	symbol := Symbol intern: (self readBytes: size into: (Utf8String new: size)).
	decorator register: symbol.
	^symbol! !
!Kernel.STBInFiler4 categoriesForMethods!
characterValue:!helpers!public! !
locatorKeyFor:!helpers!public! !
readString:format:!deserializing!public! !
readSymbol:!deserializing!public! !
!

!Kernel.STBInFiler4 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB 4 file."

	"Differs from v2/3 in including the UTF encoded string classes."

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
	^4! !
!Kernel.STBInFiler4 class categoriesForMethods!
initialize!class initialization!public! !
predefinedClasses!constants!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

