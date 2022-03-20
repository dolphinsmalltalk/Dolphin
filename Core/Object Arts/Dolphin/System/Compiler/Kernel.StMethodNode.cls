"Filed out from Dolphin Smalltalk"!

Kernel.StProgramNode subclass: #'Kernel.StMethodNode'
	instanceVariableNames: 'selector selectorParts body source arguments tags replacements nodeReplacements methodClass environment'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StMethodNode guid: (Core.GUID fromString: '{a10b25e1-f065-457c-90d9-2571ebf23f51}')!
Kernel.StMethodNode comment: 'StMethodNode is the parse tree node type that represents a Smalltalk method.

Instance Variables:
	arguments	<SequenceableCollection> of <StVariableNode>	the arguments to the method
	body	<StSequenceNode>	the body/statements of the method
	selector	<Symbol | nil>	the method name (cached)
	selectorParts	<SequenceableCollection> of <StValueToken>	the tokens for the selector keywords
	source	<String>	the source we compiled
	tag	<Interval | nil>	the source location of any resource/primitive tags

'!
!Kernel.StMethodNode categoriesForClass!System-Compiler! !
!Kernel.StMethodNode methodsFor!

= anObject
	| count his |
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	(self selector = anObject selector and: [body = anObject body]) ifFalse: [^false].
	(count := arguments size) == (his := anObject arguments) size ifFalse: [^false].
	1 to: count do: [:i | (arguments at: i) = (his at: i) ifFalse: [^false]].
	(count := tags size) == (his := anObject tags) size ifFalse: [^false].
	1 to: count do: [:i | (tags at: i) = (his at: i) ifFalse: [^false]].
	^true!

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

basicMethodNode
	^self!

body
	^body!

body: stmtsNode 
	body := stmtsNode.
	body parent: self!

buildSelector
	| selectorStream symbol |
	selectorStream := WriteStream on: (Utf8String new: 50).
	selectorParts do: [:each | selectorStream nextPutAll: each value].
	symbol := selectorStream contents asSymbol.
	self setSelector: symbol.
	^symbol!

childrenDo: aMonadicValuable
	arguments do: aMonadicValuable.
	tags ifNotNil: [tags do: aMonadicValuable].
	aMonadicValuable value: body!

defines: aName 
	^arguments anySatisfy: [:each | each name = aName]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	methodClass
		ifNil: [aPuttableStream nextPutAll: 'Method']
		ifNotNil: 
			[aPuttableStream
				print: methodClass;
				nextPutAll: '>>';
				print: self selector]!

environment
	^environment ifNil: [methodClass environment]!

environment: aNamespace
	environment := aNamespace!

fullBindingFor: aString
	"Answer a variable binding for the named variable in the scope of this method, and failing that in the receiver's environment. If there is no such variable, then answer nil."

	^methodClass fullBindingFor: aString environment: self environment!

hash
	^(self selector hash bitXor: self body hash) bitXor: self arguments hash!

isExternalCall
	^tags notNil and: [tags isExternalCall]!

isInlined
	^false!

isLast: aNode 
	^body isLast: aNode!

isMethod
	^true!

isPrimitive
	^tags notNil and: [tags anySatisfy: [:each | each isAnnotation not]]!

keywords
	^selectorParts collect: [:each | each value]!

lastIsReturn
	^body lastIsReturn!

methodClass
	^methodClass!

methodClass: each
	self methodClass: each environment: nil.
	scope ifNotNil: [scope outer: self newClassScope]!

methodClass: aClass environment: aNamespaceOrNil
	methodClass := aClass.
	environment := aNamespaceOrNil!

methodComments
	| methodComments |
	methodComments := OrderedCollection withAll: self comments.
	arguments do: [:each | methodComments addAll: each comments].
	^methodComments sort: [:a :b | a first < b first]!

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
	tags ifNotNil: [self tags: (tags collect: [:each | each copy])].
	self arguments: (arguments collect: [:each | each copy]).
	^self!

printOn: aStream 
	aStream nextPutAll: self formattedCode!

selector
	^selector ifNil: [self buildSelector]!

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
					[keywords first lastCodeUnit == $:
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

setSelector: aSymbol
	<mutable>
	selector := aSymbol!

source
	^source!

source: anObject
	source := anObject!

start
	^1!

stop
	^source size!

tags
	^tags ?? #()!

tags: aSequencedReadableCollection
	tags := aSequencedReadableCollection.
	tags do: [:each | each parent: self]!

uses: aNode 
	^body == aNode and: [aNode lastIsReturn]! !
!Kernel.StMethodNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
actualScope!accessing!public! !
allArgumentVariableNodesDo:!accessing!public! !
allDefinedVariableNodesDo:!accessing!public! !
argumentCount!accessing!public! !
argumentNames!accessing!public! !
arguments!accessing!public! !
arguments:!accessing!public! !
basicMethodNode!accessing!private! !
body!accessing!public! !
body:!accessing!public! !
buildSelector!helpers!private! !
childrenDo:!accessing!public! !
defines:!public!testing! !
displayOn:!printing!public! !
environment!accessing!public! !
environment:!accessing!public! !
fullBindingFor:!binding!public! !
hash!comparing!public! !
isExternalCall!public!testing! !
isInlined!public!testing! !
isLast:!public!testing! !
isMethod!public!testing! !
isPrimitive!public!testing! !
keywords!accessing!public! !
lastIsReturn!public!testing! !
methodClass!accessing!public! !
methodClass:!accessing!public! !
methodClass:environment:!initializing!private! !
methodComments!accessing!public! !
methodNode!accessing!public! !
numArgs!accessing!public! !
outer!accessing!public! !
postCopy!copying!public! !
printOn:!printing!public! !
selector!accessing!public! !
selector:!accessing!public! !
selectorParts!accessing!private! !
selectorParts:!accessing!private! !
selectorParts:arguments:!initializing!public! !
setSelector:!initializing!private! !
source!accessing!public! !
source:!accessing!public! !
start!accessing!public! !
stop!accessing!public! !
tags!accessing!public! !
tags:!accessing!private! !
uses:!public!testing! !
!

!Kernel.StMethodNode class methodsFor!

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
!Kernel.StMethodNode class categoriesForMethods!
new!instance creation!public! !
selector:arguments:body:!instance creation!public! !
selector:body:!instance creation!public! !
selectorParts:arguments:!instance creation!public! !
!

