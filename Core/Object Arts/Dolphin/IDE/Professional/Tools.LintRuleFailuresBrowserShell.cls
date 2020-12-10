"Filed out from Dolphin Smalltalk 7"!

Tools.MethodBrowserShell subclass: #'Tools.LintRuleFailuresBrowserShell'
	instanceVariableNames: 'lintRule'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.LintRuleFailuresBrowserShell guid: (Core.GUID fromString: '{1f17dd01-e9d4-4f6b-a722-e0f62aed9b74}')!
Tools.LintRuleFailuresBrowserShell comment: ''!
!Tools.LintRuleFailuresBrowserShell categoriesForClass!MVP-Presenters! !
!Tools.LintRuleFailuresBrowserShell methodsFor!

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
!Tools.LintRuleFailuresBrowserShell categoriesFor: #addToCommandRoute:!commands!public! !
!Tools.LintRuleFailuresBrowserShell categoriesFor: #lintRule!accessing!public! !
!Tools.LintRuleFailuresBrowserShell categoriesFor: #lintRule:!accessing!public! !
!Tools.LintRuleFailuresBrowserShell categoriesFor: #queryCommand:!commands!private! !
!Tools.LintRuleFailuresBrowserShell categoriesFor: #removeMethod!commands!public! !

!Tools.LintRuleFailuresBrowserShell class methodsFor!

initialize
	self canUseIdeaSpace: true! !
!Tools.LintRuleFailuresBrowserShell class categoriesFor: #initialize!initializing!private! !

