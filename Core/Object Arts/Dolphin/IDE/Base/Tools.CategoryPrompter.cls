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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 32 518 #{UI.ProportionalLayout} 294 #{Core.Dictionary} 1 518 #{Core.Association} 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 352 nil nil nil 7 nil nil nil 352 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 3 18 #{UI.PushButton} 50 20 nil 352 50 2 8 1140924416 1 480 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 480 nil 8 1853182784 1350 4 #{UI.CommandDescription} #ok 8 'OK' 1 1 nil nil true nil nil nil 262 #{Core.MessageSequence} 50 3 774 #{Core.MessageSend} #createAt:extent: 50 2 130 165 11 130 141 51 480 690 #isEnabled: 8 #(false) 480 690 #text: 50 1 8 'OK' 480 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 82 0 0 0 5 0 0 0 152 0 0 0 30 0 0 0] 8 #() 130 193 193 nil 29 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedViewRight -139 962 #fixedParentRight -153 962 #fixedParentTop 1 962 #fixedViewTop 51 18 #{UI.PushButton} 50 20 nil 352 50 2 8 1140924416 1 1040 nil 560 nil 7 nil nil nil 1040 nil 8 1853182784 594 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 642 50 2 690 #createAt:extent: 50 2 130 315 11 130 141 51 1040 690 #text: 50 1 8 'Cancel' 1040 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 157 0 0 0 5 0 0 0 227 0 0 0 30 0 0 0] 8 #() 912 nil 29 930 976 -139 992 -3 1008 1 1024 51 18 #{UI.PushButton} 50 20 nil 352 50 2 8 1140924416 1 1360 nil 560 nil 7 nil nil nil 1360 nil 8 1853182784 594 #newChoice 8 '&New…' 1 1 nil nil false nil nil nil 642 50 3 690 #createAt:extent: 50 2 130 21 11 130 141 51 1360 690 #isEnabled: 8 #(false) 1360 690 #text: 50 1 8 '&New…' 1360 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 5 0 0 0 80 0 0 0 30 0 0 0] 8 #() 912 nil 29 930 962 #fixedParentLeft 11 962 #fixedViewLeft 141 1008 1 1024 51 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 130 11 11 130 11 11 642 50 1 690 #createAt:extent: 50 2 130 11 547 130 469 77 352 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 17 1 0 0 239 0 0 0 55 1 0 0] 50 3 1360 480 1040 912 nil 27 1 true 1746 0 1778 130 11 11 130 11 11 nil nil nil nil 13901 nil nil nil 130 501 311 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 642 50 1 690 #createAt:extent: 50 2 130 6143 21 130 521 711 32 850 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 3 13 0 0 109 1 0 0] 50 2 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2256 nil nil nil 7 nil nil nil 2256 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.TreeView} 50 27 nil 2256 50 2 8 1140916775 1025 2352 1094 3 #{UI.TreeModel} nil 6 #{Kernel.IdentitySearchPolicy} 774 #{UI.TreeNode} nil nil nil 1746 0 560 nil 7 nil nil nil 2352 nil 8 1852941248 518 #{Core.Message} #localName 8 #() 2546 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil 450 0 nil #noIcons 1 1746 0 642 50 1 690 #createAt:extent: 50 2 130 11 11 130 449 517 2352 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 229 0 0 0 7 1 0 0] 8 #() 912 nil 27 1746 1 2352 8 'tree' 1778 130 11 11 130 11 11 642 50 1 690 #createAt:extent: 50 2 130 11 11 130 469 537 2256 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 239 0 0 0 17 1 0 0] 50 1 2352 912 nil 27 352 912 nil 27)! !
!Tools.CategoryPrompter class categoriesForMethods!
choices:caption:!instance creation!public! !
defaultModel!models!public! !
icon!accessing!constants!public! !
on:choices:caption:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

