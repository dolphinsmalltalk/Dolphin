"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'UI.Dialog'
	instanceVariableNames: 'confirmed ownerView validationResultPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'ValidationTimerId' -> 16r101 }!

UI.Dialog guid: (Core.GUID fromString: '{87b4c69a-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.Dialog isNonInstantiable: true!

UI.Dialog comment: 'Dialog is an abstract <dialogPresenter> superclass for allowing model data to be displayed and edited within a top-level modal dialog window. The fact that a Dialog is modal means that any changes made to the displayed data are usually buffered and not written directly back to the model until they are explicitly applied. This happens, usually after clicking an OK button. Hence a user has the opportunity of cancelling out of a Dialog without any changes being made to the underlying model.

When designing a <dialogPresenter> it is necessary to make an initial decision as to how the model data should be edited. If the model is a mutable object, in that it is legal (and sensible) to modify it in place using its aspect accessors, then it is sensible to treat it as a simple <dialogPresenter> and it can be subclassed directly from Dialog itself. If, on the other hand, the model is to be immutable then the dialog should be implemented as a <valueDialogPresenter> and, most likely, be subclassed from the ValueDialog class. The decision made here can often be quite subtle. On the one hand, making changes to a mutable object seems the most direct approach, however, a <valueDialogPresenter> can often be more flexible because it can be connected to anything that supports the <valueModel> protocol. Often the choice comes down to this: If the identity of the underlying model data must remain unchanged then use a standard <dialogPresenter>. If this is not the case then a <valueDialogPresenter> will be more suitable.

From this point let us consider the operation of a standard <dialogPresenter>. When the dialog is created, and given a subject model on which to operate, an <AspectBuffer> is created onto this subject. This is used to buffer the changes to any of the subject''s aspects so that they do not affect the original data directly. It is this <AspectBuffer> that is used as the actual model for the <dialogPresenter>. Interestingly, the use of an <AspectBuffer> imposes an additional factor in the decision to use a standard <dialogPresenter> rather than a <valueDialogPresenter>, this being, that the subject model must be capable of being cloned correctly using #copy. For more details see the comment for AspectBuffer itself.

Instance Variables:
	confirmed		<boolean> indicating whether the dialog has been confirmed and the changes applied.
	ownerView	<topView> which owns the dialog and is suspended waiting for it to complete.

'!

!UI.Dialog categoriesForClass!MVP-Presenters!MVP-Resources-Dialogs! !

!UI.Dialog methodsFor!

answer
	"Answer the model if the receiver was confirmed (with #apply, #ok) or nil otherwise"

	^self isConfirmed
		ifTrue: [ self model subject ]
		ifFalse: [ nil ]!

apply
	"Apply the changes cached in the receiver back to the original model. This can be used to
	dynamically see the effect of the changes without closing the dialog. More often
	it is sent by the #ok method just before closing the associated view."

	"First ensure that any changes cached in the view with focus (if any) are flushed"

	self flushChanges.
	self model apply.
	confirmed := true!

bufferedModelFor: aSubjectModel
	"Private - Answers a buffer suitable for the receiver on aSubjectModel. This will become the
	actual model to which the receiver is bound. May be overridden by subclasses that
	wish to use a different buffering scheme."

	^AspectBuffer subject: aSubjectModel!

cancel
	"Close the receiver without applying the changes back to the original model"

	self view close.
!

clearValidationResult
	validationResultPresenter value: nil!

createComponents
	super createComponents.
	validationResultPresenter := self add: self validationResultPresenterClass new
				name: 'validationResult'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self
		when: #timerTick:
		send: #onTimerTick:
		to: self!

deferredValidate
	self clearValidationResult.
	self view setTimer: ValidationTimerId interval: self validationDwell!

flushChanges
	"Private - First ensure that any changes cached in the view with focus (if any) are flushed"

	| focus |
	focus := View focus.
	focus isNil ifFalse: [focus updateModel]!

hintDwell
	"Answer the <Duration> for which a hint bubble should be shown before fading away."

	^validationResultPresenter dwell!

hintDwell: aDuration
	validationResultPresenter dwell: aDuration!

hintFont
	"Answer the `Font` to be used for the main text of any hint bubble. This does not affect the headline text, the font of which is not configurable."

	^validationResultPresenter hintFont!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self ownerView: View activeOrDesktop.
	confirmed := false!

isConfirmed
	"Answer true if the receiver has been confirmed and changes have been applied
	to the associated model. Can be sent after the dialog view has closed
	to determine (usually) if the Ok button was pressed."

	^confirmed!

model: aSubjectModel 
	"Set the model of the receiver to be a buffer onto aSubjectModel."

	| actualModel |
	actualModel := aSubjectModel notNil ifTrue: [self bufferedModelFor: aSubjectModel].
	super model: actualModel!

ok
	"Close the receiver and apply the changes cached in the receiver back to the model"

	<commandQuery: #queryOk:>
	self apply.
	self view close!

onTimerTick: anInteger
	anInteger == ValidationTimerId ifTrue: [self validate]!

ownerView
	"Answer the view that is parent/owner of the receiver"

	^ownerView
!

ownerView: aView
	"Private - Set the view that is parent/owner of the receiver"

	ownerView := aView.
!

preTranslateKeyboardInput: aMSG
	"Answer whether the receiver would like to consume the argument aMSG, which is a keyboard message."

	(aMSG isKeyPress: VK_RETURN)
		ifTrue: 
			[| button |
			"If the default button is disabled, it may be helpful to show validation errors"
			button := self view defaultButton.
			(button notNil and: [button isEnabled not]) ifTrue: [self validate]].
	^super preTranslateKeyboardInput: aMSG!

queryOk: aCommandQuery
	"Private - Subclasses should override to perform any necessary validation and selectively enable the Ok button as required."

	aCommandQuery validationResult: self validateModel!

revert
	"Revert the changes cached in the receiver and go back to the data in the original subject."

	self model revert
!

show
	"Shows the view of the receiver"

	self view showModeless: ownerView!

showModal
	"Show the receiver's view as a modal dialog.
	Answer the model if the receiver was confirmed (with #apply, #okay) or nil otherwise"

	self showModalView.
	^self answer!

showModalView
	self view showModalTo: ownerView!

showShell
	"Show the receiver a modeless dialog"

	self show!

subject
	"Answer the original model onto which the receiver was created"
	
	^self model subject!

validate
	| result |
	self view killTimer: ValidationTimerId.
	result := self validateModel.
	self validationResult: result.
	^result!

validateModel
	^self model validate!

validater
	^self model validater!

validater: aMonadicValuable
	"Set the <monadicValuable> used to validate the model. The valuable is passed the current (buffered) model value as its first argument, and is expected to answer a <ValuationResult>, the value of which indicates whether the model should be considered valid in context. The OK button is not enabled until the ValidationResult's value is true. The validator can also pass out a hint details to be displayed in the receiver's <ValidationResultPresenter> if desired (see ValidationResult for the options available). The hint is useful, for example, to explain to the user why the OK button is disabled, as this can otherwise be difficult to understand."

	self model validater: aMonadicValuable!

validationBlock: aBlock
	"Set the <monadicValuable> used to validate the user's reply. The valuable is passed the current reply text as its argument first argument and should answer true/false indicating whether the text is valid or not.
	This method is present mainly for backwards compatibility."

	"Although not deprecated because the old-style true/false result is adequate for many purposes, the alternative of providing a block that returns a full <ValidationResult> (see #validater:) is preferred."

	self validater: [:response | ValidationResult value: (aBlock value: response)]!

validationDwell
	"The <Duration> to wait after the user has stopped typing before re-validating and possibly showing a validation hint."

	^1 seconds!

validationResult: aValidationResult
	validationResultPresenter value: aValidationResult!

validationResultPresenterClass
	^ValidationStatusPresenter! !

!UI.Dialog categoriesForMethods!
answer!accessing!public! !
apply!commands-actions!public! !
bufferedModelFor:!accessing!private! !
cancel!commands-actions!public! !
clearValidationResult!operations!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
deferredValidate!operations!public! !
flushChanges!commands-actions!private! !
hintDwell!constants!public! !
hintDwell:!accessing!public! !
hintFont!constants!public! !
initialize!initializing!private! !
isConfirmed!public!testing! !
model:!accessing!public! !
ok!commands-actions!public! !
onTimerTick:!event handling!private! !
ownerView!accessing!public! !
ownerView:!accessing!not an aspect!private! !
preTranslateKeyboardInput:!dispatching!public! !
queryOk:!commands-queries!private! !
revert!commands-actions!public! !
show!operations!public! !
showModal!public!realizing/unrealizing! !
showModalView!private!realizing/unrealizing! !
showShell!operations!public! !
subject!accessing!public! !
validate!operations!public! !
validateModel!helpers!private! !
validater!accessing!public! !
validater:!initializing!public! !
validationBlock:!initializing!public! !
validationDwell!constants!public! !
validationResult:!accessing!public! !
validationResultPresenterClass!constants!public! !
!

UI.Dialog methodProtocol: #dialogPresenter attributes: #(#readOnly) selectors: #(#apply #cancel #caption #caption: #clearCommandHistory #ensureVisible #hasCommandHistory #ok #onAboutToDisplayMenu: #onAboutToDisplaySystemMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewClosed #onViewMinimized: #onViewOpened #onViewRestored: #parentPresenter #performAction #revert #setFocus #show #topShell #updateCaption #view)!

!UI.Dialog class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13107200 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 160 nil nil nil 5 nil nil nil 160 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 21 423 354 449 71 160 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 211 0 0 0 234 0 0 0 246 0 0 0] 8 #() 354 193 193 nil 27 nil nil nil 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 354 21 21 354 21 21 nil nil nil nil 1 nil nil nil nil 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 258 50 1 306 #createAt:extent: 50 2 354 6143 21 354 521 591 32 402 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 3 13 0 0 49 1 0 0] 50 1 160 464 nil 27)!

showModal
	"Creates a default instance of the receiver with a default view	and displays it modal 
	to the current active window. 
	Answers the result of the dialog if confirmed or nil otherwise"

	^self create showModal!

showModal: aDialogResourceNameString
	"Creates an instance of the receiver with a view identified by aResourceNameString
	and displays it modal to the current	active window. 
	Answers the result of dialog if confirmed or nil otherwise"

	^(self create: aDialogResourceNameString) showModal!

showModal: aDialogResourceNameString on: aModel
	"Creates an instance of the receiver with a view identified by aResourceNameString
	and connected to aModel. The view is displayed modal to the current active window. 
	Answers the result of dialog if confirmed or nil otherwise"

	^(self create: aDialogResourceNameString on: aModel) showModal!

showModalOn: aModel
	"Creates an instance of the receiver with a default view and connected to aModel. 
	The view is displayed modal to the current active window. 
	Answers the result of dialog if confirmed or nil otherwise"

	^(self createOn: aModel) showModal! !

!UI.Dialog class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
showModal!instance creation!public! !
showModal:!instance creation!public! !
showModal:on:!instance creation!public! !
showModalOn:!instance creation!public! !
!

