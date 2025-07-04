"Filed out from Dolphin Smalltalk"!

UI.CreateWindowApiCall
	subclass: #'UI.CreateDialog'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.CreateDialog guid: (Core.GUID fromString: '{8e83dad1-32a3-4194-8169-ce1c86fdfec7}')!

UI.CreateDialog comment: ''!

!UI.CreateDialog categoriesForClass!Kernel-Objects! !

!UI.CreateDialog methodsFor!

create: aDialogView
	| hDlg |
	hDlg := User32
				createDialogParam: aDialogView resourceLib asParameter
				lpTemplate: aDialogView templateId asResourceId
				hWndParent: aDialogView resolveOwner asParameter
				lpDialogFunc: VM getDlgProc
				dwInitParam: 0.
	"A dialog will always be created on its owner's monitor by Windows, so may not be at the DPI we expect. We have to rescale to the owner DPI, and then setting the initial position may cause rescaling back to the desired DPI if not the same."
	aDialogView dpi: nil.
	self scaleToDpi: aDialogView dpi.
	"Position and size the dialog as requested."
	aDialogView setInitialPosition: rectangle truncated.
	^hDlg!

resolveShellGeometry: aDialogView
	| extent position creationMonitor targetDpi |
	position := rectangle origin.
	extent := rectangle extent.
	creationMonitor := aDialogView resolveOwner monitor.

	"If the position is not specified, we will need to work out a suitable position on the active monitor"
	(aDialogView isRestoringFromProxy or: [position = UseDefaultGeometry])
		ifTrue: 
			["Default position, so should go on the default monitor. For a dialog this is the monitor of the owner."
			targetDpi := creationMonitor effectiveDpi.
			extent := extent = UseDefaultGeometry
						ifTrue: [creationMonitor defaultWindowExtent * targetDpi // creationMonitor dpi]
						ifFalse: [extent * targetDpi // dpi].
			position := aDialogView isInitiallyCentered
						ifTrue: [creationMonitor centerExtent: extent]
						ifFalse: [creationMonitor nextWindowPosition].
			rectangle := RECT origin: (creationMonitor adjustPosition: position forExtent: extent)
						extent: extent.
			dpi := targetDpi]
		ifFalse: 
			[| targetMonitor |
			"Position was specified. This will determine the final monitor, so we scale to that monitor first."
			targetMonitor := DisplayMonitor nearestPoint: position.
			targetDpi := targetMonitor effectiveDpi.
			"Now we can calculate the extent as above"
			extent := extent = UseDefaultGeometry
						ifTrue: [targetMonitor defaultWindowExtent * targetDpi / targetMonitor dpi]
						ifFalse: [extent * targetDpi / dpi].
			"If should be initially centered, override the specified position, but keeping to the same monitor"
			position := aDialogView isInitiallyCentered
						ifTrue: 
							["Position so as to centre the window at whatever its extent should be"
							targetMonitor centerExtent: extent]
						ifFalse: [position * targetDpi / dpi].
			"Now adjust to fit the target monitor"
			rectangle := (targetMonitor adjustPosition: position forExtent: extent) extent: extent.
			dpi := targetDpi.
			"Finally rescale to the creation Dpi - when the dialog is repositioned to the actual target monitor, it will be rescaled if necessary. In the meantime the geometry needs to be scaled for the creation monitor, even if the eventual position is on another monitor."
			self scaleToDpi: creationMonitor effectiveDpi]! !

!UI.CreateDialog categoriesForMethods!
create:!operations!public! !
resolveShellGeometry:!operations!private! !
!

!UI.CreateDialog class methodsFor!

rectangle: aRectangle dpi: anInteger
	<primitive: 157>
	^self new
		rectangle: aRectangle;
		dpi: anInteger;
		yourself! !

!UI.CreateDialog class categoriesForMethods!
rectangle:dpi:!instance creation!public! !
!

