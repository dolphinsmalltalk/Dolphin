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

createThreeCards
	| tools |
	tools := Array new: 3.
	ideaShell view noRedrawDo: 
			[tools at: 1 put: self newSystemBrowserCard.
			tools at: 2 put: self newClassBrowserCard.
			tools at: 3 put: self newViewComposerCard].
	self assert: ideaShell cards size = 3.
	tools do: 
			[:each |
			self assert: each view parentView == ideaShell cardsPresenter view.
			self assert: each parentPresenter == ideaShell cardsPresenter].
	^tools!

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
	ideaShell := nil.
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
	| toolToolbar cardToolbar tools |
	tools := self createThreeCards.

	"Find the original toolbar and the newly installed card toolbar"
	toolToolbar := tools third view viewNamed: 'toolbar'.
	cardToolbar := toolToolbar parentView.
	self assert: cardToolbar isOpen.
	self assert: cardToolbar parentView == tools third view.

	"Breakout the card onto the desktop"
	ideaShell breakoutCurrentCard.

	"There should only be two cards left in the IS"
	self assert: ideaShell cards size = 2.
	self assert: ideaShell cardsPresenter subPresenters size = 2.

	"The card should now be a child of the desktop"
	self assert: (tools third view isKindOf: ShellView).
	self assert: tools third view isOpen.
	self assert: tools third view parentView == View desktop.

	"The  toolbar should have been restored and the card toolbar destroyed"
	self assert: toolToolbar parentView == tools third view.
	self deny: cardToolbar isOpen.

	"Breakout the other cards to leave the IdeaSpace empty"
	ideaShell hide.
	ideaShell
		breakoutCurrentCard;
		breakoutCurrentCard.
	tools do: 
			[:each |
			each exit.
			self assert: each view isClosed].
	ideaShell show.
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
	| hist cards |
	ideaShell view disableRedraw.
	cards := self createThreeCards.
	hist := ideaShell instVarNamed: 'cardHistory'.
	self assert: hist position = 3.
	self deny: hist hasFuture.
	cards second view ensureVisible.
	cards first view ensureVisible.
	cards second view ensureVisible.
	cards third view ensureVisible.
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
	cards := self createThreeCards.
	self assert: ideaShell cards size = 3.
	hist := ideaShell instVarNamed: 'cardHistory'.
	self assert: hist position = 3.
	self deny: hist hasFuture.
	cards first view ensureVisible.
	cards third view ensureVisible.
	self assert: hist position = 5.
	self deny: hist hasFuture.
	ideaShell closeCard.
	self assert: ideaShell currentCard == cards first.
	self assert: ideaShell cards size = 2.
	self assert: hist position = 3.
	self deny: hist hasFuture.
	self assert: hist hasPast.
	ideaShell closeCard.
	self assert: ideaShell currentCard == cards second.
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

	| sb cb eb ws vc rb saveString newIdeaShell newSb newCb newEb newWs newVc newRb definitionPresenter |
	"This test is pretty slow, but we can speed it up by ~30% by disabling redraw while populating the test subject"
	(ideaShell view)
		hide;
		disableRedraw.
	"System Browser on False"
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
	eb browserEnvironment: (Smalltalk developmentSystem browserEnvironmentForClasses: Object subclasses).
	eb method: (Presenter compiledMethodAt: #createComponents).

	"Workspace"
	ws := self newWorkspaceCard.
	ws workspace evaluationPools: (Array with: Win32Constants with: CommCtrlConstants).

	"View Composer"
	vc := self newViewComposerCard.
	vc resourceIdentifier: (ResourceIdentifier class: Shell).

	"View Browser"
	rb := self newViewBrowserCard.
	rb resource: (ResourceIdentifier class: Shell).

	"Make the system browser the current card"
	sb ensureVisible.
	"Enabling redraw will also unhide"
	ideaShell view enableRedraw.

	"Save it"
	saveString := ideaShell saveStateString.
	"Restore state into a new idea space"
	newIdeaShell := IdeaSpaceShell create.
	newIdeaShell configureFromSavedStateString: saveString.
	self assert: newIdeaShell cards size = 6.
	newSb := newIdeaShell cards first.
	newCb := newIdeaShell cards second.
	newEb := newIdeaShell cards third.
	newWs := newIdeaShell cards fourth.
	newVc := newIdeaShell cards fifth.
	newRb := newIdeaShell cards sixth.
	self assert: newIdeaShell currentCard == newSb.
	self assert: (newSb isKindOf: SystemBrowserShell).
	self assert: newSb actualClass == sb actualClass.
	self assert: newSb packages = sb packages.
	self assert: (newCb isKindOf: ClassBrowserShell).
	self assert: newCb actualClass == cb actualClass.
	self assert: newCb method == cb method.
	self deny: (newCb getPinStateFor: 'filtersSlidey').
	self assert: (newEb isKindOf: EnvironmentBrowserShell).
	self assert: newEb method == eb method.
	self assert: (newWs isKindOf: SmalltalkWorkspaceDocument).
	self assert: newWs getDocumentData = ws getDocumentData.
	self assert: newWs filename = ws filename.
	self assert: newWs workspace evaluationPools = ws workspace evaluationPools.
	self assert: newWs workspace evaluationPools first == ws workspace evaluationPools first.
	self assert: (newVc isKindOf: ViewComposer).
	self assert: newVc resourceIdentifier = vc resourceIdentifier.
	self assert: (newRb isKindOf: ResourceBrowser).
	self assert: newRb resource = rb resource.
	newIdeaShell view destroy!

testSaveRestoreEmpty
	"Test Save and Restore an empty IdeaSpace"

	| saveString newIdeaShell |
	saveString := ideaShell saveStateString.
	newIdeaShell := IdeaSpaceShell create.
	newIdeaShell configureFromSavedStateString: saveString.
	newIdeaShell show.
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
!IdeaSpaceShellTest categoriesFor: #createThreeCards!helpers!private! !
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

