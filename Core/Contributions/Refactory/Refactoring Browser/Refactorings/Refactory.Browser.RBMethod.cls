"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Refactory.Browser.RBMethod'
	instanceVariableNames: 'class compiledMethod source selector parseTree'
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

environment
	^self boundParseTree environment!

hash
	"Answer the <SmallInteger> hash value for the receiver."

	^selector hash bitXor: class hash!

method
	^compiledMethod!

method: aCompiledMethod 
	compiledMethod := aCompiledMethod!

methodClass
	^class!

model
	^class model!

modelClass
	^class!

modelClass: aRBClass
	class := aRBClass!

parseEnvironment
	compiledMethod ifNil: [^nil].
	compiledMethod customEnvironment ifNotNil: [:env | ^env classInModel: self model].
	^compiledMethod owningPackageIfLoose ifNotNil: [:package | package environment]!

parseTree
	^parseTree
		ifNil: 
			[parseTree := RBParser
						parseMethod: self source
						in: class
						environment: self parseEnvironment
						onError: [:str :pos | ^nil]]!

printOn: aStream
	aStream
		print: class;
		nextPutAll: '>>';
		print: self selector!

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

selector: aSymbol 
	selector := aSymbol!

source
	^source ifNil: [source := compiledMethod getSource]!

source: aString 
	source := aString! !
!Refactory.Browser.RBMethod categoriesForMethods!
=!comparing!public! !
boundParseTree!accessing!public! !
environment!accessing!public! !
hash!comparing!public! !
method!accessing!public! !
method:!accessing!public! !
methodClass!accessing!public! !
model!accessing!public! !
modelClass!accessing!public! !
modelClass:!accessing!public! !
parseEnvironment!accessing!private! !
parseTree!accessing!public! !
printOn:!printing!public! !
refersToClass:!public!testing! !
refersToSymbol:!public!testing! !
refersToVariable:!public!testing! !
selector!accessing!public! !
selector:!accessing!public! !
source!accessing!public! !
source:!accessing!public! !
!

!Refactory.Browser.RBMethod class methodsFor!

for: aRBClass fromMethod: aCompiledMethod andSelector: aSymbol 
	^(self new)
		modelClass: aRBClass;
		method: aCompiledMethod;
		selector: aSymbol;
		yourself!

for: aRBClass source: aString selector: aSelector 
	^(self new)
		modelClass: aRBClass;
		selector: aSelector;
		source: aString;
		yourself! !
!Refactory.Browser.RBMethod class categoriesForMethods!
for:fromMethod:andSelector:!instance creation!public! !
for:source:selector:!instance creation!public! !
!

