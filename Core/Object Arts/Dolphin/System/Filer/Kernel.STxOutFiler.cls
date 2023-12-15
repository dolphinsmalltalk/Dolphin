"Filed out from Dolphin Smalltalk"!

Kernel.STxFiler
	subclass: #'Kernel.STxOutFiler'
	instanceVariableNames: 'writeMap proxyOverrides refOffset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'StableMask' -> 16r1 }!
Kernel.STxOutFiler guid: (Core.GUID fromString: '{1a85a928-daab-4ce8-a1d9-cd785d6a90df}')!
Kernel.STxOutFiler isNonInstantiable: true!
Kernel.STxOutFiler comment: '`STxOutFiler` is the abstract class of object serializers for writing in STB and STL formats. There are concrete classes for writing of each version from the original STB v0 up to the current version.

Note that whilst the writing of the historic formats is supported, the format of the classes themselves in the image may have changed, so forwards compatibility is limited. The corresponding STxInFiler class for each concrete STxOutFiler will be able to deserialize the object stream written, but it may not actually be readable in the down-level Dolphin version that natively supported the STx version, because the instance variable layout may have changed, and in some cases the classes may not be present or not be locatable.

## Instance Variables:
  `writeMap`		`IdentityDictionary`. Map of `Object`s to their `SmallInteger` reference index in the binary output stream.
  `proxyOverrides`	`IdentityDictionary`. Map of `Object`s to the `STBProxy`s (or special values) output in their place.
  `refOffset`		`<integer>`. Offset of object references to allow for pre-registered objects and classes'!
!Kernel.STxOutFiler categoriesForClass!System-Binary storage! !
!Kernel.STxOutFiler methodsFor!

beStable
	flags := flags bitOr: StableMask!

contents
	"Answer the contents of the serialized object stream."

	^stream contents!

inFilerClass
	^self subclassResponsibility!

isStable
	"Answer whether the receiver is attempting to serialize objects to the stream in an invariant order. This is useful, for example, if the result is emitted to source checked in to a source code control system, as it can avoid the source representation churning when there has been no real change. Note that stability is not guaranteed, as it requires on the nature and co-operation of the serialised objects. In some cases this can be difficult or impossible to achieve because there is no stable ordering available or where some of the data is volatile. However, even if the result is not completely stable, it can still be useful to see a reduced level of change that reflects the actual differences."

	^flags allMask: StableMask!

nextPut: anObject
	"Write anObject to the stream in STB/STL 5+ format."

	| objectToSave |
	(self refForObject: anObject)
		ifNotNil: 
			[:refIndex |
			self writeReference: refIndex.
			^anObject].
	"If anObject is the subject of an #override:with: message then we output the 'with' proxy object instead."
	objectToSave := self overrideFor: anObject.
	objectToSave == Collection.AbsentCookie
		ifTrue: [anObject stbSaveOn: self]
		ifFalse: 
			["In general we no longer need the proxy override because the proxied object will now be in the write map, so any future references will be replaced by the reference index. Removing the proxy entry stops the proxy map getting too large. This does not apply to substituting nil's, however, as in that case the substitute cannot be added to the write map, so we will need to retain the proxy override to continue substituting nils for any future references too."
			objectToSave ifNotNil: [self removeOverrideFor: anObject].
			self saveObject: anObject as: objectToSave].
	^anObject!

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

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB v6 file. 
	The collection proxies are no longer used. Objects streams should no longer contain AnsiStrings - Strings are always written with UTF-8 encoding so that they deserialise with the original code points, regardless of the system code page on the target system."

	^self inFilerClass predefinedClasses!

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

	STBError signal: 'Not supported by this version of <1s> (<2p>)' << { self stxFormatName. self version }!

registerPredefinedClasses
	predefinedClassOffset := writeMap size.
	self predefinedClasses do: [:each | self register: each].
	refOffset := self lastPredefined - writeMap size + 1!

removeOverrideFor: anObject
	anObject ifNotNil: [proxyOverrides removeKey: anObject ifAbsent: nil]!

reset
	"Private - Reset the instance.
	Write the fixed-format header to stream. This enables the reader to identify
	the version of the written data."

	writeMap := IdentityDictionary new: 128.
	proxyOverrides := IdentityDictionary new.
	refOffset := 1.
	self
		writeSignatureAndVersion;
		registerPredefined!

saveArray: anArray
	"Save an <Array> to the object stream"

	self subclassResponsibility!

saveBindingReference: aBindingReference
	"Save a <BindingReference> to the object stream"

	self subclassResponsibility!

saveBoolean: aBoolean
	"Serialize a <Boolean> value to the object stream."

	self subclassResponsibility!

saveByteArray: aByteArray
	"Save a <ByteArray> to the object stream"

	self subclassResponsibility!

saveByteObject: aByteObject
	"Save an <Object> of an indexable byte class to the object stream"

	self
		writePreambleFor: aByteObject class: aByteObject basicClass;
		writeByteObject: aByteObject!

saveCharacter: aCharacter
	"Serialize a <Character> to the object stream."

	self subclassResponsibility!

saveClass: aClass
	"Serialize a <Class> to the object stream. Note that only a reference is saved. The class must be present in the image where the stream is deserialised."

	self subclassResponsibility!

saveCollection: aCollection
	self subclassResponsibility!

saveFloat: aFloat
	"Serialize a <Float> to the object stream."

	self subclassResponsibility!

saveLargeInteger: aLargeInteger
	"Serialize a <LargeInteger> to the object stream"

	self subclassResponsibility!

saveLookupTable: aLookupTable
	"Serialize a <LookupTable> to the object stream."

	self subclassResponsibility!

saveMetaclass: aMetaclass
	"Save a metaclass instance to the object stream."

	self subclassResponsibility!

saveNil
	"Serialize nil to the object stream"

	self subclassResponsibility!

saveObject: aNonLiteralObject
	"Write anObject to the stream in the full STx format, i.e. the argument is not expected to be any of the (mainly literal) objects with a special representation."

	self
		writePreambleFor: aNonLiteralObject class: aNonLiteralObject basicClass;
		writeInstanceVariables: aNonLiteralObject!

saveObject: anObject as: anObjectToSave
	"If anObjectToSave is zero then output anObject as normal (ie. without any proxy)."

	anObjectToSave == 0 ifTrue: [^self saveObject: anObject].

	"A proxy of nil means output nil instead of anObject."
	anObjectToSave ifNil: [^self saveNil].

	"Output anObjectToSave (usually a proxy) instead of anObject"
	self
		writePreambleFor: anObject class: anObjectToSave basicClass;
		writeInstanceVariables: anObjectToSave!

saveResourceLibrary: aResourceLibrary
	self writePreambleFor: aResourceLibrary class: aResourceLibrary basicClass.
	self nextPut: aResourceLibrary fileName!

saveScaledDecimal: aScaledDecimal
	"Serialize a <ScaledDecimal> to the object stream."

	self subclassResponsibility!

saveSet: aSet elements: aCollection
	"Save a <Set> with elements in the 2nd argument to the object stream. In the case of a <Set> the first and second arguments are typically identical. In the case of a Dictionary, the 2nd argument should be the associations."

	self subclassResponsibility!

saveSingleton: anObject
	"Write the normal STB pre-amble for anObject to the output stream. The object is registered in the write map so that any subsequent refs are shared. This method is intended for use from custom implementations of the class side #stbSaveOn: message."

	self writePreambleFor: anObject class: anObject basicClass!

saveSingleton: anObject class: aClass name: nameObject
	self writePreambleFor: anObject class: aClass.
	self nextPut: nameObject!

saveSmallInteger: aSmallInteger
	"Serialize a <SmallInteger> to the object stream."

	self subclassResponsibility!

saveStatic: aBindingReference
	"Serialize a static variable reference into the stream. On deserialisation this will be resolved to the value of the static variable in the loading image. If the variable is not defined in the loading image, an error will be thrown . This is suitable for 'global' static variables such as Processor, etc, but defining globals is a poor practice so new uses may be a smell."

	self subclassResponsibility!

saveStatic: aBindingReference for: anObject
	"Serialize a static variable reference into the stream."

	self saveStatic: aBindingReference!

saveString: aString
	"Serialize a <String> into the object stream."

	self subclassResponsibility!

saveSymbol: aSymbol
	"Serialize a <Symbol> into the object stream."

	self subclassResponsibility!

saveVariableBinding: aVariableBinding
	self saveObject: aVariableBinding!

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

stream: aStream
	stream := aStream.
	self initialize!

writeByteObject: aByteObject
	self subclassResponsibility!

writeClass: aClass prefix: anObject version: verInteger instSize: sizeInteger
	self subclassResponsibility!

writeClassReference: anInteger prefix: prefixInteger
	self subclassResponsibility!

writeInstanceVariables: anObject
	self subclassResponsibility!

writeLookupTableElements: aLookupTable
	self isStable
		ifTrue: 
			[(self sortCollectionElements: aLookupTable associations) do: 
					[:each |
					self nextPut: each key.
					self nextPut: each value]]
		ifFalse: 
			[aLookupTable keysAndValuesDo: 
					[:eachKey :eachValue |
					self
						nextPut: eachKey;
						nextPut: eachValue]]!

writePreambleFor: anObject class: aClass
	self
		writePreambleFor: anObject
		class: aClass
		version: aClass stbVersion
		instSize: aClass instSize!

writePreambleFor: anObject class: aClass version: verInteger instSize: sizeInteger
	(self refForObject: aClass)
		ifNotNil: 
			[:refIndex |
			"class has already been output so we can encode a short reference to the class within the prefix."
			self writeClassReference: refIndex prefix: PrefixDataMask]
		ifNil: 
			["hitherto unencountered class so we need to save full class details in the object header."
			self
				writeClass: aClass
				prefix: PrefixClassMask
				version: verInteger
				instSize: sizeInteger.
			self register: aClass].
	self register: anObject!

writeReference: anInteger
	self subclassResponsibility!

writeSetElements: aCollection
	(self isStable ifTrue: [self sortCollectionElements: aCollection] ifFalse: [aCollection])
		do: [:each | self nextPut: each]!

writeSignatureAndVersion
	self subclassResponsibility! !
!Kernel.STxOutFiler categoriesForMethods!
beStable!accessing!public! !
contents!accessing!public! !
inFilerClass!constants!private! !
isStable!public!testing! !
nextPut:!accessing!public! !
override:with:!proxies!public! !
overrideFor:!accessing!private! !
predefinedClasses!constants!public! !
refForObject:!private!searching! !
register:!accessing!private! !
register:asGlobal:!globals!public! !
registerPredefinedClasses!initializing!private! !
removeOverrideFor:!proxies!public! !
reset!initializing!private! !
saveArray:!public!serializing! !
saveBindingReference:!public!serializing! !
saveBoolean:!public!serializing! !
saveByteArray:!public!serializing! !
saveByteObject:!public!serializing! !
saveCharacter:!public!serializing! !
saveClass:!public!serializing! !
saveCollection:!public!serializing! !
saveFloat:!public!serializing! !
saveLargeInteger:!public!serializing! !
saveLookupTable:!public!serializing! !
saveMetaclass:!public!serializing! !
saveNil!public!serializing! !
saveObject:!public!serializing! !
saveObject:as:!public!serializing! !
saveResourceLibrary:!public!serializing! !
saveScaledDecimal:!public!serializing! !
saveSet:elements:!public!serializing! !
saveSingleton:!binary filing!public! !
saveSingleton:class:name:!binary filing!public! !
saveSmallInteger:!public!serializing! !
saveStatic:!public!serializing! !
saveStatic:for:!public!serializing! !
saveString:!public!serializing! !
saveSymbol:!public!serializing! !
saveVariableBinding:!public!serializing! !
sortCollectionElements:!printing!private! !
stream:!initializing!public! !
writeByteObject:!helpers!private! !
writeClass:prefix:version:instSize:!helpers!private! !
writeClassReference:prefix:!helpers!private! !
writeInstanceVariables:!helpers!private! !
writeLookupTableElements:!operations!private! !
writePreambleFor:class:!binary filing!private! !
writePreambleFor:class:version:instSize:!binary filing!private! !
writeReference:!helpers!private! !
writeSetElements:!private!serializing! !
writeSignatureAndVersion!helpers!private! !
!

!Kernel.STxOutFiler class methodsFor!

new
	^self on: self newStream!

newStream
	^self subclassResponsibility!

on: aStream
	"Answer a new instance attached to the binary stream aStream."

	^self basicNew stream: aStream!

on: aStream version: anInteger
	"Answer a new instance attached to the binary stream aStream."

	^(self classForVersion: anInteger) on: aStream!

version: anInteger 
	^self on: self newStream version: anInteger! !
!Kernel.STxOutFiler class categoriesForMethods!
new!instance creation!public! !
newStream!helpers!private! !
on:!instance creation!public! !
on:version:!instance creation!public! !
version:!instance creation!public! !
!

