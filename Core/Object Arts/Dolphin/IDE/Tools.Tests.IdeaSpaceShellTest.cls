"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.IdeaSpaceShellTest'
	instanceVariableNames: 'ideaShell browserPlugins'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.IdeaSpaceShellTest guid: (Core.GUID fromString: '{2e6de900-c47f-4134-b038-b70cd1679c1c}')!
Tools.Tests.IdeaSpaceShellTest comment: ''!
!Tools.Tests.IdeaSpaceShellTest categoriesForClass!Unclassified! !
!Tools.Tests.IdeaSpaceShellTest methodsFor!

create: aClassSymbol subclassOf: aClass
	| newClass |
	newClass := aClass subclass: aClassSymbol instanceVariableNames: '' classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''.
	self assert: (newClass notNil and: [newClass isKindOf: Class]).
	^newClass!

createThreeCards
	| tools |
	tools := Array new: 3.
	ideaShell view noRedrawDo: 
			[tools at: 1 put: self newInspectorShellCard.
			tools at: 2 put: self newInspectorShellCard.
			tools at: 3 put: self newInspectorShellCard].
	self assert: ideaShell cards size equals: 3.
	tools do: 
			[:each |
			self assert: each view parentView identicalTo: ideaShell cardsPresenter view.
			self assert: each parentPresenter identicalTo: ideaShell cardsPresenter].
	^tools!

newClassBrowserCard
	^ideaShell newEmbeddedCardOfClass: ClassBrowserShell!

newEnvironmentBrowserCard
	^ideaShell newEmbeddedCardOfClass: EnvironmentBrowserShell!

newInspectorShellCard
	^ideaShell newEmbeddedCardOfClass: InspectorShell!

newSystemBrowserCard
	^ideaShell newEmbeddedCardOfClass: SystemBrowserShell!

newViewBrowserCard
	^ideaShell newEmbeddedCardOfClass: ResourceBrowser!

newViewComposerCard
	^ideaShell newEmbeddedCardOfClass: ViewComposer!

newWorkspaceCard
	| workspace |
	workspace := ideaShell newEmbeddedCardOfClass: SmalltalkWorkspaceDocument.
	self assert: workspace workspace view isKindOf: Scintilla.ScintillaView.
	^workspace
		filename: (FileLocator installRelative localFileSpecFor: 'Boot.st');
		fileLoad;
		yourself!

setUp
	super setUp.
	ideaShell := IdeaSpaceShell show.
	browserPlugins := ClassBrowserAbstract subclasses collect: 
					[:each |
					| plugins |
					plugins := each plugins.
					each plugins: #().
					each -> plugins]!

tearDown
	ideaShell destroy.
	ideaShell := nil.
	browserPlugins do: [:each | each key plugins: each value].
	super tearDown!

testAbsorbCard
	| tool1 tool2 vcToolbar cardLayout |
	SmalltalkSystemShell default setFocus.
	tool1 := InspectorShell show.
	self assert: ideaShell cards isEmpty.

	"Find the original VC toolbar"
	vcToolbar := tool1 view viewNamed: 'toolbar'.
	self assert: vcToolbar isOpen.

	"Absorb the VC into the IdeaSpace"
	ideaShell absorbCard: tool1.
	self assert: ideaShell cards size equals: 1.

	"Check view and presenter hierarchy"
	self assert: tool1 view parentView identicalTo: ideaShell cardsPresenter view.
	self assert: tool1 parentPresenter identicalTo: ideaShell cardsPresenter.
	self assert: (ideaShell cardsPresenter subPresenters includes: tool1).
	self assert: (ideaShell cardsPresenter view subViews includes: tool1 view).
	cardLayout := ideaShell cardsPresenter view layoutManager.
	self assert: (cardLayout cards includes: tool1 view).
	self assert: (cardLayout cardViews includes: tool1 view).

	"Original menu bar should have gone, IdeaSpace should now show this"
	self assert: ideaShell view menuBar identicalTo: tool1 view menuBar.

	"Add another card and make sure it goes at the right place"
	SmalltalkSystemShell default setFocus.
	tool2 := SmalltalkWorkspaceDocument show.
	ideaShell absorbCard: tool2.
	self assert: ideaShell cards size equals: 2.
	self assert: ideaShell isCurrentCardLast!

testAbsorbedCardRemoval
	| tool |
	SmalltalkSystemShell default setFocus.
	tool := InspectorShell show.
	self assert: ideaShell cards isEmpty.

	"Absorb the VC into the IdeaSpace"
	ideaShell absorbCard: tool.
	self assert: ideaShell cards size equals: 1.

	"Test card removal"
	ideaShell removeCard: tool.
	self assert: ideaShell cards isEmpty!

testBreakoutCard
	| toolToolbar cardToolbar tools |
	tools := self createThreeCards.

	"Find the original toolbar and the newly installed card toolbar"
	toolToolbar := tools third view viewNamed: 'toolbar'.
	cardToolbar := toolToolbar parentView.
	self assert: cardToolbar isOpen.
	self assert: cardToolbar parentView identicalTo: tools third view.

	"Breakout the card onto the desktop"
	ideaShell breakoutCurrentCard.

	"There should only be two cards left in the IS"
	self assert: ideaShell cards size equals: 2.
	self assert: ideaShell cardsPresenter subPresenters size equals: 2.

	"The card should now be a child of the desktop"
	self assert: tools third view isKindOf: ShellView.
	self assert: tools third view isOpen.
	self assert: tools third view parentView identicalTo: View desktop.

	"The  toolbar should have been restored and the card toolbar destroyed"
	self assert: toolToolbar parentView identicalTo: tools third view.
	self deny: cardToolbar isOpen.

	"Breakout the other cards to leave the IdeaSpace empty"
	ideaShell hide.
	ideaShell
		breakoutCurrentCard;
		breakoutCurrentCard.
	tools do: 
			[:each |
			each exit.
			self deny: each isOpen].
	ideaShell show.
	"There should no cards left in the IS"
	self assert: ideaShell cards isEmpty.
	self assert: ideaShell cardsPresenter subPresenters isEmpty.

	"Ideaspace caption and background should be flipped"
	self assert: ideaShell caption equals: 'Idea Space'!

testBreakoutCardOrdering
	| cards |
	cards := self createThreeCards.

	"Breakout the first card (this used to fail)"
	cards first ensureVisible.
	ideaShell breakoutCurrentCard.
	cards first exit!

testHistoryRemove
	| hist cards |
	ideaShell view disableRedraw.
	cards := self createThreeCards.
	hist := ideaShell instVarNamed: 'cardHistory'.
	self assert: hist position equals: 3.
	self deny: hist hasFuture.
	cards second view ensureVisible.
	cards first view ensureVisible.
	cards second view ensureVisible.
	cards third view ensureVisible.
	self assert: hist position equals: 7.
	self deny: hist hasFuture.
	ideaShell closeCard.
	self assert: ideaShell cards size equals: 2.
	self assert: hist position equals: 4.
	self deny: hist hasFuture.
	ideaShell closeCard.
	super assert: ideaShell cards size = 1.
	self assert: hist position equals: 1.
	self deny: hist hasFuture.
	ideaShell closeCard.
	self assert: ideaShell cards size equals: 0.
	self assert: hist isEmpty.
	"Similar but with non-sequential visit history - idea here is to test that removing cards
	pops back to the previous visit and does not in itself generate more visits"
	cards := self createThreeCards.
	self assert: ideaShell cards size equals: 3.
	hist := ideaShell instVarNamed: 'cardHistory'.
	self assert: hist position equals: 3.
	self deny: hist hasFuture.
	cards first view ensureVisible.
	cards third view ensureVisible.
	self assert: hist position equals: 5.
	self deny: hist hasFuture.
	ideaShell closeCard.
	self assert: ideaShell currentCard identicalTo: cards first.
	self assert: ideaShell cards size equals: 2.
	self assert: hist position equals: 3.
	self deny: hist hasFuture.
	self assert: hist hasPast.
	ideaShell closeCard.
	self assert: ideaShell currentCard identicalTo: cards second.
	self assert: ideaShell cards size equals: 1.
	self assert: hist position equals: 1.
	self deny: hist hasFuture.
	ideaShell closeCard.
	self assert: ideaShell cards size equals: 0.
	self assert: hist isEmpty!

testRemoveCard
	| sb |
	sb := self newSystemBrowserCard.
	self newClassBrowserCard.
	super assert: ideaShell cards size = 2.
	sb exit.
	super assert: ideaShell cards size = 1.
	ideaShell closeCard.
	super assert: ideaShell cards isEmpty!

testSaveRestore
	"Test Save and Restore of various Ideaspace tools"

	| sb cb ws saveString newSb newCb newEb newWs newVc newRb sbPackages rid wsDocData wsPools wsFilename |
	"This test is pretty slow, but we can speed it up by ~30% by disabling redraw while populating the test subject"
	ideaShell view
		hide;
		disableRedraw.
	"System Browser on False"
	sb := self newSystemBrowserCard.
	sbPackages := {ClassBrowserShell owningPackage. false class owningPackage}.
	sb packages: sbPackages.
	sb actualClass: false class.

	"Class Browser on View>>destroy with definition showing"
	cb := self newClassBrowserCard.
	cb method: View >> #destroy.
	cb setPinStateFor: 'filtersSlidey' to: false.
	(cb instVarNamed: 'definitionPresenter') ensureVisible.

	"Environment Browser on Object subclassses"
	self newEnvironmentBrowserCard
		browserEnvironment: (Smalltalk developmentSystem browserEnvironmentForClasses: Object subclasses);
		method: Presenter >> #createComponents.

	"Workspace"
	ws := self newWorkspaceCard.
	ws workspace evaluationPools: {OS.Win32Constants. OS.CommCtrlConstants}.
	wsDocData := ws getDocumentData.
	wsFilename := ws filename.
	wsPools := ws workspace evaluationPools.

	"View Composer"
	rid := ResourceIdentifier class: Shell.
	self newViewComposerCard resourceIdentifier: rid.

	"View Browser"
	self newViewBrowserCard resource: (ResourceIdentifier class: Shell).

	"Make the system browser the current card"
	sb ensureVisible.
	"Enabling redraw will also unhide"
	ideaShell view enableRedraw.

	"Save it"
	saveString := ideaShell saveStateString.
	ideaShell view destroy.
	"Restore state into a new idea space"
	ideaShell := IdeaSpaceShell create.
	ideaShell configureFromSavedStateString: saveString.
	self assert: ideaShell cards size equals: 6.
	newSb := ideaShell cards first.
	newCb := ideaShell cards second.
	newEb := ideaShell cards third.
	newWs := ideaShell cards fourth.
	newVc := ideaShell cards fifth.
	newRb := ideaShell cards sixth.
	self assert: ideaShell currentCard identicalTo: newSb.
	self assert: newSb isKindOf: SystemBrowserShell.
	self assert: newSb actualClass identicalTo: false class.
	self assert: newSb packages equals: sbPackages.
	self assert: newCb isKindOf: ClassBrowserShell.
	self assert: newCb actualClass identicalTo: View.
	self assert: newCb method identicalTo: View >> #destroy.
	self deny: (newCb getPinStateFor: 'filtersSlidey').
	self assert: newEb isKindOf: EnvironmentBrowserShell.
	self assert: newEb method identicalTo: Presenter >> #createComponents.
	self assert: newWs isKindOf: SmalltalkWorkspaceDocument.
	self assert: newWs getDocumentData equals: wsDocData.
	self assert: newWs filename equals: wsFilename.
	self assert: newWs workspace evaluationPools equals: wsPools.
	self assert: newWs workspace evaluationPools first identicalTo: wsPools first.
	self assert: newVc isKindOf: ViewComposer.
	self assert: newVc resourceIdentifier equals: rid.
	self assert: newRb isKindOf: ResourceBrowser.
	self assert: newRb resource equals: rid!

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
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #create:subclassOf:!helpers!private! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #createThreeCards!helpers!private! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #newClassBrowserCard!private!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #newEnvironmentBrowserCard!private!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #newInspectorShellCard!private!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #newSystemBrowserCard!private!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #newViewBrowserCard!private!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #newViewComposerCard!private!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #newWorkspaceCard!private!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #setUp!private!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #tearDown!private!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #testAbsorbCard!public!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #testAbsorbedCardRemoval!public!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #testBreakoutCard!public!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #testBreakoutCardOrdering!public!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #testHistoryRemove!public!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #testRemoveCard!public!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #testSaveRestore!public!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #testSaveRestoreEmpty!public!unit tests! !
!Tools.Tests.IdeaSpaceShellTest categoriesFor: #testSaveRestoreErrors!public!unit tests! !

