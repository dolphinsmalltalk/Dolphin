"Filed out from Dolphin Smalltalk"!

Refactoring subclass: #ExpandReferencedPoolsRefactoring
	instanceVariableNames: 'pools fromClass parseTree toClasses'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExpandReferencedPoolsRefactoring guid: (GUID fromString: '{5567e549-3f11-4042-99cd-794dab099550}')!
ExpandReferencedPoolsRefactoring comment: 'ExpandReferencedPoolsRefactoring is a refactoring that expands a PoolDictionary''s scope for a method that is being moved from one class to another. This refactoring is primarily used to support other, more complicated refactorings such as MoveMethod.

Instance Variables:
	fromClass	<RBClass>			The class that the method is being moved from.
	parseTree	<BRProgramNode>	The method whose pool references need to be expanded.
	pools	<Collection of: Symbol>	The collection of Pool References in parseTree.
	toClasses	<Collection of: RBClass>	The classes into which the pools must be expanded.

'!
!ExpandReferencedPoolsRefactoring categoriesForClass!Refactory-Refactorings! !
!ExpandReferencedPoolsRefactoring methodsFor!

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
					(nonMetaClass definesPoolDictionary: eachPoolName) not]]!

movePool: aSymbol toClass: aClass 
	| nonMetaClass |
	nonMetaClass := aClass nonMetaclass.
	(nonMetaClass definesPoolDictionary: aSymbol) 
		ifFalse: [nonMetaClass addPoolDictionary: aSymbol]!

movePoolVariables
	pools 
		do: [:poolDict | toClasses do: [:each | self movePool: poolDict toClass: each]]!

poolVariableNamesIn: poolName 
	^(Smalltalk at: poolName ifAbsent: [Dictionary new]) keys 
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
			[currentClass allPoolDictionaryNames 
				do: [:each | ((self poolVariableNamesIn: each) includes: varName) ifTrue: [^each]].
			currentClass := currentClass superclass].
	^nil! !
!ExpandReferencedPoolsRefactoring categoriesForMethods!
computePoolsToMove!public!transforming! !
forMethod:fromClass:toClasses:!initialize/release!public! !
hasPoolsToMove!public!testing! !
movePool:toClass:!public!transforming! !
movePoolVariables!public!transforming! !
poolVariableNamesIn:!public!transforming! !
preconditions!preconditions!public! !
transform!public!transforming! !
whichPoolDefines:!public!transforming! !
!

!ExpandReferencedPoolsRefactoring class methodsFor!

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
!ExpandReferencedPoolsRefactoring class categoriesForMethods!
forMethod:fromClass:toClasses:!instance creation!public! !
model:forMethod:fromClass:toClasses:!instance creation!public! !
!

