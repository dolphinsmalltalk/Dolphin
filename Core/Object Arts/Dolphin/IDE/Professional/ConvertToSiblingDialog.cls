"Filed out from Dolphin Smalltalk X6.1"!

Dialog subclass: #ConvertToSiblingDialog
	instanceVariableNames: 'classNamePresenter subclassesPresenter statusModel'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ConvertToSiblingDialog guid: (GUID fromString: '{2E1173DA-AD55-42DA-BEB3-E8D674480103}')!
ConvertToSiblingDialog comment: ''!
!ConvertToSiblingDialog categoriesForClass!Development! !
!ConvertToSiblingDialog methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	classNamePresenter := self add: TextPresenter new name: 'newClassName'.
	subclassesPresenter := self add: ListPresenter new name: 'subclasses'.
	statusModel := ValueHolder new!

createSchematicWiring
	super createSchematicWiring.
	subclassesPresenter 
		when: #selectionChanged
		send: #onSelectionChanged
		to: self!

isValid
	| error |
	[self model checkPreconditions] on: RefactoringError
		do: 
			[:ex | 
			error := ex.
			ex return: nil].
	statusModel value: error.
	^error isNil!

model: aChildrenToSiblingsRefactoring 
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: aChildrenToSiblingsRefactoring.
	aspectBuffer := self model.
	classNamePresenter model: (aspectBuffer aspectValue: #className).
	subclassesPresenter model: (ListModel on: aspectBuffer subclasses)!

onSelectionChanged
	self model subclasses: subclassesPresenter selections.
	^self invalidateUserInterface!

onViewOpened
	super onViewOpened.
	(self view viewNamed: 'status' ifNone: []) ifNotNil: [:item | item model: statusModel].
	subclassesPresenter view selectAll!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>."

	aCommandQuery commandSymbol == #ok 
		ifTrue: 
			[classNamePresenter value.
			aCommandQuery isEnabled: self isValid.
			^true].
	^super queryCommand: aCommandQuery! !
!ConvertToSiblingDialog categoriesFor: #createComponents!initializing!public! !
!ConvertToSiblingDialog categoriesFor: #createSchematicWiring!initializing!public! !
!ConvertToSiblingDialog categoriesFor: #isValid!private!testing! !
!ConvertToSiblingDialog categoriesFor: #model:!accessing!public! !
!ConvertToSiblingDialog categoriesFor: #onSelectionChanged!public! !
!ConvertToSiblingDialog categoriesFor: #onViewOpened!event handling!public! !
!ConvertToSiblingDialog categoriesFor: #queryCommand:!commands!private! !

!ConvertToSiblingDialog class methodsFor!

defaultModel
	^ChildrenToSiblingsRefactoring new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 25690113 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 165 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 672 0 721158 ##(Smalltalk.SystemColor)  31 0 5 0 0 0 672 852230 ##(Smalltalk.FramingLayout)  234 240 98 4 410 8 ##(Smalltalk.TextEdit)  98 16 0 672 98 2 8 1140916352 1025 848 0 482 512 0 5 0 0 0 848 0 8 4294903615 852486 ##(Smalltalk.NullConverter)  0 0 1 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 610 285 13 610 403 41 848 1058 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 848 1058 8 #isTextModified: 98 1 32 848 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 6 0 0 0 87 1 0 0 26 0 0 0] 98 0 610 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedPreviousRight 21 1394 8 #fixedParentRight -1 1394 8 #fixedPreviousTop -5 1394 8 #fixedViewTop 41 410 8 ##(Smalltalk.StaticText)  98 16 0 672 98 2 8 1140850944 1 1536 0 0 0 5 0 0 0 1536 0 8 4294903269 962 0 0 0 994 202 208 98 2 1058 1088 98 2 610 5 19 610 261 41 1536 1058 8 #text: 98 1 8 '&Name for new superclass:' 1536 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 9 0 0 0 132 0 0 0 29 0 0 0] 98 0 1344 0 27 1362 1394 8 #fixedParentLeft 5 1394 8 #fixedViewLeft 261 1394 8 #fixedParentTop 19 1504 41 234 256 98 2 848 8 'newClassName' 0 994 202 208 98 1 1058 1088 98 2 610 21 17 610 689 81 672 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 98 1 0 0 48 0 0 0] 98 2 1536 848 1344 0 27 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 2192 0 0 0 5 0 0 0 2192 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 994 202 208 98 1 1058 1088 98 2 610 21 419 610 689 61 2192 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 209 0 0 0 98 1 0 0 239 0 0 0] 98 0 1344 0 27 0 0 410 688 98 15 0 416 98 2 8 1140850688 131073 2496 0 754 31 0 5 0 0 0 2496 642 1 11 410 1552 98 16 0 2496 98 2 8 1140850944 65 2592 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 482 8 4278190080 0 517 0 0 0 2592 482 512 8 4294903269 962 0 0 0 994 202 208 98 2 1058 1088 98 2 610 1 1 610 689 27 2592 1058 1776 98 1 8 'Choose subclasses to be promoted to siblings:' 2592 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 13 0 0 0] 98 0 1344 0 27 410 8 ##(Smalltalk.StatusBar)  98 18 0 2496 98 2 8 1409288204 1 3008 0 482 8 4278190080 0 5 0 0 0 3008 0 8 4294903525 234 256 98 2 853766 ##(Smalltalk.StatusBarItem)  1 -1 3008 0 459270 ##(Smalltalk.Message)  8 #displayString 98 0 3202 8 #iconImageIndex 2480 1049670 1 ##(Smalltalk.IconImageManager)  8 'status' 98 1 3184 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 3008 0 0 994 202 208 98 1 1058 1088 98 2 610 1 269 610 689 45 3008 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 134 0 0 0 88 1 0 0 156 0 0 0] 98 0 1344 0 27 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 2496 98 2 8 1140970059 1025 3552 590662 2 ##(Smalltalk.ListModel)  202 208 2480 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 512 0 5 265030 4 ##(Smalltalk.Menu)  0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #moveFirst 8 'Move to &First' 1 1 0 0 0 3778 1 3810 8 #moveUp 8 'Move to &Previous' 1 1 0 0 0 3778 1 3810 8 #moveDown 8 'Move to &Next' 1 1 0 0 0 3778 1 3810 8 #moveLast 8 'Move to &Last' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 3552 0 8 4294903485 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  3312 0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 '' 689 8 #left 4096 8 ##(Smalltalk.SortedCollection)  0 0 3552 0 3 0 0 8 #list 2480 0 133121 0 0 994 202 208 98 2 1058 1088 98 2 610 1 37 610 689 223 3552 1058 8 #contextMenu: 98 1 3744 3552 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 88 1 0 0 129 0 0 0] 98 0 1344 0 27 234 256 98 4 3552 8 'subclasses' 3008 8 'statusbar' 590342 ##(Smalltalk.Rectangle)  610 1 1 610 1 11 994 202 208 98 1 1058 1088 98 2 610 21 97 610 689 323 2496 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 48 0 0 0 98 1 0 0 209 0 0 0] 98 3 2592 3552 3008 1344 0 27 234 256 2480 4530 610 21 17 610 21 21 0 0 0 0 17125 0 0 0 610 541 391 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 32 8 1980769739 994 202 208 98 3 1058 1088 98 2 610 3359 21 610 761 571 416 1058 1776 98 1 8 'Convert to Sibling...' 416 1058 8 #updateMenuBar 2480 416 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 11 8 0 0 39 1 0 0] 98 3 672 2496 2192 1344 0 27 )! !
!ConvertToSiblingDialog class categoriesFor: #defaultModel!models!public! !
!ConvertToSiblingDialog class categoriesFor: #resource_Default_view!public!resources-views! !

