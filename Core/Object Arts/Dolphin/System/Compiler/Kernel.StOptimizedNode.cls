"Filed out from Dolphin Smalltalk 7"!

StValueNode subclass: #StOptimizedNode
	instanceVariableNames: 'left right body value methodClass source'
	classVariableNames: 'UnevaluatedCookie'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!StOptimizedNode categoriesFor: #=!comparing!public! !
!StOptimizedNode categoriesFor: #acceptVisitor:!public!visitor! !
!StOptimizedNode categoriesFor: #argumentCount!public! !
!StOptimizedNode categoriesFor: #arguments!accessing!public! !
!StOptimizedNode categoriesFor: #body!accessing!public! !
!StOptimizedNode categoriesFor: #body:!accessing!public! !
!StOptimizedNode categoriesFor: #childrenDo:!accessing!public! !
!StOptimizedNode categoriesFor: #evaluateStatements!helpers!private! !
!StOptimizedNode categoriesFor: #hash!comparing!public! !
!StOptimizedNode categoriesFor: #initialize!public! !
!StOptimizedNode categoriesFor: #isImmediateNode!public!testing! !
!StOptimizedNode categoriesFor: #isInlined!public! !
!StOptimizedNode categoriesFor: #left:body:right:!initializing!public! !
!StOptimizedNode categoriesFor: #methodClass!accessing!private! !
!StOptimizedNode categoriesFor: #methodClass:!accessing!private! !
!StOptimizedNode categoriesFor: #needsParenthesis!public!testing! !
!StOptimizedNode categoriesFor: #postCopy!copying!public! !
!StOptimizedNode categoriesFor: #precedence!accessing!public! !
!StOptimizedNode categoriesFor: #source!accessing!public! !
!StOptimizedNode categoriesFor: #source:!accessing!private! !
!StOptimizedNode categoriesFor: #startWithoutParentheses!accessing!public! !
!StOptimizedNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!StOptimizedNode categoriesFor: #value!accessing!public! !
!StOptimizedNode categoriesFor: #value:!accessing!public! !

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
!StOptimizedNode class categoriesFor: #body:!instance creation!public! !
!StOptimizedNode class categoriesFor: #initialize!public! !
!StOptimizedNode class categoriesFor: #left:body:right:!instance creation!public! !
!StOptimizedNode class categoriesFor: #new!instance creation!public! !

