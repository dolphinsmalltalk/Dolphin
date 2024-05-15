"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #IdeaSpaceShellTest
	instanceVariableNames: 'browserPlugins'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

IdeaSpaceShellTest guid: (GUID fromString: '{2e6de900-c47f-4134-b038-b70cd1679c1c}')!

IdeaSpaceShellTest comment: ''!

!IdeaSpaceShellTest categoriesForClass!Unclassified! !

!IdeaSpaceShellTest methodsFor!

classToTest
	^IdeaSpaceShell!

create: aClassSymbol subclassOf: aClass
	| newClass |
	newClass := aClass subclass: aClassSymbol instanceVariableNames: '' classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''.
	self assert: (newClass notNil and: [newClass isKindOf: Class]).
	^newClass!

createThreeCards
	| tools |
	tools := Array new: 3.
	presenter view noRedrawDo: 
			[tools at: 1 put: self newInspectorShellCard.
			tools at: 2 put: self newInspectorShellCard.
			tools at: 3 put: self newInspectorShellCard].
	self assert: presenter cards size equals: 3.
	tools do: 
			[:each |
			self assert: each view parentView identicalTo: presenter cardsPresenter view.
			self assert: each parentPresenter identicalTo: presenter cardsPresenter].
	^tools!

destroyPresenter
	presenter ifNil: [^self].
	presenter destroy.
	presenter := nil!

initializePresenter
	presenter := IdeaSpaceShell show!

newClassBrowserCard
	^presenter newEmbeddedCardOfClass: ClassBrowserShell!

newEnvironmentBrowserCard
	^presenter newEmbeddedCardOfClass: EnvironmentBrowserShell!

newInspectorShellCard
	^presenter newEmbeddedCardOfClass: InspectorShell!

newSystemBrowserCard
	^presenter newEmbeddedCardOfClass: SystemBrowserShell!

newViewBrowserCard
	^presenter newEmbeddedCardOfClass: ResourceBrowser!

newViewComposerCard
	^presenter newEmbeddedCardOfClass: ViewComposer!

newWorkspaceCard
	| workspace |
	workspace := presenter newEmbeddedCardOfClass: SmalltalkWorkspaceDocument.
	self assert: workspace workspace view isKindOf: ScintillaView.
	^workspace
		filename: (FileLocator installRelative localFileSpecFor: 'Boot.st');
		fileLoad;
		yourself!

setUp
	super setUp.
	browserPlugins := ClassBrowserAbstract subclasses collect: 
					[:each |
					| plugins |
					plugins := each plugins.
					each plugins: #().
					each -> plugins]!

tearDown
	super tearDown.
	browserPlugins do: [:each | each key plugins: each value]!

testAbsorbCard
	| tool1 tool2 vcToolbar cardLayout |
	SmalltalkSystemShell default setFocus.
	tool1 := InspectorShell show.
	self assert: presenter cards isEmpty.

	"Find the original VC toolbar"
	vcToolbar := tool1 view viewNamed: 'toolbar'.
	self assert: vcToolbar isOpen.

	"Absorb the VC into the IdeaSpace"
	presenter absorbCard: tool1.
	self assert: presenter cards size equals: 1.

	"Check view and presenter hierarchy"
	self assert: tool1 view parentView identicalTo: presenter cardsPresenter view.
	self assert: tool1 parentPresenter identicalTo: presenter cardsPresenter.
	self assert: (presenter cardsPresenter subPresenters includes: tool1).
	self assert: (presenter cardsPresenter view subViews includes: tool1 view).
	cardLayout := presenter cardsPresenter view layoutManager.
	self assert: (cardLayout cards includes: tool1 view).
	self assert: (cardLayout cardViews includes: tool1 view).

	"Original menu bar should have gone, IdeaSpace should now show this"
	self assert: presenter view menuBar identicalTo: tool1 view menuBar.

	"Add another card and make sure it goes at the right place"
	SmalltalkSystemShell default setFocus.
	tool2 := SmalltalkWorkspaceDocument show.
	presenter absorbCard: tool2.
	self assert: presenter cards size equals: 2.
	self assert: presenter isCurrentCardLast!

testAbsorbedCardRemoval
	| tool |
	SmalltalkSystemShell default setFocus.
	tool := InspectorShell show.
	self assert: presenter cards isEmpty.

	"Absorb the VC into the IdeaSpace"
	presenter absorbCard: tool.
	self assert: presenter cards size equals: 1.

	"Test card removal"
	presenter removeCard: tool.
	self assert: presenter cards isEmpty!

testBreakoutCard
	| toolToolbar cardToolbar tools |
	tools := self createThreeCards.

	"Find the original toolbar and the newly installed card toolbar"
	toolToolbar := tools third view viewNamed: 'toolbar'.
	cardToolbar := toolToolbar parentView.
	self assert: cardToolbar isOpen.
	self assert: cardToolbar parentView identicalTo: tools third view.

	"Breakout the card onto the desktop"
	presenter breakoutCurrentCard.

	"There should only be two cards left in the IS"
	self assert: presenter cards size equals: 2.
	self assert: presenter cardsPresenter subPresenters size equals: 2.

	"The card should now be a child of the desktop"
	self assert: tools third view isKindOf: ShellView.
	self assert: tools third view isOpen.
	self assert: tools third view parentView identicalTo: View desktop.

	"The  toolbar should have been restored and the card toolbar destroyed"
	self assert: toolToolbar parentView identicalTo: tools third view.
	self deny: cardToolbar isOpen.

	"Breakout the other cards to leave the IdeaSpace empty"
	presenter hide.
	presenter
		breakoutCurrentCard;
		breakoutCurrentCard.
	tools do: 
			[:each |
			each exit.
			self deny: each isOpen].
	presenter show.
	"There should no cards left in the IS"
	self assert: presenter cards isEmpty.
	self assert: presenter cardsPresenter subPresenters isEmpty.

	"Ideaspace caption and background should be flipped"
	self assert: presenter caption equals: 'Idea Space'!

testBreakoutCardOrdering
	| cards |
	cards := self createThreeCards.

	"Breakout the first card (this used to fail)"
	cards first ensureVisible.
	presenter breakoutCurrentCard.
	cards first exit!

testHistoryRemove
	| hist cards |
	presenter view disableRedraw.
	cards := self createThreeCards.
	hist := presenter instVarNamed: 'cardHistory'.
	self assert: hist position equals: 3.
	self deny: hist hasFuture.
	cards second view ensureVisible.
	cards first view ensureVisible.
	cards second view ensureVisible.
	cards third view ensureVisible.
	self assert: hist position equals: 7.
	self deny: hist hasFuture.
	presenter closeCard.
	self assert: presenter cards size equals: 2.
	self assert: hist position equals: 4.
	self deny: hist hasFuture.
	presenter closeCard.
	super assert: presenter cards size = 1.
	self assert: hist position equals: 1.
	self deny: hist hasFuture.
	presenter closeCard.
	self assert: presenter cards size equals: 0.
	self assert: hist isEmpty.
	"Similar but with non-sequential visit history - idea here is to test that removing cards
	pops back to the previous visit and does not in itself generate more visits"
	cards := self createThreeCards.
	self assert: presenter cards size equals: 3.
	hist := presenter instVarNamed: 'cardHistory'.
	self assert: hist position equals: 3.
	self deny: hist hasFuture.
	cards first view ensureVisible.
	cards third view ensureVisible.
	self assert: hist position equals: 5.
	self deny: hist hasFuture.
	presenter closeCard.
	self assert: presenter currentCard identicalTo: cards first.
	self assert: presenter cards size equals: 2.
	self assert: hist position equals: 3.
	self deny: hist hasFuture.
	self assert: hist hasPast.
	presenter closeCard.
	self assert: presenter currentCard identicalTo: cards second.
	self assert: presenter cards size equals: 1.
	self assert: hist position equals: 1.
	self deny: hist hasFuture.
	presenter closeCard.
	self assert: presenter cards size equals: 0.
	self assert: hist isEmpty!

testRemoveCard
	| sb cb |
	sb := self newSystemBrowserCard.
	self newClassBrowserCard.
	super assert: presenter cards size = 2.
	sb exit.
	super assert: presenter cards size = 1.
	presenter closeCard.
	super assert: presenter cards isEmpty!

testSaveRestore
	"Test Save and Restore of various Ideaspace tools"

	| sb cb ws saveString newSb newCb newEb newWs newVc newRb sbPackages rid wsDocData wsPools wsFilename |
	"This test is pretty slow, but we can speed it up by ~30% by disabling redraw while populating the test subject"
	presenter view
		hide;
		disableRedraw.
	"System Browser on False"
	sb := self newSystemBrowserCard.
	sbPackages := { ClassBrowserShell owningPackage. false class owningPackage }.
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
	ws workspace evaluationPools: {Win32Constants. CommCtrlConstants}.
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
	presenter view enableRedraw.

	"Save it"
	saveString := presenter saveStateString.
	presenter view destroy.
	"Restore state into a new idea space"
	presenter := IdeaSpaceShell create.
	presenter configureFromSavedStateString: saveString.
	self assert: presenter cards size equals: 6.
	newSb := presenter cards first.
	newCb := presenter cards second.
	newEb := presenter cards third.
	newWs := presenter cards fourth.
	newVc := presenter cards fifth.
	newRb := presenter cards sixth.
	self assert: presenter currentCard identicalTo: newSb.
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
	saveString := presenter saveStateString.
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
	saveString := presenter saveStateString.
	aaaClass removeFromSystem.
	newIdeaShell := IdeaSpaceShell show.
	self should: [newIdeaShell configureFromSavedStateString: saveString]
		raise: Compiler notificationClass.
	newIdeaShell view destroy!

viewClass
	^ShellView! !

!IdeaSpaceShellTest categoriesForMethods!
classToTest!constants!private! !
create:subclassOf:!helpers!private! !
createThreeCards!helpers!private! !
destroyPresenter!private!Running! !
initializePresenter!private!unit tests! !
newClassBrowserCard!private!unit tests! !
newEnvironmentBrowserCard!private!unit tests! !
newInspectorShellCard!private!unit tests! !
newSystemBrowserCard!private!unit tests! !
newViewBrowserCard!private!unit tests! !
newViewComposerCard!private!unit tests! !
newWorkspaceCard!private!unit tests! !
setUp!private!unit tests! !
tearDown!private!unit tests! !
testAbsorbCard!public!unit tests! !
testAbsorbedCardRemoval!public!unit tests! !
testBreakoutCard!public!unit tests! !
testBreakoutCardOrdering!public!unit tests! !
testHistoryRemove!public!unit tests! !
testRemoveCard!public!unit tests! !
testSaveRestore!public!unit tests! !
testSaveRestoreEmpty!public!unit tests! !
testSaveRestoreErrors!public!unit tests! !
viewClass!constants!private! !
!

