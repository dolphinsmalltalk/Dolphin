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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog 918022 #{Graphics.Point} 501 701 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 1376774 #{UI.ProportionalLayout} 138 #{Core.Dictionary} 34 1 1049094 #{Core.Association} 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 720 nil nil nil 7 nil nil nil 720 1048838 #{UI.FramingLayout} 170 176 34 6 410 #{UI.PushButton} 34 20 nil 720 34 2 8 1140924416 1 848 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 848 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 315 11 498 141 51 848 1058 #text: 34 1 8 'Cancel' 848 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 157 0 0 0 5 0 0 0 227 0 0 0 30 0 0 0] 8 #() 498 193 193 nil 29 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedViewRight -139 1298 #fixedParentRight -3 1298 #fixedParentTop 1 1298 #fixedViewTop 51 410 #{UI.PushButton} 34 20 nil 720 34 2 8 1140924416 1 1376 nil 928 nil 7 nil nil nil 1376 nil 8 1815097472 962 #ok 8 'OK' 1 1 nil nil true nil nil nil 1010 34 3 1058 #createAt:extent: 34 2 498 165 11 498 141 51 1376 1058 #isEnabled: 8 #(false) 1376 1058 #text: 34 1 8 'OK' 1376 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 82 0 0 0 5 0 0 0 152 0 0 0 30 0 0 0] 8 #() 1248 nil 29 1266 1312 -139 1328 -153 1344 1 1360 51 410 #{UI.PushButton} 34 20 nil 720 34 2 8 1140924416 1 1728 nil 928 nil 7 nil nil nil 1728 nil 8 1815097472 962 #newChoice 8 '&New…' 1 1 nil nil false nil nil nil 1010 34 3 1058 #createAt:extent: 34 2 498 21 11 498 141 51 1728 1058 #isEnabled: 8 #(false) 1728 1058 #text: 34 1 8 '&New…' 1728 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 5 0 0 0 80 0 0 0 30 0 0 0] 8 #() 1248 nil 29 1266 1298 #fixedParentLeft 11 1298 #fixedViewLeft 141 1344 1 1360 51 170 192 8 #() 1180166 #{Graphics.Rectangle} 498 11 11 498 11 11 1010 34 1 1058 #createAt:extent: 34 2 498 11 547 498 469 77 720 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 17 1 0 0 239 0 0 0 55 1 0 0] 34 3 1728 1376 848 1248 nil 27 1 true 170 192 2128 2146 498 11 11 498 11 11 nil nil nil nil 38751 nil nil nil 498 501 311 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 1010 34 1 1058 #createAt:extent: 34 2 498 12287 21 498 521 711 416 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 3 25 0 0 109 1 0 0] 34 2 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 2624 nil nil nil 7 nil nil nil 2624 984838 #{UI.BorderLayout} 1 1 nil nil nil nil 410 #{UI.TreeView} 34 27 nil 2624 34 2 8 1140916775 1025 2720 787526 3 #{UI.TreeModel} nil 1769478 #{Kernel.IdentitySearchPolicy} 721670 #{UI.TreeNode} nil nil nil 170 192 2128 928 nil 7 nil nil nil 2720 nil 8 1814826960 786950 #{Core.Message} #localName 8 #() 2914 #iconImageIndex 2128 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil 170 176 2128 nil #noIcons 1 170 192 2128 1010 34 1 1058 #createAt:extent: 34 2 498 11 11 498 449 517 2720 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 229 0 0 0 7 1 0 0] 8 #() 1248 nil 27 170 192 34 2 2720 8 'tree' 2146 498 11 11 498 11 11 1010 34 1 1058 #createAt:extent: 34 2 498 11 11 498 469 537 2624 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 239 0 0 0 17 1 0 0] 34 1 2720 1248 nil 27 720 1248 nil 27)! !
!Tools.CategoryPrompter class categoriesForMethods!
choices:caption:!instance creation!public! !
defaultModel!models!public! !
icon!accessing!constants!public! !
on:choices:caption:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

