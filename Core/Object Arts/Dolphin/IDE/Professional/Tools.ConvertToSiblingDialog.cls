"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'Tools.ConvertToSiblingDialog'
	instanceVariableNames: 'subclassesPresenter namespacePresenter classNamePresenter showChangesPresenter'
	classVariableNames: ''
	imports: #(#{Refactory.Browser private})
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.ConvertToSiblingDialog guid: (Core.GUID fromString: '{2e1173da-ad55-42da-beb3-e8d674480103}')!

Tools.ConvertToSiblingDialog comment: ''!

!Tools.ConvertToSiblingDialog methodsFor!

chooseNamespace
	| rbModel |
	rbModel := self model model.
	(ChooseNamespaceDialog
		create: 'Default view'
		on: namespacePresenter model
		choices: (ClassHierarchyModel
				withRoots: ((Namespace classInModel: rbModel) subclasses
						copyWithout: (SharedPool classInModel: rbModel)) sort))
			showModal!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	classNamePresenter := self add: TextPresenter new name: 'newClassName'.
	namespacePresenter := self add: TextPresenter new name: 'namespace'.
	subclassesPresenter := self add: ListPresenter new name: 'subclasses'.
	showChangesPresenter := self add: BooleanPresenter new name: 'showChanges'!

createSchematicWiring
	super createSchematicWiring.
	classNamePresenter
		when: #valueChanged
		send: #onClassNameChanged
		to: self.
	subclassesPresenter
		when: #selectionChanged
		send: #onSelectionChanged
		to: self!

model: aChildrenToSiblingsRefactoring
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: aChildrenToSiblingsRefactoring.
	aspectBuffer := self model.
	aspectBuffer validater: [:ref | ref preconditions validate].
	classNamePresenter model: (aspectBuffer aspectValue: #unqualifiedClassName).
	namespacePresenter model: (aspectBuffer aspectValue: #environment).
	subclassesPresenter model: (ListModel on: aspectBuffer subclasses).
	showChangesPresenter model: (aspectBuffer aspectValue: #shouldShowChanges)!

onClassNameChanged
	"Private - The new superclass name has been edited. Initiate delayed validation."

	self deferredValidate!

onSelectionChanged
	self model subclasses: subclassesPresenter selections.
	self validate!

onViewOpened
	super onViewOpened.
	subclassesPresenter view selectAll!

validateModel
	classNamePresenter value.
	^super validateModel! !

!Tools.ConvertToSiblingDialog categoriesForMethods!
chooseNamespace!commands!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
model:!accessing!public! !
onClassNameChanged!event handling!private! !
onSelectionChanged!private! !
onViewOpened!event handling!public! !
validateModel!commands-queries!private! !
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 12 18 #{UI.TextEdit} 50 20 nil 240 50 2 8 1140916352 1025 384 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 384 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[122 0 0 0 255 255 255 255 161 1 0 0 21 0 0 0] 193 416 nil 384 562 #setMarginWidths: 50 1 8 #(3 3) 384 3 8 #() 518 #{Graphics.Point} 193 193 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 1 818 #fixedParentRight -53 818 #fixedPreviousTop -3 818 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 240 50 2 8 1140850944 1 896 nil nil nil 5 nil nil nil 896 nil nil 482 nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[2 0 0 0 1 0 0 0 122 0 0 0 21 0 0 0] 193 928 nil 896 562 #text: 50 1 8 'New superclass &name:' 896 3 8 #() 754 193 193 nil 27 786 818 #fixedParentLeft 5 818 #fixedViewLeft 241 818 #fixedParentTop 3 880 41 18 #{UI.TextEdit} 50 20 nil 240 50 2 8 1140850816 262145 1232 nil 464 nil 5 nil nil nil 1232 nil nil 482 nil nil 3 #perChar nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[122 0 0 0 30 0 0 0 161 1 0 0 50 0 0 0] 193 1264 nil 1232 562 #setMarginWidths: 50 1 8 #(3 3) 1232 3 8 #() 754 193 193 nil 45 786 832 1 848 -53 864 -1 880 41 18 #{UI.PushButton} 50 20 nil 240 50 2 8 1140924416 1 1520 nil 464 nil 5 nil nil nil 1520 nil nil 1350 4 #{UI.CommandDescription} #chooseNamespace 8 '…' 1 1 nil nil false nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[168 1 0 0 30 0 0 0 188 1 0 0 50 0 0 0] 193 1552 8 '…' 1520 562 #isEnabled: 8 #(false) 1520 3 8 #() 754 193 193 nil 29 786 832 15 1200 41 864 1 880 41 18 #{UI.StaticText} 50 16 nil 240 50 2 8 1140850944 1 1840 nil nil nil 5 nil nil nil 1840 nil nil 482 nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[2 0 0 0 31 0 0 0 122 0 0 0 51 0 0 0] 193 1872 nil 1840 562 #text: 50 1 8 '&Namespace:' 1840 3 8 #() 754 193 193 nil 27 786 1184 5 1200 241 818 #fixedPreviousBottom 21 880 41 18 #{UI.StaticRectangle} 50 14 nil 240 50 2 8 1140850960 1 2144 nil nil nil 5 nil nil nil 2144 nil nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 59 0 0 0 188 1 0 0 61 0 0 0] 193 2176 8 '' 2144 3 8 #() 754 193 193 nil 27 786 1184 1 848 1 818 #fixedViewBottom -3 818 #fixedParentBottom -7 338 #{Core.IdentityDictionary} 50 6 1520 8 'chooseNamespace' 1232 8 'namespace' 384 8 'newClassName' nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[10 0 0 0 8 0 0 0 198 1 0 0 73 0 0 0] 193 272 8 '' 240 3 50 6 896 384 1840 1232 1520 2144 754 193 193 nil 27 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 2656 nil nil nil 5 nil nil nil 2656 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_Refactoring_OK_Cancel_button_block nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[10 0 0 0 216 0 0 0 198 1 0 0 246 0 0 0] 193 2688 8 '' 2656 3 8 #() 754 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2912 nil nil nil 5 nil nil nil 2912 210 1 11 18 #{UI.StaticText} 50 16 nil 2912 50 2 8 1140850944 65 2992 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 517 nil nil nil 2992 464 nil 482 nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 0 0 0 0 188 1 0 0 15 0 0 0] 193 3024 nil 2992 562 #text: 50 1 8 'Choose subclasses to be promoted to siblings:' 2992 3 8 #() 754 193 193 nil 27 18 #{UI.ReferenceView} 50 14 nil 2912 50 2 8 1140850688 131073 3328 nil nil nil 5 nil nil nil 3328 2722 #{UI.ValidationStatusPresenter} #resource_Default_view nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 118 0 0 0 188 1 0 0 138 0 0 0] 193 3360 8 '' 3328 3 2880 754 193 193 nil 27 nil nil 18 #{UI.ListView} 50 45 nil 2912 50 2 8 1140970059 1025 3552 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 464 nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1586 #moveFirst 8 'Move to &First' 1 1 nil nil nil 3762 1 1586 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3762 1 1586 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3762 1 1586 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3552 nil nil 518 #{Core.Message} #displayString 8 #() 3986 #iconImageIndex 4016 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 3650 1 3142 5 #{UI.ListViewColumn} 8 '' 689 #left 4000 3986 #<= 8 #() nil nil 3552 nil 3 nil nil #list 8 #() nil 133121 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 3552 nil nil nil nil nil nil nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 20 0 0 0 188 1 0 0 113 0 0 0] 193 3584 8 '' 3552 562 #contextMenu: 50 1 3728 3552 3 8 #() 754 193 193 nil 35 338 #{Core.IdentityDictionary} 50 4 3552 8 'subclasses' 3328 8 'validationStatus' 518 #{Graphics.Rectangle} 754 1 1 754 1 11 514 50 1 562 #createWindow: 50 1 610 642 8 #[10 0 0 0 73 0 0 0 198 1 0 0 216 0 0 0] 193 2944 8 '' 2912 3 50 3 2992 3552 3328 754 193 193 nil 27 550 #{Core.IdentityDictionary} 0 4482 754 21 17 754 21 21 nil nil nil nil 1 nil nil nil 754 601 441 1 nil 193 774 #{Core.Semaphore} nil nil 1 false nil nil nil nil nil 514 50 2 562 #createWindow: 50 1 518 #{UI.CreateDialog} 4482 754 7679 21 754 8639 611 193 32 562 #setWindowText: 50 1 8 'Convert to Sibling…' 32 1 50 3 240 2912 2656 754 193 193 nil 29)! !

!Tools.ConvertToSiblingDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

