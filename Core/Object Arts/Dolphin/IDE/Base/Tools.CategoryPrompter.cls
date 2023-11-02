"Filed out from Dolphin Smalltalk"!

UI.ValueDialog
	subclass: #'Tools.CategoryPrompter'
	instanceVariableNames: 'treePresenter flags categoryClass'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: { 'AllowIntermediatesMask' -> 16r1. 'AllowReadOnlyMask' -> 16r2 }!
Tools.CategoryPrompter guid: (Core.GUID fromString: '{87b4c6a6-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.CategoryPrompter comment: 'CategoryPrompter is a <valueDialogPresenter> that can be used to prompt for a <Category>.

Example:
(CategoryPrompter list: MethodCategory allMethodCategories 
	caption: ''Choose a category'') showModal "Display it"

Instance Variables:
	treePresenter	<TreePresenter> displaying the hierarchy of categories to choose from.
	allowIntermediates	<boolean> indicating whether intermediate nodes in the hierarchy are available to be chosen.
	categoryClass	<Category class> indicating the class of category being displayed.

'!
!Tools.CategoryPrompter categoriesForClass!MVP-Presenters! !
!Tools.CategoryPrompter methodsFor!

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
!Tools.CategoryPrompter categoriesForMethods!
allowIntermediates!accessing!public! !
allowIntermediates:!accessing!public! !
allowReadOnly!accessing!public! !
allowReadOnly:!accessing!public! !
categoryClass:!accessing!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
initialize!initializing!private! !
list:!accessing!public! !
newCategory!commands!public! !
newChoice!commands!public! !
onCategorySelectionChanged!event handling!private! !
onChoose!event handling!private! !
queryCommand:!commands!private! !
!

!Tools.CategoryPrompter class methodsFor!

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

	^SmalltalkSystem current icon!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 1 518 #{Core.Association} 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 368 nil nil nil 5 nil nil nil 368 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 6 18 #{UI.PushButton} 50 20 nil 368 50 2 8 1140924416 1 512 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 512 nil nil 1350 4 #{UI.CommandDescription} #newChoice 8 '&New…' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 3 774 #{Core.MessageSend} #createAt:extent: 50 2 130 21 11 130 141 51 512 706 #isEnabled: 8 #(false) 512 706 #text: 50 1 8 '&New…' 512 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 5 0 0 0 80 0 0 0 30 0 0 0] 8 #() 130 193 193 nil 29 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 11 978 #fixedViewLeft 141 978 #fixedParentTop 1 978 #fixedViewTop 51 18 #{UI.PushButton} 50 20 nil 368 50 2 8 1140924416 1 1056 nil 592 nil 5 nil nil nil 1056 nil nil 610 #ok 8 'OK' 1 1 nil nil true nil nil nil 658 50 3 706 #createAt:extent: 50 2 130 165 11 130 141 51 1056 706 #isEnabled: 8 #(false) 1056 706 #text: 50 1 8 'OK' 1056 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 82 0 0 0 5 0 0 0 152 0 0 0 30 0 0 0] 8 #() 928 nil 29 946 978 #fixedViewRight -139 978 #fixedParentRight -153 1024 1 1040 51 18 #{UI.PushButton} 50 20 nil 368 50 2 8 1140924416 1 1424 nil 592 nil 5 nil nil nil 1424 nil nil 610 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 658 50 2 706 #createAt:extent: 50 2 130 315 11 130 141 51 1424 706 #text: 50 1 8 'Cancel' 1424 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 157 0 0 0 5 0 0 0 227 0 0 0 30 0 0 0] 8 #() 928 nil 29 946 1392 -139 1408 -3 1024 1 1040 51 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 130 11 11 130 11 11 658 50 1 706 #createAt:extent: 50 2 130 11 547 130 469 77 368 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 17 1 0 0 239 0 0 0 55 1 0 0] 50 3 512 1056 1424 928 nil 27 1 true 1730 0 1762 130 11 11 130 11 11 nil nil nil nil 1 nil nil nil 130 501 311 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 658 50 1 706 #createAt:extent: 50 2 130 6143 21 130 521 711 32 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 3 13 0 0 109 1 0 0] 50 2 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2224 nil nil nil 5 nil nil nil 2224 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.TreeView} 50 27 nil 2224 50 2 8 1140916775 1025 2320 1094 3 #{UI.TreeModel} nil 6 #{Kernel.IdentitySearchPolicy} 774 #{UI.TreeNode} nil nil nil 1730 0 592 nil 5 nil nil nil 2320 nil nil 518 #{Core.Message} #localName 8 #() 2498 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil 550 #{Core.LookupTable} 0 nil #noIcons 1 1730 0 658 50 1 706 #createAt:extent: 50 2 130 11 11 130 449 517 2320 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 229 0 0 0 7 1 0 0] 8 #() 928 nil 27 466 1728 50 2 2320 8 'tree' 1762 130 11 11 130 11 11 658 50 1 706 #createAt:extent: 50 2 130 11 11 130 469 537 2224 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 239 0 0 0 17 1 0 0] 50 1 2320 928 nil 27 368 928 nil 27)! !
!Tools.CategoryPrompter class categoriesForMethods!
choices:caption:!instance creation!public! !
defaultModel!models!public! !
icon!accessing!constants!public! !
on:choices:caption:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

