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
	validationResultPresenter positionBlock: [self hintPosition].
	treePresenter := self add: TreePresenter new name: 'tree'.

!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.
	treePresenter when: #selectionChanged send: #onCategorySelectionChanged to: self.
	treePresenter when: #actionPerformed send: #onChoose to: self.!

hintPosition
	"Private - Answer a <Point> representing the screen co-ordinate at which the hint bubble's arrow should point."

	| treeView itemRect sel |
	treeView := treePresenter selectableItems view.
	sel := treeView selectionByIndex.
	itemRect := sel = 0 ifTrue: [treeView rectangle] ifFalse: [treeView itemRect: sel textOnly: true].
	^treeView mapPointToScreen: itemRect centerRight!

initialize
	"Private - Initialize the receiver"

	super initialize.
	categoryClass := MethodCategory.
	flags := 0.
	treePresenter model: CategoryTreeModel new!

invalidChoice: aString
	^(ValidationResult errorMessage: aString)
		caption: 'Invalid choice';
		yourself!

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

validateModel
	| cat |
	cat := self value.
	cat
		ifNil: 
			[^(ValidationResult errorMessage: 'Please select a category')
				caption: 'Incomplete Input';
				yourself].
	cat isIntermediate
		ifTrue: 
			[self allowIntermediates ifFalse: [^self invalidChoice: 'Intermediate categories are not valid']]
		ifFalse: 
			[(self allowReadOnly or: [cat acceptsAdditions])
				ifFalse: [^self invalidChoice: '''<d>'' is read-only' << cat]].
	^ValidationResult new!

validationResultPresenterClass
	^ValidationHintPresenter! !

!Tools.CategoryPrompter categoriesForMethods!
allowIntermediates!accessing!public! !
allowIntermediates:!accessing!public! !
allowReadOnly!accessing!public! !
allowReadOnly:!accessing!public! !
categoryClass:!accessing!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
hintPosition!accessing!private! !
initialize!initializing!private! !
invalidChoice:!helpers!private! !
list:!accessing!public! !
newCategory!commands!public! !
newChoice!commands!public! !
onCategorySelectionChanged!event handling!private! !
onChoose!event handling!private! !
validateModel!helpers!private! !
validationResultPresenterClass!constants!public! !
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 1 518 #{Core.Association} 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 352 nil nil nil 5 nil nil nil 352 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 6 18 #{UI.PushButton} 50 20 nil 352 50 2 8 1140924416 1 496 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 496 nil nil 1350 4 #{UI.CommandDescription} #newChoice 8 '&New…' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[10 0 0 0 5 0 0 0 80 0 0 0 30 0 0 0] 193 528 8 '&New…' 496 690 #isEnabled: 8 #(false) 496 3 8 #() 130 193 193 nil 29 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 11 930 #fixedViewLeft 141 930 #fixedParentTop 1 930 #fixedViewTop 51 18 #{UI.PushButton} 50 20 nil 352 50 2 8 1140924416 1 1008 nil 576 nil 5 nil nil nil 1008 nil nil 594 #ok 8 'OK' 1 1 nil nil true nil nil nil 642 50 2 690 #createWindow: 50 1 738 770 8 #[82 0 0 0 5 0 0 0 152 0 0 0 30 0 0 0] 193 1040 8 'OK' 1008 690 #isEnabled: 8 #(false) 1008 3 8 #() 130 193 193 nil 29 898 930 #fixedViewRight -139 930 #fixedParentRight -153 976 1 992 51 18 #{UI.PushButton} 50 20 nil 352 50 2 8 1140924416 1 1344 nil 576 nil 5 nil nil nil 1344 nil nil 594 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 642 50 1 690 #createWindow: 50 1 738 770 8 #[157 0 0 0 5 0 0 0 227 0 0 0 30 0 0 0] 193 1376 8 'Cancel' 1344 3 8 #() 130 193 193 nil 29 898 1312 -139 1328 -3 976 1 992 51 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 130 11 11 130 11 11 642 50 1 690 #createWindow: 50 1 738 770 8 #[5 0 0 0 17 1 0 0 239 0 0 0 55 1 0 0] 193 384 8 '' 352 3 50 3 496 1008 1344 130 193 193 nil 27 1 true 1618 0 1650 130 11 11 130 11 11 nil nil nil nil 1 nil nil nil 130 501 311 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 642 50 2 690 #createWindow: 50 1 518 #{UI.CreateDialog} 1650 130 7679 21 130 8199 731 193 32 690 #setWindowText: 50 1 8 '' 32 1 50 2 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2192 nil nil nil 5 nil nil nil 2192 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.TreeView} 50 35 nil 2192 50 2 8 1140916775 1025 2288 1094 3 #{UI.TreeModel} nil 6 #{Kernel.IdentitySearchPolicy} 774 #{UI.TreeNode} nil nil nil 1618 0 576 nil 5 nil nil nil 2288 nil nil 518 #{Core.Message} #localName 8 #() 2466 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil 550 #{Core.LookupTable} 0 nil #noIcons 1 1618 0 1 262 #{UI.TreeViewDynamicUpdateMode} 2288 nil nil nil nil nil nil 642 50 1 690 #createWindow: 50 1 738 770 8 #[5 0 0 0 5 0 0 0 229 0 0 0 7 1 0 0] 193 2320 8 '' 2288 3 8 #() 130 193 193 nil 29 450 1616 50 2 2288 8 'tree' 1650 130 11 11 130 11 11 642 50 1 690 #createWindow: 50 1 738 770 8 #[5 0 0 0 5 0 0 0 239 0 0 0 17 1 0 0] 193 2224 8 '' 2192 3 50 1 2288 130 193 193 nil 27 352 130 193 193 nil 29)! !

!Tools.CategoryPrompter class categoriesForMethods!
choices:caption:!instance creation!public! !
defaultModel!models!public! !
icon!accessing!constants!public! !
on:choices:caption:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

