"Filed out from Dolphin Smalltalk"!

UI.ValueDialog
	subclass: #'UI.CommonDialog'
	instanceVariableNames: 'winStruct hook positioning'
	classVariableNames: 'HookCallbackDescriptor'
	imports: #(#{OS.CommonDialogConstants})
	classInstanceVariableNames: 'hookHandlers'
	classConstants: {}!

UI.CommonDialog guid: (Core.GUID fromString: '{87b4c6a8-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.CommonDialog isNonInstantiable: true!

UI.CommonDialog comment: 'CommonDialog is an abstract <valueDialogPresenter> superclass for all Windows common dialogs.

Instance Variables:
	winStruct		<Win32Structure> used to configure the system dialog.
	unused		<UndefinedObject> reserved for future use.

Class Instance Variables:
	hookHandlers	<IdentityDictionary> mapping <integer> message codes to the <Symbol>ic selectors of the message handler methods.


'!

!UI.CommonDialog categoriesForClass!MVP-Presenters! !

!UI.CommonDialog methodsFor!

attachHandle: anExternalHandle
	"Private - Create a DialogView to represent the receiver's view."

	| dialog |
	dialog := DialogView fromHandle: anExternalHandle.
	self view: dialog!

basicShowModal
	"Private - Create and show a new instance of this common dialog."

	^self subclassResponsibility!

checkError
	| err |
	err := ComDlg32 commDlgExtendedError.
	^err = 0 ifFalse: [self error: ('Common dialog error: <1d>' expandMacrosWith: err)]!

createHook
	^self class hookHandlers
		ifNotNil: 
			[:handlers |
			External.Callback block: 
					[:hdlg :uiMsg :wParam :lParam |
					view isNil ifTrue: [self attachHandle: hdlg].
					(handlers lookup: uiMsg)
						ifNil: [0]
						ifNotNil: 
							[:selector |
							(self
								perform: selector
								with: uiMsg
								with: wParam
								with: lParam) asUIntPtr]]
				descriptor: HookCallbackDescriptor]!

dialogView
	"Answer a <View> wrapping the actual dialog."

	^self view!

extent
	"Answer a <Point> representing the pixel extent of the receiver's view."

	^self dialogView extent!

extractResult: apiResult
	"Private - Extract and apply the result from the parameter structure 
	passed to the Win32 API associated with this common dialog, immediately 
	after the call to that API."

	^self subclassResponsibility!

initialize
	"Private - Initialize the receiver"

	winStruct := self winStructClass new.
	positioning := #centerOwner.
	super initialize!

initialPositioning
	"Answer the inital positioning used to place the dialog when opened, one of:
		- #system, let Windows decide
		- #centerOwner, centre over the owner window
		- #centerMonitor, centre on the monitor of the owner window
		- #centerMouse, centre over the mouse position"

	^positioning!

initialPositioning: aSymbol
	"Set the inital positioning used to place the dialog when opened. See #initialPositioning for the list of options."

	positioning := aSymbol!

ownerView: aView
	"Private - Set the receiver's ownerView to aView."

	super ownerView: aView.
	self winStruct ownerView: aView.!

position
	"Answer a <Point> representing the screen position of the receiver's view."

	^self dialogView getWindowRect topLeft!

position: aPoint
	"Set the top left position of the receiver's view to the screen co-ordinate represented by the <Point> argument. Answer whether the position request was accepted."

	self dialogView position: aPoint!

prepareStruct
	"Private - Initialize the parameter structure to be passed to the Win32
	API associated with this common dialog, immediately prior to the call
	to that API."

	!

saveViewCaption
	caption ifNil: [caption := self view topView caption]!

setInitialPosition
	(##(IdentityDictionary withAll: {#system -> [:dialog | ].
				#centerOwner
					-> [:dialog | dialog position: dialog ownerView getWindowRect center - (dialog extent / 2)].
				#centerMonitor
					-> [:dialog | dialog position: dialog ownerView monitor workArea center - (dialog extent / 2)].
				#centerMouse -> [:dialog | dialog position: Cursor position - (dialog extent / 2)].
				#originMouse -> [:dialog | dialog position: Cursor position]})
		lookup: self initialPositioning) ifNotNil: [:monad | monad value: self]!

setViewIcon: anIcon
	"Set the icon of a view opened on the receiver.
	We don't want to foist our icon onto the common dialogs, so override to do nothing."!

showModal
	"Create and show the receiver's modal dialog. Answer the 'result' (as defined by the
	subclass) or nil if no selection was made."

	"Implementation Note: The common dialogs steal the message loop and send WM_ENTERIDLE
	messages only erratically. We therefore start up the idle timer to allow us to run
	background processes now and again."

	| apiResult owner wasEnabled hitType |
	hook := self createHook.
	hook notNil ifTrue: [self winStruct hook: hook].
	self prepareStruct.
	owner := self ownerView ifNil: [View activeOrDesktop].
	wasEnabled := owner isEnabled.
	apiResult := 
			[SessionManager.Current inputState startIdleTimer.
			hook notNil ifTrue: [view := nil].
			self basicShowModal]
					ensure: [SessionManager.Current inputState stopIdleTimer].
	hitType := wasEnabled
				ifTrue: [HTCLIENT]
				ifFalse: 
					[owner isEnabled: false.
					HTERROR].
	"Reset the view's cursor in case control does not return to message loop"
	User32
		sendMessage: owner asParameter
		msg: WM_SETCURSOR
		wParam: 0
		lParam: hitType.
	self extractResult: apiResult.
	^self answer!

updateIcon
	"Private - Transfer any icon across to the view. The common dialogs do not
	require icons so do nothing"!

winStruct
	"Private - Answer the receiver's associated windows parameter structure."

	^winStruct

!

winStructClass
	"Private - Answer the class to use for the receiver's associated windows parameter structure."

	^self subclassResponsibility!

wmInitDialog: message wParam: wParam lParam: lParam
	"Private - A WM_INITDIALOG message was sent to the hook procedure. This is sent after the common dialog itself has handled the message."

	self caption ifNotNil: [:text | self setViewCaption: text].
	self setInitialPosition.
	^1! !

!UI.CommonDialog categoriesForMethods!
attachHandle:!private!realizing/unrealizing! !
basicShowModal!private!realizing/unrealizing! !
checkError!helpers!private! !
createHook!helpers!private! !
dialogView!public! !
extent!public! !
extractResult:!helpers!private! !
initialize!accessing!initializing!private! !
initialPositioning!public! !
initialPositioning:!public! !
ownerView:!accessing!private! !
position!public! !
position:!public! !
prepareStruct!helpers!private! !
saveViewCaption!public! !
setInitialPosition!public! !
setViewIcon:!operations!public! !
showModal!public!realizing/unrealizing! !
updateIcon!private!updating! !
winStruct!accessing!private! !
winStructClass!constants!private! !
wmInitDialog:wParam:lParam:!event handling-win32!private! !
!

!UI.CommonDialog class methodsFor!

defaultView
	"Answer the resource name of the default view for the receiver."

	self shouldNotImplement!

hookHandlers
	^hookHandlers!

initialize
	HookCallbackDescriptor := External.FunctionDescriptor argumentTypes: 'handle uint32 uintptr uintptr'!

initializeDefaultHooks
	hookHandlers := IdentityDictionary new.
	hookHandlers at: WM_INITDIALOG put: #wmInitDialog:wParam:lParam:!

showModal
	"Creates a default instance of the receiver and displays it modal 
	to the current active window. 
	Answers the result of the dialog if confirmed or nil otherwise"

	^self new showModal!

showModal: aDialogResourceNameString
	"Private - Should not implement. CommonDialogs can only use the view provided
	by the operating system."

	^self shouldNotImplement!

showModal: aDialogResourceNameString on: aModel
	"Private - Should not implement. CommonDialogs can only use the view provided
	by the operating system."

	^self shouldNotImplement
!

showModalOn: aModel
	"Creates an instance of the receiver connected to aModel. 
	The view is displayed modal to the current active window. 
	Answers the result of dialog if confirmed or nil otherwise"

	^(self on: aModel) showModal! !

!UI.CommonDialog class categoriesForMethods!
defaultView!constants!public! !
hookHandlers!accessing!private! !
initialize!class initialization!development!private! !
initializeDefaultHooks!initializing!must not strip!private! !
showModal!instance creation!public! !
showModal:!instance creation!private! !
showModal:on:!instance creation!private! !
showModalOn:!instance creation!public! !
!

