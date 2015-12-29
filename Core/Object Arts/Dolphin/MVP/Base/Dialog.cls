"Filed out from Dolphin Smalltalk X6.2"!

Shell subclass: #Dialog
	instanceVariableNames: 'confirmed ownerView'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Dialog guid: (GUID fromString: '{87B4C69A-026E-11D3-9FD7-00A0CC3E4A32}')!
Dialog comment: 'Dialog is an abstract <dialogPresenter> superclass for allowing model data to be displayed and edited within a top-level modal dialog window. The fact that a Dialog is modal means that any changes made to the displayed data are usually buffered and not written directly back to the model until they are explicitly applied. This happens, usually after clicking an OK button. Hence a user has the opportunity of cancelling out of a Dialog without any changes being made to the underlying model.

When designing a <dialogPresenter> it is necessary to make an initial decision as to how the model data should be edited. If the model is a mutable object, in that it is legal (and sensible) to modify it in place using its aspect accessors, then it is sensible to treat it as a simple <dialogPresenter> and it can be subclassed directly from Dialog itself. If, on the other hand, the model is to be immutable then the dialog should be implemented as a <valueDialogPresenter> and, most likely, be subclassed from the ValueDialog class. The decision made here can often be quite subtle. On the one hand, making changes to a mutable object seems the most direct approach, however, a <valueDialogPresenter> can often be more flexible because it can be connected to anything that supports the <valueModel> protocol. Often the choice comes down to this: If the identity of the underlying model data must remain unchanged then use a standard <dialogPresenter>. If this is not the case then a <valueDialogPresenter> will be more suitable.

From this point let us consider the operation of a standard <dialogPresenter>. When the dialog is created, and given a subject model on which to operate, an <AspectBuffer> is created onto this subject. This is used to buffer the changes to any of the subject''s aspects so that they do not affect the original data directly. It is this <AspectBuffer> that is used as the actual model for the <dialogPresenter>. Interestingly, the use of an <AspectBuffer> imposes an additional factor in the decision to use a standard <dialogPresenter> rather than a <valueDialogPresenter>, this being, that the subject model must be capable of being cloned correctly using #copy. For more details see the comment for AspectBuffer itself.

Instance Variables:
	confirmed		<boolean> indicating whether the dialog has been confirmed and the changes applied.
	ownerView	<topView> which owns the dialog and is suspended waiting for it to complete.

'!
!Dialog categoriesForClass!MVP-Presenters!MVP-Resources-Dialogs! !
!Dialog methodsFor!

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

	^AspectBuffer subject: aSubjectModel.


	!

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
	confirmed := false
!

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
!Dialog categoriesFor: #answer!accessing!public! !
!Dialog categoriesFor: #apply!commands!public! !
!Dialog categoriesFor: #bufferedModelFor:!accessing!private! !
!Dialog categoriesFor: #cancel!commands!public! !
!Dialog categoriesFor: #flushChanges!commands!private! !
!Dialog categoriesFor: #initialize!initializing!private! !
!Dialog categoriesFor: #isConfirmed!public!testing! !
!Dialog categoriesFor: #model:!accessing!public! !
!Dialog categoriesFor: #ok!commands!public! !
!Dialog categoriesFor: #ownerView!accessing!public! !
!Dialog categoriesFor: #ownerView:!accessing!private! !
!Dialog categoriesFor: #revert!commands!public! !
!Dialog categoriesFor: #showModal!public!realizing/unrealizing! !
!Dialog categoriesFor: #showModalView!private!realizing/unrealizing! !
!Dialog categoriesFor: #showShell!operations!public! !
!Dialog categoriesFor: #subject!accessing!public! !

Dialog methodProtocol: #dialogPresenter attributes: #(#readOnly) selectors: #(#apply #cancel #caption #caption: #clearCommandHistory #ensureVisible #hasCommandHistory #hasCommandHistory: #ok #onAboutToDisplayMenu: #onAboutToDisplaySystemMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewClosed #onViewMinimized: #onViewOpened #onViewRestored: #parentPresenter #performAction #redo #revert #setFocus #show #topShell #undo #updateCaption #view)!

!Dialog class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(ColorRef)  8 4278190080 0 133 0 0 0 416 788230 ##(BorderLayout)  1 1 0 410 8 ##(ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 560 0 0 0 5 0 0 0 560 1180166 ##(ResourceIdentifier)  8 ##(Presenter)  8 #resource_OK_Cancel_button_block 0 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  21 437 834 469 71 560 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 218 0 0 0 244 0 0 0 253 0 0 0] 98 0 834 193 193 0 27 0 0 0 234 256 928 590342 ##(Rectangle)  834 21 21 834 21 21 0 0 0 0 12301 0 0 0 0 1 0 0 590598 ##(Semaphore)  0 0 1 0 8 2010572111 706 202 208 98 2 770 800 98 2 834 1341 905 834 521 591 416 770 8 #menuBar: 98 1 0 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 158 2 0 0 196 1 0 0 162 3 0 0 235 2 0 0] 98 1 560 944 0 27 )!

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
!Dialog class categoriesFor: #icon!constants!public! !
!Dialog class categoriesFor: #resource_Default_view!public!resources-views! !
!Dialog class categoriesFor: #showModal!instance creation!public! !
!Dialog class categoriesFor: #showModal:!instance creation!public! !
!Dialog class categoriesFor: #showModal:on:!instance creation!public! !
!Dialog class categoriesFor: #showModalOn:!instance creation!public! !

