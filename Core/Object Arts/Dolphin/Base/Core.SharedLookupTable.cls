"Filed out from Dolphin Smalltalk 7"!

Core.LookupTable variableSubclass: #'Core.SharedLookupTable'
	instanceVariableNames: 'mutex'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SharedLookupTable guid: (Core.GUID fromString: '{87b4c52f-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.SharedLookupTable comment: 'SharedLookupTable is the class of <LookupTable>s which permits only a single process to access its contents at any one time (it uses a <Mutex> object for this purpose). 

Instance Variables:
	mutex			<Mutex>. Protection lock to guard contents.

Class Variables:
	AbsentCookie		<Object>. Used to identity evaluation of exception handling block.

Certain methods are not overridden for the following reasons:

	add:			Immediate superclass implementation use #at:put:
	associationAt:		Implemented in terms of #assocationAt:ifAbsent:
	associationAt:ifAbsent:	Implemented in terms of #at:ifAbsent:
	associations		Implemented in terms of associationsDo:
	associationsDo:		Implemented in terms of keysAndValuesDo:
	at:			Implemented in terms of #at:ifAbsent:
	at:ifAbsent:		Overridden
	at:ifAbsentPut:		Overridden
	at:put:			ditto
	basicValues		atomic
	capacity			atomic
	collect:			Implemented in terms of #do:, result will be a LookupTable
	copyElementsInto:		private, uses only within critical sections
	copyEmpty		Implemented in terms of #copyEmpty:
	copyEmpty:		Private, used only within critical sections
	countElements		Implemented in terms of #do:
	detect:			Implemented in terms of #detect:ifNone:
	detect:ifNone:		Implemented in terms of #do:
	do:			Overridden, public entry point. Revokes weak status for duration of enumeration.
	emptyCheck		implemented in terms of #isEmpty
	errorNotFound, errorNotKeyed 	Don''t access shared data apart from print (uses do:)
	findElementOrNil:		private, used only within methods protected by mutex (e.g. add:)
	findKeyOrNil:		ditto
	fixCollisionsFrom: 		ditto
	grow			ditto (sent only from Set>>privateAt:put:)
	growSize			Private, used only within critical section (not used for Set''s?)
	identityIncludes:		Overridden
	includes:			Implemented in terms of #do:
	includesAssociation:		Overridden
	includesKey:		Overridden
	initialize			Overridden, but to instantiate the mutex, not for mutual exclusion
	inject:into:			Implemented in terms of do:
	inspect			Debug only
	intersection:		Implemented in terms of select:
	isEmpty			uses #size == 0, which is atomic
	keyAtEqualValue:ifAbsent:	Overridden
	keyAtValue:		Implemented in terms of keyAtValue:ifAbsent:
	keyAtValue:ifAbsent:		Overridden
	keysAndValuesDo:		Overridden. Revokes weak status for duration of enumeration.
	keysClass			Answers constant
	keys			Implemented in terms of #do:
	keysDo:			Implemented in terms of #keysAndValuesDo:
	lookupKey:		For private use of compiler
	maxPrint			Atomic
	moveFrom:to:		Private, used only within critical sections
	occurrencesOf:		Implemented in terms of #do
	printOn:			Overridden
	postResize:		private, used only within methods protected by mutex
	preResize:			ditto, but must override to maintain mutex
	privateAt:put:		private, used only within critical sections
	rehash			uses #resize:, and otherwise accesses no shared data
	reject:			Implemented in terms of #select:
	relocateElement:from:	private, used only within methods protected by mutex
	remove:			Not valid for dictionaries
	remove:ifAbsent:		ditto
	removeAssociation:		Implemented in terms of removeKey:
	removeIndex:		private, used only within methods protected by mutex
	removeKey:		Implemented in terms of removeKey:ifAbsent:
	removeKey:ifAbsent:		Overridden
	resize:			Overridden, public entry point
	shrink			Overridden, public entry point
	select:			Implemented in terms of keysAndValuesDo:
	size			atomic
	storeOn:			Overridden
	tally			atomic
	uncheckedAdd:		Not used by dictionaries.
	uncheckedAt:put:		Private, used only within critical sections
	values			Implemented in terms of #do:
	valuesClass	`	Answers constant'!
!Core.SharedLookupTable categoriesForClass!Collections-Unordered! !
!Core.SharedLookupTable methodsFor!

anySatisfy: aMonadicValuable
	"Answer whether the <monadicValuable> argument evaluates to true for any element of the receiver."

	self do: [:e | (aMonadicValuable value: e) ifTrue: [^true]].
	^false!

asArray
	"Answer an Array whose elements are those of the receiver (ordering is possibly arbitrary).
	Must implement as critical section as otherwise Array size might be wrong."

	^mutex critical: [super asArray]!

asByteArray
	"Answer a ByteArray whose elements are those of the receiver (ordering is possibly arbitrary).
	Must implement as critical section as otherwise the ByteArray size might be wrong."

	^mutex critical: [super asByteArray]!

at: key ifAbsent: exceptionHandler
	"Answer the value named by the argument, key.  If key is not found,
	answer the result of evaluating the niladic valuable, exceptionHandler.
	Implementation Note: We avoid evaluating the exceptionHandler valuable
	inside the mutex to minimize the chances of throwing an exception
	with the mutex locked (#critical:'s ensure block would handle the case
	where the exceptionHandler performs a far return), HOWEVER this does
	mean it is not entirely safe to add a new item in the ifAbsent handler
	(#at:ifAbsentPut: should be used in this case)."

	| answer |
	answer := mutex critical: [super at: key ifAbsent: [AbsentCookie]].
	^answer == AbsentCookie
		ifTrue: [exceptionHandler value]
		ifFalse: [answer]!

at: key ifAbsentPut: exceptionHandler
	"Answer the value named by the argument, key.  If key is not found,
	then add and answer the result of evaluating the niladic valuable,
	exceptionHandler.
	Implementation Note: If exceptionHandler is a block, it should not include 
	an explicit return (if it does then no value will be inserted).
	Note also that in this case we evaluate the exception handler within
	the mutex so that the particular key remains absent!!"

	^mutex critical: [super at: key ifAbsentPut: exceptionHandler]!

at: key ifAbsentPutClean: exceptionHandler
	"Answer the value of the receiver keyed by the first <Object> argument. If key is not one of the receiver's keys, then add the result of evaluating  the <niladicValuable> 2nd argument and answer that result.
	Note that unlike #at:ifAbsentPut:, this method assumes that the valuable does not modify the receiver, and therefore it only looks up the key position once. Thus it is more efficient but less general purpose."

	^mutex critical: [super at: key ifAbsentPutClean: exceptionHandler]!

at: key ifAbsentPutValue: valueObject
	"Answer the value of the receiver keyed by the <Object> argument, keyObject.
	If keyObject is not one of the receiver's keys, then add the <Object>, valueObject,
	at keyObject, and answer valueObject."

	^mutex critical: [super at: key ifAbsentPutValue: valueObject]!

at: key put: newElement
	"Store the argument, newElement, with the external key, key,
	in the receiver. Answer newElement."

	key isNil ifTrue: [^self error: 'key cannot be nil'].
	^mutex critical: [super at: key put: newElement]!

changeKey: key to: newKey
	"Private - Change the key of the element of the receiver with key, key, to
	newKey (e.g. rename a variable). Answer the value of the element
	whose key was changed"

	^mutex critical: [super changeKey: key to: newKey]!

do: operation
	"Evaluate monadic value argument, operation, for each of the elements (values) of the 
	receiver. Answers the receiver.
	If aBlock contains an explicit return, then the mutex will be unlocked by the #ensure:
	block in #critical:."

	mutex critical: [super do: operation]
!

identityIncludes: comperand
	"Answer whether the <Object> argument, comperand, is one of the receiver's elements."

	^mutex critical: [super identityIncludes: comperand]!

includesAssociation: anAssociation
	"Answer whether the receiver contains the key/value pair in anAssociation"

	^mutex critical: [super includesAssociation: anAssociation]!

includesKey: key
	"Answer whether the receiver contains the specified key."

	^mutex critical: [super includesKey: key]!

initialize
	"Private - Initialize the state of the receiver."

	mutex := Mutex new.
	super initialize!

keyAtEqualValue: value ifAbsent: exceptionHandler
	"Answer the name of the argument, value. If there is no such value, answer
	the result of evaluating the niladic valuable, exceptionHandler.
	Equality is used for comparison of the values (this increases the chances of 
	returning any duplicates the Dictionary might contain).
	Implementation Note: We avoid evaluating the exceptionHandler valuable
	inside the mutex to minimize the chances of throwing an exception
	with the mutex locked (#critical:'s ensure block would handle the case
	where the exceptionHandler performs a far return)."

	| answer |
	answer := mutex critical: [super keyAtEqualValue: value ifAbsent: [AbsentCookie]].
	^answer == AbsentCookie
		ifTrue: [exceptionHandler value]
		ifFalse: [answer]!

keyAtValue: value ifAbsent: exceptionHandler
	"Answer the key of the first value in the receiver identical
	to the argument, value. If the receiver contains no such element,
	answer the result of evaluating the monadic valuable, exceptionHandler.
	Implementation Note: We avoid evaluating the exceptionHandler valuable
	inside the mutex to minimize the chances of throwing an exception
	with the mutex locked (#critical:'s ensure block would handle the case
	where the exceptionHandler performs a far return)."

	| answer |
	answer := mutex critical: [super keyAtValue: value ifAbsent: [AbsentCookie]].
	^answer == AbsentCookie
		ifTrue: [exceptionHandler value]
		ifFalse: [answer]!

keysAndValuesDo: operation
	"Evaluate the dyadic valuable, operation, for each key/value pair in the receiver,
	to the exclusion of other threads."

	mutex critical: [super keysAndValuesDo: operation]!

keysDo: operation 
	"Evaluate the <monadicValuable>, operation, for each of the receiver's keys, to the exclusion of other threads."

	mutex critical: [super keysDo: operation]!

lookup: keyObject
	"Answer the value named by the <Object> argument, keyObject, or nil if there is no such key in the receiver.
	Clearly if the receiver can contain nil values then it will not be possible to distinguish between the absence
	of the key and the key being associated with a nil value. However, this method expresses the
	very common pattern of passing an empty block as absent handler to #at:ifAbsent:, i.e. as in this 
	default implementation."

	^mutex critical: [super lookup: keyObject]!

mutex
	"Private - Answer the receiver's mutual exclusion object"

	^mutex!

mutex: aMutex
	"Private - Set the receiver's mutual exclusion object to the argument, aMutex"

	mutex := aMutex !

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original, apart from the elements. Answer the receiver. In
	the case of a SharedLookupTable we need a new mutex."

	super postCopy.
	mutex := Mutex new.
	^self!

preResize: newMe
	"This message is sent by the receiver when resizing, before the
	receiver's elements are added to newMe. We must assign across the
	mutex so that process synchronisation is correctly preserved."

	newMe mutex: mutex!

printOn: aStream
	"Print a string representation of self on aStream."

	mutex critical: [super printOn: aStream]!

removeAllKeys: keys
	^mutex critical: [super removeAllKeys: keys]!

removeKey: key ifAbsent: exceptionHandler
	"Remove the key (and its associated value), from the receiver. If key is
	not in the receiver, answer the result of evaluating the niladic valuable
	exceptionHandler. Otherwise, answer the value named by key.
	Implementation Note: Avoid evaluating the exceptionHandler valuable
	inside the mutex to minimize the chances of throwing an exception
	with the mutex locked (#critical:'s ensure block would handle the case
	where the exceptionHandler performs a far return)."

	| answer |
	answer:= mutex critical: [super removeKey: key ifAbsent: [AbsentCookie]].
	^answer == AbsentCookie
		ifTrue: [exceptionHandler value]
		ifFalse: [answer]!

resize: anInteger
	"Private - Resize the receiver to a capacity suitable for anInteger elements.
	We'll lose the mutex since this involves creating a new copy of the receiver
	and becoming it. Obviously we must restore the current mutex, or process
	synchronisation will be lost."

	mutex critical: [super resize: anInteger]!

shrink
	"Rebuild the collection with the optimal size for its current number of elements,
	as #rehash, but doesn't resize if already correct size."

	mutex critical: [super shrink]!

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler."

	mutex critical: [super stbSaveOn: anSTBOutFiler]! !
!Core.SharedLookupTable categoriesFor: #anySatisfy:!enumerating!public! !
!Core.SharedLookupTable categoriesFor: #asArray!converting!public! !
!Core.SharedLookupTable categoriesFor: #asByteArray!converting!public! !
!Core.SharedLookupTable categoriesFor: #at:ifAbsent:!accessing!public! !
!Core.SharedLookupTable categoriesFor: #at:ifAbsentPut:!accessing!public! !
!Core.SharedLookupTable categoriesFor: #at:ifAbsentPutClean:!accessing!public! !
!Core.SharedLookupTable categoriesFor: #at:ifAbsentPutValue:!accessing!public! !
!Core.SharedLookupTable categoriesFor: #at:put:!accessing!public! !
!Core.SharedLookupTable categoriesFor: #changeKey:to:!accessing!private! !
!Core.SharedLookupTable categoriesFor: #do:!enumerating!public! !
!Core.SharedLookupTable categoriesFor: #identityIncludes:!public!searching! !
!Core.SharedLookupTable categoriesFor: #includesAssociation:!public!searching! !
!Core.SharedLookupTable categoriesFor: #includesKey:!public!searching! !
!Core.SharedLookupTable categoriesFor: #initialize!initializing!private! !
!Core.SharedLookupTable categoriesFor: #keyAtEqualValue:ifAbsent:!accessing!public! !
!Core.SharedLookupTable categoriesFor: #keyAtValue:ifAbsent:!accessing!public! !
!Core.SharedLookupTable categoriesFor: #keysAndValuesDo:!enumerating!public! !
!Core.SharedLookupTable categoriesFor: #keysDo:!enumerating!public! !
!Core.SharedLookupTable categoriesFor: #lookup:!accessing!public! !
!Core.SharedLookupTable categoriesFor: #mutex!accessing!private! !
!Core.SharedLookupTable categoriesFor: #mutex:!initializing!private! !
!Core.SharedLookupTable categoriesFor: #postCopy!copying!public! !
!Core.SharedLookupTable categoriesFor: #preResize:!adding!public! !
!Core.SharedLookupTable categoriesFor: #printOn:!printing!public! !
!Core.SharedLookupTable categoriesFor: #removeAllKeys:!public!removing! !
!Core.SharedLookupTable categoriesFor: #removeKey:ifAbsent:!accessing!public! !
!Core.SharedLookupTable categoriesFor: #resize:!mutating!private! !
!Core.SharedLookupTable categoriesFor: #shrink!operations!public! !
!Core.SharedLookupTable categoriesFor: #stbSaveOn:!binary filing!public! !

