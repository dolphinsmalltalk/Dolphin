"Filed out from Dolphin Smalltalk"!

UI.Dialog subclass: #'Tools.MethodNameDialog'
	instanceVariableNames: 'selectorPresenter parametersPresenter parameterNamesPresenter hintBubble'
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
	parametersPresenter := self add: SequenceableCollectionPresenter new
				name: 'parameters'.
	parameterNamesPresenter := parametersPresenter presenterNamed: 'list'!

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

hintDwell
	"Private - Answer the <Duration> for which a hint bubble should be shown before fading away."

	^10 seconds!

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

	(aMSG isKeyPress: VK_RETURN) ifTrue: [self validate].
	^super preTranslateKeyboardInput: aMSG!

queryCommand: aCommandQuery
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>."

	aCommandQuery commandSymbol == #ok
		ifTrue: 
			[aCommandQuery isEnabled: self isInputValid.
			^true].
	^super queryCommand: aCommandQuery!

showValidationResult: aValidationResult
	self closeBubble.
	(aValidationResult hint isNil or: [self model selector isEmpty]) ifTrue: [^self].
	hintBubble := MessageBubble new.
	hintBubble
		caption: aValidationResult caption;
		font: self hintFont;
		timeout: self hintDwell;
		position: self hintPosition;
		exceptionDescription: aValidationResult hint;
		isSilent: true;
		open!

validater
	^self model validater!

validater: aMonadicValuable
	self model validater: aMonadicValuable!

validationDwell
	"The <Duration> to wait after the user has stopped typing before re-validating and possibly showing a hint bubble."

	^1 seconds! !
!Tools.MethodNameDialog categoriesForMethods!
allowExistingSelector!public!testing! !
allowParameterRename:!accessing!public! !
allowParameterReordering:!accessing!public! !
closeBubble!helpers!private! !
conditionsFor:!helpers!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
hintDwell!constants!private! !
hintFont!constants!private! !
hintPosition!accessing!private! !
isInputValid!private!testing! !
model:!accessing!public! !
onParameter:renamedTo:accept:!event handling!public! !
onPositionChanged:!event handling!private! !
onSignatureChanged!event handling!private! !
preTranslateKeyboardInput:!dispatching!public! !
queryCommand:!commands!private! !
showValidationResult:!helpers!private! !
validater!accessing!public! !
validater:!accessing!public! !
validationDwell!constants!public! !
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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 167 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1048838 ##(UI.FramingLayout) 170 176 34 4 410 ##(UI.StaticText) 34 16 nil 640 34 2 8 1140850944 1 768 nil nil nil 7 nil nil nil 768 nil 8 1812122528 1049094 ##(UI.NullConverter) nil nil nil 1310982 ##(Core.MessageSequence) 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 11 19 578 111 41 768 930 #text: 34 1 8 '&Selector:' 768 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 9 0 0 0 60 0 0 0 29 0 0 0] 8 #() 578 193 193 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 11 1170 #fixedViewLeft 111 1170 #fixedParentTop 19 1170 #fixedViewTop 41 410 ##(UI.TextEdit) 34 16 nil 640 34 2 8 1140916352 1025 1248 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1248 nil 8 1812078336 850 nil nil 5 882 34 2 930 #createAt:extent: 34 2 578 141 13 578 567 45 1248 930 #setMarginWidths: 34 1 8 #(3 3) 1248 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 8 #() 1120 nil 27 1138 1170 #fixedPreviousRight 21 1170 #fixedParentRight -1 1170 #fixedPreviousTop -5 1232 45 170 192 34 2 1248 8 'selector' nil 882 34 1 930 #createAt:extent: 34 2 578 21 17 578 709 81 640 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 108 1 0 0 48 0 0 0] 34 2 768 1248 1120 nil 27 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1824 nil nil nil 7 nil nil nil 1824 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 882 34 1 930 #createAt:extent: 34 2 578 21 353 578 709 61 1824 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 176 0 0 0 108 1 0 0 206 0 0 0] 8 #() 1120 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2064 nil nil nil 7 nil nil nil 2064 610 1 1 410 ##(UI.Toolbar) 34 28 nil 2064 34 2 8 1140853612 131073 2144 nil nil nil 519 nil nil nil 2144 1328 8 1812060400 170 192 2048 nil nil nil 170 192 34 8 26153 1311814 1 ##(UI.ToolbarIconButton) 2144 1 1377606 4 ##(UI.CommandDescription) #moveFirst 8 'Move First' 1 1 1378630 2 ##(Graphics.TextTileIcon) $\x23EE 8 'Georgia' nil 1314 #menuHilight nil nil 3 nil nil 26153 26159 2274 2144 1 2306 #moveLast 8 'Move Last' 1 1 2354 $\x23ED 8 'Georgia' nil 2400 nil nil 3 nil nil 26159 26157 2274 2144 1 2306 #moveDown 8 'Move Down' 1 1 2354 $\x25BC nil nil 2400 nil nil 1 nil nil 26157 26155 2274 2144 1 2306 #moveUp 8 'Move Up' 1 1 2354 $\x25B2 8 'Segoe UI' nil 2400 nil nil 1 nil nil 26155 34 4 2288 2560 2496 2416 nil nil 1 nil 578 33 33 nil nil nil 882 34 1 930 #createAt:extent: 34 2 578 1 1 578 709 51 2144 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 8 #() 1120 nil 29 nil nil nil 410 ##(UI.ListView) 34 45 nil 2064 34 2 8 1140970061 1025 2816 787270 2 ##(UI.ListModel) 138 144 2048 nil 1769478 ##(Kernel.IdentitySearchPolicy) 1328 nil 7 461638 4 ##(UI.Menu) nil true 34 4 1180742 2 ##(UI.CommandMenuItem) 1 2306 #moveFirst 8 'Move to &First' 1 1 nil nil nil 3010 1 2306 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3010 1 2306 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3010 1 2306 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2816 nil 8 1812034736 ##(UI.BasicListAbstract) nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 '' 701 #left ##(UI.BasicListAbstract) 786950 ##(Core.Message) #<= 8 #() nil nil 2816 nil 3 nil nil #report 8 #() nil 133121 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 34 2 930 #createAt:extent: 34 2 578 1 51 578 709 197 2816 930 #contextMenu: 34 1 2976 2816 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 98 1 0 0 123 0 0 0] 8 #() 1120 nil 35 170 192 34 2 2816 8 'list' 1180166 ##(Graphics.Rectangle) 578 1 1 578 1 11 882 34 1 930 #createAt:extent: 34 2 578 21 97 578 709 257 2064 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 48 0 0 0 108 1 0 0 176 0 0 0] 34 2 2144 2816 1120 nil 27 170 192 34 2 2064 8 'parameters' 3650 578 21 17 578 21 21 nil nil nil nil 13229 nil nil nil 578 541 391 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 1999993616 882 34 2 930 #createAt:extent: 34 2 578 12287 21 578 781 511 416 930 #text: 34 1 8 'New Method Name…' 416 1058 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 133 25 0 0 9 1 0 0] 34 3 640 2064 1824 1120 nil 27 )! !
!Tools.MethodNameDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

