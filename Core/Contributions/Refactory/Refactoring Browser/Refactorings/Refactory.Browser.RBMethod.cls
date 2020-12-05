"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Refactory.Browser.RBMethod'
	instanceVariableNames: 'class compiledMethod source selector'
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

literal: anObject containsReferenceTo: aSymbol
	anObject == aSymbol ifTrue: [^true].
	anObject class = Array ifFalse: [^false].
	anObject do: [:each | (self literal: each containsReferenceTo: aSymbol) ifTrue: [^true]].
	^false!

method
	^compiledMethod!

method: aCompiledMethod 
	compiledMethod := aCompiledMethod!

modelClass
	^class!

modelClass: aRBClass
	class := aRBClass!

parseTree
	^RBParser parseMethod: self source in: self modelClass realClass onError: [:str :pos | ^nil]!

printOn: aStream
	aStream
		print: class;
		nextPutAll: '>>';
		print: self selector!

refersToAnySymbol: aCollection
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`#literal'
		do: 
			[:node :answer |
			answer or: 
					[| value |
					value := node value.
					aCollection anySatisfy: [:each | self literal: value containsReferenceTo: each]]].
	aCollection do: 
			[:each |
			(RBScanner isSelector: each)
				ifTrue: 
					[searcher matches: '`@object ' , (ParseTreeSearcher buildSelectorString: each)
						do: [:node :answer | true]]].
	^searcher executeTree: self parseTree initialAnswer: false!

refersToClass: anRBClass
	| searcher names |
	searcher := ParseTreeSearcher new.
	#namespaceToDo.	"Bodge to also search for the unqualified name - this might get hits that are not real matches."
	names := {anRBClass fullName asSymbol. anRBClass unqualifiedName asSymbol}.
	searcher matchesAnyOf: names do: [:node :answer | true].
	^(searcher executeTree: self parseTree initialAnswer: false) or: [self refersToAnySymbol: names]!

refersToSymbol: aSymbol
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`#literal'
		do: [:node :answer | answer or: [self literal: node value containsReferenceTo: aSymbol]].
	(RBScanner isSelector: aSymbol)
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
	^source isNil 
		ifTrue: [source := compiledMethod getSource]
		ifFalse: [source]!

source: aString 
	source := aString! !
!Refactory.Browser.RBMethod categoriesFor: #literal:containsReferenceTo:!private! !
!Refactory.Browser.RBMethod categoriesFor: #method!accessing!public! !
!Refactory.Browser.RBMethod categoriesFor: #method:!accessing!public! !
!Refactory.Browser.RBMethod categoriesFor: #modelClass!accessing!public! !
!Refactory.Browser.RBMethod categoriesFor: #modelClass:!accessing!public! !
!Refactory.Browser.RBMethod categoriesFor: #parseTree!accessing!public! !
!Refactory.Browser.RBMethod categoriesFor: #printOn:!printing!public! !
!Refactory.Browser.RBMethod categoriesFor: #refersToAnySymbol:!public!testing! !
!Refactory.Browser.RBMethod categoriesFor: #refersToClass:!public!testing! !
!Refactory.Browser.RBMethod categoriesFor: #refersToSymbol:!public!testing! !
!Refactory.Browser.RBMethod categoriesFor: #refersToVariable:!public!testing! !
!Refactory.Browser.RBMethod categoriesFor: #selector!accessing!public! !
!Refactory.Browser.RBMethod categoriesFor: #selector:!accessing!public! !
!Refactory.Browser.RBMethod categoriesFor: #source!accessing!public! !
!Refactory.Browser.RBMethod categoriesFor: #source:!accessing!public! !

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
!Refactory.Browser.RBMethod class categoriesFor: #for:fromMethod:andSelector:!instance creation!public! !
!Refactory.Browser.RBMethod class categoriesFor: #for:source:selector:!instance creation!public! !

