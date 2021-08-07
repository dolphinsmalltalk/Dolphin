"Filed out from Dolphin Smalltalk"!

UI.MessageBoxAbstract subclass: #'UI.MessageBox'
	instanceVariableNames: 'button uniqueId flags icon styleFlags headline detailsText expandLabel collapseLabel checkboxText footerIcon handle events verified footerText'
	classVariableNames: 'ButtonStyles ModeStyles'
	imports: #(#{OS.Win32Constants} #{OS.TaskDialogConstants} #{OS.Win32Errors} #{OS.WinRegConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'CommonButtonFlags' -> #(16r1 16r8 16r8 16r10 16r1 16r2 16r4 16r20 nil 16r10 16r1).
		'DefaultableMask' -> 16r30.
		'SuppressibleMask' -> 16r10
	}!
UI.MessageBox guid: (Core.GUID fromString: '{87b4c49f-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.MessageBox comment: '`MessageBox` provides a convenient dialog abstraction for posing short questions, and reporting notifications, warnings, or errors.

`MessageBox` is implemented using the  [Windows TaskDialog](https://docs.microsoft.com/en-us/windows/win32/controls/task-dialogs) control. TaskDialog offers significantly more functionality and greater flexibility than the traditional Windows MessageBox:
  - It supports centering over the owner window, which provides a better experience, especially with multiple monitors. The MessageBox only ever opens in the centre of the primary monitor.
  - It supports checkbox functionality that is ideal for implementing suppressed messages, and unlike the `SHMessageBoxCheck` API this can be used to implement "Remember this answer" functionality (defaultable), as opposed to just "Don''t show me this again" (suppressible). The checkbox text (aka verificationText) can be configured as desired. It does not just have to be used for defaulting functionality, although if used for defaulting it is not available for other purposes.
  - It can display any icon supplied as an icon handle (HICON), not just icons loaded from resources. This allows use of `TextTileIcon`s, etc.
  - It has headline text functionality, as well as the message content text. The headline text function is displayed in a different style for emphasis. The style depends on the theme, but typically it will be a larger font and in a highlight colour.
  - It has extra details functionality for display of additional information that is initially collapsed behind an expando button.
  - It also supports display of a progress bar, and radio buttons, but these features are not currently supported by the Dolphin abstraction.

The main aspect of Windows MessageBox functionality that is missing from TaskDialog is task-modality, i.e. disablement of all windows in the application when the dialog is shown. This can be (and is) simulated fairly easily in the Smalltalk layer, however. A more unfortunate difference is that TaskDialogs appear to ignore tabs in the text, unlike the basic Windows MessageBox, so this can affect the appearance of existing messages that use tabs to indent some content.

Example usage:

```
	MessageBox new 
		confirm: ''Would you like a cup of tea?''.
	MessageBox warning: ''Contents are hot''.
	MessageBox errorMsg: ''You''''ve burned yourself''.

	"Create an instance for complete flexibility"
	MessageBox new
		icon: Object icon;
		buttonStyle: #cancelRetryContinue;
		text: ''Is this any more helpful?'';
		open
```

`MessageBox`s can also be configured so that they are suppressible by the user. This includes a checkbox in the `MessageBox` which the user can tick if they don''t want to see the message again. Subsequent attempts to display the same message (as identified by the uniqueId) will result in the immediate return of a default button value. There are two forms of suppressible message box. The first is primarily for backwards compability, and when suppressed will always return the default button value. The second is a new defaultable style, which will return the button the user pressed when choosing to suppress the message box. In other words the older `isSuppressible` style can be used for cases where the user may not wish to see the dialog again. The `isDefaultable` style is useful for cases where one wants "Remember this answer" functionality. 

For compatibility with message boxes shown by the [SHMessageBoxCheck API](https://docs.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-shmessageboxcheckw) API (as used in versions of Dolphin prior to 8) when an `isSuppressible` message box is suppressed by the user, a value is written under _HKCU/Software/Microsoft/Windows/CurrentVersion/Explorer/DontShowMeThisDialogAgain_. The value is named after the `uniqueId` set when the message box was opened, prepended with the GUID of the Dolphin application (i.e. the GUID of the `SessionManager` class).

Defaultable message boxes also write a registry value, but this time under _HKCU/Software/<product registry key>/DontShowMeThisDialogAgain_. The registry value is a `REG_DWORD`, and its value is the id of the users button selection when suppressing the dialog (i.e. the remembered answer).

##Instance Variables:
  `button`			`<integer>` id of the button that was pressed (e.g. `IDOK`)
  `uniqueId`		`Object`. The display string of this object is used to uniquely identify (within an application) a particular suppressible message box instance.
  `flags`			`<integer>`. Miscellaneous flags
  `icon`			`Icon` displayed in the message box, if not one of the standard icons.
  `styleFlags`		`<integer>`. Button and icon styles.
  `headline`		`Utf16String` text displayed as the header text (aka main text)
  `detailsText`		`Utf16String` text displayed as extra details text (aka expanded information)
  `expandLabel`	`Utf16String` label displayed on the extra detail expando button when collapsed
  `collapseLabel`	`Utf16String` label displayed on the extra detail expando button when expanded
  `checkboxText`	`Utf16String` label of the verification checkbox, e.g. used for suppressible messages
  `footerIcon`		`Icon` to be displayed in the footer of the message box.
  `handle`			`External.Handle` of the task dialog window, when open
  `events`			`EventsCollection`. Event storage.
  `verified`		`<boolean>` indicating whether the checkbox in the message box (if any) was checked when closed.

##Class Variables:
  `ButtonStyles`	`IdentityDictionary` mapping `Symbol` button style names to the corresponding `MB_XXX_` flag values.
  `ModeStyles`		`IdentityDictionary` mapping `Symbol` modality style names (e.g. #task) to the corresponding `_MB_XXX_` flag values.

##Class Constants:
  `CommonButtonFlags`
  `DefaultableMask`
  `SuppressibleMask`	`<integer>`. Masks in/out the suppressible flag from the flags instance variable.
'!
!UI.MessageBox categoriesForClass!MVP-Views-Support! !
!UI.MessageBox methodsFor!

assertStylesValid
	"Private - SHMessageBoxCheck supports only a limited range of the full set of MessageBox
	styles. We try to adapt the style request to an equivalent style, but if this is not
	possible then let the programmer know that they will not get the desired effect."

	"Implementation Note: Although the documentation states that SHMessageBoxCheck does not
	support MB_YESNOCANCEL, in fact its MB_YESNO style is really the that. It doesn't display a
	Cancel button, but it does enable the close box on the caption (and will respond to the
	ESCape key), and the result in that case is #cancel."

	self assert: [##({MB_YESNOCANCEL. MB_OKCANCEL. MB_YESNO. MB_OK}) includes: self buttonStyleValue].
	self assert: 
			[| val |
			val := self iconStyleFlag.
			val ~= MB_USERICON and: [IconStyles values includes: val]]!

basicOpen
	"Private - Display a Win32 Task Dialog configured as a message box, and answer the Win32 Id of the button pressed by the user."

	| buttons dwFlags struct title callback hwndOwner |
	struct := OS.TASKDIALOGCONFIG new.
	"Sizing to content is most similar to the legacy MessageBox."
	dwFlags := TDF_SIZE_TO_CONTENT.
	"The TaskDialog API does not have the behaviour of the MessageBox API that it will re-enable a disabled owner, so we don't need to worry about that."
	hwndOwner := self ownerHandle.
	"Positioning the dialog relative to the owner window is preferable when working with multiple screens."
	(User32 isWindowVisible: hwndOwner)
		ifTrue: 
			[(User32 isIconic: hwndOwner) ifTrue: [User32 showWindow: hwndOwner nCmdShow: SW_RESTORE].
			dwFlags := dwFlags bitOr: TDF_POSITION_RELATIVE_TO_WINDOW].
	struct hwndParent: hwndOwner.
	icon
		ifNil: [struct hMainIcon: self iconId]
		ifNotNil: 
			[struct hMainIcon: icon asParameter.
			dwFlags := dwFlags bitOr: TDF_USE_HICON_MAIN].
	buttons := self buttonIds.
	struct dwCommonButtons: (buttons inject: 0
				into: [:buttonFlags :each | buttonFlags bitOr: (CommonButtonFlags at: each)]).
	struct nDefaultButton: (buttons at: self defaultButton).
	title := self caption asUtf16String.
	struct pszWindowTitle: title.
	self text ifNotNil: [:content | struct pszContent: content].
	self headline ifNotNil: [:main | struct pszMainInstruction: main].
	footerIcon
		ifNotNil: 
			[struct hFooterIcon: footerIcon asParameter.
			dwFlags := dwFlags bitOr: TDF_USE_HICON_FOOTER].
	self footerText ifNotNil: [:footer | struct pszFooter: footer].
	self checkboxText ifNotNil: [:verificationText | struct pszVerificationText: verificationText].
	self detailsText
		ifNotNil: [:expandedInformation | struct pszExpandedInformation: expandedInformation].
	self expandLabel
		ifNotNil: [:collapsedControlText | struct pszCollapsedControlText: collapsedControlText].
	self collapseLabel
		ifNotNil: [:expandedControlText | struct pszExpandedControlText: expandedControlText].
	callback := self notificationCallback.
	struct pfCallback: callback asParameter.
	verified ifTrue: [dwFlags := dwFlags bitOr: TDF_VERIFICATION_FLAG_CHECKED].
	struct dwFlags: dwFlags.
	self showIndirect: struct.
	callback free.
	^button!

beFatalError
	"Set the receiver's style such that the receiver opens as a fatal error message (e.g. for out of resource situations)."

	self
		iconStyle: #error;
		beSystemModal!

beSystemModal
	"Set the receiver's style so that it is system modal (i.e. all top level windows are disabled) when opened. Since this option disables all other applications, it should be used only when catastrophic errors occur which require immediate user attention. N.B. Should be combined with #error to prevent activation messages being sent to the parent window when opened."

	self modality: #system!

beTaskModal
	"Set the receiver's style so that it is task modal (i.e. all top level Dolphin windows are disabled) when opened. Other applications are unaffected."

	self modality: #task.
	self setForeground!

buttonIds
	^##((Array new: 7)
		at: MB_OK + 1 put: {IDOK};
		at: MB_OKCANCEL + 1 put: {IDOK. IDCANCEL};
		at: MB_ABORTRETRYIGNORE + 1 put: {IDCANCEL. IDRETRY. IDOK};
		at: MB_YESNOCANCEL + 1 put: {IDYES. IDNO. IDCANCEL};
		at: MB_YESNO + 1 put: {IDYES. IDNO};
		at: MB_RETRYCANCEL + 1 put: {IDRETRY. IDCANCEL};
		at: MB_CANCELTRYCONTINUE + 1 put: {IDCANCEL. IDRETRY. IDOK};
		yourself) at: self buttonStyleValue + 1!

buttonStyle
	"Answer the symbolic name of the button style to be used in the message box (one of: #ok, #okCancel, #yesNo, #yesNoCancel #abortRetryIgnore, #retryCancel, #cancelRetryContinue)"

	^ButtonStyles keyAtValue: self buttonStyleValue!

buttonStyle: aSymbol
	aSymbol == #abortRetryIgnore
		ifTrue: 
			[| sender |
			sender := Processor activeProcess topFrame sender sender.
			Notification
				signal: 'MessageBox button style #abortRetryIgnore is deprecated (use #cancelRetryContinue). Sent from: '
						, sender method printString].
	self setStyle: (ButtonStyles at: aSymbol) maskedBy: MB_TYPEMASK!

buttonStyleValue
	^styleFlags bitAnd: MB_TYPEMASK!

checkboxText
	"Answer the text to be displayed as the receiver's verification text (i.e. the checkbox label)"

	^checkboxText ifNil: [self defaultCheckboxText]!

checkboxText: aString
	"Set the text to be displayed as the receiver's verification text (i.e. the checkbox label)."

	"This text cannot be changed once the dialog is open"
	checkboxText := aString ifNotNil: [aString asUtf16String].
	"In theory the text can be changed after the message box is opened, e.g. from an event handler, but this does not appear to work."
	self setElement: TDE_FOOTER text: checkboxText!

collapseLabel
	"Answer the label `<string>` to be shown on the expando button when expanded, i.e. this is the label when the button will collapse the extra details."

	^collapseLabel!

collapseLabel: aString
	collapseLabel := aString ifNotNil: [aString asUtf16String]!

confirm
	self hasIcon ifFalse: [self iconStyle: #prompt].
	self buttonStyle: #yesNo.
	^self open == #yes!

confirm: aString
	"Display a message box with the specified `String` prompt, and Yes and No push buttons. Answer whether the user confirmed (by pressing the Yes button)."

	self text: aString.
	^self confirm!

confirm: aString onYes: yesValuable onNo: noValuable onCancel: cancelValuable
	"Prompt the user with a Yes/No/Cancel message box, answering the value of evaluating the appropriate <niladicValuable> argument based on their response."

	| response |
	response := self confirmOrCancel: aString.
	^(response == #cancel
		ifTrue: [cancelValuable]
		ifFalse: [response == #yes ifTrue: [yesValuable] ifFalse: [noValuable]]) value!

confirmOrCancel
	self hasIcon ifFalse: [self iconStyle: #prompt].
	self buttonStyle: #yesNoCancel.
	^self open!

confirmOrCancel: aString
	"Display a message box for the receiver with the prompt, aString, and Yes, No and Cancel push buttons. Answer one of the symbolic constants #yes, #no, or #cancel, according to the button pressed by the receiver."

	self text: aString.
	^self confirmOrCancel!

defaultablesKeyName
	^SessionManager current productRegistryKey , '\DontShowMeThisDialogAgain'!

defaultButton
	"Answer the one-based integer index of the default button."

	^((styleFlags bitAnd: MB_DEFMASK) >> 8) + 1!

defaultButton: anInteger
	"Set the one-based index of the default push button to be used when the receiver is opened. By default the first push button is the default button."

	(anInteger between: 1 and: 4)
		ifFalse: [^self error: ('Invalid default button index: <1p>' expandMacrosWith: anInteger)].
	self setStyle: anInteger - 1 << 8 maskedBy: MB_DEFMASK!

defaultButtonId
	^self buttonIds at: self defaultButton!

defaultCheckboxText
	"Private - Answer the text that will be displayed by default in a suppressible/defaultable message box alongside the suppression checkbox."

	^self isSuppressible
		ifTrue: 
			[(self isDefaultable
				ifTrue: ['Remember my answer and do not ask again']
				ifFalse: ['In the future, do not show me this dialog box']) asUtf16String]!

destroy
	"Destroy the message box as if cancelled."

	^User32 destroyWindow: handle!

detailsText
	"Answer the additional details text that can be displayed in the message box by pressing an expando button."

	^detailsText!

detailsText: aString
	"Set the additional details text that can be displayed in the message box when expanded."

	detailsText := aString ifNotNil: [aString asUtf16String].
	self setElement: TDE_EXPANDED_INFORMATION text: detailsText!

expandLabel
	"Answer the label `<string>` to be shown on the expando button when collapsed, i.e. this is the label when the button will cause the extra details to be shown."

	^expandLabel!

expandLabel: aString
	expandLabel := aString ifNotNil: [aString asUtf16String]!

footerIcon: anIcon
	"Set the receiver's footer icon to be the argument, anIcon. The Footer icon is only displayed if there is also footerText."

	footerIcon := anIcon asSmallIcon.
	self setElement: TDIE_ICON_FOOTER icon: footerIcon!

footerText
	"Answer the text to be displayed as the receiver's footer text, or nil if none."

	^footerText!

footerText: aString
	"Set the text to be displayed as the receiver's footer text."

	footerText := aString ifNotNil: [aString asUtf16String].
	self setElement: TDE_FOOTER text: footerText!

getDefaultButton
	| status buf |
	buf := ByteArray newFixed: 8.
	buf dwordAtOffset: 4 put: 4.
	status := AdvApi32
				regGetValue: HKEY_CURRENT_USER
				lpSubKey: self defaultablesKeyName
				lpValue: self uniqueId displayString
				dwFlags: RRF_RT_DWORD
				pdwType: nil
				pvData: buf
				pcbData: buf yourAddress + 4.
	^status == ERROR_SUCCESS ifTrue: [buf dwordAtOffset: 0]!

getEvents
	"Private - Answer the EventsCollection belonging to the receiver, or nil if the receiver
	has no events registered for it"

	^events!

getSuppressedDefault
	"Private - If the receiver is a suppressible/defaultable message, then answer the button id result to be used instead of showing the receiver. For defaultable messages, this will be whatever button the user chose when requesting that the dialog not be shown again. For suppressible dialogs, this will be the default button id, regardless of the user's choice when suppressing the dialog (which is for backwards compatibility, not because this is particularly user friendly)."

	"Implementation Note: Use the registry API directly, rather than going through the RegKey classes, to avoid taking a dependency."

	^self isSuppressible
		ifTrue: 
			["Unfortunately we can't really use the same registry area for the old 'suppressible' message box as our new 'defaultable' ones, because the SHMessageBoxCheck API that was historically used for the suppressible messages will ignore any suppression value for the id if the string value is not 'NO'."
			self isDefaultable
				ifTrue: [self getDefaultButton]
				ifFalse: [self isSuppressed ifTrue: [self defaultButtonId]]]!

globallyUniqueId
	^'<1d>:<2d>' expandMacrosWithArguments: {SessionManager current appIdString. self uniqueId}
		locale: Locale invariant!

handle
	"Answer the receiver's window handle. This is only available after the receiver has been opened."

	^handle!

hasOwner
	^self owner notNil and: [self owner ~= 0]!

headline
	"Answer the text to be displayed alongside the icon as the message headline."

	^headline!

headline: aString
	"Set the text to be displayed alongside the icon as the message headline. This is drawn in a larger font that the content text."

	headline := aString ifNotNil: [aString asUtf16String].
	"The text can be changed after the message box is opened, e.g. from an event handler, even if there was no header text initially. The dialog may relayout to accommodate the header."
	self setElement: TDE_MAIN_INSTRUCTION text: headline!

icon: anIcon
	"Set the receiver's icon to be the argument, anIcon."

	anIcon
		ifNil: 
			[icon := nil.
			self iconStyle: #notify]
		ifNotNil: 
			[icon := anIcon asLargeIcon.
			self iconStyle: #user]!

iconId
	"Private - Answer the Task Dialog common icon id for the receiver. Used if there is no custom icon set."

	"Note that we can also use the standard system icon id's here, because these ID's are valid for a null HINSTANCE, hence IDI_QUESTION for prompts."

	^##(IdentityDictionary new
		at: #none put: 0;
		at: #error put: TD_ERROR_ICON;
		at: #warning put: TD_WARNING_ICON;
		at: #notify put: TD_INFORMATION_ICON;
		at: #prompt put: IDI_QUESTION;
		shrink;
		yourself) at: self iconStyle!

iconStyleFlag
	"Private - Answer the icon style bits from the receiver's style mask."

	^styleFlags bitAnd: MB_ICONMASK!

iconStyleFlag: anInteger
	anInteger == MB_USERICON ifFalse: [icon := nil].
	self setStyle: anInteger maskedBy: MB_ICONMASK!

idOfButtonAt: anInteger 
	^self buttonIds at: anInteger!

initialize
	"Private - Initialize the receiver's instance variables."

	flags := styleFlags := 0.
	verified := false!

isChecked
	^verified!

isChecked: aBoolean
	verified := aBoolean!

isDefaultable
	"Answer whether this message box will be give the user the option to remember their response and use that in future without showing the message."

	^(flags allMask: DefaultableMask) and: [self uniqueId notNil]!

isDefaultable: aBoolean
	"Set whether this message box will give the user the option of remembering their response for occurrences with the same uniqueId in the future."

	"Note that this flag is ignored unless the uniqueId associated with this particular message box is also set."

	flags := flags mask: DefaultableMask set: aBoolean!

isSuppressed
	"Answer whether this message has been previously suppressed by the current user."

	| isSuppressed sizeBuf status buf |
	buf := Utf16String newFixed: 2.	"Note that the value must be 'NO'. Anything else appears to be ignored."
	sizeBuf := ByteArray newFixed: 4.
	sizeBuf dwordAtOffset: 0 put: buf byteSize.
	status := AdvApi32
				regGetValue: HKEY_CURRENT_USER
				lpSubKey: self suppressionsKeyName
				lpValue: self globallyUniqueId
				dwFlags: RRF_RT_REG_SZ
				pdwType: nil
				pvData: buf
				pcbData: sizeBuf.
	isSuppressed := status == ERROR_SUCCESS and: [buf = 'NO'].
	^isSuppressed!

isSuppressible
	"Answer whether this message box will be give the user the option of not seeing further occurrences with the same uniqueId in the future."

	^(flags allMask: SuppressibleMask) and: [self uniqueId notNil]!

isSuppressible: aBoolean
	"Set whether this message box will give the user the option of not seeing further occurrences with the same uniqueId in the future."

	"Note that this flag is ignored unless the uniqueId associated with this particular message box is also set."

	flags := flags mask: SuppressibleMask set: aBoolean!

isTaskModal
	"Answer whether the receiver is task modal (i.e. modal to all windows in the application not just the active one)."

	^styleFlags allMask: MB_TASKMODAL!

modality
	"Answer the symbolic name of the receiver's modal style (one of #application, #task, or #system). "

	^ModeStyles keyAtValue: self modeMask!

modality: aSymbol
	"Set the receiver's modal style to that named by the argument, which must be one of #application, #task, or #system.
	  - #application modal message boxes are modal only to the owner window and spawn the message box on a background thread in order to allow the rest of the system to operate normally.
	  - #task modal message boxes are intended to be modal to the whole Dolphin application, and spawn the message box on the main UI thread, which means that the message box has control of the main message loop. This has certain consequences, such as disabling keyboard accelerators."

	self setStyle: (ModeStyles at: aSymbol) maskedBy: MB_MODEMASK!

modeMask
	^styleFlags bitAnd: MB_MODEMASK!

notificationCallback
	^Callback block: 
			[:hWnd :msg :wParam :lParam :lpRefData |
			handle := hWnd.
			(#(#tdnCreated:lParam: #tdnNavigated:lParam: #tdnButtonClicked:lParam: #tdnHyperlinkClicked:lParam: #tdnTimer:lParam: #tdnDestroyed:lParam: #tdnRadioButtonClicked:lParam: #tdnDialogConstructed:lParam: #tdnVerificationClicked:lParam: #tdnHelp:lParam: #tdnExpandoButtonClicked:lParam:)
				lookup: msg + 1)
					ifNil: [S_OK]
					ifNotNil: 
						[:selector |
						self
							perform: selector
							with: wParam
							with: lParam]]
		descriptor: (FunctionDescriptor returnType: 'hresult'
				argumentTypes: 'handle dword uintptr  intptr intptr')!

open
	"Display a Windows Task Dialog for the receiver, and answer a portable symbolic constant  for the button pressed by the user."

	button := self getSuppressedDefault ifNil: [self basicOpen].
	^self result!

result
	"Answer the symbolic name of the clicked button."

	^#(#ok #cancel #abort #retry #ignore #yes #no #close #help #retry #ignore) at: button!

saveDefaultButton
	"Private - Remember the user's answer so that this will be used in future without displaying the message box."

	| value |
	value := ByteArray new: 4.
	value dwordAtOffset: 0 put: button.
	"Use the registry API directly to reduce dependencies."
	AdvApi32
		regSetKeyValue: HKEY_CURRENT_USER
		lpSubKey: self defaultablesKeyName
		lpValueName: self uniqueId displayString
		dwType: REG_DWORD
		lpData: value
		cbData: 4!

saveSuppressed
	"Private - Store dialog suppression in the registry at the location and format expected by SHMessageBoxCheck"

	"Use the registry API directly to reduce dependencies."

	AdvApi32
		regSetKeyValue: HKEY_CURRENT_USER
		lpSubKey: self suppressionsKeyName
		lpValueName: self globallyUniqueId
		dwType: REG_SZ
		lpData: ##('NO' asUtf16String)
		cbData: 6!

saveSuppressedDefault
	self isSuppressible
		ifTrue: 
			[self isDefaultable
				ifTrue: [self saveDefaultButton]
				ifFalse: 
					["The dialog will be suppressed in future and will always answer the default button, even if a different button was pressed this time."
					self saveSuppressed]]!

setElement: anInteger icon: anIcon
	"Private - Note that the icon can only be updated by handle if originally set to a specific icon."

	handle
		ifNotNil: 
			[User32
				sendMessage: handle
				msg: TDM_UPDATE_ICON
				wParam: anInteger
				lParam: anIcon asParameter]!

setElement: anInteger text: aUtf16String
	"Private - Update the text of the specified element. Causes the dialog to relayout to accomodate the next text."

	handle
		ifNotNil: 
			[User32
				sendMessage: handle
				msg: TDM_SET_ELEMENT_TEXT
				wParam: anInteger
				lpParam: aUtf16String]!

setEvents: anEventsCollectionOrNil 
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil. Answer the receiver."

	events := anEventsCollectionOrNil.
	^self!

setForeground
	"Set the receiver's style such that the receiver opens in the foreground."

	styleFlags := styleFlags mask: MB_SETFOREGROUND set: true!

setStyle: anInteger maskedBy: maskInteger 
	styleFlags := (styleFlags maskClear: maskInteger) maskSet: (anInteger bitAnd: maskInteger)!

showIndirect: aTASKDIALOGCONFIG
	| buf |
	buf := ByteArray newFixed: 12.
	self isTaskModal
		ifTrue: 
			[| hwndParent enabled |
			"Note that we don't need to use the Dolphin idle timer because the dialog offers its own rapid timer notification"
			aTASKDIALOGCONFIG dwFlags: (aTASKDIALOGCONFIG dwFlags bitOr: TDF_CALLBACK_TIMER).
			"Unfortunately TaskDialogs do not provide similar functionality to MB_TASKMODAL, so we have to disable all the top-level Windows ourselves."
			hwndParent := aTASKDIALOGCONFIG hwndParent.
			enabled := SessionManager inputState topLevelWindows select: 
							[:each |
							"We let the dialog manage enablement of the owner view so that it doesn't lose focus when the dialog is closed."
							each handle ~= hwndParent and: 
									[| isEnabled |
									isEnabled := each isEnabled.
									each isEnabled: false.
									isEnabled]].
			
			[CommCtrlLibrary default
				taskDialogIndirect: aTASKDIALOGCONFIG
				pnButton: buf yourAddress
				pnRadioButton: buf yourAddress + 4
				pfVerificationFlagChecked: buf yourAddress + 8]
					ensure: [enabled do: [:each | each isEnabled: true]]]
		ifFalse: 
			["Open the dialog using an overlapped call on a separate thread to avoid losing control of the message loop. We don't need an idle timer at all in this case."

			"If the initiating process is the UI process then its priority is boosted so that the operation requested by the user completes more quickly when the dialog is closed."
			Processor forkMainIfMain
				ifTrue: 
					[| proc |
					proc := Processor activeProcess.
					proc priority: proc priority + 1].
			CommCtrlLibrary default
				overlappedTaskDialogIndirect: aTASKDIALOGCONFIG
				pnButton: buf yourAddress
				pnRadioButton: buf yourAddress + 4
				pfVerificationFlagChecked: buf yourAddress + 8].
	button := buf sdwordAtOffset: 0.
	verified := (buf dwordAtOffset: 8) ~~ 0.
	(verified and: [self isSuppressible]) ifTrue: [self saveSuppressedDefault]!

suppressionsKeyName
	^'Software\Microsoft\Windows\CurrentVersion\Explorer\DontShowMeThisDialogAgain'!

tdnButtonClicked: wParamInteger lParam: lParamInteger
	"Private - One of the task dialog buttons has been clicked. The wParam is the button id. Normally a button click will close the task dialog, but answering S_FALSE will prevent that."

	| value |
	"Event handlers can set the accept value to false to ignore the button click and prevent the message box from closing."
	value := true asValue.
	self
		trigger: #buttonClicked:accept:
		with: wParamInteger
		with: value.
	^value value ifTrue: [S_OK] ifFalse: [S_FALSE]!

tdnCreated: wParamInteger lParam: lParamInteger
	"Private - Like TDN_DIALOG_CONSTRUCTED, this notification is received when the dialog has been created but before it is displayed. The docs are not clear on the difference between the two, but TDN_DIALOG_CONSTRUCTED is received first."

	"Transcript nextPutAll: 'TDN_CREATED: Active view: '; print: View active; nextPutAll: ', foreground view: '; print: View foreground; cr."
	self trigger: #created.
	^S_OK!

tdnDestroyed: wParamInteger lParam: lParamInteger
	"Private - The task dialog has been destroyed."

	handle := nil.
	self trigger: #destroyed.
	^S_OK!

tdnDialogConstructed: wParamInteger lParam: lParamInteger
	"Private - The task dialog box has been created, but not yet displayed. The box will have a handle by this point."

	"Transcript nextPutAll: 'TDN_DIALOG_CONSTRUCTED: Active view: '; print: View active; nextPutAll: ', foreground view: '; print: View foreground; cr."
	self trigger: #dialogConstructed.
	^S_OK!

tdnExpandoButtonClicked: wParamInteger lParam: lParamInteger
	"Private - The expand/collapse button has been clicked. It is not possible to prevent the expand/collapse operation. The event argument is true if the dialog is expanded."

	self trigger: #expandoClicked: with: wParamInteger asBoolean.
	^S_OK!

tdnHelp: wParamInteger lParam: lParamInteger
	"Private - The user has pressed F1 while the task dialog has focus."

	self trigger: #help.
	^S_OK!

tdnHyperlinkClicked: wParamInteger lParam: lParamInteger
	"Private - A hyperlink in the task dialog text has been clicked."

	self trigger: #hyperlinkClicked: with: (Utf16String fromAddress: lParamInteger).
	^S_OK!

tdnNavigated: wParamInteger lParam: lParamInteger
	self trigger: #navigated.
	^S_OK!

tdnRadioButtonClicked: wParamInteger lParam: lParamInteger
	"Private - A radio button in the task dialog has been clicked. The argument to the event is the clicked radio button's id."

	self trigger: #radioButtonClicked: with: wParamInteger.
	^S_OK!

tdnTimer: wParamInteger lParam: lParamInteger
	"Private - The task dialog timer has fired, which it does about every 200mS (according to the docs). The wParam is the number of milliseconds since the task dialog was opened."

	"We must not enter idle if the dialog is owned by a thread other than the main Dolphin thread. Entering idle actually means putting the main Dolphin UI process to sleep waiting on the input Semaphore. If the task dialog window that originated this notification is owned by another thread, e.g. because it was launched overlapped, then it will curently be waiting on a cross-thread call into the main Dolphin thread that is running this method to process the notification (Smalltalk code can only run on the Dolphin main thread). If we block now the call will not be able to return, and the originating thread will also be blocked. The Dolphin VM samples the input queue of its own main thread, and eventually when there is no input waiting the idle process will quiesce the main thread completely by calling MsgWaitForMultipleObjectsEx. Neither the sampling, nor the MsgWaitForMultipleObjectsEx API, will detect input events for foreign threads. As the Dolphin main thread will remain suspended. the foreign window will remain blocked awaiting this notification handler to return, and the dialog will appear non-responsive. It would only be able to start responding again if some Dolphin window has pending events waking up the main UI process, which would in turn allow this call to return back to the dialog's thread, resuming normal service."

	(User32 getWindowThreadProcessId: handle lpdwProcessId: nil) = Kernel32 getCurrentThreadId
		ifTrue: [SessionManager inputState enterIdle].
	^S_OK!

tdnVerificationClicked: wParamInteger lParam: lParamInteger
	"Private - The task dialog verification check box has been clicked. The argument to the event is true if the checkbox is checked, else false."

	self trigger: #verificationClicked: with: wParamInteger asBoolean.
	^S_OK!

text: aString
	"Set the content text to be displayed message content under the header text (if any). This is equivalent to the main text of an old-style message box, and is drawn in a smaller font that the header text.
	The text can be changed after the message box is opened, e.g. from an event handler, even if there was no content text initially."

	super text: aString.
	self setElement: TDE_CONTENT text: text!

uniqueId
	"Answer the unique id that, should the user decide to suppress this message box, will be stored in the registry. If the message box is suppressible, the id is stored under the key:
		HKCU/Software/Microsoft/Windows/CurrentVersion/Explorer/DontShowMeThisDialogAgain 
	This is a global area used by all applications, so the id has to be unique. The class attempts to assist you in this by pre-pending this unique id with the GUID of the SessionManager class, which is the closest thing to a unique id for each Dolphin application. A good choice for the unique id is then the full name of the method displaying the message box. Note that if the id is nil the message box will not be suppressible."

	^uniqueId!

uniqueId: anObject
	uniqueId := anObject displayString: Locale invariant!

updateElement: anInteger text: aUtf16String
	"Private - Update the text of the specified element. This does not relayout, so if there is insufficient space the text may be clipped."

	handle
		ifNotNil: 
			[User32
				sendMessage: handle
				msg: TDM_UPDATE_ELEMENT_TEXT
				wParam: anInteger
				lpParam: aUtf16String]!

wibble! !
!UI.MessageBox categoriesForMethods!
assertStylesValid!helpers!private! !
basicOpen!displaying!private! !
beFatalError!accessing-styles!public! !
beSystemModal!accessing-styles!public! !
beTaskModal!accessing-styles!public! !
buttonIds!constants!private! !
buttonStyle!accessing-styles!public! !
buttonStyle:!accessing-styles!public! !
buttonStyleValue!accessing!private! !
checkboxText!accessing!public! !
checkboxText:!accessing!public! !
collapseLabel!accessing!public! !
collapseLabel:!accessing!public! !
confirm!operations!public! !
confirm:!operations!public! !
confirm:onYes:onNo:onCancel:!displaying!public! !
confirmOrCancel!displaying!public! !
confirmOrCancel:!displaying!public! !
defaultablesKeyName!constants!private! !
defaultButton!accessing!public! !
defaultButton:!initializing!public! !
defaultButtonId!accessing!private! !
defaultCheckboxText!constants!private! !
destroy!private!realizing/unrealizing! !
detailsText!accessing!public! !
detailsText:!accessing!public! !
expandLabel!accessing!public! !
expandLabel:!accessing!public! !
footerIcon:!accessing!public! !
footerText!accessing!public! !
footerText:!accessing!public! !
getDefaultButton!helpers!private! !
getEvents!events!private! !
getSuppressedDefault!helpers!private! !
globallyUniqueId!helpers!private! !
handle!accessing!public! !
hasOwner!displaying!private! !
headline!accessing!public! !
headline:!accessing!public! !
icon:!accessing!public! !
iconId!helpers!private! !
iconStyleFlag!accessing-styles!private! !
iconStyleFlag:!accessing-styles!private! !
idOfButtonAt:!helpers!private! !
initialize!initializing!private! !
isChecked!public!testing! !
isChecked:!accessing!public! !
isDefaultable!public!testing! !
isDefaultable:!initializing!public! !
isSuppressed!helpers!public! !
isSuppressible!public!testing! !
isSuppressible:!initializing!public! !
isTaskModal!public!testing! !
modality!accessing-styles!public! !
modality:!accessing-styles!public! !
modeMask!accessing-styles!private! !
notificationCallback!helpers!private! !
open!displaying!public! !
result!accessing!public! !
saveDefaultButton!helpers!private! !
saveSuppressed!helpers!private! !
saveSuppressedDefault!helpers!private! !
setElement:icon:!helpers!private! !
setElement:text:!operations!private! !
setEvents:!events!private! !
setForeground!accessing-styles!public! !
setStyle:maskedBy:!accessing-styles!private! !
showIndirect:!displaying!private! !
suppressionsKeyName!constants!private! !
tdnButtonClicked:lParam:!event handling!private! !
tdnCreated:lParam:!event handling!private! !
tdnDestroyed:lParam:!event handling!private! !
tdnDialogConstructed:lParam:!event handling!private! !
tdnExpandoButtonClicked:lParam:!event handling!private! !
tdnHelp:lParam:!event handling!private! !
tdnHyperlinkClicked:lParam:!event handling!private! !
tdnNavigated:lParam:!event handling!private! !
tdnRadioButtonClicked:lParam:!event handling!private! !
tdnTimer:lParam:!event handling!private! !
tdnVerificationClicked:lParam:!event handling!private! !
text:!accessing!public! !
uniqueId!accessing!public! !
uniqueId:!initializing!public! !
updateElement:text:!operations!private! !
wibble!accessing-styles!public! !
!

UI.MessageBox methodProtocol: #wibble attributes: #() selectors: #(#wibble)!

!UI.MessageBox class methodsFor!

confirm: aString
	"Display a Windows Task Dialog configured like a Message Box, prompting for confirmation of the <readableString> argument. Answer whether the user confirmed (by pressing the Yes button). The caption will be filled in from the defaults later."

	^self confirm: aString caption: nil!

confirm: promptString caption: titleString
	"Display a Windows Task Dialog configured as a Message Box, prompting for confirmation of the <readableString> question, promptString , with the <readableString> caption, titleString."

	^self new
		caption: titleString;
		confirm: promptString!

confirm: aString onYes: yesValuable onNo: noValuable onCancel: cancelValuable
	"Prompt the user with a Yes/No/Cancel message box, answering the value of evaluating the appropriate <niladicValuable> argument based on their response."

	^self new
		confirm: aString
		onYes: yesValuable
		onNo: noValuable
		onCancel: cancelValuable!

initialize
	"Private - Initialize the class variables of the receiver:
		MessageBox initialize
	"

	self addClassConstant: 'ButtonStyles'
		value: (IdentityDictionary new
				at: #ok put: MB_OK;
				at: #okCancel put: MB_OKCANCEL;
				at: #abortRetryIgnore put: MB_ABORTRETRYIGNORE;
				at: #yesNoCancel put: MB_YESNOCANCEL;
				at: #yesNo put: MB_YESNO;
				at: #retryCancel put: MB_RETRYCANCEL;
				at: #cancelRetryContinue put: MB_CANCELTRYCONTINUE;
				shrink;
				yourself).
	self addClassConstant: 'ModeStyles'
		value: (IdentityDictionary new
				at: #application put: MB_APPLMODAL;
				at: #task put: MB_TASKMODAL;
				at: #system put: MB_SYSTEMMODAL;
				shrink;
				yourself).
	self addClassConstant: 'CommonButtonFlags'
		value: ((Array new: 11)
				at: IDOK put: TDCBF_OK_BUTTON;
				at: IDCANCEL put: TDCBF_CANCEL_BUTTON;
				at: IDABORT put: TDCBF_CANCEL_BUTTON;
				at: IDRETRY put: TDCBF_RETRY_BUTTON;
				at: IDIGNORE put: TDCBF_OK_BUTTON;
				at: IDYES put: TDCBF_YES_BUTTON;
				at: IDNO put: TDCBF_NO_BUTTON;
				at: IDCLOSE put: TDCBF_CLOSE_BUTTON;
				at: IDHELP put: nil;
				at: IDTRYAGAIN put: TDCBF_RETRY_BUTTON;
				at: IDCONTINUE put: TDCBF_OK_BUTTON;
				yourself)! !
!UI.MessageBox class categoriesForMethods!
confirm:!instance creation!public! !
confirm:caption:!instance creation!public! !
confirm:onYes:onNo:onCancel:!instance creation!public! !
initialize!development!initializing!private! !
!

