"Filed out from Dolphin Smalltalk"!

Kernel.STBFiler subclass: #'Kernel.AbstractSTBInFiler'
	instanceVariableNames: 'readMap converters deferredActions flags readSize'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'UpgradingMask' -> 16r1
	}!
Kernel.AbstractSTBInFiler guid: (Core.GUID fromString: '{28fb7b4f-ca63-4a50-af05-a1c54269e4ff}')!
Kernel.AbstractSTBInFiler isNonInstantiable: true!
Kernel.AbstractSTBInFiler comment: ''!
!Kernel.AbstractSTBInFiler categoriesForClass!System-Binary storage! !
!Kernel.AbstractSTBInFiler methodsFor!

basicNext
	"Private - Answer the next object from the receiver's stream."

	^self readObjectWithPrefix: self readInteger!

classAt: anInteger
	"Private - Answer the map value for a class at anInteger. If anInteger is zero then answer nil.
	Signal an exception if there is no such entry."

	^self objectAt: anInteger!

contents
	"Answer an array of the objects stored in the stream."

	| writeStream |
	writeStream := Array writeStream: 16.
	[self atEnd] whileFalse: [writeStream nextPut: self next].
	^writeStream contents!

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

isUpgrading
	^flags allMask: UpgradingMask!

isUpgrading: aBoolean 
	flags := flags mask: UpgradingMask set: aBoolean!

newClassLocator
	^self subclassResponsibility!

next
	"Answer the next object from the receiver's stream."

	| nextObject |
	nextObject := self basicNext.
	self evaluateDeferredActions.
	^nextObject!

objectAt: anInteger
	"Private - Answer the map value at anInteger. Signal an exception if there is no such entry."

	^readMap at: anInteger!

readClassData: anInteger
	"Private - Answer the class whose details are prefixed by the specified <integer> flags
	in <STBPrefix> format."

	| versionBeingRead class format |
	versionBeingRead := (anInteger allMask: STBPrefix.NonZeroVersionMask)
				ifTrue: [self readInteger]
				ifFalse: [0].
	class := self readClassLocator: anInteger.
	self register: class.
	versionBeingRead == class stbVersion ifTrue: [^class].
	format := STBClassConversion
				forFiler: self
				class: class
				version: versionBeingRead
				prefix: anInteger.
	format converterBlock isNil
		ifTrue: [^self class errorUnrecognisedClass: class version: versionBeingRead].
	converters at: class put: format.
	^class!

readClassLocator: anIntegerFlags
	^self subclassResponsibility!

readInteger
	"Private - Answer the next 32-bit integer in the stream."

	^stream nextSDWORD!

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

readObjectWithPrefix: anInteger
	| anObject newObjectIndex class |
	anInteger == 0 ifTrue: [^nil].	"optimize for nil"

	"SmallInteger?"
	(anInteger allMask: STBPrefix.SmallIntegerMask) ifTrue: [^anInteger bitShift: -1].
	(anInteger allMask: STBPrefix.DataPrefixMask)
		ifFalse: 
			[^(anInteger allMask: STBPrefix.CharacterMask)
				ifTrue: [Character value: (anInteger bitShift: STBPrefix.IndexShift)]
				ifFalse: [self objectAt: (anInteger bitShift: STBPrefix.IndexShift)]].

	"Ascertain the class of the object."
	class := (anInteger allMask: STBPrefix.ClassPrefixMask)
				ifTrue: [self readClassData: anInteger]
				ifFalse: [self classAt: (anInteger bitShift: STBPrefix.IndexShift)].

	"Now read the object data."
	newObjectIndex := readMap size + 1.
	anObject := class stbReadFrom: self format: (converters lookup: class).

	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: self at: newObjectIndex!

readSizeBlock
	^version < 3
		ifTrue: [[:class | stream nextSDWORD]]
		ifFalse: [[:class | class isVariable ifTrue: [stream nextSDWORD] ifFalse: [0]]]!

readSizeOf: aClass
	^readSize value: aClass!

readVersion
	| char |
	version := 0.
	[(char := Character ansiValue: stream next) isDigit]
		whileTrue: [version := version * 10 + char digitValue].
	^char == $\x20!

register: anObject
	"Private - Add anObject to the readMap, answering the index of the object in the map. This is important for some classes that might want to fixup the reference later."

	^readMap addAnsweringIndex: anObject!

registerAll: anArrayOfClass 
	readMap addAllLast: anArrayOfClass!

reset
	"Private - Reset the instance.
	Read the stream to establish whether it is in STB format
	and if so initialise the readMap."

	self resetAndValidateStream.
	readMap := OrderedCollection new: 512.
	converters := IdentityDictionary new.
	deferredActions := nil.
	readSize := self readSizeBlock.
	super reset!

resetAndValidateStream
	((self class peekForSignatureIn: stream) and: [self readVersion])
		ifFalse: 
			[STBError
				signal: ('Input stream not in <1s> format' expandMacrosWith: self class signature asAnsiString)].
	version > self class version
		ifTrue: 
			[STBError
				signal: ('Input stream is an incompatible <2s> format (version <1d>)' expandMacrosWith: version
						with: self class signature asAnsiString)]!

setRefOffset: anInteger
	readMap setSize: anInteger! !
!Kernel.AbstractSTBInFiler categoriesForMethods!
basicNext!accessing!private! !
classAt:!accessing!private! !
contents!enumerating!public! !
convertObjectOfClass:size:format:!operations!private! !
defaultClassLocatorClass!constants!private! !
deferAction:!deferred actions!public! !
evaluateDeferredActions!deferred actions!private! !
fixup:to:!operations!public! !
initialize!initializing!private! !
isUpgrading!public!testing! !
isUpgrading:!accessing!public! !
newClassLocator!helpers!private! !
next!operations!public! !
objectAt:!accessing!private! !
readClassData:!helpers!private! !
readClassLocator:!helpers!private! !
readInteger!helpers!private! !
readMap!accessing!private! !
readObjectOfClass:format:size:!operations!public! !
readObjectOfClass:size:!operations!private! !
readObjectWithPrefix:!accessing!private! !
readSizeBlock!operations!private! !
readSizeOf:!operations!public! !
readVersion!initializing!private! !
register:!helpers!private! !
registerAll:!public! !
reset!initializing!private! !
resetAndValidateStream!initializing!private! !
setRefOffset:!accessing!private! !
!

!Kernel.AbstractSTBInFiler class methodsFor!

peekForSignatureIn: aReadStream
	"Answer whether the <readableStream> argument, aReadStream, appears to
	be an STB stream (or is positioned at the start of an STB stream). If the STB
	signature is found, then the stream is left positioned immediately after it, 
	otherwise the stream position is not changed."

	| position |
	position := aReadStream position.
	^(aReadStream nextAvailable: self signature size) asByteArray = self signature
		or: [aReadStream position: position. false]! !
!Kernel.AbstractSTBInFiler class categoriesForMethods!
peekForSignatureIn:!public!testing! !
!

