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

	| maxExtentToUse preferredClientExtent actualExtentToUse screenRectangle insets aspectView |
	maxExtentToUse := self view extent.
	aspectView := aspectPresenterInDialog view.
	preferredClientExtent := aspectView calculateExtent.
	self isSingleLineValueWorkspace
		ifTrue: 
			["Scintilla views always answer one line too many so, so deduct the height of a line."
			preferredClientExtent y: preferredClientExtent y - (aspectView lineHeight: 1)].
	preferredClientExtent x: (preferredClientExtent x max: aspectRectangle width).

	"Workout if we need to inset our aspect presenter"
	insets := 2 @ 0 corner: 2 @ 2.
	hookPresenter view insets: insets.

	"Now ask for the ideal extent and map to the desktop"
	actualExtentToUse := maxExtentToUse min: preferredClientExtent + insets topLeft + insets bottomRight.
	screenRectangle := self view
				calcRectangleFromClientRectangle: (aspectRectangle topLeft extent: actualExtentToUse).

	"Finally, just check that our rectangle doesn't go off the screen"
	screenRectangle := screenRectangle intersect: View desktop rectangle.
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(262144 134283264) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1409289036 131073 528 nil nil nil 519 nil nil nil 528 nil 8 1815075056 170 192 34 2 410 #{UI.Toolbar} 34 28 nil 528 34 2 8 1409289036 131137 640 nil nil nil 519 nil nil nil 640 nil 8 1815075056 170 192 8 #() nil nil nil 170 192 34 4 59351 1311814 1 #{UI.ToolbarIconButton} 640 1 1377606 4 #{UI.CommandDescription} #ok 8 'Ok' 1 1 1378630 2 #{Graphics.TextTileIcon} $\x2714 8 'Segoe UI Emoji' nil 917510 #{Graphics.Color} #commonGreen nil nil 1 nil nil 59351 59353 786 640 1 818 #cancel 8 'Cancel' 1 1 866 $\x2716 nil nil 914 #red nil nil 1 nil nil 59353 34 2 800 944 nil nil 1 nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 349 1 1138 93 51 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 0 0 0 0 220 0 0 0 25 0 0 0] 8 #() 1138 193 193 nil 29 8 'okButton' nil nil nil 170 192 736 138 144 736 nil nil 1 nil nil nil nil 852806 1 #{UI.FlowLayout} 1 1 13 1042 34 1 1090 #createAt:extent: 34 2 1138 1 557 1138 441 51 528 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 22 1 0 0 220 0 0 0 47 1 0 0] 34 1 640 1248 nil 29 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 1488 nil 914 #default nil 7 nil nil nil 1488 498 1 1 nil nil nil nil nil 170 192 736 nil 1042 34 1 1090 #createAt:extent: 34 2 1138 1 1 1138 441 557 1488 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 220 0 0 0 22 1 0 0] 8 #() 1248 nil 27 170 192 34 4 1488 8 'hook' 528 8 'toolbarButtons' nil nil nil nil nil 59723 nil nil 1138 1281 961 1138 401 201 1 nil nil 918278 #{Core.Semaphore} nil nil 1 false 8 2004646672 1042 34 2 1090 #createAt:extent: 34 2 1138 12287 21 1138 469 635 416 1090 #text: 34 1 8 'Edit' 416 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 233 24 0 0 71 1 0 0] 34 4 1488 528 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140989952 1 2080 nil nil nil 7 nil nil nil 2080 nil 8 1815097472 818 #ok 8 'OK' 1 1 nil nil true nil nil nil 1042 34 3 1090 #createAt:extent: 34 2 1138 9 -79 1138 151 47 2080 1090 #isEnabled: 8 #(false) 2080 1090 #text: 34 1 8 'OK' 2080 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 216 255 255 255 79 0 0 0 239 255 255 255] 8 #() 1248 nil 29 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140858880 1 2416 nil nil nil 7 nil nil nil 2416 nil 8 1815097472 818 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1042 34 2 1090 #createAt:extent: 34 2 1138 329 -79 1138 151 47 2416 1090 #text: 34 1 8 'Cancel' 2416 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 216 255 255 255 239 0 0 0 239 255 255 255] 8 #() 1248 nil 29 1248 nil 27)! !
!Tools.AspectEditorDialog class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

