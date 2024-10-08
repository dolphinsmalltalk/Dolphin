﻿"Filed out from Dolphin Smalltalk"!

Core.ArrayedCollection
	subclass: #'Core.RunArray'
	instanceVariableNames: 'values runs'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.RunArray guid: (Core.GUID fromString: '{87b4c513-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.RunArray comment: ''!

!Core.RunArray categoriesForClass!Collections-Arrayed! !

!Core.RunArray methodsFor!

allSatisfy: discriminator
	"Answer whether the <monadicValuable>, discriminator, evaluates to true for
	every element of the receiver."

	"Implementation Note: Override back to Collection definition as #at: is very slow for RunArrays."

	self do: [:e | (discriminator value: e) ifFalse: [^false]].
	^true!

anySatisfy: discriminator
	"Answer whether the <monadicValuable>, discriminator, evaluates to true for
	any element of the receiver."

	"Implementation Note: Override back to Collection definition as #at: is very slow for RunArrays."

	self do: [:e | (discriminator value: e) ifTrue: [^true]].
	^false!

asRunArray
	^self!

at: anInteger
	"Answer the element at index, anInteger, in the receiver."

	| index |
	anInteger < 1 ifTrue: [^self errorSubscriptBounds: anInteger].
	index := 0.
	1 to: runs size
		do: 
			[:i |
			index := index + (runs at: i).
			anInteger <= index ifTrue: [^values at: i]].
	^self errorSubscriptBounds: anInteger!

at: index ifAbsent: exceptionBlock
	"Answer an <Object> which is the element of the receiver 
	at the specified index. If the index is out of bounds answer
	the result of evaluating the <niladicValuable> exceptionBlock."

	^(index > 0 and: [index <= self size])
		ifTrue: [self at: index]
		ifFalse: [exceptionBlock value]!

at: index put: newElement
	"Replace the element of the receiver at the specified <integer> index with 
	the <Object> argument, newElement. If the index is out of bounds, raise 
	a BoundsError.

	Implementation Note: RunArrays are not mutable."

	^self shouldNotImplement
!

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	^Array!

decodeNextFrom: aReadStream
	"Private - Answer the next <Object> in the receiver's encoding from the <ReadStream> argument ."

	^self at: aReadStream advancePosition!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original, apart from the elements. Answer the receiver. In
	the case of a RunArray we need to copy the runs and values arrays."

	super postCopy.
	values := values copy.
	runs := runs copy.
	^self!

resize: anInteger
	"Run arrays are not extensible"

	^self shouldNotImplement
!

runs: runsArray values: valuesArray
	"Private - Set the receiver's instance variables."

	runs := runsArray.
	values := valuesArray!

runsAndValuesDo: operation
	runs with: values do: operation!

runStartAndValueAt: anInteger
	"Private - Answer an association between the <dyadicValuable> 
	operation for the element of the receiver at the specified index 
	and the index of the start of the run in which that element occurs.
	The run-start is the key, the element the value."

	| runStart |
	runStart := 1.
	1 to: runs size do: [:i | | nextRun |
		nextRun := runStart + (runs at: i).
		nextRun > anInteger
			ifTrue: [^runStart -> (values at: i)].
		runStart := nextRun].
	^self errorSubscriptBounds: anInteger!

runStartAt: anInteger
	"Answer the index of the start of the run which includes the index anInteger (i.e. the index of
	the first element in the receiver in the run of elements equal to the element at anInteger)."

	| index |
	index := 1.
	runs do: [:run |
		(index + run) > anInteger
			ifTrue: [ ^index ].
		index := index + run].
	^self errorSubscriptBounds: anInteger
!

size
	"Answer the number of elements in the receiver."

	| tally |
	tally := 0.
	1 to: runs size do: [:i | tally := tally + (runs at: i)].
	^tally!

sortUsing: aSortAlgorithm
	"Perform an in-place sort against the receiver using the specified sort algorithm"
	
	self shouldNotImplement!

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class (although this implementation uses the class primitive, which should not fail). Normally used when comparing two objects to determine if they are of the comparable types."

	^Array!

storeOn: aWriteStream
	"Append to the <puttableStream> argument an expression which when evaluated will answer a collection similar to the receiver."

	aWriteStream nextPut: $(.
	self class storeOn: aWriteStream.
	aWriteStream nextPutAll: ' runs: '.
	runs storeOn: aWriteStream.
	aWriteStream nextPutAll: ' values: '.
	values storeOn: aWriteStream.
	aWriteStream nextPut: $)! !

!Core.RunArray categoriesForMethods!
allSatisfy:!enumerating!public! !
anySatisfy:!enumerating!public! !
asRunArray!converting!public! !
at:!accessing!public! !
at:ifAbsent:!accessing!public! !
at:put:!accessing!public! !
copyingClass!copying!private! !
decodeNextFrom:!encode/decode!private! !
postCopy!copying!public! !
resize:!mutating!public! !
runs:values:!accessing!private! !
runsAndValuesDo:!enumerating!public! !
runStartAndValueAt:!accessing!private! !
runStartAt:!accessing!public! !
size!accessing!public! !
sortUsing:!public!sorting! !
species!accessing!public! !
storeOn:!accessing!private! !
!

!Core.RunArray class methodsFor!

new
	"Answer a new, empty, instance of the receiver."

	^self runs: {} values: {}!

new: anInteger
	"Answer a new instance of the receiver with anInteger nil elements."

	^self new: anInteger withAll: nil!

new: anInteger withAll: anObject
	"Answer a new instance of the receiver with anInteger elements which are all 
	the argument, anObject."

	^anInteger == 0 ifTrue: [self new] ifFalse: [self runs: {anInteger} values: {anObject}]!

runs: runsArray values: valuesArray
	"Answer a new instance of the receiver with the specified runs and values.
	N.B. The two arrays must be the same size."

	^self basicNew
		runs: runsArray values: valuesArray!

with: element1
	^self runs: #(1) values: {element1}!

with: element1 with: element2
	^self runs: #(1 1)
		values: {element1. element2}!

with: element1 with: element2 with: element3
	^self runs: #(1 1 1)
		values: {element1. element2. element3}!

with: element1 with: element2 with: element3 with: element4
	^self runs: #(1 1 1 1)
		values: {element1. element2. element3. element4}!

with: element1 with: element2 with: element3 with: element4 with: element5
	^self runs: #(1 1 1 1 1)
		values: {element1. element2. element3. element4. element5}!

withAll: aCollection
	| runLength current runs values |
	runs := WriteStream on: {}.
	values := WriteStream on: {}.
	runLength := 0.
	current := AbsentCookie.
	aCollection do: 
			[:each |
			current = each
				ifTrue: [runLength := runLength + 1]
				ifFalse: 
					[runLength > 0
						ifTrue: 
							[runs nextPut: runLength.
							values nextPut: current].
					runLength := 1.
					current := each]].
	runLength > 0
		ifTrue: 
			[runs nextPut: runLength.
			values nextPut: current].
	^self runs: runs contents values: values contents! !

!Core.RunArray class categoriesForMethods!
new!instance creation!public! !
new:!instance creation!public! !
new:withAll:!instance creation!public! !
runs:values:!instance creation!public! !
with:!instance creation!public! !
with:with:!instance creation!public! !
with:with:with:!instance creation!public! !
with:with:with:with:!instance creation!public! !
with:with:with:with:with:!instance creation!public! !
withAll:!instance creation!public! !
!

