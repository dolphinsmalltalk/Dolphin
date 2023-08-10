"Filed out from Dolphin Smalltalk"!

Kernel.STxVersionPolicy
	subclass: #'Kernel.STLVersionPolicy'
	instanceVariableNames: ''
	classVariableNames: 'Versions'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'PrefixLiteralMask' -> 16r8. 'Signature' -> #'!!STL' }!
Kernel.STLVersionPolicy guid: (Core.GUID fromString: '{e627c38d-3250-49c9-a8ac-efe2bb2e2783}')!
Kernel.STLVersionPolicy isNonInstantiable: true!
Kernel.STLVersionPolicy comment: '`STLVersionPolicy` is the abstract class of policy/strateger plugins for writing and reading the particular STB formats of each version from the original STL, which was v3 to align with the STB version when STL was first introduced, up to the current version.'!
!Kernel.STLVersionPolicy methodsFor!

next
	| prefixOrLiteral |
	prefixOrLiteral := stream next.
	prefixOrLiteral isInteger
		ifFalse: 
			["Atomic values, or an indirection to them; classes are represented by BindingReferences as these have a literal form that can be embedded in literal arrays. This will not include integers, but does include nil, true, false, Symbols, BindingReferences (except as an indirection to a class object), and (in old version STL content) class objects. It cannot include arrays, even of atomic objects, because the array itself is not atomic and may be shared."
			^prefixOrLiteral value].
	PrefixLiteralMask == prefixOrLiteral ifFalse: [^self readObjectWithPrefix: prefixOrLiteral].
	^self readLiteralData!

readBytes: anInteger into: aByteObject
	^stream next
		replaceBytesOf: aByteObject
		from: 1
		to: anInteger
		startingAt: 1!

readClassDataWithPrefix: anInteger
	"As of STL5 the class refs are printed into the STL as BindingReferences. These are true literals (so don't need the ##() expressions to be embedded in the literal array) but need to be resolved back to the class by sending them #value. Note that the resolved binding is cached by the literal BindingReference object, so this is still relatively efficient after the first run through."

	^(anInteger allMask: PrefixNonZeroVersionMask)
		ifTrue: 
			[| versionBeingRead |
			versionBeingRead := stream next.
			filer
				registerClass: stream next value
				version: versionBeingRead
				prefix: anInteger]
		ifFalse: 
			[filer
				registerClass: stream next value
				version: 0
				prefix: anInteger]!

readCollection: aClass format: anSTBClassConversion size: anInteger
	| set |
	set := aClass new: anInteger.
	filer register: set.
	anInteger timesRepeat: [set add: filer basicNext].
	^set!

readInteger
	^stream next!

readLiteralData
	| newObject |
	newObject := stream next.
	newObject basicClass == Array
		ifTrue: 
			[| array size |
			"We have to resolve any BindingReferences in the literal array"
			array := Array basicNew: (size := newObject size).
			1 to: size do: [:i | array at: i put: (newObject at: i) value].
			newObject := array]
		ifFalse: [newObject isImmutable ifTrue: [newObject := newObject copy]].
	filer register: newObject.
	^newObject!

readLookupTable: aClass format: anSTBClassConversion size: anInteger
	"LookupTables have a proxy-less representation in version 6. The format is the the class name and size (already read), followed by a sequence of key-value pairs emitted directly into the STB stream."

	| lookupTable |
	lookupTable := aClass new: anInteger.
	filer register: lookupTable.
	anInteger timesRepeat: [lookupTable at: filer basicNext put: filer basicNext].
	^lookupTable!

readObjectSize: aClass
	^aClass isVariable ifTrue: [stream next] ifFalse: [0]!

readObjectWithPrefix: anInteger
	"Private - In STL version 5 and later, the input stream should not contain encoded nil's or Characters, as these are written as literals. SmallIntegers are still encoded though, as this is necessary to distinguish these from the prefix values."

	| anObject newObjectIndex class |
	(anInteger allMask: PrefixSmallIntegerMask)
		ifTrue: 
			["Encoded in the prefix"
			^anInteger bitShift: -1].
	(anInteger allMask: PrefixDataMask)
		ifFalse: 
			["Must be an object reference"
			^filer objectAt: (anInteger bitShift: PrefixRefUnshift)].

	"Ascertain the class of the object."
	class := (anInteger allMask: PrefixClassMask)
				ifTrue: [self readClassDataWithPrefix: anInteger]
				ifFalse: 
					["Previously encountered class"
					filer classAt: (anInteger bitShift: PrefixRefUnshift)].

	"Now read the object data."
	newObjectIndex := filer readMap size + 1.
	anObject := class stbReadFrom: filer format: (filer converters lookup: class).

	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: filer at: newObjectIndex!

readString: aClass
	"We'll only be here for deserializing non-literal Utf8Strings, which are written as a literal ByteArray."

	^filer basicNext asUtf8String!

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
			1 to: size do: [:i | filer nextPut: (anArray basicAt: i)]]!

saveBindingReference: aBindingReference
	"Save a <BindingReference> to the object stream"

	"Absolute binding references can be written as literals as these will always resolve to the same variable independent of context."

	aBindingReference isRelative
		ifTrue: [self saveObject: aBindingReference]
		ifFalse: [self writeLiteral: aBindingReference]!

saveBoolean: aBoolean
	stream nextPut: aBoolean!

saveByteArray: aByteArray
	self writeLiteral: aByteArray!

saveCharacter: aCharacter
	aCharacter isAtomic ifTrue: [stream nextPut: aCharacter] ifFalse: [self writeLiteral: aCharacter]!

saveClass: aClass
	stream nextPut: aClass!

saveCollection: aCollection
	"From STL version 6, collection proxies are no longer used and collection elements are written directly."

	self writePreambleFor: aCollection class: aCollection basicClass.
	stream nextPut: aCollection size.
	aCollection do: [:each | filer nextPut: each]!

saveFloat: aFloat
	aFloat isFinite
		ifTrue: [self writeLiteral: aFloat]
		ifFalse: [stream nextPut: aFloat printString asQualifiedReference]!

saveLargeInteger: aLargeInteger
	self writeLiteral: aLargeInteger!

saveLookupTable: aLookupTable
	"STL version 6 no longer uses the collection proxies."

	self writePreambleFor: aLookupTable class: aLookupTable basicClass.
	stream nextPut: aLookupTable size.
	(self sortCollectionElements: aLookupTable associations) do: 
			[:each |
			filer
				nextPut: each key;
				nextPut: each value]!

saveMetaclass: aMetaclass
	stream nextPut: aMetaclass!

saveNil
	stream nextPut: nil!

saveScaledDecimal: aScaledDecimal
	aScaledDecimal isLiteral
		ifTrue: [self writeLiteral: aScaledDecimal]
		ifFalse: [self saveObject: aScaledDecimal]!

saveSet: aSet elements: aCollection
	"Save a <Set> with elements in the 2nd argument to the object stream. In the case of a <Set> the first and second arguments are typically identical. In the case of a Dictionary, the 2nd argument should be the associations.
	From STL version 6, collection proxies are no longer used and the elements are written directly. They are first sorted, if possible in the natural order but failing that in printString order, to improve the source stability."

	self writePreambleFor: aSet class: aSet basicClass.
	stream nextPut: aCollection size.
	(self sortCollectionElements: aCollection) do: [:each | filer nextPut: each]!

saveSmallInteger: aSmallInteger
	stream nextPut: ((aSmallInteger bitShift: 1) bitOr: 1)!

saveStatic: aBindingReference
	stream nextPut: aBindingReference asFullyQualifiedReference!

saveString: aString
	| utf8 |
	utf8 := aString asUtf8String.
	utf8 isLiteral
		ifTrue: 
			[filer register: aString.
			stream
				nextPut: PrefixLiteralMask;
				nextPut: utf8]
		ifFalse: 
			["Store non-printable Utf8Strings as byte arrays"
			self writePreambleFor: aString class: Utf8String.
			stream nextPut: utf8 asByteArray]!

saveSymbol: aSymbol
	stream nextPut: aSymbol!

sortCollectionElements: aCollection
	"Private - We want the elements printed in a stable order, e.g. so that if in source code we don't get gratuitous diffs occurring."

	^[aCollection asSortedArray] on: Error
		do: 
			[:ex |
			| strm |
			"Fall back on sorting by printString representation"
			strm := String smalltalkWriteStream.
			aCollection asSortedArray:  
					[:a :b |
					| ap bp |
					strm reset.
					a printOn: strm.
					ap := strm contents.
					strm reset.
					b printOn: strm.
					bp := strm contents.
					ap <==> bp <= 0]]!

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

writeClass: aClass prefix: anObject
	| code |
	"STL doesn't write the locator string, so its length does not need to be encoded in the prefix"
	code := PrefixClassMask bitOr: (aClass instSize bitShift: PrefixInstSizeShift).
	aClass isVariable
		ifTrue: [code := code bitOr: (aClass isBytes ifTrue: [PrefixBytesMask] ifFalse: [PrefixVariableMask])].
	aClass stbVersion == 0
		ifTrue: [stream nextPut: code]
		ifFalse: 
			[stream
				nextPut: (code bitOr: PrefixNonZeroVersionMask);
				nextPut: aClass stbVersion].
	stream nextPut: aClass!

writeClassReference: anInteger prefix: prefixInteger
	stream nextPut: (prefixInteger bitOr: (anInteger bitShift: PrefixRefShift))!

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
						do: [:i | filer nextPut: (anObject instVarAt: i)]]]
		ifFalse: 
			[1 to: (instanceSpec bitAnd: Behavior._SizeMask) do: [:i | filer nextPut: (anObject instVarAt: i)]]!

writeLiteral: aString
	filer register: aString.
	stream
		nextPut: PrefixLiteralMask;
		nextPut: aString!

writeReference: anInteger
	stream nextPut: (anInteger == 0 ifFalse: [anInteger bitShift: PrefixRefShift])!

writeSignatureAndVersion
	stream
		nextPut: Signature;
		nextPut: version! !
!Kernel.STLVersionPolicy categoriesForMethods!
next!accessing!private! !
readBytes:into:!operations!public! !
readClassDataWithPrefix:!operations!public! !
readCollection:format:size:!operations!public! !
readInteger!operations!public! !
readLiteralData!helpers!private! !
readLookupTable:format:size:!operations!public! !
readObjectSize:!operations!public! !
readObjectWithPrefix:!operations!private! !
readString:!binary filing!public! !
saveArray:!binary filing!public! !
saveBindingReference:!binary filing!public! !
saveBoolean:!binary filing!public! !
saveByteArray:!binary filing!public! !
saveCharacter:!binary filing!public! !
saveClass:!binary filing!public! !
saveCollection:!operations!public! !
saveFloat:!binary filing!public! !
saveLargeInteger:!binary filing!public! !
saveLookupTable:!operations!public! !
saveMetaclass:!binary filing!public! !
saveNil!binary filing!public! !
saveScaledDecimal:!binary filing!public! !
saveSet:elements:!operations!public! !
saveSmallInteger:!binary filing!public! !
saveStatic:!binary filing!public! !
saveString:!binary filing!public! !
saveSymbol:!binary filing!public! !
sortCollectionElements:!printing!private! !
writeByteObject:!operations!private! !
writeClass:prefix:!operations!private! !
writeClassReference:prefix:!operations!private! !
writeInstanceVariables:!operations!private! !
writeLiteral:!operations!private! !
writeReference:!operations!private! !
writeSignatureAndVersion!operations!private! !
!

!Kernel.STLVersionPolicy class methodsFor!

formatName
	"Answer the format name."

	^'STL'!

initialize
	"
	self initialize
	"

	"The first STL resources are from D6. Originally the STL version tracked the STB version, so the first STL version was 3."

	Versions := (Array new: 7)
				at: 7 put: STLVersion6Policy;
				yourself!

literalPrinterClass
	^self subclassResponsibility!

peekForSignatureIn: aReadStream
	"Answer whether the <readableStream> argument, aReadStream, appears to be an STL stream (or is positioned at the start of an STL stream). If the STL signature is found, then the stream is left positioned immediately after it, otherwise the stream position is not changed."

	| position |
	position := aReadStream position.
	^aReadStream nextAvailable = Signature or: 
			[aReadStream position: position.
			false]!

readVersionFrom: anSTLInFiler
	| ver |
	ver := anSTLInFiler stream nextAvailable.
	^ver isInteger ifTrue: [self filer: anSTLInFiler version: ver]!

register
	Versions at: self version + 1 put: self!

unregister
	Versions at: self version + 1 put: nil!

versions
	^Versions! !
!Kernel.STLVersionPolicy class categoriesForMethods!
formatName!constants!public! !
initialize!class initialization!public! !
literalPrinterClass!constants!public! !
peekForSignatureIn:!public!testing! !
readVersionFrom:!instance creation!public! !
register!class initialization!private! !
unregister!class hierarchy-removing!private! !
versions!accessing!public! !
!

