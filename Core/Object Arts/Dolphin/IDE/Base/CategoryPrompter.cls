"Filed out from Dolphin Smalltalk"!

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

!CategoryPrompter categoriesForMethods!
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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog 328198 ##(Smalltalk.Point) 501 701 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 704 nil nil nil 5 nil nil nil 704 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.PushButton) 34 20 nil 704 34 2 8 1140924416 1 832 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 832 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #newChoice 8 '&New...' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[10 0 0 0 5 0 0 0 80 0 0 0 30 0 0 0] 193 864 8 '&New...' 832 1058 #isEnabled: 8 #(false) 832 3 8 #() 498 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 11 1298 #fixedViewLeft 141 1298 #fixedParentTop 1 1298 #fixedViewTop 51 410 ##(Smalltalk.PushButton) 34 20 nil 704 34 2 8 1140924416 1 1376 nil 912 nil 5 nil nil nil 1376 nil 8 1759007584 946 #ok 8 'OK' 1 1 nil nil true nil nil nil 994 138 144 34 2 1058 #createWindow: 34 1 1106 1138 8 #[82 0 0 0 5 0 0 0 152 0 0 0 30 0 0 0] 193 1408 8 'OK' 1376 1058 #isEnabled: 8 #(false) 1376 3 8 #() 498 193 193 nil 29 1266 1298 #fixedViewRight -139 1298 #fixedParentRight -153 1344 1 1360 51 410 ##(Smalltalk.PushButton) 34 20 nil 704 34 2 8 1140924416 1 1744 nil 912 nil 5 nil nil nil 1744 nil 8 1759007584 946 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 994 138 144 34 1 1058 #createWindow: 34 1 1106 1138 8 #[157 0 0 0 5 0 0 0 227 0 0 0 30 0 0 0] 193 1776 8 'Cancel' 1744 3 8 #() 498 193 193 nil 29 1266 1712 -139 1728 -3 1344 1 1360 51 170 192 8 #() 590342 ##(Smalltalk.Rectangle) 498 11 11 498 11 11 994 138 144 34 1 1058 #createWindow: 34 1 1106 1138 8 #[5 0 0 0 17 1 0 0 239 0 0 0 55 1 0 0] 193 736 8 '' 704 3 34 3 832 1376 1744 498 193 193 nil 27 1 true 170 192 2064 2082 498 11 11 498 11 11 nil nil nil nil 10507 nil nil nil 498 501 311 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 994 138 144 34 2 1058 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 2082 498 1 1 498 521 711 193 416 1058 #setWindowText: 34 1 8 '' 416 1 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2672 nil nil nil 5 nil nil nil 2672 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.TreeView) 34 27 nil 2672 34 2 8 1140916775 1025 2768 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 2064 912 nil 5 nil nil nil 2768 nil 8 1758766000 459270 ##(Smalltalk.Message) #localName 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil 170 176 2064 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 2064 994 138 144 34 1 1058 #createWindow: 34 1 1106 1138 8 #[5 0 0 0 5 0 0 0 229 0 0 0 7 1 0 0] 193 2800 8 '' 2768 3 8 #() 498 193 193 nil 27 170 192 34 2 2768 8 'tree' 2082 498 11 11 498 11 11 994 138 144 34 1 1058 #createWindow: 34 1 1106 1138 8 #[5 0 0 0 5 0 0 0 239 0 0 0 17 1 0 0] 193 2704 8 '' 2672 3 34 1 2768 498 193 193 nil 27 704 498 193 193 nil 29 )! !

!CategoryPrompter class categoriesForMethods!
choices:caption:!instance creation!public! !
defaultModel!models!public! !
icon!accessing!constants!public! !
initialize!initializing!private! !
on:choices:caption:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

