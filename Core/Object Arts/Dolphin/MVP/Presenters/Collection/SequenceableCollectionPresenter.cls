"Filed out from Dolphin Smalltalk"!

CollectionPresenter subclass: #SequenceableCollectionPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!SequenceableCollectionPresenter categoriesForMethods!
canReorder!private!testing! !
moveDown!commands!operations!public! !
moveFirst!commands!operations!public! !
moveLast!commands!operations!public! !
moveUp!commands!operations!public! !
onValueChanged!event handling!private! !
queryCommand:!commands!private! !
!

!SequenceableCollectionPresenter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 512 nil nil nil 5 nil nil nil 512 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_List_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 250 0 0 0 25 0 0 0] 193 544 8 'toolbar' 512 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140936781 1025 864 590662 2 ##(Smalltalk.ListModel) 138 144 816 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #moveFirst 8 'Move to &First' 1 1 nil nil nil 1090 1 1122 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 1090 1 1122 #moveDown 8 'Move to &Next' 1 1 nil nil nil 1090 1 1122 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 864 nil 8 1759068368 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 493 #left 1346 #displayString 1376 1346 #<= 8 #() nil nil 864 nil 3 nil nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 610 138 144 34 2 674 #createWindow: 34 1 722 754 8 #[0 0 0 0 25 0 0 0 250 0 0 0 150 0 0 0] 193 896 8 '' 864 674 #contextMenu: 34 1 1056 864 3 8 #() 834 193 193 nil 35 170 192 34 2 864 8 'list' nil 610 138 144 34 1 674 #createWindow: 34 1 722 754 8 #[191 13 0 0 10 0 0 0 185 14 0 0 160 0 0 0] 193 448 8 '' 416 1 34 2 512 864 834 193 193 nil 27 )! !

!SequenceableCollectionPresenter class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

