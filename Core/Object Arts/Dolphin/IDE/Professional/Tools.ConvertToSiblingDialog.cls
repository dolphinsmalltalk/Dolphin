"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #ConvertToSiblingDialog
	instanceVariableNames: 'classNamePresenter subclassesPresenter statusModel'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ConvertToSiblingDialog guid: (GUID fromString: '{2e1173da-ad55-42da-beb3-e8d674480103}')!
ConvertToSiblingDialog comment: ''!
!ConvertToSiblingDialog categoriesForClass!MVP-Presenters!MVP-Resources-Dialogs! !
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.StaticText) 34 16 nil 640 34 2 8 1140850944 1 768 nil nil nil 7 nil nil nil 768 nil 8 1883797456 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 1 23 578 281 41 768 946 #text: 34 1 8 '&Name for new superclass:' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 11 0 0 0 140 0 0 0 31 0 0 0] 8 #() 578 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1186 #fixedViewLeft 281 1186 #fixedParentTop 23 1186 #fixedViewTop 41 410 ##(Smalltalk.TextEdit) 34 16 nil 640 34 2 8 1140916352 1025 1264 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 1264 nil 8 1883819888 850 nil nil 1 882 138 144 34 2 946 #createAt:extent: 34 2 578 301 17 578 387 45 1264 946 #setMarginWidths: 34 1 8 #(3 3) 1264 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 150 0 0 0 8 0 0 0 87 1 0 0 30 0 0 0] 8 #() 1136 nil 27 1154 1186 #fixedPreviousRight 21 1186 #fixedParentRight -1 1186 #fixedPreviousTop -5 1248 45 170 192 34 2 1264 8 'newClassName' nil 882 138 144 34 1 946 #createAt:extent: 34 2 578 21 17 578 689 81 640 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 98 1 0 0 48 0 0 0] 34 2 768 1264 1136 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1872 nil nil nil 7 nil nil nil 1872 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 882 138 144 34 1 946 #createAt:extent: 34 2 578 21 433 578 689 61 1872 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 216 0 0 0 98 1 0 0 246 0 0 0] 8 #() 1136 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2128 nil nil nil 7 nil nil nil 2128 610 1 11 410 ##(Smalltalk.StaticText) 34 16 nil 2128 34 2 8 1140850944 65 2208 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 519 nil nil nil 2208 1344 8 1883797456 850 nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 578 1 1 578 689 31 2208 946 #text: 34 1 8 'Choose subclasses to be promoted to siblings:' 2208 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 15 0 0 0] 8 #() 1136 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 2128 34 2 8 1409288204 1 2576 nil nil nil 7 nil nil nil 2576 nil 8 1883634224 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 2576 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 2722 #iconImageIndex 8 #() nil 8 'status' 34 1 2704 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2576 nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 578 1 287 578 689 41 2576 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 0 0 0 88 1 0 0 163 0 0 0] 8 #() 1136 nil 27 nil nil 410 ##(Smalltalk.ListView) 34 45 nil 2128 34 2 8 1140970059 1025 3024 590662 2 ##(Smalltalk.ListModel) 138 144 2112 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1344 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #moveFirst 8 'Move to &First' 1 1 nil nil nil 3218 1 3250 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3218 1 3250 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3218 1 3250 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3024 nil 8 1883852064 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 689 #left ##(Smalltalk.BasicListAbstract) 2722 #<= 8 #() nil nil 3024 nil 3 nil nil #list 2112 nil 133121 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 578 1 41 578 689 237 3024 946 #contextMenu: 34 1 3184 3024 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 20 0 0 0 88 1 0 0 138 0 0 0] 8 #() 1136 nil 35 170 192 34 4 3024 8 'subclasses' 2576 8 'statusbar' 590342 ##(Smalltalk.Rectangle) 578 1 1 578 1 11 882 138 144 34 1 946 #createAt:extent: 34 2 578 21 97 578 689 337 2128 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 48 0 0 0 98 1 0 0 216 0 0 0] 34 3 2208 3024 2576 1136 nil 27 170 192 2112 3874 578 21 17 578 21 21 nil nil nil nil 34785 nil nil nil 578 601 441 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 2010284960 882 138 144 34 3 946 #createAt:extent: 34 2 578 7039 21 578 761 591 416 946 #text: 34 1 8 'Convert to Sibling...' 416 946 #updateMenuBar 2112 416 1074 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 59 15 0 0 49 1 0 0] 34 3 640 2128 1872 1136 nil 27 )! !
!ConvertToSiblingDialog class categoriesFor: #defaultModel!models!public! !
!ConvertToSiblingDialog class categoriesFor: #resource_Default_view!public!resources-views! !

