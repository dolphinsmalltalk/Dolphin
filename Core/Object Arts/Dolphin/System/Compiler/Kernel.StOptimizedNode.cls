"Filed out from Dolphin Smalltalk 7"!

Kernel.StValueNode subclass: #'Kernel.StOptimizedNode'
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
!Kernel.StOptimizedNode categoriesFor: #=!comparing!public! !
!Kernel.StOptimizedNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StOptimizedNode categoriesFor: #argumentCount!public! !
!Kernel.StOptimizedNode categoriesFor: #arguments!accessing!public! !
!Kernel.StOptimizedNode categoriesFor: #body!accessing!public! !
!Kernel.StOptimizedNode categoriesFor: #body:!accessing!public! !
!Kernel.StOptimizedNode categoriesFor: #childrenDo:!accessing!public! !
!Kernel.StOptimizedNode categoriesFor: #evaluateStatements!helpers!private! !
!Kernel.StOptimizedNode categoriesFor: #hash!comparing!public! !
!Kernel.StOptimizedNode categoriesFor: #initialize!public! !
!Kernel.StOptimizedNode categoriesFor: #isImmediateNode!public!testing! !
!Kernel.StOptimizedNode categoriesFor: #isInlined!public! !
!Kernel.StOptimizedNode categoriesFor: #left:body:right:!initializing!public! !
!Kernel.StOptimizedNode categoriesFor: #methodClass!accessing!private! !
!Kernel.StOptimizedNode categoriesFor: #methodClass:!accessing!private! !
!Kernel.StOptimizedNode categoriesFor: #needsParenthesis!public!testing! !
!Kernel.StOptimizedNode categoriesFor: #postCopy!copying!public! !
!Kernel.StOptimizedNode categoriesFor: #precedence!accessing!public! !
!Kernel.StOptimizedNode categoriesFor: #source!accessing!public! !
!Kernel.StOptimizedNode categoriesFor: #source:!accessing!private! !
!Kernel.StOptimizedNode categoriesFor: #startWithoutParentheses!accessing!public! !
!Kernel.StOptimizedNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!Kernel.StOptimizedNode categoriesFor: #value!accessing!public! !
!Kernel.StOptimizedNode categoriesFor: #value:!accessing!public! !

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
!Kernel.StOptimizedNode class categoriesFor: #body:!instance creation!public! !
!Kernel.StOptimizedNode class categoriesFor: #initialize!public! !
!Kernel.StOptimizedNode class categoriesFor: #left:body:right:!instance creation!public! !
!Kernel.StOptimizedNode class categoriesFor: #new!instance creation!public! !

