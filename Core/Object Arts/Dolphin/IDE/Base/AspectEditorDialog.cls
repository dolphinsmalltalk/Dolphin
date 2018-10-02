"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #AspectEditorDialog
	instanceVariableNames: 'aspectPresenterInDialog hookPresenter subjectModel aspect aspectRectangle'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AspectEditorDialog guid: (GUID fromString: '{760c70e7-2b1b-4e1e-9742-397d87529534}')!
AspectEditorDialog comment: ''!
!AspectEditorDialog categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!AspectEditorDialog methodsFor!

apply
	"Apply our copied model into the original subject model"

	self flushChanges.
	subjectModel value: aspectPresenterInDialog model value.
	^super apply!

applyPreferredExtent
	"Calculate and apply a suitable extent for the receiver based on the preferred extent of the
	aspectPresenterInDialog view. Note that the minium extent that can be allowed is the
	#minExtent for the receivers view and the maximum is given by the *current* extent. The
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
	toobarButtonsView := self view viewNamed: 'toolbarButtons' ifNone: [].
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
!AspectEditorDialog categoriesFor: #apply!commands!public! !
!AspectEditorDialog categoriesFor: #applyPreferredExtent!operations!private! !
!AspectEditorDialog categoriesFor: #arrangeToolbarButtons!operations!private! !
!AspectEditorDialog categoriesFor: #createAspectPresenters:for:!operations!private! !
!AspectEditorDialog categoriesFor: #createComponents!operations!private! !
!AspectEditorDialog categoriesFor: #isDismissedOnDeactivate!constants!operations!private! !
!AspectEditorDialog categoriesFor: #isSingleLine!private! !
!AspectEditorDialog categoriesFor: #isSingleLineValueWorkspace!private! !
!AspectEditorDialog categoriesFor: #ok!commands!public! !
!AspectEditorDialog categoriesFor: #onViewNcDeactivated:!event handling!private! !
!AspectEditorDialog categoriesFor: #recommendedRectangle:!accessing!public! !
!AspectEditorDialog categoriesFor: #removeBordersFromAspectPresenter!operations!private! !

!AspectEditorDialog class methodsFor!

defaultAdditionalAccelerators
	^#(#(#ok 'Ctrl+S')).
!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(262144 134283264) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1409289036 131073 528 nil nil nil 517 nil nil nil 528 nil 8 1915204752 170 192 34 2 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1409289036 131137 640 nil nil nil 517 nil nil nil 640 nil 8 1915204752 170 192 8 #() 170 192 34 4 42311 1115206 1 ##(Smalltalk.ToolbarIconButton) 640 1 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 'Ok' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2714 8 'Segoe UI Emoji' nil 262406 ##(Smalltalk.ARGB) 8 4278222848 nil nil 1 nil nil 42311 42313 786 640 1 818 #cancel 8 'Cancel' 1 1 866 $\x2716 nil nil 914 8 4294901760 nil nil 1 nil nil 42313 34 2 800 960 nil nil 1 nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 349 1 1186 93 51 640 1138 #updateSizePosted 736 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 0 0 0 0 220 0 0 0 25 0 0 0] 8 #() 1186 193 193 nil 27 8 'okButton' 170 192 736 138 144 736 nil nil 1 nil nil nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 13 1074 138 144 34 2 1138 #createAt:extent: 34 2 1186 1 557 1186 441 51 528 1138 #updateSizePosted 736 528 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 22 1 0 0 220 0 0 0 47 1 0 0] 34 1 640 1312 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1584 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 1584 498 1 1 nil nil nil nil nil 170 192 736 nil 1074 138 144 34 1 1138 #createAt:extent: 34 2 1186 1 1 1186 441 557 1584 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 220 0 0 0 22 1 0 0] 8 #() 1312 nil 27 170 192 34 4 1584 8 'hook' 528 8 'toolbarButtons' nil nil nil nil nil 9745 nil nil 1186 1281 961 1186 401 201 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 2011052416 1074 138 144 34 3 1138 #createAt:extent: 34 2 1186 157 157 1186 469 635 416 1138 #text: 34 1 8 'Edit' 416 1138 #updateMenuBar 736 416 1250 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 78 0 0 0 78 0 0 0 56 1 0 0 139 1 0 0] 34 4 1584 528 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140989952 1 2256 nil nil nil 5 nil nil nil 2256 nil 8 1915188384 818 #ok 8 'OK' 1 1 nil nil true nil nil nil 1074 138 144 34 3 1138 #createAt:extent: 34 2 1186 9 -79 1186 151 47 2256 1138 #isEnabled: 8 #(false) 2256 1138 #text: 34 1 8 'OK' 2256 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 216 255 255 255 79 0 0 0 239 255 255 255] 8 #() 1312 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140858880 1 2608 nil nil nil 5 nil nil nil 2608 nil 8 1915188384 818 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1074 138 144 34 2 1138 #createAt:extent: 34 2 1186 329 -79 1186 151 47 2608 1138 #text: 34 1 8 'Cancel' 2608 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 216 255 255 255 239 0 0 0 239 255 255 255] 8 #() 1312 nil 29 1312 nil 27 )! !
!AspectEditorDialog class categoriesFor: #defaultAdditionalAccelerators!public! !
!AspectEditorDialog class categoriesFor: #resource_Default_view!public!resources-views! !

