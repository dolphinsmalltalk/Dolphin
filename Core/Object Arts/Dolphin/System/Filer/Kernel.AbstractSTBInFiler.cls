"Filed out from Dolphin Smalltalk"!

Kernel.STBFiler
	subclass: #'Kernel.AbstractSTBInFiler'
	instanceVariableNames: 'readMap converters deferredActions flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'UpgradingMask' -> 16r1 }!
Kernel.AbstractSTBInFiler guid: (Core.GUID fromString: '{28fb7b4f-ca63-4a50-af05-a1c54269e4ff}')!
Kernel.AbstractSTBInFiler isNonInstantiable: true!
Kernel.AbstractSTBInFiler comment: ''!
!Kernel.AbstractSTBInFiler categoriesForClass!System-Binary storage! !
!Kernel.AbstractSTBInFiler methodsFor!

basicNext
	"Private - Answer the next object from the receiver's stream."

	^self subclassResponsibility!

classAt: anInteger
	"Private - Answer the map value for a class at anInteger.
	Signal an exception if the class reference is invalid or not to one of the permitted classes."

	| class |
	class := readMap lookup: anInteger.
	class class isMeta
		ifTrue: 
			["Any class already in the read map must have passed any validator previously. Even the pre-defined classes are validated before addition."
			^class].
	"The index did not identify a class."
	(policy lookupPredefinedClass: anInteger)
		ifNil: 
			["Corrupt input stream - the reference object is not a class, e.g. a malicious user could construct a stream that loads an object of a valid class, and then direct the filer to treat it as the class of another entry by modifying the class reference to the reference generated for the prior object that is not actually a class."
			STBError signal: '<1s> input stream contains an invalid class reference (<2d>)'
						<< { self class formatName. anInteger }]
		ifNotNil: 
			[:predefined |
			"A pre-defined class that is not among those allowed (e.g. when using an STBValidatingInFiler), so report the class that would have been  referenced if permitted."
			self class errorInvalidClass: predefined asQualifiedReference]!

classLocator
	"Answer a <ClassLocator> for use in resolving classes from the receiver's input stream."

	^self subclassResponsibility!

contents
	"Answer an array of the objects stored in the stream."

	| writeStream |
	writeStream := Array writeStream: 16.
	[self atEnd] whileFalse: [writeStream nextPut: self next].
	^writeStream contents!

converters
	^converters!

convertObjectOfClass: aClass size: anInteger format: anSTBClassConversion
	"Private - Read on old format object from the stream: Create an Array or ByteArray into which the stored instance variables are deserialized. This is passed to the converter block which answers an instance of the real class initialised from the array."

	| newObject |
	aClass isPointers
		ifTrue: 
			[newObject := Array new: anSTBClassConversion instSize + anInteger.
			self register: newObject.
			1 to: newObject size do: [:i | newObject at: i put: self basicNext]]
		ifFalse: 
			[newObject := ByteArray new: anInteger.
			self register: newObject.
			1 to: anInteger do: [:i | newObject at: i put: stream next]].
	"Initialise a new instance from the old format object data and become it."
	newObject become: (anSTBClassConversion converterBlock value: newObject).
	^newObject!

deferAction: aNiladicValuable
	"Add the <niladicValuable> argument to the receiver's deferredActions collection for later 
	evaluation just before the receiver answers from its #next method. This method is available for 
	use by the #fixup:at: method of STBProxy classes to defer a <niladicValuable> for fixing-up
	of new instances when all filed-in objects are in a known state."

	deferredActions isNil ifTrue: [deferredActions := OrderedCollection new].
	deferredActions addLast: aNiladicValuable!

elements
	"Answer all the objects that have been read from the stream up to this point, disregarding any pre-registered classes or objects.
	Once the deserialisation is complete, this should be the complete set of objects in the object graph, excluding pre-registered objects."

	^readMap copyFrom: self policy lastPredefined + 1!

errorUnrecognisedClass: aClass version: version
	"Private - Signal an STBError indicating that the STB data contains
	instances of aClass of version that we don't know how to convert."

	STBError signal: 'Input stream contains an unsupported version <1d> of <2p>' << { version. aClass }!

evaluateDeferredActions
	"Private - Evaluate any deferred actions then clear the deferredActions collection."

	deferredActions notNil ifTrue: [
		deferredActions do: [:aNiladicValuable | aNiladicValuable value].
		deferredActions := nil]!

fixup: anInteger to: anObject
	"Replace the readMap entry at anInteger with anObject."

	readMap at: anInteger put: anObject
!

initialize
	"Private - Initialize the receiver."

	flags := 0.
	^super initialize!

initializeObjectMap
	self initializeReadMap!

initializeReadMap
	readMap := OrderedCollection new: 512.
	policy registerPredefined: self!

isUpgrading
	^flags allMask: UpgradingMask!

isUpgrading: aBoolean 
	flags := flags mask: UpgradingMask set: aBoolean!

next
	"Answer the next object from the receiver's stream."

	| nextObject |
	nextObject := self basicNext.
	self evaluateDeferredActions.
	^nextObject!

objectAt: anInteger
	"Private - Answer the map value at anInteger. Signal an exception if there is no such entry."

	^(readMap lookup: anInteger) ifNil: [self class errorInconsistentSTB: anInteger]!

policy: anObject
	policy := anObject!

readByteObject: aByteObject
	self register: aByteObject.
	policy readByteObject: aByteObject!

readMap
	"Private - Answer the value of the receiver's readMap. This is an OrderedCollection of all
	the object read so far from the filer. It is used  to map the object identifiers in
	the file stream (which are really the indices into the collection) to the actual
	objects"

	^readMap!

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

	| newObject instSpec  |
	"Register the new object before reading its instance variables, in case of circular references"
	self register: (newObject := aClass basicNew: anInteger).
	instSpec := aClass instanceSpec.
	(instSpec anyMask: Behavior._PointersMask)
		ifTrue: 
			[1 to: (instSpec bitAnd: Behavior._SizeMask) + anInteger
				do: [:i | newObject instVarAt: i put: self basicNext]]
		ifFalse: [1 to: anInteger do: [:i | newObject basicAt: i put: stream next]].
	^newObject!

readSizeOf: aClass
	^policy readObjectSize: aClass!

readVersion
	policy := self class versionPolicyClass readVersionFrom: self.
	^policy notNil!

register: anObject
	"Private - Add anObject to the readMap, answering the index of the object in the map. This is important for some classes that might want to fixup the reference later."

	^readMap addAnsweringIndex: anObject!

registerAllClasses: anArrayOfClass
	readMap addAllLast: anArrayOfClass!

registerClass: aClass version: versionInteger prefix: prefixInteger
	| format |
	self register: aClass.
	versionInteger == aClass stbVersion ifTrue: [^aClass].
	format := STBClassConversion
				forFiler: self
				class: aClass
				version: versionInteger
				prefix: prefixInteger.
	format converterBlock ifNil: [^self errorUnrecognisedClass: aClass version: versionInteger].
	converters at: aClass put: format.
	^aClass!

reset
	"Private - Reset the instance.
	Read the stream to establish whether it is in STB format
	and if so initialise the readMap."

	self resetAndValidateStream.
	readMap := OrderedCollection new: 512.
	converters := IdentityDictionary new.
	deferredActions := nil.
	self initializeObjectMap!

resetAndValidateStream
	((self class peekForSignatureIn: stream) and: [self readVersion])
		ifFalse: [STBError signal: 'Input stream not in <1s> format' << self class formatName]!

setRefOffset: anInteger
	readMap setSize: anInteger!

stream: aStream
	stream := aStream.
	self initialize! !
!Kernel.AbstractSTBInFiler categoriesForMethods!
basicNext!accessing!private! !
classAt:!accessing!private! !
classLocator!accessing!public! !
contents!enumerating!public! !
converters!accessing!private! !
convertObjectOfClass:size:format:!operations!private! !
deferAction:!deferred actions!public! !
elements!accessing!public! !
errorUnrecognisedClass:version:!exceptions!private! !
evaluateDeferredActions!deferred actions!private! !
fixup:to:!operations!public! !
initialize!initializing!private! !
initializeObjectMap!initializing!private! !
initializeReadMap!initializing!private! !
isUpgrading!public!testing! !
isUpgrading:!accessing!public! !
next!operations!public! !
objectAt:!accessing!private! !
policy:!accessing!private! !
readByteObject:!public! !
readMap!accessing!private! !
readObjectOfClass:format:size:!operations!public! !
readObjectOfClass:size:!operations!private! !
readSizeOf:!operations!public! !
readVersion!initializing!private! !
register:!helpers!private! !
registerAllClasses:!private! !
registerClass:version:prefix:!helpers!private! !
reset!initializing!private! !
resetAndValidateStream!initializing!private! !
setRefOffset:!accessing!private! !
stream:!initializing!private! !
!

!Kernel.AbstractSTBInFiler class methodsFor!

errorInconsistentSTB: anInteger
	"Private - Signal an STBError indicating that the stream being read contains inconsistent STB data."

	STBError signal: '<1s> input stream is inconsistent (object <2d> referenced but not yet defined)'
				<< { self formatName. anInteger }!

errorInvalidClass: aBindingReference
	"Private - Signal an exception to warn that an input stream contains an invalid class."

	STBError signal: '<1s> input stream contains an invalid class (<2d>)'
				<< { self formatName. aBindingReference }!

on: aStream
	"Answer a new instance attached to the binary stream aStream."

	^self new stream: aStream!

peekForSignatureIn: aReadStream
	"Answer whether the <readableStream> argument, aReadStream, appears to be an STB stream (or is positioned at the start of an STB stream). If the STB signature is found, then the stream is left positioned immediately after it, otherwise the stream position is not changed."

	^self versionPolicyClass peekForSignatureIn: aReadStream! !
!Kernel.AbstractSTBInFiler class categoriesForMethods!
errorInconsistentSTB:!exceptions!private! !
errorInvalidClass:!exceptions!private! !
on:!instance creation!public! !
peekForSignatureIn:!public!testing! !
!

