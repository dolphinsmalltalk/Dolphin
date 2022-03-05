"Filed out from Dolphin Smalltalk"!

StProgramNode subclass: #StMethodNode
	instanceVariableNames: 'selector selectorParts body source arguments tag replacements nodeReplacements methodClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StMethodNode guid: (GUID fromString: '{a10b25e1-f065-457c-90d9-2571ebf23f51}')!
StMethodNode comment: 'StMethodNode is the parse tree node type that represents a Smalltalk method.

Instance Variables:
	arguments	<SequenceableCollection> of <StVariableNode>	the arguments to the method
	body	<StSequenceNode>	the body/statements of the method
	selector	<Symbol | nil>	the method name (cached)
	selectorParts	<SequenceableCollection> of <StValueToken>	the tokens for the selector keywords
	source	<String>	the source we compiled
	tag	<Interval | nil>	the source location of any resource/primitive tags

'!
!StMethodNode categoriesForClass!System-Compiler! !
!StMethodNode methodsFor!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	(self selector = anObject selector and: [self body = anObject body]) ifFalse: [^false].
	1 to: self arguments size
		do: [:i | (self arguments at: i) = (anObject arguments at: i) ifFalse: [^false]].
	^self tag = anObject tag!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitMethodNode: self!

actualScope
	"Answer the actual scope in which this nodes variables will be defined."

	^self!

allArgumentVariableNodesDo: aMonadicValuable
	self arguments do: aMonadicValuable.
	super allArgumentVariableNodesDo: aMonadicValuable!

allDefinedVariableNodesDo: aMonadicValuable
	self arguments do: aMonadicValuable.
	super allDefinedVariableNodesDo: aMonadicValuable!

argumentCount
	^arguments size!

argumentNames
	^self arguments collect: [:each | each name]!

arguments
	^arguments!

arguments: variableNodes 
	arguments := variableNodes.
	arguments do: [:each | each parent: self]!

body
	^body!

body: stmtsNode 
	body := stmtsNode.
	body parent: self!

buildSelector
	| selectorStream |
	selectorStream := WriteStream on: (Utf8String new: 50).
	selectorParts do: [:each | selectorStream nextPutAll: each value].
	^selectorStream contents asSymbol!

childrenDo: aMonadicValuable 
	self arguments do: aMonadicValuable.
	aMonadicValuable value: self body!

defines: aName 
	^arguments anySatisfy: [:each | each name = aName]!

displayOn: aStream
	aStream nextPutAll: 'Method'!

hash
	^(self selector hash bitXor: self body hash) bitXor: self arguments hash!

isExternalCall
	^tag notNil and: [tag isExternalCall]!

isInlined
	^false!

isLast: aNode 
	^body isLast: aNode!

isMethod
	^true!

isPrimitive
	#rbFix.	"On Dolphin primitives are parsed into an AST, so the tag is actually a node"
	^tag notNil!

lastIsReturn
	^body lastIsReturn!

methodClass
	^methodClass!

methodClass: aClass 
	methodClass := aClass!

methodComments
	| methodComments |
	methodComments := OrderedCollection withAll: self comments.
	arguments do: [:each | methodComments addAll: each comments].
	^methodComments asSortedCollection: [:a :b | a first < b first]!

methodNode
	^self!

numArgs
	^self argumentCount!

outer
	"Answer the <StMethodNode> or <StBlockNode> being the scope in which this node exists."

	^self!

postCopy
	super postCopy.
	self body: body copy.
	self arguments: (arguments collect: [:each | each copy]).
	^self!

printOn: aStream 
	aStream nextPutAll: self formattedCode!

selector
	^selector ifNil: [selector := self buildSelector]!

selector: aSelector
	| keywords numArgs |
	keywords := aSelector keywords.
	numArgs := aSelector argumentCount.
	numArgs == arguments size
		ifFalse: [self error: 'Attempting to assign selector with wrong number of arguments.'].
	selectorParts := numArgs == 0
				ifTrue: [{StIdentifierToken
							start: nil
							comments: nil
							value: keywords first}]
				ifFalse: 
					[keywords first last == $:
						ifTrue: 
							[keywords collect: 
									[:each |
									StKeywordToken
										start: nil
										comments: nil
										value: each]]
						ifFalse: 
							[{StBinarySelectorToken
									start: nil
									comments: nil
									value: aSelector}]].
	selector := aSelector!

selectorParts
	^selectorParts!

selectorParts: tokenCollection 
	selectorParts := tokenCollection!

selectorParts: tokenCollection arguments: variableNodes 
	selectorParts := tokenCollection.
	self arguments: variableNodes!

source
	^source!

source: anObject
	source := anObject!

start
	^1!

stop
	^source size!

tag
	^tag!

tag: anStTagNodeOrNil 
	tag := anStTagNodeOrNil!

uses: aNode 
	^body == aNode and: [aNode lastIsReturn]! !
!StMethodNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
actualScope!public! !
allArgumentVariableNodesDo:!accessing!public! !
allDefinedVariableNodesDo:!accessing!public! !
argumentCount!accessing!public! !
argumentNames!accessing!public! !
arguments!accessing!public! !
arguments:!accessing!public! !
body!accessing!public! !
body:!accessing!public! !
buildSelector!helpers!private! !
childrenDo:!accessing!public! !
defines:!public!testing! !
displayOn:!printing!public! !
hash!comparing!public! !
isExternalCall!public!testing! !
isInlined!public!testing! !
isLast:!public!testing! !
isMethod!public!testing! !
isPrimitive!public!testing! !
lastIsReturn!public!testing! !
methodClass!accessing!public! !
methodClass:!accessing!public! !
methodComments!accessing!public! !
methodNode!accessing!public! !
numArgs!accessing!public! !
outer!public! !
postCopy!copying!public! !
printOn:!printing!public! !
selector!accessing!public! !
selector:!accessing!public! !
selectorParts!accessing!private! !
selectorParts:!accessing!private! !
selectorParts:arguments:!initializing!public! !
source!accessing!public! !
source:!accessing!public! !
start!accessing!public! !
stop!accessing!public! !
tag!accessing!public! !
tag:!accessing!private! !
uses:!public!testing! !
!

!StMethodNode class methodsFor!

new
	^(super new)
		initialize;
		yourself!

selector: aSymbol arguments: variableNodes body: aSequenceNode 
	^(self new)
		arguments: variableNodes;
		selector: aSymbol;
		body: aSequenceNode;
		yourself!

selector: aSymbol body: aSequenceNode 
	^self 
		selector: aSymbol
		arguments: #()
		body: aSequenceNode!

selectorParts: tokenCollection arguments: variableNodes 
	^(self new)
		selectorParts: tokenCollection arguments: variableNodes;
		yourself! !
!StMethodNode class categoriesForMethods!
new!instance creation!public! !
selector:arguments:body:!instance creation!public! !
selector:body:!instance creation!public! !
selectorParts:arguments:!instance creation!public! !
!

