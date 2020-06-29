"Filed out from Dolphin Smalltalk 7"!

ContainerView subclass: #AbstractCardContainer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractCardContainer guid: (GUID fromString: '{87b4c718-026e-11d3-9fd7-00a0cc3e4a32}')!
AbstractCardContainer comment: 'AbstractCardContainer is an abstract <compositeView> class that implements the base <cardView> protocol for its concrete sub-classes. A <cardView> has a fixed CardLayout manager for arranging its sub-views (which are generally known as "cards"). The cards are arranged in a stack, one on top of the other, like cards in a card file box. The <cardView> protocol provides methods for bringing individual cards to the front of the stack and allowing them to be displayed.

Typically one would use a <cardView> to create "tabbed" dialog boxes or multi-page wizards. There are specific concrete subclasses, CardContainer and WizardCardContainer, to do this.'!
!AbstractCardContainer categoriesForClass!MVP-Resources-Card Containers!MVP-Views! !
!AbstractCardContainer methodsFor!

cardLayout
	^self layoutManager!

cards
	^self managedSubViews!

currentCard
	"Answer the subview of the receiver that is the currently visible
	card or nil if there is none"

	^self cardLayout currentCard!

cycleNextCard
	"Select the next card in z order sequence after the current card.
	Cycle round to the first card in the sequence where necessary.
	Answers the card selected"

	^self cardLayout cycleNextCard!

cyclePreviousCard
	"Select the previous card in z order sequence before the current card.
	Cycle round to the last card in the sequence where necessary.
	Answers the card selected"

	^self cardLayout cyclePreviousCard!

defaultLayoutManager
	^CardLayout new!

ensureSubViewVisible: aSubView 
	"Ensures that aSubView is visible in the receiver. Show the appropriate card
	if it is not already visible"

	super ensureSubViewVisible: aSubView.
	self cardLayout showCard: aSubView!

firstCard
	"Show the card which is first in the z-order sequence of the 
	associated container. It is an error to ask for the first card
	when there is none. Answers the view that is the first card."

	self cardLayout firstCard.
	^self tabOntoCurrentCard!

lastCard
	"Show the card which is last in the z-order sequence of the 
	associated container. It is an error to ask for the first card
	when there is none. Answers the view that is the last card."

	self cardLayout lastCard.
	^self tabOntoCurrentCard!

nextCard
	"Show the card which is next in the z-order sequence of the 
	associated container after the current card that is visible. 
	Answers the view that is the next card or nil if there is none"

	self cardLayout nextCard.
	^self tabOntoCurrentCard!

onCurrentCardChanged
	"Private - The current card has been changed in the layout manager. 
	Trigger our own card change event."

	self trigger: #currentCardChanged!

onSubViewAdded: aView 
	"Private - Received when aView has been added to the receiver.
	Ensure that this is given an arrangement to make it a suitable citizen
	of the receiver."

	super onSubViewAdded: aView.
	aView arrangement isNil ifTrue: [aView arrangement: self cards size].
	self cardLayout showCard: aView.
	aView show!

onViewCreated
	"Private - Create the tabs view if it is not already present"

	super onViewCreated.
	self cardLayout 
		when: #currentCardChanged
		send: #onCurrentCardChanged
		to: self!

previousCard
	"Show the card which is previous in the z-order sequence of the 
	associated container before the current card that is visible. 
	Answers the view that is the previous card or nil if there is none"

	self cardLayout previousCard.
	^self tabOntoCurrentCard!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver into the <CommandQuery>
	argument."

	| cmd |
	cmd := aCommandQuery commandSymbol.
	cmd == #nextCard 
		ifTrue: 
			[aCommandQuery isEnabled: self currentCard ~= self cardLayout cards last.
			^true].
	cmd == #previousCard 
		ifTrue: 
			[aCommandQuery isEnabled: self currentCard ~= self cardLayout cards first.
			^true].
	^super queryCommand: aCommandQuery!

tabOntoCurrentCard
	"Private - The receiver has just displayed a new card.
	Tab to the first tab stop. Ask for the state to be refreshed. 
	Answer the current card"

	| card |
	card := self currentCard.
	card notNil ifTrue: [ 
		card tabFirst.
		self invalidateUserInterface ].
	^card


	

	!

validateSubViewLayouts: aLayoutContext 
	"Private - Validate the layout of the visible sub-views of the receiver."

	self currentCard ifNotNil: [:card | card validateLayout: aLayoutContext]! !
!AbstractCardContainer categoriesFor: #cardLayout!accessing!private! !
!AbstractCardContainer categoriesFor: #cards!accessing!public! !
!AbstractCardContainer categoriesFor: #currentCard!accessing!public! !
!AbstractCardContainer categoriesFor: #cycleNextCard!commands!public! !
!AbstractCardContainer categoriesFor: #cyclePreviousCard!commands!public! !
!AbstractCardContainer categoriesFor: #defaultLayoutManager!initializing!private! !
!AbstractCardContainer categoriesFor: #ensureSubViewVisible:!public!sub views! !
!AbstractCardContainer categoriesFor: #firstCard!commands!public! !
!AbstractCardContainer categoriesFor: #lastCard!commands!public! !
!AbstractCardContainer categoriesFor: #nextCard!commands!public! !
!AbstractCardContainer categoriesFor: #onCurrentCardChanged!event handling!private! !
!AbstractCardContainer categoriesFor: #onSubViewAdded:!event handling!private! !
!AbstractCardContainer categoriesFor: #onViewCreated!event handling!private! !
!AbstractCardContainer categoriesFor: #previousCard!commands!public! !
!AbstractCardContainer categoriesFor: #queryCommand:!commands!private! !
!AbstractCardContainer categoriesFor: #tabOntoCurrentCard!operations!private! !
!AbstractCardContainer categoriesFor: #validateSubViewLayouts:!geometry!private! !

AbstractCardContainer methodProtocol: #cardView attributes: #(#readOnly) selectors: #(#currentCard #cycleNextCard #cyclePreviousCard #firstCard #lastCard #nextCard #onCurrentCardChanged #previousCard)!

