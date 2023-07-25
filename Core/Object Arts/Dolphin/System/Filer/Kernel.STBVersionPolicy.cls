"Filed out from Dolphin Smalltalk"!

Kernel.STxVersionPolicy
	subclass: #'Kernel.STBVersionPolicy'
	instanceVariableNames: ''
	classVariableNames: 'Versions'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'Signature' -> #[33 83 84 66 32] }!
Kernel.STBVersionPolicy guid: (Core.GUID fromString: '{f475def0-9dbb-40da-b618-b76ffddf5c16}')!
Kernel.STBVersionPolicy isNonInstantiable: true!
Kernel.STBVersionPolicy comment: ''!
!Kernel.STBVersionPolicy methodsFor!

lastPredefined
	"Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^4!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB file of the represented version.
	No classes were pre-registered in the original, version 0, STB format, and hence String and STBClassProxy classes could not be restored from STB, e.g. the following did not work:
		Object fromBinaryStoreBytes: String binaryStoreBytes
	"

	^#()!

putCharacter: aCharacter
	stream nextInt32Put: ((aCharacter codePoint bitShift: STxFiler.PrefixRefShift)
				bitOr: STxFiler.PrefixCharacterMask)!

putNil
	stream nextInt32Put: 0!

putSmallInteger: aSmallInteger
	stream nextInt32Put: ((aSmallInteger bitShift: 1) bitOr: 1)!

readByteObject: aByteObject
	stream
		basicNext: aByteObject basicSize
		into: aByteObject
		startingAt: 1!

readClassDataWithPrefix: anInteger
	| versionBeingRead |
	versionBeingRead := (anInteger allMask: STxFiler.PrefixNonZeroVersionMask)
				ifTrue: [stream nextInt32]
				ifFalse: [0].
	^filer
		registerClass: (self readClassWithPrefix: anInteger)
		version: versionBeingRead
		prefix: anInteger!

readInteger
	^stream nextInt32!

readObjectSize: aClass
	^stream nextInt32!

serializeObject: anObject
	anObject stbSaveOn: filer!

writeByteObject: aByteObject
	| size |
	size := aByteObject basicSize.
	stream
		nextInt32Put: size;
		next: size
			putAll: aByteObject
			startingAt: 1!

writeClass: aClass
	| locatorString prefixCode |
	locatorString := self classLocatorStringFor: aClass.
	prefixCode := STxFiler.PrefixClassMask
				bitOr: ((locatorString size bitShift: STxFiler.PrefixLocatorLenShift)
						bitOr: (aClass instSize bitShift: STxFiler.PrefixInstSizeShift)).
	aClass isVariable
		ifTrue: 
			[prefixCode := prefixCode
						bitOr: (aClass isBytes ifTrue: [STxFiler.PrefixBytesMask] ifFalse: [STxFiler.PrefixVariableMask])].
	aClass stbVersion == 0
		ifTrue: [stream nextInt32Put: prefixCode]
		ifFalse: 
			[stream
				nextInt32Put: (prefixCode bitOr: STxFiler.PrefixNonZeroVersionMask);
				nextInt32Put: aClass stbVersion].
	stream nextPutAll: locatorString asByteArray!

writeClassReference: anInteger
	stream nextInt32Put: (STxFiler.PrefixDataMask bitOr: (anInteger bitShift: STxFiler.PrefixRefShift))!

writeInteger: anInteger
	stream nextInt32Put: anInteger!

writeReference: anInteger
	stream nextInt32Put: (anInteger bitShift: STxFiler.PrefixRefShift)!

writeSignatureAndVersion
	stream
		nextPutAll: Signature;
		nextPutAll: version printString asByteArray;
		nextPut: 16r20! !
!Kernel.STBVersionPolicy categoriesForMethods!
lastPredefined!constants!public! !
predefinedClasses!constants!public! !
putCharacter:!operations!public! !
putNil!operations!public! !
putSmallInteger:!operations!public! !
readByteObject:!operations!public! !
readClassDataWithPrefix:!operations!public! !
readInteger!operations!public! !
readObjectSize:!operations!public! !
serializeObject:!operations!public! !
writeByteObject:!operations!public! !
writeClass:!operations!public! !
writeClassReference:!operations!public! !
writeInteger:!operations!public! !
writeReference:!operations!public! !
writeSignatureAndVersion!operations!public! !
!

!Kernel.STBVersionPolicy class methodsFor!

initialize
	"
		Version 0 - Dolphin 1 through 5. 
		Version 1 - Dolphin 6. Preregisters certain commonly occurring classes
		Version 2 - Delegates save/load to class, format changed for certain pre-registered classes.
		Version 3 - Only writes basicSize for objects of variable classes.
		Version 4 - No change in STB (new version of STL).
		Version 5 - Dolphin 8. Fully-qualified class names written. Classes are expected to implement #stbReadFrom:format:size:, rather than #stbReadFrom:format:.

	self initialize
	"

	Versions := Array new: 6!

peekForSignatureIn: aReadStream
	"Answer whether the <readableStream> argument, aReadStream, appears to be an STB stream (or is positioned at the start of an STB stream). If the STB	signature is found, then the stream is left positioned immediately after it, otherwise the stream position is not changed."

	| position |
	position := aReadStream position.
	^(aReadStream nextAvailable: ##(Signature size)) asByteArray = Signature
		or: [aReadStream position: position. false]!

readVersionFrom: anSTBFiler
	| byte ver aByteStream |
	aByteStream := anSTBFiler stream.
	byte := aByteStream nextAvailable.
	byte isNil ifTrue: [^nil].
	ver := byte - ##($0 asciiValue).
	(ver < 0 or: [ver > 9]) ifTrue: [^nil].
	
	[byte := aByteStream nextAvailable.
	byte notNil and: [byte >= ##($0 asciiValue) and: [byte <= ##($9 asciiValue)]]]
			whileTrue: [ver := ver * 10 + (byte - ##($0 asciiValue))].
	byte == ##(Character space asciiValue) ifFalse: [^nil].
	^self filer: anSTBFiler version: ver!

versions
	^Versions! !
!Kernel.STBVersionPolicy class categoriesForMethods!
initialize!class initialization!public! !
peekForSignatureIn:!public!testing! !
readVersionFrom:!instance creation!public! !
versions!public! !
!

