"Filed out from Dolphin Smalltalk"!

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

extendMenus
	{(self view viewNamed: 'methodsList') presenterConnectionPoint contextMenu.
		self view menuBar findCommand: #method} do: 
				[:each |
				each insertItem: (CommandMenuItem
							commandDescription: (CommandDescription command: (Message selector: #ignoreFailure)
									description: '&Ignore this rule failure'))
					before: #removeMethod]!

ignoreFailure
	"Filter the selected method so that it is not checked by the current rule in future"

	| index methods |
	methods := self browser selections.
	methods do: [:each | self developmentSystem addFilteredMethod: each forLintRule: self lintRule].
	index := self browser selectionsByIndex first.
	self browser model removeAll: methods.
	self browser selectionByIndex: index ifAbsent: []!

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

onViewOpened
	"Received when the receiver's view is been connected. 
	Transfer the caption across to the view"

	super onViewOpened.
	self extendMenus!

queryCommand: aCommandQuery
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery> argument."

	| selector |
	selector := aCommandQuery commandSymbol.
	#ignoreFailure == selector
		ifTrue: 
			[aCommandQuery isEnabled: self browser hasSelection.
			^true].
	^super queryCommand: aCommandQuery! !
!Tools.LintRuleFailuresBrowserShell categoriesForMethods!
addToCommandRoute:!commands!public! !
extendMenus!browsing!private! !
ignoreFailure!commands!public! !
lintRule!accessing!public! !
lintRule:!accessing!public! !
onViewOpened!event handling!public! !
queryCommand:!commands!private! !
!

!Tools.LintRuleFailuresBrowserShell class methodsFor!

initialize
	self canUseIdeaSpace: true! !
!Tools.LintRuleFailuresBrowserShell class categoriesForMethods!
initialize!initializing!private! !
!

