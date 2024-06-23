"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.Magnitude'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Magnitude guid: (Core.GUID fromString: '{87b4c49b-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.Magnitude isNonInstantiable: true!

Core.Magnitude comment: 'Magnitude is an abstract class which provides the protocol objects which can be compared
along a linear dimension, e.g. Numbers, Dates, Times.

Subclasses of Magnitude must implement the following comparing protocol (at the very least):
#<, #=, #hash'!

!Core.Magnitude categoriesForClass!Magnitude-General! !

!Core.Magnitude methodsFor!

< aMagnitude
	"Answer whether the receiver is less than the <magnitude> argument.

	Only this relational operator need be implemented by subclasses, since the others can generally be implemented in terms of it (though performance or special characteristics may dictate otherwise)."

	^self subclassResponsibility!

<= aMagnitude
	"Answer whether the receiver is less than or equal to the <magnitude> argument."

	^(aMagnitude < self) not!

<==> aMagnitude
	"Answer the receiver's <integer> collation order with respect to the <Magitude> argument."

	"Defined for polymorphism with Strings, where this version of the spaceship operator is case-sensitive (#<=> is not). For Magnitudes this is equivalent to #<=>."

	^self <=> aMagnitude!

<=> aMagnitude
	"Answer the receiver's <integer> collation order with respect to the <Number> argument. Colloquially known as the spaceship operator.
	The answer is < 0 if the receiver should collate before the argument, 0 if they have the same collation order, or > 0 if the receiver should collate after the argument.
	N.B. Gives an incorrect answer if either operand is a NaN."

	^self = aMagnitude ifTrue: [0] ifFalse: [self < aMagnitude ifTrue: [-1] ifFalse: [1]]!

= aMagnitude
	"Answer whether the receiver is equivalent to the <magnitude> argument."

	^self subclassResponsibility!

> aMagnitude
	"Answer whether the receiver is greater than the <magnitude> argument."

	^aMagnitude < self!

>= aMagnitude
	"Answer whether the receiver is greater than or equal to the <magnitude>, argument."

	^aMagnitude <= self!

between: min and: max
	"Answer whether the receiver is inclusively between the <magnitude> arguments, 
	min and max."

	^self >= min and: [self <= max]!

clampBetween: minimum and: maximum
	"Clamp the receiver's value to the specified range."

	self < minimum ifTrue: [^minimum].
	self < maximum ifTrue: [^self].
	^maximum!

hash
	"Answer a SmallInteger hash value for the receiver which obeys the invariant that any two 
	objects which compare equal (using #=) must have the same hash value (but not 
	necessarily vice-versa). Like #=, and #<, must be implemented by subclasses."

	^self subclassResponsibility!

max: operand
	"Answer the greater of the receiver and the <magnitude>, operand.
	 Implementation Note: #< is used since other relational operators are often implemented 
	in terms of it."

	^self < operand
		ifTrue:  [operand]
		ifFalse: [self]!

min: operand
	"Answer the lesser of the receiver and the <magnitude>, operand."

	^self < operand
		ifTrue:  [self]
		ifFalse: [operand]!

printString
	"Answer a <readableString> whose characters are a description of the receiver as a Smalltalk developer would want to see it."

	"Implementation Note: Avoid the cost of using a LimitedWriteStream for most cases."

	| stream |
	stream := String smalltalkWriteStream: 32.
	self printOn: stream.
	^stream contents! !

!Core.Magnitude categoriesForMethods!
<!comparing!public! !
<=!comparing!public! !
<==>!comparing!public! !
<=>!comparing!public! !
=!comparing!public! !
>!comparing!public! !
>=!comparing!public! !
between:and:!comparing!public! !
clampBetween:and:!comparing!public! !
hash!comparing!public! !
max:!comparing!public! !
min:!comparing!public! !
printString!printing!public! !
!

Core.Magnitude methodProtocol: #magnitude attributes: #(#ansi #readOnly) selectors: #(#< #<= #> #>= #between:and: #max: #min:)!

