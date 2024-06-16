"Filed out from Dolphin Smalltalk"!

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

!ConvertToSiblingDialog categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
isValid!private!testing! !
model:!accessing!public! !
onSelectionChanged!public! !
onViewOpened!event handling!public! !
queryCommand:!commands!private! !
!

!ConvertToSiblingDialog class methodsFor!

defaultModel
	^ChildrenToSiblingsRefactoring new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(12845056 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.TextEdit) 34 16 nil 608 34 2 8 1140916352 1025 736 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 736 nil 8 1759000288 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[150 0 0 0 8 0 0 0 87 1 0 0 30 0 0 0] 193 768 nil 736 946 #setMarginWidths: 34 1 8 #(3 3) 736 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 21 1202 #fixedParentRight -1 1202 #fixedPreviousTop -5 1202 #fixedViewTop 45 410 ##(Smalltalk.StaticText) 34 16 nil 608 34 2 8 1140850944 1 1280 nil nil nil 5 nil nil nil 1280 nil 8 1759212608 850 nil nil nil 882 138 144 34 2 946 #createWindow: 34 1 994 1026 8 #[0 0 0 0 11 0 0 0 140 0 0 0 31 0 0 0] 193 1312 nil 1280 946 #text: 34 1 8 '&Name for new superclass:' 1280 3 8 #() 1138 193 193 nil 27 1170 1202 #fixedParentLeft 1 1202 #fixedViewLeft 281 1202 #fixedParentTop 23 1264 41 170 192 34 2 736 8 'newClassName' nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[10 0 0 0 8 0 0 0 98 1 0 0 48 0 0 0] 193 640 8 '' 608 3 34 2 1280 736 1138 193 193 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1872 nil nil nil 5 nil nil nil 1872 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[10 0 0 0 216 0 0 0 98 1 0 0 246 0 0 0] 193 1904 8 '' 1872 3 8 #() 1138 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2144 nil nil nil 5 nil nil nil 2144 578 1 11 410 ##(Smalltalk.StaticText) 34 16 nil 2144 34 2 8 1140850944 65 2224 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 517 nil nil nil 2224 816 8 1759212608 850 nil nil nil 882 138 144 34 2 946 #createWindow: 34 1 994 1026 8 #[0 0 0 0 0 0 0 0 88 1 0 0 15 0 0 0] 193 2256 nil 2224 946 #text: 34 1 8 'Choose subclasses to be promoted to siblings:' 2224 3 8 #() 1138 193 193 nil 27 410 ##(Smalltalk.StatusBar) 34 21 nil 2144 34 2 8 1409288204 1 2592 nil nil nil 5 nil nil nil 2592 nil 8 1758805184 170 192 34 2 853830 1 ##(Smalltalk.StatusBarItem) 8193 -1 2592 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 2738 #iconImageIndex 8 #() nil 8 'status' nil nil nil 34 1 2720 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 2592 nil nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[0 0 0 0 143 0 0 0 88 1 0 0 163 0 0 0] 193 2624 8 '' 2592 3 8 #() 1138 193 193 nil 29 nil nil 410 ##(Smalltalk.ListView) 34 45 nil 2144 34 2 8 1140970059 1025 3056 590662 2 ##(Smalltalk.ListModel) 138 144 2112 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 816 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #moveFirst 8 'Move to &First' 1 1 nil nil nil 3250 1 3282 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3250 1 3282 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3250 1 3282 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3056 nil 8 1759068368 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 689 #left ##(Smalltalk.BasicListAbstract) 2738 #<= 8 #() nil nil 3056 nil 3 nil nil #list 8 #() nil 133121 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 138 144 34 2 946 #createWindow: 34 1 994 1026 8 #[0 0 0 0 20 0 0 0 88 1 0 0 138 0 0 0] 193 3088 8 '' 3056 946 #contextMenu: 34 1 3216 3056 3 8 #() 1138 193 193 nil 35 170 192 34 4 2592 8 'statusbar' 3056 8 'subclasses' 590342 ##(Smalltalk.Rectangle) 1138 1 1 1138 1 11 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[10 0 0 0 48 0 0 0 98 1 0 0 216 0 0 0] 193 2176 8 '' 2144 3 34 3 2224 3056 2592 1138 193 193 nil 27 170 192 2112 3938 1138 21 17 1138 21 21 nil nil nil nil 10905 nil nil nil 1138 601 441 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 2006356512 nil nil nil nil 882 138 144 34 2 946 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 3938 1138 1 1 1138 761 591 193 416 946 #setWindowText: 34 1 8 'Convert to Sibling...' 416 1 34 3 608 2144 1872 1138 193 193 nil 29 )! !

!ConvertToSiblingDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

