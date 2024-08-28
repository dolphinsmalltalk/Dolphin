"Filed out from Dolphin Smalltalk"!

ValuePresenter subclass: #CollectionPresenter
	instanceVariableNames: 'addItemBlock listPresenter changing flags'
	classVariableNames: 'ReadOnlyMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CollectionPresenter guid: (GUID fromString: '{cef6a076-8a4e-4dc8-9732-9241724d99e3}')!

CollectionPresenter comment: 'CollectionPresenter is a <valuePresenter> that presents a <Collection> accessed via its <valueModel>. It provides a number of [operations]for editing the list. As changes are made to the list it is applied back to the presenter''s <valueModel>.

Instance Variables:
	listPresenter	<ListPresenter> presenting the list accessed as the value of the presenter''s model.
'!

!CollectionPresenter categoriesForClass!MVP-Presenters!MVP-Resources-Lists! !

!CollectionPresenter methodsFor!

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
	listPresenter := self add: ListPresenter new name: 'list'.
!

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
			error := nil] 
					on: Compiler errorClass , Error
					do: 
						[:ex | 
						error := ex.
						ex return: nil].
			error notNil and: 
					[| mb |
					mb := MessageBox new.
					mb buttonStyle: #yesNo.
					mb caption: 'Error evaluating expression...'.
					(mb errorMsg: ('<1d><n><n>Try again?' expandMacrosWith: error)) == #yes]]] 
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

!CollectionPresenter categoriesForMethods!
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

!CollectionPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^OrderedCollection new asValue!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) instanceClass defaultIcon!

initialize
	ReadOnlyMask := 1!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 7 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1409289036 131137 512 nil nil nil 519 nil nil nil 512 327686 ##(Smalltalk.Color) #default 8 1795812352 170 192 8 #() nil nil nil 170 192 34 4 16833 1115718 2 ##(Smalltalk.ToolbarIconButton) 512 1 1180998 4 ##(Smalltalk.CommandDescription) #addItem 8 'New Item' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'NewThing.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 16833 nil nil 16835 690 512 1 722 #removeItem 8 'Delete Item' 1 1 770 nil true 816 8 'EditClear.ico' 864 16835 nil nil 34 3 704 896 1049158 1 ##(Smalltalk.ToolbarSeparator) 512 1 nil nil 9 1 nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 250 0 0 0 25 0 0 0] 193 544 8 '' 512 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 31 nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140936781 1025 1280 590662 2 ##(Smalltalk.ListModel) 138 144 640 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 592 nil 1031 265030 4 ##(Smalltalk.Menu) nil true 34 1 984134 2 ##(Smalltalk.CommandMenuItem) 1 722 #removeItem 8 '&Delete' 1 1 770 nil true 816 8 'EditClear.ico' 864 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 1280 nil 8 1795768528 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 493 #left 1602 #displayString 1632 1602 #<= 8 #() nil nil 1280 nil 3 nil nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1026 138 144 34 2 1090 #createWindow: 34 1 1138 1170 8 #[0 0 0 0 25 0 0 0 250 0 0 0 150 0 0 0] 193 1312 8 '' 1280 1090 #contextMenu: 34 1 1440 1280 3 8 #() 1250 193 193 nil 35 170 192 34 2 1280 8 'list' nil 1026 138 144 34 1 1090 #createWindow: 34 1 1138 1170 8 #[255 14 0 0 10 0 0 0 249 15 0 0 160 0 0 0] 193 448 8 '' 416 1 34 2 512 1280 1250 193 193 nil 27 )! !

!CollectionPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
initialize!initializing!public! !
resource_Default_view!public!resources-views! !
!

