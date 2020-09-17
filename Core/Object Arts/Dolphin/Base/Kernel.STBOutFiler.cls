"Filed out from Dolphin Smalltalk 7"!

Kernel.STBFiler subclass: #'Kernel.STBOutFiler'
	instanceVariableNames: 'writeMap globals globalNils proxyOverrides refOffset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBOutFiler guid: (Core.GUID fromString: '{87b4c6e8-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STBOutFiler comment: '<STBOutFiler> is the basic binary filer for serializing a tree of <Object>s to a byte stream.

Instance Variables:
	writeMap		<IdentityDictionary>. Map of <Object>s to their <SmallInteger> id in the binary output stream.
	globals		<IdentityDictionary>. Map of global <Object>s to their associated global name <Symbol>s.
	globalNils		<OrderedCollection> of <Symbol>s being the names of nil value global variables written to the stream.
	proxyOverrides	<IdentityDictionary>. Map of <Object>s to the <STBProxy>s (or special values) output in their place.

'!
!Kernel.STBOutFiler categoriesForClass!System-Binary storage! !
!Kernel.STBOutFiler methodsFor!

basicNextPut: anObject
	"Private - Write anObject to the stream in STB format."

	| class objectToSave |
	anObject isNil ifTrue: [^self writeNil].
	"If anObject has been registered as a global then we wrap it up as an STBGlobalObjectProxy
	and output that instead."
	(self objectIsGlobal: anObject) ifTrue: [^self putGlobal: anObject].

	"Some objects can be encoded entirely within the prefix."
	class := anObject class.
	class == SmallInteger ifTrue: [^self writeInteger: (STBPrefix encodeSmallInteger: anObject)].
	class == Character ifTrue: [^self putCharacter: anObject].

	"References to objects already output can also be encoded entirely within the prefix."
	(self refForObject: anObject)
		ifNotNil: [:refIndex | ^self writeInteger: (STBPrefix encodeObjectRef: refIndex)].

	"If anObject is the subject of an override:with: message then we output the 'with' proxy object instead."
	objectToSave := proxyOverrides at: anObject ifAbsent: [Collection.AbsentCookie].
	objectToSave == Collection.AbsentCookie
		ifTrue: [self serializeObject: anObject]
		ifFalse: 
			[objectToSave notNil ifTrue: [proxyOverrides removeKey: anObject].
			self saveObject: anObject as: objectToSave]!

nextPut: anObject
	"Write anObject to the stream in STB format."

	self basicNextPut: anObject.
	^anObject!

objectIsGlobal: anObject
	"Private - Answer true if anObject has been registered as global."

	^anObject isNil ifTrue: [globalNils isEmpty not] ifFalse: [globals includesKey: anObject]!

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

putCharacter: aCharacter
	self writeInteger: (STBPrefix encodeCharacter: aCharacter)!

putGlobal: anObject
	"Private - Wrap anObject up as an STBGlobalObjectProxy and output that instead."

	| symbol |
	anObject isNil
		ifTrue: [symbol := globalNils removeFirst]
		ifFalse: 
			[| symbolCollection |
			symbolCollection := globals at: anObject.
			symbol := symbolCollection removeFirst.
			symbolCollection isEmpty ifTrue: [globals removeKey: anObject]].
	self basicNextPut: (STBGlobalObjectProxy for: anObject name: symbol)!

refForObject: anObject
	"Private - Answer the map index of anObject or nil if it is not present.
	The nil object has a conceptual index of zero."

	anObject isNil ifTrue: [^0].
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

	(anObject isNil
		ifTrue: [globalNils]
		ifFalse: [globals at: anObject ifAbsentPutClean: [OrderedCollection new]]) add: aSymbol!

removeOverrideFor: anObject
	anObject isNil ifFalse: [proxyOverrides removeKey: anObject ifAbsent: []]!

reset
	"Private - Reset the instance.
	Write the fixed-format header to stream. This enables the reader to identify
	the version of the written data."

	refOffset := 1.
	writeMap := IdentityDictionary new: 128.
	globals := IdentityDictionary new: 8.
	globalNils := OrderedCollection new: 8.
	proxyOverrides := IdentityDictionary new.
	self resetStream.
	super reset!

resetStream
	stream
		nextPutAll: self class signature;
		nextPutAll: self class version displayString asByteArray;
		nextPut: 16r20!

saveObject: aNonImmediateObject
	"Write anObject to the stream in STB format as normal.
	Note that the argument must NOT be a SmallInteger or other immediate object,
	neither should it be another 'special' object such as nil.
	This is a low-level method, and is not intended for normal binary object streaming - 
	use #nextPut: instead."

	self writeObject: aNonImmediateObject as: aNonImmediateObject withPrefix: STBPrefix.DataPrefix !

saveObject: anObject as: anObjectToSave
	"Write anObject to the stream in STB format as anObjectToSave."

	"If anObjectToSave is zero then output anObject as normal (ie. without any proxy)."

	anObjectToSave == 0 ifTrue: [^self saveObject: anObject].

	"A proxy of nil means output nil instead of anObject."
	anObjectToSave isNil ifTrue: [^self basicNextPut: nil].

	"Output anObject to save instead of anObject marking it as a proxy so the STBInFiler
	knows to do a #fixup:to on input."
	self
		writeObject: anObject
		as: anObjectToSave
		withPrefix: STBPrefix forProxy!

serializeObject: anObject
	"Let anObject output itself."

	anObject stbSaveOn: self!

setRefOffset: anInteger
	refOffset := anInteger - writeMap size + 1!

writeClass: anObject withLocator: locatorString 
	stream nextPutAll: locatorString asByteArray!

writeClass: class withPrefix: anSTBPrefix
	"Private - An object of the <Class>, class, is about to be written to the binary stream,
	output an appropriate class prefix for it."

	(self refForObject: class)
		ifNotNil: 
			[:refIndex |
			"class has already been output 	so we can encode a short reference to the class within the prefix."
			self writeInteger: (anSTBPrefix encodeClassRef: refIndex)]
		ifNil: 
			["hitherto unencountered class so we need to save full class details in the object header."
			| classVersion locatorString |
			locatorString := class fullName asString.
			self writeInteger: (anSTBPrefix encodeClass: class locator: locatorString).
			(classVersion := class stbVersion) ~~ 0 ifTrue: [self writeInteger: classVersion].
			self writeClass: class withLocator: locatorString.
			self register: class]!

writeInstanceVariables: objectToSave
	"Private - Dump the instance variables of the <Object> argument to the binary stream."

	| class |
	class := objectToSave basicClass.
	class isVariable
		ifTrue: 
			[| basicSize |
			basicSize := objectToSave basicSize.
			self writeInteger: basicSize.
			class isPointers
				ifFalse: [1 to: basicSize do: [:i | stream nextPut: (objectToSave basicAt: i)]]
				ifTrue: [1 to: class instSize + basicSize do: [:i | self basicNextPut: (objectToSave instVarAt: i)]]]
		ifFalse: [1 to: class instSize do: [:i | self basicNextPut: (objectToSave instVarAt: i)]]!

writeInteger: anInteger
	"Private - Write anInteger to the stream."

	stream nextSDWORDPut: anInteger!

writeNil
	self writeInteger: 0!

writeObject: anObject as: objectToSave withPrefix: anSTBPrefix
	"Private - Represent anObject on the stream as objectToSave giving it a prefix of anSTBPrefix."

	self 
		writeClass: objectToSave class withPrefix: anSTBPrefix;
		register: anObject;
		writeInstanceVariables: objectToSave!

writePreambleFor: anObject
	"Write the normal STB pre-amble for anObject to the output stream. The object is also
	registered in the write map so that any subsequent refs are shared. This method is intended
	for use from custom implementations of the class side #stbSaveOn: message."

	self
		writeClass: anObject class withPrefix: STBPrefix forData;
		register: anObject! !
!Kernel.STBOutFiler categoriesFor: #basicNextPut:!operations!private! !
!Kernel.STBOutFiler categoriesFor: #nextPut:!operations!public! !
!Kernel.STBOutFiler categoriesFor: #objectIsGlobal:!globals!private! !
!Kernel.STBOutFiler categoriesFor: #override:with:!proxies!public! !
!Kernel.STBOutFiler categoriesFor: #putCharacter:!helpers!private! !
!Kernel.STBOutFiler categoriesFor: #putGlobal:!globals!private! !
!Kernel.STBOutFiler categoriesFor: #refForObject:!private!searching! !
!Kernel.STBOutFiler categoriesFor: #register:!accessing!private! !
!Kernel.STBOutFiler categoriesFor: #register:asGlobal:!globals!public! !
!Kernel.STBOutFiler categoriesFor: #removeOverrideFor:!proxies!public! !
!Kernel.STBOutFiler categoriesFor: #reset!initializing!private! !
!Kernel.STBOutFiler categoriesFor: #resetStream!initializing!private! !
!Kernel.STBOutFiler categoriesFor: #saveObject:!operations!public! !
!Kernel.STBOutFiler categoriesFor: #saveObject:as:!operations!public! !
!Kernel.STBOutFiler categoriesFor: #serializeObject:!operations!private! !
!Kernel.STBOutFiler categoriesFor: #setRefOffset:!accessing!private! !
!Kernel.STBOutFiler categoriesFor: #writeClass:withLocator:!operations!private! !
!Kernel.STBOutFiler categoriesFor: #writeClass:withPrefix:!operations!private! !
!Kernel.STBOutFiler categoriesFor: #writeInstanceVariables:!operations!private! !
!Kernel.STBOutFiler categoriesFor: #writeInteger:!helpers!private! !
!Kernel.STBOutFiler categoriesFor: #writeNil!operations!private! !
!Kernel.STBOutFiler categoriesFor: #writeObject:as:withPrefix:!operations!private! !
!Kernel.STBOutFiler categoriesFor: #writePreambleFor:!binary filing!public! !

!Kernel.STBOutFiler class methodsFor!

uninitialize
	"Private - STBPrefix is only used by STBOutFiler now so if STBOutFiler is going, we no longer need it.
	However it has some static instances that will prevent it being stripped if we don't clear
	them away."

	STBPrefix uninitialize! !
!Kernel.STBOutFiler class categoriesFor: #uninitialize!class hierarchy-removing!private! !

