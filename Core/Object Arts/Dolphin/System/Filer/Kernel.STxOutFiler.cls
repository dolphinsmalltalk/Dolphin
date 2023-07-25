"Filed out from Dolphin Smalltalk"!

Kernel.STxFiler
	subclass: #'Kernel.STxOutFiler'
	instanceVariableNames: 'writeMap globals globalNils proxyOverrides refOffset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STxOutFiler guid: (Core.GUID fromString: '{1a85a928-daab-4ce8-a1d9-cd785d6a90df}')!
Kernel.STxOutFiler isNonInstantiable: true!
Kernel.STxOutFiler comment: ''!
!Kernel.STxOutFiler categoriesForClass!System-Binary storage! !
!Kernel.STxOutFiler methodsFor!

basicNextPut: anObject
	"Private - Write anObject to the stream in STB format."

	| class objectToSave |
	anObject
		ifNil: 
			[policy putNil.
			^self].
	"If anObject has been registered as a global then we wrap it up as an STBGlobalObjectProxy
	and output that instead."
	(self objectIsGlobal: anObject) ifTrue: [^self putGlobal: anObject].

	"Some objects can be encoded entirely within the prefix."
	class := anObject class.
	class == SmallInteger
		ifTrue: 
			[policy putSmallInteger: anObject.
			^self].
	class == Character
		ifTrue: 
			[policy putCharacter: anObject.
			^self].

	"References to objects already output can also be encoded entirely within the prefix."
	(self refForObject: anObject)
		ifNotNil: 
			[:refIndex |
			policy writeReference: refIndex.
			^self].

	"If anObject is the subject of an override:with: message then we output the 'with' proxy object instead."
	objectToSave := proxyOverrides at: anObject ifAbsent: Collection.AbsentCookie.
	objectToSave == Collection.AbsentCookie
		ifTrue: [policy serializeObject: anObject]
		ifFalse: 
			[objectToSave notNil ifTrue: [proxyOverrides removeKey: anObject].
			self saveObject: anObject as: objectToSave]!

initializeObjectMap
	refOffset := 1.
	writeMap := IdentityDictionary new: 128.
	policy registerPredefined: self!

nextPut: anObject
	"Write anObject to the stream in STB format."

	self basicNextPut: anObject.
	^anObject!

objectIsGlobal: anObject
	"Private - Answer true if anObject has been registered as global."

	^anObject ifNil: [globalNils notNil] ifNotNil: [globals notNil and: [globals includesKey: anObject]]!

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

	anObject isNil ifFalse: [proxyOverrides at: anObject put: anObjectToSave]!

putGlobal: anObject
	"Private - Wrap anObject up as an STBGlobalObjectProxy and output that instead."

	| symbol |
	anObject
		ifNil: 
			[symbol := globalNils removeFirst.
			globalNils isEmpty ifTrue: [globalNils := nil]]
		ifNotNil: 
			[| symbolCollection |
			symbolCollection := globals at: anObject.
			symbol := symbolCollection removeFirst.
			symbolCollection isEmpty ifTrue: [globals removeKey: anObject].
			globals isEmpty ifTrue: [globals := nil]].
	self basicNextPut: (STBGlobalObjectProxy for: anObject name: symbol)!

refForObject: anObject
	"Private - Answer the map index of anObject or nil if it is not present.
	The nil object has a conceptual index of zero."

	anObject ifNil: [^0].
	^writeMap lookup: anObject!

register: anObject
	"Private - Add anObject to the map of output objects."

	writeMap at: anObject put: writeMap size + refOffset!

register: anObject asGlobal: aSymbol
	"Add anObject to the globals dictionary.
	When this object is output it will be wrapped in an STBGlobalObjectProxy.
	When the proxy is subsequently loaded it be added to Smalltalk with the
	name aSymbol. If the same object is registered as several global symbols
	then it must be #nextPut: a corresponding number of times."

	anObject
		ifNil: [(globalNils ifNil: [globalNils := OrderedCollection new]) addLast: aSymbol]
		ifNotNil: 
			[globals
				ifNil: 
					[globals := IdentityDictionary new
								at: aSymbol put: OrderedCollection new;
								yourself]
				ifNotNil: [(globals at: anObject ifAbsentPutClean: [OrderedCollection new]) addLast: aSymbol]]!

removeOverrideFor: anObject
	anObject isNil ifFalse: [proxyOverrides removeKey: anObject ifAbsent: nil]!

reset
	"Private - Reset the instance.
	Write the fixed-format header to stream. This enables the reader to identify
	the version of the written data."

	globals := globalNils := nil.
	proxyOverrides := IdentityDictionary new.
	policy writeSignatureAndVersion.
	self initializeObjectMap!

saveObject: aNonImmediateObject
	"Write anObject to the stream in STB format as normal.
	Note that the argument must NOT be a SmallInteger or other immediate object,
	neither should it be another 'special' object such as nil.
	This is a low-level method, and is not intended for normal binary object streaming - 
	use #nextPut: instead."

	self
		writePreambleFor: aNonImmediateObject;
		writeInstanceVariables: aNonImmediateObject!

saveObject: anObject as: anObjectToSave
	"Write anObject to the stream in STB format as anObjectToSave."

	"If anObjectToSave is zero then output anObject as normal (ie. without any proxy)."

	anObjectToSave == 0 ifTrue: [^self saveObject: anObject].

	"A proxy of nil means output nil instead of anObject."
	anObjectToSave ifNil: [^self basicNextPut: nil].

	"Output anObjectToSave (usually a proxy) instead of anObject"
	self
		writeClassPrefix: anObjectToSave basicClass;
		register: anObject;
		writeInstanceVariables: anObjectToSave!

setRefOffset: anInteger
	refOffset := anInteger - writeMap size + 1!

stream: aStream version: anInteger
	stream := aStream.
	policy := (self class versionPolicyClass filer: self version: anInteger).
	self initialize!

writeByteObject: aByteObject
	self writePreambleFor: aByteObject.
	policy writeByteObject: aByteObject!

writeClassPrefix: aClass
	"An object of the <Class> specified by the first argument, is about to be written to the binary stream, output an appropriate class prefix for it."

	(self refForObject: aClass)
		ifNotNil: 
			[:refIndex |
			"class has already been output so we can encode a short reference to the class within the prefix."
			policy writeClassReference: refIndex]
		ifNil: 
			["hitherto unencountered class so we need to save full class details in the object header."
			policy writeClass: aClass.
			self register: aClass]!

writeInstanceVariables: objectToSave
	"Private - Dump the instance variables of the <Object> argument to the binary stream."

	| instanceSpec |
	instanceSpec := objectToSave basicClass instanceSpec.
	(instanceSpec anyMask: Behavior._VariableMask)
		ifTrue: 
			[| basicSize |
			basicSize := objectToSave basicSize.
			policy writeInteger: basicSize.
			(instanceSpec anyMask: Behavior._PointersMask)
				ifFalse: [1 to: basicSize do: [:i | stream nextPut: (objectToSave basicAt: i)]]
				ifTrue: 
					[1 to: (instanceSpec bitAnd: Behavior._SizeMask) + basicSize
						do: [:i | self basicNextPut: (objectToSave instVarAt: i)]]]
		ifFalse: 
			[1 to: (instanceSpec bitAnd: Behavior._SizeMask)
				do: [:i | self basicNextPut: (objectToSave instVarAt: i)]]!

writePreambleFor: anObject
	"Write the normal STB pre-amble for anObject to the output stream. The object is also
	registered in the write map so that any subsequent refs are shared. This method is intended
	for use from custom implementations of the class side #stbSaveOn: message."

	self
		writeClassPrefix: anObject basicClass;
		register: anObject! !
!Kernel.STxOutFiler categoriesForMethods!
basicNextPut:!operations!private! !
initializeObjectMap!initializing!private! !
nextPut:!operations!public! !
objectIsGlobal:!globals!private! !
override:with:!proxies!public! !
putGlobal:!globals!private! !
refForObject:!private!searching! !
register:!accessing!private! !
register:asGlobal:!globals!public! !
removeOverrideFor:!proxies!public! !
reset!initializing!private! !
saveObject:!operations!public! !
saveObject:as:!operations!public! !
setRefOffset:!accessing!private! !
stream:version:!initializing!private! !
writeByteObject:!public! !
writeClassPrefix:!operations!public! !
writeInstanceVariables:!operations!private! !
writePreambleFor:!binary filing!public! !
!

!Kernel.STxOutFiler class methodsFor!

on: aStream
	"Answer a new instance attached to the binary stream aStream."

	^self on: aStream version: self version!

on: aStream version: anInteger
	"Answer a new instance attached to the binary stream aStream."

	^self new stream: aStream version: anInteger!

version
	"Private - Answer the version number of the format produced by the receiver.
		Version 1 - Preregisters certain commonly occurring classes
		Version 2 - Delegates save/load to class, format changed for certain pre-registered classes.
		Version 3 - Only writes basicSize for objects of variable classes.
		Version 4 - Literal filer stores true, false, Smalltalk, etc as literals rather than special predefined object indices, and stores the full set of atomic objects, and arrays of atomic objects, as literals, not just Strings, Symbols, Integers, ByteArrays, classes and pool dictionaries.
		Version 5 - Fully-qualified class names written. Literal filer stores classes as fully-qualified BindingReferences."

	^5! !
!Kernel.STxOutFiler class categoriesForMethods!
on:!instance creation!public! !
on:version:!instance creation!public! !
version!constants!private! !
!

