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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(786432 134283392) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1409289164 131137 544 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 544 nil 8 1912794480 170 192 34 2 410 ##(Smalltalk.Toolbar) 34 25 nil 544 34 2 8 1409289036 131137 768 nil nil nil 519 nil nil nil 768 nil 8 1912794480 170 192 8 #() 170 192 34 4 37637 1115206 1 ##(Smalltalk.ToolbarIconButton) 768 1 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 'Ok' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'True.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 37637 37639 914 768 1 946 #cancel 8 'Cancel' 1 1 994 nil true 1040 8 'False.ico' 1088 37639 34 2 928 1120 170 176 34 4 395334 3 ##(Smalltalk.Bitmap) nil true nil nil nil nil 3 690 33 33 3 1250 nil true nil nil nil nil 3 690 33 33 1 nil 1 nil 690 33 33 690 45 45 nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 690 1 1 690 93 51 768 1426 #updateSizePosted 864 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 46 0 0 0 25 0 0 0] 8 #() 690 193 193 nil 27 8 'okButton' 170 192 864 138 144 864 170 176 864 nil 1 nil 690 33 33 690 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 13 1362 138 144 34 2 1426 #createAt:extent: 34 2 690 381 1 690 93 273 544 1426 #updateSizePosted 864 544 1522 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 0 0 0 0 0 0 0 236 0 0 0 136 0 0 0] 34 1 768 1584 nil 27 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1904 nil 466 496 nil 7 nil nil nil 1904 514 1 1 nil nil nil nil nil 170 192 864 nil 1362 138 144 34 1 1426 #createAt:extent: 34 2 690 1 1 690 381 273 1904 1522 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 190 0 0 0 136 0 0 0] 8 #() 1584 nil 27 170 192 34 4 544 8 'toolbarButtons' 1904 8 'hook' nil nil nil nil nil 124989 nil nil 690 1281 961 690 301 71 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 2007257760 1362 138 144 34 3 1426 #createAt:extent: 34 2 690 3839 21 690 501 301 416 1426 #text: 34 1 8 'Edit' 416 1426 #updateMenuBar 864 416 1522 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 121 8 0 0 160 0 0 0] 34 4 1904 544 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140989952 1 2544 nil nil nil 7 nil nil nil 2544 nil 8 1912725136 946 #ok 8 'OK' 1 1 nil nil true nil nil nil 1362 138 144 34 3 1426 #createAt:extent: 34 2 690 9 -79 690 151 47 2544 1426 #isEnabled: 8 #(false) 2544 1426 #text: 34 1 8 'OK' 2544 1522 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 216 255 255 255 79 0 0 0 239 255 255 255] 8 #() 1584 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140858880 1 2896 nil nil nil 7 nil nil nil 2896 nil 8 1912725136 946 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1362 138 144 34 2 1426 #createAt:extent: 34 2 690 329 -79 690 151 47 2896 1426 #text: 34 1 8 'Cancel' 2896 1522 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 216 255 255 255 239 0 0 0 239 255 255 255] 8 #() 1584 nil 29 1584 nil 27 )! !
!AspectEditorDialog class categoriesFor: #resource_Default_view!public!resources-views! !

