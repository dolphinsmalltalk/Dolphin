"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'Tools.ConvertToSiblingDialog'
	instanceVariableNames: 'classNamePresenter namespacePresenter subclassesPresenter statusModel'
	classVariableNames: ''
	imports: #(#{Refactory.Browser private})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ConvertToSiblingDialog guid: (Core.GUID fromString: '{2e1173da-ad55-42da-beb3-e8d674480103}')!
Tools.ConvertToSiblingDialog comment: ''!
!Tools.ConvertToSiblingDialog categoriesForClass!MVP-Presenters!MVP-Resources-Dialogs! !
!Tools.ConvertToSiblingDialog methodsFor!

chooseNamespace
	(ChooseNamespaceDialog createOn: namespacePresenter model) showModal!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	classNamePresenter := self add: TextPresenter new name: 'newClassName'.
	namespacePresenter := self add: TextPresenter new name: 'namespace'.
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
	classNamePresenter model: (aspectBuffer aspectValue: #unqualifiedClassName).
	namespacePresenter model: (aspectBuffer aspectValue: #environment).
	subclassesPresenter model: (ListModel on: aspectBuffer subclasses)!

onSelectionChanged
	self model subclasses: subclassesPresenter selections.
	^self invalidateUserInterface!

onViewOpened
	super onViewOpened.
	(self view viewNamed: 'status' ifNone: nil) ifNotNil: [:item | item model: statusModel].
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
!Tools.ConvertToSiblingDialog categoriesForMethods!
chooseNamespace!commands!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
isValid!private!testing! !
model:!accessing!public! !
onSelectionChanged!public! !
onViewOpened!event handling!public! !
queryCommand:!commands!private! !
!

!Tools.ConvertToSiblingDialog class methodsFor!

defaultModel
	^ChildrenToSiblingsRefactoring new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 7 nil nil nil 272 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 6 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 400 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 400 nil 8 1853182784 1350 4 #{UI.CommandDescription} #chooseNamespace 8 '…' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 3 774 #{Core.MessageSend} #createAt:extent: 50 2 210 649 61 210 41 41 400 610 #isEnabled: 8 #(false) 400 610 #text: 50 1 8 '…' 400 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 68 1 0 0 30 0 0 0 88 1 0 0 50 0 0 0] 8 #() 210 193 193 nil 29 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 15 882 #fixedViewLeft 41 882 #fixedPreviousTop 1 882 #fixedViewTop 41 18 #{UI.StaticRectangle} 50 14 nil 272 50 2 8 1140850960 1 960 nil nil nil 7 nil nil nil 960 nil 8 1853387904 562 50 1 610 #createAt:extent: 50 2 210 1 119 210 689 5 960 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 59 0 0 0 88 1 0 0 61 0 0 0] 8 #() 832 nil 27 850 882 #fixedParentLeft 1 882 #fixedParentRight 1 882 #fixedViewBottom -3 882 #fixedParentBottom -7 18 #{UI.StaticText} 50 16 nil 272 50 2 8 1140850944 1 1264 nil nil nil 7 nil nil nil 1264 nil 8 1853387904 518 #{UI.NullConverter} nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 5 3 210 241 41 1264 610 #text: 50 1 8 'New superclass &name:' 1264 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 1 0 0 0 122 0 0 0 21 0 0 0] 8 #() 832 nil 27 850 1200 5 912 241 882 #fixedParentTop 3 944 41 18 #{UI.StaticText} 50 16 nil 272 50 2 8 1140850944 1 1600 nil nil nil 7 nil nil nil 1600 nil 8 1853387904 1346 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 5 63 210 241 41 1600 610 #text: 50 1 8 '&Namespace:' 1600 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 31 0 0 0 122 0 0 0 51 0 0 0] 8 #() 832 nil 27 850 1200 5 912 241 882 #fixedPreviousBottom 21 944 41 18 #{UI.TextEdit} 50 20 nil 272 50 2 8 1140850816 262145 1920 nil 480 nil 7 nil nil nil 1920 nil 8 1853175488 1346 nil nil 3 #perChar nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 245 61 210 391 41 1920 610 #setMarginWidths: 50 1 8 #(3 3) 1920 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 30 0 0 0 61 1 0 0 50 0 0 0] 8 #() 832 nil 45 850 896 1 1216 -53 928 -1 944 41 18 #{UI.TextEdit} 50 20 nil 272 50 2 8 1140916352 1025 2224 nil 480 nil 7 nil nil nil 2224 nil 8 1853175488 1346 nil nil 1 #perChar nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 245 -1 210 391 45 2224 610 #setMarginWidths: 50 1 8 #(3 3) 2224 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 255 255 255 255 61 1 0 0 21 0 0 0] 8 #() 832 nil 45 850 896 1 1216 -53 928 -3 944 45 550 #{Core.IdentityDictionary} 3 400 8 'chooseNamespace' 1920 8 'namespace' 2224 8 'newClassName' nil 562 50 1 610 #createAt:extent: 50 2 210 21 17 210 689 131 272 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 98 1 0 0 73 0 0 0] 50 6 1264 2224 1600 1920 400 960 832 nil 27 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 2752 nil nil nil 7 nil nil nil 2752 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 562 50 1 610 #createAt:extent: 50 2 210 21 433 210 689 61 2752 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 216 0 0 0 98 1 0 0 246 0 0 0] 8 #() 832 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2992 nil nil nil 7 nil nil nil 2992 242 1 11 18 #{UI.StaticText} 50 16 nil 2992 50 2 8 1140850944 65 3072 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 519 nil nil nil 3072 480 8 1853387904 1346 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 689 31 3072 610 #text: 50 1 8 'Choose subclasses to be promoted to siblings:' 3072 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 15 0 0 0] 8 #() 832 nil 27 18 #{UI.StatusBar} 50 21 nil 2992 50 2 8 1409288204 1 3424 nil nil nil 7 nil nil nil 3424 nil 8 1852980448 2530 1 1862 1 #{UI.StatusBarItem} 8193 -1 3424 nil 518 #{Core.Message} #displayString 8 #() 3554 #iconImageIndex 8 #() nil 8 'status' nil nil nil 50 1 3536 1094 1 #{UI.StatusBarNullItem} 8705 1 3424 nil nil 562 50 1 610 #createAt:extent: 50 2 210 1 237 210 689 41 3424 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 118 0 0 0 88 1 0 0 138 0 0 0] 8 #() 832 nil 29 nil nil 18 #{UI.ListView} 50 45 nil 2992 50 2 8 1140970059 1025 3840 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 480 nil 7 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 514 #moveFirst 8 'Move to &First' 1 1 nil nil nil 4050 1 514 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 4050 1 514 #moveDown 8 'Move to &Next' 1 1 nil nil nil 4050 1 514 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3840 nil 8 1853243664 3554 #displayString 8 #() 3554 #iconImageIndex 4304 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 3938 1 3142 5 #{UI.ListViewColumn} 8 '' 689 #left 4288 3554 #<= 8 #() nil nil 3840 nil 3 nil nil #list 8 #() nil 133121 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 562 50 1 610 #createAt:extent: 50 2 210 1 41 210 689 187 3840 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 20 0 0 0 88 1 0 0 113 0 0 0] 8 #() 832 nil 35 2530 2 3840 8 'subclasses' 3424 8 'statusbar' 518 #{Graphics.Rectangle} 210 1 1 210 1 11 562 50 1 610 #createAt:extent: 50 2 210 21 147 210 689 287 2992 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 73 0 0 0 98 1 0 0 216 0 0 0] 50 3 3072 3840 3424 832 nil 27 2530 0 4674 210 21 17 210 21 21 nil nil nil nil 13199 nil nil nil 210 601 441 1 nil nil 774 #{Core.Semaphore} nil nil 1 false 8 2011790800 562 50 2 610 #createAt:extent: 50 2 210 6143 21 210 761 591 32 610 #text: 50 1 8 'Convert to Sibling…' 32 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 49 1 0 0] 50 3 272 2992 2752 832 nil 27)! !
!Tools.ConvertToSiblingDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

