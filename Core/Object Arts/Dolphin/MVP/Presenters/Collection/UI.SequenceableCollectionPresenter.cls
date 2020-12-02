"Filed out from Dolphin Smalltalk 7"!

CollectionPresenter subclass: #SequenceableCollectionPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SequenceableCollectionPresenter guid: (GUID fromString: '{87b4c68c-026e-11d3-9fd7-00a0cc3e4a32}')!
SequenceableCollectionPresenter comment: 'SequenceableCollectionPresenter is a <valuePresenter> that presents a <sequencedCollection> accessed via its <valueModel>. It provides a number of [operations]for editing the list. As changes are made to the list it is applied back to the presenter''s <valueModel>.

'!
!SequenceableCollectionPresenter categoriesForClass!MVP-Presenters! !
!SequenceableCollectionPresenter methodsFor!

canReorder
	"Private - Answer true if it is valid to reorder the receiver's collection"

	^self isReadOnly not 
		and: [self model canSet and: [self model value class conformsToProtocol: #sequencedCollection]]!

moveDown
	"Moves the current selection closer to the end of the receiver's list"

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

	| list index |
	index := listPresenter selectionByIndex.
	list := self listModel.
	list noEventsDo: 
			[| item |
			item := list at: index.
			list replaceFrom: 2 to: index with: list startingAt: 1.
			list at: 1 put: item].
	list notifyListChanged.
	listPresenter selectionByIndex: 1!

moveLast
	"Moves the current selection to be the last  item in the receiver's list"

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

	| index list |
	index := listPresenter selectionByIndex.
	list := self listModel.
	list noEventsDo: [list swap: index with: index - 1].
	list notifyListChanged.
	listPresenter selectionByIndex: index - 1!

onValueChanged
	"Private - The value has been changed in the receiver's model.
	Transfer the value to the listModel"

	listPresenter list: self value!

queryCommand: query
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>, query"

	| command |
	command := query commandSymbol.
	(#(#moveUp #moveFirst) identityIncludes: command) 
		ifTrue: 
			[query isEnabled: (self canReorder and: [listPresenter selectionByIndex > 1]).
			^true].
	(#(#moveDown #moveLast) identityIncludes: command) 
		ifTrue: 
			[query 
				isEnabled: (self canReorder and: 
							[| selected |
							selected := listPresenter selectionByIndex.
							selected > 0 and: [selected < self listModel size]]).
			^true].
	^super queryCommand: query! !
!SequenceableCollectionPresenter categoriesFor: #canReorder!private!testing! !
!SequenceableCollectionPresenter categoriesFor: #moveDown!commands!operations!public! !
!SequenceableCollectionPresenter categoriesFor: #moveFirst!commands!operations!public! !
!SequenceableCollectionPresenter categoriesFor: #moveLast!commands!operations!public! !
!SequenceableCollectionPresenter categoriesFor: #moveUp!commands!operations!public! !
!SequenceableCollectionPresenter categoriesFor: #onValueChanged!event handling!private! !
!SequenceableCollectionPresenter categoriesFor: #queryCommand:!commands!private! !

!SequenceableCollectionPresenter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 512 nil nil nil 5 nil nil nil 512 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_List_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 722 501 51 512 674 #text: 34 1 8 'toolbar' 512 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 250 0 0 0 25 0 0 0] 8 #() 722 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140936781 1025 896 590662 2 ##(Smalltalk.ListModel) 138 144 864 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #moveFirst 8 'Move to &First' 1 1 nil nil nil 1122 1 1154 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 1122 1 1154 #moveDown 8 'Move to &Next' 1 1 nil nil nil 1122 1 1154 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 896 nil 8 1883852064 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 493 #left 1378 #displayString 1408 1378 #<= 8 #() nil nil 896 nil 3 nil nil #report 864 nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 610 138 144 34 2 674 #createAt:extent: 34 2 722 1 51 722 501 251 896 674 #contextMenu: 34 1 1088 896 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 250 0 0 0 150 0 0 0] 8 #() 880 nil 35 170 192 34 2 896 8 'list' nil 610 138 144 34 1 674 #createAt:extent: 34 2 722 7039 21 722 501 301 416 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 185 14 0 0 160 0 0 0] 34 2 512 896 880 nil 27 )! !
!SequenceableCollectionPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

