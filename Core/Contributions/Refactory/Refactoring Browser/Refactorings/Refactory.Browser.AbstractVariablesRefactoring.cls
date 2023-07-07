"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Refactoring
	subclass: #'Refactory.Browser.AbstractVariablesRefactoring'
	instanceVariableNames: 'tree fromClass instVarReaders instVarWriters privateClassVarReaders privateClassVarWriters toClasses ignore'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AbstractVariablesRefactoring guid: (Core.GUID fromString: '{4693691a-7a7d-4b15-a3e9-c4c5554aa27e}')!
Refactory.Browser.AbstractVariablesRefactoring comment: ''!
!Refactory.Browser.AbstractVariablesRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.AbstractVariablesRefactoring methodsFor!

abstractClassVariable: aVariableBinding
	| refactoring rewriter |
	refactoring := CreateAccessorsForVariableRefactoring
				model: model
				variable: aVariableBinding key
				class: fromClass instanceClass
				classVariable: true.
	self performComponentRefactoring: refactoring.
	rewriter := ParseTreeRewriter
				replaceClassVariable: aVariableBinding
				withGetter: refactoring getterMethod
				andSetter: refactoring setterMethod
				forReceiver: (fromClass isMeta ifTrue: ['self'] ifFalse: ['self class']).
	(rewriter executeTree: tree) ifTrue: [tree := rewriter tree]!

abstractClassVariables
	| variables |
	(privateClassVarReaders isEmpty and: [privateClassVarWriters isEmpty]) ifTrue: [^self].
	variables := (Set withAll: privateClassVarReaders)
				addAll: privateClassVarWriters;
				yourself.
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
	(instVarReaders isEmpty and: [instVarWriters isEmpty]) ifTrue: [^self].
	variables := Set new.
	variables
		addAll: instVarReaders;
		addAll: instVarWriters.
	variables do: [:each | self abstractInstanceVariable: each]!

abstractVariablesIn: aBRProgramNode from: fromBehavior toAll: behaviorCollection ignoring: aVariableName
	| importsRefactoring |
	tree := aBRProgramNode.
	fromClass := self classObjectFor: fromBehavior.
	toClasses := behaviorCollection collect: [:each | self classObjectFor: each].
	ignore := aVariableName.
	importsRefactoring := ExpandImportsRefactoring
				model: self model
				forMethod: tree
				fromClass: fromClass
				toClasses: toClasses.
	self performComponentRefactoring: importsRefactoring.
	self computeVariablesToAbstract!

computeVariablesToAbstract
	| searcher |
	instVarReaders := Set new.
	instVarWriters := Set new.
	privateClassVarReaders := Set new.
	privateClassVarWriters := Set new.
	searcher := ParseTreeSearcher new.
	searcher
		matches: '`var := ``@anything' do: [:aNode :answer | self processAssignmentNode: aNode];
		matches: '`var' do: [:aNode :answer | self processReferenceNode: aNode].
	searcher executeTree: tree.
	self removeDefinedClassVariables!

hasVariablesToAbstract
	^(instVarReaders isEmpty and: 
			[instVarWriters isEmpty and: [privateClassVarReaders isEmpty and: [privateClassVarWriters isEmpty]]])
		not!

instanceVariableNames
	^fromClass allInstanceVariableNames asSet!

instVarReaders
	^instVarReaders!

instVarWriters
	^instVarWriters!

parseTree
	^tree!

preconditions
	^RBCondition empty!

privateClassVarReaders
	^privateClassVarReaders!

privateClassVarWriters
	^privateClassVarWriters!

processAssignmentNode: aStAssignmentNode
	| variable varNode |
	varNode := aStAssignmentNode variable.
	(varNode isSpecialVariable or: [ignore = varNode name]) ifTrue: [^self].
	variable := varNode variable.
	variable isInstanceVariable ifTrue: [instVarWriters add: varNode name].
	variable binding
		ifNotNil: 
			[:binding |
			(binding isClassVariable
				and: [binding isPrivate and: [binding environment == fromClass instanceClass]])
					ifTrue: [privateClassVarWriters add: binding]]!

processReferenceNode: aStVariableNode
	| variable |
	(aStVariableNode isSpecialVariable or: [ignore = aStVariableNode name]) ifTrue: [^self].
	variable := aStVariableNode variable.
	variable isInstanceVariable ifTrue: [instVarReaders add: aStVariableNode name].
	variable binding
		ifNotNil: 
			[:binding |
			(binding isClassVariable
				and: [binding isPrivate and: [binding environment == fromClass instanceClass]])
					ifTrue: [privateClassVarReaders add: binding]]!

removeDefinedClassVariables
	| selectionBlock |
	selectionBlock := 
			[:binding |
			toClasses anySatisfy: [:each | (each instanceClass includesClass: binding environment) not]].
	privateClassVarReaders := privateClassVarReaders select: selectionBlock.
	privateClassVarWriters := privateClassVarWriters select: selectionBlock!

shouldAbstractVariables
	^(self lookupOption: #abstractVariables) cull: self!

transform
	self hasVariablesToAbstract
		ifTrue: [self shouldAbstractVariables ifFalse: [self refactoringAborted]].
	self abstractInstanceVariables.
	self abstractClassVariables! !
!Refactory.Browser.AbstractVariablesRefactoring categoriesForMethods!
abstractClassVariable:!public!transforming! !
abstractClassVariables!public!transforming! !
abstractInstanceVariable:!public!transforming! !
abstractInstanceVariables!public!transforming! !
abstractVariablesIn:from:toAll:ignoring:!initializing!private! !
computeVariablesToAbstract!private!transforming! !
hasVariablesToAbstract!public!testing! !
instanceVariableNames!public!transforming! !
instVarReaders!accessing!public! !
instVarWriters!accessing!public! !
parseTree!accessing!public! !
preconditions!preconditions!public! !
privateClassVarReaders!accessing!public! !
privateClassVarWriters!accessing!public! !
processAssignmentNode:!private!transforming! !
processReferenceNode:!private!transforming! !
removeDefinedClassVariables!public!transforming! !
shouldAbstractVariables!private!requests! !
transform!public!transforming! !
!

!Refactory.Browser.AbstractVariablesRefactoring class methodsFor!

model: aRBModel abstractVariablesIn: aBRProgramNode from: fromBehavior toAll: behaviorCollection
	^self
		model: aRBModel
		abstractVariablesIn: aBRProgramNode
		from: fromBehavior
		toAll: behaviorCollection
		ignoring: nil!

model: aRBModel abstractVariablesIn: aBRProgramNode from: fromBehavior toAll: behaviorCollection ignoring: aVariableName
	^self new
		model: aRBModel;
		abstractVariablesIn: aBRProgramNode
			from: fromBehavior
			toAll: behaviorCollection
			ignoring: aVariableName;
		yourself! !
!Refactory.Browser.AbstractVariablesRefactoring class categoriesForMethods!
model:abstractVariablesIn:from:toAll:!instance creation!public! !
model:abstractVariablesIn:from:toAll:ignoring:!instance creation!public! !
!

