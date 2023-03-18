"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Refactoring
	subclass: #'Refactory.Browser.QualifyStaticVariablesRefactoring'
	instanceVariableNames: 'tree'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.QualifyStaticVariablesRefactoring guid: (Core.GUID fromString: '{c1a01452-ac2f-4813-8a6c-7486f4b17285}')!
Refactory.Browser.QualifyStaticVariablesRefactoring comment: ''!
!Refactory.Browser.QualifyStaticVariablesRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.QualifyStaticVariablesRefactoring methodsFor!

parseTree
	^tree!

preconditions
	^RBCondition empty!

qualifyStaticVariables
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: '`identifier'
		withValueFrom: 
			[:variableNode |
			variableNode copy
				name: variableNode binding fullName;
				clearPositions;
				yourself]
		when: [:variableNode | variableNode isStaticVariable and: [variableNode name ~= variableNode binding fullName]].
	"rewriter
		replace: '`#literal'
		withValueFrom: [:literalNode | self rewriteStaleLiteralReference: literalNode]
		when: [:literalNode | self isStaleLiteralReference: literalNode]."
	(rewriter executeTree: tree) ifTrue: [tree := rewriter tree]!

qualifyVariablesIn: aStMethodNode 
	tree := aStMethodNode!

transform
	self qualifyStaticVariables! !
!Refactory.Browser.QualifyStaticVariablesRefactoring categoriesForMethods!
parseTree!accessing!public! !
preconditions!preconditions!public! !
qualifyStaticVariables!private!transforming! !
qualifyVariablesIn:!public! !
transform!public!transforming! !
!

!Refactory.Browser.QualifyStaticVariablesRefactoring class methodsFor!

model: aRBModel qualifyVariablesIn: aBoundProgramNode
	^self new
		model: aRBModel;
		qualifyVariablesIn: aBoundProgramNode! !
!Refactory.Browser.QualifyStaticVariablesRefactoring class categoriesForMethods!
model:qualifyVariablesIn:!instance creation!public! !
!

