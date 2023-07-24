"Filed out from Dolphin Smalltalk"!

Kernel.STLVersionPolicy
	subclass: #'Kernel.STLVersionPolicyForNamespaces'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLVersionPolicyForNamespaces guid: (Core.GUID fromString: '{a22c8dbe-6df4-436a-b8f4-9af7db5670e1}')!
Kernel.STLVersionPolicyForNamespaces isNonInstantiable: true!
Kernel.STLVersionPolicyForNamespaces comment: ''!
!Kernel.STLVersionPolicyForNamespaces methodsFor!

readByteObject: aByteObject
	| byteArray |
	byteArray := stream next.
	byteArray
		replaceBytesOf: aByteObject
		from: 1
		to: aByteObject basicSize
		startingAt: 1!

readClassDataWithPrefix: anInteger
	"As of STL5 the class refs are printed into the STL as BindingReferences. These are true literals (so don't need the ##() expressions to be embedded in the literal array) but need to be resolved back to the class by sending them #value. Note that the resolved binding is cached by the literal BindingReference object, so this is still relatively efficient after the first run through."

	^(anInteger allMask: STBFiler.PrefixNonZeroVersionMask)
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

readObjectWithPrefix: anInteger
	"In STL version 5 and later, the input stream won't contain encoded nil's or Characters, as these are written as literals. SmallIntegers are still encoded though, as this is necessary to distinguish these from the prefix values."

	| anObject newObjectIndex class |
	(anInteger allMask: STBFiler.PrefixSmallIntegerMask)
		ifTrue: 
			["Encoded in the prefix"
			^anInteger bitShift: -1].
	(anInteger allMask: STBFiler.PrefixDataMask)
		ifFalse: 
			["Must be an object reference"
			^filer objectAt: (anInteger bitShift: STBFiler.PrefixRefUnshift)].

	"Ascertain the class of the object."
	class := (anInteger allMask: STBFiler.PrefixClassMask)
				ifTrue: [self readClassDataWithPrefix: anInteger]
				ifFalse: 
					["Previously encountered class"
					filer classAt: (anInteger bitShift: STBFiler.PrefixRefUnshift)].

	"Now read the object data."
	newObjectIndex := filer readMap size + 1.
	anObject := class stbReadFrom: filer format: (filer converters lookup: class).

	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: filer at: newObjectIndex!

registerPredefinedObjects: anSTLFiler
	"Private - Post version 3, don't pre-register standard objects with literal representation as we write these directly to the stream."!

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

writeClass: aClass
	| code |
	"STL doesn't write or use the locator string, so its length need not be encoded in the prefix, although it was prior to D8"
	code := STBFiler.PrefixClassMask bitOr: (aClass instSize bitShift: STBFiler.PrefixInstSizeShift).
	aClass isVariable
		ifTrue: 
			[code := code
						bitOr: (aClass isBytes ifTrue: [STBFiler.PrefixBytesMask] ifFalse: [STBFiler.PrefixVariableMask])].
	aClass stbVersion == 0
		ifTrue: [stream nextPut: code]
		ifFalse: 
			[stream
				nextPut: (code bitOr: STBFiler.PrefixNonZeroVersionMask);
				nextPut: aClass stbVersion].
	stream nextPut: aClass! !
!Kernel.STLVersionPolicyForNamespaces categoriesForMethods!
readByteObject:!operations!public! !
readClassDataWithPrefix:!operations!public! !
readObjectWithPrefix:!accessing!public! !
registerPredefinedObjects:!initializing!private! !
writeByteObject:!operations!public! !
writeClass:!operations!public! !
!

!Kernel.STLVersionPolicyForNamespaces class methodsFor!

literalPrinterClass
	^STLPrinter! !
!Kernel.STLVersionPolicyForNamespaces class categoriesForMethods!
literalPrinterClass!constants!public! !
!

