"Filed out from Dolphin Smalltalk"!

StValueNode subclass: #StOptimizedNode
	instanceVariableNames: 'left right body value methodClass source'
	classVariableNames: 'UnevaluatedCookie'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StOptimizedNode guid: (GUID fromString: '{d6ca95fa-6dec-4ced-8780-c36c6450314f}')!
StOptimizedNode comment: 'StOptimizedNode is an parse tree node that represents ##(...) expressions. These expressions are evaluated at compile time and directly inserted into the method.

Instance Variables:
	body	<StSequenceNode> the body of the expression
	left	<Integer>	position of the ##( characters
	right	<Integer>	position of )

'!
!StOptimizedNode categoriesForClass!System-Compiler! !
!StOptimizedNode methodsFor!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	^self body = anObject body!

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
	| s |
	methodClass isNil ifTrue: [^nil].
	^self source
		ifNotNil: [:s | Compiler evaluate: (s copyFrom: body start to: body stop) for: methodClass instanceClass]!

hash
	^self body hash!

initialize
	value := UnevaluatedCookie!

isImmediateNode
	^true!

isInlined
	^false!

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

	value == UnevaluatedCookie ifTrue: [value := self evaluateStatements].
	^value!

value: anObject
	value := anObject! !
!StOptimizedNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
argumentCount!public! !
arguments!accessing!public! !
body!accessing!public! !
body:!accessing!public! !
childrenDo:!accessing!public! !
evaluateStatements!helpers!private! !
hash!comparing!public! !
initialize!public! !
isImmediateNode!public!testing! !
isInlined!public! !
left:body:right:!initializing!public! !
methodClass!accessing!private! !
methodClass:!accessing!private! !
needsParenthesis!public!testing! !
postCopy!copying!public! !
precedence!accessing!public! !
source!accessing!public! !
source:!accessing!private! !
startWithoutParentheses!accessing!public! !
stopWithoutParentheses!accessing!public! !
value!accessing!public! !
value:!accessing!public! !
!

!StOptimizedNode class methodsFor!

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
!StOptimizedNode class categoriesForMethods!
body:!instance creation!public! !
initialize!public! !
left:body:right:!instance creation!public! !
new!instance creation!public! !
!

