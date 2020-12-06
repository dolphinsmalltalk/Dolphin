"Filed out from Dolphin Smalltalk 7"!

UI.Shell subclass: #'UI.Dialog'
	instanceVariableNames: 'confirmed ownerView'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
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

flushChanges
	"Private - First ensure that any changes cached in the view with focus (if any) are flushed"

	| focus |
	focus := View focus.
	focus isNil ifFalse: [focus updateModel]!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self ownerView: View active.
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

	self apply.
	self view close.
!

ownerView
	"Answer the view that is parent/owner of the receiver"

	^ownerView
!

ownerView: aView
	"Private - Set the view that is parent/owner of the receiver"

	ownerView := aView.
!

revert
	"Revert the changes cached in the receiver and go back to the data in the original subject."

	self model revert
!

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
	
	^self model subject! !
!UI.Dialog categoriesFor: #answer!accessing!public! !
!UI.Dialog categoriesFor: #apply!commands!public! !
!UI.Dialog categoriesFor: #bufferedModelFor:!accessing!private! !
!UI.Dialog categoriesFor: #cancel!commands!public! !
!UI.Dialog categoriesFor: #flushChanges!commands!private! !
!UI.Dialog categoriesFor: #initialize!initializing!private! !
!UI.Dialog categoriesFor: #isConfirmed!public!testing! !
!UI.Dialog categoriesFor: #model:!accessing!public! !
!UI.Dialog categoriesFor: #ok!commands!public! !
!UI.Dialog categoriesFor: #ownerView!accessing!public! !
!UI.Dialog categoriesFor: #ownerView:!accessing!not an aspect!private! !
!UI.Dialog categoriesFor: #revert!commands!public! !
!UI.Dialog categoriesFor: #showModal!public!realizing/unrealizing! !
!UI.Dialog categoriesFor: #showModalView!private!realizing/unrealizing! !
!UI.Dialog categoriesFor: #showShell!operations!public! !
!UI.Dialog categoriesFor: #subject!accessing!public! !

UI.Dialog methodProtocol: #dialogPresenter attributes: #(#readOnly) selectors: #(#apply #cancel #caption #caption: #clearCommandHistory #ensureVisible #hasCommandHistory #hasCommandHistory: #ok #onAboutToDisplayMenu: #onAboutToDisplaySystemMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewClosed #onViewMinimized: #onViewOpened #onViewRestored: #parentPresenter #performAction #redo #revert #setFocus #show #topShell #undo #updateCaption #view)!

!UI.Dialog class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 165 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 21 423 738 449 71 528 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 211 0 0 0 234 0 0 0 246 0 0 0] 8 #() 738 193 193 nil 27 nil nil nil 170 192 832 1180166 ##(Graphics.Rectangle) 738 21 21 738 21 21 nil nil nil nil 27845 nil nil nil nil 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2005493520 626 138 144 34 1 690 #createAt:extent: 34 2 738 6143 21 738 521 591 416 786 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 3 13 0 0 49 1 0 0] 34 1 528 848 nil 27)!

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
!UI.Dialog class categoriesFor: #icon!constants!public! !
!UI.Dialog class categoriesFor: #resource_Default_view!public!resources-views! !
!UI.Dialog class categoriesFor: #showModal!instance creation!public! !
!UI.Dialog class categoriesFor: #showModal:!instance creation!public! !
!UI.Dialog class categoriesFor: #showModal:on:!instance creation!public! !
!UI.Dialog class categoriesFor: #showModalOn:!instance creation!public! !

