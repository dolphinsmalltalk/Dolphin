"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'UI.ValueDialog'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ValueDialog guid: (Core.GUID fromString: '{87b4c6a5-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ValueDialog comment: 'ValueDialog is an abstract <valueDialogPresenter> superclass for allowing <valueModel> data to be displayed and edited within a top-level modal dialog window.  When deciding whether to implement a dialog as a plain <dialogPresenter> or as a <valueDialogPresenter> there are a number of considerations to take into account. These are discussed in the comment for the Dialog class.

For the most part a <valueDialogPresenter> operates in much the same way as any <dialogPresenter>. However, its subject will always be a <valueModel>, although the value that this refers to will obviously be different for each dialog. When the dialog is created, the actual model that is installed is a <ValueBuffer> onto the subject. This is a type of <valueHolder> that is used to buffer any changes to the subject''s value so that they will not be written back to the original model until an explicit #apply request is made.
'!
!UI.ValueDialog categoriesForClass!MVP-Presenters! !
!UI.ValueDialog methodsFor!

answer
	"Answer the model if the receiver was confirmed (with #apply, #okay) 
	or nil otherwise. Dereference the value from the model since this will
	be most useful"

	^self isConfirmed
		ifTrue: [ self model value ]
		ifFalse: [ nil ]!

bufferClass
	^ValueBuffer!

bufferedModelFor: aSubjectValueModel
	"Private - Answers a buffer suitable for the receiver on aSubjectValueModel. This will become the
	actual model to which the receiver is bound."

	^(self bufferClass subject: aSubjectValueModel asValue) comparisonPolicy: SearchPolicy equality!

isInputValid
	^self model isValid!

model: aValueModel
	"Set the model of the receiver to be aValueModel. Register with it's #valueChanged
	event"

	super model: aValueModel.
	aValueModel when: #valueChanged send: #onValueChanged to: self!

onValueChanged
	"The value held by the receiver's model has changed.
	The default is to trigger a #valueChanged event off the receiver"

	self trigger: #valueChanged!

value
	"Answer the model value of the receiver"

	^self model value!

value: anObject
	"Set the model value of the receiver to be anObject. The change
	will not be flushed back to the original subject model until #apply
	is received"

	self model value: anObject.! !
!UI.ValueDialog categoriesForMethods!
answer!accessing!public! !
bufferClass!accessing!private! !
bufferedModelFor:!helpers!private! !
isInputValid!public!testing! !
model:!accessing!public! !
onValueChanged!event handling!public! !
value!accessing!public! !
value:!accessing!public! !
!

UI.ValueDialog methodProtocol: #value attributes: #(#readOnly) selectors: #(#value #value:)!
UI.ValueDialog methodProtocol: #valueDialogPresenter attributes: #(#readOnly) selectors: #(#apply #cancel #caption #caption: #clearCommandHistory #ensureVisible #hasCommandHistory #ok #onAboutToDisplayMenu: #onAboutToDisplaySystemMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewClosed #onViewMinimized: #onViewOpened #onViewRestored: #parentPresenter #performAction #revert #setFocus #show #topShell #updateCaption #value #value: #view)!
UI.ValueDialog methodProtocol: #valuePresenter attributes: #(#readOnly) selectors: #(#value #value:)!

!UI.ValueDialog class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^nil asValue
!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !
!UI.ValueDialog class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
!

