"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'Tools.ConvertToSiblingDialog'
	instanceVariableNames: 'subclassesPresenter namespacePresenter classNamePresenter'
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
	subclassesPresenter := self add: ListPresenter new name: 'subclasses'!

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
	subclassesPresenter model: (ListModel on: aspectBuffer subclasses)!

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
	^super validateModel!

validationResult: aValidationResult
	validationResultPresenter value: aValidationResult! !
!Tools.ConvertToSiblingDialog categoriesForMethods!
chooseNamespace!commands!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
model:!accessing!public! !
onClassNameChanged!event handling!private! !
onSelectionChanged!private! !
onViewOpened!event handling!public! !
validateModel!commands-queries!private! !
validationResult:!accessing!public! !
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 12 18 #{UI.TextEdit} 50 20 nil 272 50 2 8 1140916352 1025 416 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 416 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 245 -1 210 591 45 416 594 #setMarginWidths: 50 1 8 #(3 3) 416 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 255 255 255 255 161 1 0 0 21 0 0 0] 8 #() 210 193 193 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 1 834 #fixedParentRight -53 834 #fixedPreviousTop -3 834 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 272 50 2 8 1140850944 1 912 nil nil nil 5 nil nil nil 912 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 210 5 3 210 241 41 912 594 #text: 50 1 8 'New superclass &name:' 912 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 1 0 0 0 122 0 0 0 21 0 0 0] 8 #() 784 nil 27 802 834 #fixedParentLeft 5 834 #fixedViewLeft 241 834 #fixedParentTop 3 896 41 18 #{UI.TextEdit} 50 20 nil 272 50 2 8 1140850816 262145 1248 nil 496 nil 5 nil nil nil 1248 nil nil 514 nil nil 3 #perChar nil nil nil 546 50 2 594 #createAt:extent: 50 2 210 245 61 210 591 41 1248 594 #setMarginWidths: 50 1 8 #(3 3) 1248 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 30 0 0 0 161 1 0 0 50 0 0 0] 8 #() 784 nil 45 802 848 1 864 -53 880 -1 896 41 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 1536 nil 496 nil 5 nil nil nil 1536 nil nil 1350 4 #{UI.CommandDescription} #chooseNamespace 8 '…' 1 1 nil nil false nil nil nil 546 50 3 594 #createAt:extent: 50 2 210 849 61 210 41 41 1536 594 #isEnabled: 8 #(false) 1536 594 #text: 50 1 8 '…' 1536 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 168 1 0 0 30 0 0 0 188 1 0 0 50 0 0 0] 8 #() 784 nil 29 802 848 15 1216 41 880 1 896 41 18 #{UI.StaticText} 50 16 nil 272 50 2 8 1140850944 1 1888 nil nil nil 5 nil nil nil 1888 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 210 5 63 210 241 41 1888 594 #text: 50 1 8 '&Namespace:' 1888 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 31 0 0 0 122 0 0 0 51 0 0 0] 8 #() 784 nil 27 802 1200 5 1216 241 834 #fixedPreviousBottom 21 896 41 18 #{UI.StaticRectangle} 50 14 nil 272 50 2 8 1140850960 1 2192 nil nil nil 5 nil nil nil 2192 nil nil 546 50 1 594 #createAt:extent: 50 2 210 1 119 210 889 5 2192 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 59 0 0 0 188 1 0 0 61 0 0 0] 8 #() 784 nil 27 802 1200 1 864 1 834 #fixedViewBottom -3 834 #fixedParentBottom -7 370 #{Core.IdentityDictionary} 50 6 1536 8 'chooseNamespace' 1248 8 'namespace' 416 8 'newClassName' nil 546 50 1 594 #createAt:extent: 50 2 210 21 17 210 889 131 272 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 198 1 0 0 73 0 0 0] 50 6 912 416 1888 1248 1536 2192 784 nil 27 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 2672 nil nil nil 5 nil nil nil 2672 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 546 50 1 594 #createAt:extent: 50 2 210 21 433 210 889 61 2672 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 216 0 0 0 198 1 0 0 246 0 0 0] 8 #() 784 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2912 nil nil nil 5 nil nil nil 2912 242 1 11 18 #{UI.StaticText} 50 16 nil 2912 50 2 8 1140850944 65 2992 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 517 nil nil nil 2992 496 nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 210 1 1 210 889 31 2992 594 #text: 50 1 8 'Choose subclasses to be promoted to siblings:' 2992 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 188 1 0 0 15 0 0 0] 8 #() 784 nil 27 18 #{UI.ReferenceView} 50 14 nil 2912 50 2 8 1140850688 131073 3328 nil nil nil 5 nil nil nil 3328 2738 #{UI.ValidationStatusPresenter} #resource_Default_view nil 546 50 1 594 #createAt:extent: 50 2 210 1 237 210 889 41 3328 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 118 0 0 0 188 1 0 0 138 0 0 0] 2896 784 nil 27 nil nil 18 #{UI.ListView} 50 45 nil 2912 50 2 8 1140970059 1025 3536 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 496 nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1602 #moveFirst 8 'Move to &First' 1 1 nil nil nil 3746 1 1602 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3746 1 1602 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3746 1 1602 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3536 nil nil 518 #{Core.Message} #displayString 8 #() 3970 #iconImageIndex 4000 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 3634 1 3142 5 #{UI.ListViewColumn} 8 '' 689 #left 3984 3970 #<= 8 #() nil nil 3536 nil 3 nil nil #list 8 #() nil 133121 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 546 50 1 594 #createAt:extent: 50 2 210 1 41 210 889 187 3536 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 20 0 0 0 188 1 0 0 113 0 0 0] 8 #() 784 nil 35 370 #{Core.IdentityDictionary} 50 4 3536 8 'subclasses' 3328 8 'validationStatus' 518 #{Graphics.Rectangle} 210 1 1 210 1 11 546 50 1 594 #createAt:extent: 50 2 210 21 147 210 889 287 2912 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 73 0 0 0 198 1 0 0 216 0 0 0] 50 3 2992 3536 3328 784 nil 27 550 #{Core.IdentityDictionary} 0 4386 210 21 17 210 21 21 nil nil nil nil 1 nil nil nil 210 601 441 1 nil nil 774 #{Core.Semaphore} nil nil 1 false nil 546 50 2 594 #createAt:extent: 50 2 210 6143 21 210 961 591 32 594 #text: 50 1 8 'Convert to Sibling…' 32 722 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 223 13 0 0 49 1 0 0] 50 3 272 2912 2672 784 nil 27)! !
!Tools.ConvertToSiblingDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

