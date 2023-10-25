"Filed out from Dolphin Smalltalk"!

Kernel.STxInFiler
	subclass: #'Kernel.STLInFiler'
	instanceVariableNames: 'policy'
	classVariableNames: 'Versions'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'Signature' -> #'!!STL' }!
Kernel.STLInFiler guid: (Core.GUID fromString: '{0eb5f19a-a120-4002-83d9-c520f502de6d}')!
Kernel.STLInFiler comment: '`STLInFiler` is the class of object deserializers for reading streams of objects serialized by a corresponding `STLOutFiler`. 

`STLInFiler` itself currently supports reading the STL 6 literal serialization format.

STL 6 differs from the (interim in Dolphin 8) STL 5 format in the following ways:
  - No classes are pre-registered. This ensures that all classes are visible in the literal array, even `Array`.
- Proxies are no longer required for most collections. SortedCollections are still proxied, however, and other collections can be proxied, e.g. to ensure that the elements are always emitted in a stable ordering.

There are subclasses for reading each of the earlier versions from the original STL 3 up to previous version. The correct class of deserializer is instantiated automatically by reading the version from the header, or a specific subclass can be used.

Backwards compatibility (i.e. reading old formats) should be complete by virtue of this hierarchy of classes and the class specific conversions as implemented by each class'' `stbConvertFrom:` method. Any failure to read an old stream should be considered a bug.'!
!Kernel.STLInFiler categoriesForClass!System-Binary storage! !
!Kernel.STLInFiler methodsFor!

basicNext
	"Private - Answer the next object from the receiver's stream."

	| prefixOrLiteral |
	prefixOrLiteral := stream next.
	prefixOrLiteral isInteger
		ifFalse: 
			["Atomic values, or an indirection to them; classes are represented by BindingReferences as these have a literal form that can be embedded in literal arrays. This will not include integers, but does include nil, true, false, Symbols, BindingReferences (except as an indirection to a class object), and (in old version STL content) class objects. It cannot include arrays, even of atomic objects, because the array itself is not atomic and may be shared."
			^prefixOrLiteral value].
	PrefixLiteralMask == prefixOrLiteral ifFalse: [^self readObjectWithPrefix: prefixOrLiteral].
	^self readLiteralData!

characterValue: anInteger
	"Answer the <Character> for the specified <Integer> code read from the object stream."

	"Only relevant to STB and the original STL 3 format. In STL 4+ Characters are written as literals, so we don't expect to encounter an encoded character."

	^STBError signal: 'Unexpected encoded Character in <1s> input stream: <2p>'
				<< { self stxFormatName. Character codePoint: anInteger }!

lastPredefined
	"Private - Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^0!

readBytes: anInteger into: aByteObject
	^stream next
		replaceBytesOf: aByteObject
		from: 1
		to: anInteger
		startingAt: 1!

readClassDataWithPrefix: anInteger
	"Private - Deserialize the class data preceding the instance data of a class not previously seen in the object stream."

	"As of STL 5 the class refs are printed into the STL as BindingReferences. These are true literals (so don't need the ##() expressions to be embedded in the literal array) but need to be resolved back to the class by sending them #value. Note that the resolved binding is cached by the literal BindingReference object, so for STL stored as a literal array in a method this is still relatively efficient after the first run through."

	^self
		registerVersion: ((anInteger allMask: PrefixNonZeroVersionMask) ifTrue: [stream next] ifFalse: [0])
		ofClass: stream next value
		prefix: anInteger!

readExtensibleCollection: aClass format: anSTBClassConversion size: anInteger
	| set |
	set := aClass new: anInteger.
	decorator register: set.
	anInteger timesRepeat: [set add: decorator basicNext].
	^set!

readLiteralData
	| newObject |
	newObject := stream next.
	newObject basicClass == Array
		ifTrue: 
			[| array size |
			"We have to resolve any BindingReferences in the literal array"
			array := Array basicNew: (size := newObject size).
			1 to: size do: [:i | array at: i put: (newObject at: i) value].
			newObject := array]
		ifFalse: [newObject isImmutable ifTrue: [newObject := newObject copy]].
	decorator register: newObject.
	^newObject!

readLookupTable: aClass format: anSTBClassConversion size: anInteger
	"LookupTables have a proxy-less representation in version 6. The format is the the class name and size (already read), followed by a sequence of key-value pairs emitted directly into the STB stream."

	| lookupTable |
	lookupTable := aClass new: anInteger.
	decorator register: lookupTable.
	anInteger timesRepeat: [lookupTable at: decorator basicNext put: decorator basicNext].
	^lookupTable!

readObjectWithPrefix: anInteger
	"Private - Deserialize an object from the literal stream with the specified <Integer> prefix code."

	"In STL 5+, the input stream should not contain encoded nil's or Characters, as these are written as literals. SmallIntegers are still encoded though, as this is necessary to distinguish these from the prefix values."

	| anObject newObjectIndex class |
	(anInteger allMask: PrefixSmallIntegerMask)
		ifTrue: 
			["SmallInteger encoded in the prefix"
			^anInteger bitShift: -1].
	(anInteger allMask: PrefixDataMask)
		ifFalse: 
			["Not data, so must be an encoded object reference"
			^decorator objectAt: (anInteger bitShift: PrefixRefUnshift)].

	"Ascertain the class of the object."
	class := (anInteger allMask: PrefixClassMask)
				ifTrue: [self readClassDataWithPrefix: anInteger]
				ifFalse: 
					["Reference to previously encountered class"
					decorator classAt: (anInteger bitShift: PrefixRefUnshift)].

	"Now read the object data, delegating to the class to allow for custom formats."
	newObjectIndex := readMap size + 1.
	anObject := class stbReadFrom: decorator format: (converters lookup: class).

	"Finally invite the object to perform fixup such as replacing itself with another, e.g. if it is an STBProxy."
	^anObject stbFixup: decorator at: newObjectIndex!

readSizeOf: aClass
	"Read the indexable size of an object of the specified <Class> from the object stream."

	^aClass isVariable ifTrue: [stream next] ifFalse: [0]!

readString: aClass format: aSTxClassConversion
	"Deserialize a <String> from the object stream."

	"We'll only be here for deserializing non-literal Utf8Strings, which are written as an (unregistered) literal ByteArray."

	| string |
	string := decorator basicNext asUtf8String.
	decorator register: string.
	^string!

readSymbol: aSTxClassConversion
	"Symbols are always written in literal form in STL, so we should never get here"

	^self shouldNotImplement!

registerPredefinedObjects
	"Private - We may pre-register a few special objects that must never be recreated, depending on the version policy and format."

	"In STL 4 and later there are no pre-registered objects, although STL 4 still has predefined classes"! !
!Kernel.STLInFiler categoriesForMethods!
basicNext!accessing!private! !
characterValue:!helpers!public! !
lastPredefined!constants!private! !
readBytes:into:!helpers!private! !
readClassDataWithPrefix:!operations!public! !
readExtensibleCollection:format:size:!operations!public! !
readLiteralData!helpers!private! !
readLookupTable:format:size:!operations!public! !
readObjectWithPrefix:!operations!private! !
readSizeOf:!deserializing!public! !
readString:format:!deserializing!public! !
readSymbol:!deserializing!public! !
registerPredefinedObjects!initializing!private! !
!

!Kernel.STLInFiler class methodsFor!

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

	Versions := Array new: 7.
	self register!

peekForSignatureIn: aReadStream
	"Answer whether the <readableStream> argument, aReadStream, appears to be an STL stream (or is positioned at the start of an STL stream). If the STL signature is found, then the stream is left positioned immediately after it, otherwise the stream position is not changed."

	| position |
	position := aReadStream position.
	^aReadStream nextAvailable = Signature or: 
			[aReadStream position: position.
			false]!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered for every STL stream of this version."

	"There was relatively little benefit in pre-registering classes in STL, since it does not have the chicken-before-egg problem that STB has with, for example, Strings, since all the types that are required to support the format itself have a literal representation and will be instantiated by the compiler. The classes for objects with literal form do not need to be registered. We also do not need the STB class proxies in the STL representation. The downside of pre-registering is that the references to the class are not visible as normal references (although the STLClassCollector will find them). Given the hidden references downside, and limited advantages in STL, we drop all pre-registered classes in STL 6."

	^#()!

readVersionFrom: aReadStream
	"Private - Read and answer the <integer> STL format version from the stream."

	^aReadStream nextAvailable!

register
	Versions at: self version + 1 put: self!

stxFormatName
	"Answer the format name, either STB or STL."

	^'STL'!

uninitialize
	self unregister!

unregister
	Versions at: self version + 1 put: nil!

versions
	^Versions! !
!Kernel.STLInFiler class categoriesForMethods!
initialize!class initialization!public! !
peekForSignatureIn:!public!testing! !
predefinedClasses!constants!public! !
readVersionFrom:!helpers!private! !
register!class initialization!private! !
stxFormatName!constants!public! !
uninitialize!class hierarchy-removing!public! !
unregister!class hierarchy-removing!private! !
versions!accessing!public! !
!

