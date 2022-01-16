"Filed out from Dolphin Smalltalk"!

Kernel.STLInFiler subclass: #'Kernel.STLClassCollector'
	instanceVariableNames: 'classes'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLClassCollector guid: (Core.GUID fromString: '{bf23d8df-102a-469c-90f6-0698b66b6fa6}')!
Kernel.STLClassCollector comment: ''!
!Kernel.STLClassCollector categoriesForClass!System-Binary storage! !
!Kernel.STLClassCollector methodsFor!

basicNext
	| prefixOrLiteral |
	prefixOrLiteral := stream next.
	prefixOrLiteral isInteger ifFalse: [^self collectClassOf: prefixOrLiteral value].
	STBPrefix.LiteralPrefixMask == prefixOrLiteral
		ifFalse: [^self readObjectWithPrefix: prefixOrLiteral].
	^self readLiteralData!

classes
	^classes!

collectClassOf: anObject
	classes add: (anObject isBehavior ifTrue: [anObject instanceClass] ifFalse: [anObject basicClass]).
	^anObject!

contents
	self basicNext.
	^classes!

initialize
	"Private - Initialize the receiver."

	classes := DeafObject.Current.
	super initialize.
	classes := IdentitySet new: 64.
	"Even an empty STL store array will contain the Symbol, #'STL!!', a SmallInteger for the version, and the Array itself)."
	classes
		add: Array;
		add: Symbol;
		add: SmallInteger.!

objectAt: anInteger
	"Private - Answer the map value at anInteger. Signal an exception if there is no such entry."

	^anInteger < MaxPredefinedRef
		ifTrue: 
			["Record a reference to a pre-registered class so we know it is used in this stream"
			self collectClassOf: (readMap at: anInteger)]
		ifFalse: [readMap at: anInteger]!

readLiteralData
	| newObject |
	newObject := stream next.
	newObject basicClass == Array
		ifTrue: [1 to: newObject size do: [:i | self collectClassOf: (newObject at: i) value]]
		ifFalse: [self collectClassOf: newObject].
	readMap addLast: newObject.
	^newObject!

register: anObject
	"Private - Add anObject to the readMap, answering the index of the object in the map. This is important for some classes that might want to fixup the reference later."

	self collectClassOf: anObject.
	^readMap addAnsweringIndex: anObject! !
!Kernel.STLClassCollector categoriesForMethods!
basicNext!accessing!private! !
classes!accessing!private! !
collectClassOf:!helpers!private! !
contents!public! !
initialize!initializing!private! !
objectAt:!accessing!private! !
readLiteralData!helpers!private! !
register:!helpers!private! !
!

!Kernel.STLClassCollector class methodsFor!

classesIn: aLiteralArray
	"Answer a new instance attached to the binary stream aStream."

	^(self on: aLiteralArray readStream) contents!

on: aStream
	"Answer a new instance attached to the binary stream aStream."

	^self new
		stream: aStream;
		initialize! !
!Kernel.STLClassCollector class categoriesForMethods!
classesIn:!instance creation!public! !
on:!instance creation!public! !
!

