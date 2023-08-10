"Filed out from Dolphin Smalltalk"!

Kernel.STxProxy
	subclass: #'Kernel.STBCollectionProxy'
	instanceVariableNames: 'class array'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBCollectionProxy guid: (Core.GUID fromString: '{87b4c6eb-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STBCollectionProxy comment: ''!
!Kernel.STBCollectionProxy categoriesForClass!System-Binary storage! !
!Kernel.STBCollectionProxy methodsFor!

array: anArray
	"Private - Set the array inst var to anArray, the elements of the collection represented by the receiver.
	The use of the empty array literal enables the STBOutFiler to issue a shorter object reference for
	any subsequent empty instances of the receiver."

	array := anArray isEmpty
		ifTrue: [#()]
		ifFalse: [anArray]
!

class: aClass
	"Private - Set the class of the object represented by the receiver."

	class := aClass
!

value
	"Answer a new collection of class class and elements array."

	^class withAll: array! !
!Kernel.STBCollectionProxy categoriesForMethods!
array:!accessing!private! !
class:!accessing!private! !
value!converting!public! !
!

!Kernel.STBCollectionProxy class methodsFor!

class: aClass array: anArray
	"Answer a new instance containing the class and elements of
	the collection that it represents."

	^self basicNew
		class: aClass;
		array: anArray;
		yourself
	!

forCollection: aCollection 
	"Answer a new instance representing aCollection."

	^self class: aCollection basicClass array: aCollection asArray! !
!Kernel.STBCollectionProxy class categoriesForMethods!
class:array:!instance creation!public! !
forCollection:!instance creation!public! !
!

