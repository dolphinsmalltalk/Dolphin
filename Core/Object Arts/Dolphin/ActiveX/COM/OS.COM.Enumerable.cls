"Filed out from Dolphin Smalltalk 7"!

Core.SequenceableCollection subclass: #'OS.COM.Enumerable'
	instanceVariableNames: 'interface'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Enumerable guid: (Core.GUID fromString: '{87b4c50e-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.COM.Enumerable comment: 'OS.COM.Enumerable is a <sequencedReadableCollection> that wraps an OLE enumeration interface (IEnumXXXX). It provides an efficient way to treat an enumeration supplied by a COM object as a full-blown Smalltalk collection.

Enumerables are really much closer to positionable stream''s than sequenceable collections, so this design is a mistake in hindsight, but remains in place for now.

'!
!OS.COM.Enumerable categoriesForClass!Collections-Sequenceable! !
!OS.COM.Enumerable methodsFor!

add: newElement
	"OLE IEnums are immutable, and therefore not extensible."

	^self shouldNotImplement!

approxSize
	"Private - Answer the approximate size of the receiver.
	Implementation Note: The size of enumerators must be calculated (no tally
	is kept), which is expensive, so we revert to the basic collection
	implementation."

	^2!

at: index 
	"Answer the element of the receiver at the specified index. If the index
	is out of bounds, raise an exception."

	| elem |
	elem := interface
				position: index - 1;
				nextAvailable.
	^elem ifNil: [self errorSubscriptBounds: index]!

at: index put: newElement
	"OLE IEnums are immutable."

	^self shouldNotImplement!

basicFree
	"Private - Release any external resources held by the receiver."

	interface free!

collect: transformer
	"Evaluate the <monadicValuable> argument, transformer, for each of the 
	receiver's elements in the order defined by the receiver's implementation of #do:.
	Answer a new collection like the receiver containing the values returned by 
	transformer on each evaluation.
	Implementation Note: #size is very slow on an OLE enumerator (it has to be calculated
	by enumerating the collection), so override to avoid it."

	^interface collect: [:elem | transformer value: elem]!

copyEmpty: anInteger
	"Private - Answer an empty copy of the receiver (which must be of the exact same class
	not the copy-class), with sufficient capacity for anInteger number of elements."

	"Implementation Note: This is not possible for an OLEEnumerator, so answer an empty <OrderedCollection>"

	^self copyingClass new: anInteger!

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	"For an OLEEnumerator, we copy to an appropriate Smalltalk class (Array because OLEEnumerators are fixed in size and typically static)."

	^Array!

copySize
	"Private - Answer the size of empty copy to create when performing various
	copying/collecting transformations against the receiver.
	Implementation Note: Override because #size is slow, and we copy into
	a dynamically extensible collection."

	^self approxSize!

free
	"Release an external resources held by the receiver."

	interface notNil ifTrue: [
		self basicFree.
		interface := nil]!

from: start to: stop keysAndValuesDo: operation
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	between the <integer> indices, start and stop, inclusive with the element and its
	index as respectively the second and first arguments. A BoundsError will be
	raised if either start or stop is out of bounds.
	Implementation Note: The superclass implementation would be very slow, because #at:
	is quite slow on IEnums due to the lack of easy random access."

	| elem index |
	index := start - 1.
	interface position: index.
	[(elem := interface nextAvailable) notNil and: [index < stop]] whileTrue: [
		operation value: (index:=index+1) value: elem].
	"Report any stop bounds error."
	stop > index
		ifTrue: [^self errorSubscriptBounds: stop].!

growSize
	"Private - Not growable."

	^self shouldNotImplement!

interface: anIEnum
	"Private - Set the receiver's IEnum interface to be the argument."

	interface := anIEnum!

keysAndValuesDo: operation
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	with the <integer> index of that element and the element itself as the arguments.
	Implementation Note: We must override this in order that #countElements can calculate
	the size without causing the infinite recursion
		 #keysAndValuesDo:->#size->#countElements->#do:->#keysAndValuesDo: ... and so on."

	| index |
	index := 0.
	interface do: [:elem | operation value: (index := index + 1) value: elem]!

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class (although this implementation uses the class primitive, which should not fail). Normally used when comparing two objects to determine if they are of the comparable types."

	^Array! !
!OS.COM.Enumerable categoriesFor: #add:!adding!public! !
!OS.COM.Enumerable categoriesFor: #approxSize!accessing!private! !
!OS.COM.Enumerable categoriesFor: #at:!accessing!public! !
!OS.COM.Enumerable categoriesFor: #at:put:!accessing!public! !
!OS.COM.Enumerable categoriesFor: #basicFree!private!realizing/unrealizing! !
!OS.COM.Enumerable categoriesFor: #collect:!enumerating!public! !
!OS.COM.Enumerable categoriesFor: #copyEmpty:!copying!private! !
!OS.COM.Enumerable categoriesFor: #copyingClass!copying!private! !
!OS.COM.Enumerable categoriesFor: #copySize!copying!private! !
!OS.COM.Enumerable categoriesFor: #free!public!realizing/unrealizing! !
!OS.COM.Enumerable categoriesFor: #from:to:keysAndValuesDo:!enumerating!public! !
!OS.COM.Enumerable categoriesFor: #growSize!accessing!private! !
!OS.COM.Enumerable categoriesFor: #interface:!accessing!private! !
!OS.COM.Enumerable categoriesFor: #keysAndValuesDo:!enumerating!public! !
!OS.COM.Enumerable categoriesFor: #species!accessing!public! !

!OS.COM.Enumerable class methodsFor!

onIEnum: anIEnum
	"Answer a new instance of the receiver which provides access via the Collection protocol 
	to the specified IEnum."

	^self new
		interface: anIEnum

	! !
!OS.COM.Enumerable class categoriesFor: #onIEnum:!instance creation!public! !

