"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #IdeaSpaceShellTest
	instanceVariableNames: 'ideaShell'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdeaSpaceShellTest guid: (GUID fromString: '{2E6DE900-C47F-4134-B038-B70CD1679C1C}')!
IdeaSpaceShellTest comment: ''!
!IdeaSpaceShellTest categoriesForClass!Unclassified! !
!IdeaSpaceShellTest methodsFor!

create: aClassSymbol subclassOf: aClass
	| newClass |
	newClass := aClass subclass: aClassSymbol instanceVariableNames: '' classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''.
	self assert: (newClass notNil and: [newClass isKindOf: Class]).
	^newClass!

newClassBrowserCard
	^ideaShell newEmbeddedCardOfClass: ClassBrowserShell!

newEnvironmentBrowserCard
	^ideaShell newEmbeddedCardOfClass: EnvironmentBrowserShell!

newSystemBrowserCard
	^ideaShell newEmbeddedCardOfClass: SystemBrowserShell!

newViewBrowserCard
	^ideaShell newEmbeddedCardOfClass: ResourceBrowser!

newViewComposerCard
	^ideaShell newEmbeddedCardOfClass: ViewComposer!

newWorkspaceCard
	^(ideaShell newEmbeddedCardOfClass: SmalltalkWorkspaceDocument)
		filename: (FileLocator installRelative localFileSpecFor: 'Boot.st');
		fileLoad;
		yourself!

setUp
	super setUp.
	ideaShell := IdeaSpaceShell show!

tearDown
	ideaShell destroy.
	super tearDown!

testAbsorbCard
	| vc cb vcToolbar cardLayout |
	SmalltalkSystemShell default setFocus.
	vc := ViewComposer show.
	self assert: ideaShell cards isEmpty.

	"Find the original VC toolbar"
	vcToolbar := vc view viewNamed: 'toolbar'.
	self assert: vcToolbar isOpen.

	"Absorb the VC into the IdeaSpace"
	ideaShell absorbCard: vc.
	self assert: ideaShell cards size = 1.

	"Check view and presenter hierarchy"
	self assert: vc view parentView == ideaShell cardsPresenter view.
	self assert: vc parentPresenter == ideaShell cardsPresenter.
	self assert: (ideaShell cardsPresenter subPresenters includes: vc).
	self assert: (ideaShell cardsPresenter view subViews includes: vc view).
	cardLayout := ideaShell cardsPresenter view layoutManager.
	self assert: (cardLayout cards includes: vc view).
	self assert: (cardLayout cardViews includes: vc view).

	"Original menu bar should have gone, IdeaSpace should now show this"
	self assert: ideaShell view menuBar == vc view menuBar.

	"Add another card and make sure it goes at the right place"
	SmalltalkSystemShell default setFocus.
	cb := ClassBrowserShell show.
	ideaShell absorbCard: cb.
	self assert: ideaShell cards size = 2.
	self assert: ideaShell isCurrentCardLast!

testAbsorbedCardRemoval
	| vc |
	SmalltalkSystemShell default setFocus.
	vc := ViewComposer show.
	self assert: ideaShell cards isEmpty.

	"Absorb the VC into the IdeaSpace"
	ideaShell absorbCard: vc.
	self assert: ideaShell cards size = 1.

	"Test card removal"
	ideaShell removeCard: vc.
	self assert: ideaShell cards isEmpty!

testBreakoutCard
	| vc sb cb vcToolbar vcCardToolbar |
	sb := self newSystemBrowserCard.
	cb := self newClassBrowserCard.
	vc := self newViewComposerCard.
	self assert: ideaShell cards size = 3.
	self assert: vc view parentView==ideaShell cardsPresenter view.
	self assert: vc parentPresenter==ideaShell cardsPresenter.

	"Find the original VC toolbar nd the newly installed card toolbar"
	vcToolbar := vc view viewNamed: 'toolbar'.
	vcCardToolbar := vcToolbar parentView.
	self assert: vcCardToolbar isOpen.
	self assert: vcCardToolbar parentView == vc view.

	"Breakout the VC onto the desktop"
	ideaShell breakoutCurrentCard.

	"There should only be two cards left in the IS"
	self assert: ideaShell cards size = 2.
	self assert: ideaShell cardsPresenter subPresenters size = 2.

	"The VC card should now be a child of the desktop"
	self assert: (vc view isKindOf: ShellView).
	self assert: vc view isOpen.
	self assert: vc view parentView == View desktop.

	"The VC toolbar should have been restored and the card toolbar destroyed"
	self assert: vcToolbar parentView == vc view.
	self deny: vcCardToolbar isOpen.
	vc exit.
	self assert: vc view isClosed.

	"Breakout the other cards to leave the IdeaSpace empty"
	ideaShell
		breakoutCurrentCard;
		breakoutCurrentCard.
	sb exit.
	cb exit.

	"There should no cards left in the IS"
	self assert: ideaShell cards isEmpty.
	self assert: ideaShell cardsPresenter subPresenters isEmpty.

	"Ideaspace caption and background should be flipped"
	self assert: ideaShell caption = 'Idea Space'!

testBreakoutCardOrdering
	| vc sb cb |
	sb := self newSystemBrowserCard.
	cb := self newClassBrowserCard.
	vc := self newViewComposerCard.

	"Breakout the first card (this used to fail)"
	sb ensureVisible.
	ideaShell breakoutCurrentCard.
	sb exit!

testHistoryRemove
	| vc sb cb hist |
	sb := self newSystemBrowserCard.
	cb := self newClassBrowserCard.
	vc := self newViewComposerCard.
	self assert: ideaShell cards size = 3.
	hist := ideaShell instVarNamed: 'cardHistory'.
	self assert: hist position = 3.
	self deny: hist hasFuture.
	cb view ensureVisible.
	sb view ensureVisible.
	cb view ensureVisible.
	vc view ensureVisible.
	self assert: hist position = 7.
	self deny: hist hasFuture.
	ideaShell closeCard.
	self assert: ideaShell cards size = 2.
	self assert: hist position = 4.
	self deny: hist hasFuture.
	ideaShell closeCard.
	super assert: ideaShell cards size = 1.
	self assert: hist position = 1.
	self deny: hist hasFuture.
	ideaShell closeCard.
	self assert: ideaShell cards size = 0.
	self assert: hist isEmpty.
	"Similar but with non-sequential visit history - idea here is to test that removing cards
	pops back to the previous visit and does not in itself generate more visits"
	sb := self newSystemBrowserCard.
	cb := self newClassBrowserCard.
	vc := self newViewComposerCard.
	self assert: ideaShell cards size = 3.
	hist := ideaShell instVarNamed: 'cardHistory'.
	self assert: hist position = 3.
	self deny: hist hasFuture.
	sb view ensureVisible.
	vc view ensureVisible.
	self assert: hist position = 5.
	self deny: hist hasFuture.
	ideaShell closeCard.
	self assert: ideaShell currentCard == sb.
	self assert: ideaShell cards size = 2.
	self assert: hist position = 3.
	self deny: hist hasFuture.
	self assert: hist hasPast.
	ideaShell closeCard.
	self assert: ideaShell currentCard == cb.
	self assert: ideaShell cards size = 1.
	self assert: hist position = 1.
	self deny: hist hasFuture.
	ideaShell closeCard.
	self assert: ideaShell cards size = 0.
	self assert: hist isEmpty!

testRemoveCard
	| sb cb |
	sb := self newSystemBrowserCard.
	cb := self newClassBrowserCard.
	super assert: ideaShell cards size = 2.
	sb exit.
	super assert: ideaShell cards size = 1.
	ideaShell closeCard.
	super assert: ideaShell cards isEmpty!

testSaveRestore
	"Test Save and Restore of various Ideaspace tools"

	"System Browser on False"

	| sb cb eb ws vc rb saveString newIdeaShell newSb newCb newEb newWs newVc newRb definitionPresenter |
	sb := self newSystemBrowserCard.
	sb packages: (Array with: False owningPackage with: ClassBrowserShell owningPackage).
	sb actualClass: False.

	"Class Browser on View>>destroy with definition showing"
	cb := self newClassBrowserCard.
	cb method: (View compiledMethodAt: #destroy).
	cb setPinStateFor: 'filtersSlidey' to: false.
	definitionPresenter := cb instVarNamed: 'definitionPresenter'.
	definitionPresenter ensureVisible.

	"Environment Browser on Object subclassses"
	eb := self newEnvironmentBrowserCard.
	eb 
		browserEnvironment: (Smalltalk developmentSystem browserEnvironmentForClasses: Object subclasses).
	eb method: (Presenter compiledMethodAt: #createComponents).

	"Workspace"
	ws := self newWorkspaceCard.
	ws workspace evaluationPools: (Array with: Win32Constants with: CommCtrlConstants).

	"View Composer"
	vc := self newViewComposerCard.
	vc resourceIdentifier: (ResourceIdentifier class: ClassBrowserShell).

	"View Browser"
	rb := self newViewBrowserCard.
	rb resource: (ResourceIdentifier class: ClassBrowserShell).

	"Make the system browser the current card"
	sb ensureVisible.

	"Save it"
	saveString := ideaShell saveStateString.
	newIdeaShell := IdeaSpaceShell show configureFromSavedStateString: saveString.
	self assert: newIdeaShell cards size = 6.
	newSb := newIdeaShell cards first.
	newCb := newIdeaShell cards second.
	newEb := newIdeaShell cards third.
	newWs := newIdeaShell cards fourth.
	newVc := newIdeaShell cards fifth.
	newRb := newIdeaShell cards sixth.
	self assert: (newSb isKindOf: SystemBrowserShell).
	self assert: newSb actualClass == sb actualClass.
	self assert: newSb packages = sb packages.
	self assert: (newCb isKindOf: ClassBrowserShell).
	self assert: newCb actualClass == cb actualClass.
	self deny: (newCb getPinStateFor: 'filtersSlidey').
	self assert: (newEb isKindOf: EnvironmentBrowserShell).
	self assert: (newWs isKindOf: SmalltalkWorkspaceDocument).
	self assert: (newVc isKindOf: ViewComposer).
	self assert: (newRb isKindOf: ResourceBrowser).
	self assert: newCb method == cb method.
	self assert: newIdeaShell currentCard == newSb.
	self assert: newEb method == eb method.
	self assert: newWs getDocumentData = ws getDocumentData.
	self assert: newWs filename = ws filename.
	self assert: newWs workspace evaluationPools = ws workspace evaluationPools.
	self assert: newWs workspace evaluationPools first == ws workspace evaluationPools first.
	self assert: newVc resourceIdentifier = vc resourceIdentifier.
	self assert: newRb resource = rb resource.
	newIdeaShell view destroy!

testSaveRestoreEmpty
	"Test Save and Restore an empty IdeaSpace"

	| saveString newIdeaShell |
	saveString := ideaShell saveStateString.
	newIdeaShell := IdeaSpaceShell show configureFromSavedStateString: saveString.
	self assert: newIdeaShell cards isEmpty.
	newIdeaShell view destroy!

testSaveRestoreErrors
	"Test Save and Restore of various Ideaspace tools"

	| cb newIdeaShell saveString aaaClass |
	cb := self newClassBrowserCard.
	aaaClass := self create: #AAAClass subclassOf: Object.
	cb actualClass: aaaClass.
	saveString := ideaShell saveStateString.
	aaaClass removeFromSystem.
	newIdeaShell := IdeaSpaceShell show.
	self should: [newIdeaShell configureFromSavedStateString: saveString]
		raise: Compiler notificationClass.
	newIdeaShell view destroy! !
!IdeaSpaceShellTest categoriesFor: #create:subclassOf:!helpers!private! !
!IdeaSpaceShellTest categoriesFor: #newClassBrowserCard!private!unit tests! !
!IdeaSpaceShellTest categoriesFor: #newEnvironmentBrowserCard!private!unit tests! !
!IdeaSpaceShellTest categoriesFor: #newSystemBrowserCard!private!unit tests! !
!IdeaSpaceShellTest categoriesFor: #newViewBrowserCard!private!unit tests! !
!IdeaSpaceShellTest categoriesFor: #newViewComposerCard!private!unit tests! !
!IdeaSpaceShellTest categoriesFor: #newWorkspaceCard!private!unit tests! !
!IdeaSpaceShellTest categoriesFor: #setUp!private!unit tests! !
!IdeaSpaceShellTest categoriesFor: #tearDown!private!unit tests! !
!IdeaSpaceShellTest categoriesFor: #testAbsorbCard!public!unit tests! !
!IdeaSpaceShellTest categoriesFor: #testAbsorbedCardRemoval!public!unit tests! !
!IdeaSpaceShellTest categoriesFor: #testBreakoutCard!public!unit tests! !
!IdeaSpaceShellTest categoriesFor: #testBreakoutCardOrdering!public!unit tests! !
!IdeaSpaceShellTest categoriesFor: #testHistoryRemove!public!unit tests! !
!IdeaSpaceShellTest categoriesFor: #testRemoveCard!public!unit tests! !
!IdeaSpaceShellTest categoriesFor: #testSaveRestore!public!unit tests! !
!IdeaSpaceShellTest categoriesFor: #testSaveRestoreEmpty!public!unit tests! !
!IdeaSpaceShellTest categoriesFor: #testSaveRestoreErrors!public!unit tests! !

