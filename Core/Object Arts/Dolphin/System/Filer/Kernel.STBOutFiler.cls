"Filed out from Dolphin Smalltalk"!

Kernel.STxOutFiler
	subclass: #'Kernel.STBOutFiler'
	instanceVariableNames: ''
	classVariableNames: 'Versions'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBOutFiler guid: (Core.GUID fromString: '{87b4c6e8-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STBOutFiler comment: '`STBOutFiler` is the basic binary filer for serializing a tree of `Object`s to a byte stream.

`STBOutFiler` itself currently supports writing the STB 6 binary object serialization format. There are subclasses for writing each of the earlier versions from the original STB v0 up to previous version. The correct class of serializer can be specified using one of the instance creation methods that accepts a version number, or the relevant subclass can be instantiated directly.

Note that although the old formats can be written with complete fidelity, this does not guarantee that the data will be deserializable in an older version of Dolphin because it may contain classes that are not present in the older image, or which have a different layout.

STB 6 differs from STB 5 in not requiring the use of proxies for most collections. SortedCollections are still be proxied, however.

'!
!Kernel.STBOutFiler categoriesForClass!System-Binary storage! !
!Kernel.STBOutFiler methodsFor!

inFilerClass
	^STBInFiler!

saveArray: anArray
	| size |
	self writePreambleFor: anArray class: anArray basicClass.
	stream nextInt32Put: (size := anArray basicSize).
	1 to: size do: [:i | self nextPut: (anArray basicAt: i)]!

saveBindingReference: aBindingReference
	self saveObject: aBindingReference!

saveBoolean: aBoolean
	"Serialize a <Boolean> value to the object stream."

	self writeReference: (aBoolean ifTrue: [0] ifFalse: [1])!

saveByteArray: aByteArray
	"Save a <ByteArray> to the object stream"

	self saveByteObject: aByteArray!

saveCharacter: aCharacter
	"Serialize a <Character> to the object stream."

	stream nextInt32Put: ((aCharacter codePoint bitShift: PrefixRefShift) bitOr: PrefixCharacterMask)!

saveClass: aClass
	"Serialize a <Class> to the object stream. Note that only a reference is saved. The class must be present in the image where the stream is deserialised."

	"In STB a proxy is used"

	self saveObject: aClass
		as: (STBClassProxy locatorKey: (self locatorKeyFor: aClass) package: aClass owningPackage)!

saveCollection: aCollection
	"STx version 6 no longer uses the collection proxies."

	self writePreambleFor: aCollection class: aCollection basicClass.
	stream nextInt32Put: aCollection size.
	aCollection do: [:each | self nextPut: each]!

saveFloat: aFloat
	"Serialize a <Float> to the object stream."

	self saveObject: aFloat!

saveLargeInteger: aLargeInteger
	"Serialize a <LargeInteger> to the object stream"

	self saveObject: aLargeInteger!

saveLookupTable: aLookupTable
	"Serialize a <LookupTable> to the object stream."

	"STB version 6 no longer uses the collection proxies. LookupTables are written as a class, size, and a sequence of key-value pairs."

	self writePreambleFor: aLookupTable class: aLookupTable basicClass.
	stream nextInt32Put: aLookupTable size.
	self writeLookupTableElements: aLookupTable!

saveMetaclass: aMetaclass
	"Save a metaclass instance to the object stream."

	"In STB metaclasses, like classes, are always proxied"

	| inst |
	inst := aMetaclass instanceClass.
	self saveObject: aMetaclass
		as: (STBMetaclassProxy locatorKey: (self locatorKeyFor: inst) package: inst owningPackage)!

saveNil
	"Serialize nil to the object stream"

	"In STB nil has the special object reference 0"

	stream nextInt32Put: 0!

saveScaledDecimal: aScaledDecimal
	"Serialize a <ScaledDecimal> to the object stream."

	self saveObject: aScaledDecimal!

saveSet: aSet elements: aCollection
	"Save a <Set> with elements in the 2nd argument to the object stream. In the case of a <Set> the first and second arguments are typically identical. In the case of a Dictionary, the 2nd argument should be the associations."

	"As of STB 6, collections are no longer proxied."

	self writePreambleFor: aSet class: aSet basicClass.
	stream nextInt32Put: aSet size.
	self writeSetElements: aCollection!

saveSmallInteger: aSmallInteger
	"Serialize a <SmallInteger> to the object stream."

	stream nextInt32Put: ((aSmallInteger bitShift: 1) bitOr: 1)!

saveStatic: aBindingReference
	"Serialize a static variable reference into the stream. "

	self saveObject: aBindingReference
		as: (STBStaticVariableProxy reference: aBindingReference asFullyQualifiedReference)!

saveString: aString
	"Serialize a <String> into the object stream."

	"We always store strings in UTF-8 form now.  UTF-8 is the best encoding for serialisation as it preserves the correct code points in (generally) the minimum space, and is not sensitive to byte ordering. This does mean that the original class of the string is lost, but this is generally desirable. AnsiStrings are largely obsolete and cannot be saved/restored correctly across hosts with different system code pages. Utf16Strings are usually only needed for calling Windows APIs - in the image they are interchangeable with Utf8Strings. Although the class of Utf16Strings and AnsiStrings is not preserved, identity within the graph is, i.e. a string with shared references in the input graph will have the same shared references in the deserialised graph. Non-literal (unprintable) strings are stored as if a general byte object of class Utf8String."

	| utf8 size |
	self writePreambleFor: aString class: Utf8String.
	utf8 := aString asUtf8String.
	stream nextInt32Put: (size := utf8 size).
	1 to: size do: [:i | stream nextPut: (utf8 basicAt: i)]!

saveSymbol: aSymbol
	"Serialize a <Symbol> into the object stream."

	self saveObject: aSymbol!

writeByteObject: aByteObject
	| size |
	size := aByteObject basicSize.
	stream
		nextInt32Put: size;
		basicNext: size
			putAll: aByteObject
			startingAt: 1!

writeClass: aClass prefix: anInteger version: verInteger instSize: sizeInteger
	| locatorString prefixCode |
	locatorString := self locatorKeyFor: aClass.
	prefixCode := anInteger bitOr: (locatorString size bitShift: PrefixLocatorLenShift).
	aClass isBytes
		ifTrue: [prefixCode := prefixCode bitOr: PrefixBytesMask]
		ifFalse: 
			[prefixCode := prefixCode bitOr: (sizeInteger bitShift: PrefixInstSizeShift).
			aClass isVariable ifTrue: [prefixCode := prefixCode bitOr: PrefixVariableMask]].
	verInteger == 0
		ifTrue: [stream nextInt32Put: prefixCode]
		ifFalse: 
			[stream
				nextInt32Put: (prefixCode bitOr: PrefixNonZeroVersionMask);
				nextInt32Put: verInteger].
	stream nextPutAll: locatorString asByteArray!

writeClassReference: anInteger prefix: prefixInteger
	stream nextInt32Put: (prefixInteger bitOr: (anInteger bitShift: PrefixRefShift))!

writeInstanceVariables: anObject
	| instanceSpec |
	instanceSpec := anObject basicClass instanceSpec.
	(instanceSpec anyMask: Behavior._VariableMask)
		ifTrue: 
			[| basicSize |
			"As of V1, the indexed size was only written for indexable objects"
			stream nextInt32Put: (basicSize := anObject basicSize).
			(instanceSpec anyMask: Behavior._PointersMask)
				ifFalse: 
					[1 to: basicSize
						do: 
							[:i |
							"Bytes written directly"
							stream nextPut: (anObject basicAt: i)]]
				ifTrue: 
					[1 to: (instanceSpec bitAnd: Behavior._SizeMask) + basicSize
						do: [:i | self nextPut: (anObject instVarAt: i)]]]
		ifFalse: 
			[1 to: (instanceSpec bitAnd: Behavior._SizeMask) do: [:i | self nextPut: (anObject instVarAt: i)]]!

writeReference: anInteger
	stream nextInt32Put: (anInteger bitShift: PrefixRefShift)!

writeSignatureAndVersion
	stream
		nextPutAll: STBInFiler.Signature;
		nextPutAll: self version printString asByteArray;
		nextPut: 16r20! !
!Kernel.STBOutFiler categoriesForMethods!
inFilerClass!constants!private! !
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
writeClass:prefix:version:instSize:!operations!private! !
writeClassReference:prefix:!operations!private! !
writeInstanceVariables:!operations!private! !
writeReference:!operations!private! !
writeSignatureAndVersion!operations!private! !
!

!Kernel.STBOutFiler class methodsFor!

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

newStream
	^WriteStream on: (ByteArray new: 256)!

register
	Versions at: self version + 1 put: self!

stxFormatName
	"Answer the format name, either STB or STL."

	^'STB'!

unregister
	Versions at: self version + 1 put: nil!

version
	^6!

versions
	^Versions! !
!Kernel.STBOutFiler class categoriesForMethods!
initialize!class initialization!public! !
newStream!helpers!private! !
register!class initialization!private! !
stxFormatName!constants!public! !
unregister!class hierarchy-removing!private! !
version!constants!public! !
versions!accessing!public! !
!

