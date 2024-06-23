"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Refactoring
	subclass: #'Refactory.Browser.ExpandImportsRefactoring'
	instanceVariableNames: 'imports fromClass parseTree toClasses isExpanded'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.ExpandImportsRefactoring guid: (Core.GUID fromString: '{5567e549-3f11-4042-99cd-794dab099550}')!

Refactory.Browser.ExpandImportsRefactoring comment: 'ExpandReferencedPoolsRefactoring is a refactoring that expands a PoolDictionary''s scope for a method that is being moved from one class to another. This refactoring is primarily used to support other, more complicated refactorings such as MoveMethod.

Instance Variables:
	fromClass	<RBClass>			The class that the method is being moved from.
	parseTree	<BRProgramNode>	The method whose pool references need to be expanded.
	pools	<Collection of: Symbol>	The collection of Pool References in parseTree.
	toClasses	<Collection of: RBClass>	The classes into which the pools must be expanded.

'!

!Refactory.Browser.ExpandImportsRefactoring categoriesForClass!Refactory-Refactorings! !

!Refactory.Browser.ExpandImportsRefactoring methodsFor!

addImport: aBindingReference toClass: aClass
	(aClass instanceClass importsNamespace: aBindingReference)
		ifFalse: 
			[self performComponentRefactoring: (AddImportRefactoring
						model: self model
						addImport: aBindingReference
						to: aClass)]!

addImports
	imports do: [:bindingRef | toClasses do: [:each | self addImport: bindingRef toClass: each]]!

computeReferencedNamespaces
	| poolVariables searcher |
	poolVariables := self importedVariableNamesFor: fromClass.
	imports := Set new.
	searcher := ParseTreeSearcher new.
	searcher matches: '`var'
		do: 
			[:aNode :answer |
			| varName |
			varName := aNode name.
			(aNode whoDefines: varName) isNil
				ifTrue: 
					[(poolVariables includes: varName)
						ifTrue: 
							[| pool |
							pool := self whichNamespaceDefines: varName.
							pool notNil ifTrue: [imports add: pool]]]].
	searcher executeTree: parseTree.
	imports := imports select: 
					[:each |
					toClasses anySatisfy: [:eachClass | (eachClass instanceClass importsNamespace: each) not]]!

forMethod: aParseTree fromClass: aClass toClasses: classCollection 
	fromClass := self model classFor: aClass.
	parseTree := aParseTree.
	toClasses := classCollection collect: [:each | self model classFor: each]!

isExpanded
	^isExpanded!

preconditions
	^RBCondition empty!

shouldAddImports: aCollection
	^(self lookupOption: #addImports) cull: self cull: aCollection!

transform
	self computeReferencedNamespaces.
	isExpanded := imports isEmpty
				or: [(self shouldAddImports: imports) and: 
							[self addImports.
							true]]!

whichNamespaceDefines: aString
	| currentClass |
	currentClass := fromClass.
	[currentClass isNil] whileFalse: 
			[currentClass allImports do: 
					[:each |
					each valueOrNil
						ifNotNil: [:namespace | (namespace localBindingFor: aString) ifNotNil: [:var | var isClassVariable ifTrue: [^each]]]].
			currentClass := currentClass superclass].
	^nil! !

!Refactory.Browser.ExpandImportsRefactoring categoriesForMethods!
addImport:toClass:!private!transforming! !
addImports!private!transforming! !
computeReferencedNamespaces!private!transforming! !
forMethod:fromClass:toClasses:!initialize/release!public! !
isExpanded!accessing!public! !
preconditions!preconditions!public! !
shouldAddImports:!private!requests! !
transform!public!transforming! !
whichNamespaceDefines:!public!transforming! !
!

!Refactory.Browser.ExpandImportsRefactoring class methodsFor!

forMethod: aParseTree fromClass: aClass toClasses: classCollection 
	^(self new)
		forMethod: aParseTree
			fromClass: aClass
			toClasses: classCollection;
		yourself!

model: aRBModel forMethod: aParseTree fromClass: aClass toClasses: classCollection
	^self new
		model: aRBModel;
		forMethod: aParseTree
			fromClass: aClass
			toClasses: classCollection;
		yourself! !

!Refactory.Browser.ExpandImportsRefactoring class categoriesForMethods!
forMethod:fromClass:toClasses:!instance creation!public! !
model:forMethod:fromClass:toClasses:!instance creation!public! !
!

