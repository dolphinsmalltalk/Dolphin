"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Refactoring subclass: #'Refactory.Browser.AbstractVariablesRefactoring'
	instanceVariableNames: 'tree fromClass instVarReaders instVarWriters classVarReaders classVarWriters toClasses ignore'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AbstractVariablesRefactoring guid: (Core.GUID fromString: '{4693691a-7a7d-4b15-a3e9-c4c5554aa27e}')!
Refactory.Browser.AbstractVariablesRefactoring comment: ''!
!Refactory.Browser.AbstractVariablesRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.AbstractVariablesRefactoring methodsFor!

abstractClassVariable: aString
	| refactoring rewriter nonMetaClass |
	nonMetaClass := fromClass nonMetaclass.
	refactoring := CreateAccessorsForVariableRefactoring
				model: self model
				variable: aString
				class: nonMetaClass
				classVariable: true.
	self performComponentRefactoring: refactoring.
	rewriter := ParseTreeRewriter new.
	fromClass isMeta
		ifTrue: 
			[rewriter
				replace: aString , ' := ``@object'
					with: ('self <1s> ``@object' expandMacrosWith: refactoring setterMethod);
				replace: aString with: 'self ' , refactoring getterMethod]
		ifFalse: 
			[rewriter
				replace: aString , ' := ``@object'
					with: ('self class <1s> ``@object' expandMacrosWith: refactoring setterMethod);
				replace: aString with: 'self class ' , refactoring getterMethod].
	(rewriter executeTree: tree) ifTrue: [tree := rewriter tree]!

abstractClassVariables
	| variables |
	classVarReaders isEmpty & classVarWriters isEmpty ifTrue: [^self].
	variables := Set new.
	variables
		addAll: classVarReaders;
		addAll: classVarWriters.
	variables do: [:each | self abstractClassVariable: each]!

abstractInstanceVariable: aString
	| refactoring rewriter |
	refactoring := CreateAccessorsForVariableRefactoring
				model: self model
				variable: aString
				class: fromClass
				classVariable: false.
	self performComponentRefactoring: refactoring.
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: aString , ' := ``@object'
			with: ('self <1s> ``@object' expandMacrosWith: refactoring setterMethod);
		replace: aString with: 'self ' , refactoring getterMethod.
	(rewriter executeTree: tree) ifTrue: [tree := rewriter tree]!

abstractInstanceVariables
	| variables |
	instVarReaders isEmpty & instVarWriters isEmpty ifTrue: [^self].
	variables := Set new.
	variables
		addAll: instVarReaders;
		addAll: instVarWriters.
	variables do: [:each | self abstractInstanceVariable: each]!

abstractVariablesIn: aBRProgramNode from: fromBehavior toAll: behaviorCollection ignoring: aVariableName
	| poolRefactoring |
	tree := aBRProgramNode.
	fromClass := self classObjectFor: fromBehavior.
	toClasses := behaviorCollection collect: [:each | self classObjectFor: each].
	ignore := aVariableName.
	poolRefactoring := ExpandReferencedPoolsRefactoring
				model: self model
				forMethod: tree
				fromClass: fromClass
				toClasses: toClasses.
	self performComponentRefactoring: poolRefactoring.
	self computeVariablesToAbstract!

classVariableNames
	| nonMetaClass |
	nonMetaClass := fromClass nonMetaclass.
	^(nonMetaClass allClassVariableNames collect: [:each | each asString]) asSet!

computeVariablesToAbstract
	| searcher |
	instVarReaders := Set new.
	instVarWriters := Set new.
	classVarReaders := Set new.
	classVarWriters := Set new.
	searcher := ParseTreeSearcher new.
	searcher
		matches: '`var := ``@anything' do: [:aNode :answer | self processAssignmentNode: aNode];
		matches: '`var' do: [:aNode :answer | self processReferenceNode: aNode].
	searcher executeTree: tree.
	self removeDefinedClassVariables!

hasVariablesToAbstract
	^(instVarReaders isEmpty 
		& instVarWriters isEmpty 
		& classVarReaders isEmpty 
		& classVarWriters isEmpty) 
		not!

instanceVariableNames
	^fromClass allInstanceVariableNames asSet!

parseTree
	^tree!

preconditions
	^RBCondition empty!

processAssignmentNode: aNode 
	| varName |
	varName := aNode variable name.
	ignore = varName ifTrue: [^self].
	(aNode whoDefines: varName) notNil ifTrue: [^self].
	(self instanceVariableNames includes: varName) 
		ifTrue: [instVarWriters add: varName].
	(self classVariableNames includes: varName) 
		ifTrue: [classVarWriters add: varName]!

processReferenceNode: aNode 
	| varName |
	varName := aNode name.
	ignore = varName ifTrue: [^self].
	(aNode whoDefines: varName) notNil ifTrue: [^self].
	(self instanceVariableNames includes: varName) 
		ifTrue: [instVarReaders add: varName].
	(self classVariableNames includes: varName) 
		ifTrue: [classVarReaders add: varName]!

removeDefinedClassVariables
	| selectionBlock nonMetaClass |
	nonMetaClass := fromClass nonMetaclass.
	selectionBlock := 
			[:varName | 
			toClasses anySatisfy: 
					[:each | 
					(each nonMetaclass includesClass: (nonMetaClass whoDefinesClassVariable: varName)) not]].
	classVarReaders := classVarReaders select: selectionBlock.
	classVarWriters := classVarWriters select: selectionBlock!

transform
	self hasVariablesToAbstract 
		ifTrue: 
			[self 
				refactoringWarning: 'This method has direct variable references which<n>will need to be converted to getter/setters.' 
						expandMacros].
	self abstractInstanceVariables.
	self abstractClassVariables! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesFor: #abstractClassVariable:!public!transforming! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesFor: #abstractClassVariables!public!transforming! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesFor: #abstractInstanceVariable:!public!transforming! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesFor: #abstractInstanceVariables!public!transforming! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesFor: #abstractVariablesIn:from:toAll:ignoring:!initialize/release!public! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesFor: #classVariableNames!public!transforming! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesFor: #computeVariablesToAbstract!public!transforming! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesFor: #hasVariablesToAbstract!public!testing! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesFor: #instanceVariableNames!public!transforming! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesFor: #parseTree!accessing!public! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesFor: #preconditions!preconditions!public! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesFor: #processAssignmentNode:!public!transforming! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesFor: #processReferenceNode:!public!transforming! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesFor: #removeDefinedClassVariables!public!transforming! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesFor: #transform!public!transforming! !

!Refactory.Browser.AbstractVariablesRefactoring class methodsFor!

model: aRBNamespace abstractVariablesIn: aBRProgramNode from: fromBehavior toAll: behaviorCollection 
	^self 
		model: aRBNamespace
		abstractVariablesIn: aBRProgramNode
		from: fromBehavior
		toAll: behaviorCollection
		ignoring: nil!

model: aRBNamespace abstractVariablesIn: aBRProgramNode from: fromBehavior toAll: behaviorCollection ignoring: aVariableName 
	^(self new)
		model: aRBNamespace;
		abstractVariablesIn: aBRProgramNode
			from: fromBehavior
			toAll: behaviorCollection
			ignoring: aVariableName;
		yourself! !
!Refactory.Browser.AbstractVariablesRefactoring class categoriesFor: #model:abstractVariablesIn:from:toAll:!instance creation!public! !
!Refactory.Browser.AbstractVariablesRefactoring class categoriesFor: #model:abstractVariablesIn:from:toAll:ignoring:!instance creation!public! !

