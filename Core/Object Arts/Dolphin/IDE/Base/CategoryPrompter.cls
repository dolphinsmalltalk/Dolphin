"Filed out from Dolphin Smalltalk 7"!

ValueDialog subclass: #CategoryPrompter
	instanceVariableNames: 'treePresenter flags categoryClass'
	classVariableNames: 'AllowIntermediatesMask AllowReadOnlyMask'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
CategoryPrompter guid: (GUID fromString: '{87b4c6a6-026e-11d3-9fd7-00a0cc3e4a32}')!
CategoryPrompter comment: 'CategoryPrompter is a <valueDialogPresenter> that can be used to prompt for a <Category>.

Example:
(CategoryPrompter list: MethodCategory allMethodCategories 
	caption: ''Choose a category'') showModal "Display it"

Instance Variables:
	treePresenter	<TreePresenter> displaying the hierarchy of categories to choose from.
	allowIntermediates	<boolean> indicating whether intermediate nodes in the hierarchy are available to be chosen.
	categoryClass	<Category class> indicating the class of category being displayed.

'!
!CategoryPrompter categoriesForClass!MVP-Presenters! !
!CategoryPrompter methodsFor!

allowIntermediates
	"Answer whether the selection of intermediate categories is valid."

	^flags allMask: AllowIntermediatesMask!

allowIntermediates: bool
	"Set whether the selection of intermediate categories is valid."

	flags := flags mask: AllowIntermediatesMask set: bool!

allowReadOnly
	"Answer whether the selection of read-only categories is valid."

	^flags allMask: AllowReadOnlyMask!

allowReadOnly: bool
	"Set whether the selection of read-only categories is valid."

	flags := flags mask: AllowReadOnlyMask set: bool!

categoryClass: anObject
	"Set the value of the receiver's 'categoryClass' instance variable to the argument, anObject."

	categoryClass := anObject!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	treePresenter := self add: TreePresenter new name: 'tree'.

!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.
	treePresenter when: #selectionChanged send: #onCategorySelectionChanged to: self.
	treePresenter when: #actionPerformed send: #onChoose to: self.!

initialize
	"Private - Initialize the receiver"

	super initialize.
	categoryClass := MethodCategory.
	flags := 0.
	treePresenter model: CategoryTreeModel new!

list: categories
	"Set the list of categories displayed in the receiver to the <collection>, categories."

	treePresenter model list: categories.
	self value notNil ifTrue: [treePresenter selection: self value]!

newCategory
	"New Category button selected. Allow a new Category to be created."

	| chosenCategoryName default |
	default := treePresenter selectionOrNil.
	default := default notNil ifTrue: [default name] ifFalse: [''].
	chosenCategoryName := Prompter 
				on: default
				prompt: 'Unique ' , categoryClass name , ' name:'
				caption: 'New ' , categoryClass name.
	chosenCategoryName notNil 
		ifTrue: 
			[self value: (categoryClass name: chosenCategoryName).
			self ok]!

newChoice
	"New... button selected."

	self newCategory!

onCategorySelectionChanged
	"Private - The selection has been changed in the tree presenter.
	Transfer the selection to our buffered model's value"

	self value: treePresenter selectionOrNil!

onChoose
	"Private - The user double clicked a category. Route as if a command."

	self view onCommand: (CommandDescription command: #ok)!

queryCommand: query
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery>, query."

	query commandSymbol == #ok ifTrue: [ | cat |
		cat := self value.
		query isEnabled: 
			(cat notNil and: [
				cat isIntermediate 
					ifTrue: [self allowIntermediates]
					ifFalse: [self allowReadOnly or: [cat acceptsAdditions]]]).
		^true].

	^super queryCommand: query.
! !
!CategoryPrompter categoriesFor: #allowIntermediates!accessing!public! !
!CategoryPrompter categoriesFor: #allowIntermediates:!accessing!public! !
!CategoryPrompter categoriesFor: #allowReadOnly!accessing!public! !
!CategoryPrompter categoriesFor: #allowReadOnly:!accessing!public! !
!CategoryPrompter categoriesFor: #categoryClass:!accessing!public! !
!CategoryPrompter categoriesFor: #createComponents!initializing!public! !
!CategoryPrompter categoriesFor: #createSchematicWiring!initializing!public! !
!CategoryPrompter categoriesFor: #initialize!initializing!private! !
!CategoryPrompter categoriesFor: #list:!accessing!public! !
!CategoryPrompter categoriesFor: #newCategory!commands!public! !
!CategoryPrompter categoriesFor: #newChoice!commands!public! !
!CategoryPrompter categoriesFor: #onCategorySelectionChanged!event handling!private! !
!CategoryPrompter categoriesFor: #onChoose!event handling!private! !
!CategoryPrompter categoriesFor: #queryCommand:!commands!private! !

!CategoryPrompter class methodsFor!

choices: aSequenceableCollection caption: aStringCaption 
	"Answers a dialog to allow the user to choose from aSequenceableCollection of categories.
	The dialog is given aStringCaption. There will be no initial list selection when the dialog is
	displayed"

	^self 
		on: nil asValue
		choices: aSequenceableCollection
		caption: aStringCaption!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^MethodCategory unclassified asValue!

icon
	"Answers an Icon that can be used to represent this class."

	^Smalltalk developmentSystem icon
!

initialize
	"Private - Initialize the receiver. Install as a sample application into the
	system folder
		self initialize.
	"

	AllowIntermediatesMask := 16r1.
	AllowReadOnlyMask := 16r2!

on: value choices: list caption: caption
	"Answers a dialog to allow the user to choose from the <sequencedReadableCollection> of
	values, list. The initial list selection is the <Category>, value which, if nil, there is no selection.
	The dialog is given the <readableString> caption, title"

	^(self createOn: value asValue)
		list: list;
		caption: caption
!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog 328198 ##(Smalltalk.Point) 501 701 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 720 nil nil nil 5 nil nil nil 720 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.PushButton) 34 20 nil 720 34 2 8 1140924416 1 848 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 848 nil 8 1915188384 1180998 4 ##(Smalltalk.CommandDescription) #newChoice 8 '&New...' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 21 11 498 141 51 848 1090 #isEnabled: 8 #(false) 848 1090 #text: 34 1 8 '&New...' 848 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 5 0 0 0 80 0 0 0 30 0 0 0] 8 #() 498 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 11 1362 #fixedViewLeft 141 1362 #fixedParentTop 1 1362 #fixedViewTop 51 410 ##(Smalltalk.PushButton) 34 20 nil 720 34 2 8 1140924416 1 1440 nil 928 nil 5 nil nil nil 1440 nil 8 1915188384 978 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1026 138 144 34 2 1090 #createAt:extent: 34 2 498 315 11 498 141 51 1440 1090 #text: 34 1 8 'Cancel' 1440 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 157 0 0 0 5 0 0 0 227 0 0 0 30 0 0 0] 8 #() 1312 nil 29 1330 1362 #fixedViewRight -139 1362 #fixedParentRight -3 1408 1 1424 51 410 ##(Smalltalk.PushButton) 34 20 nil 720 34 2 8 1140924416 1 1808 nil 928 nil 5 nil nil nil 1808 nil 8 1915188384 978 #ok 8 'OK' 1 1 nil nil true nil nil nil 1026 138 144 34 3 1090 #createAt:extent: 34 2 498 165 11 498 141 51 1808 1090 #isEnabled: 8 #(false) 1808 1090 #text: 34 1 8 'OK' 1808 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 82 0 0 0 5 0 0 0 152 0 0 0 30 0 0 0] 8 #() 1312 nil 29 1330 1776 -139 1792 -153 1408 1 1424 51 170 192 8 #() 590342 ##(Smalltalk.Rectangle) 498 11 11 498 11 11 1026 138 144 34 1 1090 #createAt:extent: 34 2 498 11 547 498 469 77 720 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 17 1 0 0 239 0 0 0 55 1 0 0] 34 3 848 1808 1440 1312 nil 27 1 true 170 192 2192 2210 498 11 11 498 11 11 nil nil nil nil 10011 nil nil nil 498 501 311 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2011052416 1026 138 144 34 2 1090 #createAt:extent: 34 2 498 1661 725 498 521 711 416 1090 #updateMenuBar 2192 416 1250 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 62 3 0 0 106 1 0 0 66 4 0 0 205 2 0 0] 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2736 nil nil nil 5 nil nil nil 2736 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.TreeView) 34 27 nil 2736 34 2 8 1140916775 1025 2832 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 2192 928 nil 5 nil nil nil 2832 nil 8 1914975136 459270 ##(Smalltalk.Message) #localName 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil 170 176 2192 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 2192 1026 138 144 34 1 1090 #createAt:extent: 34 2 498 11 11 498 449 517 2832 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 229 0 0 0 7 1 0 0] 8 #() 1312 nil 27 170 192 34 2 2832 8 'tree' 2210 498 11 11 498 11 11 1026 138 144 34 1 1090 #createAt:extent: 34 2 498 11 11 498 469 537 2736 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 239 0 0 0 17 1 0 0] 34 1 2832 1312 nil 27 720 1312 nil 27 )! !
!CategoryPrompter class categoriesFor: #choices:caption:!instance creation!public! !
!CategoryPrompter class categoriesFor: #defaultModel!models!public! !
!CategoryPrompter class categoriesFor: #icon!accessing!constants!public! !
!CategoryPrompter class categoriesFor: #initialize!initializing!private! !
!CategoryPrompter class categoriesFor: #on:choices:caption:!instance creation!public! !
!CategoryPrompter class categoriesFor: #resource_Default_view!public!resources-views! !

