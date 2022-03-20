"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Refactory.Browser.RBMethod'
	instanceVariableNames: 'class compiledMethod source selector parseTree hasSourceIntervals'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBMethod guid: (Core.GUID fromString: '{4f76178d-295e-4b31-9cda-d786b96c5ed7}')!
Refactory.Browser.RBMethod comment: 'RBMethod represents a method in an RBAbstractClass.

Instance Variables:
	class	<RBAbstractClass>	where the method is defined
	compiledMethod	<CompiledCode | nil>	the CompiledMethod object (if we have been compiled)
	selector	<Symbol>	our name
	source	<String>	our source'!
!Refactory.Browser.RBMethod categoriesForClass!Refactory-Model! !
!Refactory.Browser.RBMethod methodsFor!

= anObject
	"Answer whether the argument is considered equivalent to the receiver."

	^self == anObject or: 
			[self class == anObject class and: 
					[class == anObject modelClass and: 
							[selector = anObject selector
								and: [self parseTree ifNil: [source = anObject source] ifNotNil: [:ast | ast = anObject parseTree]]]]]!

boundParseTree
	"Answer an <StMethodNode> representing the parse tree for the receiver, with any variable bindings resolved."

	| ast |
	ast := self parseTree.
	ast scope ifNil: [RBVariableAnalyser analyseParseTree: ast].
	^ast!

buildParseTree
	hasSourceIntervals := true.
	^RBParser
		parseMethod: self source
		in: class
		environment: self parseEnvironment
		onError: [:str :pos | ^nil]!

categories
	^class protocolsFor: selector!

environment
	^self boundParseTree environment!

existingPackageAndEnvironment
	^self method
		ifNil: [Pair first: nil second: nil]
		ifNotNil: 
			[:method |
			method owningPackageIfLoose
				ifNil: [Pair first: method methodClass owningPackage second: nil]
				ifNotNil: 
					[:package |
					Pair first: package
						second: (package environment ifNotNil: [:namespace | namespace classInModel: self model])]]!

hash
	"Answer the <SmallInteger> hash value for the receiver."

	^selector hash bitXor: class hash!

method
	^compiledMethod!

methodClass
	^class!

model
	^class model!

modelClass
	^class!

modelClass: anRBClass method: aCompiledMethod
	class := anRBClass.
	compiledMethod := aCompiledMethod.
	selector := aCompiledMethod selector.
	hasSourceIntervals := true.
	^self!

modelClass: aRBClass selector: aSymbol source: aString
	class := aRBClass.
	selector := aSymbol.
	source := aString.
	hasSourceIntervals := true.
	^self!

parseEnvironment
	compiledMethod ifNil: [^nil].
	compiledMethod customEnvironment ifNotNil: [:env | ^env classInModel: self model].
	^compiledMethod owningPackageIfLoose
		ifNotNil: [:package | package environment ifNotNil: [:env | env classInModel: self model]]!

parseTree
	^parseTree ifNil: [parseTree := self buildParseTree]!

parseTree: aStMethodNode 
	parseTree := aStMethodNode.
	source := aStMethodNode newSource.
	"Assume that the parse tree has been rewritten and does not have valid source positions - reparsing will be needed if those are required"
	hasSourceIntervals := false!

parseTreeWithSourceIntervals
	hasSourceIntervals ifFalse: [parseTree := nil].
	^self parseTree!

printOn: aStream
	aStream
		print: class;
		nextPutAll: '>>';
		print: self selector!

refersToBinding: aVariableBinding
	^self boundParseTree refersToBinding: aVariableBinding!

refersToBinding1: aVariableBinding
	| matchBlock |
	matchBlock := [:node :answer | answer or: [node refersToBinding: aVariableBinding]].
	^ParseTreeSearcher new
		matches: '`identifier' do: matchBlock;
		matches: '`#literal' do: matchBlock;
		executeTree: self boundParseTree initialAnswer: false!

refersToClass: aRBClass
	| matchBlock |
	matchBlock := [:node :answer | answer or: [node refersToClass: aRBClass]].
	^ParseTreeSearcher new
		matches: '`identifier' do: matchBlock;
		matches: '`#literal' do: matchBlock;
		executeTree: self boundParseTree initialAnswer: false!

refersToSymbol: aSymbol
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`#literal' do: [:node :answer | answer or: [node refersToSymbol: aSymbol]].
	(Scanner isSelector: aSymbol)
		ifTrue: 
			[searcher matches: '`@object ' , (ParseTreeSearcher buildSelectorString: aSymbol)
				do: [:node :answer | true]].
	^searcher executeTree: self parseTree initialAnswer: false!

refersToVariable: aString
	| searcher tree |
	tree := self parseTree.
	((tree defines: aString) or: [tree body defines: aString]) ifTrue: [^false].
	searcher := ParseTreeSearcher new.
	searcher
		matches: aString do: [:node :answer | true];
		matches: '[:`@vars | | `@temps | `@.Stmts]'
			do: 
				[:node :answer |
				answer or: 
						[((node defines: aString) or: [node body defines: aString]) not
							and: [searcher executeTree: node body initialAnswer: false]]].
	^searcher executeTree: self parseTree initialAnswer: false!

selector
	^selector!

source
	^source ifNil: [source := compiledMethod getSource]!

source: aString 
	source = aString ifTrue: [^self].
	"Transcript print: self; nextPutAll: ' source changed'; cr.
	parseTree newSource = aString ifTrue: [self halt]."
	source := aString.
	"We must clear the cached parse tree"
	parseTree := nil! !
!Refactory.Browser.RBMethod categoriesForMethods!
=!comparing!public! !
boundParseTree!accessing!public! !
buildParseTree!accessing!private! !
categories!public! !
environment!accessing!public! !
existingPackageAndEnvironment!public! !
hash!comparing!public! !
method!accessing!public! !
methodClass!accessing!public! !
model!accessing!public! !
modelClass!accessing!public! !
modelClass:method:!accessing!initializing!private! !
modelClass:selector:source:!initializing!private! !
parseEnvironment!accessing!private! !
parseTree!accessing!public! !
parseTree:!public! !
parseTreeWithSourceIntervals!accessing!public! !
printOn:!printing!public! !
refersToBinding:!public!testing! !
refersToBinding1:!public!testing! !
refersToClass:!public!testing! !
refersToSymbol:!public!testing! !
refersToVariable:!public!testing! !
selector!accessing!public! !
source!accessing!public! !
source:!accessing!public! !
!

!Refactory.Browser.RBMethod class methodsFor!

for: aRBClass fromMethod: aCompiledMethod
	^self new modelClass: aRBClass method: aCompiledMethod!

for: aRBClass source: aString selector: aSelector
	^self new
		modelClass: aRBClass
		selector: aSelector
		source: aString! !
!Refactory.Browser.RBMethod class categoriesForMethods!
for:fromMethod:!instance creation!public! !
for:source:selector:!instance creation!public! !
!

