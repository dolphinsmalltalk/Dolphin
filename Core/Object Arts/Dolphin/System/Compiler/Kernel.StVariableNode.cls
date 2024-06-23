"Filed out from Dolphin Smalltalk"!

Kernel.StValueNode
	subclass: #'Kernel.StVariableNode'
	instanceVariableNames: 'start variable'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.StVariableNode guid: (Core.GUID fromString: '{38ecca66-7d53-4b09-90f6-5c6f0e76ba79}')!

Kernel.StVariableNode isNonInstantiable: true!

Kernel.StVariableNode comment: 'StAbstractVariableNode is an abstract parse tree node with subclasses to represent variable references and definitions.

Instance Variables:
	start		<Integer> start position of the variable in the source
	variable	A subtype of <StVariable> describing the type of variable that this node is referencing or defining. Only set if semantic analysis has been run.

'!

!Kernel.StVariableNode categoriesForClass!System-Compiler! !

!Kernel.StVariableNode methodsFor!

= anObject
	self == anObject ifTrue: [^true].
	(anObject isKindOf: StVariableNode) ifFalse: [^false].
	^self name = anObject name!

binding
	"Only static variable nodes can have a binding."

	^nil!

hash
	^self name hash!

hasQualifiedName
	"Answer whether the receiver has a qualified name (i.e. it is a static variable reference with a dot separated path)."

	^false!

isConstantNode
	"Answer whether the receiver describes a variable that cannot be assigned to (i.e. a constant)."

	^false!

isImmediateNode
	^true!

isParameter
	^false!

isStaticVariable
	"Answer whether the receiver is a reference to a static variable - this is only valid after binding variables in a parse tree using a semantic analyser."

	^false!

isTempDeclaration
	^false!

isVariable
	^true!

name
	^self subclassResponsibility!

needsParenthesis
	^false!

precedence
	^0!

setStart: anInteger
	start := anInteger!

startWithoutParentheses
	^start!

stopWithoutParentheses
	^start + self name size - 1!

variable
	^variable!

variable: aStVariable
	variable := aStVariable! !

!Kernel.StVariableNode categoriesForMethods!
=!comparing!public! !
binding!accessing!public! !
hash!comparing!public! !
hasQualifiedName!public!testing! !
isConstantNode!public!testing! !
isImmediateNode!public!testing! !
isParameter!public!testing! !
isStaticVariable!public!testing! !
isTempDeclaration!public!testing! !
isVariable!public!testing! !
name!constants!public! !
needsParenthesis!public!testing! !
precedence!accessing!public! !
setStart:!initializing!private! !
startWithoutParentheses!accessing!public! !
stopWithoutParentheses!accessing!public! !
variable!accessing!public! !
variable:!accessing!public! !
!

!Kernel.StVariableNode class methodsFor!

identifierToken: anIdentifierToken
	^self named: anIdentifierToken value start: anIdentifierToken start!

named: aString
	^self named: aString start: 0!

named: aString start: anInteger
	aString = 'self' ifTrue: [^StSelfVariableNode start: anInteger].
	aString = 'super' ifTrue: [^StSuperVariableNode start: anInteger].
	aString = 'thisContext' ifTrue: [^StThisContextVariableNode start: anInteger].
	^self new
		setName: aString start: anInteger;
		yourself!

new
	"Answer an instance of the receiver with no indexed variables. Send the receiver the message {new: 0} if the receiver is indexable.

	This is the fundamental method by which new class instances are created. It is inherited
	by class objects (Metaclass instance instances) through the route:
		MyClass class -> MyClass class superclass -> ... 
			-> Object class -> Class -> ClassDescription -> Behavior"

	"Primitive failure reasons:
		ObjectTypeMismatch	- The receiver is an indexable class, and requires a size.
		NonInstantiable		- The receiver class is non-instantiable (abstract)."

	<primitive: 70>
	_failureCode == _PrimitiveFailureCode.NonInstantiable ifTrue: [^StBasicVariableNode new].
	^self primitiveFailed: _failureCode!

selfNode
	^StSelfVariableNode start: 0!

superNode
	^StSuperVariableNode start: 0!

thisContextNode
	^StThisContextVariableNode start: 0! !

!Kernel.StVariableNode class categoriesForMethods!
identifierToken:!instance creation!public! !
named:!instance creation!public! !
named:start:!instance creation!public! !
new!instance creation!public! !
selfNode!instance creation!public! !
superNode!instance creation!public! !
thisContextNode!instance creation!public! !
!

