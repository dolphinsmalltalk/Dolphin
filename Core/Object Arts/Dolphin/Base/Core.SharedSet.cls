"Filed out from Dolphin Smalltalk"!

Core.Set
	variableSubclass: #'Core.SharedSet'
	instanceVariableNames: 'mutex'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SharedSet guid: (Core.GUID fromString: '{87b4c528-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.SharedSet comment: 'SharedSet is a process safe subclass of <Set>, which has the same behavior. It''s instances make use of a <Mutex> (a mutual exclusion lock) to prevent more than one process from accessing their elements at the same time. Although process safe to the extent   that the invariants of the data structure are maintained, further synchronisation mechanisms will almost certainly be required if a <SharedSet> is used to buffer information between processes (e.g. see <SharedQueue>).

The following methods of Set are, or are not, overridden for the reasons given:

	add:		Overridden, public entry point
	addAll:		Implmented using #add:
	asArray		Overridden because must ensure size does not change between instantiating the 			new Array and the #do: loop.
	asByteArray	ditto
	asBag		Bags size affects capacity only, so not overridden.
	asOrderedCollection	ditto
	asSet		atomic (answers self)
	asSortedCollection	Size affects capacity only, so not overridden
	asSortedCollection:	ditto
	at:		Not permitted on sets
	at:put:		Ditto
	capacity		atomic
	collect:		Implemented in terms of #do:. Result will be a Set.
	copyElementsInto:	ditto
	do:		Overridden, public entry point
	findElementOrNil:	private, used only within methods protected by mutex (e.g. add:)
	find:ifAbsent:	Overidden, public entry point
	fixCollisionsFrom: 	ditto
	grow		ditto (sent only from maintainLoadFactor)
	identityIncludes:	Overridden, public entry point
	includes:		Overridden, public entry point
	initialize		overridden, but to instantiate the mutex, not for mutual exclusion
	isEmpty		uses #size, which is atomic
	moveFrom:to:	ditto
	occurrencesOf:	uses #includes: and otherwise accesses no shared data
	postResize:	private, used only within methods protected by mutex
	preResize:		ditto
	privateAt:put:	ditto
	rehash		uses #resize:, and otherwise accesses no shared data
	relocateElement:from: 	private, used only within methods protected by mutex
	remove:ifAbsent:	Overridden, public entry point
	removeIndex:	private, used only within methods protected by mutex
	resize:		Overridden, public entry point
	shrink		Overridden, public entry point
	size		atomic
	tally		atomic
	uncheckedAdd:	private, used only within methods protected by mutex

Instance Variables:
	mutex		<Mutex> for ensuring mutually exclusive access to the collection.

Class Variables:
	AbsentCookie	<Object>. Unique cookie used internally to signal element absence.

'!
!Core.SharedSet categoriesForClass!Collections-Unordered! !
!Core.SharedSet methodsFor!

add: newObject
	"Include newObject as one of the elements of the receiver. Answer newObject."

	^mutex critical: [super add: newObject]!

addAll: newElements
	"Include all the elements of the <collection> argument, newElements, as the receiver's elements. 
	Answer newElements. 
	Implementation Note: Override to avoid overhead of acquiring mutex for each addition."

	mutex critical: [newElements do: [:each | super add: each]].
	^newElements!

allSatisfy: aMonadicValuable
	"Answer whether the <monadicValuable> argument evaluates to true for every element of the receiver."

	^mutex critical: [super allSatisfy: aMonadicValuable]!

asArray
	"Answer an Array whose elements are those of the receiver (ordering is possibly arbitrary).
	Must implement as critical section as otherwise Array size might be wrong."

	^mutex critical: [super asArray]!

asByteArray
	"Answer a ByteArray whose elements are those of the receiver (ordering is possibly arbitrary).
	Must implement as critical section as otherwise the ByteArray size might be wrong."

	^mutex critical: [super asByteArray]!

do: operation
	"Evaluate monadic value argument, operation, for each of the elements (non-nil members) 
	of the receiver. Answers the receiver.
	N.B. It is important that operation does not put the active process to sleep (i.e.
	wait on some Semaphore) as this will prevent other Smalltalk processes from accessing
	the receiver for a potentially long time, and if a weak subclass, may prevent the
	removal of Corpses from taking place. In the case of weak subclasses, if the putting the
	active process to sleep is unavoidable, then the weak status should be removed until
	the end of the critical block (e.g. send #beStrong at the start of the block, and
	#beWeakWithNotify at the end of the block)."

	mutex critical: [super do: operation]!

find: target ifAbsent: exceptionHandler
	"Answer the actual element of the receiver which matches (however 'match' is defined)
	the argument, target. If there is no such element, then the result of evaluating the
	niladic valuable, exceptionHandler, is answered."

	| answer |
	answer := mutex critical: [super find: target ifAbsent: AbsentCookie].
	^answer == AbsentCookie ifTrue: [exceptionHandler value] ifFalse: [answer]!

identityIncludes: target
	"Answer whether the <Object> argument, target, is one of the receiver's elements."

	^mutex critical: [super identityIncludes: target]!

includes: target
	"Answer whether the argument, target, is equal to one of the elements of the receiver."

	^mutex critical: [super includes: target]!

initialize
	"Instance variable initialization. The mutex protects against concurrent access from multiple
	processes, but permits the same process to make multiple entries."

	super initialize.
	mutex := Mutex new!

mutex
	"Private - Answer the receiver's mutual exclusion object"
	
	^mutex!

mutex: aMutex
	"Private - Set the receiver's mutual exclusion object to the argument, aMutex"

	mutex := aMutex!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original, apart from the elements. Answer the receiver. In
	the case of a SharedSet we need a new mutex."

	super postCopy.
	mutex := Mutex new.
	^self!

preResize: newMe
	"This message is sent by the receiver when resizing, before the receiver's elements are added to newMe. 
	We must assign across the mutex so that process synchronisation is correctly preserved."

	newMe mutex: mutex!

printOn: aStream
	"Print a string representation of the receiver on aStream."

	mutex critical: [super printOn: aStream]!

remove: oldElement ifAbsent: exceptionHandler
	"If oldElement is one of the receiver's elements, then remove it from the 
	receiver and answer it (as Sets cannot contain duplicates, only one element is
	ever removed). If oldElement is not an element of the receiver (i.e.
	no element of the receiver is #= to oldObject) then answer the 
	result of evaluating the niladic valuable, exceptionHandler."

	| answer |
	answer := mutex critical: [super remove: oldElement ifAbsent: AbsentCookie].
	^answer == AbsentCookie ifTrue: [exceptionHandler value] ifFalse: [answer]!

resize: anInteger
	"Private - Resize the receiver to have a capacity suitable for accommodating
	at least anInteger elements."

	mutex critical: [super resize: anInteger]!

shrink
	"Rebuild the collection with the optimal size for its current number of elements,
	as #rehash, but doesn't resize if already correct size."

	mutex critical: [super shrink]! !
!Core.SharedSet categoriesForMethods!
add:!adding!public! !
addAll:!adding!public! !
allSatisfy:!enumerating!public! !
asArray!converting!public! !
asByteArray!converting!public! !
do:!enumerating!public! !
find:ifAbsent:!public!searching! !
identityIncludes:!public!searching! !
includes:!public!searching! !
initialize!initializing!public! !
mutex!accessing!private! !
mutex:!initializing!private! !
postCopy!copying!public! !
preResize:!adding!public! !
printOn:!printing!public! !
remove:ifAbsent:!public!removing! !
resize:!mutating!private! !
shrink!mutating!public! !
!

