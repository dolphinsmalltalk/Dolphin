"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'Tools.Tests.IdeaSpaceShellTest'
	instanceVariableNames: 'browserPlugins'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Tests.IdeaSpaceShellTest guid: (Core.GUID fromString: '{2e6de900-c47f-4134-b038-b70cd1679c1c}')!

Tools.Tests.IdeaSpaceShellTest comment: ''!

!Tools.Tests.IdeaSpaceShellTest methodsFor!

classToTest
	^IdeaSpaceShell!

create: aClassSymbol subclassOf: aClass
	| newClass |
	newClass := aClass subclass: aClassSymbol instanceVariableNames: '' classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''.
	self assert: (newClass notNil and: [newClass isKindOf: Class]).
	^newClass!

createThreeCards
	| tools |
	tools := presenter view noRedrawDo: [(1 to: 3) collect: [:i | self newInspectorShellCard]].
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
	self assert: workspace workspace view isKindOf: UI.Scintilla.ScintillaView.
	^workspace
		filename: (FileLocator installRelative localFileSpecFor: 'Boot.st');
		fileLoad;
		yourself!

setUp
	super setUp.
	browserPlugins := ClassBrowserAbstract subclasses collect: 
					[:each |
					| plugins |
					plugins := each basicPlugins.
					each basicPlugins: #().
					each -> plugins]!

tearDown
	super tearDown.
	browserPlugins do: [:each | each key basicPlugins: each value]!

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
	| card1 |
	card1 := self newInspectorShellCard.
	self newInspectorShellCard.
	super assert: presenter cards size = 2.
	card1 exit.
	super assert: presenter cards size = 1.
	presenter closeCard.
	super assert: presenter cards isEmpty!

testSaveRestore
	"Test Save and Restore of various Ideaspace tools"

	<knownSlowTest>
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
		model: (Refactory.Browser.RBModel
					onEnvironment: (SmalltalkSystem current browserEnvironmentForClasses: Object subclasses));
		method: Presenter >> #createComponents.

	"Workspace"
	ws := self newWorkspaceCard.
	ws workspace namespaces: { OS.Win32Constants. OS.CommCtrlConstants }.
	wsDocData := ws getDocumentData.
	wsFilename := ws filename.
	wsPools := ws workspace namespaces.

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
	self assert: newWs workspace namespaces equals: wsPools.
	self assert: newWs workspace namespaces first identicalTo: wsPools first.
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

!Tools.Tests.IdeaSpaceShellTest categoriesForMethods!
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

!Tools.Tests.IdeaSpaceShellTest class methodsFor!

resource_Default_view_D6

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 196934 1 ##(Smalltalk.RGB)  29606851 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.WizardCardContainer)  98 15 0 416 98 2 8 1140850688 131073 544 0 0 0 7 0 0 0 544 655878 ##(Smalltalk.CardLayout)  202 208 98 2 721414 ##(Smalltalk.Association)  5 410 8 ##(Smalltalk.ContainerView)  98 15 0 544 98 2 8 1140850688 131073 720 0 482 29606851 0 7 0 0 0 720 514 1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 720 98 2 8 1140853516 131073 832 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 519 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 832 914 8 4278190080 8 4294904325 234 256 98 4 410 8 ##(Smalltalk.ReferenceView)  98 14 0 832 98 2 8 1140916224 131073 1152 0 0 0 7 0 0 0 1152 1180166 ##(Smalltalk.ResourceIdentifier)  848 8 #resource_Smalltalk_tools 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 1042 63 1 1042 991 51 1152 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 98 0 1042 193 193 0 27 8 'smalltalkTools' 410 1168 98 14 0 832 98 2 8 1140850688 131073 1536 0 0 0 7 0 0 0 1536 1234 848 8 #resource_Image_tools 0 1282 202 208 98 1 1346 1376 98 2 1042 1 1 1042 63 51 1536 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1488 1504 0 27 8 'imageTools' 234 256 1488 202 208 1488 234 240 1488 0 1 0 1042 33 33 1042 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 1282 202 208 98 2 1346 1376 98 2 1042 1 1 1042 1185 51 832 1346 8 #updateSize 1488 832 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 25 0 0 0] 98 2 1536 1152 1504 0 27 0 0 0 410 8 ##(Smalltalk.ImageView)  98 21 0 720 98 2 8 1140850944 1 2096 721990 2 ##(Smalltalk.ValueHolder)  0 32 1376774 ##(Smalltalk.PluggableSearchPolicy)  459270 ##(Smalltalk.Message)  8 #= 98 0 2242 8 #hash 98 0 0 482 29606851 0 7 0 0 0 2096 0 8 4294902281 852486 ##(Smalltalk.NullConverter)  0 0 0 0 8 #centered 1 0 0 1282 202 208 98 1 1346 1376 98 2 1042 1 51 1042 1185 643 2096 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 80 2 0 0 90 1 0 0] 98 0 1504 0 27 234 256 98 4 832 8 'toolbar' 2096 8 'backgroundImage' 0 1282 202 208 98 1 1346 1376 98 2 1042 1 1 1042 1185 693 720 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 90 1 0 0] 98 2 832 2096 1504 0 27 690 7 410 736 98 15 0 544 98 2 8 1140850688 131073 2832 0 917766 ##(Smalltalk.PluggableColor)  1346 8 #toolBackgroundColor 98 0 8 ##(Smalltalk.SmalltalkSystem)  0 5 0 0 0 2832 514 1 1 0 0 0 0 410 8 ##(Smalltalk.CardContainer)  98 16 0 2832 98 2 8 1140850688 131073 3008 0 2898 1346 2944 98 0 2976 0 21 265030 4 ##(Smalltalk.Menu)  0 16 98 2 3138 0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem)  1025 1180998 4 ##(Smalltalk.CommandDescription)  2242 8 #tabOrientation: 98 1 8 #top 8 '&Top' 1 1 0 0 0 3218 1025 3250 2242 3296 98 1 8 #bottom 8 '&Bottom' 1 1 0 0 0 3218 1025 3250 2242 3296 98 1 8 #left 8 '&Left' 1 1 0 0 0 3218 1025 3250 2242 3296 98 1 8 #right 8 '&Right' 1 1 0 0 0 8 '&Orientation' 0 134217729 0 0 0 0 0 3138 0 16 98 5 3218 1025 3250 2242 8 #viewMode: 98 1 8 #noIcons 8 '&No Icons' 1 1 0 0 0 3218 1025 3250 2242 3744 98 1 8 #smallIcons 8 '&Small Icons' 1 1 0 0 0 3218 1025 3250 2242 3744 98 1 8 #mediumIcons 8 'Medium Icons' 1 1 0 0 0 3218 1025 3250 2242 3744 98 1 8 #largeIcons 8 '&Large Icons' 1 1 0 0 0 3218 1 3250 2242 3744 98 1 8 #tileIcons 8 'Tile Icons' 1 1 0 0 0 8 '&View' 0 134217729 0 0 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 3008 626 202 208 1488 0 234 256 1488 0 410 8 ##(Smalltalk.TabViewXP)  98 28 0 3008 98 2 8 1140916736 1 4272 590662 2 ##(Smalltalk.ListModel)  202 208 1488 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  3088 0 17 0 0 0 4272 0 8 4294904659 787814 3 ##(Smalltalk.BlockClosure)  0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 8 ##(Smalltalk.ListControlView)  8 #defaultGetTextBlock 575230339 8 #[30 105 226 0 106] 8 #displayString 4464 7 257 0 4450 0 0 4482 2 3 8 ##(Smalltalk.IconicListAbstract)  8 #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] 8 #iconImageIndex 4576 7 257 0 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 3872 0 0 0 0 0 1282 202 208 98 2 1346 1376 98 2 1042 1 1 1042 1185 693 4272 1346 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 4272 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 90 1 0 0] 98 0 1504 0 27 1282 202 208 98 2 1346 1376 98 2 1042 1 1 1042 1185 693 3008 1346 8 #contextMenu: 98 1 3152 3008 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 90 1 0 0] 98 1 4272 1504 0 27 234 256 98 2 3008 8 'cards' 0 1282 202 208 98 1 1346 1376 98 2 1042 1 1 1042 1185 693 2832 1442 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 90 1 0 0] 98 1 3008 1504 0 27 720 234 256 98 2 720 8 'background' 0 1282 202 208 98 1 1346 1376 98 2 1042 1 1 1042 1185 693 544 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 90 1 0 0] 98 2 720 2832 1504 0 27 234 256 1488 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 4 3138 0 16 98 12 3218 1 3250 8 #fileNew 8 '&New' 9373 1 0 0 0 3218 1 3250 8 #fileOpen 8 '&Open...' 9375 1 0 0 0 3218 1 3250 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 3218 1 3250 8 #fileSave 8 '&Save' 9383 1 0 0 0 3218 1 3250 8 #fileSaveAs 8 'Save &As...' 1 1 0 0 0 3218 1 3250 8 #fileRevert 8 '&Revert' 1 1 0 0 0 5826 4097 3218 1 3250 8 #saveImage 8 'Sa&ve Image' 1 1 0 0 0 3218 1 3250 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 0 0 0 5826 4097 3218 1 3250 8 #exit 8 '&Close' 17639 1 0 0 0 8 '&File' 0 134217729 0 0 49707 0 0 3138 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 49709 0 0 3138 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 49711 0 0 3138 0 16 98 19 3218 1 3250 8 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  49 786694 ##(Smalltalk.ShellLibrary)  0 0 3218 1 3250 8 #help 8 'On this &Tool' 1249 1 0 0 0 3218 1 3250 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 5826 4097 3218 1 3250 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 5826 4097 3218 1 3250 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3218 1 3250 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3218 1 3250 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 3138 0 16 98 4 3218 2097153 3250 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 6514 0 16 6560 8 'TipOfTheDay.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 3218 1 3250 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 6514 0 16 6560 8 'TipOfTheDay.ico' 7168 0 0 5826 4097 3218 1 3250 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 49733 0 0 5826 4097 3218 1 3250 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3218 1 3250 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3218 1 3250 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 3218 1 3250 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 5826 4097 3218 1 3250 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 6514 0 16 6560 8 'LiveUpdate.ico' 7168 0 0 5826 4097 3218 1 3250 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6514 0 16 6560 8 '!!APPLICATION' 7168 0 0 8 '&Help' 0 134217729 0 0 49747 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1282 202 208 98 3 1346 1376 98 2 1042 2799 21 1042 1201 801 416 1346 8 #text: 98 1 8 'Dolphin Idea Space' 416 1346 8 #updateMenuBar 1488 416 1442 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 207 7 0 0 154 1 0 0] 98 1 544 1504 0 27 )! !

!Tools.Tests.IdeaSpaceShellTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
!

