"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Refactoring subclass: #'Refactory.Browser.ExpandReferencedPoolsRefactoring'
	instanceVariableNames: 'pools fromClass parseTree toClasses'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ExpandReferencedPoolsRefactoring guid: (Core.GUID fromString: '{5567e549-3f11-4042-99cd-794dab099550}')!
Refactory.Browser.ExpandReferencedPoolsRefactoring comment: 'ExpandReferencedPoolsRefactoring is a refactoring that expands a PoolDictionary''s scope for a method that is being moved from one class to another. This refactoring is primarily used to support other, more complicated refactorings such as MoveMethod.

Instance Variables:
	fromClass	<RBClass>			The class that the method is being moved from.
	parseTree	<BRProgramNode>	The method whose pool references need to be expanded.
	pools	<Collection of: Symbol>	The collection of Pool References in parseTree.
	toClasses	<Collection of: RBClass>	The classes into which the pools must be expanded.

'!
!Refactory.Browser.ExpandReferencedPoolsRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.ExpandReferencedPoolsRefactoring methodsFor!

computePoolsToMove
	| poolVariables searcher |
	poolVariables := self poolVariableNamesFor: fromClass.
	pools := Set new.
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
							pool := self whichPoolDefines: varName.
							pool notNil ifTrue: [pools add: pool]]]].
	searcher executeTree: parseTree!

forMethod: aParseTree fromClass: aClass toClasses: classCollection 
	fromClass := self model classFor: aClass.
	parseTree := aParseTree.
	toClasses := classCollection collect: [:each | self model classFor: each]!

hasPoolsToMove
	^pools anySatisfy: 
			[:eachPoolName |
			toClasses anySatisfy: 
					[:eachClass |
					| nonMetaClass |
					nonMetaClass := eachClass nonMetaclass.
					(nonMetaClass importsNamespace: eachPoolName) not]]!

movePool: aSymbol toClass: aClass
	| nonMetaClass |
	nonMetaClass := aClass nonMetaclass.
	(nonMetaClass importsNamespace: aSymbol) ifFalse: [nonMetaClass addImport: aSymbol]!

movePoolVariables
	pools 
		do: [:poolDict | toClasses do: [:each | self movePool: poolDict toClass: each]]!

poolVariableNamesIn: poolName
	^(poolName asQualifiedReference valueOrNil ifNil: [Dictionary new]) keys
		collect: [:name | name asString]!

preconditions
	^RBCondition empty!

transform
	self computePoolsToMove.
	self hasPoolsToMove 
		ifTrue: 
			[self 
				refactoringWarning: 'This method contains references to pools<n>which may need to be moved.' 
						expandMacros].
	self movePoolVariables!

whichPoolDefines: varName
	| currentClass |
	currentClass := fromClass.
	[currentClass isNil] whileFalse: 
			[currentClass allImports
				do: [:each | ((self poolVariableNamesIn: each) includes: varName) ifTrue: [^each]].
			currentClass := currentClass superclass].
	^nil! !
!Refactory.Browser.ExpandReferencedPoolsRefactoring categoriesFor: #computePoolsToMove!public!transforming! !
!Refactory.Browser.ExpandReferencedPoolsRefactoring categoriesFor: #forMethod:fromClass:toClasses:!initialize/release!public! !
!Refactory.Browser.ExpandReferencedPoolsRefactoring categoriesFor: #hasPoolsToMove!public!testing! !
!Refactory.Browser.ExpandReferencedPoolsRefactoring categoriesFor: #movePool:toClass:!public!transforming! !
!Refactory.Browser.ExpandReferencedPoolsRefactoring categoriesFor: #movePoolVariables!public!transforming! !
!Refactory.Browser.ExpandReferencedPoolsRefactoring categoriesFor: #poolVariableNamesIn:!public!transforming! !
!Refactory.Browser.ExpandReferencedPoolsRefactoring categoriesFor: #preconditions!preconditions!public! !
!Refactory.Browser.ExpandReferencedPoolsRefactoring categoriesFor: #transform!public!transforming! !
!Refactory.Browser.ExpandReferencedPoolsRefactoring categoriesFor: #whichPoolDefines:!public!transforming! !

!Refactory.Browser.ExpandReferencedPoolsRefactoring class methodsFor!

forMethod: aParseTree fromClass: aClass toClasses: classCollection 
	^(self new)
		forMethod: aParseTree
			fromClass: aClass
			toClasses: classCollection;
		yourself!

model: aRBNamespace forMethod: aParseTree fromClass: aClass toClasses: classCollection 
	^(self new)
		model: aRBNamespace;
		forMethod: aParseTree
			fromClass: aClass
			toClasses: classCollection;
		yourself! !
!Refactory.Browser.ExpandReferencedPoolsRefactoring class categoriesFor: #forMethod:fromClass:toClasses:!instance creation!public! !
!Refactory.Browser.ExpandReferencedPoolsRefactoring class categoriesFor: #model:forMethod:fromClass:toClasses:!instance creation!public! !

