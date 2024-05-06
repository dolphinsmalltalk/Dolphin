"Filed out from Dolphin Smalltalk"!

SelectableItemsTest subclass: #SlideyInneyOuteyThingTest
	instanceVariableNames: 'allowCardChange'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SlideyInneyOuteyThingTest guid: (GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!

SlideyInneyOuteyThingTest comment: ''!

!SlideyInneyOuteyThingTest categoriesForClass!Unclassified! !

!SlideyInneyOuteyThingTest methodsFor!

classToTest
	^SlideyInneyOuteyThing!

initializePresenter
	super initializePresenter.
	presenter animationDuration: 0 milliseconds.
	#(#red #green #blue) do: 
			[:each |
			| child |
			child := ColorView new.
			child model value: (Color perform: each).
			presenter tray addSubView: child.
			child arrangement: each capitalized].
	allowCardChange := true!

objectsToTest
	^{5. 0. '&Hello && Welcome'. #(1 2 3). 0 @ 0}!

onCardChanged
	events addLast: ((SelectionChangedEvent forSource: presenter tray)
				newSelection: presenter tray currentCard;
				yourself)!

onCardChanging: aSelectionChangingEvent
	events add: aSelectionChangingEvent.
	aSelectionChangingEvent value: allowCardChange!

selectionView
	^presenter tabs!

testCardChange
	"Verify that preventing the card change works, and that multiple events are not sent."

	| mouseClick event |
	"Programmatic selection change will not trigger the changing event - the change cannot be prevented"
	events := OrderedCollection new.
	presenter tray
		when: #currentCardChanging:
			send: #onCardChanging:
			to: self;
		when: #currentCardChanged
			send: #onCardChanged
			to: self.
	presenter tabs selectionByIndex: 1.
	self assert: events size equals: 1.
	event := events single.
	self assert: event isKindOf: SelectionChangeEvent.
	self assert: event newSelection value equals: Color red.
	"Change selection by mouse click"
	events := OrderedCollection new.
	mouseClick := self mouseDownEventOnItem: 2 buttons: { #left }.
	self sendClickEvent: mouseClick.
	self assert: presenter tabs selectionsByIndex equals: #(2).
	self assert: events size equals: 2.
	event := events first.
	self assert: event isKindOf: SelectionChangingEvent.
	self assert: event oldSelections equals: { 'Red' }.
	"Block selection change by mouse click"
	events := OrderedCollection new.
	allowCardChange := false.
	mouseClick := self mouseDownEventOnItem: 3 buttons: { #left }.
	self sendClickEvent: mouseClick.
	self assert: presenter tabs selectionsByIndex equals: #(2).
	self assert: events size equals: 1!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assert: view backcolor identicalTo: Color default.
	self assert: view animation identicalTo: #roll.
	self assert: view isEnabled.
	self assert: view isCardChangeAnimated.
	self assert: view isTrayResizable.
	self assert: view isHiddenOnUnpin.
	self assert: view inheritContextMenu! !

!SlideyInneyOuteyThingTest categoriesForMethods!
classToTest!helpers!private! !
initializePresenter!public!Running! !
objectsToTest!helpers!private! !
onCardChanged!event handling!private! !
onCardChanging:!event handling!private! !
selectionView!accessing!private! !
testCardChange!public!unit tests! !
verifyUpgradedView:identifier:!helpers!private! !
!

