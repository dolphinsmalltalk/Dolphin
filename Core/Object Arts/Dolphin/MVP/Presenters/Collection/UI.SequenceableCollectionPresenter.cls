"Filed out from Dolphin Smalltalk"!

UI.CollectionPresenter
	subclass: #'UI.SequenceableCollectionPresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.SequenceableCollectionPresenter guid: (Core.GUID fromString: '{87b4c68c-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.SequenceableCollectionPresenter comment: 'SequenceableCollectionPresenter is a <valuePresenter> that presents a <sequencedCollection> accessed via its <valueModel>. It provides a number of [operations]for editing the list. As changes are made to the list it is applied back to the presenter''s <valueModel>.

'!

!UI.SequenceableCollectionPresenter categoriesForClass!MVP-Presenters! !

!UI.SequenceableCollectionPresenter methodsFor!

canMoveDown
	^self canReorder and: [listPresenter selectionByIndex between: 1 and: self listModel size - 1]!

canMoveUp
	^self canReorder and: [listPresenter selectionByIndex > 1]!

canReorder
	"Private - Answer true if it is valid to reorder the receiver's collection"

	^self isReadOnly not 
		and: [self model canSet and: [self model value class conformsToProtocol: #sequencedCollection]]!

moveDown
	"Moves the current selection closer to the end of the receiver's list"

	<commandQuery: #canMoveDown>
	| index list |
	index := listPresenter selectionByIndex.
	list := self listModel.
	"Although we are only swapping two elements, the collection presenter responds to any event
	from the list model by refreshing everything (see
	CollectionPresenter>>createSchematicWiring). We don't want to refresh it twice."
	list noEventsDo: [list swap: index with: index + 1].
	list notifyListChanged.
	listPresenter selectionByIndex: index + 1!

moveFirst
	"Moves the current selection to be the first item in the receiver's list"

	<commandQuery: #canMoveUp>
	| list index |
	index := listPresenter selectionByIndex.
	list := self listModel.
	list noEventsDo: 
			[| item |
			item := list at: index.
			list
				replaceFrom: 2
				to: index
				with: list
				startingAt: 1.
			list at: 1 put: item].
	list notifyListChanged.
	listPresenter selectionByIndex: 1!

moveLast
	"Moves the current selection to be the last item in the receiver's list"

	<commandQuery: #canMoveDown>
	| list index last |
	index := listPresenter selectionByIndex.
	list := self listModel.
	last := list size.
	list noEventsDo: 
			[| item |
			item := list at: index.
			list 
				replaceFrom: index
				to: last - 1
				with: list
				startingAt: index + 1.
			list at: last put: item].
	list notifyListChanged.
	listPresenter selectionByIndex: last!

moveUp
	"Moves the current selection closer to the head of the receiver's list"

	<commandQuery: #canMoveUp>
	| index list |
	index := listPresenter selectionByIndex.
	list := self listModel.
	list noEventsDo: [list swap: index with: index - 1].
	list notifyListChanged.
	listPresenter selectionByIndex: index - 1!

onValueChanged
	"Private - The value has been changed in the receiver's model.
	Transfer the value to the listModel"

	listPresenter list: self value! !

!UI.SequenceableCollectionPresenter categoriesForMethods!
canMoveDown!commands-queries!private!testing! !
canMoveUp!commands-queries!private!testing! !
canReorder!commands-queries!private!testing! !
moveDown!commands-actions!operations!public! !
moveFirst!commands-actions!operations!public! !
moveLast!commands-actions!operations!public! !
moveUp!commands-actions!operations!public! !
onValueChanged!event handling!private! !
!

!UI.SequenceableCollectionPresenter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 144 nil nil nil 5 nil nil nil 144 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_List_tools nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 1 338 501 51 144 290 #text: 50 1 8 'toolbar' 144 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 250 0 0 0 25 0 0 0] 8 #() 338 193 193 nil 27 nil nil nil 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140936781 1025 512 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #moveFirst 8 'Move to &First' 1 1 nil nil nil 754 1 786 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 754 1 786 #moveDown 8 'Move to &Next' 1 1 nil nil nil 754 1 786 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 512 nil nil 518 #{Core.Message} #displayString 8 #() 994 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 610 1 3142 5 #{UI.ListViewColumn} 8 '' 493 #left 994 #displayString 1024 994 #<= 8 #() nil nil 512 nil 3 nil nil #report 8 #() nil 133217 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 242 50 1 290 #createAt:extent: 50 2 338 1 51 338 501 251 512 434 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 250 0 0 0 150 0 0 0] 8 #() 496 nil 35 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 512 8 'list' nil 242 50 1 290 #createAt:extent: 50 2 338 6143 21 338 501 301 32 434 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 249 12 0 0 160 0 0 0] 50 2 144 512 496 nil 27)! !

!UI.SequenceableCollectionPresenter class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

