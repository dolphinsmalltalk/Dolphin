"Filed out from Dolphin Smalltalk 99 release 3.0"!

OLEEnumerator subclass: #VARIANTEnumerator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''!

VARIANTEnumerator class instanceVariableNames: ''!

VARIANTEnumerator comment: ''!

VARIANTEnumerator guid: (GUID fromString: '{211C6D0C-5B21-494B-BC30-83B51FA5E5F4}')!

!VARIANTEnumerator categoriesForClass!Unclassified! !

!VARIANTEnumerator methodsFor!

at: index
	"Answer the element of the receiver at the specified index. If the index
	is out of bounds, raise an exception."

	^(super at: index) value!

from: start to: stop keysAndValuesDo: operation
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	between the <integer> indices, start and stop, inclusive with the element and its
	index as respectively the second and first arguments. A BoundsError will be
	raised if either start or stop is out of bounds."

	| elem index |
	index := start - 1.
	interface position: index.
	[(elem := interface nextAvailable) notNil and: [index < stop]] whileTrue: [
		operation value: (index:=index+1) value: elem value].
	"Report any stop bounds error."
	stop > index
		ifTrue: [^self errorSubscriptBounds: stop].!

keysAndValuesDo: operation
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	with the <integer> index of that element and the element itself as the arguments."

	| elem index |
	interface reset.
	index := 0.
	[(elem := interface nextAvailable) notNil] whileTrue: [
		index := index + 1.
		operation value: index value: elem value]! !

!VARIANTEnumerator categoriesFor: #at:!accessing!public! !
!VARIANTEnumerator categoriesFor: #from:to:keysAndValuesDo:!enumerating!public! !
!VARIANTEnumerator categoriesFor: #keysAndValuesDo:!enumerating!public! !

