"Filed out from Dolphin Smalltalk"!

Kernel.STxInFiler
	subclass: #'Kernel.STBInFiler'
	instanceVariableNames: ''
	classVariableNames: 'Versions'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'Signature' -> #[33 83 84 66 32] }!
Kernel.STBInFiler guid: (Core.GUID fromString: '{87b4c6e7-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STBInFiler comment: '`STBInFiler` is the class of object deserializers for reading streams of objects serialized by a corresponding `STBOutFiler`.

`STBInFiler` itself currently supports reading the STB 6 binary object serialization format. There are subclasses for reading each of the earlier versions from the original STB v0 up to previous version. The correct class of deserializer is instantiated automatically by reading the version from the header.

STB 6 differs from STB 5 in dropping the mandatory use of proxies for most collections. SortedCollections are still proxied, however, and other collections can be proxied, e.g. to ensure that the elements are always emitted in a stable ordering.

Backwards compatibility (i.e. reading old formats) should be complete by virtue of this hierarchy of classes and the class specific conversions as implemented by each class'' `stbConvertFrom:` method. Any failure to read an old stream should be considered a bug.

'!
!Kernel.STBInFiler categoriesForClass!System-Binary storage! !
!Kernel.STBInFiler methodsFor!

basicNext
	"Private - Answer the next object from the receiver's stream."

	| anObject newObjectIndex class prefixCode |
	prefixCode := stream nextInt32.
	prefixCode == 0 ifTrue: [^nil].
	"SmallInteger?"
	(prefixCode allMask: PrefixSmallIntegerMask) ifTrue: [^prefixCode bitShift: -1].
	(prefixCode allMask: PrefixDataMask)
		ifFalse: 
			[^(prefixCode allMask: PrefixCharacterMask)
				ifTrue: [decorator characterValue: (prefixCode bitShift: PrefixRefUnshift)]
				ifFalse: [decorator objectAt: (prefixCode bitShift: PrefixRefUnshift)]].
	"Ascertain the class of the object."
	class := (prefixCode allMask: PrefixClassMask)
				ifTrue: [self readClassDataWithPrefix: prefixCode]
				ifFalse: [decorator classAt: (prefixCode bitShift: PrefixRefUnshift)].
	"Now read the object data."
	newObjectIndex := readMap size + 1.
	anObject := class stbReadFrom: decorator format: (converters lookup: class).
	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: decorator at: newObjectIndex!

characterValue: anInteger
	"Answer the <Character> for the specified <Integer> code from the object stream."

	"From STB 4, the Unicode code point was encoded. This is guaranteed to round-trip correctly regardless of system code page."

	^Character codePoint: anInteger!

readBytes: anInteger into: aByteObject
	^stream
		basicNext: anInteger
		into: aByteObject
		startingAt: 1!

readClassDataWithPrefix: anInteger
	"Private - Deserialize the class data preceding the instance data of a class not previously seen in the object stream."

	^self
		registerVersion: ((anInteger allMask: PrefixNonZeroVersionMask)
				ifTrue: [stream nextInt32]
				ifFalse: [0])
		ofClass: (self readClassWithPrefix: anInteger)
		prefix: anInteger!

readClassWithPrefix: anInteger
	| locatorString len |
	len := anInteger bitShift: PrefixLocatorLenUnshift.
	locatorString := Utf8String new: len.
	self readBytes: len into: locatorString.
	^self classLocator locateClass: (FullBindingReference
				pathString: locatorString
				path: nil
				private: false)!

readExtensibleCollection: aClass format: anSTBClassConversion size: anInteger
	| extensibleCollection |
	extensibleCollection := aClass new: anInteger.
	decorator register: extensibleCollection.
	anInteger timesRepeat: [extensibleCollection add: decorator basicNext].
	^extensibleCollection!

readLookupTable: aClass format: anSTBClassConversion size: anInteger
	"LookupTables have a proxy-less representation in version 6. The format is the the class name and size (already read), followed by a sequence of key-value pairs emitted directly into the STB stream."

	| lookupTable |
	lookupTable := aClass new: anInteger.
	decorator register: lookupTable.
	anInteger timesRepeat: [lookupTable at: decorator basicNext put: decorator basicNext].
	^lookupTable!

readSizeOf: aClass
	"Read the indexable size of an object of the specified <Class> from the object stream."

	"As of STB version 3, the out-filer only writes the object size for indexable objects."

	^aClass isVariable ifTrue: [stream nextInt32] ifFalse: [0]!

readString: aClass format: aSTxClassConversion
	"Deserialize a <String> from the object stream."

	| size string |
	size := stream nextInt32.
	string := aClass new: size.
	decorator register: string.
	^self readBytes: size into: string!

readSymbol: aSTxClassConversion
	"Deserialize a <Symbol> from the object stream."

	| size symbol |
	size := stream nextInt32.
	symbol := Symbol intern: (self readBytes: size into: (Utf8String new: size)).
	decorator register: symbol.
	^symbol! !
!Kernel.STBInFiler categoriesForMethods!
basicNext!accessing!private! !
characterValue:!helpers!public! !
readBytes:into:!helpers!private! !
readClassDataWithPrefix:!operations!public! !
readClassWithPrefix:!operations!private! !
readExtensibleCollection:format:size:!operations!public! !
readLookupTable:format:size:!operations!public! !
readSizeOf:!deserializing!public! !
readString:format:!deserializing!public! !
readSymbol:!deserializing!public! !
!

!Kernel.STBInFiler class methodsFor!

initialize
	"
		Version 0 - Dolphin 1 through 4. 
		Version 1 - Dolphin 5. Preregisters certain commonly occurring classes
		Version 2 - Delegates save/load to class, format changed for certain pre-registered classes. Symbols no longer proxied.
		Version 3 - Only writes basicSize for objects of variable classes.
		Version 4 - Dolphin 7. No real format change in STB, although UTF strings appear in the stream. New version of STL.
		Version 5 - Dolphin 8. Fully-qualified class names written. Classes are expected to implement #stbReadFrom:format:size:, rather than #stbReadFrom:format:.
		Version 6 - Proxyless collections

	self initialize. self allSubclasses do: [:each | each isAbstract ifFalse: [each initialize]]
	"

	Versions := Array new: 7.
	self register!

peekForSignatureIn: aReadStream
	"Answer whether the <readableStream> argument, aReadStream, appears to be an STB stream (or is positioned at the start of an STB stream). If the STB	signature is found, then the stream is left positioned immediately after it, otherwise the stream position is not changed."

	| position |
	position := aReadStream position.
	^(aReadStream nextAvailable: ##(Signature size)) asByteArray = Signature
		or: [aReadStream position: position. false]!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB file."

	"As of STB 6 the collection proxies are no longer used routinely, but they are still occasionally useful. e.g. for forcing a stable order of the key/value pairs, so are retained. However object streams should no longer contain AnsiStrings - Strings are always written with UTF-8 encoding so that they deserialise with the original code points, regardless of the system code page on the target system."

	^##({
		#{AnsiString}.
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

readVersionFrom: aByteStream
	"Private - Read and answer the <integer> STB format version encoded in the byte stream."

	| byte ver |
	byte := aByteStream nextAvailable.
	byte ifNil: [^nil].
	ver := byte - ##($0 asciiValue).
	(ver < 0 or: [ver > 9]) ifTrue: [^nil].
	
	[byte := aByteStream nextAvailable.
	byte notNil and: [byte >= ##($0 asciiValue) and: [byte <= ##($9 asciiValue)]]]
			whileTrue: [ver := ver * 10 + (byte - ##($0 asciiValue))].
	"There should be a space separator demarking the end of the version number"
	byte == ##(Character space asciiValue) ifFalse: [^nil].
	^ver!

register
	Versions at: self version + 1 put: self!

stxFormatName
	"Answer the format name, either STB or STL."

	^'STB'!

unregister
	Versions at: self version + 1 put: nil!

versions
	^Versions! !
!Kernel.STBInFiler class categoriesForMethods!
initialize!class initialization!public! !
peekForSignatureIn:!public!testing! !
predefinedClasses!public! !
readVersionFrom:!helpers!private! !
register!class initialization!private! !
stxFormatName!constants!public! !
unregister!class hierarchy-removing!private! !
versions!accessing!public! !
!

