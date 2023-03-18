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

	self canGrow
		ifTrue: 
			[| item |
			item := addItemBlock notNil ifTrue: [addItemBlock value] ifFalse: [self defaultAddItem].
			item notNil ifTrue: [self addItem: item]]
		ifFalse: [Sound errorBeep]!

addItem: anObject
	"Add anObject into the receiver's list"

	self listModel add: anObject
	!

canGrow
	"Private - Answer true if it is valid to add and remove elements of the receiver's collection"

	^self isReadOnly not and: 
			[self model canSet 
				and: [self model value class conformsToProtocol: #sequencedContractibleCollection]]!

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

defaultAddItem
	"Private - Prompts to add an item to the receiver. Used if no addItemBlock has been specified"

	^self promptForExpression: 'Evaluate:' caption: 'Add Item'!

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

promptForExpression: promptString caption: captionString
	| result text |
	result := nil.
	text := '' asValue.
	
	[| expression |
	expression := Prompter
				on: text
				prompt: promptString
				caption: captionString.
	expression notNil and: 
			[| error |
			
			[result := Compiler evaluate: expression.
			error := nil] on: Compiler errorClass , Error
					do: 
						[:ex |
						error := ex.
						ex return: nil].
			error notNil and: 
					[(MessageBox new
						buttonStyle: #yesNo;
						iconStyle: #error;
						caption: 'Error evaluating expression…';
						headline: error displayString;
						errorMsg: 'Try again?') == #yes]]]
			whileTrue.
	^result!

queryCommand: query
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>, query"

	| command |
	command := query commandSymbol.
	(#(#addItem) identityIncludes: command) 
		ifTrue: 
			[query isEnabled: self canGrow.
			^true].
	(#(#removeItem) identityIncludes: command) 
		ifTrue: 
			[query isEnabled: (self canGrow and: [listPresenter hasSelection]).
			^true].
	^super queryCommand: query!

removeItem
	"Removes the current selection from the receiver's list"

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
addItem!commands!public! !
addItem:!operations!public! !
canGrow!private!testing! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultAddItem!helpers!private! !
initialize!initializing!public! !
isReadOnly!public!testing! !
isReadOnly:!modes!public! !
listModel!public! !
listPresenter!accessing!public! !
model:!accessing!public! !
onListChanged!event handling!private! !
onSelectionChanged!public! !
onValueChanged!event handling!private! !
promptForExpression:caption:!helpers!private! !
queryCommand:!commands!private! !
removeItem!commands!operations!public! !
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1409289036 131137 512 nil nil nil 517 nil nil nil 512 917510 #{Graphics.Color} #default 8 1815075056 170 192 8 #() nil nil nil 170 192 34 4 64391 1311814 1 #{UI.ToolbarIconButton} 512 1 1377606 4 #{UI.CommandDescription} #addItem 8 'New Item' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'NewThing.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil 64391 64393 690 512 1 722 #removeItem 8 'Delete Item' 1 1 770 nil true 802 8 'EditClear.ico' 864 65541 nil 64393 34 3 704 896 1245766 1 #{UI.ToolbarSeparator} 512 1 nil nil 1 nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 1138 501 51 512 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 250 0 0 0 25 0 0 0] 8 #() 1138 193 193 nil 29 nil nil nil 410 #{UI.ListView} 34 45 nil 416 34 2 8 1140936781 1025 1264 787270 2 #{UI.ListModel} 138 144 640 nil 1769478 #{Kernel.IdentitySearchPolicy} 592 nil 1029 461638 4 #{UI.Menu} nil true 34 1 1180742 2 #{UI.CommandMenuItem} 1 722 #removeItem 8 '&Delete' 1 1 770 nil true 802 8 'EditClear.ico' 864 65541 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 1264 nil 8 1815049392 786950 #{Core.Message} #displayString 8 #() 1602 #iconImageIndex 640 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 '' 493 #left 1602 #displayString 1632 1602 #<= 8 #() nil nil 1264 nil 3 nil nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1042 34 2 1090 #createAt:extent: 34 2 1138 1 51 1138 501 251 1264 1090 #contextMenu: 34 1 1424 1264 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 250 0 0 0 150 0 0 0] 8 #() 1248 nil 35 170 192 34 2 1264 8 'list' nil 1042 34 1 1090 #createAt:extent: 34 2 1138 12287 21 1138 501 301 416 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 249 24 0 0 160 0 0 0] 34 2 512 1264 1248 nil 27)! !
!UI.CollectionPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

