"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #ConvertToSiblingDialog
	instanceVariableNames: 'classNamePresenter subclassesPresenter statusModel'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 165 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.TextEdit) 34 16 nil 640 34 2 8 1140916352 1025 768 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 7 nil nil nil 768 nil 8 1915280032 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 301 17 578 387 45 768 994 #setMarginWidths: 34 1 8 #(3 3) 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 150 0 0 0 8 0 0 0 87 1 0 0 30 0 0 0] 8 #() 578 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 21 1234 #fixedParentRight -1 1234 #fixedPreviousTop -5 1234 #fixedViewTop 45 410 ##(Smalltalk.StaticText) 34 16 nil 640 34 2 8 1140850944 1 1312 nil nil nil 7 nil nil nil 1312 nil 8 1915124368 898 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 23 578 281 41 1312 994 #text: 34 1 8 '&Name for new superclass:' 1312 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 11 0 0 0 140 0 0 0 31 0 0 0] 8 #() 1184 nil 27 1202 1234 #fixedParentLeft 1 1234 #fixedViewLeft 281 1234 #fixedParentTop 23 1296 41 170 192 34 2 768 8 'newClassName' nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 21 17 578 689 81 640 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 98 1 0 0 48 0 0 0] 34 2 1312 768 1184 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1888 nil nil nil 7 nil nil nil 1888 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 21 433 578 689 61 1888 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 216 0 0 0 98 1 0 0 246 0 0 0] 8 #() 1184 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2144 nil nil nil 7 nil nil nil 2144 610 1 11 410 ##(Smalltalk.StaticText) 34 16 nil 2144 34 2 8 1140850944 65 2224 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 519 nil nil nil 2224 848 8 1915124368 898 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 689 31 2224 994 #text: 34 1 8 'Choose subclasses to be promoted to siblings:' 2224 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 15 0 0 0] 8 #() 1184 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 2144 34 2 8 1409288204 1 2592 nil nil nil 7 nil nil nil 2592 nil 8 1914952576 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 2592 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 2738 #iconImageIndex 8 #() nil 8 'status' 34 1 2720 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2592 nil nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 287 578 689 41 2592 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 0 0 0 88 1 0 0 163 0 0 0] 8 #() 1184 nil 27 nil nil 410 ##(Smalltalk.ListView) 34 30 nil 2144 34 2 8 1140970059 1025 3040 590662 2 ##(Smalltalk.ListModel) 138 144 2128 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 848 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #moveFirst 8 'Move to &First' 1 1 nil nil nil 3234 1 3266 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3234 1 3266 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3234 1 3266 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3040 nil 8 1915211424 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 689 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 3040 nil 3 nil nil #list 2128 nil 133121 nil 34 4 nil nil 578 1 1 nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 41 578 689 237 3040 994 #contextMenu: 34 1 3200 3040 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 20 0 0 0 88 1 0 0 138 0 0 0] 8 #() 1184 nil 27 170 192 34 4 3040 8 'subclasses' 2592 8 'statusbar' 590342 ##(Smalltalk.Rectangle) 578 1 1 578 1 11 930 138 144 34 1 994 #createAt:extent: 34 2 578 21 97 578 689 337 2144 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 48 0 0 0 98 1 0 0 216 0 0 0] 34 3 2224 3040 2592 1184 nil 27 170 192 2128 3890 578 21 17 578 21 21 nil nil nil nil 13367 nil nil nil 578 601 441 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 2011052416 930 138 144 34 3 994 #createAt:extent: 34 2 578 3839 21 578 761 591 416 994 #text: 34 1 8 'Convert to Sibling...' 416 994 #updateMenuBar 2128 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 251 8 0 0 49 1 0 0] 34 3 640 2144 1888 1184 nil 27 )! !
!ConvertToSiblingDialog class categoriesFor: #defaultModel!models!public! !
!ConvertToSiblingDialog class categoriesFor: #resource_Default_view!public!resources-views! !

