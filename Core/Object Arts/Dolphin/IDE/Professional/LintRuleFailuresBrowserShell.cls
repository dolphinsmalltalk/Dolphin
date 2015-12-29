"Filed out from Dolphin Smalltalk X6"!

MethodBrowserShell subclass: #LintRuleFailuresBrowserShell
	instanceVariableNames: 'lintRule'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LintRuleFailuresBrowserShell guid: (GUID fromString: '{1F17DD01-E9D4-4F6B-A722-E0F62AED9B74}')!
LintRuleFailuresBrowserShell comment: ''!
!LintRuleFailuresBrowserShell categoriesForClass!Development! !
!LintRuleFailuresBrowserShell methodsFor!

addToCommandRoute: route
	super addToCommandRoute: route.
	route prependTarget: self!

lintRule
	^lintRule!

lintRule: aLintRule 
	| failedMethods |
	lintRule := aLintRule.
	self methods: aLintRule result
	"
	failedMethods := aLintRule failedMethodsSorted.
	failedMethods notEmpty 
		ifTrue: 
			[(self browser)
				list: failedMethods;
				selection: failedMethods first].
	self caption: aLintRule name"!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery> argument."

	| selector |
	selector := aCommandQuery commandSymbol.
	#removeMethod == selector 
		ifTrue: 
			[
			aCommandQuery
				isEnabled: self browser hasSelection;
				text: '&Ignore this rule failure'.
			^true].
	^super queryCommand: aCommandQuery 
!

removeMethod
	"Filter the selected method so that it is not checked by the current rule in future"

	| index methods |
	methods := self browser selections.
	methods do: [:each | self systemModel addFilteredMethod: each forLintRule: self lintRule].
	index := self browser selectionsByIndex first.
	self browser model removeAll: methods.
	self browser selectionByIndex: index ifAbsent: []! !
!LintRuleFailuresBrowserShell categoriesFor: #addToCommandRoute:!commands!public! !
!LintRuleFailuresBrowserShell categoriesFor: #lintRule!accessing!public! !
!LintRuleFailuresBrowserShell categoriesFor: #lintRule:!accessing!public! !
!LintRuleFailuresBrowserShell categoriesFor: #queryCommand:!commands!private! !
!LintRuleFailuresBrowserShell categoriesFor: #removeMethod!commands!public! !

!LintRuleFailuresBrowserShell class methodsFor!

initialize
	self canUseIdeaSpace: true! !
!LintRuleFailuresBrowserShell class categoriesFor: #initialize!initializing!private! !

