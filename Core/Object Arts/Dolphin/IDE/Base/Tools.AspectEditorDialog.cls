"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'Tools.AspectEditorDialog'
	instanceVariableNames: 'aspectPresenterInDialog hookPresenter subjectModel aspect aspectRectangle'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.AspectEditorDialog guid: (Core.GUID fromString: '{760c70e7-2b1b-4e1e-9742-397d87529534}')!

Tools.AspectEditorDialog comment: ''!

!Tools.AspectEditorDialog categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !

!Tools.AspectEditorDialog methodsFor!

apply
	"Apply our copied model into the original subject model"

	self flushChanges.
	subjectModel value: aspectPresenterInDialog model value.
	^super apply!

applyPreferredExtent
	"Calculate and apply a suitable extent for the receiver based on the preferred extent of the
	aspectPresenterInDialog view. Note that the minium extent that can be allowed is the
	#minExtent for the receiver's view and the maximum is given by the *current* extent. The
	absolute maximum extent to which the receiver can later be resized by the user is given by
	the #maxExtent."

	| preferredClientExtent actualExtentToUse screenRectangle inset insets aspectView |
	aspectView := aspectPresenterInDialog view.
	preferredClientExtent := aspectView calculateExtent.
	self isSingleLineValueWorkspace
		ifTrue: 
			["Scintilla views always answer one line too many so, so deduct the height of a line."
			preferredClientExtent y: preferredClientExtent y - (aspectView lineHeight: 1)].
	preferredClientExtent x: (preferredClientExtent x max: aspectRectangle width).

	"Inset our aspect presenter a little"
	inset := 2 * self view dpi // USER_DEFAULT_SCREEN_DPI.
	insets := inset @ 0 corner: inset @ inset.
	hookPresenter view insets: insets.

	"Now ask for the ideal extent and map to the desktop"
	actualExtentToUse := self view extent
				min: preferredClientExtent + insets topLeft + insets bottomRight.
	screenRectangle := self view
				calcRectangleFromClientRectangle: (aspectRectangle topLeft extent: actualExtentToUse).

	"Finally, just check that our rectangle doesn't go off the screen"
	screenRectangle := screenRectangle intersect: OS.SystemMetrics current virtualScreenRectangle.
	self view rectangle: screenRectangle.

	"Once we're done we can decide where to position the buttons"
	self arrangeToolbarButtons.
	self view ensureLayoutValid.
	"Looks nicer without borders in small dialogs"
	self isSingleLine ifTrue: [self removeBordersFromAspectPresenter]!

arrangeToolbarButtons
	"For single line views we arrange the toolbar buttons at #east. Otherwise at #south"

	| toobarButtonsView |
	toobarButtonsView := self view viewNamed: 'toolbarButtons' ifNone: nil.
	toobarButtonsView notNil
		ifTrue: [toobarButtonsView arrangement: (self isSingleLine ifTrue: [#east] ifFalse: [#south])]!

createAspectPresenters: anAspectAccessor for: aspectValueModel
	"Tidy up our views"

	| copyModel |
	aspect := anAspectAccessor aspectDescriptor.
	aspectPresenterInDialog := aspect editablePresenterFor: aspectValueModel in: hookPresenter.

	"To avoid visual shock make sure our aspect presenter's font is the same as that of the
	receiver (and therefore of the dialog's parent too)."
	aspectPresenterInDialog view font: self view font.
	self view backcolor: aspectPresenterInDialog view backcolor.

	"We don't use the standard dialog mode buffering scheme. Instead we take a copy of the model
	contents that have been handed to us in the aspectPresenter and we reinstall these as the
	model being edited. The original model is saved as our subjectModel. This way, when we
	come to apply the changes in the receiver we can take the contents of the copy and set them
	back into the original model. See #apply."
	subjectModel := aspectPresenterInDialog model comparisonPolicy: SearchPolicy equality.
	copyModel := subjectModel value copy asValue.
	aspectPresenterInDialog model: copyModel.
	aspectPresenterInDialog
		when: #actionPerformed
		send: #ok
		to: self.
	self isSingleLineValueWorkspace ifTrue: [aspectPresenterInDialog beSingleLineMode].

	"Set our rectangle to the appropriate size and position"
	self applyPreferredExtent.
	aspectPresenterInDialog view
		arrangement: #center;
		setFocus!

createComponents
	super createComponents.
	hookPresenter := self add: Presenter new name: 'hook'!

isDismissedOnDeactivate
	"Private - Answer true if the receiver should auto-dismiss when it loses activation."

	"WARNING: Don't enable this or the dialog will be dismissed if it in turn launches another dialog (or shell)"

	^false!

isSingleLine
	"Private - Answer true if the receiver is editing a single line, false otherwise"

	"Actually, this is rather difficult to ascertain for sure, so we make a guess"

	^aspect isMultilineValue not
		and: [aspectPresenterInDialog view height < (self view actualFont pixelSize * 4)]!

isSingleLineValueWorkspace
	^aspect isEditedWithValueWorkspace and: [aspect isMultilineValue not]!

ok
	"The dialog has been okayed. Apply and/or accept the changes. The superclass implementation
	just applies the dialog copy model and closes. However, in the special case where we have a
	ValueWorkspace (Aspect class>>defaultPresenterBlock) installed we need to accept the
	workspace value first and then apply and close."

	<acceleratorKey: 'Ctrl+S'>
	aspect isEditedWithValueWorkspace ifTrue: [aspectPresenterInDialog accept ifFalse: [^self]].
	^super ok!

onViewNcDeactivated: anEvent 
	"Private - Default handler for frame de-activation"

	(self isOpen and: [self isDismissedOnDeactivate]) ifTrue: [[self cancel] postToInputQueue].
	^nil!

recommendedRectangle: aRectangle 
	aspectRectangle := aRectangle asRectangle.

!

removeBordersFromAspectPresenter
	(aspectPresenterInDialog view)
		hasBorder: false;
		hasClientEdge: false;
		hasStaticEdge: false! !

!Tools.AspectEditorDialog categoriesForMethods!
apply!commands!public! !
applyPreferredExtent!operations!private! !
arrangeToolbarButtons!operations!private! !
createAspectPresenters:for:!operations!private! !
createComponents!operations!private! !
isDismissedOnDeactivate!constants!operations!private! !
isSingleLine!private! !
isSingleLineValueWorkspace!private! !
ok!commands!public! !
onViewNcDeactivated:!event handling!private! !
recommendedRectangle:!accessing!public! !
removeBordersFromAspectPresenter!operations!private! !
!

!Tools.AspectEditorDialog class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(262144 134283264) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1409289036 131073 160 nil nil nil 517 nil nil nil 160 nil nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 18 #{UI.Toolbar} 50 28 nil 160 50 2 8 1409289036 131137 272 nil nil nil 517 nil nil nil 272 nil nil 226 #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 2 1094 1 #{UI.ToolbarIconButton} 272 1 1350 4 #{UI.CommandDescription} #ok 8 'Ok' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $✔ 8 'Segoe UI Emoji' nil 6 #{Graphics.Color} #commonGreen nil nil 1 nil nil nil 386 272 1 418 #cancel 8 'Cancel' 1 1 466 8 $✖ nil nil 530 #red nil nil 1 nil nil nil nil nil 1 nil nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 349 1 754 93 51 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 0 0 0 0 220 0 0 0 25 0 0 0] 8 #() 754 193 193 nil 29 8 'okButton' nil nil nil nil 550 #{Core.OrderedCollection} 0 nil nil 1 nil nil nil nil 838 1 #{UI.FlowLayout} 1 1 13 658 50 1 706 #createAt:extent: 50 2 754 1 557 754 441 51 160 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 22 1 0 0 220 0 0 0 47 1 0 0] 50 1 272 864 nil 29 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1104 nil 530 #default nil 5 nil nil nil 1104 130 1 1 nil nil nil nil nil 550 #{Core.IdentityDictionary} 0 nil 658 50 1 706 #createAt:extent: 50 2 754 1 1 754 441 557 1104 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 220 0 0 0 22 1 0 0] 8 #() 864 nil 27 226 1200 50 4 1104 8 'hook' 160 8 'toolbarButtons' nil nil nil nil nil 1 nil nil 754 1281 961 754 401 201 1 nil nil 774 #{Core.Semaphore} nil nil 1 false nil 658 50 2 706 #createAt:extent: 50 2 754 6143 21 754 469 635 32 706 #text: 50 1 8 'Edit' 32 802 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 233 12 0 0 71 1 0 0] 50 4 1104 160 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140989952 1 1696 nil nil nil 5 nil nil nil 1696 nil nil 418 #ok 8 'OK' 1 1 nil nil true nil nil nil 658 50 3 706 #createAt:extent: 50 2 754 9 -79 754 151 47 1696 706 #isEnabled: 8 #(false) 1696 706 #text: 50 1 8 'OK' 1696 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 216 255 255 255 79 0 0 0 239 255 255 255] 8 #() 864 nil 29 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140858880 1 2016 nil nil nil 5 nil nil nil 2016 nil nil 418 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 658 50 2 706 #createAt:extent: 50 2 754 329 -79 754 151 47 2016 706 #text: 50 1 8 'Cancel' 2016 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 216 255 255 255 239 0 0 0 239 255 255 255] 8 #() 864 nil 29 864 nil 27)! !

!Tools.AspectEditorDialog class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

