"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'Tools.MethodNameDialog'
	instanceVariableNames: 'selectorPresenter parametersPresenter parameterNamesPresenter hintBubble showChangesPresenter'
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

closeBubble
	hintBubble
		ifNotNil: 
			[hintBubble close.
			hintBubble := nil]!

conditionsFor: aRBMethodName
	^aRBMethodName conditions!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
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

getHintCaption: aValidationResult
	^aValidationResult caption
		ifNil: [aValidationResult hint iconStyle == #error ifTrue: ['Invalid Signature']]!

hintFont
	"Private - Answer the `Font` to be used for the main text of any hint bubble. This does not affect the headline text, the font of which is not configurable."

	^SmalltalkSystem current defaultFont!

hintPosition
	"Private - Answer a <Point> representing the screen co-ordinate at which the hint bubble's arrow should point."

	^selectorPresenter view screenRectangle centerRight!

isInputValid
	^self model isValid!

model: anObject
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: anObject.
	aspectBuffer := self model.
	aspectBuffer validater: [:methodName | (self conditionsFor: methodName) validate].
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

onPositionChanged: aPositionEvent
	self closeBubble.
	^super onPositionChanged: aPositionEvent!

onSignatureChanged
	"Private - The method signature has been edited. Initiate delayed validation."

	self closeBubble.
	self view setTimer: ValidationTimerId interval: self validationDwell!

preTranslateKeyboardInput: aMSG
	"Answer whether the receiver would like to consume the argument aMSG, which is a keyboard message."

	(aMSG isKeyPress: VK_RETURN)
		ifTrue: 
			[| button |
			"If the default button is disabled, it may be helpful to show validation errors"
			button := self view defaultButton.
			(button notNil and: [button isEnabled not]) ifTrue: [self validate]].
	^super preTranslateKeyboardInput: aMSG!

queryCommand: aCommandQuery
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>."

	aCommandQuery commandSymbol == #ok
		ifTrue: 
			[aCommandQuery isEnabled: self isInputValid.
			^true].
	^super queryCommand: aCommandQuery!

showChanges
	^showChangesPresenter value!

showValidationResult: aValidationResult
	self closeBubble.
	(aValidationResult hint isNil or: [self model selector isEmpty]) ifTrue: [^self].
	hintBubble := MessageBubble new.
	hintBubble
		caption: (self getHintCaption: aValidationResult);
		font: self hintFont;
		timeout: self hintDwell;
		position: self hintPosition;
		exceptionDescription: aValidationResult hint;
		isSilent: true;
		open!

validater
	^self model validater!

validater: aMonadicValuable
	self model validater: aMonadicValuable! !
!Tools.MethodNameDialog categoriesForMethods!
allowExistingSelector!public!testing! !
allowParameterRename:!accessing!public! !
allowParameterReordering:!accessing!public! !
closeBubble!helpers!private! !
conditionsFor:!helpers!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
getHintCaption:!helpers!private! !
hintFont!constants!private! !
hintPosition!accessing!private! !
isInputValid!private!testing! !
model:!accessing!public! !
onParameter:renamedTo:accept:!event handling!public! !
onPositionChanged:!event handling!private! !
onSignatureChanged!event handling!private! !
preTranslateKeyboardInput:!dispatching!public! !
queryCommand:!commands!private! !
showChanges!public! !
showValidationResult:!helpers!private! !
validater!accessing!public! !
validater:!accessing!public! !
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 7 nil nil nil 272 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 2 18 #{UI.StaticText} 50 16 nil 272 50 2 8 1140850944 1 400 nil nil nil 7 nil nil nil 400 nil 8 1853387904 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 11 19 210 111 41 400 562 #text: 50 1 8 '&Selector:' 400 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 9 0 0 0 60 0 0 0 29 0 0 0] 8 #() 210 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 11 802 #fixedViewLeft 111 802 #fixedParentTop 19 802 #fixedViewTop 41 18 #{UI.TextEdit} 50 20 nil 272 50 2 8 1140916352 1025 880 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 880 nil 8 1853175488 482 nil nil 1 #perChar nil nil nil 514 50 2 562 #createAt:extent: 50 2 210 141 13 210 567 45 880 562 #setMarginWidths: 50 1 8 #(3 3) 880 690 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 8 #() 752 nil 45 770 802 #fixedPreviousRight 21 802 #fixedParentRight -1 802 #fixedPreviousTop -5 864 45 550 #{Core.IdentityDictionary} 1 880 8 'selector' nil 514 50 1 562 #createAt:extent: 50 2 210 21 17 210 709 81 272 690 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 108 1 0 0 48 0 0 0] 50 2 400 880 752 nil 27 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 1456 nil nil nil 7 nil nil nil 1456 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 514 50 1 562 #createAt:extent: 50 2 210 21 353 210 709 61 1456 690 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 176 0 0 0 108 1 0 0 206 0 0 0] 8 #() 752 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1696 nil nil nil 7 nil nil nil 1696 242 1 1 18 #{UI.Toolbar} 50 28 nil 1696 50 2 8 1140853612 131073 1776 nil nil nil 519 nil nil nil 1776 960 8 1853287488 1266 0 nil nil nil 1266 4 47797 1094 1 #{UI.ToolbarIconButton} 1776 1 1350 4 #{UI.CommandDescription} #moveFirst 8 'Move First' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $⏮ 8 'Georgia' nil 946 #menuHilight nil nil 3 nil nil 47797 47799 1890 1776 1 1922 #moveUp 8 'Move Up' 1 1 1970 8 $▲ 8 'Segoe UI' nil 2032 nil nil 1 nil nil 47799 47801 1890 1776 1 1922 #moveDown 8 'Move Down' 1 1 1970 8 $▼ nil nil 2032 nil nil 1 nil nil 47801 47803 1890 1776 1 1922 #moveLast 8 'Move Last' 1 1 1970 8 $⏭ 8 'Georgia' nil 2032 nil nil 3 nil nil 47803 50 4 1904 2048 2144 2224 nil nil 1 nil 210 33 33 nil nil nil 514 50 1 562 #createAt:extent: 50 2 210 1 1 210 709 51 1776 690 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 8 #() 752 nil 29 nil nil nil 18 #{UI.ListView} 50 45 nil 1696 50 2 8 1140970061 1025 2496 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 960 nil 7 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1922 #moveFirst 8 'Move to &First' 1 1 nil nil nil 2706 1 1922 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 2706 1 1922 #moveDown 8 'Move to &Next' 1 1 nil nil nil 2706 1 1922 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2496 nil 8 1853243664 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 2594 1 3142 5 #{UI.ListViewColumn} 8 '' 701 #left 2960 2946 #<= 8 #() nil nil 2496 nil 3 nil nil #report 8 #() nil 133121 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 514 50 1 562 #createAt:extent: 50 2 210 1 51 210 709 197 2496 690 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 98 1 0 0 123 0 0 0] 8 #() 752 nil 35 1266 1 2496 8 'list' 518 #{Graphics.Rectangle} 210 1 1 210 1 11 514 50 1 562 #createAt:extent: 50 2 210 21 97 210 709 257 1696 690 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 48 0 0 0 108 1 0 0 176 0 0 0] 50 2 1776 2496 752 nil 27 1266 1 1696 8 'parameters' 3314 210 21 17 210 21 21 nil nil nil nil 13379 nil nil nil 210 541 391 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 514 50 2 562 #createAt:extent: 50 2 210 6143 21 210 781 511 32 562 #text: 50 1 8 'New Method Name…' 32 690 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 133 13 0 0 9 1 0 0] 50 3 272 1696 1456 752 nil 27)!

resource_Refactoring_view
	"Answer the literal data from which the 'Refactoring view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Refactoring_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 7 nil nil nil 272 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 2 18 #{UI.StaticText} 50 16 nil 272 50 2 8 1140850944 1 400 nil nil nil 7 nil nil nil 400 nil 8 1853387904 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 11 19 210 111 41 400 562 #text: 50 1 8 '&Selector:' 400 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 9 0 0 0 60 0 0 0 29 0 0 0] 8 #() 210 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 11 802 #fixedViewLeft 111 802 #fixedParentTop 19 802 #fixedViewTop 41 18 #{UI.TextEdit} 50 20 nil 272 50 2 8 1140916352 1025 880 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 880 nil 8 1853175488 482 nil nil 1 #perChar nil nil nil 514 50 2 562 #createAt:extent: 50 2 210 141 13 210 567 45 880 562 #setMarginWidths: 50 1 8 #(3 3) 880 690 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 8 #() 752 nil 45 770 802 #fixedPreviousRight 21 802 #fixedParentRight -1 802 #fixedPreviousTop -5 864 45 550 #{Core.IdentityDictionary} 1 880 8 'selector' nil 514 50 1 562 #createAt:extent: 50 2 210 21 17 210 709 81 272 690 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 108 1 0 0 48 0 0 0] 50 2 400 880 752 nil 27 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 1456 nil nil nil 7 nil nil nil 1456 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_Refactoring_OK_Cancel_button_block nil 514 50 1 562 #createAt:extent: 50 2 210 21 353 210 709 61 1456 690 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 176 0 0 0 108 1 0 0 206 0 0 0] 8 #() 752 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1696 nil nil nil 7 nil nil nil 1696 242 1 1 18 #{UI.Toolbar} 50 28 nil 1696 50 2 8 1140853612 131073 1776 nil nil nil 519 nil nil nil 1776 960 8 1853287488 1266 0 nil nil nil 1266 4 47789 1094 1 #{UI.ToolbarIconButton} 1776 1 1350 4 #{UI.CommandDescription} #moveFirst 8 'Move First' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $⏮ 8 'Georgia' nil 946 #menuHilight nil nil 3 nil nil 47789 47791 1890 1776 1 1922 #moveUp 8 'Move Up' 1 1 1970 8 $▲ 8 'Segoe UI' nil 2032 nil nil 1 nil nil 47791 47793 1890 1776 1 1922 #moveDown 8 'Move Down' 1 1 1970 8 $▼ nil nil 2032 nil nil 1 nil nil 47793 47795 1890 1776 1 1922 #moveLast 8 'Move Last' 1 1 1970 8 $⏭ 8 'Georgia' nil 2032 nil nil 3 nil nil 47795 50 4 1904 2048 2144 2224 nil nil 1 nil 210 33 33 nil nil nil 514 50 1 562 #createAt:extent: 50 2 210 1 1 210 709 51 1776 690 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 8 #() 752 nil 29 nil nil nil 18 #{UI.ListView} 50 45 nil 1696 50 2 8 1140970061 1025 2496 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 960 nil 7 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1922 #moveFirst 8 'Move to &First' 1 1 nil nil nil 2706 1 1922 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 2706 1 1922 #moveDown 8 'Move to &Next' 1 1 nil nil nil 2706 1 1922 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2496 nil 8 1853243664 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 2594 1 3142 5 #{UI.ListViewColumn} 8 '' 701 #left 2960 2946 #<= 8 #() nil nil 2496 nil 3 nil nil #report 8 #() nil 133121 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 514 50 1 562 #createAt:extent: 50 2 210 1 51 210 709 197 2496 690 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 98 1 0 0 123 0 0 0] 8 #() 752 nil 35 1266 1 2496 8 'list' 518 #{Graphics.Rectangle} 210 1 1 210 1 11 514 50 1 562 #createAt:extent: 50 2 210 21 97 210 709 257 1696 690 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 48 0 0 0 108 1 0 0 176 0 0 0] 50 2 1776 2496 752 nil 27 1266 1 1696 8 'parameters' 3314 210 21 17 210 21 21 nil nil nil nil 13359 nil nil nil 210 541 391 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 514 50 2 562 #createAt:extent: 50 2 210 6143 21 210 781 511 32 562 #text: 50 1 8 'New Method Name…' 32 690 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 133 13 0 0 9 1 0 0] 50 3 272 1696 1456 752 nil 27)! !
!Tools.MethodNameDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
resource_Refactoring_view!public!resources-views! !
!

