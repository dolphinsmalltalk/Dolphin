"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #IdeaSpaceShell
	instanceVariableNames: 'cardsPresenter backgroundPresenter defaultMenuBar cardHistory filename'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
IdeaSpaceShell guid: (GUID fromString: '{402CF4F5-0B2E-4533-9664-C99FE1BF84FA}')!
Idea Space comment: ''!
!Idea Space categoriesForClass!Development!MVP-Presenters! !
!IdeaSpaceShell methodsFor!

absorbCard: card 
	card view setParent: cardsPresenter view.
	card view 
		setWindowPosAfter: HWND_BOTTOM asParameter
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
	existingToolbar parentView addSubView: newToolbar.
	newToolbar arrangement: #north.
	newToolbar layoutManager: BorderLayout new.
	existingToolbar setParent: newToolbar.
	existingToolbar arrangement: #center.
	cardToolbar := ReferenceView resourceIdentifier: self ideaCardToolbarId.
	newToolbar addSubView: cardToolbar.
	cardToolbar arrangement: #east!

addShellDecorations: aShell 
	| shellView |
	shellView := aShell view.
	(shellView 
		baseStyleMask: ##(WS_THICKFRAME | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX)
		set: true
		recreateIfChanged: true) ifTrue: [shellView frameChanged]!

allAdditionalAccelerators
	| answer |
	answer := OrderedCollection withAll: self additionalAccelerators.
	self subPresenters do: 
			[:each | 
			each == cardsPresenter 
				ifFalse: 
					[answer addAll: each additionalAccelerators.
					each allSubPresentersDo: [:eachSub | answer addAll: eachSub additionalAccelerators]]].
	self currentCard ifNotNil: [:tool | answer addAll: tool allAdditionalAccelerators].
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

installCardMenubarAndAccelerators
	self view menuBar: self currentCard view menuBar!

isCurrentCardFirst
	^self hasCurrentCard and: [self cards first = self currentCard]!

isCurrentCardLast
	^self hasCurrentCard and: [self cards last = self currentCard]!

isIdeaSpaceCard
	^false!

loadErrorDescriptionFrom: anException 
	(anException isKindOf: CompilerNotification) 
		ifTrue: [^'<1d> in line <2d>' expandMacrosWith: anException errorMessage with: anException line].
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
						errorMsg: ('There was a problem loading the IdeaSpace template: "<1d>". 

The error reported was: "<2d>". 

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

onCardChanged
	self installCardMenubarAndAccelerators.
	self updateCaption.
	cardHistory visit: self currentCard view!

onCloseRequested: aBooleanValue 
	"Private - A request to close the view onto the receiver as occurred.
	Prompt to save any outstanding changed"

	self cards isEmpty ifTrue: [^aBooleanValue value].
	(MessageBox confirm: 'Are you sure you wish to close this IdeaSpace?') 
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
		when: #currentCardChanged
		send: #onCardChanged
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
	(aSmalltalkToolShell view viewNamed: 'statusbar' ifNone: [^self]) hasSizeGrip: false!

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
			[self saveStateOn: stream] ensure: [stream close].
			saved := true]
		ifFalse: [saved := self saveIdeaSpaceAs]] 
			on: FileException
			do: 
				[:e | 
				MessageBox errorMsg: 'Unable to save file ' , e file name printString
					caption: 'Error - ' , e messageText].
	^saved!

saveIdeaSpaceAs
	| proceed newFilename |
	newFilename := (FileSaveDialog on: self filename asValue)
				fileTypes: self class fileTypes;
				defaultExtension: self class defaultFileExtension;
				caption: 'Save IdeaSpace As...';
				showModal.
	(proceed := newFilename notNil and: 
					[(File exists: newFilename) not or: 
							[MessageBox 
								confirm: ('<1s><n>This file already exists, are you sure you would like to overwrite it?' 
										expandMacrosWith: newFilename)
								caption: SessionManager current applicationName]]) 
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
			aWriteStream
				nextPutAll: ('"Create and configure a <1s>"' expandMacrosWith: each class name);
				cr;
				nextPut: $a;
				nextPutAll: each class name;
				nextPutAll: ' := ';
				nextPutAll: 'anIdeaSpace newEmbeddedCardOfClass: ';
				nextPutAll: each class name;
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
	aWriteStream
		nextPutAll: ('anIdeaSpace currentCardIndex: <1d>' expandMacrosWith: currentCardIndexInCardsToSave);
		cr.
	aWriteStream nextPut: $]!

setWatermark
	backgroundPresenter value: self watermarkBitmap!

tabs
	^cardsPresenter view tabs!

updateCaption
	self caption: (self hasCurrentCard ifTrue: [self currentCard caption] ifFalse: [self basicCaption])!

watermarkBitmap
	| bitmap |
	bitmap := Bitmap fromFile: 'Resources\IdeaSpaceBackdrop.bmp'
				usingLocator: FileLocator installRelative.
	^bitmap createWatermarkAlphaPercent: 60 backcolor: backgroundPresenter view backcolor! !
!IdeaSpaceShell categoriesFor: #absorbCard:!private! !
!IdeaSpaceShell categoriesFor: #addIdeaCardTools:!helpers!private! !
!IdeaSpaceShell categoriesFor: #addShellDecorations:!helpers!private! !
!IdeaSpaceShell categoriesFor: #allAdditionalAccelerators!constants!private! !
!IdeaSpaceShell categoriesFor: #basicCaption!constants!public! !
!IdeaSpaceShell categoriesFor: #breakoutCard:!private! !
!IdeaSpaceShell categoriesFor: #breakoutCurrentCard!public! !
!IdeaSpaceShell categoriesFor: #cardHistoryBack!commands!private! !
!IdeaSpaceShell categoriesFor: #cardHistoryForward!commands!private! !
!IdeaSpaceShell categoriesFor: #cards!accessing!public! !
!IdeaSpaceShell categoriesFor: #cardsPresenter!public! !
!IdeaSpaceShell categoriesFor: #closeCard!commands!public! !
!IdeaSpaceShell categoriesFor: #closeCard:!commands!public! !
!IdeaSpaceShell categoriesFor: #configureCardForIdeaSpace:!private! !
!IdeaSpaceShell categoriesFor: #createComponents!initializing!private! !
!IdeaSpaceShell categoriesFor: #createSchematicWiring!initializing!private! !
!IdeaSpaceShell categoriesFor: #currentCard!accessing!public! !
!IdeaSpaceShell categoriesFor: #currentCardIndex!public! !
!IdeaSpaceShell categoriesFor: #currentCardIndex:!public! !
!IdeaSpaceShell categoriesFor: #defaultHelpId!constants!public! !
!IdeaSpaceShell categoriesFor: #destroyCard:!commands!public! !
!IdeaSpaceShell categoriesFor: #filename!accessing!public! !
!IdeaSpaceShell categoriesFor: #filename:!accessing!public! !
!IdeaSpaceShell categoriesFor: #hasContents!public! !
!IdeaSpaceShell categoriesFor: #hasCurrentCard!public!testing! !
!IdeaSpaceShell categoriesFor: #hasFilename!public!testing! !
!IdeaSpaceShell categoriesFor: #historySkip:!helpers!public! !
!IdeaSpaceShell categoriesFor: #ideaCardToolbarId!Constants!private! !
!IdeaSpaceShell categoriesFor: #initialize!initializing!private! !
!IdeaSpaceShell categoriesFor: #installCardMenubarAndAccelerators!helpers!private! !
!IdeaSpaceShell categoriesFor: #isCurrentCardFirst!public!testing! !
!IdeaSpaceShell categoriesFor: #isCurrentCardLast!public!testing! !
!IdeaSpaceShell categoriesFor: #isIdeaSpaceCard!public!testing! !
!IdeaSpaceShell categoriesFor: #loadErrorDescriptionFrom:!private! !
!IdeaSpaceShell categoriesFor: #loadIdeaSpace!commands!private! !
!IdeaSpaceShell categoriesFor: #moveCardLeft!commands!public! !
!IdeaSpaceShell categoriesFor: #moveCardRight!commands!public! !
!IdeaSpaceShell categoriesFor: #newEmbeddedCardOfClass:!helpers!private! !
!IdeaSpaceShell categoriesFor: #onCardCaptionChanged!event handling!private! !
!IdeaSpaceShell categoriesFor: #onCardChanged!event handling!private! !
!IdeaSpaceShell categoriesFor: #onCloseRequested:!event handling!private! !
!IdeaSpaceShell categoriesFor: #onIdleEntered!event handling!private! !
!IdeaSpaceShell categoriesFor: #onTabsMiddleButtonClicked:!event handling!private! !
!IdeaSpaceShell categoriesFor: #onViewOpened!event handling!private! !
!IdeaSpaceShell categoriesFor: #openIdeaSpace!public! !
!IdeaSpaceShell categoriesFor: #openOn:!private! !
!IdeaSpaceShell categoriesFor: #queryCommand:!commands!private! !
!IdeaSpaceShell categoriesFor: #registerForCardEvents!helpers!private! !
!IdeaSpaceShell categoriesFor: #removeCard:!commands!private! !
!IdeaSpaceShell categoriesFor: #removeCardMenubarAndAccelerators!helpers!private! !
!IdeaSpaceShell categoriesFor: #removeHistoryForCard:!commands!private! !
!IdeaSpaceShell categoriesFor: #removeIdeaCardTools:!helpers!private! !
!IdeaSpaceShell categoriesFor: #removeShellDecorations:!helpers!private! !
!IdeaSpaceShell categoriesFor: #removeSizeGrip:!helpers!private! !
!IdeaSpaceShell categoriesFor: #restorePreviousCard:!commands!private! !
!IdeaSpaceShell categoriesFor: #revertIdeaSpace!public! !
!IdeaSpaceShell categoriesFor: #saveIdeaSpace!commands!operations!public! !
!IdeaSpaceShell categoriesFor: #saveIdeaSpaceAs!commands!operations!public! !
!IdeaSpaceShell categoriesFor: #saveStateOn:!private!saved state! !
!IdeaSpaceShell categoriesFor: #setWatermark!operations!private! !
!IdeaSpaceShell categoriesFor: #tabs!accessing!private! !
!IdeaSpaceShell categoriesFor: #updateCaption!helpers!private! !
!IdeaSpaceShell categoriesFor: #watermarkBitmap!constants!private! !

!IdeaSpaceShell class methodsFor!

defaultAdditionalAccelerators
	^#(#(#nextCard 'ALT+RIGHT') #(#previousCard 'ALT+LEFT') #(#closeCard 'Ctrl+F4'))!

defaultFileExtension
	"Answer a default extension that will be used for files saved from
	the receiver"

	^'st'!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Idea Space'!

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

	Smalltalk developmentSystem
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.

!

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

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 196934 1 ##(Smalltalk.RGB) 29606851 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 0 0 0 410 8 ##(Smalltalk.WizardCardContainer) 98 15 0 416 98 2 8 1140850688 131073 544 0 0 0 7 0 0 0 544 655878 ##(Smalltalk.CardLayout) 202 208 98 2 721414 ##(Smalltalk.Association) 5 410 8 ##(Smalltalk.ContainerView) 98 15 0 544 98 2 8 1140850688 131073 720 0 482 29606851 0 7 0 0 0 720 514 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 720 98 2 8 1140853516 131073 832 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 0 832 914 8 4278190080 8 4294903529 234 256 98 4 410 8 ##(Smalltalk.ReferenceView) 98 14 0 832 98 2 8 1140916224 131073 1152 0 0 0 7 0 0 0 1152 1180166 ##(Smalltalk.ResourceIdentifier) 848 8 #resource_Smalltalk_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 1042 63 1 1042 991 51 1152 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 98 0 1042 193 193 0 27 8 'smalltalkTools' 410 1168 98 14 0 832 98 2 8 1140850688 131073 1536 0 0 0 7 0 0 0 1536 1234 848 8 #resource_Image_tools 0 1282 202 208 98 1 1346 1376 98 2 1042 1 1 1042 63 51 1536 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1488 1504 0 27 8 'imageTools' 234 256 1488 202 208 1488 234 240 1488 0 1 0 1042 33 33 1042 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1282 202 208 98 2 1346 1376 98 2 1042 1 1 1042 1169 51 832 1346 8 #updateSizePosted 1488 832 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 25 0 0 0] 98 2 1536 1152 1504 0 27 0 0 0 410 8 ##(Smalltalk.ImageView) 98 21 0 720 98 2 8 1140850944 1 2096 721990 2 ##(Smalltalk.ValueHolder) 0 32 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) 8 #= 98 0 2242 8 #hash 98 0 0 482 29606851 0 7 0 0 0 2096 0 8 4294902281 852486 ##(Smalltalk.NullConverter) 0 0 0 0 8 #centered 1 0 0 1282 202 208 98 1 1346 1376 98 2 1042 1 51 1042 1169 633 2096 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 72 2 0 0 85 1 0 0] 98 0 1504 0 27 234 256 98 4 2096 8 'backgroundImage' 832 8 'toolbar' 0 1282 202 208 98 1 1346 1376 98 2 1042 1 1 1042 1169 683 720 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 98 2 832 2096 1504 0 27 690 7 410 736 98 15 0 544 98 2 8 1140850688 131073 2832 0 917766 ##(Smalltalk.PluggableColor) 1346 8 #toolBackgroundColor 98 0 8 ##(Smalltalk.SmalltalkSystem) 0 5 0 0 0 2832 514 1 1 0 0 0 0 410 8 ##(Smalltalk.CardContainer) 98 16 0 2832 98 2 8 1140850688 131073 3008 0 2898 1346 2944 98 0 2976 0 21 265030 4 ##(Smalltalk.Menu) 0 16 98 2 3138 0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem) 1025 1180998 4 ##(Smalltalk.CommandDescription) 2242 8 #tabOrientation: 98 1 8 #top 8 '&Top' 1 1 0 0 0 3218 1025 3250 2242 3296 98 1 8 #bottom 8 '&Bottom' 1 1 0 0 0 3218 1025 3250 2242 3296 98 1 8 #left 8 '&Left' 1 1 0 0 0 3218 1025 3250 2242 3296 98 1 8 #right 8 '&Right' 1 1 0 0 0 8 '&Orientation' 0 134217729 0 0 0 0 0 3138 0 16 98 5 3218 1025 3250 2242 8 #viewMode: 98 1 8 #noIcons 8 '&No Icons' 1 1 0 0 0 3218 1025 3250 2242 3744 98 1 8 #smallIcons 8 '&Small Icons' 1 1 0 0 0 3218 1025 3250 2242 3744 98 1 8 #mediumIcons 8 'Medium Icons' 1 1 0 0 0 3218 1025 3250 2242 3744 98 1 8 #largeIcons 8 '&Large Icons' 1 1 0 0 0 3218 1 3250 2242 3744 98 1 8 #tileIcons 8 'Tile Icons' 1 1 0 0 0 8 '&View' 0 134217729 0 0 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 3008 626 202 208 1488 0 234 256 1488 0 410 8 ##(Smalltalk.TabViewXP) 98 28 0 3008 98 2 8 1140916736 1 4272 590662 2 ##(Smalltalk.ListModel) 202 208 1488 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 3088 0 17 0 0 0 4272 0 8 4294903943 787814 3 ##(Smalltalk.BlockClosure) 0 0 918822 ##(Smalltalk.CompiledMethod) 2 3 8 ##(Smalltalk.ListControlView) 8 #defaultGetTextBlock 575230339 8 #[30 105 226 0 106] 8 #displayString 4464 7 257 0 4450 0 0 4482 2 3 8 ##(Smalltalk.IconicListAbstract) 8 #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] 8 #iconImageIndex 4576 7 257 0 1049926 1 ##(Smalltalk.IconImageManager) 0 0 0 0 0 3968 0 0 0 0 0 1282 202 208 98 2 1346 1376 98 2 1042 1 1 1042 1169 685 4272 1346 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 4272 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 86 1 0 0] 98 0 1504 0 27 1282 202 208 98 2 1346 1376 98 2 1042 1 1 1042 1169 685 3008 1346 8 #contextMenu: 98 1 3152 3008 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 86 1 0 0] 98 1 4272 1504 0 27 234 256 98 2 3008 8 'cards' 0 1282 202 208 98 1 1346 1376 98 2 1042 1 1 1042 1169 683 2832 1442 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 98 1 3008 1504 0 27 720 234 256 98 2 720 8 'background' 0 1282 202 208 98 1 1346 1376 98 2 1042 1 1 1042 1169 683 544 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 98 2 720 2832 1504 0 27 234 256 1488 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 4 3138 0 16 98 12 3218 1 3250 8 #fileNew 8 '&New' 9373 1 0 0 0 3218 1 3250 8 #fileOpen 8 '&Open...' 9375 1 0 0 0 3218 1 3250 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3218 1 3250 8 #fileSave 8 '&Save' 9383 1 0 0 0 3218 1 3250 8 #fileSaveAs 8 'Save &As...' 1 1 0 0 0 3218 1 3250 8 #fileRevert 8 '&Revert' 1 1 0 0 0 5826 4097 3218 1 3250 8 #saveImage 8 'Sa&ve Image' 1 1 0 0 0 3218 1 3250 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 0 0 0 5826 4097 3218 1 3250 8 #exit 8 '&Close' 17639 1 0 0 0 8 '&File' 0 134217729 0 0 36459 0 0 3138 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 36461 0 0 3138 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 36463 0 0 3138 0 16 98 15 3218 1 3250 8 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 49 786694 ##(Smalltalk.ShellLibrary) 0 0 3218 1 3250 8 #help 8 'On this &Tool' 1249 1 0 0 0 3218 1 3250 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 5826 4097 3218 1 3250 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 5826 4097 3218 1 3250 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3218 1 3250 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3218 1 3250 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 5826 4097 3218 1 3250 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3218 1 3250 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3218 1 3250 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 5826 4097 3218 1 3250 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6514 0 16 6560 8 '!!APPLICATION' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 8 '&Help' 0 134217729 0 0 36487 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1282 202 208 98 3 1346 1376 98 2 1042 3839 21 1042 1201 801 416 1346 8 #text: 98 1 8 'Dolphin Idea Space' 416 1346 8 #updateMenuBar 1488 416 1442 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 98 1 544 1504 0 27 )!

toolsFolderHelpId
	^10599!

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self! !
!IdeaSpaceShell class categoriesFor: #defaultAdditionalAccelerators!constants!public! !
!IdeaSpaceShell class categoriesFor: #defaultFileExtension!constants!public! !
!IdeaSpaceShell class categoriesFor: #displayOn:!displaying!public! !
!IdeaSpaceShell class categoriesFor: #fileTypes!constants!private! !
!IdeaSpaceShell class categoriesFor: #getFilename!instance creation!private! !
!IdeaSpaceShell class categoriesFor: #icon!constants!public! !
!IdeaSpaceShell class categoriesFor: #initialize!initializing!private! !
!IdeaSpaceShell class categoriesFor: #open!instance creation!public! !
!IdeaSpaceShell class categoriesFor: #openOn:!instance creation!public! !
!IdeaSpaceShell class categoriesFor: #resource_Default_view!public!resources-views! !
!IdeaSpaceShell class categoriesFor: #toolsFolderHelpId!constants!public! !
!IdeaSpaceShell class categoriesFor: #uninitialize!class hierarchy-removing!private! !

