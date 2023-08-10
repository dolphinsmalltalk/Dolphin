"Filed out from Dolphin Smalltalk"!

Kernel.STBVersion3Policy
	subclass: #'Kernel.STBVersion4Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBVersion4Policy guid: (Core.GUID fromString: '{a7f58978-d185-4fe0-ad35-09149b4daf45}')!
Kernel.STBVersion4Policy comment: ''!
!Kernel.STBVersion4Policy methodsFor!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB v4 file. Differs from V1 in including the UTF encoded string classes."

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

readString: aClass
	"STB4 is from Dolphin 7.1 and writes Utf16Strings as Utf8String equivalents. AnsiStrings were still written, however."

	| size |
	size := stream nextInt32.
	^self readBytes: size into: (aClass new: size)!

saveString: aString
	"STB 4 was introduced in Dolphin 7.1, and had UTF encoded strings. However, Utf16String instances were written as Utf8Strings. This did mean that the class of Utf16Strings was not preserved, but the UTF encoded strings are interchangeable for most purposes."

	| bytes size |
	bytes := aString encoding == #utf16le ifTrue: [aString asUtf8String] ifFalse: [aString].
	self writePreambleFor: aString class: bytes class.
	stream nextInt32Put: (size := bytes size).
	1 to: size do: [:i | stream nextPut: (bytes basicAt: i)]!

saveSymbol: aSymbol
	"Symbols were no longer proxied - newly deserialised objects are all sent #stbFixup:at:, so there is no need to use proxies just to perform fixup.
	The Symbols themselves are now UTF-8 encoded."

	| size |
	self writeClassReference: (filer refForObject: Symbol) prefix: PrefixDataMask.
	filer register: aSymbol.
	stream nextInt32Put: (size := aSymbol size).
	1 to: size do: [:i | stream nextPut: (aSymbol basicAt: i)]! !
!Kernel.STBVersion4Policy categoriesForMethods!
predefinedClasses!constants!public! !
readString:!binary filing!public! !
saveString:!binary filing!public! !
saveSymbol:!binary filing!public! !
!

!Kernel.STBVersion4Policy class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	^4! !
!Kernel.STBVersion4Policy class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

