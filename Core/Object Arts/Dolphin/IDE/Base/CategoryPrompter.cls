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
!CategoryPrompter categoriesForClass!Development!MVP-Presenters! !
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
	categoryClass := Object methodCategoryClass.
	flags := 0.
	treePresenter model: CategoryTreeModel new.!

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

	^Object methodCategoryClass unclassified asValue!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 328198 ##(Smalltalk.Point)  501 701 167 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  202 8 ##(Smalltalk.Dictionary)  98 1 721414 ##(Smalltalk.Association)  410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 672 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 672 852230 ##(Smalltalk.FramingLayout)  234 240 98 6 410 8 ##(Smalltalk.PushButton)  98 17 0 672 98 2 8 1140924416 1 848 0 482 512 0 7 0 0 0 848 0 8 4294903631 1180998 4 ##(Smalltalk.CommandDescription)  8 #cancel 8 'Cancel' 1 1 0 0 32 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 530 331 11 530 141 51 848 1090 8 #text: 98 1 8 'Cancel' 848 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 165 0 0 0 5 0 0 0 235 0 0 0 30 0 0 0] 98 0 530 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedViewRight -139 1362 8 #fixedParentRight -3 1362 8 #fixedParentTop 1 1362 8 #fixedViewTop 51 410 864 98 17 0 672 98 2 8 1140924416 1 1504 0 482 512 0 7 0 0 0 1504 0 8 4294903631 962 8 #newChoice 8 '&New...' 1 1 0 0 32 1026 202 208 98 3 1090 1120 98 2 530 21 11 530 141 51 1504 1090 8 #isEnabled: 98 1 32 1504 1090 1200 98 1 8 '&New...' 1504 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 5 0 0 0 80 0 0 0 30 0 0 0] 98 0 1312 0 27 1330 1362 8 #fixedParentLeft 11 1362 8 #fixedViewLeft 141 1440 1 1472 51 410 864 98 17 0 672 98 2 8 1140924416 1 1984 0 482 512 0 7 0 0 0 1984 0 8 4294903631 962 8 #ok 8 'OK' 1 1 0 0 16 1026 202 208 98 3 1090 1120 98 2 530 181 11 530 141 51 1984 1090 1776 98 1 32 1984 1090 1200 98 1 8 'OK' 1984 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 90 0 0 0 5 0 0 0 160 0 0 0 30 0 0 0] 98 0 1312 0 27 1330 1376 -139 1408 -153 1440 1 1472 51 234 256 98 0 590342 ##(Smalltalk.Rectangle)  530 11 11 530 11 11 1026 202 208 98 1 1090 1120 98 2 530 11 557 530 485 77 672 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 22 1 0 0 247 0 0 0 60 1 0 0] 98 3 1504 1984 848 1312 0 27 1 16 234 256 2400 2418 530 11 11 530 11 11 0 0 0 0 33775 0 0 0 530 501 311 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 1026 202 208 98 2 1090 1120 98 2 530 2799 21 530 521 711 416 1090 8 #updateMenuBar 2400 416 1250 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 123 6 0 0 109 1 0 0] 98 2 410 688 98 15 0 416 98 2 8 1140850688 131073 2960 0 754 31 0 7 0 0 0 2960 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.TreeView)  98 27 0 2960 98 2 8 1140916263 1025 3072 590918 3 ##(Smalltalk.TreeModel)  0 1310726 ##(Smalltalk.IdentitySearchPolicy)  525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 2400 482 512 0 7 0 0 0 3072 0 8 4294903619 459270 ##(Smalltalk.Message)  8 #localName 98 0 8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 234 240 2400 17 8 #noIcons 1 0 1026 202 208 98 1 1090 1120 98 2 530 11 11 530 465 527 3072 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 237 0 0 0 12 1 0 0] 98 0 1312 0 27 234 256 98 2 3072 8 'tree' 2418 530 11 11 530 11 11 1026 202 208 98 1 1090 1120 98 2 530 11 11 530 485 547 2960 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 247 0 0 0 22 1 0 0] 98 1 3072 1312 0 27 672 1312 0 27 )! !
!CategoryPrompter class categoriesFor: #choices:caption:!instance creation!public! !
!CategoryPrompter class categoriesFor: #defaultModel!models!public! !
!CategoryPrompter class categoriesFor: #icon!accessing!constants!public! !
!CategoryPrompter class categoriesFor: #initialize!initializing!private! !
!CategoryPrompter class categoriesFor: #on:choices:caption:!instance creation!public! !
!CategoryPrompter class categoriesFor: #resource_Default_view!public!resources-views! !

