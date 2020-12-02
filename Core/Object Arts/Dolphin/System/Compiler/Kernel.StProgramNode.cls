"Filed out from Dolphin Smalltalk 7"!

Object subclass: #StProgramNode
	instanceVariableNames: 'parent comments'
	classVariableNames: 'FormatterClass SuperSearch'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'InlinedBlockSelectors' -> #(#ifTrue: #ifTrue:ifFalse: #ifFalse: #ifFalse:ifTrue: #whileTrue: #whileTrue #whileFalse: #whileFalse #to:do: #to:by:do: #and: #or: #repeat #ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil:).
		'OptimizedSelectors' -> #(#ifTrue: #ifTrue:ifFalse: #ifFalse: #ifFalse:ifTrue: #whileTrue: #whileTrue #whileFalse: #whileFalse #to:do: #to:by:do: #and: #or: #repeat #ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil: #yourself)
	}!
StProgramNode guid: (GUID fromString: '{3e45084e-5de8-40c0-b448-c53339a17b52}')!
StProgramNode isAbstract: true!
StProgramNode comment: 'StProgramNode is an abstract class that represents a parse tree node in a Smalltalk program.

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
!StProgramNode categoriesForClass!System-Compiler! !
!StProgramNode methodsFor!

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

cascadeListCharacter
	^$;!

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
	self nodesDo: [:each | each comments do: [:comment | newComments remove: comment ifAbsent: []]].
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

equalTo: aNode exceptForVariables: variableNameCollection 
	| dictionary |
	dictionary := Dictionary new.
	(self equalTo: aNode withMapping: dictionary) ifFalse: [^false].
	dictionary keysAndValuesDo: 
			[:key :value | 
			(key = value or: [variableNameCollection includes: key]) ifFalse: [^false]].
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

isPatternNode
	^false!

isQualifiedReference
	^false!

isReturn
	^false!

isSelfVariable
	"Answer whether the variable described by the receiver is the special variables 'super'."

	^false!

isSequence
	^false!

isSpecialVariable
	"Answer whether the variable described by the receiver is one of the special (aka pseudo) variables 'self', 'super' or 'thisContext'."

	^false!

isSuperVariable
	"Answer whether the variable described by the receiver is the special variables 'super'."

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

listCharacter
	^$@!

literalCharacter
	^$#!

methodComments
	^self comments!

methodNode
	^parent isNil ifTrue: [nil] ifFalse: [parent methodNode]!

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

parent: anStProgramNode 
	parent := anStProgramNode!

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
	^statementComments asSortedCollection: [:a :b | a first < b first]!

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
	self childrenDo: [:each | (each intersectsInterval: anInterval) ifTrue: [selectedChildren addLast: each]].
	^selectedChildren size == 1 
		ifTrue: [selectedChildren first whichNodeIsContainedBy: anInterval]
		ifFalse: [nil]!

whoDefines: aName 
	^(self defines: aName) 
		ifTrue: [self]
		ifFalse: [parent notNil ifTrue: [parent whoDefines: aName] ifFalse: [nil]]! !
!StProgramNode categoriesFor: #acceptVisitor:!public!visitor! !
!StProgramNode categoriesFor: #addComments:!accessing!public! !
!StProgramNode categoriesFor: #addStatementCommentsTo:!helpers!private! !
!StProgramNode categoriesFor: #allArgumentVariableNodesDo:!enumerating!public! !
!StProgramNode categoriesFor: #allArgumentVariables!accessing!public! !
!StProgramNode categoriesFor: #allDefinedVariableNodes!accessing!public! !
!StProgramNode categoriesFor: #allDefinedVariableNodesDo:!enumerating!public! !
!StProgramNode categoriesFor: #allDefinedVariables!accessing!public! !
!StProgramNode categoriesFor: #allTemporaryVariableNodes!accessing!public! !
!StProgramNode categoriesFor: #allTemporaryVariableNodesDo:!enumerating!public! !
!StProgramNode categoriesFor: #allTemporaryVariables!accessing!public! !
!StProgramNode categoriesFor: #assigns:!public!testing! !
!StProgramNode categoriesFor: #bestNodeFor:!public!querying! !
!StProgramNode categoriesFor: #blockVariables!accessing!public! !
!StProgramNode categoriesFor: #cascadeListCharacter!meta variable/accessing!public! !
!StProgramNode categoriesFor: #children!accessing!public! !
!StProgramNode categoriesFor: #childrenDo:!accessing!public! !
!StProgramNode categoriesFor: #collect:!enumerating!public! !
!StProgramNode categoriesFor: #comments!accessing!public! !
!StProgramNode categoriesFor: #comments:!accessing!public! !
!StProgramNode categoriesFor: #containedBy:!public!testing! !
!StProgramNode categoriesFor: #containsReturn!public!testing! !
!StProgramNode categoriesFor: #copyCommentsFrom:!copying!public! !
!StProgramNode categoriesFor: #defines:!public!testing! !
!StProgramNode categoriesFor: #directlyUses:!public!testing! !
!StProgramNode categoriesFor: #displayOn:!printing!public! !
!StProgramNode categoriesFor: #do:!enumerating!public! !
!StProgramNode categoriesFor: #equalTo:exceptForVariables:!comparing!public! !
!StProgramNode categoriesFor: #evaluatedFirst:!public!testing! !
!StProgramNode categoriesFor: #formattedCode!accessing!public! !
!StProgramNode categoriesFor: #formatterClass!accessing!public! !
!StProgramNode categoriesFor: #hashForCollection:!comparing!private! !
!StProgramNode categoriesFor: #intersectsInterval:!public!testing! !
!StProgramNode categoriesFor: #isAssignment!public!testing! !
!StProgramNode categoriesFor: #isBlock!public!testing! !
!StProgramNode categoriesFor: #isCascade!public!testing! !
!StProgramNode categoriesFor: #isDirectlyUsed!public!testing! !
!StProgramNode categoriesFor: #isDynamicArray!public!testing! !
!StProgramNode categoriesFor: #isEvaluatedFirst!public!testing! !
!StProgramNode categoriesFor: #isImmediateNode!public!testing! !
!StProgramNode categoriesFor: #isLast:!public!testing! !
!StProgramNode categoriesFor: #isList!public!testing/matching! !
!StProgramNode categoriesFor: #isLiteralArray!public!testing! !
!StProgramNode categoriesFor: #isLiteralNode!public!testing! !
!StProgramNode categoriesFor: #isMessage!public!testing! !
!StProgramNode categoriesFor: #isMethod!public!testing! !
!StProgramNode categoriesFor: #isPatternNode!public!testing/matching! !
!StProgramNode categoriesFor: #isQualifiedReference!public!testing! !
!StProgramNode categoriesFor: #isReturn!public!testing! !
!StProgramNode categoriesFor: #isSelfVariable!public!testing! !
!StProgramNode categoriesFor: #isSequence!public!testing! !
!StProgramNode categoriesFor: #isSpecialVariable!public!testing! !
!StProgramNode categoriesFor: #isSuperVariable!public!testing! !
!StProgramNode categoriesFor: #isUsed!public!testing! !
!StProgramNode categoriesFor: #isValue!public!testing! !
!StProgramNode categoriesFor: #isVariable!public!testing! !
!StProgramNode categoriesFor: #lastIsReturn!public!testing! !
!StProgramNode categoriesFor: #listCharacter!meta variable/accessing!public! !
!StProgramNode categoriesFor: #literalCharacter!meta variable/accessing!public! !
!StProgramNode categoriesFor: #methodComments!accessing!public! !
!StProgramNode categoriesFor: #methodNode!accessing!public! !
!StProgramNode categoriesFor: #newSource!accessing!public! !
!StProgramNode categoriesFor: #nodesDo:!iterating!public! !
!StProgramNode categoriesFor: #outer!public! !
!StProgramNode categoriesFor: #parent!accessing!public! !
!StProgramNode categoriesFor: #parent:!accessing!public! !
!StProgramNode categoriesFor: #postCopy!copying!public! !
!StProgramNode categoriesFor: #precedence!accessing!public! !
!StProgramNode categoriesFor: #printOn:!printing!public! !
!StProgramNode categoriesFor: #recurseInto!public!testing/matching! !
!StProgramNode categoriesFor: #recurseIntoCharacter!meta variable/accessing!public! !
!StProgramNode categoriesFor: #sentMessages!accessing!public! !
!StProgramNode categoriesFor: #size!enumerating!public! !
!StProgramNode categoriesFor: #source!accessing!public! !
!StProgramNode categoriesFor: #sourceInterval!accessing!public! !
!StProgramNode categoriesFor: #start!accessing!public! !
!StProgramNode categoriesFor: #startWithoutParentheses!accessing!public! !
!StProgramNode categoriesFor: #statementCharacter!meta variable/accessing!public! !
!StProgramNode categoriesFor: #statementComments!accessing!public! !
!StProgramNode categoriesFor: #statementNode!public!querying! !
!StProgramNode categoriesFor: #stop!accessing!public! !
!StProgramNode categoriesFor: #temporaryVariables!accessing!public! !
!StProgramNode categoriesFor: #uses:!public!testing! !
!StProgramNode categoriesFor: #whichNodeIsContainedBy:!public!querying! !
!StProgramNode categoriesFor: #whoDefines:!public!querying! !

!StProgramNode class methodsFor!

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
!StProgramNode class categoriesFor: #defaultFormatterClass!constants!public! !
!StProgramNode class categoriesFor: #formatterClass!accessing!public! !
!StProgramNode class categoriesFor: #formatterClass:!accessing!public! !
!StProgramNode class categoriesFor: #initialize!class initialization!development!public! !
!StProgramNode class categoriesFor: #inlinedBlockSelectors!constants!public! !
!StProgramNode class categoriesFor: #optimizedSelectors!constants!public! !

