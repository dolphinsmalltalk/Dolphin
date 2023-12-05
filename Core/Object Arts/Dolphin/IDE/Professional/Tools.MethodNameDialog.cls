"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'Tools.MethodNameDialog'
	instanceVariableNames: 'selectorPresenter parametersPresenter parameterNamesPresenter showChangesPresenter'
	classVariableNames: ''
	imports: #(#{Refactory.Browser private})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.MethodNameDialog guid: (Core.GUID fromString: '{560f006d-fa1b-4603-810c-3b7b21486bd3}')!
Tools.MethodNameDialog comment: 'MethodNameDialog is a <dialogPresenter> used to edit a method selector and argument list. It is part of the native Dolphin Refactoring Browser implementation, and is used for refactorings such as ''Rename Method''.

Instance Variables:
	selectorPresenter		<TextPresenter>. The method selector.
	parametersPresenter		<ListValuePresenter>. List of argument names.

'!
!Tools.MethodNameDialog categoriesForClass!MVP-Presenters! !
!Tools.MethodNameDialog methodsFor!

allowExistingSelector
	^false!

allowParameterRename: aBoolean
	parameterNamesPresenter view canEditLabels: aBoolean!

allowParameterReordering: aBoolean
	parameterNamesPresenter view isEnabled: aBoolean!

conditionsFor: aRBMethodName
	^aRBMethodName conditions!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	"We don't want to show an error bubble if the user hasn't entered any text yet."
	validationResultPresenter
		filterBlock: [:result | self model selector notEmpty];
		hintFont: SmalltalkSystem current defaultFont.
	selectorPresenter := self add: TextPresenter new name: 'selector'.
	parametersPresenter := self add: SequenceableCollectionPresenter new name: 'parameters'.
	parameterNamesPresenter := parametersPresenter presenterNamed: 'list'.
	showChangesPresenter := self add: BooleanPresenter new name: 'showChanges'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	parameterNamesPresenter
		when: #labelOf:editedTo:accept:
		send: #onParameter:renamedTo:accept:
		to: self.
	selectorPresenter
		when: #valueChanged
		send: #onSignatureChanged
		to: self.
	"There is something awry/missing with the event propagation here. We shouldn't need to delve in to the ListModel like this."
	parameterNamesPresenter model
		when: #listChanged
		send: #onSignatureChanged
		to: self!

model: anObject
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: anObject.
	aspectBuffer := self model.
	self validater: [:methodName | (self conditionsFor: methodName) validate].
	selectorPresenter model: (aspectBuffer aspectValue: #selector).
	parametersPresenter model: (aspectBuffer aspectValue: #arguments)!

onParameter: aString renamedTo: aString2 accept: aValueHolder
	| args |
	args := self model arguments.
	(args includes: aString2) 
		ifTrue: [aValueHolder value: false]
		ifFalse: 
			[args := args copy at: (args indexOf: aString) put: aString2; yourself.
			(self model aspectValue: #arguments) value: args.
			aValueHolder value: true]!

onSignatureChanged
	"Private - The method signature has been edited. Initiate delayed validation."

	self deferredValidate!

showChanges
	^showChangesPresenter value!

validater: aMonadicValuable
	self model validater: 
			[:methodName |
			(aMonadicValuable value: methodName)
				caption: 'Invalid Signature';
				presenter: selectorPresenter;
				yourself]!

validationResultPresenterClass
	^ValidationHintPresenter! !
!Tools.MethodNameDialog categoriesForMethods!
allowExistingSelector!public!testing! !
allowParameterRename:!accessing!public! !
allowParameterReordering:!accessing!public! !
conditionsFor:!helpers!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
model:!accessing!public! !
onParameter:renamedTo:accept:!event handling!public! !
onSignatureChanged!event handling!private! !
showChanges!public! !
validater:!accessing!public! !
validationResultPresenterClass!constants!public! !
!

!Tools.MethodNameDialog class methodsFor!

defaultModel
	^RBMethodName new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 4 18 #{UI.TextEdit} 50 20 nil 272 50 2 8 1140916352 1025 416 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 416 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 141 13 210 567 45 416 594 #setMarginWidths: 50 1 8 #(3 3) 416 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 8 #() 210 193 193 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 21 834 #fixedParentRight -1 834 #fixedPreviousTop -5 834 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 272 50 2 8 1140850944 1 912 nil nil nil 5 nil nil nil 912 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 210 11 19 210 111 41 912 594 #text: 50 1 8 '&Selector:' 912 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 9 0 0 0 60 0 0 0 29 0 0 0] 8 #() 784 nil 27 802 834 #fixedParentLeft 11 834 #fixedViewLeft 111 834 #fixedParentTop 19 896 41 370 #{Core.IdentityDictionary} 50 2 416 8 'selector' nil 546 50 1 594 #createAt:extent: 50 2 210 21 17 210 709 81 272 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 108 1 0 0 48 0 0 0] 50 2 912 416 784 nil 27 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 1440 nil nil nil 5 nil nil nil 1440 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 546 50 1 594 #createAt:extent: 50 2 210 21 353 210 709 61 1440 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 176 0 0 0 108 1 0 0 206 0 0 0] 8 #() 784 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1680 nil nil nil 5 nil nil nil 1680 242 1 1 18 #{UI.Toolbar} 50 28 nil 1680 50 2 8 1140853612 131073 1760 nil nil nil 517 nil nil nil 1760 496 nil 370 #{Core.IdentityDictionary} 1664 nil nil nil nil 50 4 1094 1 #{UI.ToolbarIconButton} 1760 1 1350 4 #{UI.CommandDescription} #moveFirst 8 'Move First' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $⏮ 8 'Georgia' nil 482 #menuHilight nil nil 3 nil nil nil 1858 1760 1 1890 #moveUp 8 'Move Up' 1 1 1938 8 $▲ 8 'Segoe UI' nil 2000 nil nil 1 nil nil nil 1858 1760 1 1890 #moveDown 8 'Move Down' 1 1 1938 8 $▼ nil nil 2000 nil nil 1 nil nil nil 1858 1760 1 1890 #moveLast 8 'Move Last' 1 1 1938 8 $⏭ 8 'Georgia' nil 2000 nil nil 3 nil nil nil nil nil 1 nil 210 33 33 nil nil nil 546 50 1 594 #createAt:extent: 50 2 210 1 1 210 709 51 1760 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 8 #() 784 nil 29 nil nil nil 18 #{UI.ListView} 50 45 nil 1680 50 2 8 1140970061 1025 2448 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 496 nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1890 #moveFirst 8 'Move to &First' 1 1 nil nil nil 2658 1 1890 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 2658 1 1890 #moveDown 8 'Move to &Next' 1 1 nil nil nil 2658 1 1890 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2448 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 2546 1 3142 5 #{UI.ListViewColumn} 8 '' 701 #left 2896 2882 #<= 8 #() nil nil 2448 nil 3 nil nil #report 8 #() nil 133121 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 546 50 1 594 #createAt:extent: 50 2 210 1 51 210 709 197 2448 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 98 1 0 0 123 0 0 0] 8 #() 784 nil 35 370 #{Core.IdentityDictionary} 50 2 2448 8 'list' 518 #{Graphics.Rectangle} 210 1 1 210 1 11 546 50 1 594 #createAt:extent: 50 2 210 21 97 210 709 257 1680 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 48 0 0 0 108 1 0 0 176 0 0 0] 50 2 1760 2448 784 nil 27 370 #{Core.IdentityDictionary} 50 2 1680 8 'parameters' 3266 210 21 17 210 21 21 nil nil nil nil 1 nil nil nil 210 541 391 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 546 50 2 594 #createAt:extent: 50 2 210 6143 21 210 781 511 32 594 #text: 50 1 8 'New Method Name…' 32 722 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 133 13 0 0 9 1 0 0] 50 3 272 1680 1440 784 nil 27)!

resource_Refactoring_view
	"Answer the literal data from which the 'Refactoring view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Refactoring_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 4 18 #{UI.TextEdit} 50 20 nil 272 50 2 8 1140916352 1025 416 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 416 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 141 13 210 567 45 416 594 #setMarginWidths: 50 1 8 #(3 3) 416 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 8 #() 210 193 193 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 21 834 #fixedParentRight -1 834 #fixedPreviousTop -5 834 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 272 50 2 8 1140850944 1 912 nil nil nil 5 nil nil nil 912 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 210 11 19 210 111 41 912 594 #text: 50 1 8 '&Selector:' 912 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 9 0 0 0 60 0 0 0 29 0 0 0] 8 #() 784 nil 27 802 834 #fixedParentLeft 11 834 #fixedViewLeft 111 834 #fixedParentTop 19 896 41 370 #{Core.IdentityDictionary} 50 2 416 8 'selector' nil 546 50 1 594 #createAt:extent: 50 2 210 21 17 210 709 81 272 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 108 1 0 0 48 0 0 0] 50 2 912 416 784 nil 27 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 1440 nil nil nil 5 nil nil nil 1440 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_Refactoring_OK_Cancel_button_block nil 546 50 1 594 #createAt:extent: 50 2 210 21 353 210 709 61 1440 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 176 0 0 0 108 1 0 0 206 0 0 0] 8 #() 784 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1680 nil nil nil 5 nil nil nil 1680 242 1 1 18 #{UI.Toolbar} 50 28 nil 1680 50 2 8 1140853612 131073 1760 nil nil nil 517 nil nil nil 1760 496 nil 370 #{Core.IdentityDictionary} 1664 nil nil nil nil 50 4 1094 1 #{UI.ToolbarIconButton} 1760 1 1350 4 #{UI.CommandDescription} #moveFirst 8 'Move First' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $⏮ 8 'Georgia' nil 482 #menuHilight nil nil 3 nil nil nil 1858 1760 1 1890 #moveUp 8 'Move Up' 1 1 1938 8 $▲ 8 'Segoe UI' nil 2000 nil nil 1 nil nil nil 1858 1760 1 1890 #moveDown 8 'Move Down' 1 1 1938 8 $▼ nil nil 2000 nil nil 1 nil nil nil 1858 1760 1 1890 #moveLast 8 'Move Last' 1 1 1938 8 $⏭ 8 'Georgia' nil 2000 nil nil 3 nil nil nil nil nil 1 nil 210 33 33 nil nil nil 546 50 1 594 #createAt:extent: 50 2 210 1 1 210 709 51 1760 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 8 #() 784 nil 29 nil nil nil 18 #{UI.ListView} 50 45 nil 1680 50 2 8 1140970061 1025 2448 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 496 nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1890 #moveFirst 8 'Move to &First' 1 1 nil nil nil 2658 1 1890 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 2658 1 1890 #moveDown 8 'Move to &Next' 1 1 nil nil nil 2658 1 1890 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2448 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 2546 1 3142 5 #{UI.ListViewColumn} 8 '' 701 #left 2896 2882 #<= 8 #() nil nil 2448 nil 3 nil nil #report 8 #() nil 133121 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 546 50 1 594 #createAt:extent: 50 2 210 1 51 210 709 197 2448 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 98 1 0 0 123 0 0 0] 8 #() 784 nil 35 370 #{Core.IdentityDictionary} 50 2 2448 8 'list' 518 #{Graphics.Rectangle} 210 1 1 210 1 11 546 50 1 594 #createAt:extent: 50 2 210 21 97 210 709 257 1680 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 48 0 0 0 108 1 0 0 176 0 0 0] 50 2 1760 2448 784 nil 27 370 #{Core.IdentityDictionary} 50 2 1680 8 'parameters' 3266 210 21 17 210 21 21 nil nil nil nil 1 nil nil nil 210 541 391 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 546 50 2 594 #createAt:extent: 50 2 210 6143 21 210 781 511 32 594 #text: 50 1 8 'New Method Name…' 32 722 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 133 13 0 0 9 1 0 0] 50 3 272 1680 1440 784 nil 27)! !
!Tools.MethodNameDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
resource_Refactoring_view!public!resources-views! !
!

