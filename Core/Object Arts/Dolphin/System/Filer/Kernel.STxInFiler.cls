"Filed out from Dolphin Smalltalk"!

Kernel.STxFiler
	subclass: #'Kernel.STxInFiler'
	instanceVariableNames: 'decorator readMap converters deferredActions classLocator context'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'UpgradingMask' -> 16r1 }!
Kernel.STxInFiler guid: (Core.GUID fromString: '{28fb7b4f-ca63-4a50-af05-a1c54269e4ff}')!
Kernel.STxInFiler isNonInstantiable: true!
Kernel.STxInFiler comment: '`STxInFiler` is the abstract class of object deserializers for reading streams of objects serialized by a corresponding `STxOutFiler`. There are concrete classes for reading each version from the original STB v0 up to the current version.

Backwards compatibility (i.e. reading old formats) should be complete by virtue of this hierarchy of classes and the class specific conversions as implemented by each class'' `stbConvertFrom:` method. Any failure to read an old stream should be considered a bug.'!
!Kernel.STxInFiler categoriesForClass!System-Binary storage! !
!Kernel.STxInFiler methodsFor!

basicNext
	"Answer the next object from the receiver's stream."

	^self subclassResponsibility!

characterValue: anInteger
	"Answer the <Character> for the specified <Integer> code from the object stream."

	^self subclassResponsibility!

classAt: anInteger
	"Answer the read map value for a <Class> with the specified reference.
	Signal an exception if the class reference is invalid or not to one of the permitted classes."

	| class |
	class := readMap lookup: anInteger.
	class class isMeta ifFalse: [^self errorInvalidClassRef: anInteger].
	"Any class already in the read map must have passed any validator previously. Even the pre-defined classes are validated before addition."
	^class!

classLocator
	"Answer the receiver's classLocator inst var. This holds the context of any remote class references and provides the mechanism of resolving them."

	^classLocator ifNil: [classLocator := self defaultClassLocatorClass new]!

classLocator: aClassLocator
	"Sets the receiver's classLocator instVar to aClassLocator.
	This is required to hold the context of any relative class reference and to provide
	the mechanism for resolving it."

	classLocator := aClassLocator!

contents
	"Answer an array of the objects stored in the stream."

	| writeStream |
	writeStream := Array writeStream: 16.
	[self atEnd] whileFalse: [writeStream nextPut: self next].
	^writeStream contents!

context
	"Answers the context for objects read by the receiver"

	^context!

context: anObject
	"Sets the context for objects read by the receiver to anObject. This may be, for example, the parent window of a window being read."

	context := anObject!

converterFor: aClass
	"Answer the <StxClassConversion> registered for the specified <Class>, or nil if none."

	^converters lookup: aClass!

convertObjectOfClass: aClass size: anInteger format: anSTBClassConversion
	"Private - Read on old format object from the stream: Create an Array or ByteArray into which the stored instance variables are deserialized. This is passed to the converter block which answers an instance of the real class initialised from the array."

	| newObject |
	aClass isPointers
		ifTrue: 
			[newObject := Array new: anSTBClassConversion instSize + anInteger.
			decorator register: newObject.
			1 to: newObject size do: [:i | newObject at: i put: self basicNext]]
		ifFalse: 
			[newObject := ByteArray new: anInteger.
			decorator register: newObject.
			1 to: anInteger do: [:i | newObject at: i put: stream next]].
	"Initialise a new instance from the old format object data and become it."
	newObject become: (anSTBClassConversion converterBlock value: newObject).
	^newObject!

decorator
	^decorator!

decorator: aSTxInFiler
	"Wrap this in-filer with a decorator."

	decorator := aSTxInFiler!

defaultClassLocatorClass
	"Answer the class of Class Locator to use by default for finding and validating
	classes in the receiver's input stream."

	^ClassLocator!

deferAction: aNiladicValuable
	"Add the <niladicValuable> argument to the receiver's deferredActions collection for later 
	evaluation just before the receiver answers from its #next method. This method is available for 
	use by the #fixup:at: method of STBProxy classes to defer a <niladicValuable> for fixing-up
	of new instances when all filed-in objects are in a known state."

	deferredActions isNil ifTrue: [deferredActions := OrderedCollection new].
	deferredActions addLast: aNiladicValuable!

elements
	"Answer all the objects that have been read from the stream up to this point, disregarding any pre-registered classes or objects. Once the deserialisation is complete, this should be the complete set of objects in the object graph, excluding pre-registered objects, although for STLInFilers it will not include any atomic objects represented directly as literals, as these are not placed in the readMap."

	^readMap copyFrom: self lastPredefined + 1!

errorInvalidClassRef: anInteger
	(self lookupPredefinedClass: anInteger)
		ifNil: 
			["Corrupt input stream - the reference object is not a class, e.g. a bad actor could construct a stream that loads an object of a valid class, and then direct the filer to treat it as the class of another entry by modifying the class reference to the reference generated for the prior object that is not actually a class."
			STBError signal: '<1s> input stream contains an invalid class reference: <2d>'
						<< { self stxFormatName. anInteger }]
		ifNotNil: 
			[:predefined |
			"A pre-defined class that is not among those allowed (e.g. when using an STBValidatingInFiler), so report the class that would have been referenced if permitted."
			self class errorInvalidClass: predefined asQualifiedReference]!

errorInvalidObjectRef: anInteger
	"Private - Signal an STBError indicating that the stream being read contains inconsistent STB data."

	^(self lookupPredefinedClass: anInteger)
		ifNotNil: 
			[:class |
			"A pre-defined class that is not among those allowed (e.g. when using an STBValidatingInFiler), so report the class that would have been referenced if permitted."
			self class errorInvalidClass: class asQualifiedReference]
		ifNil: 
			[STBError signal: '<1s> input stream is inconsistent (object <2d> referenced but not yet defined)'
						<< { self stxFormatName. anInteger }]!

errorUnrecognisedClass: aClass version: version
	"Private - Signal an STBError indicating that the STB data contains
	instances of aClass of version that we don't know how to convert."

	STBError signal: '<1s> input stream contains an unsupported version <2d> of <3p>'
				<< { self stxFormatName. version. aClass }!

evaluateDeferredActions
	"Private - Evaluate any deferred actions then clear the deferredActions collection."

	(deferredActions ifNil: [^self]) do: [:aNiladicValuable | aNiladicValuable value].
	deferredActions := nil!

fixup: anInteger to: anObject
	"Replace the readMap entry at anInteger with anObject."

	readMap at: anInteger put: anObject
!

initialize
	"Private - Initialize the receiver."

	decorator := self.
	^super initialize!

isUpgrading
	^flags allMask: UpgradingMask!

isUpgrading: aBoolean 
	flags := flags mask: UpgradingMask set: aBoolean!

lookupPredefinedClass: anInteger
	^self predefinedClasses lookup: anInteger - predefinedClassOffset!

next
	"Answer the next object from the receiver's stream, evaluating any deferred actions to complete the object graph deserialization."

	| nextObject |
	nextObject := self basicNext.
	self evaluateDeferredActions.
	^nextObject!

nextIndex
	"Answer the next unused object reference."

	^readMap size + 1!

objectAt: anInteger
	"Answer the map value at anInteger. Signal an exception if there is no such entry."

	^(readMap lookup: anInteger) ifNil: [self errorInvalidObjectRef: anInteger]!

predefinedClasses
	^self class predefinedClasses!

readByteObject: aClass size: anInteger
	"Deserialize a byte object of the specified <Class> and size from the object stream."

	| object |
	object := aClass basicNew: anInteger.
	decorator register: object.
	self readBytes: anInteger into: object.
	^object!

readBytes: anInteger into: aByteObject
	^self subclassResponsibility!

readClassDataWithPrefix: anInteger
	"Private - Deserialize the class data preceding the instance data of a class not previously seen in the object stream."

	^self subclassResponsibility!

readExtensibleCollection: aClass format: anSTBClassConversion size: anInteger
	"Deserialize an <extensibleCollection> from the object stream. From STx 6, These are written without a proxy as a class (e.g. OrderedCollection) followed by a sequence elements."

	^self subclassResponsibility!

readLookupTable: aClass format: anSTBClassConversion size: anInteger
	"Deserialize a LookupTable from the object stream. From STx 6, these are written without a proxy as a class (e.g. LookupTable or IdentityDictionary) followed by a sequence of key-value pairs."

	^self subclassResponsibility!

readMap
	"Private - Answer the value of the receiver's readMap. This is an OrderedCollection of all the objects read so far from the filer. It is used  to map the object identifiers in the stream (which are really the indices into the collection) to the actual	objects"

	^readMap!

readNil
	"Read a nil from the object stream"

	^nil!

readObjectOfClass: aClass format: anSTBClassConversion size: anInteger
	"Read the stream for the data to create an instance of aClass."

	^anSTBClassConversion
		ifNil: [self readObjectOfClass: aClass size: anInteger]
		ifNotNil: 
			[self
				convertObjectOfClass: aClass
				size: anInteger
				format: anSTBClassConversion]!

readObjectOfClass: aClass size: anInteger
	"Private - Read an object of the specified class and variable size, that is of the current format"

	| newObject instSpec |
	"Register the new object before reading its instance variables, in case of circular references"
	decorator register: (newObject := aClass basicNew: anInteger).
	instSpec := aClass instanceSpec.
	(instSpec anyMask: Behavior._PointersMask)
		ifTrue: 
			[1 to: (instSpec bitAnd: Behavior._SizeMask) + anInteger
				do: [:i | newObject instVarAt: i put: decorator basicNext]]
		ifFalse: [1 to: anInteger do: [:i | newObject basicAt: i put: stream next]].
	^newObject!

readSizeOf: aClass
	"Read the indexable size of an object of the specified <Class> from the object stream."

	^self subclassResponsibility!

readString: aClass format: aSTxClassConversion
	"Deserialize a <String> from the object stream."

	^self subclassResponsibility!

readSymbol: aSTxClassConversion
	"Deserialize a <Symbol> from the object stream."

	^self subclassResponsibility!

register: anObject
	"Add anObject to the readMap, answering the index of the object in the map. This is important for some classes that might want to fixup the reference later."

	^readMap addAnsweringIndex: anObject!

registerConversionFrom: versionInteger ofClass: aClass prefix: prefixInteger
	| format |
	format := STxClassConversion
				forFiler: self
				class: aClass
				version: versionInteger
				prefix: prefixInteger.
	format converterBlock ifNil: [^self errorUnrecognisedClass: aClass version: versionInteger].
	converters at: aClass put: format.
	^aClass!

registerPredefinedClasses
	| locator |
	predefinedClassOffset := readMap size.
	locator := self classLocator.
	self predefinedClasses do: [:each | readMap addLast: ((locator includesClass: each) ifTrue: [each])].
	readMap setSize: self lastPredefined!

registerVersion: versionInteger ofClass: aClass prefix: prefixInteger
	decorator register: aClass.
	versionInteger == aClass stbVersion
		ifFalse: 
			[self
				registerConversionFrom: versionInteger
				ofClass: aClass
				prefix: prefixInteger].
	^aClass!

reset
	"Private - Reset the instance."

	readMap := OrderedCollection new: 512.
	converters := IdentityDictionary new.
	deferredActions := nil.
	self registerPredefined!

stream: aStream
	stream := aStream.
	self initialize! !
!Kernel.STxInFiler categoriesForMethods!
basicNext!accessing!public! !
characterValue:!helpers!public! !
classAt:!accessing!public! !
classLocator!accessing!public! !
classLocator:!accessing!public! !
contents!enumerating!public! !
context!accessing!public! !
context:!accessing!public! !
converterFor:!accessing!public! !
convertObjectOfClass:size:format:!operations!private! !
decorator!public! !
decorator:!public! !
defaultClassLocatorClass!constants!private! !
deferAction:!deferred actions!public! !
elements!accessing!public! !
errorInvalidClassRef:!public! !
errorInvalidObjectRef:!public! !
errorUnrecognisedClass:version:!exceptions!private! !
evaluateDeferredActions!deferred actions!private! !
fixup:to:!operations!public! !
initialize!initializing!private! !
isUpgrading!public!testing! !
isUpgrading:!accessing!public! !
lookupPredefinedClass:!helpers!private! !
next!operations!public! !
nextIndex!accessing!public! !
objectAt:!accessing!public! !
predefinedClasses!private! !
readByteObject:size:!deserializing!public! !
readBytes:into:!helpers!private! !
readClassDataWithPrefix:!helpers!private! !
readExtensibleCollection:format:size:!operations!public! !
readLookupTable:format:size:!operations!public! !
readMap!accessing!private! !
readNil!deserializing!public! !
readObjectOfClass:format:size:!operations!public! !
readObjectOfClass:size:!operations!private! !
readSizeOf:!deserializing!public! !
readString:format:!deserializing!public! !
readSymbol:!deserializing!public! !
register:!helpers!public! !
registerConversionFrom:ofClass:prefix:!helpers!private! !
registerPredefinedClasses!initializing!private! !
registerVersion:ofClass:prefix:!helpers!private! !
reset!initializing!private! !
stream:!initializing!private! !
!

!Kernel.STxInFiler class methodsFor!

errorInvalidClass: aBindingReference
	"Private - Signal an exception to warn that an input stream contains an invalid class."

	STBError signal: 'Input stream contains an invalid class (<1d>)' << { aBindingReference }!

newOn: aPuttableStream
	"Private - Answer a new instance for serialising object graphs to the <puttableStream> first argument, using the version policy specified as the 2nd argument."

	^self new stream: aPuttableStream!

on: aStream
	"Answer a new instance attached to the binary stream aStream."

	^(self classForVersion: (self readSignatureAndVersion: aStream)) newOn: aStream!

peekForSignatureIn: aReadStream
	"Answer whether the <readableStream> argument, aReadStream, appears to be an STB stream (or is positioned at the start of an STB stream). If the STB signature is found, then the stream is left positioned immediately after it, otherwise the stream position is not changed."

	^self subclassResponsibility!

predefinedClasses
	"Answer the sequence of classes that are pre-registered for this STx filer version."

	^self subclassResponsibility!

readSignatureAndVersion: aStream
	"Return the STB/STL signature and stbVersion from the object stream, aStream. Throw an error if the stream does not contain STx data or is of an an unrecognised version."

	(self peekForSignatureIn: aStream)
		ifTrue: [(self readVersionFrom: aStream) ifNotNil: [:ver | ^ver]].
	STBError signal: 'Input stream not in <1s> format' << self stxFormatName!

readVersionFrom: aReadStream
	"Private - Read and answer the <integer> STx format version from the stream."

	^self subclassResponsibility! !
!Kernel.STxInFiler class categoriesForMethods!
errorInvalidClass:!exceptions!private! !
newOn:!instance creation!private! !
on:!instance creation!public! !
peekForSignatureIn:!public!testing! !
predefinedClasses!public! !
readSignatureAndVersion:!helpers!public! !
readVersionFrom:!helpers!private! !
!

