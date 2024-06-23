"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ChangeStaticVariableQualificationRefactoring
	subclass: #'Refactory.Browser.QualifyStaticVariablesRefactoring'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.QualifyStaticVariablesRefactoring guid: (Core.GUID fromString: '{c1a01452-ac2f-4813-8a6c-7486f4b17285}')!

Refactory.Browser.QualifyStaticVariablesRefactoring comment: ''!

!Refactory.Browser.QualifyStaticVariablesRefactoring categoriesForClass!Refactory-Refactorings! !

!Refactory.Browser.QualifyStaticVariablesRefactoring methodsFor!

buildRewriter
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
	rewriter
		replace: '`#literal'
		withValueFrom: 
			[:literalNode |
			literalNode rewriteQualifiedReferencesWith: 
					[:literalRefNode |
					literalRefNode binding
						ifNil: [literalRefNode copy]
						ifNotNil: 
							[:binding |
							(literalRefNode copyWithName: binding fullName)
								isRelative: false;
								yourself]]]
		when: [:literalNode | literalNode isOrContainsQualifiedReferenceMatching: [:refNode | refNode binding notNil]].
	^rewriter! !

!Refactory.Browser.QualifyStaticVariablesRefactoring categoriesForMethods!
buildRewriter!private!transforming! !
!

