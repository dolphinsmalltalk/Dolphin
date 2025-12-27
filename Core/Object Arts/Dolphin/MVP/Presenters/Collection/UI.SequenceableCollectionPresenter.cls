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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 144 nil nil nil 5 nil nil nil 144 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_List_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 250 0 0 0 25 0 0 0] 193 176 8 'toolbar' 144 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 nil nil nil 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140936781 1025 480 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #moveFirst 8 'Move to &First' 1 1 nil nil nil 722 1 754 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 722 1 754 #moveDown 8 'Move to &Next' 1 1 nil nil nil 722 1 754 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 480 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 6 1 #{Core.Message} 8 'doIt' 8 '[:obj | [obj displayString] on: Error do: [:ex | ex description]]' 8 #[33 105 17 252 0 0 0 2 3 0 226 0 106 46 34 193 106 226 2 106] #displayString 1094 2 #{Kernel.VariableBinding} #Error #{Core.Error} #{Core} 1 #description #on:do: 976 962 0 nil 1008 37 257 nil 7 257 nil 962 0 nil 994 5 1 #{Core.SmallInteger} 8 'doIt' 8 '[:obj | [obj iconImageIndex] on: Error do: [:ex | -1]]' 8 #[32 105 17 252 0 0 0 2 3 0 226 0 106 46 33 192 106 61 106] #iconImageIndex 1088 #on:do: 1120 962 0 nil 1136 37 257 nil 7 257 nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 578 1 3142 5 #{UI.ListViewColumn} 8 '' 493 #left 962 0 nil 994 6 1 #{Core.Message} 8 'doIt' 8 '[:obj | [obj displayString] on: Error do: [:ex | ex description]]' 8 #[33 105 17 252 0 0 0 2 3 0 226 0 106 46 34 193 106 226 2 106] #displayString 1088 #description #on:do: 1312 962 0 nil 1328 37 257 nil 7 257 nil 518 #{Core.Message} #<= 8 #() nil nil 480 nil 3 nil nil #report 8 #() nil 133217 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 480 nil nil nil nil nil nil nil nil nil 242 50 2 290 #createWindow: 50 1 338 370 8 #[0 0 0 0 25 0 0 0 250 0 0 0 150 0 0 0] 193 512 8 '' 480 290 #contextMenu: 50 1 688 480 3 8 #() 450 193 193 nil 35 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 480 8 'list' nil 242 50 1 290 #createWindow: 50 1 338 370 8 #[255 11 0 0 10 0 0 0 249 12 0 0 160 0 0 0] 193 80 8 '' 32 1 50 2 144 480 450 193 193 nil 27)! !

!UI.SequenceableCollectionPresenter class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

