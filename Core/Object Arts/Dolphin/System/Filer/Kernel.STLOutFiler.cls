"Filed out from Dolphin Smalltalk"!

Kernel.STxOutFiler
	subclass: #'Kernel.STLOutFiler'
	instanceVariableNames: ''
	classVariableNames: 'Versions'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLOutFiler guid: (Core.GUID fromString: '{72dee7e2-3402-4813-99f6-379ffc717b86}')!
Kernel.STLOutFiler comment: '`STLOutFiler` is a class of object serializers that can store a graph of arbitrary `Object`s as an array of objects that have literal form when fed through an `STLPrinter`. The literal arrays resulting can be stored in the source code of methods, and therefore it provides a generic capability to store object instance state in source code. This format is currently used to store view resources, for example.

`STLOutFiler` itself currently supports writing the STL 6 literal object serialization format. There are subclasses for writing each of the earlier versions from the original STL v3 up to previous version. The correct class of serializer can be specified using one of the instance creation methods that accepts a version number, although when possible it can be helpful for application deployment purposes to refer to the relevant subclass directly to ensure it forms part of the deployed application.

Note that although the old formats can be written with complete fidelity, this does not guarantee that the data will be deserializable in an older version of Dolphin because it may contain classes that are not present in the older image, or which have a different layout. It is generally better to avoid resaving old object streams that you might want to load in a downlevel version of Dolphin.

STL 6 differs from the (interim in Dolphin 8) STL 5 format in the following ways:
  - No classes are pre-registered. This ensures that all classes are visible in the literal array, even `Array`.
  - Proxies are no longer required for most collections. SortedCollections are still proxied, however, and other collections can be proxied, e.g. to ensure that the elements are always emitted in a stable ordering.
  - STL 6 supports a stable mode, which is the default,. The idea is that that when serializing an object graph that is unchanged in stable mode the literal array does not change. Although `STLOutFiler` itself provides basic support for this, e.g. it sorts set elements before storing them, it can also require classes to add specific support in their `#stbSaveOn:` implementations. Browse senders of `#isStable` to see examples.
'!
!Kernel.STLOutFiler categoriesForClass!System-Binary storage! !
!Kernel.STLOutFiler methodsFor!

defaultFlags
	"Private - We want STL to be stable by default - its whole point is to produce a source format after all"

	^StableMask!

inFilerClass
	^STLInFiler!

lastPredefined
	"Private - Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^0!

readBytes: anInteger into: aByteObject
	^stream next
		replaceBytesOf: aByteObject
		from: 1
		to: anInteger
		startingAt: 1!

registerPredefinedObjects
	"Private - We may pre-register a few special objects that must never be recreated, depending on the version policy and format."

	"In STL 5 and later there are no pre-registered objects"!

saveArray: anArray
	"Save an <Array> to the object stream."

	"Arrays can be written as literals iff all their elements are atomic objects. This is because there is no need to consider reference identity for these objects since it is implicit (an atomic class of objects is one where any one value can only have one instance)."

	(anArray allSatisfy: [:each | each isAtomic])
		ifTrue: [self writeLiteral: anArray]
		ifFalse: 
			[| size |
			"No literal form, need to break it down"
			self writePreambleFor: anArray class: anArray basicClass.
			stream nextPut: (size := anArray basicSize).
			1 to: size do: [:i | self nextPut: (anArray basicAt: i)]]!

saveBindingReference: aBindingReference
	"Save a <BindingReference> to the object stream"

	"Absolute binding references can be written as literals as these will always resolve to the same variable independent of context."

	aBindingReference isRelative
		ifTrue: [self saveObject: aBindingReference]
		ifFalse: [self writeLiteral: aBindingReference]!

saveBoolean: aBoolean
	"Serialize a <Boolean> value to the object stream."

	stream nextPut: aBoolean!

saveByteArray: aByteArray
	"Save a <ByteArray> to the object stream"

	self writeLiteral: aByteArray!

saveCharacter: aCharacter
	"Serialize a <Character> to the object stream."

	aCharacter isAtomic ifTrue: [stream nextPut: aCharacter] ifFalse: [self writeLiteral: aCharacter]!

saveClass: aClass
	"Serialize a <Class> to the object stream. Note that only a reference is saved. The class must be present in the image where the stream is deserialised."

	"In STL5/6 the class is stored as a literal binding reference, but the translation is done when the STL is printed for storage in source."

	stream nextPut: aClass!

saveCollection: aCollection
	"From STL version 6, collection proxies are no longer used and collection elements are written directly."

	self writePreambleFor: aCollection class: aCollection basicClass.
	stream nextPut: aCollection size.
	aCollection do: [:each | self nextPut: each]!

saveFloat: aFloat
	"Serialize a <Float> to the object stream."

	"In STL 6+ Floats are stored in literal form if finite, and as a BindingReference if non-finite, with the binding reference resolving to the NaN, PositiveInfinity, or NegativeInfinity class constants of Float."

	aFloat isFinite
		ifTrue: [self writeLiteral: aFloat]
		ifFalse: [stream nextPut: aFloat printString asQualifiedReference]!

saveLargeInteger: aLargeInteger
	"Serialize a <LargeInteger> to the object stream"

	self writeLiteral: aLargeInteger!

saveLookupTable: aLookupTable
	"Serialize a <LookupTable> to the object stream."

	"STL version 6 no longer uses the collection proxies. The representation is the class, size, and then a sequence of key-value pairs. The key-value pairs are sorted in order to improve the stability of the source representation."

	self writePreambleFor: aLookupTable class: aLookupTable basicClass.
	stream nextPut: aLookupTable size.
	self writeLookupTableElements: aLookupTable!

saveMetaclass: aMetaclass
	"Save a metaclass instance to the object stream."

	"As of STL 6, metaclasses are no longer proxied. In STL source representation, generated from the store array, they will printed as meta binding references."

	stream nextPut: aMetaclass!

saveNil
	"Serialize nil to the object stream"

	stream nextPut: nil!

saveScaledDecimal: aScaledDecimal
	"Serialize a <ScaledDecimal> to the object stream."

	aScaledDecimal isLiteral
		ifTrue: [self writeLiteral: aScaledDecimal]
		ifFalse: [self saveObject: aScaledDecimal]!

saveSet: aSet elements: aCollection
	"Save a <Set> with elements in the 2nd argument to the object stream. In the case of a <Set> the first and second arguments are typically identical. In the case of a Dictionary, the 2nd argument should be the associations."

	"From STL version 6, collection proxies are no longer used and the elements are written directly. They are first sorted, if possible in the natural order but failing that in printString order, to improve the source stability."

	self writePreambleFor: aSet class: aSet basicClass.
	stream nextPut: aCollection size.
	self writeSetElements: aCollection!

saveSmallInteger: aSmallInteger
	"Serialize a <SmallInteger> to the object stream."

	stream nextPut: ((aSmallInteger bitShift: 1) bitOr: 1)!

saveStatic: aBindingReference
	"Serialize a static variable reference into the stream."

	stream nextPut: aBindingReference asFullyQualifiedReference!

saveString: aString
	"Serialize a <String> into the object stream."

	"We always store strings in UTF-8 form now.  UTF-8 is the best encoding for serialisation as it preserves the correct code points in (generally) the minimum space, and is not sensitive to byte ordering. This does mean that the original class of the string is lost, but this is generally desirable. AnsiStrings are largely obsolete and cannot be saved/restored correctly across hosts with different system code pages. Utf16Strings are usually only needed for calling Windows APIs - in the image they are interchangeable with Utf8Strings. Although the class of Utf16Strings and AnsiStrings is not preserved, identity within the graph is, i.e. a string with shared references in the input graph will have the same shared references in the deserialised graph. Non-literal (unprintable) strings are stored as if a general byte object of class Utf8String."

	| utf8 |
	utf8 := aString asUtf8String.
	utf8 isLiteral
		ifTrue: 
			[self register: aString.
			stream
				nextPut: STxFiler.PrefixLiteralMask;
				nextPut: utf8]
		ifFalse: 
			["Store non-printable Utf8Strings as byte arrays"
			self writePreambleFor: aString class: Utf8String.
			stream nextPut: utf8 asByteArray]!

saveSymbol: aSymbol
	"Serialize a <Symbol> into the object stream."

	stream nextPut: aSymbol!

writeByteObject: aByteObject
	| size bytes |
	size := aByteObject basicSize.
	bytes := ByteArray new: size.
	aByteObject
		replaceBytesOf: bytes
		from: 1
		to: size
		startingAt: 1.
	stream
		nextPut: size;
		nextPut: bytes!

writeClass: aClass prefix: anInteger
	| code |
	"STL doesn't write the locator string, so its length does not need to be encoded in the prefix"
	code := STxFiler.PrefixClassMask bitOr: (aClass instSize bitShift: STxFiler.PrefixInstSizeShift).
	aClass isVariable
		ifTrue: 
			[code := code
						bitOr: (aClass isBytes ifTrue: [STxFiler.PrefixBytesMask] ifFalse: [STxFiler.PrefixVariableMask])].
	aClass stbVersion == 0
		ifTrue: [stream nextPut: code]
		ifFalse: 
			[stream
				nextPut: (code bitOr: STxFiler.PrefixNonZeroVersionMask);
				nextPut: aClass stbVersion].
	stream nextPut: aClass!

writeClassReference: anInteger prefix: prefixInteger
	stream nextPut: (prefixInteger bitOr: (anInteger bitShift: STxFiler.PrefixRefShift))!

writeInstanceVariables: anObject
	"Private - The first STL version was v3 and followed the same basic layout as STB v3, with a size prefix written for indexable objects only."

	| instanceSpec |
	instanceSpec := anObject basicClass instanceSpec.
	(instanceSpec anyMask: Behavior._VariableMask)
		ifTrue: 
			[| basicSize |
			basicSize := anObject basicSize.
			stream nextPut: basicSize.
			(instanceSpec anyMask: Behavior._PointersMask)
				ifFalse: [1 to: basicSize do: [:i | stream nextPut: (anObject basicAt: i)]]
				ifTrue: 
					[1 to: (instanceSpec bitAnd: Behavior._SizeMask) + basicSize
						do: [:i | self nextPut: (anObject instVarAt: i)]]]
		ifFalse: 
			[1 to: (instanceSpec bitAnd: Behavior._SizeMask) do: [:i | self nextPut: (anObject instVarAt: i)]]!

writeLiteral: anObject
	self register: anObject.
	stream
		nextPut: PrefixLiteralMask;
		nextPut: anObject!

writeReference: anInteger
	stream nextPut: (anInteger == 0 ifFalse: [anInteger bitShift: STxFiler.PrefixRefShift])!

writeSignatureAndVersion
	stream
		nextPut: STLInFiler.Signature;
		nextPut: self version! !
!Kernel.STLOutFiler categoriesForMethods!
defaultFlags!constants!private! !
inFilerClass!constants!private! !
lastPredefined!constants!private! !
readBytes:into:!helpers!private! !
registerPredefinedObjects!initializing!private! !
saveArray:!operations!public! !
saveBindingReference:!operations!public! !
saveBoolean:!public!serializing! !
saveByteArray:!operations!public! !
saveCharacter:!operations!public! !
saveClass:!operations!public! !
saveCollection:!operations!public! !
saveFloat:!operations!public! !
saveLargeInteger:!public!serializing! !
saveLookupTable:!operations!public! !
saveMetaclass:!operations!public! !
saveNil!operations!public! !
saveScaledDecimal:!public!serializing! !
saveSet:elements:!public!serializing! !
saveSmallInteger:!public!serializing! !
saveStatic:!public!serializing! !
saveString:!public!serializing! !
saveSymbol:!public!serializing! !
writeByteObject:!operations!private! !
writeClass:prefix:!operations!private! !
writeClassReference:prefix:!operations!private! !
writeInstanceVariables:!operations!private! !
writeLiteral:!operations!private! !
writeReference:!operations!private! !
writeSignatureAndVersion!operations!private! !
!

!Kernel.STLOutFiler class methodsFor!

initialize
	"
	self initialize. self allSubclasses do: [:each | each isAbstract ifFalse: [each initialize]]
	"

	"The first STL resources are from D6. Originally the STL version tracked the STB version, so the first STL version was 3."

	Versions := (Array new: 7)
				at: 7 put: self;
				yourself!

literalPrinterClass
	^STLPrinter!

newStream
	^WriteStream on: (Array new: 64)!

register
	Versions at: self version + 1 put: self!

stxFormatName
	"Answer the format name, either STB or STL."

	^'STL'!

unregister
	Versions at: self version + 1 put: nil!

version
	"Private - Answer the version number of the format produced by the receiver.
		1 - Preregisters certain commonly occurring classes
		2 - Delegates save/load to class, format changed for certain pre-registered classes.
		3 - Only writes basicSize for objects of variable classes.
		4 - Literal filer stores true, false, Smalltalk, etc as literals rather than special predefined object indices, and stores the full set of atomic objects, and arrays of atomic objects, as literals, not just Strings, Symbols, Integers, ByteArrays, classes and pool dictionaries.
		5 - Fully-qualified class names written. Literal filer stores classes as fully-qualified BindingReferences.
		6 - Proxyless collections and resource libraries. STL has no pre-registered classes, so all referenced classes are immediately visible in the literal array"

	^6!

versions
	^Versions! !
!Kernel.STLOutFiler class categoriesForMethods!
initialize!class initialization!public! !
literalPrinterClass!constants!public! !
newStream!helpers!private! !
register!class initialization!private! !
stxFormatName!constants!public! !
unregister!class hierarchy-removing!private! !
version!constants!private! !
versions!accessing!public! !
!

