"Filed out from Dolphin Smalltalk 2000 release 5.00"!

Navigator subclass: #BrowserNavigator
	instanceVariableNames: 'dependents acceptAsPrivate'
	classVariableNames: 'RefactoringOptions'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BrowserNavigator comment: ''!

BrowserNavigator guid: (GUID fromString: '{8B8A133F-01B1-11D5-B80A-000102677BBF}')!

!BrowserNavigator categoriesForClass!Unclassified! !
!BrowserNavigator methodsFor!

browseReferencesTo: aLiteral 
	^self
		showWaitCursorWhile: [(self environment referencesTo: aLiteral)]!

environment
	^environment!

environment: aBrowserEnvironment 
	environment := aBrowserEnvironment!

getState
	"rbDmm - we set the state in queryCommand instead"
	| state | 

	state := self navigatorStateClass new.
	^state!

navigatorStateClass
	^(Smalltalk at: #DolphinNavigatorState)!

setState: aRefactoringBrowseShell
	"rbDmm - added"
	| state | 
	state := self navigatorStateClass new.
	state selectedClass: aRefactoringBrowseShell classesPresenter selectionOrNil.
	state category: aRefactoringBrowseShell categoriesPresenter selectionOrNil.
	state method: aRefactoringBrowseShell methodBrowserPresenter method.
	"Not required for D4
	state packages: aRefactoringBrowseShell packagesPresenter selectionOrNil."
	state mode: aRefactoringBrowseShell modePresenter selectionOrNil.
	state variables: aRefactoringBrowseShell variablesPresenter selectionOrNil.
	state protocols: aRefactoringBrowseShell protocolsPresenter selectionOrNil.
	state filterPresenter: aRefactoringBrowseShell filterPresenter.
	state currentView: aRefactoringBrowseShell currentView.

	^state!

showWaitCursorWhile: aBlock

	^Cursor wait showWhile: aBlock! !
!BrowserNavigator categoriesFor: #browseReferencesTo:!operations!public! !
!BrowserNavigator categoriesFor: #environment!operations!public! !
!BrowserNavigator categoriesFor: #environment:!operations!public! !
!BrowserNavigator categoriesFor: #getState!operations!public! !
!BrowserNavigator categoriesFor: #navigatorStateClass!operations!public! !
!BrowserNavigator categoriesFor: #setState:!operations!public! !
!BrowserNavigator categoriesFor: #showWaitCursorWhile:!operations!public! !

!BrowserNavigator class methodsFor!

forEnvironment: aBrowserEnvironment 
	^(self new) initialize; "rbDmm added initialize to init widgets"
		environment: aBrowserEnvironment;
		yourself! !
!BrowserNavigator class categoriesFor: #forEnvironment:!initialize/release!public! !

