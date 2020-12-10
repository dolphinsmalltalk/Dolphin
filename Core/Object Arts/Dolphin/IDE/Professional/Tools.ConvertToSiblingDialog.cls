"Filed out from Dolphin Smalltalk 7"!

UI.Dialog subclass: #'Tools.ConvertToSiblingDialog'
	instanceVariableNames: 'classNamePresenter subclassesPresenter statusModel'
	classVariableNames: ''
	imports: #(#{Refactory.Browser private})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ConvertToSiblingDialog guid: (Core.GUID fromString: '{2e1173da-ad55-42da-beb3-e8d674480103}')!
Tools.ConvertToSiblingDialog comment: ''!
!Tools.ConvertToSiblingDialog categoriesForClass!MVP-Presenters!MVP-Resources-Dialogs! !
!Tools.ConvertToSiblingDialog methodsFor!

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
!Tools.ConvertToSiblingDialog categoriesFor: #createComponents!initializing!public! !
!Tools.ConvertToSiblingDialog categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.ConvertToSiblingDialog categoriesFor: #isValid!private!testing! !
!Tools.ConvertToSiblingDialog categoriesFor: #model:!accessing!public! !
!Tools.ConvertToSiblingDialog categoriesFor: #onSelectionChanged!public! !
!Tools.ConvertToSiblingDialog categoriesFor: #onViewOpened!event handling!public! !
!Tools.ConvertToSiblingDialog categoriesFor: #queryCommand:!commands!private! !

!Tools.ConvertToSiblingDialog class methodsFor!

defaultModel
	^ChildrenToSiblingsRefactoring new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 133 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1048838 ##(UI.FramingLayout) 170 176 34 4 410 ##(UI.StaticText) 34 16 nil 640 34 2 8 1140850944 1 768 nil nil nil 7 nil nil nil 768 nil 8 1801195232 1049094 ##(UI.NullConverter) nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 1 23 578 281 41 768 946 #text: 34 1 8 '&Name for new superclass:' 768 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 11 0 0 0 140 0 0 0 31 0 0 0] 8 #() 578 193 193 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 1 1186 #fixedViewLeft 281 1186 #fixedParentTop 23 1186 #fixedViewTop 41 410 ##(UI.TextEdit) 34 16 nil 640 34 2 8 1140916352 1025 1264 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1264 nil 8 1801338832 850 nil nil 1 882 138 144 34 2 946 #createAt:extent: 34 2 578 301 17 578 387 45 1264 946 #setMarginWidths: 34 1 8 #(3 3) 1264 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 150 0 0 0 8 0 0 0 87 1 0 0 30 0 0 0] 8 #() 1136 nil 27 1154 1186 #fixedPreviousRight 21 1186 #fixedParentRight -1 1186 #fixedPreviousTop -5 1248 45 170 192 34 2 1264 8 'newClassName' nil 882 138 144 34 1 946 #createAt:extent: 34 2 578 21 17 578 689 81 640 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 98 1 0 0 48 0 0 0] 34 2 768 1264 1136 nil 27 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1872 nil nil nil 7 nil nil nil 1872 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 882 138 144 34 1 946 #createAt:extent: 34 2 578 21 433 578 689 61 1872 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 216 0 0 0 98 1 0 0 246 0 0 0] 8 #() 1136 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2128 nil nil nil 7 nil nil nil 2128 610 1 11 410 ##(UI.StaticText) 34 16 nil 2128 34 2 8 1140850944 65 2208 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil nil nil 519 nil nil nil 2208 1344 8 1801195232 850 nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 578 1 1 578 689 31 2208 946 #text: 34 1 8 'Choose subclasses to be promoted to siblings:' 2208 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 15 0 0 0] 8 #() 1136 nil 27 410 ##(UI.StatusBar) 34 18 nil 2128 34 2 8 1409288204 1 2576 nil nil nil 7 nil nil nil 2576 nil 8 1801004784 170 192 34 2 1050374 ##(UI.StatusBarItem) 1 -1 2576 nil 786950 ##(Core.Message) #displayString 8 #() 2722 #iconImageIndex 8 #() nil 8 'status' 34 1 2704 1311750 ##(UI.StatusBarNullItem) 513 1 2576 nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 578 1 287 578 689 41 2576 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 0 0 0 88 1 0 0 163 0 0 0] 8 #() 1136 nil 27 nil nil 410 ##(UI.ListView) 34 45 nil 2128 34 2 8 1140970059 1025 3024 787270 2 ##(UI.ListModel) 138 144 2112 nil 1769478 ##(Kernel.IdentitySearchPolicy) 1344 nil 7 461638 4 ##(UI.Menu) nil true 34 4 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #moveFirst 8 'Move to &First' 1 1 nil nil nil 3218 1 3250 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3218 1 3250 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3218 1 3250 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3024 nil 8 1801282304 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 '' 689 #left ##(UI.BasicListAbstract) 2722 #<= 8 #() nil nil 3024 nil 3 nil nil #list 8 #() nil 133121 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 578 1 41 578 689 237 3024 946 #contextMenu: 34 1 3184 3024 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 20 0 0 0 88 1 0 0 138 0 0 0] 8 #() 1136 nil 35 170 192 34 4 3024 8 'subclasses' 2576 8 'statusbar' 1180166 ##(Graphics.Rectangle) 578 1 1 578 1 11 882 138 144 34 1 946 #createAt:extent: 34 2 578 21 97 578 689 337 2128 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 48 0 0 0 98 1 0 0 216 0 0 0] 34 3 2208 3024 2576 1136 nil 27 170 192 2112 3890 578 21 17 578 21 21 nil nil nil nil 29171 nil nil nil 578 601 441 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 false 8 1996777232 882 138 144 34 2 946 #createAt:extent: 34 2 578 6143 21 578 761 591 416 946 #text: 34 1 8 'Convert to Sibling...' 416 1074 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 49 1 0 0] 34 3 640 2128 1872 1136 nil 27 )! !
!Tools.ConvertToSiblingDialog class categoriesFor: #defaultModel!models!public! !
!Tools.ConvertToSiblingDialog class categoriesFor: #resource_Default_view!public!resources-views! !

