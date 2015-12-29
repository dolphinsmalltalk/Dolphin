"Filed out from Dolphin Smalltalk 2000 release 5.00"!

ValueKeyedAdaptor subclass: #IndexedInstVarAccessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IndexedInstVarAccessor guid: (GUID fromString: '{A40B8A81-1EE9-4C09-87C9-BA024D5DE662}')!
IndexedInstVarAccessor comment: ''!
!IndexedInstVarAccessor categoriesForClass!MVP-Models! !
!IndexedInstVarAccessor methodsFor!

canSet
	"Private - Answer whether the receiver can be set using #value:."

	^super canSet and: [self key ~= 0]!

subject: anObject key: aKey
	"Private - Sets the subject object and the key being used to access an element of it"

	super subject: anObject key: aKey.
	getSelector := #basicAt:.
	putSelector := #basicAt:put:.

!

value
	"Answers the <Object> value of the receiver, obtained by
	sending a message to the receiver's subject with the key."
	
	^self key=0 ifTrue: [self subject] ifFalse: [super value].	
! !
!IndexedInstVarAccessor categoriesFor: #canSet!private!testing! !
!IndexedInstVarAccessor categoriesFor: #subject:key:!initializing!private! !
!IndexedInstVarAccessor categoriesFor: #value!accessing!public! !

