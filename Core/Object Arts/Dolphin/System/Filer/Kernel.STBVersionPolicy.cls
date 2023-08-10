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
Kernel.STBVersionPolicy comment: '`STBVersionPolicy` is the abstract class of policy/strateger plugins for writing and reading the particular STB formats of each version from the original STB v0 up to the current version.'!
!Kernel.STBVersionPolicy methodsFor!

locatorKeyFor: aClass
	"In STB v5+, class locator strings are full names"

	^aClass fullName!

next
	"Private - Answer the next object from the receiver's stream."

	| anObject newObjectIndex class prefixCode |
	prefixCode := stream nextInt32.
	prefixCode == 0 ifTrue: [^nil].	"optimize for nil"
	"SmallInteger?"
	(prefixCode allMask: PrefixSmallIntegerMask) ifTrue: [^prefixCode bitShift: -1].
	(prefixCode allMask: PrefixDataMask)
		ifFalse: 
			[^(prefixCode allMask: PrefixCharacterMask)
				ifTrue: [Character value: (prefixCode bitShift: PrefixRefUnshift)]
				ifFalse: [filer objectAt: (prefixCode bitShift: PrefixRefUnshift)]].
	"Ascertain the class of the object."
	class := (prefixCode allMask: PrefixClassMask)
				ifTrue: [self readClassDataWithPrefix: prefixCode]
				ifFalse: [filer classAt: (prefixCode bitShift: PrefixRefUnshift)].
	"Now read the object data."
	newObjectIndex := filer readMap size + 1.
	anObject := class stbReadFrom: filer format: (filer converters lookup: class).
	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: filer at: newObjectIndex!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB file of the represented version.
	No classes were pre-registered in the original, version 0, STB format, and hence String and STBClassProxy classes could not be restored from STB, e.g. the following did not work:
		Object fromBinaryStoreBytes: String binaryStoreBytes
	"

	^#()!

readBytes: anInteger into: aByteObject
	^stream
		basicNext: anInteger
		into: aByteObject
		startingAt: 1!

readClassDataWithPrefix: anInteger
	| versionBeingRead |
	versionBeingRead := (anInteger allMask: PrefixNonZeroVersionMask)
				ifTrue: [stream nextInt32]
				ifFalse: [0].
	^filer
		registerClass: (self readClassWithPrefix: anInteger)
		version: versionBeingRead
		prefix: anInteger!

readClassWithPrefix: anInteger
	| locatorString |
	locatorString := Utf8String new: (anInteger bitShift: PrefixLocatorLenUnshift).
	1 to: locatorString size do: [:i | locatorString basicAt: i put: stream next].
	^filer classLocator locateClass: (FullBindingReference
				pathString: locatorString
				path: nil
				private: false)!

readInteger
	^stream nextInt32!

readObjectSize: aClass
	"As of STB version 3, the out-filer only writes the object size for indexable objects."

	^aClass isVariable ifTrue: [stream nextInt32] ifFalse: [0]!

readString: aClass
	| size |
	size := stream nextInt32.
	^self readBytes: size into: (aClass new: size)!

registerPredefinedObjects: anSTBFiler
	"Private - We pre-register objects that must never be recreated - note	that if the 'fixed' list of pre-registered objects is changed, then the STB version must be
	changed and an upgrade mechanism put in place."

	anSTBFiler
		register: true;
		register: false;
		register: Smalltalk;
		register: Processor!

saveArray: anArray
	| size |
	self writePreambleFor: anArray class: anArray basicClass.
	stream nextInt32Put: (size := anArray basicSize).
	1 to: size do: [:i | filer nextPut: (anArray basicAt: i)]!

saveBindingReference: aBindingReference
	self saveObject: aBindingReference!

saveBoolean: aBoolean
	self saveObject: aBoolean!

saveByteArray: aByteArray
	"Save a <ByteArray> to the object stream"

	self saveByteObject: aByteArray!

saveCharacter: aCharacter
	stream nextInt32Put: ((aCharacter codePoint bitShift: PrefixRefShift) bitOr: PrefixCharacterMask)!

saveClass: aClass
	self saveObject: aClass
		as: (STBClassProxy locatorKey: (self locatorKeyFor: aClass) package: aClass owningPackage)!

saveFloat: aFloat
	self saveObject: aFloat!

saveLargeInteger: aLargeInteger
	self saveObject: aLargeInteger!

saveMetaclass: aMetaclass
	| inst |
	inst := aMetaclass instanceClass.
	self saveObject: aMetaclass
		as: (STBMetaclassProxy locatorKey: (self locatorKeyFor: inst) package: inst owningPackage)!

saveNil
	stream nextInt32Put: 0!

saveScaledDecimal: aScaledDecimal
	self saveObject: aScaledDecimal!

saveSmallInteger: aSmallInteger
	stream nextInt32Put: ((aSmallInteger bitShift: 1) bitOr: 1)!

saveStatic: aBindingReference
	self saveObject: aBindingReference as: (STBStaticVariableProxy reference: aBindingReference asFullyQualifiedReference)!

saveString: aString
	| utf8 size |
	self writePreambleFor: aString class: Utf8String.
	utf8 := aString asUtf8String.
	stream nextInt32Put: (size := utf8 size).
	1 to: size do: [:i | stream nextPut: (utf8 basicAt: i)]!

saveSymbol: aSymbol
	self saveObject: aSymbol!

writeByteObject: aByteObject
	| size |
	size := aByteObject basicSize.
	stream
		nextInt32Put: size;
		basicNext: size
			putAll: aByteObject
			startingAt: 1!

writeClass: aClass prefix: anInteger
	| locatorString prefixCode |
	locatorString := self locatorKeyFor: aClass.
	prefixCode := anInteger bitOr: (locatorString size bitShift: PrefixLocatorLenShift).
	aClass isBytes
		ifTrue: [prefixCode := prefixCode bitOr: PrefixBytesMask]
		ifFalse: 
			[prefixCode := prefixCode bitOr: (aClass instSize bitShift: PrefixInstSizeShift).
			aClass isVariable ifTrue: [prefixCode := prefixCode bitOr: PrefixVariableMask]].
	aClass stbVersion == 0
		ifTrue: [stream nextInt32Put: prefixCode]
		ifFalse: 
			[stream
				nextInt32Put: (prefixCode bitOr: PrefixNonZeroVersionMask);
				nextInt32Put: aClass stbVersion].
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
						do: [:i | filer nextPut: (anObject instVarAt: i)]]]
		ifFalse: 
			[1 to: (instanceSpec bitAnd: Behavior._SizeMask) do: [:i | filer nextPut: (anObject instVarAt: i)]]!

writeReference: anInteger
	stream nextInt32Put: (anInteger bitShift: PrefixRefShift)!

writeSignatureAndVersion
	stream
		nextPutAll: Signature;
		nextPutAll: version printString asByteArray;
		nextPut: 16r20! !
!Kernel.STBVersionPolicy categoriesForMethods!
locatorKeyFor:!accessing!helpers!operations!public! !
next!binary filing!public! !
predefinedClasses!constants!public! !
readBytes:into:!operations!public! !
readClassDataWithPrefix:!operations!public! !
readClassWithPrefix:!operations!private! !
readInteger!operations!public! !
readObjectSize:!operations!public! !
readString:!binary filing!public! !
registerPredefinedObjects:!initializing!private! !
saveArray:!binary filing!public! !
saveBindingReference:!binary filing!public! !
saveBoolean:!operations!public! !
saveByteArray:!binary filing!public! !
saveCharacter:!operations!public! !
saveClass:!binary filing!public! !
saveFloat:!binary filing!public! !
saveLargeInteger:!binary filing!public! !
saveMetaclass:!binary filing!public! !
saveNil!operations!public! !
saveScaledDecimal:!binary filing!public! !
saveSmallInteger:!operations!public! !
saveStatic:!binary filing!public! !
saveString:!binary filing!public! !
saveSymbol:!binary filing!public! !
writeByteObject:!operations!private! !
writeClass:prefix:!operations!private! !
writeClassReference:prefix:!operations!private! !
writeInstanceVariables:!operations!private! !
writeReference:!operations!private! !
writeSignatureAndVersion!operations!private! !
!

!Kernel.STBVersionPolicy class methodsFor!

formatName
	"Answer the format name."

	^'STB'!

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

	Versions := (Array new: 7)
				at: 7 put: STBVersion6Policy;
				yourself!

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

register
	Versions at: self version + 1 put: self!

unregister
	Versions at: self version + 1 put: nil!

versions
	^Versions! !
!Kernel.STBVersionPolicy class categoriesForMethods!
formatName!constants!public! !
initialize!class initialization!public! !
peekForSignatureIn:!public!testing! !
readVersionFrom:!instance creation!public! !
register!class initialization!private! !
unregister!class hierarchy-removing!private! !
versions!accessing!public! !
!

