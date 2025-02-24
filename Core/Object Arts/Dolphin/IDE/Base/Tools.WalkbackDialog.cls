﻿"Filed out from Dolphin Smalltalk"!

UI.DialogView
	subclass: #'Tools.WalkbackDialog'
	instanceVariableNames: 'callStack resumable caption debuggable'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'CallStackId' -> 16r3E9.
			'Commands'
				-> (LookupTable withAll: { 16r1 -> #debug. 16r2 -> #terminate. 16r3 -> #resume. 16r4 -> #copy }).
			'IconId' -> 16r3F1
		}!

Tools.WalkbackDialog guid: (Core.GUID fromString: '{87b4c723-026e-11d3-9fd7-00a0cc3e4a32}')!

Tools.WalkbackDialog comment: '
Instance Variables:
	callStack		<readableString> containing the walkback trace.
	resumable		<boolean> indicating if the process is resumable.
	caption		<readableString> holding the walkback caption.

Class Variables:
	CallStackId	<integer> ID of the call stack text window.
	DebugId		<integer> ID of the "debug" button.
	IconId		<integer> ID of the warning icon.
	ResumeId		<integer> ID of the "resume" button.
	TerminateId	<integer> ID of the "terminate" button.
	KillId		<integer> ID of the "kill" button.

'!

!Tools.WalkbackDialog categoriesForClass!MVP-Views! !

!Tools.WalkbackDialog methodsFor!

actualBackcolor
	"Private - Answer the <Color> to be applied as the receiver's background colour. If the
	local backcolor is nil then the backcolor is inherited from the parent chain. If the
	parent's actual background colour is nil, then the default background colour is used."

	^Color.Face3d!

callStack: aString
	"Set the call stack to be displayed by the receiver."

	callStack := aString!

caption: aString
	"Set the caption of the receiver to aString"

	caption := aString!

copyWalkbackToClipboard
	"Copy the walkback details to the clipboard, which is useful for submitting a bug report (etc),
	although a VM 'crash' dump is typically better."

	(String writeStream 
		display: DateAndTime now; 
		nextPutAll: ': '; 
		print: caption; cr; 
		nextPutAll: callStack; 
		contents) copyToClipboard!

debuggable: aBoolean
	"Set whether the Debug key should be enabled or disabled."

	debuggable := aBoolean!

errorCreateWindowFailed
	Notification signal: 'Failed to open walkback dialog'!

onDpiChanged: aDpiChangedEvent
	| lresult |
	"In this case the controls are from a template, so we let DefDlgProc do the scaling."
	lresult := super defaultWindowProcessing: aDpiChangedEvent.
	"Save down the new DPI as in the superclass implementation we are replacing"
	dpi := aDpiChangedEvent newDpi.
	"We must rescale the error/warning image or Windows will just bitmap scale it with unpleasing results"
	self setImage.
	^lresult!

onInitDialog
	"Private - The walkback is opening and all controls have been created.
	Initialize as necessary."

	
	[self class releaseCapture.
	self
		setImage;
		parp;
		text: caption;
		setItem: CallStackId text: callStack;
		enableItem: (Commands keyAtValue: #resume) state: resumable;
		enableItem: IDOK state: debuggable.

	"Set default answer used if window closed rather than button pressed"
	self answer: #terminate]
			on: Error
			do: [:e | e resignalAsWarning].
	^true	"direct Windows to set the focus"!

parp
	Sound beep: (resumable
				ifTrue: [OS.MessageBoxConstants.MB_ICONWARNING]
				ifFalse: [OS.MessageBoxConstants.MB_ICONERROR])!

resumable: aBoolean
	"Set whether the resume key should be enabled or disabled."

	resumable := aBoolean!

runModalLoop
	"Private - create a modal message loop. We override this here due to a strange effect under
	Windows 95 where one walkback immediately following another will not be shown successfully.
	At least, it IS shown temporarily, but vanishes when the previous dialog is destroyed."

	[self show] postToMessageQueue.
	super runModalLoop!

setImage
	self setItem: IconId
		icon: (resumable
				ifTrue: [Icon warning withExtent: self metrics largeIconExtent]
				ifFalse: [Icon error withExtent: self metrics largeIconExtent])!

setInitialPosition: aRectangle
	"Private - Set the initial position and extent of the dialog window immediately after creation."

	"In this case the dialog content is loaded from the template, so we let the dialog manager worry about the correct extent, but we do allow the walkback dialog to be repositioned."

	OS.User32
		setWindowPos: handle
		hWndInsertAfter: nil
		x: aRectangle left
		y: aRectangle top
		cx: 0
		cy: 0
		uFlags: ##(SWP_NOACTIVATE | SWP_NOZORDER | SWP_NOSENDCHANGING | SWP_NOSIZE)!

templateId
	"Private - Answer the dialog template for the receiver."

	^136!

wmCommand: message wParam: wParam lParam: lParam
	"Our command handling requirements are very simple, so to avoid having to create Smalltalk
	button objects to represent the buttons on the template, we simply implement a rudimentary
	wmCommand: handler. We set the answer to the command name so that the caller can decide what
	to do with the process."

	| copyid |
	self answer: (Commands lookup: wParam).
	copyid := Commands keyAtValue: #copy.
	wParam > copyid ifTrue: [^false].
	wParam == copyid
		ifTrue: 
			[self copyWalkbackToClipboard.
			^false].
	^self destroy!

wmSize: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_SIZE (window resized) message."

	#todo "Resize the controls".
	^nil
! !

!Tools.WalkbackDialog categoriesForMethods!
actualBackcolor!accessing!private! !
callStack:!accessing!public! !
caption:!accessing!public! !
copyWalkbackToClipboard!commands!public! !
debuggable:!accessing!public! !
errorCreateWindowFailed!operations!private! !
onDpiChanged:!event handling!public! !
onInitDialog!event handling!private! !
parp!operations!private! !
resumable:!accessing!public! !
runModalLoop!operations!private! !
setImage!private!updating! !
setInitialPosition:!private!realizing/unrealizing! !
templateId!constants!private! !
wmCommand:wParam:lParam:!event handling-win32!public! !
wmSize:wParam:lParam:!event handling-win32!private! !
!

!Tools.WalkbackDialog class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self addClassConstant: 'Commands'
		value: (LookupTable withAll: { IDCANCEL -> #terminate. IDOK -> #debug. 3 -> #resume. 4 -> #copy })! !

!Tools.WalkbackDialog class categoriesForMethods!
initialize!initializing!private! !
!

