"Filed out from Dolphin Smalltalk"!

Kernel.STBVersionPolicy
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

literalPrinterClass
	^self subclassResponsibility!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered for every STL stream. 
	There is relatively little benefit in pre-registering classes in STL, since we do not have the chicken-before-egg problem that STB has with, for example, Strings, since all the types that are required to support the format have a literal representation and will be instantiated by the compiler. The classes for objects with literal form do not need to be registered. We also do not need the STB class proxies in the STL representation. However, in all STL versions up to and including 5, the pre-registered classes were retained."

	^PredefinedClasses!

putCharacter: aCharacter on: anObjectStream
	anObjectStream nextPut: aCharacter!

putNilOn: anObjectStream
	anObjectStream nextPut: nil!

putSmallInteger: aSmallInteger on: aStream
	aStream nextPut: ((aSmallInteger bitShift: 1) bitOr: 1)!

readClassData: anSTBFiler prefix: anInteger
	^(anInteger allMask: STBFiler.PrefixNonZeroVersionMask)
		ifTrue: 
			[| versionBeingRead stream |
			stream := anSTBFiler stream.
			versionBeingRead := stream next.
			anSTBFiler
				registerClass: stream next
				version: versionBeingRead
				prefix: anInteger]
		ifFalse: 
			[anSTBFiler
				registerClass: anSTBFiler stream next
				version: 0
				prefix: anInteger]!

readIntegerFrom: anObjectStream
	^anObjectStream next!

readObjectSize: aClass from: aPositionableStream
	^aClass isVariable ifTrue: [aPositionableStream next] ifFalse: [0]!

serializeObject: anObject with: anSTLOutFiler
	anObject isAtomic
		ifTrue: 
			["Note that atomic objects are not registered in the map for sharing purposes, as by definition any literal occurrence maps to the same unique instance"
			anSTLOutFiler stream nextPut: anObject]
		ifFalse: 
			["Certain other objects with literal representations can also be saved to the stream directly, but need to be registered in case they are shared in the object graph being serialized. Note that with the exception of LargeInteger, these are literal collections of atomic objects (e.g. Strings are collections of Characters)."
			(anObject class == Array
				ifTrue: [anObject allSatisfy: [:each | each isAtomic]]
				ifFalse: [anObject isLiteral])
					ifTrue: 
						[anSTLOutFiler stream
							nextPut: STBFiler.PrefixLiteralMask;
							nextPut: anObject.
						anSTLOutFiler register: anObject]
					ifFalse: 
						["No literal form, need to break it down"
						anObject stbSaveOn: anSTLOutFiler]]!

writeClass: aClass on: aStream
	| code |
	"STL doesn't write the locator string, so its length does not need to be encoded in the prefix"
	code := STBFiler.PrefixClassMask bitOr: (aClass instSize bitShift: STBFiler.PrefixInstSizeShift).
	aClass isVariable
		ifTrue: 
			[code := code
						bitOr: (aClass isBytes ifTrue: [STBFiler.PrefixBytesMask] ifFalse: [STBFiler.PrefixVariableMask])].
	aClass stbVersion == 0
		ifTrue: [aStream nextPut: code]
		ifFalse: 
			[aStream
				nextPut: (code bitOr: STBFiler.PrefixNonZeroVersionMask);
				nextPut: aClass stbVersion].
	aStream nextPut: aClass!

writeClassReference: anInteger on: aStream
	aStream
		nextPut: (STBFiler.PrefixDataMask bitOr: (anInteger bitShift: STBFiler.PrefixRefShift))!

writeInteger: anInteger on: anObjectStream
	anObjectStream nextPut: anInteger!

writeReference: anInteger on: aStream
	aStream nextPut: (anInteger bitShift: STBFiler.PrefixRefShift)!

writeSignatureAndVersionOn: anObjectStream
	anObjectStream
		nextPut: Signature;
		nextPut: version! !
!Kernel.STLVersionPolicy categoriesForMethods!
lastPredefined!constants!public! !
literalPrinterClass!public! !
predefinedClasses!constants!public! !
putCharacter:on:!operations!public! !
putNilOn:!operations!public! !
putSmallInteger:on:!operations!public! !
readClassData:prefix:!helpers!public! !
readIntegerFrom:!operations!public! !
readObjectSize:from:!public! !
serializeObject:with:!operations!public! !
writeClass:on:!operations!public! !
writeClassReference:on:!operations!public! !
writeInteger:on:!operations!public! !
writeReference:on:!operations!public! !
writeSignatureAndVersionOn:!public! !
!

!Kernel.STLVersionPolicy class methodsFor!

initialize
	"
	self initialize
	"

	"The first STL resources are from D6. Originally the STL version tracked the STB version, so the first STL version was 3."

	Versions := {
				nil.
				nil.
				nil.
				nil.
				nil.
				STLVersion5Policy new version: 5.
				STLVersion6Policy new version: 6
			}!

peekForSignatureIn: aReadStream
	"Answer whether the <readableStream> argument, aReadStream, appears to be an STL stream (or is positioned at the start of an STL stream). If the STL signature is found, then the stream is left positioned immediately after it, otherwise the stream position is not changed."

	| position |
	position := aReadStream position.
	^aReadStream nextAvailable = Signature or: 
			[aReadStream position: position.
			false]!

readVersionFrom: anObjectStream
	| ver |
	ver := anObjectStream nextAvailable.
	^ver isInteger ifTrue: [self forVersion: ver]!

versions
	^Versions! !
!Kernel.STLVersionPolicy class categoriesForMethods!
initialize!class initialization!public! !
peekForSignatureIn:!public!testing! !
readVersionFrom:!instance creation!public! !
versions!public! !
!

