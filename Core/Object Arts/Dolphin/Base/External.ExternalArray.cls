"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'External.ExternalArray'
	instanceVariableNames: 'length'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.ExternalArray guid: (Core.GUID fromString: '{87b4c593-026e-11d3-9fd7-00a0cc3e4a32}')!

External.ExternalArray comment: '`ExternalArray` is an abstract class of `External.Structure` to represent contiguous heterogeneous arrays of external types, be they scalar of structured. Its various concrete subclasses can be used for external interfacing tasks, typically where C-style arrays are expected.

`StructureArray` is the most general of the subclasses in that it supports arbitrary element types (represented by other `Structure` classes), and can in fact perform the task of the other subclasses such as `UInt32Array`. The more specialized subclasses do, however, offer much greater efficiency where they are applicable. However, note the important difference that `StructureArray>>#at:` will typically return an instance of its element class that is a reference to (i.e. points at) the underlying external data in the array. Mutating the returned element will therefore update the the array in place. The specialised external arrays will usually marshal directly to an appropriate Smalltalk value for the array element, rather than return a reference. This means that mutating the returned value will not update the array, but rather to update the value one must send `#at:put:` back to the array to overwrite the external data at the same index.

Specialized subclasses are provided for most standard intrinsic types; signed and unsigned integers of 8, 16, 32-bits, and 64-bits, single and double precision floating point numbers, etc.

Note that for backwards compatibility `ExternalArray` itself can be used to represent arrays of unsigned 8-bit integers (i.e. bytes), however this is soft-deprecated. UInt8Array should be used in preference.

## Instance Variables:
  `length`		`<integer>` number of elements in the array.

'!

!External.ExternalArray categoriesForClass!External-Data-Structured! !

!External.ExternalArray methodsFor!

= comparand
	| size |
	self == comparand ifTrue: [^true].
	self species == comparand species ifFalse: [^false].
	size := self length.
	size = comparand size ifFalse: [^false].
	1 to: size do: [:i | (self uncheckedAt: i) = (comparand at: i) ifFalse: [^false]].
	^true!

allSatisfy: discriminator
	"Answer whether the <monadicValuable>, discriminator, evaluates to true for
	every element of the receiver."

	1 to: self length do: [:i | (discriminator value: (self uncheckedAt: i)) ifFalse: [^false]].
	^true!

anySatisfy: discriminator
	"Answer whether the <monadicValuable>, discriminator, evaluates to true for
	any element of the receiver.
	Implementation Note: The argument is evaluated for every element of the
	receiver iff it evaluates to false for every element."

	1 to: self size do: [:i | (discriminator value: (self uncheckedAt: i)) ifTrue: [^true]].
	^false!

appendToStream: puttableStream
	"Private - Append the receiver's elements to the argument, puttableStream.
	We can be able to do a fast block copy. Answer the receiver.
	Implementation note: Double dispatched from puttableStream>>nextPutAll:."

	puttableStream next: self byteSize putAll: bytes startingAt: 1!

asArray
	"Answer an <Array> containing the constituent elements of the receiver."

	| answer size |
	answer := Array new: (size := self length).
	self
		uncheckedFrom: 1
		to: size
		keysAndValuesDo: [:i :each | answer basicAt: i put: each].
	^answer!

asByteArray
	"Answer a <ByteArray> containing the constituent elements of the receiver."

	^bytes copyFrom: 1 to: self byteSize!

asOrderedCollection
	"Answer an <OrderedCollection> whose elements are those of the receiver
	The ordering is that of the #do: operation as implemented by the receiver,
	and the answer will normally be the same size as the receiver.
	Implementation Note: Although we might be able to perform this operation 
	faster for collections which keep a tally of their size (or can otherwise 
	access it without calculation) we must be careful NOT to provide a default 
	implementation which will cause a double enumeration for collections which must
	count their elements to determine their size, which may be very slow."

	| answer |
	answer := OrderedCollection new: self length.
	self do: [:elem | answer addLast: elem].
	^answer!

at: anInteger 
	"Answer the element of the receiver at the specified index.
	Raise an error if the index if out of bounds."

	(anInteger < 1 or: [anInteger > self length]) 
		ifTrue: [^self errorSubscriptBounds: anInteger].
	^self uncheckedAt: anInteger!

at: index ifAbsent: exceptionBlock 
	"Answer an <Object> which is the element of the receiver 
	at the specified index. If the index is out of bounds answer
	the result of evaluating the <niladicValuable> exceptionBlock."

	^(index > 0 and: [index <= self length]) 
		ifTrue: [self uncheckedAt: index]
		ifFalse: [exceptionBlock value]!

at: anInteger put: newValue
	"Set the element of the receiver at the specified index.
	Raise an error if the index is out of bounds."

	(anInteger < 1 or: [anInteger > self length]) ifTrue: [self errorSubscriptBounds: anInteger].
	^self uncheckedAt: anInteger put: newValue!

atAllPut: anObject
	"Replace all the elements of the receiver with the native representation of the <Object> argument.
	The behaviour is undefined if the argument cannot be represented as an element of the array - an error may be thrown, or an invalid element stored."

	1 to: self length do: [:i | self uncheckedAt: i put: anObject]!

basicAt: anInteger 
	"Private - Answer the element of the receiver at the specified index. Raise an error if the index if out of bounds."

	"Implementation Note: The receiver is not an indexable class, so we can override this message successfully, and we need to do so to create an object that behaves as if it is a ByteArray."

	(anInteger < 1 or: [anInteger > self length]) 
		ifTrue: [^self errorSubscriptBounds: anInteger].
	^self uncheckedAt: anInteger!

basicAt: indexInteger put: valueInteger
	"Private - Replace the receiver's indexed element at the argument, index, with the argument, value. Answer value."

	(indexInteger < 1 or: [indexInteger > self length])
		ifTrue: [self errorSubscriptBounds: indexInteger].
	^self uncheckedAt: indexInteger put: valueInteger!

basicLength: anInteger
	"Private - Set the length (in elements, not bytes) of the receiver."
	
	length := anInteger.
	^self!

basicUncheckedAt: anInteger 
	"Private - Answer an 8-bit unsigned <SmallInteger> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^bytes uint8AtOffset: anInteger - 1!

basicUncheckedAt: indexInteger put: valueInteger 
	"Private - Replace the value at the index specified by the `<integer>` 1st argument with value of the 2nd argument. The types of object acceptable as the 2nd argument vary by subclass, but at this base level `SmallInteger` values in the range 0..255 are expected (i.e. octets). No bounds checks are performed on the subscript. "

	^bytes uint8AtOffset: indexInteger - 1 put: valueInteger!

binarySearchFor: anObject using: searchBlock
	"Private - Answer the index at which anObject is located using a binary chop search based on searchBlock"

	^SequenceableCollection
		binarySearch: self
		for: anObject
		using: searchBlock!

byteSize
	"Answer the total size in bytes of this array. We assume the array is a contiguous block with no padding between elements."

	^self elementSize * self length!

collect: transformer
	"Evaluate the <monadicValuable> argument, transformer, for each of the receiver's elements
	in the order defined by the receiver's implementation of #do:. Answer a new collection like
	the receiver containing the values returned by transformer on each evaluation."

	"Implementation Note: We use the special instance creation method #copyLikeOfSize: because
	the transformation block may evaluate to objects which cannot be stored as elements of this
	type of array and therefore we must store them in an <Array>."

	| answer size |
	size := self length.
	answer := self copyingClass new: size.
	self
		uncheckedFrom: 1
		to: size
		keysAndValuesDo: [:i :each | answer at: i put: (transformer value: each)].
	^answer!

copyFrom: startInteger to: stopInteger
	"Answer an object of the same species as the receiver containing a copy of the elements of the receiver starting at index start, until index stop, inclusive."

	| len |
	len := stopInteger - startInteger + 1.
	^(self copyingClass new: len)
		replaceFrom: 1
		to: len
		with: self
		startingAt: startInteger!

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	^Array!

detect: discriminator
	"Evaluate the <monadicValuable> argument, discriminator, for each of the receiver's elements
	in the order defined by the receiver's implementation of #do:.
	Answer the first element for which discriminator evaluates to true. If none evaluates to true,
	report an error."

	^self detect: discriminator ifNone: [self errorNotFound: discriminator]!

detect: discriminator ifNone: exceptionHandler
	"Evaluate the <monadicValuable> argument, discriminator, for each of the receiver's 
	elements.  Answer the first element (in the #do: order) for which discriminator evaluates 
	to true. If none evaluates to true answer the result of evaluating the <niladicValuable> 
	argument, exceptionHandler.
	Implementation Note: It is important for Shared subclasses that the exceptionHandler is 
	not evaluated inside the enumeration in case it is a niladic block containing an explicit 
	return (we try to avoid explicit returns from critical sections, as these require an unwind)."

	self do: [:each | (discriminator value: each) ifTrue: [^each]].
	^exceptionHandler value!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPut: $(.
	self isNull
		ifFalse: 
			[| listSep |
			listSep := aPuttableStream locale listSeparator.
			self do: [:element | element displayOn: aPuttableStream]
				separatedBy: 
					[aPuttableStream
						nextPutAll: listSep;
						space]].
	aPuttableStream nextPut: $)!

do: operation
	"Evaluate monadic value argument, operation, for each of the elements of the 
	receiver. Answers the receiver. The elements are evaluated in index order.
	Implementation Note: Implemented in terms of keysAndValuesDo: to reduce
	the burden of subclassing. Where performance is an issue subclasses may 
	want to override this."

	self keysAndValuesDo: [:i :elem | operation value: elem]!

do: aMonadicValuable separatedBy: aNiladicValuable
	"Evaluate the <monadicValuable> first argument for each of the receiver's elements, interspersed with evaluations of the <niladicValuable> second argument. The separator argument is first evaluated after the first element, and is not evaluated after the last element (i.e. it is not evaluated at all if there are less than two elements)."

	| count |
	(count := self length) == 0 ifTrue: [^self].
	aMonadicValuable value: (self uncheckedAt: 1).
	2 to: count
		do: 
			[:i |
			aNiladicValuable value.
			aMonadicValuable value: (self uncheckedAt: i)]!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^self class elementClass!

elementSize
	"Private - Answer the size of the receiver's instances' constituent 
	elements in bytes."

	^self elementClass elementSize!

encodeAsBytesOn: aWriteStream from: startInteger count: sizeInteger
	"Private - Encode <integer>, sizeInteger, bytes of the receiver starting with that at <integer>, startInteger, onto the <WriteStream>, aWriteStream. The stream is known to be streaming out bytes, which is of course the receiver's native encoding too."

	aWriteStream
		basicNext: sizeInteger
		putAll: self
		startingAt: startInteger!

encoding
	^#binary!

first
	^self at: 1!

fourth
	^self at: 4!

from: start do: operation
	"Evaluate the <monadicValuable>, operation, for each element of the receiver
	from start, inclusive."

	self 
		from: start
		keysAndValuesDo: [:i :each | operation value: each]!

from: start keysAndValuesDo: operation 
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	from the element with <integer> index, start, inclusive. A BoundsError will be
	raised if either start or stop is out of bounds."

	self 
		from: start
		to: self length
		keysAndValuesDo: operation!

from: startInteger to: stopInteger keysAndValuesDo: operation 
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	between the <integer> indices, start and stop, inclusive with the element and its
	index as respectively the second and first arguments."

	"Implementation Note: Do the bounds check up front to avoid the need to check
	on each access."

	startInteger < 1 ifTrue: [self errorSubscriptBounds: startInteger].
	stopInteger > self length ifTrue: [self errorSubscriptBounds: stopInteger].
	self 
		uncheckedFrom: startInteger
		to: stopInteger
		keysAndValuesDo: operation!

hash
	"Answer the <integer> hash value for the receiver."

	"Implementation Note: This is a copy of the (not terribly good) hash function of SequenceableCollection, because ExternalArrays should compare equal to Arrays of equivalent values."

	| size |
	(size := self length) == 0 ifTrue: [^17171].
	^size + (self at: 1) hash + (self at: size) hash!

includes: target
	"Answer whether the argument, target, is one of the elements of the receiver.
	Implementation Note: Override superclass to revert to element search."

	1 to: self length do: [:i | target = (self at: i) ifTrue: [^true]].
	^false!

includesKey: anInteger
	^anInteger between: 1 and: self length!

initializePointer
	length := 0!

inject: initialValue into: operation
	"Evaluate the <dyadicValuable> argument, operation, once for each element in the receiver, with
	that element as the second argument; and with the first argument as the value of the previous 
	evaluation, starting with the <Object> argument, initialValue. The operation must answer the value
	it wishes to have passed as its first argument the next time it is evaluated. The traversal is in the #do: 
	order. Answer the final value of the operation.
	This enumeration is particularly useful for performing summations and other statistical operations."

	| nextValue |
	nextValue := initialValue.
	self do: [:each | nextValue := operation value: nextValue value: each].
	^nextValue!

isEmpty
	"Answer whether the receiver contains no elements."

	^self length == 0
!

isSelfEvaluating
	^self notNull!

keys
	"Answer a <collection> containing the receiver's keys."

	^1 to: self length!

keysAndValuesDo: operation 
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	with the index of that element and the element itself as the arguments.
	Implementation Note: Subclasses should override #from:to:keysAndValuesDo: rather 
	than this method, unless they have a slow implementation of #size."

	self 
		uncheckedFrom: 1
		to: self length
		keysAndValuesDo: operation!

last
	^self at: self length!

length
	"Answer the number of elements in the receiver."

	^length!

length: anInteger
	"Set the length (in elements, not bytes) of the receiver, resizing the
	bytes of the receiver to accommodate the new length.
	This is not private as it can be used to adjust the length of 
	pointer instances after creation."
	
	self basicLength: anInteger.
	self bytes resize: self byteSize!

lookup: keyInteger
	"Answer the value named by the <Integer> argument, keyInteger, or nil if there is no such key in the receiver."

	^(keyInteger > 0 and: [keyInteger <= self length]) ifTrue: [self uncheckedAt: keyInteger]!

maxEncoding
	^1!

notEmpty
	"Answer whether the receiver contains any elements."

	^self isEmpty not!

packing
	"Private - Answer the number of bytes between individual elements of the receiver.
	This is the receiver's elementSize plus any padding necessary."

	^self elementSize!

replaceBytesOf: aByteObject from: start to: stop startingAt: fromStart
	"Private - Standard method for transfering bytes from one variable
	byte object to another, normally double dispatched from #replaceFrom:to:with:startingAt:"

	^bytes replaceBytesOf: aByteObject from: start to: stop startingAt: fromStart-1*self elementSize+1!

replaceElementsOf: anIndexableObject from: startInteger to: stopInteger startingAt: startAtInteger
	"Private - Replace the indexable instance variables of the variable pointer object,
	anIndexableObject, between startInteger and stopInteger inclusive with values from the
	receiver starting from startAtInteger. Answers anIndexableObject."

	| count offset stop |
	count := stopInteger - startInteger + 1.
	count <= 0 ifTrue: [^anIndexableObject].
	startAtInteger < 1 ifTrue: [self errorSubscriptBounds: startAtInteger].
	(stop := startAtInteger + count - 1) > self length
		ifTrue: [self errorSubscriptBounds: self length + 1].
	offset := startInteger - startAtInteger.
	self
		uncheckedFrom: startAtInteger
		to: stop
		keysAndValuesDo: [:i :each | anIndexableObject basicAt: offset + i put: each].
	^anIndexableObject!

replaceFrom: startInteger to: stopInteger with: aByteObject startingAt: startAtInteger 
	"Standard method for transfering bytes from one variable
	byte object to another. See String>>replaceFrom:to:with:startingAt:"

	| elemSize offset |
	elemSize := self elementSize.
	offset := (startInteger - 1) * elemSize.
	aByteObject 
		replaceBytesOf: self bytes
		from: 1 + offset
		to: stopInteger * elemSize
		startingAt: startAtInteger!

requiresFinalization
	"Answer may hold external resources that need to be freed. Unknowned structures requiring finalization are marked as finalizable."

	^self elementClass requiresFinalization!

second
	^self at: 2!

select: discriminator
	"Evaluate the <monadicValuable> argument, discriminator, for each of the receiver's elements.
	Answer a new <collection> like the receiver containing only those elements for which 
	the discriminator evaluates to true."

	| aStream |
	aStream := self copyingClass writeStream.
	self keysAndValuesDo: [:i :elem | (discriminator value: elem) ifTrue: [aStream nextPut: elem]].
	^aStream contents!

single
	self length == 1 ifFalse: [self errorNotSingleton].
	^self uncheckedAt: 1!

size
	"Answer the number of elements in the receiver."
	
	^self length!

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class (although this implementation uses the class primitive, which should not fail). Normally used when comparing two objects to determine if they are of the comparable types."

	^Array!

uncheckedAt: anInteger
	"Private - Answer an 8-bit unsigned <SmallInteger> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^self basicUncheckedAt: anInteger!

uncheckedAt: indexInteger put: anObject
	"Private - Replace the value at the index specified by the `<integer>` 1st argument with value of the 2nd argument. The types of object acceptable as the 2nd argument vary by subclass, but at this base level `SmallInteger` values in the range 0..255 are expected (i.e. octets). No bounds checks are performed on the subscript. "

	self basicUncheckedAt: indexInteger put: anObject.
	^anObject!

uncheckedFrom: startInteger to: stopInteger keysAndValuesDo: operation 
	"Private - Evaluate the <dyadicValuable>, operation, for each element of the receiver
	between the <integer> indices, start and stop, inclusive with the element and its
	index as respectively the second and first arguments. No bounds checking is
	performed. "

	"Subclasses should override this method in order to replace all #do: family enumerators 
	(#do:, #keysAndValuesDo:, #from:to:do:, and,	of course, #from:to:keysAndValuesDo:)."

	startInteger to: stopInteger do: [:i | operation value: i value: (self uncheckedAt: i)]!

value
	^self collect: [:each | each value]!

with: aCollection do: aDyadicValuable
	"Evaluate the <dyadicValuable> argument with each of the receiver's element values along with the corresponding element from the <collection> argument, aCollection. The collection is enumerated in its #do: order."

	self length = aCollection size ifFalse: [^self error: 'collections are of different sizes'].
	self keysAndValuesDo: [:i :elem | aDyadicValuable value: elem value: (aCollection at: i)]! !

!External.ExternalArray categoriesForMethods!
=!comparing!public! !
allSatisfy:!enumerating!public! !
anySatisfy:!enumerating!public! !
appendToStream:!double dispatch!private! !
asArray!converting!public! !
asByteArray!converting!public! !
asOrderedCollection!converting!public! !
at:!accessing!public! !
at:ifAbsent:!accessing!public! !
at:put:!accessing!public! !
atAllPut:!accessing!public! !
basicAt:!accessing!private! !
basicAt:put:!accessing!private! !
basicLength:!initializing!private! !
basicUncheckedAt:!accessing!private! !
basicUncheckedAt:put:!accessing!private! !
binarySearchFor:using:!public!searching! !
byteSize!accessing!public! !
collect:!enumerating!public! !
copyFrom:to:!copying!public! !
copyingClass!copying!private! !
detect:!public!searching! !
detect:ifNone:!public!searching! !
displayOn:!printing!private! !
do:!enumerating!public! !
do:separatedBy:!enumerating!public! !
elementClass!constants!public! !
elementSize!instance creation!private! !
encodeAsBytesOn:from:count:!double dispatch!encode/decode!private! !
encoding!constants!public! !
first!accessing!public! !
fourth!accessing!public! !
from:do:!enumerating!public! !
from:keysAndValuesDo:!enumerating!public! !
from:to:keysAndValuesDo:!enumerating!public! !
hash!comparing!public! !
includes:!public!searching! !
includesKey:!public!testing! !
initializePointer!initializing!public! !
inject:into:!enumerating!public! !
isEmpty!public!testing! !
isSelfEvaluating!public!testing! !
keys!accessing!public! !
keysAndValuesDo:!enumerating!public! !
last!accessing!public! !
length!accessing!public! !
length:!accessing!public! !
lookup:!accessing!public! !
maxEncoding!constants!public! !
notEmpty!public!testing! !
packing!constants!private! !
replaceBytesOf:from:to:startingAt:!double dispatch!private! !
replaceElementsOf:from:to:startingAt:!private!replacing! !
replaceFrom:to:with:startingAt:!public!replacing! !
requiresFinalization!public!realizing/unrealizing!testing! !
second!accessing!public! !
select:!enumerating!public! !
single!accessing!public! !
size!accessing!public! !
species!constants!public! !
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
uncheckedFrom:to:keysAndValuesDo:!enumerating!private! !
value!accessing!public! !
with:do:!enumerating!public! !
!

!External.ExternalArray class methodsFor!

alignment
	"Answer the alignment required for instances of the receiver when embedded in arrays or
	other structures. This is the alignment of the elements of the array in most cases."

	^self elementSize!

clear: addressOrBytes
	"Finalize an instance of the structure which instances of the receiver wrap which resides at the specified address. Note that this is not about freeing the specified memory block, but any resources which it references."

	"In general we need to know the number of elements to enumerate in order to be able to clear the array, so cannot implement this."
	self shouldNotImplement!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^UInt8!

elementSize
	"Private - Answer the size of the receiver's instances' constituent 
	elements in bytes."

	^self elementClass elementSize!

fromAddress: anAddress length: anInteger
	"Answer a new instance of the receiver that points at an array of anInteger elements of type elementClass at anAddress."

	"Note:
		- If the length is zero, then we ignore the address (even if invalid). 
		- If the length is non-zero then we answer nil if the address is the Null pointer.
		- It is assumed that the new instance will not own the underlying data at anAddress. Passing the address itself as the owner suppresses any finalization that the instance might otherwise perform if it owned the data."

	^self fromAddress: anAddress owner: anAddress length: anInteger!

fromAddress: anAddress length: anInteger elementClass: elementClass
	"Answer a new instance of the receiver that points at an array of anInteger elements of type elementClass at anAddress."

	^self fromAddress: anAddress owner: anAddress length: anInteger elementClass: elementClass!

fromAddress: anAddress owner: anObject
	"The receiver needs to know how long the array is to avoid reading or writing off its end."

	^self shouldNotImplement !

fromAddress: anAddress owner: anObject length: anInteger
	"Answer a new instance of the receiver that points at an
	array of anInteger elements of type elementClass at anAddress.
	Implementation Note: If the length is zero, then we ignore the address (even if invalid).
	If the length is non-zero then we answer nil if the address is the Null pointer."

	^anAddress isNull
		ifFalse: 
			[self basicNew
				initializeAtAddress: anAddress owner: anObject;
				basicLength: anInteger]!

fromAddress: anAddress owner: anObject length: anInteger elementClass: elementClass
	"Answer a new instance of the receiver that points at an
	array of anInteger elements of type elementClass at anAddress.
	Implementation Note: If the length is zero, then we ignore the address (even if invalid).
	If the length is non-zero then we answer nil if the address is the Null pointer."

	elementClass == self elementClass ifFalse: [self error: 'Mismatched element class: <1p>' << elementClass].
	^self fromAddress: anAddress owner: anObject length: anInteger!

getFieldNames
	^#()!

length: countInteger elementSize: sizeInteger bufferClass: bufferClass
	"Private - Answer a new instance of the receiver allocated with space for countInteger elements of sizeInteger bytes."

	^(self basicNew initializeBuffer: bufferClass size: countInteger * sizeInteger) basicLength: countInteger!

marshal: aCollection
	aCollection class == self ifTrue: [^aCollection].
	^self withAll: aCollection!

new: anInteger bufferClass: bufferClass
	"Answer a new instance of the receiver allocated at an immovable location."

	^self
		length: anInteger
		elementSize: self elementSize
		bufferClass: bufferClass!

new: elementCount withAll: elementValue
	"Answer a new instance of the receiver with <integer>, anInteger, elements, each of which is initialized to the <Object>, anObject."

	^(self new: elementCount)
		atAllPut: elementValue;
		yourself!

newBuffer
	^self new: 0 bufferClass: self bufferClass!

with: element1
	"Answer a new instance of the receiver containing the single 
	<Object> element, element1."

	^(self new: 1)
		uncheckedAt: 1 put: element1;
		yourself!

withAll: newElements
	"Answer a new instance of the receiver containing all of the elements of the <collection> newElements.
	An error will be raised if any of the elements of newElements cannot be stored in instances of the receiver."

	^self withAll: newElements bufferClass: self bufferClass!

withAll: newElements bufferClass: bufferClass
	"Answer a new instance of the receiver containing all of the 
	elements of the <collection> newElements.
	An error will be raised if any of the elements of newElements
	cannot be stored in instances of the receiver."

	| answer |
	answer := self new: newElements size bufferClass: bufferClass.
	newElements inject: 1
		into: 
			[:i :elem |
			answer uncheckedAt: i put: elem.
			i + 1].
	^answer!

withBytes: aByteArray 
	| count |
	count := aByteArray size / self elementSize.
	count isInteger ifFalse: [self error: 'The buffer does not hold an integral number of elements of type ', self elementClass printString].
	^(super withBytes: aByteArray)
		basicLength: count! !

!External.ExternalArray class categoriesForMethods!
alignment!constants!public! !
clear:!public!realizing/unrealizing! !
elementClass!constants!public! !
elementSize!instance creation!private! !
fromAddress:length:!instance creation!public! !
fromAddress:length:elementClass:!instance creation!public! !
fromAddress:owner:!instance creation!public! !
fromAddress:owner:length:!instance creation!public! !
fromAddress:owner:length:elementClass:!instance creation!public! !
getFieldNames!constants!private! !
length:elementSize:bufferClass:!instance creation!private! !
marshal:!instance creation!public! !
new:bufferClass:!instance creation!public! !
new:withAll:!instance creation!public! !
newBuffer!instance creation!public! !
with:!instance creation!public! !
withAll:!instance creation!public! !
withAll:bufferClass:!instance creation!public! !
withBytes:!instance creation!public! !
!

