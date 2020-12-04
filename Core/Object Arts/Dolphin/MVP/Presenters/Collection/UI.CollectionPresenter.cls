"Filed out from Dolphin Smalltalk 7"!

UI.ValuePresenter subclass: #'UI.CollectionPresenter'
	instanceVariableNames: 'addItemBlock listPresenter changing flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'ReadOnlyMask' -> 16r1
	}!
UI.CollectionPresenter guid: (Core.GUID fromString: '{cef6a076-8a4e-4dc8-9732-9241724d99e3}')!
UI.CollectionPresenter comment: 'CollectionPresenter is a <valuePresenter> that presents a <Collection> accessed via its <valueModel>. It provides a number of [operations]for editing the list. As changes are made to the list it is applied back to the presenter''s <valueModel>.

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
					[| mb |
					mb := MessageBox new.
					mb buttonStyle: #yesNo.
					mb caption: 'Error evaluating expression...'.
					(mb errorMsg: ('<1d><n><n>Try again?' expandMacrosWithArguments: {error} locale: Locale smalltalk))
						== #yes]]]
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
	"Select the first occurence of the <Object>, anObject, in the collection. If anObject is
	nil, then simply remove the existing selection. If anObject is not present then signal a
	NotFoundError. Answer anObject."

	^listPresenter selectionOrNil: anObject!

setAddItemBlock: aNiladicValuable
	"Set the block to evaluate when adding new items to the receiver's collection"

	addItemBlock := aNiladicValuable! !
!UI.CollectionPresenter categoriesFor: #addItem!commands!public! !
!UI.CollectionPresenter categoriesFor: #addItem:!operations!public! !
!UI.CollectionPresenter categoriesFor: #canGrow!private!testing! !
!UI.CollectionPresenter categoriesFor: #createComponents!initializing!public! !
!UI.CollectionPresenter categoriesFor: #createSchematicWiring!initializing!public! !
!UI.CollectionPresenter categoriesFor: #defaultAddItem!helpers!private! !
!UI.CollectionPresenter categoriesFor: #initialize!initializing!public! !
!UI.CollectionPresenter categoriesFor: #isReadOnly!public!testing! !
!UI.CollectionPresenter categoriesFor: #isReadOnly:!modes!public! !
!UI.CollectionPresenter categoriesFor: #listModel!public! !
!UI.CollectionPresenter categoriesFor: #listPresenter!accessing!public! !
!UI.CollectionPresenter categoriesFor: #model:!accessing!public! !
!UI.CollectionPresenter categoriesFor: #onListChanged!event handling!private! !
!UI.CollectionPresenter categoriesFor: #onSelectionChanged!public! !
!UI.CollectionPresenter categoriesFor: #onValueChanged!event handling!private! !
!UI.CollectionPresenter categoriesFor: #promptForExpression:caption:!helpers!private! !
!UI.CollectionPresenter categoriesFor: #queryCommand:!commands!private! !
!UI.CollectionPresenter categoriesFor: #removeItem!commands!operations!public! !
!UI.CollectionPresenter categoriesFor: #selectionOrNil!public!selection! !
!UI.CollectionPresenter categoriesFor: #selectionOrNil:!public!selection! !
!UI.CollectionPresenter categoriesFor: #setAddItemBlock:!accessing!public! !

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 25 nil 416 34 2 8 1409289036 131137 512 nil nil nil 517 nil nil nil 512 917510 ##(Graphics.Color) #default 8 1920642432 170 192 8 #() 170 192 34 4 36289 1311814 1 ##(UI.ToolbarIconButton) 512 1 1377606 4 ##(UI.CommandDescription) #addItem 8 'New Item' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'NewThing.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 36289 36291 690 512 1 722 #removeItem 8 'Delete Item' 1 1 770 nil true 816 8 'EditClear.ico' 864 36291 34 3 704 896 1245766 1 ##(UI.ToolbarSeparator) 512 1 nil nil 1 nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 1 1 1138 501 51 512 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 250 0 0 0 25 0 0 0] 8 #() 1138 193 193 nil 27 nil nil nil 410 ##(UI.ListView) 34 45 nil 416 34 2 8 1140936781 1025 1264 787270 2 ##(UI.ListModel) 138 144 640 nil 1638406 ##(Kernel.IdentitySearchPolicy) 592 nil 1029 461638 4 ##(UI.Menu) nil true 34 1 1180742 2 ##(UI.CommandMenuItem) 1 722 #removeItem 8 '&Delete' 1 1 770 nil true 816 8 'EditClear.ico' 864 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 1264 nil 8 1920618720 786950 ##(Core.Message) #displayString 8 #() ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 '' 493 #left 1586 #displayString 1616 1586 #<= 8 #() nil nil 1264 nil 3 nil nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1026 138 144 34 2 1090 #createAt:extent: 34 2 1138 1 51 1138 501 251 1264 1090 #contextMenu: 34 1 1424 1264 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 250 0 0 0 150 0 0 0] 8 #() 1248 nil 35 170 192 34 2 1264 8 'list' nil 1026 138 144 34 1 1090 #createAt:extent: 34 2 1138 6143 21 1138 501 301 416 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 249 12 0 0 160 0 0 0] 34 2 512 1264 1248 nil 27)! !
!UI.CollectionPresenter class categoriesFor: #defaultModel!models!public! !
!UI.CollectionPresenter class categoriesFor: #icon!constants!public! !
!UI.CollectionPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

