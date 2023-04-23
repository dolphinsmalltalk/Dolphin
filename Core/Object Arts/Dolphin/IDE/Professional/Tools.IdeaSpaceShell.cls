"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.IdeaSpaceShell'
	instanceVariableNames: 'cardsPresenter backgroundPresenter defaultMenuBar cardHistory filename'
	classVariableNames: 'Watermark'
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.IdeaSpaceShell guid: (Core.GUID fromString: '{402cf4f5-0b2e-4533-9664-c99fe1bf84fa}')!
Tools.IdeaSpaceShell comment: ''!
!Tools.IdeaSpaceShell categoriesForClass!MVP-Presenters! !
!Tools.IdeaSpaceShell methodsFor!

absorbCard: card
	card view setParent: cardsPresenter view.
	card view
		setWindowPosAfter: HWND_BOTTOM
		x: 0
		y: 0
		width: 0
		height: 0
		flags: SWP_NOSIZE | SWP_NOMOVE | SWP_NOACTIVATE.
	cardsPresenter view ensureTabsAtBack.
	cardsPresenter add: card.
	card view basicMenu: nil.
	self configureCardForIdeaSpace: card!

addIdeaCardTools: aSmalltalkToolShell 
	| existingToolbar newToolbar cardToolbar |
	existingToolbar := aSmalltalkToolShell view viewNamed: 'toolbar' ifNone: [^self].
	newToolbar := Toolbar new.
	newToolbar backcolor: nil; hasDivider: false.
	existingToolbar parentView addSubView: newToolbar.
	newToolbar arrangement: #north.
	newToolbar layoutManager: BorderLayout new.
	existingToolbar setParent: newToolbar.
	existingToolbar arrangement: #center.
	cardToolbar := ReferenceView resourceIdentifier: self ideaCardToolbarId.
	newToolbar addSubView: cardToolbar.
	cardToolbar backcolor: nil.
	cardToolbar arrangement: #east!

addShellDecorations: aShell 
	| shellView |
	shellView := aShell view.
	(shellView 
		baseStyleMask: ##(WS_THICKFRAME | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX)
		set: true
		recreateIfChanged: true) ifTrue: [shellView frameChanged]!

allAdditionalKeyBindings
	| answer |
	answer := OrderedCollection withAll: self additionalKeyBindings.
	self subPresenters do: 
			[:each | 
			each == cardsPresenter 
				ifFalse: 
					[answer addAll: each additionalKeyBindings.
					each allSubPresentersDo: [:eachSub | answer addAll: eachSub additionalKeyBindings]]].
	self currentCard ifNotNil: [:tool | answer addAll: tool allAdditionalKeyBindings].
	^answer!

basicCaption
	^'Idea Space'!

breakoutCard: cardToBreakout 
	| last |
	cardToBreakout hide.
	cardToBreakout parentPresenter: nil.
	cardToBreakout view setParent: View desktop.
	last := self removeCard: cardToBreakout.
	self removeIdeaCardTools: cardToBreakout.
	self addShellDecorations: cardToBreakout.
	cardToBreakout show.
	self restorePreviousCard: last!

breakoutCurrentCard
	"Break the current card out onto the desktop"

	self removeCardMenubarAndAccelerators.
	self breakoutCard: self currentCard!

cardHistoryBack
	self historyBack!

cardHistoryForward
	^self historyForward!

cards
	"Answer the cards held by the receiver"

	"Go through the managed views of the card presenter rather than using #subPresenters to ensure
	that the cards are in the correct order"

	^cardsPresenter view managedSubViews collect: [:each | each presenter]!

cardsPresenter
	^cardsPresenter!

closeCard
	"Close the current card after first giving it an opportunity to refuse the close. 
	Answer true if the close is allowed."

	<acceleratorKey: 'Ctrl+F4'>
	^self closeCard: self currentCard!

closeCard: cardToRemove 
	"Close cardToRemove after first giving it an opportunity to refuse the close.
	Answer true if the close is allowed."

	cardToRemove view queryClose ifFalse: [^false].
	self destroyCard: cardToRemove.
	^true!

configureCardForIdeaSpace: cardToConfigure 
	"Configure cardToConfigure for use within this IdeaSpace."

	cardToConfigure 
		when: #captionChanged
		send: #onCardCaptionChanged
		to: self.
	self removeShellDecorations: cardToConfigure.
	self removeSizeGrip: cardToConfigure.
	self addIdeaCardTools: cardToConfigure.
	(cardToConfigure view)
		arrangement: cardToConfigure;
		ensureVisible.
	^cardToConfigure!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	cardsPresenter := self add: Presenter new name: 'cards'.
	backgroundPresenter := self add: ImagePresenter new name: 'backgroundImage'!

createSchematicWiring
	"Private - Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self tabs 
		when: #middleButtonReleased:
		send: #onTabsMiddleButtonClicked:
		to: self.
	self 
		when: #closeRequested:
		send: #onCloseRequested:
		to: self!

currentCard
	"Answer the current card presenter on view in the receiver"

	^cardsPresenter view currentCard ifNotNil: [:currentCardView | currentCardView presenter]!

currentCardIndex
	self hasCurrentCard ifFalse: [^0].
	^self cards indexOf: self currentCard!

currentCardIndex: anInteger 
	anInteger = 0 ifTrue: [^self].
	(self cards at: anInteger) ensureVisible!

defaultHelpId
	^10852!

destroyCard: cardToRemove 
	"Destroy cardToRemove giving it no opportunity to refuse"

	| last |
	last := self removeCard: cardToRemove.
	self restorePreviousCard: last	!

filename
	"Answers the name of the file associated with the receiver or nil
	if there is none"

	^filename!

filename: aStringOrNil
	"Sets the name of the file associated with the receiver"

	filename := nil.
	(aStringOrNil notNil and: [ aStringOrNil notEmpty ])
		ifTrue: [ filename := aStringOrNil ].
	self updateCaption!

hasContents
	^self cards notEmpty or: [self hasFilename]!

hasCurrentCard
	^cardsPresenter view currentCard notNil!

hasFilename
	"Answers true if the receiver has an associated file"

	^filename notNil
!

historySkip: anInteger 
	cardHistory skip: anInteger.
	cardHistory current ensureVisible!

ideaCardToolbarId
	^ResourceIdentifier class: Toolbar name: 'Idea space card tools'!

initialize
	super initialize.
	cardHistory := HistoryList new.
	cardHistory searchPolicy: SearchPolicy identity!

installCardMenubarAndAccelerators: aView
	self view menuBar: aView menuBar!

isCurrentCardFirst
	^self hasCurrentCard and: [self cards first = self currentCard]!

isCurrentCardLast
	^self hasCurrentCard and: [self cards last = self currentCard]!

isIdeaSpaceCard
	^false!

loadErrorDescriptionFrom: anException
	(anException isKindOf: CompilerNotification)
		ifTrue: [^'<1s> in line <2p>' expandMacrosWith: anException errorMessage with: anException line].
	^anException description!

loadIdeaSpace
	"Private - Loads the receiver from its associated template file (if any)"

	Cursor wait showWhile: 
			[| stream |
			stream := FileStream read: self filename.
			[self view noRedrawDo: [self configureFromSavedStateString: stream contents]]
				on: CompilerNotification , Error
				do: 
					[:x |
					self view enableRedraw.
					MessageBox
						errorMsg: ('There was a problem loading the IdeaSpace template: "<1s>". 

The error reported was: "<2s>". 

As as result the new IdeaSpace may only be partially complete. Please bear in mind that you
can only reload an IdeaSpace into an equivalent image to the one that was used to save the
original template. Missing Packages, Classes or Methods may give rise to errors.'
								expandMacrosWith: (File splitFilenameFrom: self filename)
								with: (self loadErrorDescriptionFrom: x))
						caption: 'Problem Loading IdeaSpace'].
			stream close]!

moveCardLeft
	| cardView nextSibling |
	cardView := self currentCard view.
	nextSibling := cardView previousSiblingView.
	nextSibling notNil ifTrue: [nextSibling := nextSibling previousSiblingView].
	nextSibling notNil ifTrue: [cardView zOrderAfter: nextSibling] ifFalse: [cardView zOrderTop]!

moveCardRight
	| cardView nextSibling |
	cardView := self currentCard view.
	nextSibling := cardView nextSiblingView.
	nextSibling notNil ifTrue: [cardView zOrderAfter: nextSibling]!

newEmbeddedCardOfClass: toolClass 
	^(self view noRedrawDo: 
			[| card |
			card := toolClass createIn: cardsPresenter.
			self configureCardForIdeaSpace: card.
			self updateCaption.
			card]) 
		show!

onCardCaptionChanged
	self updateCaption.
	cardsPresenter view updateTabs!

onCardChangedFrom: previousView to: currentView
	self installCardMenubarAndAccelerators: currentView.
	self updateCaption.
	cardHistory visit: currentView!

onCloseRequested: aBooleanValue
	"Private - A request to close the view onto the receiver as occurred.
	Prompt to save any outstanding changed"

	self cards isEmpty ifTrue: [^aBooleanValue value].
	(MessageBox new
		headline: 'Close this IdeaSpace?';
		confirm)
			ifTrue: [aBooleanValue value: (self cards allSatisfy: [:each | each view queryClose])]
			ifFalse: [aBooleanValue value: false].
	^aBooleanValue value!

onIdleEntered
	"Private - There are no messages in the input queue and the input state is
	about to go idle. Reflect back to the view so that it can update
	any visible UI elements such as toolbar buttons."

	self cards do: [:each | each onIdleEntered].
	^super onIdleEntered
!

onTabsMiddleButtonClicked: aMouseEvent 
	(self tabs itemFromPoint: aMouseEvent position) 
		ifNotNil: [:clicked | self closeCard: (self cards at: clicked)]!

onViewOpened
	super onViewOpened.
	self registerForCardEvents.
	self setWatermark.
	defaultMenuBar := self view menuBar.
!

openIdeaSpace
	"Prompt for a template filename and open the contents inside the receiver if it is empty. Otherwise
	create a new IdeaSpace to hold the contents of the file."

	| openFilename |
	self hasContents ifTrue: [^self model openIdeaSpace].
	openFilename := self class getFilename.
	openFilename isNil ifTrue: [^nil].
	^self openOn: openFilename!

openOn: openFilename 
	self
		filename: openFilename;
		loadIdeaSpace!

queryCommand: aCommandQuery 
	| selector |
	selector := aCommandQuery commandSymbol.
	#moveCardLeft == selector 
		ifTrue: 
			[aCommandQuery isEnabled: self isCurrentCardFirst not.
			^true].
	#moveCardRight == selector 
		ifTrue: 
			[aCommandQuery isEnabled: self isCurrentCardLast not.
			^true].
	#cardHistoryBack == selector 
		ifTrue: 
			[aCommandQuery isEnabled: cardHistory hasPast.
			^true].
	#cardHistoryForward == selector 
		ifTrue: 
			[aCommandQuery isEnabled: cardHistory hasFuture.
			^true].
	#breakoutCurrentCard == selector 
		ifTrue: 
			[aCommandQuery isEnabled: self hasCurrentCard.
			^true].
	(#(#dragToolToIdeaSpace #addToNewIdeaSpace) includes: selector) 
		ifTrue: 
			[aCommandQuery isEnabled: false.
			^true].
	#revertIdeaSpace == selector 
		ifTrue: 
			[aCommandQuery isEnabled: self hasFilename.
			^true].
	^super queryCommand: aCommandQuery!

registerForCardEvents
	cardsPresenter view 
		when: #currentCardChangedFrom:to:
		send: #onCardChangedFrom:to:
		to: self!

removeCard: cardToRemove 
	| last |
	last := self removeHistoryForCard: cardToRemove.
	self removeCardMenubarAndAccelerators.
	cardsPresenter remove: cardToRemove.
	^last!

removeCardMenubarAndAccelerators
	self view menuBar: defaultMenuBar!

removeHistoryForCard: cardToRemove 
	cardHistory remove: cardToRemove view.
	^cardHistory isEmpty ifFalse: [cardHistory current]!

removeIdeaCardTools: aSmalltalkToolShell 
	| originalToolbar replacementToolbar |
	originalToolbar := aSmalltalkToolShell view viewNamed: 'toolbar' ifNone: [^self].
	replacementToolbar := originalToolbar parentView.
	originalToolbar setParent: replacementToolbar parentView.
	replacementToolbar destroy.
	originalToolbar arrangement: #north!

removeShellDecorations: aShell 
	| shellView |
	shellView := aShell view.
	(shellView 
		baseStyleMask: ##(WS_THICKFRAME | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX)
		set: false
		recreateIfChanged: false) ifTrue: [shellView frameChanged]!

removeSizeGrip: aSmalltalkToolShell
	(aSmalltalkToolShell view viewNamed: 'statusbar' ifNone: nil)
		ifNotNil: [:statusbar | statusbar hasSizeGrip: false]!

restorePreviousCard: last 
	last isNil 
		ifTrue: 
			[self cards notEmpty 
				ifTrue: 
					[self currentCard isNil ifTrue: [self cards last ensureVisible].
					self currentCard ensureVisible]
				ifFalse: 
					[backgroundPresenter ensureVisible.
					self updateCaption]]
		ifFalse: 
			[self currentCard isNil ifTrue: [self cards last ensureVisible].
			last == self currentCard view 
				ifFalse: 
					["Closing the card moved to the previous sibling card, which
					 was not the last visited. Need to skip back and pop off
					 this visit"
					self historyBack.
					cardHistory clearFuture]]!

revertIdeaSpace
	self exit ifFalse: [^self].
	self class openOn: self filename!

saveIdeaSpace
	| saved |
	saved := false.
	
	[self hasFilename
		ifTrue: 
			[| stream |
			stream := FileStream write: self filename text: true.
			stream locale: Locale smalltalk.
			[self saveStateOn: stream] ensure: [stream close].
			saved := true]
		ifFalse: [saved := self saveIdeaSpaceAs]]
			on: FileException
			do: 
				[:e |
				MessageBox new
					headline: 'Unable to save file <1p>' << e file name;
					errorMsg: e messageText].
	^saved!

saveIdeaSpaceAs
	| proceed newFilename |
	newFilename := (FileSaveDialog on: self filename asValue)
				fileTypes: self class fileTypes;
				defaultExtension: self class defaultFileExtension;
				caption: 'Save IdeaSpace As…';
				showModal.
	(proceed := newFilename notNil and: 
					[(File exists: newFilename) not or: 
							[MessageBox new
								headline: 'Overwrite <1s>?' << newFilename;
								confirm: 'The file already exists, are you sure you would like to overwrite it?']])
		ifTrue: 
			["Install the new filename"
			self
				filename: newFilename;
				saveIdeaSpace].
	^proceed!

saveStateOn: aWriteStream
	"Private - Write the source of a monadic block that will configure an instance of the receiver's class
	to match the state current receiver, to aWriteStream. The block expects a fresh instance of
	the receiver's class as it's parameter"

	| cardsToSave currentCardIndexInCardsToSave |
	aWriteStream nextPutAll: '[:anIdeaSpace | | '.
	cardsToSave := self cards select: [:each | each canSaveState].
	(cardsToSave collect: [:each | each class name]) asSet do: 
			[:each |
			aWriteStream
				space;
				nextPut: $a;
				nextPutAll: each].
	aWriteStream
		space;
		nextPut: $|;
		cr.
	cardsToSave do: 
			[:each |
			'"Create and configure a <1s>"' expandMacrosWithArguments: {each class name} on: aWriteStream.
			aWriteStream
				cr;
				nextPut: $a;
				nextPutAll: each class name;
				nextPutAll: ' := ';
				nextPutAll: 'anIdeaSpace newEmbeddedCardOfClass: ';
				nextPutAll: each class fullName;
				nextPut: $.;
				cr.
			each saveStateOn: aWriteStream.
			aWriteStream
				space;
				nextPutAll: 'value: ';
				nextPut: $a;
				nextPutAll: each class name;
				nextPut: $.;
				cr;
				cr].
	currentCardIndexInCardsToSave := cardsToSave indexOf: self currentCard.
	'anIdeaSpace currentCardIndex: <1d>' expandMacrosWithArguments: {currentCardIndexInCardsToSave}
		on: aWriteStream.
	aWriteStream cr.
	aWriteStream nextPut: $]!

setWatermark
	backgroundPresenter value: self watermarkBitmap!

tabs
	^cardsPresenter view tabs!

updateCaption
	self caption: (self hasCurrentCard ifTrue: [self currentCard caption] ifFalse: [self basicCaption])!

watermarkBitmap
	^Watermark
		ifNil: 
			[Watermark := (self icon asAlphaBitmap: 256 @ 256) createWatermarkAlphaPercent: 60
						backcolor: backgroundPresenter view backcolor]! !
!Tools.IdeaSpaceShell categoriesForMethods!
absorbCard:!private! !
addIdeaCardTools:!helpers!private! !
addShellDecorations:!helpers!private! !
allAdditionalKeyBindings!constants!private! !
basicCaption!constants!public! !
breakoutCard:!private! !
breakoutCurrentCard!public! !
cardHistoryBack!commands!private! !
cardHistoryForward!commands!private! !
cards!accessing!public! !
cardsPresenter!public! !
closeCard!commands!public! !
closeCard:!commands!public! !
configureCardForIdeaSpace:!private! !
createComponents!initializing!private! !
createSchematicWiring!initializing!private! !
currentCard!accessing!public! !
currentCardIndex!public! !
currentCardIndex:!public! !
defaultHelpId!constants!public! !
destroyCard:!commands!public! !
filename!accessing!public! !
filename:!accessing!public! !
hasContents!public! !
hasCurrentCard!public!testing! !
hasFilename!public!testing! !
historySkip:!helpers!public! !
ideaCardToolbarId!Constants!private! !
initialize!initializing!private! !
installCardMenubarAndAccelerators:!helpers!private! !
isCurrentCardFirst!public!testing! !
isCurrentCardLast!public!testing! !
isIdeaSpaceCard!public!testing! !
loadErrorDescriptionFrom:!private! !
loadIdeaSpace!commands!private! !
moveCardLeft!commands!public! !
moveCardRight!commands!public! !
newEmbeddedCardOfClass:!helpers!private! !
onCardCaptionChanged!event handling!private! !
onCardChangedFrom:to:!event handling!private! !
onCloseRequested:!event handling!private! !
onIdleEntered!event handling!private! !
onTabsMiddleButtonClicked:!event handling!private! !
onViewOpened!event handling!private! !
openIdeaSpace!public! !
openOn:!private! !
queryCommand:!commands!private! !
registerForCardEvents!helpers!private! !
removeCard:!commands!private! !
removeCardMenubarAndAccelerators!helpers!private! !
removeHistoryForCard:!commands!private! !
removeIdeaCardTools:!helpers!private! !
removeShellDecorations:!helpers!private! !
removeSizeGrip:!helpers!private! !
restorePreviousCard:!commands!private! !
revertIdeaSpace!public! !
saveIdeaSpace!commands!operations!public! !
saveIdeaSpaceAs!commands!operations!public! !
saveStateOn:!private!saved state! !
setWatermark!operations!private! !
tabs!accessing!private! !
updateCaption!helpers!private! !
watermarkBitmap!constants!private! !
!

!Tools.IdeaSpaceShell class methodsFor!

defaultAdditionalAccelerators
	^#(#(#nextCard 'ALT+RIGHT') #(#previousCard 'ALT+LEFT'))!

defaultFileExtension
	"Answer a default extension that will be used for files saved from
	the receiver"

	^'st'!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Idea Space'!

fileTypes
	"Private - Answer an Array of file types that can be associated with this
	class of document."

	| domain |
	domain := self defaultModel.
	^(OrderedCollection new)
		add: domain ideaSpaceFilesType;
		add: domain smalltalkFilesType;
		add: FileDialog allFilesType;
		asArray!

getFilename
	^(FileOpenDialog new)
		fileTypes: self fileTypes;
		defaultExtension: self defaultFileExtension;
		showModal!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver.

		self initialize.
	"

	SmalltalkSystem current
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self!

open
	"Answers an instance of the receiver open on a filename that has been
	prompted for. If 'Cancel' is pressed in the file open dialog then
	answer nil"

	| openFilename |
	openFilename := self getFilename.
	openFilename isNil ifTrue: [^nil].
	^self openOn: openFilename!

openOn: openFilename 
	^(self show)
		openOn: openFilename;
		yourself!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		removeKey: #reuseIfOpen;
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 #{Graphics.ThemeColor} #toolBackground nil 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 nil nil nil nil 410 #{UI.WizardCardContainer} 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 853318 1 #{UI.CardLayout} 138 144 34 2 1049094 #{Core.Association} 5 410 #{UI.ContainerView} 34 15 nil 528 34 2 8 1140850688 131073 688 nil nil nil 7 nil nil nil 688 498 1 1 410 #{UI.Toolbar} 34 28 nil 688 34 2 8 1140853580 131073 768 nil nil nil 519 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 768 917510 #{Graphics.Color} #default 8 1815075056 170 192 34 6 410 #{UI.ReferenceView} 34 14 nil 768 34 2 8 1140916224 131073 1024 nil nil nil 7 nil nil nil 1024 1376838 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Smalltalk_tools nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 914 71 1 914 641 59 1024 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 0 0 0 0 99 1 0 0 29 0 0 0] 8 #() 914 193 193 nil 27 8 'smalltalkTools' 410 #{UI.ReferenceView} 34 14 nil 768 34 2 8 1140850688 131073 1344 nil nil nil 7 nil nil nil 1344 1090 #{UI.Toolbar} #resource_Search_tools nil 1122 34 1 1170 #createAt:extent: 34 2 914 711 1 914 445 59 1344 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 99 1 0 0 0 0 0 0 65 2 0 0 29 0 0 0] 1296 1312 nil 27 8 'searchTools' 410 #{UI.ReferenceView} 34 14 nil 768 34 2 8 1140850688 131073 1568 nil nil nil 7 nil nil nil 1568 1090 #{UI.Toolbar} #resource_Image_tools nil 1122 34 1 1170 #createAt:extent: 34 2 914 1 1 914 71 59 1568 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 35 0 0 0 29 0 0 0] 1296 1312 nil 27 8 'imageTools' nil nil nil 170 192 1296 138 144 1296 nil nil 1 nil 914 41 41 nil nil 852806 1 #{UI.FlowLayout} 1 1 1 1122 34 1 1170 #createAt:extent: 34 2 914 1 1 914 1169 59 768 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 29 0 0 0] 34 3 1568 1024 1344 1312 nil 29 nil nil nil 410 #{UI.ImageView} 34 21 nil 688 34 2 8 1140850944 1 2016 918598 2 #{UI.ValueHolder} nil false 1835526 #{Kernel.PluggableSearchPolicy} 786950 #{Core.Message} #= 8 #() 2146 #hash 8 #() nil 946 #face3d nil 7 nil nil nil 2016 nil 8 4294902281 1049094 #{UI.NullConverter} nil nil nil nil #centered 1 nil nil 1122 34 1 1170 #createAt:extent: 34 2 914 1 59 914 1169 625 2016 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 29 0 0 0 72 2 0 0 85 1 0 0] 8 #() 1312 nil 27 170 192 34 4 2016 8 'backgroundImage' 768 8 'toolbar' nil 1122 34 1 1170 #createAt:extent: 34 2 914 1 1 914 1169 683 688 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 2 768 2016 1312 nil 27 658 7 410 #{UI.ContainerView} 34 15 nil 528 34 2 8 1140850688 131073 2656 nil nil nil 5 nil nil nil 2656 498 1 1 nil nil nil nil 410 #{UI.CardContainer} 34 16 nil 2656 34 2 8 1140850688 131073 2736 nil nil nil 21 461638 4 #{UI.Menu} nil true 34 2 2802 nil true 34 4 1180742 2 #{UI.CommandMenuItem} 1025 1377606 4 #{UI.CommandDescription} 2146 #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 2882 1025 2914 2146 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 2882 1025 2914 2146 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 2882 1025 2914 2146 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 2802 nil true 34 5 2882 1025 2914 2146 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 2882 1025 2914 2146 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 2882 1025 2914 2146 #viewMode: 8 #(#mediumIcons) 8 'Medium Icons' 1 1 nil nil nil 2882 1025 2914 2146 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 2882 1 2914 2146 #viewMode: 8 #(#tileIcons) 8 'Tile Icons' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2736 594 138 144 1296 nil nil nil nil 170 192 1296 nil 410 #{UI.TabViewXP} 34 28 nil 2736 34 2 8 1140916736 1 3760 787270 2 #{UI.ListModel} 138 144 1296 nil 1769478 #{Kernel.IdentitySearchPolicy} nil nil 17 nil nil nil 3760 nil 8 1814862704 2146 #displayString 1296 2146 #iconImageIndex 1296 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil #mediumIcons nil nil nil nil nil 1122 34 2 1170 #createAt:extent: 34 2 914 1 1 914 1169 683 3760 1170 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 3760 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 8 #() 1312 nil 27 1122 34 2 1170 #createAt:extent: 34 2 914 1 1 914 1169 683 2736 1170 #contextMenu: 34 1 2816 2736 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 1 3760 1312 nil 27 170 192 34 2 2736 8 'cards' nil 1122 34 1 1170 #createAt:extent: 34 2 914 1 1 914 1169 683 2656 1250 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 1 2736 1312 nil 27 688 nil nil nil 170 192 34 2 688 8 'background' nil 1122 34 1 1170 #createAt:extent: 34 2 914 1 1 914 1169 683 528 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 2 688 2656 1312 nil 27 170 192 1296 nil 658246 4 #{UI.MenuBar} nil true 34 4 2802 nil true 34 8 2882 1 2914 #fileNew 8 '&New Workspace' 9373 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 2882 1 2914 #fileOpen 8 '&Open Workspace…' 9375 1 4866 nil true 4898 8 'OpenWorkspace.ico' 4960 65541 nil nil nil 2882 1 2914 #fileFileIn 8 '&File In…' 1 1 4866 nil true 4898 8 'FileIn.ico' 4960 65541 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 2882 1 2914 #saveImage 8 'Sa&ve Image' 1 1 4866 nil true 4898 8 'Snapshot.ico' 4960 65541 nil nil nil 2882 1 2914 #smalltalkExit 8 'E&xit Dolphin' 1 1 4866 nil true 4898 8 'PowerSwitch.ico' 4960 65541 nil nil nil 5186 4097 2882 1 2914 #exit 8 '&Close' 17639 1 1378630 2 #{Graphics.TextTileIcon} $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 25855 nil nil 2802 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 25857 nil nil 2802 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 25859 nil nil 2802 nil true 34 15 2882 1 2914 #helpContents 8 '&Contents' 1025 1 4866 nil true 4898 8 'Help.ico' 4960 65541 nil nil nil 2882 1 2914 #help 8 'On this &Tool' 1249 1 nil nil nil 2882 1 2914 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5186 4097 2882 1 2914 #learnSmalltalk 8 'Learn Smalltalk' 1 1 5474 $\x1F393 nil 946 #orchid 946 #white nil nil 1 nil nil nil nil 5186 4097 2882 1 2914 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2882 1 2914 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2882 1 2914 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5186 4097 2882 1 2914 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 4866 nil true 4898 8 '!!APPLICATION' 4960 65541 nil nil nil 2882 1 2914 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2882 1 2914 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5186 4097 2882 1 2914 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5474 $\x1F42C nil nil 946 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 25883 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1122 34 2 1170 #createAt:extent: 34 2 914 12287 21 914 1201 801 416 1170 #text: 34 1 8 'Dolphin Idea Space' 416 1250 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 87 26 0 0 154 1 0 0] 34 1 528 1312 nil 27)!

toolsFolderHelpId
	^10599! !
!Tools.IdeaSpaceShell class categoriesForMethods!
defaultAdditionalAccelerators!constants!private! !
defaultFileExtension!constants!public! !
displayOn:!displaying!public! !
fileTypes!constants!private! !
getFilename!instance creation!private! !
icon!constants!public! !
initialize!initializing!private! !
open!instance creation!public! !
openOn:!instance creation!public! !
publishedAspects!operations!public! !
resource_Default_view!public!resources-views! !
toolsFolderHelpId!constants!public! !
!

