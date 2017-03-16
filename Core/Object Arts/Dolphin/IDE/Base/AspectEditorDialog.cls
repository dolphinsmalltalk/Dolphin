"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #AspectEditorDialog
	instanceVariableNames: 'aspectPresenterInDialog hookPresenter subjectModel isValueWorkspacePresenter aspectRectangle'
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

	| maxExtentToUse preferredClientExtent actualExtentToUse screenRectangle insets |
	maxExtentToUse := self view extent.
	preferredClientExtent := isValueWorkspacePresenter 
				ifTrue: 
					["Scintilla views always answer one line too many so we just use the font height plus a fudge factor to stop the text disappearing"
					aspectPresenterInDialog view width @ (aspectPresenterInDialog view actualFont pixelSize+6)]
				ifFalse: 
					["All others we can ask"
					aspectPresenterInDialog view calculateExtent].
	preferredClientExtent x: (preferredClientExtent x max: aspectRectangle width).

	"Workout if we need to inset our aspect presenter"
	insets := 2 @ 2 corner: 2 @ 2.
	hookPresenter view insets: insets.

	"Now ask for the ideal extent and map to the desktop"
	actualExtentToUse := maxExtentToUse 
				min: preferredClientExtent + insets topLeft + insets bottomRight.
	screenRectangle := self view 
				calcRectangleFromClientRectangle: (aspectRectangle topLeft extent: actualExtentToUse).

	"Finally, just check that our rectangle doesn't go off the screen"
	screenRectangle := screenRectangle intersect: View desktop rectangle.
	self view rectangle: screenRectangle.

	"Once we're done we can decide where to position the buttons"
	self arrangeToolbarButtons.

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
	aspectPresenterInDialog := anAspectAccessor aspectDescriptor editablePresenterFor: aspectValueModel
				in: hookPresenter.

	"To avoid visual shock make sure our aspect presenter's font is the same as that of the
	receiver (and therefore of the dialog's parent too)."
	aspectPresenterInDialog view font: self view font.
	self view backcolor: aspectPresenterInDialog view backcolor.

	"We don't use the standard dialog mode buffering scheme. Instead we take a copy of the model
	contents that have been handed to us in the aspectPresenter and we reinstall these as the
	model being edited. The original model is saved asour subjectModel. This way, when we
	come to apply the changes in the receiver we can take the contents of the copy and set them
	back into the original model. See #apply."
	subjectModel := aspectPresenterInDialog model comparisonPolicy: SearchPolicy equality.
	copyModel := subjectModel value copy asValue.
	aspectPresenterInDialog model: copyModel.
	aspectPresenterInDialog 
		when: #actionPerformed
		send: #ok
		to: self.

	"Sadly we need to remember whether we have a ValueWorkspace presenter (the default block)"
	isValueWorkspacePresenter := anAspectAccessor aspectDescriptor isDefaultPresenterBlock.
	isValueWorkspacePresenter 
		ifTrue: 
			["And, if so, put it into single line mode"
			aspectPresenterInDialog beSingleLineMode].

	"Set our rectangle to the appropriate size and position"
	self applyPreferredExtent.
	(aspectPresenterInDialog view)
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

	^aspectPresenterInDialog view height < (self view actualFont pixelSize * 4)!

ok
	"The dialog has been okayed. Apply and/or accept the changes. The superclass implementation
	just applies the dialog copy model and closes. However, in the special case where we have a
	ValueWorkspace (Aspect class>>defaultPresenterBlock) installed we need to accept the
	workspace value first and then apply and close."

	isValueWorkspacePresenter ifTrue: [aspectPresenterInDialog accept ifFalse: [^self]].
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
!AspectEditorDialog categoriesFor: #ok!commands!public! !
!AspectEditorDialog categoriesFor: #onViewNcDeactivated:!event handling!private! !
!AspectEditorDialog categoriesFor: #recommendedRectangle:!accessing!public! !
!AspectEditorDialog categoriesFor: #removeBordersFromAspectPresenter!operations!private! !

!AspectEditorDialog class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 1572865 268566785 416 0 0 0 39 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1409287116 131137 512 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 519 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 512 0 8 4294903899 234 256 98 2 410 528 98 25 0 512 98 2 8 1409286988 131137 800 0 594 624 0 519 0 0 0 800 0 8 4294903899 234 256 98 0 234 256 98 4 15781 1115910 ##(Smalltalk.ToolbarIconButton)  15781 0 800 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #cancel 8 'Cancel' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'False.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr7.dll' 0 395334 3 ##(Smalltalk.Bitmap)  0 16 0 0 0 0 3 722 33 33 1 15779 962 15779 0 800 1 994 8 #ok 8 'Ok' 1 1 1058 0 16 1104 8 'True.ico' 1152 1186 0 16 0 0 0 0 3 722 33 33 1 98 2 1232 976 234 240 98 4 1328 1 1200 3 0 1 0 722 33 33 722 45 45 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 722 1 1 722 93 51 800 1506 8 #updateSizePosted 912 800 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 46 0 0 0 25 0 0 0] 98 0 722 193 193 0 27 8 'okButton' 234 256 912 202 208 912 234 240 912 0 1 0 722 33 33 722 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 13 1442 202 208 98 2 1506 1536 98 2 722 381 1 722 93 273 512 1506 1616 912 512 1634 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 0 0 0 0 0 0 0 236 0 0 0 136 0 0 0] 98 1 800 1696 0 27 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 2016 0 0 0 7 0 0 0 2016 482 1 1 0 0 0 0 0 234 256 912 0 1442 202 208 98 1 1506 1536 98 2 722 1 1 722 381 273 2016 1634 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 190 0 0 0 136 0 0 0] 98 0 1696 0 27 234 256 98 4 2016 8 'hook' 512 8 'toolbarButtons' 0 0 0 0 0 11347 0 0 722 701 501 722 301 71 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 32 8 1998891648 1442 202 208 98 3 1506 1536 98 2 722 2795 21 722 501 301 416 1506 8 #text: 98 1 8 'Edit' 416 1506 8 #updateMenuBar 912 416 1634 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 117 5 0 0 10 0 0 0 111 6 0 0 160 0 0 0] 98 4 2016 512 410 8 ##(Smalltalk.PushButton)  98 20 0 416 98 2 8 1140989952 1 2688 0 0 0 7 0 0 0 2688 0 8 4294903999 994 1264 8 'OK' 1 1 0 0 16 0 0 0 1442 202 208 98 3 1506 1536 98 2 722 9 -79 722 151 47 2688 1506 8 #isEnabled: 98 1 32 2688 1506 2560 98 1 8 'OK' 2688 1634 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 216 255 255 255 79 0 0 0 239 255 255 255] 98 0 1696 0 29 410 2704 98 20 0 416 98 2 8 1140858880 1 3072 0 0 0 7 0 0 0 3072 0 8 4294903999 994 1024 8 'Cancel' 1 1 0 0 32 0 0 0 1442 202 208 98 2 1506 1536 98 2 722 329 -79 722 151 47 3072 1506 2560 98 1 8 'Cancel' 3072 1634 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 216 255 255 255 239 0 0 0 239 255 255 255] 98 0 1696 0 29 1696 0 27 )! !
!AspectEditorDialog class categoriesFor: #resource_Default_view!public!resources-views! !

