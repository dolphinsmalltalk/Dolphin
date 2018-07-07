"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #ConvertToSiblingDialog
	instanceVariableNames: 'classNamePresenter subclassesPresenter statusModel'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ConvertToSiblingDialog guid: (GUID fromString: '{2e1173da-ad55-42da-beb3-e8d674480103}')!
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 656 nil 721158 ##(Smalltalk.SystemColor) 31 nil 7 nil nil nil 656 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.StaticText) 34 16 nil 656 34 2 8 1140850944 1 816 nil nil nil 7 nil nil nil 816 nil 8 1906774720 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 1 23 594 281 41 816 994 #text: 34 1 8 '&Name for new superclass:' 816 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 11 0 0 0 140 0 0 0 31 0 0 0] 8 #() 594 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1234 #fixedViewLeft 281 1234 #fixedParentTop 23 1234 #fixedViewTop 41 410 ##(Smalltalk.TextEdit) 34 16 nil 656 34 2 8 1140916352 1025 1312 nil 466 496 nil 7 nil nil nil 1312 nil 8 1906818384 898 nil nil 1 930 138 144 34 2 994 #createAt:extent: 34 2 594 301 17 594 387 45 1312 994 #setMarginWidths: 34 1 8 #(3 3) 1312 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 150 0 0 0 8 0 0 0 87 1 0 0 30 0 0 0] 8 #() 1184 nil 27 1202 1234 #fixedPreviousRight 21 1234 #fixedParentRight -1 1234 #fixedPreviousTop -5 1296 45 170 192 34 2 1312 8 'newClassName' nil 930 138 144 34 1 994 #createAt:extent: 34 2 594 21 17 594 689 81 656 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 98 1 0 0 48 0 0 0] 34 2 816 1312 1184 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1904 nil nil nil 7 nil nil nil 1904 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 930 138 144 34 1 994 #createAt:extent: 34 2 594 21 433 594 689 61 1904 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 216 0 0 0 98 1 0 0 246 0 0 0] 8 #() 1184 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2160 nil 722 31 nil 7 nil nil nil 2160 626 1 11 410 ##(Smalltalk.StaticText) 34 16 nil 2160 34 2 8 1140850944 65 2256 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 466 8 4278190080 nil 519 nil nil nil 2256 466 496 8 1906774720 898 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 594 1 1 594 689 31 2256 994 #text: 34 1 8 'Choose subclasses to be promoted to siblings:' 2256 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 15 0 0 0] 8 #() 1184 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 2160 34 2 8 1409288204 1 2672 nil 466 8 4278190080 nil 7 nil nil nil 2672 nil 8 1906628368 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 2672 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 2850 #iconImageIndex 8 #() 1049926 1 ##(Smalltalk.IconImageManager) 8 'status' 34 1 2832 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2672 nil nil 930 138 144 34 1 994 #createAt:extent: 34 2 594 1 287 594 689 41 2672 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 0 0 0 88 1 0 0 163 0 0 0] 8 #() 1184 nil 27 nil nil 410 ##(Smalltalk.ListView) 34 30 nil 2160 34 2 8 1140970059 1025 3184 590662 2 ##(Smalltalk.ListModel) 138 144 2144 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 496 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #moveFirst 8 'Move to &First' 1 1 nil nil nil 3394 1 3426 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3394 1 3426 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3394 1 3426 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3184 nil 8 1906899344 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2944 nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 689 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 3184 nil 3 nil nil #list 2144 nil 133121 nil 34 4 nil nil 594 1 1 nil 930 138 144 34 2 994 #createAt:extent: 34 2 594 1 41 594 689 237 3184 994 #contextMenu: 34 1 3360 3184 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 20 0 0 0 88 1 0 0 138 0 0 0] 8 #() 1184 nil 27 170 192 34 4 2672 8 'statusbar' 3184 8 'subclasses' 590342 ##(Smalltalk.Rectangle) 594 1 1 594 1 11 930 138 144 34 1 994 #createAt:extent: 34 2 594 21 97 594 689 337 2160 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 48 0 0 0 98 1 0 0 216 0 0 0] 34 3 2256 3184 2672 1184 nil 27 170 192 2144 4018 594 21 17 594 21 21 nil nil nil nil 19981 nil nil nil 594 601 441 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 2010075552 930 138 144 34 3 994 #createAt:extent: 34 2 594 3839 21 594 761 591 416 994 #text: 34 1 8 'Convert to Sibling...' 416 994 #updateMenuBar 2144 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 251 8 0 0 49 1 0 0] 34 3 656 2160 1904 1184 nil 27 )! !
!ConvertToSiblingDialog class categoriesFor: #defaultModel!models!public! !
!ConvertToSiblingDialog class categoriesFor: #resource_Default_view!public!resources-views! !

