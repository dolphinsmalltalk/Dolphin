"Filed out from Dolphin Smalltalk"!

Kernel.STBVersionPolicy
	subclass: #'Kernel.STBVersion0Policy'
	instanceVariableNames: 'headerBytes'
	classVariableNames: 'Versions'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'Signature' -> #[33 83 84 66 32] }!
Kernel.STBVersion0Policy guid: (Core.GUID fromString: '{645b2749-5dfa-4fc3-afd3-708ede25667b}')!
Kernel.STBVersion0Policy comment: ''!
!Kernel.STBVersion0Policy methodsFor!

classLocatorStringFor: aClass
	^(Smalltalk oldNames lookup: aClass)
		ifNil: 
			[| name |
			name := aClass shortName.
			(BindingReference isQualifiedName: name)
				ifTrue: 
					[STBError
						signal: '<1p> does not have an unqualified short name for use in version <2d> object stream'
								<< { aClass. self version }]
				ifFalse: [name]]!

lastPredefined
	"Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^4!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB file of the represented version.
	No classes were pre-registered in the original, version 0, STB format, and hence String and STBClassProxy classes could not be restored from STB, e.g. the following did not work:
		Object fromBinaryStoreBytes: String binaryStoreBytes
	"

	^#()!

putCharacter: aCharacter on: aPuttableStream
	aPuttableStream
		nextInt32Put: ((aCharacter codePoint bitShift: STBFiler.PrefixRefShift) bitOr: STBFiler.PrefixCharacterMask)!

putNilOn: aByteStream
	aByteStream nextInt32Put: 0!

putSmallInteger: aSmallInteger on: aStream
	aStream nextInt32Put: ((aSmallInteger bitShift: 1) bitOr: 1)!

readClass: anSTBInFiler prefix: anInteger
	| locatorString stream |
	locatorString := AnsiString new: (anInteger bitShift: STBFiler.PrefixLocatorLenUnshift).
	stream := anSTBInFiler stream.
	1 to: locatorString size do: [:i | locatorString basicAt: i put: stream next].
	^anSTBInFiler classLocator locateClass: (BindingReference
				pathString: locatorString
				private: false
				scope: Smalltalk)!

readClassData: anSTBFiler prefix: anInteger
	| versionBeingRead |
	versionBeingRead := (anInteger allMask: STBFiler.PrefixNonZeroVersionMask)
				ifTrue: [anSTBFiler stream nextInt32]
				ifFalse: [0].
	^anSTBFiler
		registerClass: (self readClass: anSTBFiler prefix: anInteger)
		version: versionBeingRead
		prefix: anInteger!

readIntegerFrom: aByteStream
	^aByteStream nextInt32!

serializeObject: anObject with: anSTBOutFiler
	anObject stbSaveOn: anSTBOutFiler!

version: anInteger
	super version: anInteger.
	headerBytes := ('!!STB <1d> ' << anInteger) asByteArray!

writeClass: aClass on: aByteStream
	| locatorString prefixCode |
	locatorString := self classLocatorStringFor: aClass.
	prefixCode := STBFiler.PrefixClassMask
				bitOr: ((locatorString size bitShift: STBFiler.PrefixLocatorLenShift)
						bitOr: (aClass instSize bitShift: STBFiler.PrefixInstSizeShift)).
	aClass isVariable
		ifTrue: 
			[prefixCode := prefixCode
						bitOr: (aClass isBytes ifTrue: [STBFiler.PrefixBytesMask] ifFalse: [STBFiler.PrefixVariableMask])].
	aClass stbVersion == 0
		ifTrue: [aByteStream nextInt32Put: prefixCode]
		ifFalse: 
			[aByteStream
				nextInt32Put: (prefixCode bitOr: STBFiler.PrefixNonZeroVersionMask);
				nextInt32Put: aClass stbVersion].
	aByteStream nextPutAll: locatorString asByteArray!

writeClassReference: anInteger on: aStream
	aStream
		nextInt32Put: (STBFiler.PrefixDataMask bitOr: (anInteger bitShift: STBFiler.PrefixRefShift))!

writeInteger: anInteger on: aByteStream
	aByteStream nextInt32Put: anInteger!

writeReference: anInteger on: aStream
	aStream nextInt32Put: (anInteger bitShift: STBFiler.PrefixRefShift)!

writeSignatureAndVersionOn: aByteStream
	aByteStream nextPutAll: headerBytes! !
!Kernel.STBVersion0Policy categoriesForMethods!
classLocatorStringFor:!public! !
lastPredefined!constants!public! !
predefinedClasses!constants!public! !
putCharacter:on:!operations!public! !
putNilOn:!operations!public! !
putSmallInteger:on:!operations!public! !
readClass:prefix:!operations!private! !
readClassData:prefix:!helpers!public! !
readIntegerFrom:!operations!public! !
serializeObject:with:!operations!public! !
version:!private! !
writeClass:on:!operations!public! !
writeClassReference:on:!operations!public! !
writeInteger:on:!operations!public! !
writeReference:on:!operations!public! !
writeSignatureAndVersionOn:!public! !
!

!Kernel.STBVersion0Policy class methodsFor!

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

	Versions := {
				STBVersion0Policy new version: 0.
				STBVersion1Policy new version: 1.
				STBVersion1Policy new version: 2.
				STBVersion3Policy new version: 3.
				STBVersion3Policy new version: 4.
				STBVersion5Policy new version: 5
			}!

peekForSignatureIn: aReadStream
	"Answer whether the <readableStream> argument, aReadStream, appears to be an STB stream (or is positioned at the start of an STB stream). If the STB	signature is found, then the stream is left positioned immediately after it, otherwise the stream position is not changed."

	| position |
	position := aReadStream position.
	^(aReadStream nextAvailable: ##(Signature size)) asByteArray = Signature
		or: [aReadStream position: position. false]!

readVersionFrom: aByteStream
	| byte ver |
	byte := aByteStream nextAvailable.
	byte isNil ifTrue: [^nil].
	ver := byte - ##($0 asciiValue).
	(ver < 0 or: [ver > 9]) ifTrue: [^nil].
	
	[byte := aByteStream nextAvailable.
	byte notNil and: [byte >= ##($0 asciiValue) and: [byte <= ##($9 asciiValue)]]]
			whileTrue: [ver := ver * 10 + (byte - ##($0 asciiValue))].
	byte == ##(Character space asciiValue) ifFalse: [^nil].
	^self forVersion: ver!

versions
	^Versions! !
!Kernel.STBVersion0Policy class categoriesForMethods!
initialize!class initialization!public! !
peekForSignatureIn:!public!testing! !
readVersionFrom:!instance creation!public! !
versions!public! !
!

