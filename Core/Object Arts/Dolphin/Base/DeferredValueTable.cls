"Filed out from Dolphin Smalltalk"!

SharedLookupTable variableSubclass: #DeferredValueTable
	instanceVariableNames: 'priority'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DeferredValueTable guid: (GUID fromString: '{2acf1f74-b319-4eed-8755-3bcc738462c0}')!
DeferredValueTable comment: 'A DeferredValueTable is a <LookupTable> specialised to hold <DeferredValue>s. '!
!DeferredValueTable categoriesForClass!Unclassified! !
!DeferredValueTable methodsFor!

at: key ifAbsent: exceptionHandler
	"Answer the value named by the argument, key.  If key is not found,
	answer the result of evaluating the niladic valuable, exceptionHandler."

	^(super at: key ifAbsent: [exceptionHandler]) value!

at: key ifAbsentPut: exceptionHandler
	"Answer the value named by the argument, key.  If key is not found,
	then add and answer the result of evaluating the niladic valuable,
	exceptionHandler."

	^(super at: key ifAbsentPut: [exceptionHandler deferredValueAt: priority]) value!

at: anObject put: aNiladicValuable 
	"Store the <niladicValuable> argument under the specified <Object> key
	in the receiver. The <niladicValuable> is expected to evaluate to the 
	eventual required value. Answer the <DeferredValue>."

	^super at: anObject put: (aNiladicValuable deferredValueAt: priority)!

do: operation
	"Evaluate monadic value argument, operation, for each of the elements (values) of the 
	receiver. Answers the receiver."

	#todo "Provide more efficient implementation".
	super keysAndValuesDo: [:k :v | operation value: v value]!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	priority := Processor activePriority!

keyAtEqualValue: value ifAbsent: exceptionHandler
	"Answer the name of the argument, value. If there is no such value, answer
	the result of evaluating the niladic valuable, exceptionHandler.
	Equality is used for comparison of the values (this increases the chances of 
	returning any duplicates the Dictionary might contain).
	Implementation Note: Optimized superclass implementation must be overridden
	back to one implemented in terms of keysAndValuesDo:"

	self keysAndValuesDo: [:k :v | value = v value ifTrue: [^k]].
	^exceptionHandler value!

keyAtValue: value ifAbsent: operation
	"Answer the <Object> key of the <Object> argument, value. 
	If there is no such value, answer the result of evaluating the 
	<niladicValuable>, operation. Identity is used for comparison of the values."

	self keysAndValuesDo: [:k :v | v value == value ifTrue: [^k]].
	^operation value!

keysAndValuesDo: operation
	"Evaluate the dyadic valuable, operation, for each key/value pair in the receiver,
	to the exclusion of other threads."

	super keysAndValuesDo: [:k :v | operation value: k value: v value]!

lookup: keyObject
	"Answer the value named by the <Object> argument, keyObject, or nil if there is no such key in the receiver."

	^(super lookup: keyObject) ifNotNil: [:deferredValue | deferredValue value]!

priority
	"Answer the <Process> priority at which the deferred values will be calculated."

	^priority!

priority: anInteger
	"Set the <Process> priority at which the deferred values will be calculated."

	priority := anInteger! !
!DeferredValueTable categoriesForMethods!
at:ifAbsent:!accessing!public! !
at:ifAbsentPut:!accessing!public! !
at:put:!accessing!public! !
do:!enumerating!public! !
initialize!initializing!private! !
keyAtEqualValue:ifAbsent:!accessing!public! !
keyAtValue:ifAbsent:!accessing!public! !
keysAndValuesDo:!enumerating!public! !
lookup:!accessing!public! !
priority!accessing!public! !
priority:!accessing!public! !
!

