"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Refactoring
	subclass: #'Refactory.Browser.UnqualifyStaticVariablesRefactoring'
	instanceVariableNames: 'tree'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.UnqualifyStaticVariablesRefactoring guid: (Core.GUID fromString: '{61fc70ec-acbe-4a00-a55f-49a38145a061}')!
Refactory.Browser.UnqualifyStaticVariablesRefactoring comment: ''!
!Refactory.Browser.UnqualifyStaticVariablesRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.UnqualifyStaticVariablesRefactoring methodsFor!

parseTree
	^tree!

preconditions
	^RBCondition empty!

transform
	self unqualifyStaticVariables!

unqualifyStaticVariables
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: '`identifier'
		withValueFrom: [:variableNode | self rewriteStaleStaticVariable: variableNode]
		when: 
			[:variableNode |
			variableNode isStaticVariable and: 
					[variableNode hasQualifiedName
						and: [(self shortestNameForStaticVariable: variableNode) ~= variableNode name]]].
	(rewriter executeTree: tree) ifTrue: [tree := rewriter tree]!

unqualifyVariablesIn: aStMethodNode
	tree := aStMethodNode! !
!Refactory.Browser.UnqualifyStaticVariablesRefactoring categoriesForMethods!
parseTree!accessing!public! !
preconditions!preconditions!public! !
transform!public!transforming! !
unqualifyStaticVariables!private!transforming! !
unqualifyVariablesIn:!public! !
!

!Refactory.Browser.UnqualifyStaticVariablesRefactoring class methodsFor!

model: aRBModel unqualifyVariablesIn: aBoundProgramNode
	^self new
		model: aRBModel;
		unqualifyVariablesIn: aBoundProgramNode! !
!Refactory.Browser.UnqualifyStaticVariablesRefactoring class categoriesForMethods!
model:unqualifyVariablesIn:!instance creation!public! !
!

