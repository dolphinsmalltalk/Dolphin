"Filed out from Dolphin Smalltalk"!

Kernel.STxFiler
	subclass: #'Kernel.STxOutFiler'
	instanceVariableNames: 'writeMap proxyOverrides refOffset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STxOutFiler guid: (Core.GUID fromString: '{1a85a928-daab-4ce8-a1d9-cd785d6a90df}')!
Kernel.STxOutFiler isNonInstantiable: true!
Kernel.STxOutFiler comment: ''!
!Kernel.STxOutFiler categoriesForClass!System-Binary storage! !
!Kernel.STxOutFiler methodsFor!

initializeObjectMap
	refOffset := 1.
	writeMap := IdentityDictionary new: 128.
	policy registerPredefined: self!

nextPut: anObject
	"Write anObject to the stream in STB/STL format."

	^policy nextPut: anObject!

override: anObject with: anObjectToSave
	"This is an opportunity circumvent the running of anObject's #stbSaveOn: method by
	pre-specifying the required behaviour. The possible actions depend on the value of anObjectToSave.
	If anObjectToSave is:
		0
			This will cause anObject to be output as normal (ie. with no proxy).
		nil
			This will cause nil to be output in place of anObject.
		an STBProxy
			This will be output in place of the receiver. It will be sent a #fixup:at:
			message at load time and should then answer the object it represents."

	anObject ifNotNil: [proxyOverrides at: anObject put: anObjectToSave]!

overrideFor: anObject
	^proxyOverrides at: anObject ifAbsent: Collection.AbsentCookie!

policy: anObject
	policy := anObject!

policy1
	^policy!

refForObject: anObject
	"Private - Answer the map index of anObject or nil if it is not present.
	The nil object has a conceptual index of zero."

	anObject ifNil: [^0].
	^writeMap lookup: anObject!

register: anObject
	"Private - Add anObject to the map of output objects."

	writeMap at: anObject put: writeMap size + refOffset!

removeOverrideFor: anObject
	anObject ifNotNil: [proxyOverrides removeKey: anObject ifAbsent: nil]!

reset
	"Private - Reset the instance.
	Write the fixed-format header to stream. This enables the reader to identify
	the version of the written data."

	proxyOverrides := IdentityDictionary new.
	policy writeSignatureAndVersion.
	self initializeObjectMap!

saveArray: anArray
	"Save an <Array> to the object stream"

	policy saveArray: anArray!

saveBindingReference: aBindingReference
	"Save a <BindingReference> to the object stream"

	policy saveBindingReference: aBindingReference!

saveByteArray: aByteArray
	"Save a <ByteArray> to the object stream"

	policy saveByteArray: aByteArray!

saveByteObject: aByteObject
	"Save an <Object> of an indexable byte class to the object stream"

	^policy saveByteObject: aByteObject!

saveCharacter: aCharacter
	policy saveCharacter: aCharacter!

saveClass: aClass
	policy saveClass: aClass!

saveCollection: aCollection
	policy saveCollection: aCollection!

saveFloat: aFloat
	policy saveFloat: aFloat!

saveLargeInteger: aLargeInteger
	"Save a <LargeInteger> to the object stream"

	policy saveLargeInteger: aLargeInteger!

saveLookupTable: aLookupTable
	policy saveLookupTable: aLookupTable!

saveMetaclass: aClass
	policy saveMetaclass: aClass!

saveNil
	policy saveNil!

saveObject: aNonImmediateObject
	"Write anObject to the stream in STB format as normal.
	Note that the argument must NOT be a SmallInteger or other immediate object,
	neither should it be another 'special' object such as nil.
	This is a low-level method, and is not intended for normal binary object streaming - 
	use #nextPut: instead."

	policy saveObject: aNonImmediateObject!

saveObject: anObject as: anObjectToSave
	policy saveObject: anObject as: anObjectToSave!

saveResourceLibrary: aResourceLibrary
	policy saveResourceLibrary: aResourceLibrary!

saveScaledDecimal: aScaledDecimal
	"Store a <ScaledDecimal> to the object stream."

	policy saveScaledDecimal: aScaledDecimal!

saveSet: aSet elements: aCollection
	policy saveSet: aSet elements: aCollection!

saveSmallInteger: aSmallInteger
	policy saveSmallInteger: aSmallInteger!

saveStatic: aBindingReference
	"Store a static variable reference into the stream. On deserialisation this will be resolved to the value of the static variable in the loading image. If the variable is not defined in the loading image, an error will be thrown . This is suitable for 'global' static variables such as Processor, etc, but defining globals is a poor practice so new uses may be a smell."

	policy saveStatic: aBindingReference!

saveString: aString
	policy saveString: aString!

saveSymbol: aSymbol
	policy saveSymbol: aSymbol!

setRefOffset: anInteger
	refOffset := anInteger - writeMap size + 1!

stream: aStream policyClass: anSTxVersionPolicyClass
	stream := aStream.
	policy := anSTxVersionPolicyClass filer: self.
	self initialize!

writePreambleFor: anObject
	"Write the normal STB pre-amble for anObject to the output stream. The object is registered in the write map so that any subsequent refs are shared. This method is intended for use from custom implementations of the class side #stbSaveOn: message."

	policy writePreambleFor: anObject class: anObject basicClass!

writePreambleFor: anObject class: aClass
	"Write the normal STB pre-amble for anObject to the output stream, with the prefix identifying the class specified by the 2nd argument. The object is registered in the write map so that any subsequent refs are shared. This method is intended for use from custom implementations of the class side #stbSaveOn: message."

	"class has already been output so we can encode a short reference to the class within the prefix."

	"hitherto unencountered class so we need to save full class details in the object header."

	policy writePreambleFor: anObject class: aClass! !
!Kernel.STxOutFiler categoriesForMethods!
initializeObjectMap!initializing!private! !
nextPut:!accessing!public! !
override:with:!proxies!public! !
overrideFor:!accessing!private! !
policy:!accessing!private! !
policy1!accessing!private! !
refForObject:!private!searching! !
register:!accessing!private! !
removeOverrideFor:!proxies!public! !
reset!initializing!private! !
saveArray:!binary filing!public! !
saveBindingReference:!binary filing!public! !
saveByteArray:!binary filing!public! !
saveByteObject:!binary filing!public! !
saveCharacter:!binary filing!public! !
saveClass:!binary filing!public! !
saveCollection:!binary filing!public! !
saveFloat:!binary filing!public! !
saveLargeInteger:!binary filing!public! !
saveLookupTable:!binary filing!public! !
saveMetaclass:!binary filing!public! !
saveNil!binary filing!public! !
saveObject:!binary filing!public! !
saveObject:as:!binary filing!public! !
saveResourceLibrary:!binary filing!public! !
saveScaledDecimal:!binary filing!public! !
saveSet:elements:!binary filing!public! !
saveSmallInteger:!binary filing!public! !
saveStatic:!binary filing!public! !
saveString:!binary filing!public! !
saveSymbol:!binary filing!public! !
setRefOffset:!accessing!private! !
stream:policyClass:!initializing!private! !
writePreambleFor:!binary filing!public! !
writePreambleFor:class:!binary filing!public! !
!

!Kernel.STxOutFiler class methodsFor!

newStream
	^self subclassResponsibility!

on: aStream
	"Answer a new instance attached to the binary stream aStream."

	^self on: aStream policy: self policyClass!

on: aStream policy: anSTxVersionPolicyClass
	"Answer a new instance for serialising object graphs to the <puttableStream> first argument, using the version policy specified as the 2nd argument."

	^self new stream: aStream policyClass: anSTxVersionPolicyClass!

on: aStream version: anInteger
	"Answer a new instance attached to the binary stream aStream."

	^self on: aStream policy: (self policyClass classForVersion: anInteger)!

policy: anSTxVersionPolicyClass
	^self on: self newStream policy: anSTxVersionPolicyClass!

version
	"Private - Answer the version number of the format produced by the receiver.
		1 - Preregisters certain commonly occurring classes
		2 - Delegates save/load to class, format changed for certain pre-registered classes.
		3 - Only writes basicSize for objects of variable classes.
		4 - Literal filer stores true, false, Smalltalk, etc as literals rather than special predefined object indices, and stores the full set of atomic objects, and arrays of atomic objects, as literals, not just Strings, Symbols, Integers, ByteArrays, classes and pool dictionaries.
		5 - Fully-qualified class names written. Literal filer stores classes as fully-qualified BindingReferences.
		6 - Proxyless collections and resource libraries. STL has no pre-registered classes, so all referenced classes are immediately visible in the literal array"

	^self policyClass version!

version: anInteger 
	^self on: self newStream version: anInteger! !
!Kernel.STxOutFiler class categoriesForMethods!
newStream!helpers!private! !
on:!instance creation!public! !
on:policy:!instance creation!public! !
on:version:!instance creation!public! !
policy:!instance creation!public! !
version!constants!private! !
version:!instance creation!public! !
!

