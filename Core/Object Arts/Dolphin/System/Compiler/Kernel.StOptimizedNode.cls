"Filed out from Dolphin Smalltalk"!

Kernel.StValueNode
	subclass: #'Kernel.StOptimizedNode'
	instanceVariableNames: 'left right body value methodClass source'
	classVariableNames: 'UnevaluatedCookie'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StOptimizedNode guid: (Core.GUID fromString: '{d6ca95fa-6dec-4ced-8780-c36c6450314f}')!
Kernel.StOptimizedNode comment: 'StOptimizedNode is an parse tree node that represents ##(...) expressions. These expressions are evaluated at compile time and directly inserted into the method.

Instance Variables:
	body	<StSequenceNode> the body of the expression
	left	<Integer>	position of the ##( characters
	right	<Integer>	position of )

'!
!Kernel.StOptimizedNode categoriesForClass!System-Compiler! !
!Kernel.StOptimizedNode methodsFor!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	^body = anObject body!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitOptimizedNode: self!

argumentCount
	^0!

arguments
	^#()!

body
	^body!

body: stmtsNode 
	body := stmtsNode.
	body parent: self!

childrenDo: aMonadicValuable 
	aMonadicValuable value: body!

evaluateStatements
	methodClass isNil ifTrue: [^nil].
	^self source
		ifNotNil: [:s | Compiler evaluate: (s copyFrom: body start to: body stop) for: methodClass instanceClass environment: self methodNode environment]!

hash
	^self body hash!

initialize
	value := UnevaluatedCookie!

isImmediateNode
	^true!

isInlined
	^false!

isStaticExpressionNode
	^true!

left: leftInteger body: aSequenceNode right: rightInteger 
	left := leftInteger.
	self body: aSequenceNode.
	right := rightInteger!

methodClass
	^methodClass!

methodClass: anObject
	methodClass := anObject!

needsParenthesis
	^false!

postCopy
	super postCopy.
	self body: body copy.
	^self!

precedence
	^0!

setValue: anObject
	<mutable>
	value := anObject!

source
	^source ifNil: [super source]!

source: anObject
	source := anObject!

startWithoutParentheses
	^left!

stopWithoutParentheses
	^right!

value
	"Lazily evaluate the expression if the value is required"

	value == UnevaluatedCookie ifTrue: [self setValue: self evaluateStatements].
	^value!

value: anObject
	value := anObject! !
!Kernel.StOptimizedNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
argumentCount!accessing!public! !
arguments!accessing!public! !
body!accessing!public! !
body:!accessing!public! !
childrenDo:!accessing!public! !
evaluateStatements!helpers!private! !
hash!comparing!public! !
initialize!initializing!public! !
isImmediateNode!public!testing! !
isInlined!public!testing! !
isStaticExpressionNode!public!testing! !
left:body:right:!initializing!public! !
methodClass!accessing!private! !
methodClass:!accessing!private! !
needsParenthesis!public!testing! !
postCopy!copying!public! !
precedence!accessing!public! !
setValue:!public! !
source!accessing!public! !
source:!accessing!private! !
startWithoutParentheses!accessing!public! !
stopWithoutParentheses!accessing!public! !
value!accessing!public! !
value:!accessing!public! !
!

!Kernel.StOptimizedNode class methodsFor!

body: aSequenceNode 
	^self new body: aSequenceNode!

initialize
	UnevaluatedCookie := Object new!

left: leftInteger body: aSequenceNode right: rightInteger 
	^(self new)
		left: leftInteger
			body: aSequenceNode
			right: rightInteger;
		yourself!

new
	^super new initialize! !
!Kernel.StOptimizedNode class categoriesForMethods!
body:!instance creation!public! !
initialize!class initialization!public! !
left:body:right:!instance creation!public! !
new!instance creation!public! !
!

