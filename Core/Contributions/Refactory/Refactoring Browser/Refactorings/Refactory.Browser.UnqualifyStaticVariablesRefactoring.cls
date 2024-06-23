"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ChangeStaticVariableQualificationRefactoring
	subclass: #'Refactory.Browser.UnqualifyStaticVariablesRefactoring'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.UnqualifyStaticVariablesRefactoring guid: (Core.GUID fromString: '{61fc70ec-acbe-4a00-a55f-49a38145a061}')!

Refactory.Browser.UnqualifyStaticVariablesRefactoring comment: ''!

!Refactory.Browser.UnqualifyStaticVariablesRefactoring categoriesForClass!Refactory-Refactorings! !

!Refactory.Browser.UnqualifyStaticVariablesRefactoring methodsFor!

buildRewriter
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: '`identifier'
		withValueFrom: [:variableNode | self rewriteStaticVariable: variableNode]
		when: [:variableNode | self isStaleStaticVariable: variableNode].
	rewriter
		replace: '`#literal'
		withValueFrom: 
			[:literalNode |
			literalNode rewriteQualifiedReferencesWith: [:refNode | self rewriteRelativeReference: refNode]]
		when: 
			[:literalNode |
			literalNode isOrContainsQualifiedReferenceMatching: 
					[:refNode |
					| binding |
					binding := refNode binding.
					binding notNil and: 
							["Could already be minimally qualified"
							refNode pathString ~= binding unqualifiedName
								and: [(self shortestNameToBind: binding from: refNode) ~= refNode pathString]]]].
	^rewriter! !

!Refactory.Browser.UnqualifyStaticVariablesRefactoring categoriesForMethods!
buildRewriter!private!transforming! !
!

