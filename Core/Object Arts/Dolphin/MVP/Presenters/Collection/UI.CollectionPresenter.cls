"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'UI.CollectionPresenter'
	instanceVariableNames: 'addItemBlock listPresenter changing flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'ReadOnlyMask' -> 16r1 }!

UI.CollectionPresenter guid: (Core.GUID fromString: '{cef6a076-8a4e-4dc8-9732-9241724d99e3}')!

UI.CollectionPresenter comment: 'CollectionPresenter is a <valuePresenter> that presents a <Collection> accessed via its <valueModel>. It provides a number of [operations] for editing the list. As changes are made to the list it is applied back to the presenter''s <valueModel>.

Instance Variables:
	listPresenter	<ListPresenter> presenting the list accessed as the value of the presenter''s model.
'!

!UI.CollectionPresenter categoriesForClass!MVP-Presenters!MVP-Resources-Lists! !

!UI.CollectionPresenter methodsFor!

addItem
	"Uses the receiver's addItemBlock to answer a new item to add to the collection"

	<commandQuery: #canAddItem>
	self canAddItem
		ifTrue: [addItemBlock value ifNotNil: [:item | self addItem: item]]
		ifFalse: [Sound errorBeep]!

addItem: anObject
	"Add anObject into the receiver's list"

	self listModel add: anObject
	!

canAddItem
	"Private - Answer true if it is valid to add elements to the receiver's collection"

	^addItemBlock notNil and: [self canAddOrRemoveItems]!

canAddOrRemoveItems
	"Private - Answer true if it is valid to add and remove elements of the receiver's collection"

	^self isReadOnly not and: 
			[self model canSet and: [self model value class conformsToProtocol: #sequencedContractibleCollection]]!

canRemoveItem
	^self canAddOrRemoveItems and: [listPresenter hasSelection]!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	listPresenter := self add: ListPresenter new name: 'list'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	(listPresenter model)
		when: #item:updatedAtIndex:
			send: #onListChanged
			to: self;
		when: #item:removedAtIndex:
			send: #onListChanged
			to: self;
		when: #item:addedAtIndex:
			send: #onListChanged
			to: self;
		when: #listChanged
			send: #onListChanged
			to: self.
	listPresenter 
		when: #selectionChanged
		send: #onSelectionChanged
		to: self!

initialize
	changing := false.
	flags := 0.
	super initialize!

isReadOnly
	"Answer whether this presenter is in read-only mode"

	^flags allMask: ReadOnlyMask!

isReadOnly: aBoolean
	"Set whether this presenter is in read-only mode"

	flags := flags mask: ReadOnlyMask set: aBoolean!

listModel
	^listPresenter model!

listPresenter
	^listPresenter!

model: aValueModel
	"Set the model of the receiver to be aValueModel. We intercept a change
	notification so that the list selection can track this value."

	super model: aValueModel.
	self onValueChanged
!

onListChanged
	"Private - The internal collection has been changed so update the receiver's model."

	changing ifTrue: [^self].
	
	[changing := true.
	self value: listPresenter list] ensure: [changing := false]!

onSelectionChanged
	self trigger: #selectionChanged!

onValueChanged
	"Private - The value has been changed in the receiver's model.
	Transfer the value to the listModel"

	changing ifTrue: [^self].
	
	[changing := true.
	listPresenter list: self value asOrderedCollection] 
			ensure: [changing := false]!

removeItem
	"Removes the current selection from the receiver's list"

	<commandQuery: #canRemoveItem>
	| index |
	index:= listPresenter selectionByIndex.
	self listModel removeAtIndex: index.
	listPresenter selectionByIndex: (index min: listPresenter model size)!

selectionOrNil
	"Return the selected object or nil if no selection."

	^listPresenter selectionOrNil!

selectionOrNil: anObject 
	"Select the first occurrence of the <Object>, anObject, in the collection. If anObject is
	nil, then simply remove the existing selection. If anObject is not present then signal a
	NotFoundError. Answer anObject."

	^listPresenter selectionOrNil: anObject!

setAddItemBlock: aNiladicValuable
	"Set the block to evaluate when adding new items to the receiver's collection"

	addItemBlock := aNiladicValuable! !

!UI.CollectionPresenter categoriesForMethods!
addItem!commands-actions!public! !
addItem:!operations!public! !
canAddItem!commands-queries!private!testing! !
canAddOrRemoveItems!commands-queries!private!testing! !
canRemoveItem!commands-queries!private!testing! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
initialize!initializing!public! !
isReadOnly!public!testing! !
isReadOnly:!modes!public! !
listModel!public! !
listPresenter!accessing!public! !
model:!accessing!public! !
onListChanged!event handling!private! !
onSelectionChanged!public! !
onValueChanged!event handling!private! !
removeItem!commands-actions!operations!public! !
selectionOrNil!public!selection! !
selectionOrNil:!public!selection! !
setAddItemBlock:!accessing!public! !
!

!UI.CollectionPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^OrderedCollection new asValue!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) instanceClass defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1409289036 131137 144 nil nil nil 517 nil nil nil 144 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 3 1094 1 #{UI.ToolbarIconButton} 144 1 1350 4 #{UI.CommandDescription} #addItem 8 'New Item' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'NewThing.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil 306 144 1 338 #removeItem 8 'Delete Item' 1 1 386 nil true 418 8 'EditClear.ico' 480 65541 nil nil 582 1 #{UI.ToolbarSeparator} 144 1 nil nil 9 1 nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 250 0 0 0 25 0 0 0] 193 176 8 '' 144 3 8 #() 518 #{Graphics.Point} 193 193 nil 31 nil nil nil 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140936781 1025 880 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 224 nil 1029 2886 4 #{UI.Menu} nil true 50 1 1094 2 #{UI.CommandMenuItem} 1 338 #removeItem 8 '&Delete' 1 1 386 nil true 418 8 'EditClear.ico' 480 65541 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 880 nil nil 518 #{Core.Message} #displayString 8 #() 1218 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 978 1 3142 5 #{UI.ListViewColumn} 8 '' 493 #left 1218 #displayString 1248 1218 #<= 8 #() nil nil 880 nil 3 nil nil #report 8 #() nil 133217 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 880 nil nil nil nil nil nil nil nil nil 642 50 2 690 #createWindow: 50 1 738 770 8 #[0 0 0 0 25 0 0 0 250 0 0 0 150 0 0 0] 193 912 8 '' 880 690 #contextMenu: 50 1 1056 880 3 8 #() 850 193 193 nil 35 242 #{Core.IdentityDictionary} 50 2 880 8 'list' nil 642 50 1 690 #createWindow: 50 1 738 770 8 #[255 14 0 0 10 0 0 0 249 15 0 0 160 0 0 0] 193 80 8 '' 32 1 50 2 144 880 850 193 193 nil 27)! !

!UI.CollectionPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

