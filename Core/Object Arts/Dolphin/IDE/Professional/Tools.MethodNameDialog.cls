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
showChanges!accessing!public! !
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 4 18 #{UI.TextEdit} 50 20 nil 240 50 2 8 1140916352 1025 384 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 384 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 193 416 nil 384 562 #setMarginWidths: 50 1 8 #(3 3) 384 3 8 #() 518 #{Graphics.Point} 193 193 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 21 818 #fixedParentRight -1 818 #fixedPreviousTop -5 818 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 240 50 2 8 1140850944 1 896 nil nil nil 5 nil nil nil 896 nil nil 482 nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[5 0 0 0 9 0 0 0 60 0 0 0 29 0 0 0] 193 928 nil 896 562 #text: 50 1 8 '&Selector:' 896 3 8 #() 754 193 193 nil 27 786 818 #fixedParentLeft 11 818 #fixedViewLeft 111 818 #fixedParentTop 19 880 41 338 #{Core.IdentityDictionary} 50 2 384 8 'selector' nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[10 0 0 0 8 0 0 0 108 1 0 0 48 0 0 0] 193 272 8 '' 240 3 50 2 896 384 754 193 193 nil 27 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 1440 nil nil nil 5 nil nil nil 1440 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[10 0 0 0 176 0 0 0 108 1 0 0 206 0 0 0] 193 1472 8 '' 1440 3 8 #() 754 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1696 nil nil nil 5 nil nil nil 1696 210 1 1 18 #{UI.Toolbar} 50 28 nil 1696 50 2 8 1140853612 131073 1776 nil nil nil 517 nil nil nil 1776 464 nil 338 #{Core.IdentityDictionary} 1664 nil nil nil nil 50 4 1606 2 #{UI.ToolbarIconButton} 1776 1 1350 4 #{UI.CommandDescription} #moveFirst 8 'Move First' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $⏮ 8 'Georgia' nil 450 #menuHilight nil nil 3 nil nil nil nil nil 1874 1776 1 1906 #moveUp 8 'Move Up' 1 1 1954 8 $▲ 8 'Segoe UI' nil 2016 nil nil 1 nil nil nil nil nil 1874 1776 1 1906 #moveDown 8 'Move Down' 1 1 1954 8 $▼ nil nil 2016 nil nil 1 nil nil nil nil nil 1874 1776 1 1906 #moveLast 8 'Move Last' 1 1 1954 8 $⏭ 8 'Georgia' nil 2016 nil nil 3 nil nil nil nil nil nil nil 9 1 #smallIcons nil nil nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 193 1808 8 '' 1776 3 8 #() 754 193 193 nil 31 nil nil nil 18 #{UI.ListView} 50 45 nil 1696 50 2 8 1140970061 1025 2464 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 464 nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1906 #moveFirst 8 'Move to &First' 1 1 nil nil nil 2674 1 1906 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 2674 1 1906 #moveDown 8 'Move to &Next' 1 1 nil nil nil 2674 1 1906 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2464 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 2562 1 3142 5 #{UI.ListViewColumn} 8 '' 701 #left 2912 2898 #<= 8 #() nil nil 2464 nil 3 nil nil #report 8 #() nil 133121 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 2464 nil nil nil nil nil nil nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 25 0 0 0 98 1 0 0 123 0 0 0] 193 2496 8 '' 2464 562 #contextMenu: 50 1 2640 2464 3 8 #() 754 193 193 nil 35 338 #{Core.IdentityDictionary} 50 2 2464 8 'list' 518 #{Graphics.Rectangle} 754 1 1 754 1 11 514 50 1 562 #createWindow: 50 1 610 642 8 #[10 0 0 0 48 0 0 0 108 1 0 0 176 0 0 0] 193 1728 8 '' 1696 3 50 2 1776 2464 754 193 193 nil 27 338 #{Core.IdentityDictionary} 50 2 1696 8 'parameters' 3362 754 21 17 754 21 21 nil nil nil nil 1 nil nil nil 754 541 391 nil nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 514 50 2 562 #createWindow: 50 1 518 #{UI.CreateDialog} 3362 754 7679 21 754 8459 531 193 32 562 #setWindowText: 50 1 8 'New Method Name…' 32 1 50 3 240 1696 1440 754 193 193 nil 29)!

resource_Refactoring_view
	"Answer the literal data from which the 'Refactoring view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Refactoring_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 4 18 #{UI.TextEdit} 50 20 nil 240 50 2 8 1140916352 1025 384 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 384 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 193 416 nil 384 562 #setMarginWidths: 50 1 8 #(3 3) 384 3 8 #() 518 #{Graphics.Point} 193 193 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 21 818 #fixedParentRight -1 818 #fixedPreviousTop -5 818 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 240 50 2 8 1140850944 1 896 nil nil nil 5 nil nil nil 896 nil nil 482 nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[5 0 0 0 9 0 0 0 60 0 0 0 29 0 0 0] 193 928 nil 896 562 #text: 50 1 8 '&Selector:' 896 3 8 #() 754 193 193 nil 27 786 818 #fixedParentLeft 11 818 #fixedViewLeft 111 818 #fixedParentTop 19 880 41 338 #{Core.IdentityDictionary} 50 2 384 8 'selector' nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[10 0 0 0 8 0 0 0 108 1 0 0 48 0 0 0] 193 272 8 '' 240 3 50 2 896 384 754 193 193 nil 27 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 1440 nil nil nil 5 nil nil nil 1440 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_Refactoring_OK_Cancel_button_block nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[10 0 0 0 176 0 0 0 108 1 0 0 206 0 0 0] 193 1472 8 '' 1440 3 8 #() 754 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1696 nil nil nil 5 nil nil nil 1696 210 1 1 18 #{UI.Toolbar} 50 28 nil 1696 50 2 8 1140853612 131073 1776 nil nil nil 517 nil nil nil 1776 464 nil 338 #{Core.IdentityDictionary} 1664 nil nil nil nil 50 4 1606 2 #{UI.ToolbarIconButton} 1776 1 1350 4 #{UI.CommandDescription} #moveFirst 8 'Move First' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $⏮ 8 'Georgia' nil 450 #menuHilight nil nil 3 nil nil nil nil nil 1874 1776 1 1906 #moveUp 8 'Move Up' 1 1 1954 8 $▲ 8 'Segoe UI' nil 2016 nil nil 1 nil nil nil nil nil 1874 1776 1 1906 #moveDown 8 'Move Down' 1 1 1954 8 $▼ nil nil 2016 nil nil 1 nil nil nil nil nil 1874 1776 1 1906 #moveLast 8 'Move Last' 1 1 1954 8 $⏭ 8 'Georgia' nil 2016 nil nil 3 nil nil nil nil nil nil nil 9 1 #smallIcons nil nil nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 193 1808 8 '' 1776 3 8 #() 754 193 193 nil 31 nil nil nil 18 #{UI.ListView} 50 45 nil 1696 50 2 8 1140970061 1025 2464 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 464 nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1906 #moveFirst 8 'Move to &First' 1 1 nil nil nil 2674 1 1906 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 2674 1 1906 #moveDown 8 'Move to &Next' 1 1 nil nil nil 2674 1 1906 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2464 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 2562 1 3142 5 #{UI.ListViewColumn} 8 '' 701 #left 2912 2898 #<= 8 #() nil nil 2464 nil 3 nil nil #report 8 #() nil 133121 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 2464 nil nil nil nil nil nil nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 25 0 0 0 98 1 0 0 123 0 0 0] 193 2496 8 '' 2464 562 #contextMenu: 50 1 2640 2464 3 8 #() 754 193 193 nil 35 338 #{Core.IdentityDictionary} 50 2 2464 8 'list' 518 #{Graphics.Rectangle} 754 1 1 754 1 11 514 50 1 562 #createWindow: 50 1 610 642 8 #[10 0 0 0 48 0 0 0 108 1 0 0 176 0 0 0] 193 1728 8 '' 1696 3 50 2 1776 2464 754 193 193 nil 27 338 #{Core.IdentityDictionary} 50 2 1696 8 'parameters' 3362 754 21 17 754 21 21 nil nil nil nil 1 nil nil nil 754 541 391 nil nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 514 50 2 562 #createWindow: 50 1 518 #{UI.CreateDialog} 3362 754 7679 21 754 8459 531 193 32 562 #setWindowText: 50 1 8 'New Method Name…' 32 1 50 3 240 1696 1440 754 193 193 nil 29)! !

!Tools.MethodNameDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
resource_Refactoring_view!public!resources-views! !
!

