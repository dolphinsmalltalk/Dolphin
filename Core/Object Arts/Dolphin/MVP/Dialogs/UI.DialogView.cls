"Filed out from Dolphin Smalltalk"!

UI.ShellView
	subclass: #'UI.DialogView'
	instanceVariableNames: 'endModal isModal oldWndProc'
	classVariableNames: ''
	imports: #(#{OS.ThemeConstants})
	classInstanceVariableNames: ''
	classConstants: { 'InProcLoopMask' -> 16r100000 }!

UI.DialogView guid: (Core.GUID fromString: '{87b4c71e-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.DialogView comment: 'DialogView is a specialisation of <topView> that provides the ability to be displayed modally and to return a value.

Instance Variables:
	endModal		<Semaphore> to wait on during the dialog modal loop.
	isModal		<boolean> indicating whether the dialog is modal or not.
	oldWndProc	<ExternalAddress> holding the original Windows dlgProc.

'!

!UI.DialogView categoriesForClass!MVP-Views! !

!UI.DialogView methodsFor!

answer
	"Answer the answer for the receiver"

	^self model!

answer: anObject
	"Set the answer for the receiver to be anObject"

	self model: anObject!

basicCreateWindowAt: originPoint extent: extentPoint styles: anArray name: anAnsiString
	"Private - Create the Windows window ensuring it has the VM window procedure.
	Answer the receiver. The position and size are currently ignored."

	"Note: If the CreateDialogIndirect() API call GPFs it is almost certainly because 
	an attempt is being made to load a dialog template from a resource library that
	has been opened with the LOAD_LIBRARY_AS_DATAFILE flag. Dialog templates
	can only be loaded from DLLs that have been loaded as normal code modules."

	^User32
		createDialog: self resourceLib asParameter
		lpTemplate: self templateId asResourceId
		hWndParent: self class activeHandle
		lpDialogFunc: VM getDlgProc
		dwInitParam: 0!

cancel
	"Process a cancel command. This is done by sending the correct cancel
	command to follow the correct procedure for cancelling a dialog."

	self destroy!

defaultBackcolor
	"Private - Answer the default colour for the receiver's background"

	^(self hasCaption or: [self isThemed not]) ifTrue: [Color.Face3d] ifFalse: [super defaultBackcolor]!

defaultButton
	"Answer the default <PushButton> in the receiver, or nil if none."

	^self findItem: self defaultButtonId ifAbsent: nil!

defaultExtent
	"Private - Answer the default size of the receiver in device-independent pixels (96-dpi DIPs). This is used only to determine the size of a view when it is created (although after scaling DIPs to the monitor DPI). Thereafter #preferredExtent is used when the desired size of a view is requested."

	"Implementation Note: This is used only for creation, and as the initial size and position are ignored when creating a dialog, we may as well answer any fixed point rather than calculating something that will be ignored."

	^260 @ 295!

defaultWindowProcessing: message wParam: wParam lParam: lParam
	"Private - Pass a Windows message to the 'default' window procedure of the receiver.
	As the receiver is a dialog we must call the DefDlgProc() instead, this will call
	our own DialogProc() (dialog procs are not WndProcs), which just returns false
	to get the DefDlgProc() to do its stuff."

	^User32
		defDlgProc: handle
		msg: message
		wParam: wParam
		lParam: lParam!

defaultWindowStyle
	"Private - Answer the default basic window creation style"

	^##(WS_DLGFRAME | WS_CAPTION | WS_SYSMENU)
!

destroy
	"Forcibly close the receiver"

	| wasModal sem |
	wasModal := self isModal.
	self isModal: false.

	"Note: #endDialog will not actually destroy the receiver if it was not 
	created by DialogBox()"
	self endDialog: 0.

	"Restart the process waiting for the dialog (but only when we have finished destroying the window)"
	"#948. Avoid ref to inst var after view destroyed, in case being mutated"
	sem := endModal.
	[sem signal] postToMessageQueue.
	wasModal == true 
		ifTrue: 
			["N.B. The dialog will be destroyed by the process which opened it after it has
			re-enabled the previously active window. This is done to avoid losing activation
			to another top-level window. Therefore we deliberately don't destroy the window
			here."
			]
		ifFalse: 
			["Ensure modeless dialogs are correctly destroyed"
			super destroy]	"cope with old resources containing nil here"!

dmGetDefId: message wParam: wParam lParam: lParam
	"Private - Handle a DM_GETDEFID message sent to request the id of any default
	push button in the receiver.
	Implementation Note: Rely on the default Dialog Proc. implementation (it can
	cope with this simple task)."

	^nil!

dmSetDefId: message wParam: wParam lParam: lParam
	"Private - Default handler for a DM_SETDEFID message sent to request that the id of any default
	push button be changed in the receiver.
	Implementation Note: Unfortunately we must jump through hoops to make this work correctly due
	to the 'features' and limitations of the default dialog proc's (DDP's) handling of default buttons
	-	The DDP does not remove the default push button style from the last push button when 
		the default is set to 0 (i.e. no default button). In fact the DDP does not really support
		the absence of any default button, since it tries to default it to IDOK.
	-	The DDP does not correctly set the default push button style of a button which is not an
		immediate child (though it does seem to work Ok after navigation with the keyboard or
		mouse)."

	| def answer |
	def := self defaultButtonId.
	answer := self defaultWindowProcessing: message wParam: wParam lParam: lParam.
	(wParam isZero and: [def notNull]) ifTrue: [
		"Dialog proc does not remove style of old default if set defId to zero, so we must force
		that behavior otherwise it is not possible to remove default status from all push
		buttons in a dialog (the dialog proc. does not seem designed to cope with this case)."
		self setButtonId: def style: BS_PUSHBUTTON].
	self defaultButtonId: wParam.	"Cache the default button"
	"Sometimes the dialog proc. does not set the default button style, so if it hasn't we will"
	def := self defaultButtonId.
	(def notNull "and: [def isDefault not]") ifTrue: [
		self setButtonId: def style: BS_DEFPUSHBUTTON].
	^answer
!

enableItem: anInteger state: aBoolean
	"Private - Enable/Disable the receiver's control with the specified Id. Answers the previous
	state of the window."

	^User32 enableWindow: (self getItem: anInteger) asParameter bEnable: aBoolean!

endDialog: result
	"Close the receiver with result as the result of the dialog (should be an Integer
	or convertible to anInteger by asUIntPtr)"

	User32 endDialog: handle nResult: result asUIntPtr!

filerProxyIn: anSTxOutFiler
	"Private - Answer a filer proxy that represents the receiver for use with the <STxOutFiler> argument."

	| proxy |
	proxy := super filerProxyIn: anSTxOutFiler.
	proxy instVars at: ##(self indexOfInstVar: 'oldWndProc') put: nil.
	^proxy!

getItemText: anInteger
	"Private - Get the text of the receiver's control with the specified id.
	We do not use the GetDlgItemText() function, since this does not provide us with a way of
	allocating an appropriately sized string."

	^(self getItem: anInteger) text!

has3dLook
	^self baseStyleAllMask: DS_3DLOOK
!

has3dLook: aBoolean
	self baseStyleMask: DS_3DLOOK set: aBoolean!

initialize
	"Private - Initialize the receiver on instantiation. Create centered by default. Answer the receiver."

	super initialize.
	self isInitiallyCentered: true.
	self isModal: false.
	endModal := Semaphore new!

isInProc
	"Answer whether the receiver will run its modal loop in-process."

	^self svFlags allMask: InProcLoopMask!

isInProc: aBoolean 
	svFlags := self svFlags mask: InProcLoopMask set: aBoolean!

isModal
	isModal isNil ifTrue: [isModal := false].
	^isModal!

isModal: anObject
	isModal := anObject!

isPersistentView
	"Dialogs are not currently restoreable because it may not be possible 
	to restore the modal execution state."

	^self isModal not!

isPropertyPage
	"Answer whether the receiver is (probably) a property page in a tagged dialog."

	^self hasCaption not and: [self getParent ~= 0]!

oldWndProc: anAddress
	"Private - Save the address of the old window procedure prior to subclassing."

	oldWndProc := anAddress!

onInitDialog
	"Default handler for dialog initialization."

	"Since the dialog is loaded from a resource template the window styles will not match those
	set for the receiver. Transfer our styles across here"

	self styles: self styles.

	"Similarly, Windows always creates dialog as a child of the desktop. Force the required
	parent here"
	User32 setParent: handle hWndNewParent: creationParent asParameter.

	(self isPropertyPage and: [self isThemed])
		ifTrue: 
			["Property pages in tabbed dialogs require a specific theme"
			UxTheme enableThemeDialogTexture: handle dwFlags: ETDT_ENABLETAB].

	"Tell Windows NOT to set the focus. We set focus later after we have populated the dialog
	(though subclasses loaded from a Windows dialog template resource may wish to return true
	here)"
	^false!

performCommand: aCommand
	"Performs aCommand on the receiver and answer the result.
	Can be overridden by subclasses that wish, perhaps, to add some
	generic undo/redo ability for all commands."

	^aCommand value
!

preTranslateKeyboardInput: aMSG
	"Answer whether the receiver would like to consume the argument aMSG,
	which is a keyboard message.
	Implementation Note: Override superclass to include standard handling
	of ESC key (to cancel the dialog)."

	^(self translateAccelerator: aMSG) or: [self isDialogMessage: aMSG]!

resourceLib
	"Answer the library/handle of the module containing the receiver's template.
	Note: This library MUST NOT be opened as a datafile (i.e. with the LOAD_LIBRARY_AS_DATAFILE
	flag), as if it is then CreateDialogIndirect() will GPF when attempting to use 
	any templates from it."

	^VM!

restorePlacement: aWINDOWPLACEMENT resolution: aPoint
	"The initial position for a dialog is ignored, so we just need to scale to the correct resolution for (what will be) the owner window"

	self basicRestorePlacement: aWINDOWPLACEMENT scalingBy: View active resolution / aPoint!

runModalInProcessLoop
	"Private - Create a modal message loop until our continue flag suggests exit. Note that here
	we run the dialog message loop in the current active process, rather than forking a new one.
	This can be useful ifa deadlock is likely due to the current process holding a Mutex lock
	likely to be required by the new process."

	self isModal: true.
	SessionManager.Current inputState loopWhile: [self isModal]!

runModalLoop
	"Private - create a modal message loop. We do this by forking a new UI process, and 
	waiting until signalled that the dialog has closed. This implementation permits
	multiple top-level windows to have separate modal dialogs against them, which 
	can be dismissed in any order."

	Processor forkMainIfMain 
		ifTrue: 
			["Boost the initiating UI processes priority so that the operation requested by the user
		completes more quickly when the dialog is closed."
			| proc |
			proc := Processor activeProcess.
			proc priority: proc priority + 1].
	self isModal: true.
	endModal wait!

setItem: anInteger font: aFontOrHandle
	"Private - Set the font of the receiver's control with the specified id."

	User32
		sendMessage: (self getItemHandle: anInteger ifAbsent: nil)
		msg: WM_SETFONT
		wParam: aFontOrHandle asParameter
		lParam: 0!

setItem: anInteger icon: anIcon
	"Private - Set the icon of the receiver's static control with the specified id.
	Difficult to trap error here because return is 0 if previously control had no error,
	or if a real error occurred!!. The answer is the handle of the previous icon."

	^User32
		sendDlgItemMessage: handle
		nIDDlgItem: anInteger
		msg: STM_SETICON
		wParam: anIcon asParameter
		lParam: 0!

setItem: anIntegerId int: anInteger
	"Private - Set the text of the receiver's control with the specified id to the string
	representation of anInteger."

	(User32
		setDlgItemInt: handle
		nIDDlgItem: anIntegerId
		uValue: anInteger
		bSigned: anInteger negative) ifFalse: [User32 systemError]!

setItem: anInteger text: aString
	"Private - Set the text of the receiver's control with the specified id."

	(User32 setDlgItemText: handle nIDDlgItem: anInteger lpString: aString)
		ifFalse: [User32 systemError]!

showModal
	"Private - Show the receiver as a dialog modal to the current active window. Note that if the Dialog has already been created, it will have taken activation, and it is no longer possible to determine the previously active window."

	^self showModalTo: nil!

showModalTo: aView
	"Private - Show the (already created) receiver as a dialog modal to aView."

	| enableOwningView owningView |
	"The act of creating a dialog box, even without showing it, steals activation, so it may be too late to find the previously active window now if the dialog has already been created"
	owningView := aView ifNil: [View active].
	(owningView isNil or: [owningView == self]) ifTrue: [owningView := View desktop].
	"Allow the create to fail, in which case return nil as the result"
	self handle isNil ifTrue: [^nil].
	(enableOwningView := owningView isEnabled) ifTrue: [owningView isEnabled: false].
	
	["Only now can we adjust the position of the dialog (if required)."
	owningView repositionShell: self.
	self
		layout;
		show.
	self isInProc ifTrue: [self runModalInProcessLoop] ifFalse: [self runModalLoop]]
			ensure: 
				["Seems windows may re-enable a disabled view itself, so we re-establish enablement state regardless"
				owningView isEnabled: enableOwningView.
				enableOwningView ifTrue: [owningView beActive].
				"Force the owning view to re-paint and update its cursor in case actions following closure of the dialog are lengthy"
				owningView update.
				User32
					sendMessage: owningView asParameter
					msg: WM_SETCURSOR
					wParam: 0
					lParam: (enableOwningView ifTrue: [HTCLIENT] ifFalse: [HTERROR]).
				owningView := nil.
				"We do not destroy the dialog until its owningView is re-enabled to prevent another
		window coming to the front."
				self basicDestroy].
	^self answer!

showModeless: aView
	"Private - Show the (already created) receiver as a modeless dialog for the specified owner window."

	aView repositionShell: self.
	self show!

subclassWindow: anExternalHandle
	"Private - Subclass the receiver's associated Win32 window by substituting the VM's 
	window procedure for the default dialog proc."

	Processor activeProcess newWindow: nil.
	self attachHandle: anExternalHandle.
	self subclassWindow!

templateId
	"Private - Answer the dialog template for the receiver. 
	This dummy template is stored in the VM resources"

	^139!

wmDpiChanged: message wParam: wParam lParam: lParam
	"Private - Handles a WM_DPICHANGED message. This is only sent to top-level windows (e.g. ShellViews in Dolphin)
		- wParam encodes the new DPI with the X-axis value in the low word, and y-axis in the high word.
		- lParam is a pointer to a RECTL providing the suggested new rectangle for the window.
	"

	super wmDpiChanged: message wParam: wParam lParam: lParam.
	"We don't want the DefDlgProc to rescale Dolphin dialogs that are described by view resources. For these the template itself does not contain any controls, and our internal re-scaling (as used for normal shells) does the job. Dialogs that are built from a template will need to call the DefDlgProc to rescale correctly."
	^0!

wmInitDialog: message wParam: wParam lParam: lParam
	"A WM_INITDIALOG message was sent by the dialog proc. Answer false if the focus has been set,
	or true if leaving that to Windows.

	N.B. This message is received before the contents of a Dolphin dialog view have been established
	so would consequently be of little use. To avoid confusion we do not send the event on to the
	presenter but, as the event may be useful to fully defined dialogs (i.e. those loaded from a template),
	we do send it to the receiver as #onInitDialog."

	"Cache the initialize default button."
	self defaultButtonId: self getDefId.

	"A 'feature' of Windows dialogs is that that default button may be IDOK, even if there is no such 
	button so we clear the non-existant button down to prevent confusion later."
	self defaultButtonId isNil ifTrue: [self setDefId: 0].

	^self onInitDialog! !

!UI.DialogView categoriesForMethods!
answer!accessing!public! !
answer:!accessing!not an aspect!public! !
basicCreateWindowAt:extent:styles:name:!private!realizing/unrealizing! !
cancel!commands!public! !
createAt:extent:!private!realizing/unrealizing! !
defaultBackcolor!colors!constants!private! !
defaultButton!accessing!public! !
defaultExtent!constants!public! !
defaultWindowProcessing:wParam:lParam:!dispatching!private! !
defaultWindowStyle!constants!private! !
destroy!public!realizing/unrealizing! !
dmGetDefId:wParam:lParam:!default button!event handling-win32!private! !
dmSetDefId:wParam:lParam:!default button!event handling-win32!private! !
enableItem:state:!accessing!private! !
endDialog:!operations!public! !
filerProxyIn:!binary filing!private! !
getItemText:!accessing!private! !
has3dLook!accessing!public! !
has3dLook:!accessing!public! !
initialize!initializing!private! !
isInProc!public!testing! !
isInProc:!accessing!public! !
isModal!accessing!private! !
isModal:!accessing!private! !
isPersistentView!public!testing! !
isPropertyPage!public!testing! !
oldWndProc:!accessing!private! !
onInitDialog!event handling!public! !
performCommand:!commands!public! !
preTranslateKeyboardInput:!dispatching!public! !
resourceLib!constants!public! !
restorePlacement:resolution:!geometry!private! !
runModalInProcessLoop!operations!private! !
runModalLoop!operations!private! !
setItem:font:!accessing!private! !
setItem:icon:!accessing!private! !
setItem:int:!accessing!private! !
setItem:text:!accessing!private! !
showModal!private!realizing/unrealizing! !
showModalTo:!private!realizing/unrealizing! !
showModeless:!private!realizing/unrealizing! !
subclassWindow:!operations!private! !
templateId!constants!private! !
wmDpiChanged:wParam:lParam:!event handling-win32!private! !
wmInitDialog:wParam:lParam:!event handling-win32!must not strip!public! !
!

!UI.DialogView class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	View registerMessageMappings: {WM_INITDIALOG -> #wmInitDialog:wParam:lParam:}!

new
	"Answer an instance of the receiver on a nil model"

	^self on: nil!

on: aSubjectModel
	"Create a new instance of the receiver editing the value of aSubjectModel."

	^super new model: aSubjectModel.
!

uninitialize
	View unregisterMessageMappings: {WM_INITDIALOG}!

winClassName
	^'#32770'! !

!UI.DialogView class categoriesForMethods!
icon!constants!public! !
initialize!initializing!private! !
new!instance creation!public! !
on:!instance creation!public! !
uninitialize!class hierarchy-removing!private! !
winClassName!constants!private! !
!

