"Filed out from Dolphin Smalltalk 7"!

Stream subclass: #Random
	instanceVariableNames: 'seed'
	classVariableNames: 'Default DefaultGeneratorClass'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Random guid: (GUID fromString: '{87b4c6f9-026e-11d3-9fd7-00a0cc3e4a32}')!
Random isAbstract: true!
Random comment: 'Random is a subclass of <Stream> that determines its elements based on an algorithm employing a number as a seed. Random itself is abstract, but has various concrete subclasses that implement different pseudo-random number generation algorithms. Attempts to instantiate an instance of Random will answer an instance of the default generator, which is usually the Park & Miller multiplicative congruential generator. This is a good generator, but uses FP arithmetic and is therefore rather slower than the typical quick''n''dirty generator one finds in most C runtime libraries. 

Random provides a concrete implementation of #atEnd, but because the size of the collection is infinite, it never ends.

Instance Variables:
	seed		<Integer>. Random seed'!
!Random categoriesForClass!Collections-Streams! !
!Random methodsFor!

atEnd
	"Answer whether the Stream is at its end - never true for a Stream of Random numbers"

	^false
!

chiSquareTest: N max: r 
	"Private - Perform a chi-square test on N numbers in the range 0..r-1.
	e.g. 
		RandomLinearCongruential newANSIC chiSquareTest: 5000000 max: 100		
		RandomLinearCongruential newParkMiller chiSquareTest: 5000000 max: 100
		RandomCRT new chiSquareTest: 5000000 max: 100		

	It should yield a value in the range 80..120, the nearer to 100 the better."

	| f t |
	f := (1 to: r) collect: [:i | 0].
	N timesRepeat: 
			[| i |
			i := self next.
			i := (i * r) truncated.
			f basicAt: i + 1 put: (f basicAt: i + 1) + 1].
	t := 0.
	1 to: r do: [:i | t := t + (f basicAt: i) squared].
	^r asFloat * t / N - N!

isReadable
	"Answer whether the receiver can be read from (i.e. it implements the 
	gettableStream protocol)."

	^true!

next
	"Answer the next object accessible by the receiver."

	^self subclassResponsibility!

peek
	"Answer a pseudo-Random floating point number between 0 and 1 generated
	from the next seed, but do not advance down the stream (i.e. self peek = self peek)."

	^self subclassResponsibility!

seed
	"Answer the receiver's seed."

	^seed!

seed: aNumber
	"Set the seed of the Random stream to aNumber (or 1 if zero)."

	seed := aNumber max: 1!

skip: anInteger
	"Set the receiver's position reference to be the current position plus
	the argument, anInteger, possibly adjusting the result so as to remain
	within the bounds of the collection."

	anInteger < 0 ifTrue: [self error: 'Cannot move backwards in Random number stream'].
	anInteger timesRepeat: [self next]! !
!Random categoriesFor: #atEnd!public!testing! !
!Random categoriesFor: #chiSquareTest:max:!examples!private! !
!Random categoriesFor: #isReadable!public!testing! !
!Random categoriesFor: #next!accessing!public! !
!Random categoriesFor: #peek!accessing!public! !
!Random categoriesFor: #seed!accessing!public! !
!Random categoriesFor: #seed:!accessing!public! !
!Random categoriesFor: #skip:!positioning!public! !

!Random class methodsFor!

default
	"Answer the default <Random> generator."
	
	^Default ifNil: [Default := self new]!

defaultGeneratorClass
	^DefaultGeneratorClass!

defaultGeneratorClass: aClass 
	DefaultGeneratorClass := aClass!

initialize
	DefaultGeneratorClass := RandomParkMiller!

new
	"Answer a new Random number generator seeded off the system clock."

	^self seed: (self systemClockSeed bitOr: 1)!

newConcrete
	^self isNonInstantiable ifTrue: [self newDefault] ifFalse: [self basicNew]!

newDefault
	^DefaultGeneratorClass new!

seed: anInteger 
	"Anwer a new Random stream with the initial seed anInteger. Due
	to a limitation of the Park and Miller algorithm, the seed cannot
	be zero."

	^(self newConcrete)
		seed: anInteger;
		yourself!

systemClockSeed
	| seed |
	seed := Delay microsecondClockValue // 1000 bitAnd: 16r3FFFFFFF.
	seed = 0 ifTrue: [seed := 1].
	^seed! !
!Random class categoriesFor: #default!instance creation!public! !
!Random class categoriesFor: #defaultGeneratorClass!accessing!public! !
!Random class categoriesFor: #defaultGeneratorClass:!accessing!public! !
!Random class categoriesFor: #initialize!initializing!public! !
!Random class categoriesFor: #new!instance creation!public! !
!Random class categoriesFor: #newConcrete!instance creation!private! !
!Random class categoriesFor: #newDefault!instance creation!private! !
!Random class categoriesFor: #seed:!instance creation!public! !
!Random class categoriesFor: #systemClockSeed!enquiries!public! !

