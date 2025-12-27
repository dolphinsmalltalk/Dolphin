"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.StProgramNode'
	instanceVariableNames: 'parent comments scope'
	classVariableNames: 'FormatterClass SuperSearch'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'InlinedBlockSelectors'
				-> #(#ifTrue: #ifTrue:ifFalse: #ifFalse: #ifFalse:ifTrue: #whileTrue: #whileTrue #whileFalse: #whileFalse #to:do: #to:by:do: #and: #or: #repeat #ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil:).
			'OptimizedSelectors'
				-> #(#ifTrue: #ifTrue:ifFalse: #ifFalse: #ifFalse:ifTrue: #whileTrue: #whileTrue #whileFalse: #whileFalse #to:do: #to:by:do: #and: #or: #repeat #ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil: #yourself)
		}!

Kernel.StProgramNode guid: (Core.GUID fromString: '{3e45084e-5de8-40c0-b448-c53339a17b52}')!

Kernel.StProgramNode isNonInstantiable: true!

Kernel.StProgramNode comment: 'StProgramNode is an abstract class that represents a parse tree node in a Smalltalk program.

Subclasses must implement the following messages:
	accessing
		start
		stop
	visitor
		acceptVisitor:

The #start and #stop methods are used to find the source that corresponds to this node. "source copyFrom: self start to: self stop" should return the source for this node.

The #acceptVisitor: method is used by StProgramNodeVisitors (the visitor pattern). This will also require updating all the StProgramNodeVisitors so that they can handle the new node type.

Subclasses might also want to redefine #match:inContext: and #copyInContext: to do parse tree searching and replacing (these methods are only available if the RBParser extension package is loaded).

Subclasses that contain other nodes should override equalTo:withMapping: to compare nodes while ignoring renaming temporary variables, and children that returns a collection of our children nodes.

Instance Variables:
	comments	<Collection> of <Interval>	the intervals in the source that have comments for this node
	parent	<StProgramNode>	the node we''re contained in

'!

!Kernel.StProgramNode categoriesForClass!System-Compiler! !

!Kernel.StProgramNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^self subclassResponsibility!

addComments: intervals 
	(intervals isNil or: [intervals isEmpty]) 
		ifFalse: [comments := comments ifNil: [intervals asArray] ifNotNil: [comments , intervals]]!

addStatementCommentsTo: anOrderedCollection
	comments ifNotNil: [anOrderedCollection addAllLast: comments].
	self childrenDo: [:each | each addStatementCommentsTo: anOrderedCollection]!

allArgumentVariableNodesDo: aMonadicValuable 
	self childrenDo: [:each | each allArgumentVariableNodesDo: aMonadicValuable]!

allArgumentVariables
	| answer |
	answer := OrderedCollection new.
	self allArgumentVariableNodesDo: [:each | answer add: each name].
	^answer!

allChildrenDo: aBlock
	self childrenDo: [:each | each nodesDo: aBlock]!

allDefinedVariableNodes
	| answer |
	answer := OrderedCollection new.
	self allDefinedVariableNodesDo: [:each | answer add: each].
	^answer!

allDefinedVariableNodesDo: aMonadicValuable 
	self childrenDo: [:each | each allDefinedVariableNodesDo: aMonadicValuable]!

allDefinedVariables
	| answer |
	answer := OrderedCollection new.
	self allDefinedVariableNodesDo: [:each | answer add: each name].
	^answer!

allSubNodes
	| all |
	all := OrderedCollection new.
	self nodesDo: [:each | all add: each].
	^all!

allTemporaryVariableNodes
	| answer |
	answer := OrderedCollection new.
	self allTemporaryVariableNodesDo: [:each | answer add: each].
	^answer!

allTemporaryVariableNodesDo: aMonadicValuable 
	self childrenDo: [:each | each allTemporaryVariableNodesDo: aMonadicValuable]!

allTemporaryVariables
	| answer |
	answer := OrderedCollection new.
	self allTemporaryVariableNodesDo: [:each | answer add: each name].
	^answer!

assigns: aVariableName 
	self childrenDo: [:each | (each assigns: aVariableName) ifTrue: [^true]].
	^false!

basicMethodNode
	^nil!

bestNodeFor: anInterval
	| selectedChildren |
	(self intersectsInterval: anInterval) ifFalse: [^nil].
	(self containedBy: anInterval) ifTrue: [^self].
	selectedChildren := OrderedCollection new.
	self
		childrenDo: [:each | (each intersectsInterval: anInterval) ifTrue: [selectedChildren addLast: each]].
	^selectedChildren size == 1 ifTrue: [selectedChildren first bestNodeFor: anInterval] ifFalse: [self]!

blockVariables
	^parent isNil ifTrue: [#()] ifFalse: [parent blockVariables]!

children
	| answer |
	answer := OrderedCollection new.
	self childrenDo: [:each | answer addLast: each].
	^answer!

childrenDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's sub-nodes, if any"!

collect: aBlock 
	"Hacked to fit collection protocols"

	^aBlock value: self!

comments
	^comments ?? #()!

comments: aCollection
	comments := aCollection!

containedBy: anInterval 
	^anInterval first <= self start and: [anInterval last >= self stop]!

containsReturn
	self childrenDo: [:each | each containsReturn ifTrue: [^true]].
	^false!

copyCommentsFrom: aNode
	"Add all comments from aNode to us. If we already have the comment, then don't add it."

	| newComments |
	newComments := OrderedCollection new.
	aNode nodesDo: [:each | newComments addAll: each comments].
	self nodesDo: [:each | each comments do: [:comment | newComments remove: comment ifAbsent: nil]].
	newComments isEmpty ifTrue: [^self].
	self comments: (newComments asSortedCollection: [:a :b | a first < b first])!

defines: aName
	^false!

directlyUses: aNode
	^true!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self basicPrintOn: aPuttableStream!

do: aBlock 
	"Hacked to fit collection protocols"

	aBlock value: self!

environment
	^self methodNode environment!

equalTo: aNode exceptForVariables: variableNameCollection
	| dictionary |
	dictionary := Dictionary new.
	(self equalTo: aNode withMapping: dictionary) ifFalse: [^false].
	dictionary
		keysAndValuesDo: [:key :value | (key = value or: [variableNameCollection includes: key]) ifFalse: [^false]].
	^true!

evaluatedFirst: aNode 
	self childrenDo: 
			[:each | 
			each == aNode ifTrue: [^true].
			each isImmediateNode ifFalse: [^false]].
	^false!

formattedCode
	^self formatterClass new format: self!

formatterClass
	^self class formatterClass!

hashForCollection: aCollection
	^aCollection isEmpty ifTrue: [0] ifFalse: [aCollection first hash]!

intersectsInterval: anInterval 
	^(anInterval first between: self start and: self stop) 
		or: [self start between: anInterval first and: anInterval last]!

isAnnotation
	^false!

isAssignment
	^false!

isBlock
	^false!

isCascade
	^false!

isDirectlyUsed
	"This node is directly used as an argument, receiver, or part of an assignment."

	^parent isNil ifTrue: [false] ifFalse: [parent directlyUses: self]!

isDynamicArray
	^false!

isEvaluatedFirst
	"Return true if we are the first thing evaluated in this statement."

	^parent isNil or: [parent isSequence or: [parent evaluatedFirst: self]]!

isImmediateNode
	^false!

isInStaticExpression
	scope
		ifNil: 
			[| current next |
			current := self.
			[(next := current parent) isNil] whileFalse: 
					[next isStaticExpressionNode ifTrue: [^true].
					current := next].
			^false].
	^scope methodScope node isStaticExpressionNode!

isLast: aNode 
	| children |
	children := self children.
	^children notEmpty and: [children last == aNode]!

isList
	^false!

isLiteralArray
	^false!

isLiteralNode
	^false!

isMessage
	^false!

isMethod
	^false!

isQualifiedReference
	^false!

isReturn
	^false!

isSelfVariable
	"Answer whether the variable described by the receiver is the special variable 'self'."

	^false!

isSequence
	^false!

isSpecialVariable
	"Answer whether the variable described by the receiver is one of the special (aka pseudo) variables 'self', 'super' or 'thisContext'."

	^false!

isStaticExpressionNode
	^false!

isSuperVariable
	"Answer whether the variable described by the receiver is the special variable 'super'."

	^false!

isTag
	^false!

isUsed
	"Answer true if this node could be used as part of another expression. For example, you could use the 
	result of this node as a receiver of a message, an argument, the right part of an assignment, or the 
	return value of a block. This differs from isDirectlyUsed in that it is conservative since it also includes 
	return values of blocks."

	^parent isNil ifTrue: [false] ifFalse: [parent uses: self]!

isValue
	^false!

isVariable
	^false!

lastIsReturn
	^self isReturn!

literalCharacter
	^$#!

makeTreeImmutable
	self nodesDo: [:each | each beImmutableObject]!

methodClass
	^self methodNode methodClass!

methodComments
	^self comments!

methodNode
	"Answer the StMethodNode at the top of the receiver's AST."

	"Implementation Note: A recursive solution would be more elegant, but the trees can be very deep, and there is a small (5-10%) perf advantage in an iterative solution."

	| current next |
	current := self.
	[(next := current parent) isNil] whileFalse: [current := next].
	"Allow for the top-most node not being an StMethodNode, although this should not be the case for a well-formed tree."
	^current basicMethodNode!

newSource
	^self formattedCode!

nodesDo: aBlock
	aBlock value: self.
	self childrenDo: [:each | each nodesDo: aBlock]!

outer
	"Answer the <StMethodNode> or <StBlockNode> being the scope in which this node exists."

	^self parent outer!

parent
	^parent!

parent: aStProgramNode
	parent := aStProgramNode!

postCopy
	"Apply any final flourish to the copy that may be required. In the case of a program node,
	we should no longer consider ourselves to have a parent, as our original parent does not
	refer to us, only to our original. In many cases we will be assigned a new parent shortly,
	as part of a larger #copy operation."

	super postCopy.
	parent := nil.
	^self!

precedence
	^6!

printOn: aStream 
	aStream nextPutAll: self class name;
		nextPut: $(;
		nextPutAll: self formattedCode;
		nextPut: $)!

recurseInto
	^false!

recurseIntoCharacter
	^$`!

refersToSymbol: aSymbol
	self childrenDo: [:each | (each refersToSymbol: aSymbol) ifTrue: [^true]].
	^false!

scope
	^scope!

scope: aStLexicalScope
	scope := aStLexicalScope!

sentMessages
	| messages |
	messages := IdentitySet new.
	self childrenDo: [:each | messages addAll: each sentMessages].
	^messages!

size
	"Hacked to fit collection protocols"

	^1!

source
	"Answer the source code string which was parsed to create the AST of which the receiver is a
	part, i.e. this is the source code text for the whole method or expression, not just the
	receiving node."

	^parent notNil ifTrue: [parent source] ifFalse: [nil]!

sourceCode
	"Answer the source code of this node (if available)."

	^self source
		ifNotNil: 
			[:source |
			| interval |
			interval := self sourceInterval.
			source copyFrom: interval start to: interval stop]!

sourceInterval
	^self start to: self stop!

start
	self subclassResponsibility!

startWithoutParentheses
	^self start!

statementCharacter
	^$.!

statementComments
	| statementComments |
	statementComments := OrderedCollection new.
	self addStatementCommentsTo: statementComments.
	^statementComments sort: [:a :b | a first < b first]!

statementNode
	"Return your topmost node that is contained by a sequence node."

	(parent isNil or: [parent isSequence]) ifTrue: [^self].
	^parent statementNode!

stop
	self subclassResponsibility!

temporaryVariables
	^parent isNil ifTrue: [#()] ifFalse: [parent temporaryVariables]!

uses: aNode
	^true!

whichNodeIsContainedBy: anInterval
	| selectedChildren |
	(self intersectsInterval: anInterval) ifFalse: [^nil].
	(self containedBy: anInterval) ifTrue: [^self].
	selectedChildren := OrderedCollection new.
	self
		childrenDo: [:each | (each intersectsInterval: anInterval) ifTrue: [selectedChildren addLast: each]].
	^selectedChildren size == 1
		ifTrue: [selectedChildren first whichNodeIsContainedBy: anInterval]
		ifFalse: [nil]!

whoDefines: aName 
	^(self defines: aName) 
		ifTrue: [self]
		ifFalse: [parent notNil ifTrue: [parent whoDefines: aName] ifFalse: [nil]]! !

!Kernel.StProgramNode categoriesForMethods!
acceptVisitor:!public!visitor! !
addComments:!accessing!public! !
addStatementCommentsTo:!helpers!private! !
allArgumentVariableNodesDo:!enumerating!public! !
allArgumentVariables!accessing!public! !
allChildrenDo:!enumerating!public! !
allDefinedVariableNodes!accessing!public! !
allDefinedVariableNodesDo:!enumerating!public! !
allDefinedVariables!accessing!public! !
allSubNodes!accessing!public! !
allTemporaryVariableNodes!accessing!public! !
allTemporaryVariableNodesDo:!enumerating!public! !
allTemporaryVariables!accessing!public! !
assigns:!public!testing! !
basicMethodNode!accessing!private! !
bestNodeFor:!public!querying! !
blockVariables!accessing!public! !
children!accessing!public! !
childrenDo:!accessing!public! !
collect:!enumerating!public! !
comments!accessing!public! !
comments:!accessing!public! !
containedBy:!public!testing! !
containsReturn!public!testing! !
copyCommentsFrom:!copying!public! !
defines:!public!testing! !
directlyUses:!public!testing! !
displayOn:!printing!public! !
do:!enumerating!public! !
environment!accessing!public! !
equalTo:exceptForVariables:!comparing!public! !
evaluatedFirst:!public!testing! !
formattedCode!accessing!public! !
formatterClass!accessing!public! !
hashForCollection:!comparing!private! !
intersectsInterval:!public!testing! !
isAnnotation!public!testing! !
isAssignment!public!testing! !
isBlock!public!testing! !
isCascade!public!testing! !
isDirectlyUsed!public!testing! !
isDynamicArray!public!testing! !
isEvaluatedFirst!public!testing! !
isImmediateNode!public!testing! !
isInStaticExpression!private!testing! !
isLast:!public!testing! !
isList!public!testing/matching! !
isLiteralArray!public!testing! !
isLiteralNode!public!testing! !
isMessage!public!testing! !
isMethod!public!testing! !
isQualifiedReference!public!testing! !
isReturn!public!testing! !
isSelfVariable!public!testing! !
isSequence!public!testing! !
isSpecialVariable!public!testing! !
isStaticExpressionNode!public!testing! !
isSuperVariable!public!testing! !
isTag!public!testing! !
isUsed!public!testing! !
isValue!public!testing! !
isVariable!public!testing! !
lastIsReturn!public!testing! !
literalCharacter!meta variable/accessing!public! !
makeTreeImmutable!operations!public! !
methodClass!accessing!public! !
methodComments!accessing!public! !
methodNode!accessing!public! !
newSource!accessing!public! !
nodesDo:!enumerating!public! !
outer!accessing!public! !
parent!accessing!public! !
parent:!accessing!public! !
postCopy!copying!public! !
precedence!accessing!public! !
printOn:!printing!public! !
recurseInto!public!testing/matching! !
recurseIntoCharacter!meta variable/accessing!public! !
refersToSymbol:!public! !
scope!accessing!public! !
scope:!accessing!public! !
sentMessages!accessing!public! !
size!enumerating!public! !
source!accessing!public! !
sourceCode!accessing!public! !
sourceInterval!accessing!public! !
start!accessing!public! !
startWithoutParentheses!accessing!public! !
statementCharacter!meta variable/accessing!public! !
statementComments!accessing!public! !
statementNode!public!querying! !
stop!accessing!public! !
temporaryVariables!accessing!public! !
uses:!public!testing! !
whichNodeIsContainedBy:!public!querying! !
whoDefines:!public!querying! !
!

!Kernel.StProgramNode class methodsFor!

defaultFormatterClass
	^Smalltalk developmentSystem formatterClass!

formatterClass
	^FormatterClass ifNil: [self defaultFormatterClass]!

formatterClass: aClass 
	FormatterClass := aClass!

initialize
	"Selectors with block arguments or receiver's that are essentially control structures and inlined by the compiler."

	| inlinedBlockSelectors |
	inlinedBlockSelectors := #(#ifTrue: #ifTrue:ifFalse: #ifFalse: #ifFalse:ifTrue: #whileTrue: #whileTrue #whileFalse: #whileFalse #to:do: #to:by:do: #and: #or: #repeat #ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil:).
	self addClassConstant: 'InlinedBlockSelectors' value: inlinedBlockSelectors.
	self addClassConstant: 'OptimizedSelectors' value: (inlinedBlockSelectors copyWith: #yourself)!

inlinedBlockSelectors
	"Selectors with block arguments or receiver's that are essentially control structures and inlined by the compiler."

	^InlinedBlockSelectors!

optimizedSelectors
	^OptimizedSelectors! !

!Kernel.StProgramNode class categoriesForMethods!
defaultFormatterClass!constants!public! !
formatterClass!accessing!public! !
formatterClass:!accessing!public! !
initialize!class initialization!development!public! !
inlinedBlockSelectors!constants!public! !
optimizedSelectors!constants!public! !
!

