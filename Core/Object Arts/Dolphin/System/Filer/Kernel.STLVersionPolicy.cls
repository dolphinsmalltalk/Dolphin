"Filed out from Dolphin Smalltalk"!

Kernel.STxVersionPolicy
	subclass: #'Kernel.STLVersionPolicy'
	instanceVariableNames: ''
	classVariableNames: 'Versions'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'Signature' -> #'!!STL' }!
Kernel.STLVersionPolicy guid: (Core.GUID fromString: '{e627c38d-3250-49c9-a8ac-efe2bb2e2783}')!
Kernel.STLVersionPolicy isNonInstantiable: true!
Kernel.STLVersionPolicy comment: ''!
!Kernel.STLVersionPolicy methodsFor!

lastPredefined
	"Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^LastPredefinedClassRef!

putCharacter: aCharacter
	stream nextPut: aCharacter!

putNil
	stream nextPut: nil!

putSmallInteger: aSmallInteger
	stream nextPut: ((aSmallInteger bitShift: 1) bitOr: 1)!

readClassDataWithPrefix: anInteger
	^(anInteger allMask: STxFiler.PrefixNonZeroVersionMask)
		ifTrue: 
			[| versionBeingRead |
			versionBeingRead := stream next.
			filer
				registerClass: stream next
				version: versionBeingRead
				prefix: anInteger]
		ifFalse: 
			[filer
				registerClass: stream next
				version: 0
				prefix: anInteger]!

readInteger
	^stream next!

readObjectSize: aClass
	^aClass isVariable ifTrue: [stream next] ifFalse: [0]!

serializeObject: anObject
	anObject isAtomic
		ifTrue: 
			["Note that atomic objects are not registered in the map for sharing purposes, as by definition any literal occurrence maps to the same unique instance"
			stream nextPut: anObject]
		ifFalse: 
			["Certain other objects with literal representations can also be saved to the stream directly, but need to be registered in case they are shared in the object graph being serialized. Note that with the exception of LargeInteger, these are literal collections of atomic objects (e.g. Strings are collections of Characters)."
			(anObject class == Array
				ifTrue: [anObject allSatisfy: [:each | each isAtomic]]
				ifFalse: [anObject isLiteral])
					ifTrue: 
						[stream
							nextPut: STxFiler.PrefixLiteralMask;
							nextPut: anObject.
						filer register: anObject]
					ifFalse: 
						["No literal form, need to break it down"
						anObject stbSaveOn: filer]]!

writeClass: aClass
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

writeClassReference: anInteger
	stream nextPut: (STxFiler.PrefixDataMask bitOr: (anInteger bitShift: STxFiler.PrefixRefShift))!

writeInteger: anInteger
	stream nextPut: anInteger!

writeReference: anInteger
	stream nextPut: (anInteger bitShift: STxFiler.PrefixRefShift)!

writeSignatureAndVersion
	stream
		nextPut: Signature;
		nextPut: version! !
!Kernel.STLVersionPolicy categoriesForMethods!
lastPredefined!constants!public! !
putCharacter:!operations!public! !
putNil!operations!public! !
putSmallInteger:!operations!public! !
readClassDataWithPrefix:!operations!public! !
readInteger!operations!public! !
readObjectSize:!operations!public! !
serializeObject:!operations!public! !
writeClass:!operations!public! !
writeClassReference:!operations!public! !
writeInteger:!operations!public! !
writeReference:!operations!public! !
writeSignatureAndVersion!operations!public! !
!

!Kernel.STLVersionPolicy class methodsFor!

initialize
	"
	self initialize
	"

	"The first STL resources are from D6. Originally the STL version tracked the STB version, so the first STL version was 3."

	self addClassVariable: 'Versions' value: {
				nil.
				nil.
				nil.
				nil.
				nil.
				nil.
				STLVersion6Policy
			}!

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

versions
	^Versions! !
!Kernel.STLVersionPolicy class categoriesForMethods!
initialize!class initialization!public! !
literalPrinterClass!constants!public! !
peekForSignatureIn:!public!testing! !
readVersionFrom:!instance creation!public! !
versions!public! !
!

