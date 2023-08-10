"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.STxVersionPolicy'
	instanceVariableNames: 'filer stream version'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'version signatureBytes'
	classConstants: {
			'LastPredefinedClassRef' -> 16r18.
			'PrefixBytesMask' -> 16r30.
			'PrefixCharacterMask' -> 16r4.
			'PrefixClassMask' -> 16r6.
			'PrefixDataMask' -> 16r2.
			'PrefixInstSizeMask' -> 16rFF.
			'PrefixInstSizeShift' -> 16r8.
			'PrefixInstSizeUnshift' -> -16r8.
			'PrefixLocatorLenShift' -> 16r10.
			'PrefixLocatorLenUnshift' -> -16r10.
			'PrefixNonZeroVersionMask' -> 16r40.
			'PrefixProxyMask' -> 16r8.
			'PrefixRefShift' -> 16r4.
			'PrefixRefUnshift' -> -16r4.
			'PrefixSmallIntegerMask' -> 16r1.
			'PrefixVariableMask' -> 16r20
		}!
Kernel.STxVersionPolicy guid: (Core.GUID fromString: '{c3707a61-0143-415a-b869-e30ff4ad09bd}')!
Kernel.STxVersionPolicy isNonInstantiable: true!
Kernel.STxVersionPolicy comment: '`STxVersionPolicy` is the abstract class of policy/strateger plugins for writing and reading the particular STB/STL formats of each version from the original STB v0 up to the current version.

Note that whilst the version policy enables the writing of the historic formats, the format of the classes themselves in the image may have changed, so forwards compatibility is limited. Backwards compatibility should be complete by virtue of this hierarchy of classes representing the overall format changes, and the class specific conversions as implemented by each class'' `stbConvertFrom:` method.'!
!Kernel.STxVersionPolicy methodsFor!

filer: anSTBFiler version: anInteger
	filer := anSTBFiler.
	"The stream is cached locally for perf reasons only"
	stream := anSTBFiler stream.
	version := anInteger!

formatName
	"Answer the format name."

	^self class formatName!

lastPredefined
	"Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^LastPredefinedClassRef!

lookupPredefinedClass: anInteger
	^self predefinedClasses lookup: anInteger - self predefinedClassOffset!

next
	^self subclassResponsibility!

nextPut: anObject
	| objectToSave |
	"If the object has previously been serialised to the stream, we emit a reference to it so that reference identity is maintained when deserialised"
	(filer refForObject: anObject)
		ifNotNil: 
			[:refIndex |
			self writeReference: refIndex.
			^anObject].
	"If anObject is the subject of an #override:with: message then we output the 'with' proxy object instead."
	objectToSave := filer overrideFor: anObject.
	objectToSave == Collection.AbsentCookie
		ifTrue: [anObject stbSaveOn: filer]
		ifFalse: 
			["In general we no longer need the proxy override because the proxied object will now be in the write map, so any future references will be replaced by the reference index. Removing the proxy entry stops the proxy map getting too large. This does not apply to substituting nil's, however, as in that case the object cannot be added to the write map, so we will need to retain the proxy override to continue substituting nils for any future references too."
			objectToSave ifNotNil: [filer removeOverrideFor: anObject].
			self saveObject: anObject as: objectToSave].
	^anObject!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB file. 
	For STB, these make it possible to binary file the classes STBClassProxy and String. Also these clases are almost always needed, so we can save space pre-registering them so that they don't need to be written into the filer.
	STL does not require the STB class proxies, and stores strings as literals, so it does not require pre-registration of classes. There reamains a small compactness benefit, but it makes it harder to find class references in resources so has been dropped from STL 6."

	"Note that pre-registering classes does not inflate the size of the binary file, it just pre-allocates a range of indices for fixed uses. Changing the order of these (or deleting registrations) will break existing binary files. Lastly a consequence of pre-registering these classes is that normal STB versioning will have no effect - the #stbVersion is only checked when a class is first read from the file. In order to version these classes it is necessary to increment the global STB version number."

	^self subclassResponsibility!

predefinedClassOffset
	^4!

readByteObject: aClass size: anInteger
	| object |
	object := aClass basicNew: anInteger.
	filer register: object.
	self readBytes: anInteger into: object.
	^object!

readBytes: anInteger into: aByteObject
	^self subclassResponsibility!

readClassDataWithPrefix: anInteger
	^self subclassResponsibility!

readCollection: aClass format: anSTBClassConversion size: anInteger
	^self subclassResponsibility!

readInteger
	self subclassResponsibility!

readLookupTable: aClass format: anSTBClassConversion size: anInteger
	^self subclassResponsibility!

readObjectSize: aClass
	^self subclassResponsibility!

readString: aClass
	^self subclassResponsibility!

register: anObject asGlobal: aSymbol
	"Add anObject to the globals dictionary.
	When this object is output it will be wrapped in an STBGlobalObjectProxy.
	When the proxy is subsequently loaded it be added to Smalltalk with the
	name aSymbol. If the same object is registered as several global symbols
	then it must be #nextPut: a corresponding number of times."

	STBError signal: 'Not supported by this version of <1s> (<2p>)' << { self formatName. self version }!

registerPredefined: anSTBFiler
	self registerPredefinedObjects: anSTBFiler.
	self registerPredefinedClasses: anSTBFiler!

registerPredefinedClasses: anSTBFiler
	anSTBFiler
		registerAllClasses: self predefinedClasses;
		setRefOffset: self lastPredefined!

registerPredefinedObjects: anSTBFiler
	"Private - We may pre-register a few special objects that must never be recreated, depending on the version policy and format."!

saveArray: anArray
	"Save an <Array> to the object stream"

	self subclassResponsibility!

saveBindingReference: aBindingReference
	"Save a <BindingReference> to the object stream"

	self subclassResponsibility!

saveBoolean: aBoolean
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
	self subclassResponsibility!

saveClass: aClass
	self subclassResponsibility!

saveCollection: aCollection
	self subclassResponsibility!

saveFloat: aFloat
	self subclassResponsibility!

saveLargeInteger: aLargeInteger
	"Save a <LargeInteger> to the object stream"

	self subclassResponsibility!

saveLookupTable: aLookupTable
	self subclassResponsibility!

saveNil
	"Save nil to the object stream"

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
	self
		writePreambleFor: aResourceLibrary class: aResourceLibrary basicClass;
		nextPut: aResourceLibrary fileName!

saveScaledDecimal: aScaledDecimal
	"Store a <ScaledDecimal> to the object stream."

	self subclassResponsibility!

saveSet: aSet elements: aCollection
	"Save a <Set> with elements in the 2nd argument to the object stream. In the case of a <Set> the first and second arguments are typically identical. In the case of a Dictionary, the 2nd argument should be the associations."

	self subclassResponsibility!

saveSmallInteger: aSmallInteger
	"Save a <SmallInteger> to the object stream."

	self subclassResponsibility!

saveStatic: aBindingReference
	"Save a static variable reference into the stream. On deserialisation this will be resolved to the value of the static variable in the loading image. If the variable is not defined in the loading image, an error will be thrown . This is suitable for 'global' static variables such as Processor, etc, but defining globals is a poor practice so new uses may be a smell."

	self subclassResponsibility!

saveString: aString
	"Save a <String> to the STL stream. We always store strings in UTF-8 form now.  UTF-8 is the best encoding for serialisation as it preserves the correct code points in (generally) the minimum space, and is not sensitive to byte ordering. This does mean that the original class of the string is lost, but this is generally desirable. AnsiString'are largely obsolete and cannot be saved/restored correctly across hosts with different system code pages. Utf16Strings are usually only needed for calling Windows APIs. In them image they are interchangeable with Utf8Strings. Although the class of Utf16Strings and AnsiStrings is not preserved, identity within the graph is, i.e. a string with shared references in the input graph will have the same shared references in the deserialised graph."

	self subclassResponsibility!

saveSymbol: aSymbol
	"Save a <Symbol> to the object stream."

	self subclassResponsibility!

version
	^version!

writeByteObject: aByteObject
	self subclassResponsibility!

writeClass: aClass prefix: anObject
	self subclassResponsibility!

writeClassReference: anInteger prefix: prefixInteger
	self subclassResponsibility!

writeInstanceVariables: anObject
	self subclassResponsibility!

writePreambleFor: anObject class: aClass
	(filer refForObject: aClass)
		ifNotNil: 
			[:refIndex |
			"class has already been output so we can encode a short reference to the class within the prefix."
			self writeClassReference: refIndex prefix: PrefixDataMask]
		ifNil: 
			["hitherto unencountered class so we need to save full class details in the object header."
			self writeClass: aClass prefix: PrefixClassMask.
			filer register: aClass].
	filer register: anObject!

writeReference: anInteger
	self subclassResponsibility!

writeSignatureAndVersion
	self subclassResponsibility! !
!Kernel.STxVersionPolicy categoriesForMethods!
filer:version:!initializing!private! !
formatName!constants!public! !
lastPredefined!constants!public! !
lookupPredefinedClass:!accessing!public! !
next!binary filing!public! !
nextPut:!accessing!public! !
predefinedClasses!constants!public! !
predefinedClassOffset!accessing!public! !
readByteObject:size:!binary filing!public! !
readBytes:into:!binary filing!public! !
readClassDataWithPrefix:!binary filing!public! !
readCollection:format:size:!binary filing!public! !
readInteger!binary filing!public! !
readLookupTable:format:size:!binary filing!public! !
readObjectSize:!binary filing!public! !
readString:!binary filing!public! !
register:asGlobal:!globals!public! !
registerPredefined:!initializing!public! !
registerPredefinedClasses:!initializing!private! !
registerPredefinedObjects:!initializing!private! !
saveArray:!binary filing!public! !
saveBindingReference:!binary filing!public! !
saveBoolean:!binary filing!public! !
saveByteArray:!binary filing!public! !
saveByteObject:!binary filing!public! !
saveCharacter:!binary filing!public! !
saveClass:!binary filing!public! !
saveCollection:!binary filing!public! !
saveFloat:!binary filing!public! !
saveLargeInteger:!constants!public! !
saveLookupTable:!binary filing!public! !
saveNil!binary filing!public! !
saveObject:!binary filing!public! !
saveObject:as:!binary filing!public! !
saveResourceLibrary:!binary filing!public! !
saveScaledDecimal:!constants!public! !
saveSet:elements:!binary filing!public! !
saveSmallInteger:!constants!public! !
saveStatic:!binary filing!public! !
saveString:!binary filing!public! !
saveSymbol:!binary filing!public! !
version!accessing!public! !
writeByteObject:!operations!private! !
writeClass:prefix:!operations!private! !
writeClassReference:prefix:!operations!private! !
writeInstanceVariables:!operations!private! !
writePreambleFor:class:!binary filing!public! !
writeReference:!operations!private! !
writeSignatureAndVersion!operations!private! !
!

!Kernel.STxVersionPolicy class methodsFor!

classForVersion: anInteger
	^(self versions lookup: anInteger + 1)
		ifNil: 
			[STBError
				signal: 'Unsupported <2s> format (version <1d>)' << { anInteger. self name copyFrom: 1 to: 3 }]!

filer: anSTxFiler
	^self filer: anSTxFiler version: self version!

filer: anSTBFiler version: anInteger
	^(self classForVersion: anInteger)
		new filer: anSTBFiler version: anInteger!

formatName
	"Answer the format name."

	^self subclassResponsibility!

readVersionFrom: aByteStream
	^self subclassResponsibility!

version
	^self subclassResponsibility!

versions
	"
		Version 0 - Dolphin 1 through 4. 
		Version 1 - Dolphin 5. Preregisters certain commonly occurring classes
		Version 2 - Delegates save/load to class, format changed for certain pre-registered classes. Symbols no longer proxied.
		Version 3 - Dolphin 6. Only writes basicSize for objects of variable classes. Proxying of global nils (largely unused) was broken by an optimisation.
		Version 4 - Dolphin 7. No real format change in STB, although UTF strings may appear in the stream. New version of STL.
		Version 5 - Dolphin 8. Fully-qualified class names written. Classes can implement #stbReadFrom:format:size:, rather than #stbReadFrom:format:.
		Version 6 - Dolphin 8. Proxyless collections. Can write all previous version formats.
	"

	^self subclassResponsibility! !
!Kernel.STxVersionPolicy class categoriesForMethods!
classForVersion:!accessing!public! !
filer:!instance creation!public! !
filer:version:!instance creation!public! !
formatName!constants!public! !
readVersionFrom:!instance creation!public! !
version!constants!public! !
versions!accessing!public! !
!

