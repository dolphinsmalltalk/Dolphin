"Filed out from Dolphin Smalltalk"!

UI.MessageBoxAbstract
	subclass: #'UI.MessageBox'
	instanceVariableNames: 'handle events flags uniqueId modality iconStyle icon headline detailsText expandLabel collapseLabel checkboxText footerIcon footerText buttonStyle defaultButton customButtons buttonNames buttonIds radioButtons defaultRadioButton progressRange verified button radioButtonId'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants private} #{OS.TaskDialogConstants private} #{OS.Win32Errors private} #{OS.WinRegConstants private})
	classInstanceVariableNames: ''
	classConstants: {
			'CommonButtonFlags' -> #(16r1 16r8 16r0 16r10 16r0 16r2 16r4 16r20 16r0 16r0 16r0).
			'DefaultableMask' -> 16r30000000.
			'StandardButtonNames'
				-> #(#ok #cancel #abort #retry #ignore #yes #no #close #help #retry #ignore).
			'SuppressibleMask' -> 16r10000000.
			'TDF_Mask' -> 16r1FFFFFF.
			'TopMostMask' -> 16r40000000
		}!
UI.MessageBox guid: (Core.GUID fromString: '{87b4c49f-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.MessageBox comment: '`MessageBox` provides a convenient dialog abstraction for posing short questions, and reporting notifications, warnings, or errors.

`MessageBox` is implemented using the [Windows TaskDialog](https://docs.microsoft.com/en-us/windows/win32/controls/task-dialogs) control. TaskDialog offers significantly more functionality and greater flexibility than the traditional Windows MessageBox:
  - Task dialogs can be centred over the owner window, providing a better user experience, especially with multiple monitors. A standard MessageBox only ever opens in the centre of the primary monitor and the only way to change this behaviour is to use a window hook.
  - Optional Checkbox functionality is ideal for implementing messages that can be suppressed by the user. Unlike the old `SHMessageBoxCheck` API this can be used to implement _Remember this answer_ functionality (defaultable), as opposed to just _Don''t show me this again_ (suppressible). The checkbox text (aka verificationText) can be configured as desired. It does not just have to be used for defaulting functionality, although if used for defaulting it is not available for other purposes.
  - Icons can be supplied as an icon handle (HICON), as opposed to by specifying a resource id and module. This allows use of icons that are not in resources such as `TextTileIcon`s, etc. Task dialogs can be displayed without any icon.
  - Optional headline text can be displayed, as well as the message content text. The headline text is emphasised. The style depends on the theme, but typically it will be a larger font and in a highlight colour. In more recent versions of Windows, the headline text is often used alone.
  - There is an optional footer text area (see `#footerText`), which can include a small icon (see `#footerIcon`). This is useful for things like tips or notes for the users attention.
  - Optional extra detail text can be included that is can be hidden/shown by means of an expando button. The labels of the expand/collapse button are customisable.
  - Custom buttons can be added; see `#customButtons:`. These can either replace the labels of the built-in (aka common) buttons, or add entirely new buttons. The ability to relabel the built-in buttons can be used to reduce ambiguity as to the result of the button selection, or the need for explanatory text.
  - Custom buttons can be of [BS_COMMANDLINK](https://docs.microsoft.com/en-us/windows/win32/controls/button-styles) style. Note text can be associated with each "command link" button by adding a third element to the button description array.
  - An optional progress bar.
  - Optional radio buttons; see `#radioButtons:`
  - The buttons can be enabled and disabled by the application (basic support is provided, but no high-level abstractions such as integration into the command system).

There are some aspects of Windows MessageBox functionality that are missing from TaskDialog, although most have been emulated in the Smalltalk layer:
  - Task/System modality, i.e. disablement of all windows in the application when the dialog is shown. Implemented in Smalltalk by disabling and re-enabling top-level Dolphin windows.
  - Some buttons are no longer provided, e.g. Abort/Retry/Ignore. These have all been implemented with custom buttons. so there are compatible button styles available.
  - TaskDialogs ignore tabs in the text, unlike the basic Windows MessageBox, so this can affect the appearance of existing messages that use tabs for indentation. This is a visual compatibility break.
  - Message boxes had a `MB_SETFOREGROUND` flag. If this was not specified, then opening a MessageBox with an inactive owner did not make the message box the foreground window. The equivalent (but inverse) TaskDialog flag, `TDF_NO_SET_FOREGROUND`, does not appear to work and the dialog is always made foreground.
  - There is no equivalent of `MB_TOPMOST`, but we can emulated this by making the task dialog top-most after creation.
  - There is no ''Help'' common button. This can be simulated by adding a custom button, but because the task dialog always displays all custom buttons first, the Help button would not appear as the last button, as it does in the standard MessageBox, unless all the buttons are custom buttons. The dialog does send a help notification (see `#tdnHelp:lParam:`) if F1 is pressed. As Dolphin has not historically supported the `MB_HELP` flag, it is left to the application to add a custom Help button if desired.

Example usage:

```
	MessageBox confirm: ''Would you like a cup of tea?''.
	MessageBox warning: ''Contents are hot''.
	MessageBox errorMsg: ''You''''ve burned yourself''.

	"Create an instance for complete flexibility"
	MessageBox new
		buttonStyle: #yesNo;
		customButtons: #((#yes ''&Yes please'') #(#no ''&No thank you''));
		icon: (TextTileIcon text: $☕);
		headline: ''How about a copy of coffee then?'';
		hasLinkButtons: true;
		open
```

`MessageBox`s can also be configured so that they are suppressible by the user. Suppressible message boxes includes a checkbox that the user can tick if they don''t want to see the message again. Subsequent attempts to display the same message (as identified by the `uniqueId`) will result in the immediate return of the default button value. There are two forms of suppressible message box. The first is the `isSuppressible` style and provides _Don''t show me this again_ functionality. When suppressed `isSuppressible` messages will always return the default button value, regardless of the choice the user made when suppressing the dialog. The second, new in Dolphin 8, is the `isDefaultable` style, providing _Remember this answer_ functionality. When suppressed `isDefaultable` messages will return the button value for the choice that the user made when suppressing the dialog. In other words the older `isSuppressible` style can be used for cases where the user may not wish to see the dialog again. The `isDefaultable` style is useful for cases where one wants to make a one-off choice. To avoid confusion it is recommended that `isSuppressible` (i.e. _Don''t show me this again_) messages are reserved for cases where the user only needs to acknowledge the message, rather than make a choice. 

For compatibility with message boxes shown by the [SHMessageBoxCheck API](https://docs.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-shmessageboxcheckw) API (as used in versions of Dolphin prior to 8) when an `isSuppressible` message box is suppressed by the user, a value is written under _HKCU/Software/Microsoft/Windows/CurrentVersion/Explorer/DontShowMeThisDialogAgain_. The value is named after the `uniqueId` set when the message box was opened, prepended with the GUID of the Dolphin application (i.e. the GUID of the `SessionManager` class).

Defaultable message boxes also write a registry value to preserve the choice on a per-user basis, but this time under _HKCU/Software/<product registry key>/DontShowMeThisDialogAgain_. The registry value is a `REG_DWORD`, and its value is the id of the user''s button selection when suppressing the dialog (i.e. the remembered answer).

##Instance Variables:
  `handle`			`External.Handle` of the task dialog window, when open
  `events`			`EventsCollection`. Event storage.
  `flags`			`<integer>`. Miscellaneous flags, mainly from the `TDF_XXX` enumeration.
  `uniqueId`		`Object`. The display string of this object is used to uniquely identify (within an application) a particular suppressible message box instance.
  `iconStyle`		`Symbol`. Identifies the icon style for the dialog to be one error, warning, notification, or prompt (standard icons), user (custom icon), or none (no icon)
  `icon`			`Icon` displayed adjacent to the message box headline, if custom.
  `headline`		`String` text displayed as the header text (aka main text)
  `detailsText`		`String` text displayed as extra details text (aka expanded information)
  `expandLabel`	`String` label displayed on the extra detail expando button when collapsed
  `collapseLabel`	`String` label displayed on the extra detail expando button when expanded
  `checkboxText`	`String` label of the verification checkbox, e.g. used for suppressible messages, but can be used for other purposes in non-suppressible messages.
  `footerIcon`		`Icon` to be displayed in the footer of the message box, but only if there is also `footerText`
  `footerText`		`String` text displayed as the dialog footer text.
  `buttonStyle`		`Symbol`. Identifies the common button style, e.g. #abortRetryIgnore, or #none for no common buttons.
  `defaultButton`	`<integer>` 1-based index of the default button, numbered left to right.
  `customButtons`	`<sequencedReadableCollection>` of `Array`. The elements are 2 or 3 element `Array`s specifying the integer id, string label, and optional note text for each custom button.
  `buttonNames`	`OrderedCollection` of `Symbol`. Symbolic names of all the buttons (standard and custom) configured for the message box.
  `buttonIds`
  `progressRange`	`Interval` of `Integer` specifying the min/max values for the progress bar. If nil, no progress bar is displayed, unless a marquee progress bar is requested using `hasMarqueeProgress:`
  `verified`		`<boolean>` indicating whether the checkbox in the message box (if any) was checked when the dialog was last closed.
  `result`			`Symbol` identifying the button that was pressed (e.g. `#ok`)

##Class Constants:
  `CommonButtonFlags`		`<integer>` flag from the `TDCBF_XXX` corresponding to each of the standard buttons. The entry is zero for any buttons that are not directly supported.
  `StandardButtonNames`	`Array` of `Symbol`. Unique names of each of the standard buttons. Not all of these have a corresponding TaskDialog common button.
  `DefaultableMask`
  `SuppressibleMask`		`<integer>`. Masks in/out the suppressible flag from the `flags` instance variable.
  `TopMostMask`			`<integer>`. Masks in/out the top-most flag from the `flags` instance variable.
  `TDF_Mask`				`<integer>`. Masks for the TDF_XXX flags in the `flags` instance variable.
'!
!UI.MessageBox categoriesForClass!MVP-Views-Support! !
!UI.MessageBox methodsFor!

areLinksParsed
	"Answer whether hyperlinks in the text will be intepreted as links."

	^flags allMask: TDF_ENABLE_HYPERLINKS!

areLinksParsed: aBoolean
	"Set whether hyperlinks in the text will be intepreted as links."

	"To be notified of links being clicked observe the #hyperlinkClicked: event published by the receiver. The event argument is the href of the link that was clicked."

	flags := flags mask: TDF_ENABLE_HYPERLINKS set: aBoolean!

baseCustomButtons
	"Private - Some of the standard buttons that are supported by the old MessageBox API have not direct equivalent in the TaskDialog. However, we can emulated these by providing them as custom buttons."

	| style pairs |
	style := self buttonStyle.
	pairs := #().
	"The magic numbers for the button label resource strings in User32.dll are undocumented, but should be stable in practice."
	style == #abortRetryIgnore ifTrue: [pairs := #(#(#abort 802) #(#retry 803) #(#ignore 804))].
	style == #cancelRetryContinue
		ifTrue: 
			["Note that 'Try Again' is mapped to #retry, and 'Continue' to #ignore. MB_CANCELTRYCONTINUE is intended as a replacement for MB_ABORTRETRYIGNORE, so when the new flag was introduced it made some sense for Dolphin's MessageBox to map the two new buttons to the previous symbols, although an inconstistency was that the first, Cancel, button was not mapped to #abort. This behaviour is maintained for Dolphin 8."
			pairs := #(#(#cancel 801) #(#retry 809) #(#ignore 810))].
	^pairs collect: [:each | {each first. String fromResourceId: each second in: User32}]!

basicOpen
	"Private - Display a Win32 Task Dialog configured as a message box, and answer the Win32 Id of the button pressed by the user."

	| standardButtons dwFlags struct callback hwndOwner buttons buttonId |
	struct := OS.TASKDIALOGCONFIG new.
	"Sizing to content is most similar to the legacy MessageBox."
	dwFlags := flags bitAnd: TDF_Mask.
	"The TaskDialog API does not have the behaviour of the MessageBox API that it will re-enable a disabled owner, so we don't need to worry about that."
	hwndOwner := self ownerHandle.
	"Positioning the dialog relative to the owner window is preferable when working with multiple screens."
	(User32 isWindowVisible: hwndOwner)
		ifTrue: 
			[(User32 isIconic: hwndOwner) ifTrue: [User32 showWindow: hwndOwner nCmdShow: SW_RESTORE].
			dwFlags := dwFlags bitOr: TDF_POSITION_RELATIVE_TO_WINDOW].
	self isSetForeground
		ifFalse: 
			["Testing suggests this flag has no effect."
			dwFlags := dwFlags bitOr: TDF_NO_SET_FOREGROUND].
	struct
		hwndParent: hwndOwner;
		windowTitle: self caption;
		content: self text;
		mainInstruction: self headline;
		footer: self footerText;
		verificationText: self checkboxText;
		expandedInformation: self detailsText;
		collapsedControlText: self expandLabel;
		expandedControlText: self collapseLabel.
	icon
		ifNil: [struct hMainIcon: self iconId]
		ifNotNil: 
			[struct hMainIcon: icon asParameter.
			dwFlags := dwFlags bitOr: TDF_USE_HICON_MAIN].
	footerIcon
		ifNotNil: 
			[struct hFooterIcon: footerIcon asParameter.
			dwFlags := dwFlags bitOr: TDF_USE_HICON_FOOTER].
	buttons := self buildCustomButtonIdsAndLabels.
	standardButtons := self standardButtonIds.
	"Common buttons can be replaced with custom buttons with different labels (or removed the custom button with the same symbolic name has an empty label)."
	standardButtons := standardButtons difference: (buttons collect: [:each | each first]).
	struct
		dwCommonButtons: (standardButtons inject: 0
					into: [:buttonFlags :each | buttonFlags bitOr: (CommonButtonFlags at: each)]);
		nDefaultButton: self defaultButtonId;
		buttons: buttons;
		radioButtons: radioButtons.
	defaultRadioButton
		ifNil: [dwFlags := dwFlags bitOr: TDF_NO_DEFAULT_RADIO_BUTTON]
		ifNotNil: [struct nDefaultRadioButton: defaultRadioButton].
	callback := self notificationCallback.
	struct pfCallback: callback asParameter.
	verified ifTrue: [dwFlags := dwFlags bitOr: TDF_VERIFICATION_FLAG_CHECKED].
	progressRange ifNotNil: [dwFlags := dwFlags bitOr: TDF_SHOW_PROGRESS_BAR].
	struct dwFlags: dwFlags.
	buttonId := self showIndirect: struct.
	callback free.
	^buttonId!

beFatalError
	"Set the receiver's style such that the receiver opens as a fatal error message (e.g. for out of resource situations)."

	self
		iconStyle: #error;
		beSystemModal!

beSystemModal
	"Set the receiver's style so that it is system modal. In earlier versions of Windows, System Modal message boxes were used for fatal system level errors that needed the user's immediate attention. This is no longer relevant from an application point of view today. The most significant way we can recognise this is to make the message box top-most. This doesn't prevent it losing activation, but does mean that it will always remain at the top of the z-order."

	self modality: #system.
	self
		isSetForeground: true;
		isTopMost: true!

beTaskModal
	"Set the receiver's style so that it is task modal (i.e. all top level Dolphin windows are disabled) when opened. Other applications are unaffected."

	self modality: #task.
	self isSetForeground: true!

buildCustomButtonIdsAndLabels
	| buttons |
	buttonNames := OrderedCollection withAll: StandardButtonNames.
	"We have to merge together the common and custom buttons. Custom buttons take precedence over common buttons with the same symbolic names."
	buttons := self mergedCustomButtons collect: 
					[:pair |
					| name id |
					name := pair first.
					id := StandardButtonNames identityIndexOf: name.
					id == 0
						ifTrue: 
							[buttonNames addLast: name.
							id := buttonNames size].
					pair copy
						at: 1 put: id;
						yourself].
	buttonIds := buttons collect: [:each | each first].
	"The control always displays any custom buttons passed in through the pButtons field of the TASKDIALOGCONFIG structure first, and then any common buttons."
	buttonIds := buttonIds , (self standardButtonIds difference: buttonIds).
	^buttons!

buttonIds
	^buttonIds
		ifNil: 
			[self buildCustomButtonIdsAndLabels.
			buttonIds]!

buttonNames
	^buttonNames
		ifNil: 
			[self buildCustomButtonIdsAndLabels.
			buttonNames]!

buttonStyle
	"Answer the symbolic name of the button style to be used in the message box (one of: #ok, #okCancel, #yesNo, #yesNoCancel #abortRetryIgnore, #retryCancel, #cancelRetryContinue)"

	^buttonStyle!

buttonStyle: aSymbol
	buttonStyle := aSymbol!

checkboxText
	"Answer the text to be displayed as the receiver's verification text (i.e. the checkbox label)"

	^checkboxText ifNil: [self defaultCheckboxText]!

checkboxText: aString
	"Set the text to be displayed as the receiver's verification text (i.e. the checkbox label). This text cannot be changed once the dialog is open."

	checkboxText := aString!

collapseLabel
	"Answer the label `<string>` to be shown on the expando button when expanded, i.e. this is the label when the button will collapse the extra details."

	^collapseLabel!

collapseLabel: aString
	collapseLabel := aString!

confirm
	self hasIcon ifFalse: [self iconStyle: #prompt].
	self buttonStyle: #yesNo.
	self open.
	^self isConfirmed!

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

customButtons
	"Answer the custom buttons displayed in the receiver, specified as a sequence of {<Symbol>, <String>}, key and label pairs."

	^customButtons!

customButtons: aSequenceOfPairs
	"Set the custom buttons displayed in the receiver, specified as a sequence of {<Symbol>, <String>}, key and label pairs. These can be for common buttons, e.g. #ok, but with the ability to vary the labels, or for completely new buttons. For command link buttons the note text should be separated from the label text by a newline."

	"All custom buttons are displayed before any of the common buttons. If there is a custom button for a common button when the common button is also requested by the buttonStyle, then only the custom button will appear. Any common buttons identified by the buttonStyle which do not have custom buttons configured will appear with their usual labels.

	Example usage:
		mb := MessageBox new.
		mb headline: 'Do you like chocolate?'.
		mb customButtons: #(#(#yes 'Of course!!') #(nil 'Not sure')).
		mb buttonStyle: #yesNo.
		mb open

	When command link buttons are used (specified by the #hasLinkButtons style), the note text is passed as a third element in the button description array, e.g
		mb := MessageBox new.
		mb headline: 'Sugar in your tea?'.
		mb customButtons: #(#(#ok nil) #(#one 'One lump' 'Mildly sweet') #(#two 'Two lumps' 'Sweet') #(#three 'Three lumps' 'Very sweet')).
		mb hasLinkButtons: true.
		mb open

	Note that we used the default #ok button style, but suppressed the OK button by providing a custom button for it with a nil (or empty) label.
	"

	customButtons := aSequenceOfPairs!

defaultablesKeyName
	^SessionManager current productRegistryKey , '\DontShowMeThisDialogAgain'!

defaultButton
	"Answer the one-based integer index of the default button. N.B. this is not the button id."

	^defaultButton!

defaultButton: anInteger
	"Set the one-based index of the default push button to be used when the receiver is opened. By default the first push button is the default button."

	defaultButton := anInteger!

defaultButtonId
	| ids |
	ids := self buttonIds.
	^ids at: self defaultButton ifAbsent: [ids first]!

defaultCheckboxText
	"Private - Answer the text that will be displayed by default in a suppressible/defaultable message box alongside the suppression checkbox."

	^self isSuppressible
		ifTrue: 
			[self isDefaultable
				ifTrue: ['Remember my answer and do not ask again']
				ifFalse: ['In the future, do not show me this dialog box']]!

defaultRadioButton
	"Answer the one-based integer index of the default radio button."

	^defaultRadioButton!

defaultRadioButton: anInteger
	"Set the one-based integer index of the default radio button. Note that for radio buttons the index and button id are equivalent. If the argument is nil, then there will be no default radio button."

	defaultRadioButton := anInteger!

destroy
	"Destroy the message box as if cancelled."

	^User32 destroyWindow: handle!

detailsText
	"Answer the additional details text that can be displayed in the message box by pressing an expando button."

	^detailsText!

detailsText: aString
	"Set the additional details text that can be displayed in the message box when expanded."

	self setElement: TDE_EXPANDED_INFORMATION text: (detailsText := aString)!

expandLabel
	"Answer the label `<string>` to be shown on the expando button when collapsed, i.e. this is the label when the button will cause the extra details to be shown."

	^expandLabel!

expandLabel: aString
	expandLabel := aString!

footerIcon
	^footerIcon!

footerIcon: anIcon
	"Set the receiver's footer icon to be the argument, anIcon. The Footer icon is only displayed when there is also footerText."

	footerIcon := anIcon asSmallIcon.
	self setElement: TDIE_ICON_FOOTER icon: footerIcon!

footerText
	"Answer the text to be displayed as the receiver's footer text, or nil if none."

	^footerText!

footerText: aString
	"Set the text to be displayed as the receiver's footer text. The text can be changed after the message box has been opened, but there will be no effect if there was no text originally."

	self setElement: TDE_FOOTER text: (footerText := aString)!

getDefaultButton
	| status buf |
	buf := ByteArray newFixed: 8.
	buf uint32AtOffset: 4 put: 4.
	status := AdvApi32
				regGetValue: HKEY_CURRENT_USER
				lpSubKey: self defaultablesKeyName
				lpValue: self uniqueId displayString
				dwFlags: RRF_RT_DWORD
				pdwType: nil
				pvData: buf
				pcbData: buf yourAddress + 4.
	^status == ERROR_SUCCESS ifTrue: [buf uint32AtOffset: 0]!

getEvents
	"Private - Answer the EventsCollection belonging to the receiver, or nil if the receiver has no events registered for it"

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

hasLinkButtons
	"Answer whether the dialog will display the custom buttons as Command Link buttons rather than normal push buttons. Note that these are not like hyperlinks, but rather just an alternate button presentation. See [BS_COMMANDLINK](https://docs.microsoft.com/en-us/windows/win32/controls/button-styles)"

	^flags allMask: TDF_USE_COMMAND_LINKS!

hasLinkButtons: aBoolean
	"Set whether the dialog will display the custom buttons as Command Link buttons rather than normal push buttons. Note that these are not like hyperlinks, but rather just an alternate button presentation. See [BS_COMMANDLINK](https://docs.microsoft.com/en-us/windows/win32/controls/button-styles)."

	flags := flags mask: TDF_USE_COMMAND_LINKS set: aBoolean!

hasMarqueeProgress
	"Answer whether the dialog will include a marquee progress bar."

	^flags allMask: TDF_SHOW_MARQUEE_PROGRESS_BAR!

hasMarqueeProgress: aBoolean
	"Set whether the dialog will include a marquee progress bar."

	flags := flags mask: TDF_SHOW_MARQUEE_PROGRESS_BAR set: aBoolean!

hasOwner
	^self owner notNil and: [self owner ~= 0]!

headline
	"Answer the text to be displayed alongside the icon as the message headline."

	^headline!

headline: aString
	"Set the text to be displayed alongside the icon as the message headline. This is drawn in a larger font that the content text."

	"The text can be changed after the message box is opened, e.g. from an event handler, even if there was no header text initially. The dialog may re-layout to accommodate the header."

	self setElement: TDE_MAIN_INSTRUCTION text: (headline := aString)!

icon
	"Answer the receiver's custom icon, if any. Note that the message box may still display an icon, depending on the #iconStyle."

	^icon!

icon: anIcon
	"Set the receiver's icon to be the argument, anIcon."

	self iconStyle: (anIcon
				ifNil: 
					[icon := nil.
					#none]
				ifNotNil: 
					[icon := anIcon asLargeIcon.
					#user])!

iconId
	"Private - Answer the Task Dialog common icon id for the receiver. Used if there is no custom icon set."

	"Note that we can also use the standard system icon id's here, because these ID's are valid for a null HINSTANCE, hence IDI_QUESTION for prompts."

	^##(IdentityDictionary new
		at: #none put: 0;
		at: #user put: 0;
		at: #error put: TD_ERROR_ICON;
		at: #warning put: TD_WARNING_ICON;
		at: #notify put: TD_INFORMATION_ICON;
		at: #prompt put: IDI_QUESTION;
		shrink;
		yourself) at: iconStyle!

iconStyle
	"Answer the receiver's symbolic icon style name."

	^iconStyle!

iconStyle: aSymbol 
	"Set the receiver's icon style to that named by the argument."

	iconStyle := aSymbol.
	iconStyle == #user ifFalse: [icon := nil]!

iconStyleFlag
	"Private - Answer the message box icon style flag, e.g. MB_ICONERROR, for the receiver's icon style."

	^IconStyles at: iconStyle!

iconStyleFlag: anInteger
	self iconStyle: (IconStyles keyAtValue: anInteger)!

initialize
	"Private - Initialize the receiver's instance variables."

	flags := TDF_SIZE_TO_CONTENT.
	verified := false.
	defaultButton := 1.
	modality := #application.
	iconStyle := #none.
	buttonStyle := #ok.
	radioButtons := #().
	radioButtonId := 0.!

isCancellable
	"Answer whether the message can be cancelled with by pressing Esc or Alt+F4, or the title bar close button, regardless of whether the dialog has a Cancel button."

	^flags allMask: TDF_ALLOW_DIALOG_CANCELLATION!

isCancellable: aBoolean
	"Set whether the message can be cancelled with by pressing Esc or Alt+F4, or the title bar close button, regardless of whether the dialog has a Cancel button."

	flags := flags mask: TDF_ALLOW_DIALOG_CANCELLATION set: aBoolean!

isChecked
	^verified!

isChecked: aBoolean
	verified := aBoolean!

isConfirmed
	^self result == #yes!

isDefaultable
	"Answer whether this message box will be give the user the option to remember their response and use that in future without showing the message."

	^(flags allMask: DefaultableMask) and: [self uniqueId notNil]!

isDefaultable: aBoolean
	"Set whether this message box will give the user the option of remembering their response for occurrences with the same uniqueId in the future."

	"Note that this flag is ignored unless the uniqueId associated with this particular message box is also set."

	flags := flags mask: DefaultableMask set: aBoolean!

isExpandedInFooter
	"Answer whether the extra detail text is shown in the footer area rather than the main content area."

	^flags allMask: TDF_EXPAND_FOOTER_AREA!

isExpandedInFooter: aBoolean
	"Set whether the extra detail text is shown in the footer area rather than the main content area."

	flags := flags mask: TDF_EXPAND_FOOTER_AREA set: aBoolean!

isInitiallyChecked
	"Answer whether the receiver's checkbox will be checked when the receiver is first opened. Normally it will not be."

	^flags allMask: TDF_VERIFICATION_FLAG_CHECKED!

isInitiallyChecked: aBoolean
	"Answer whether the receiver's checkbox will be checked when the receiver is first opened. Normally it will not be."

	verified := false.
	flags := flags mask: TDF_VERIFICATION_FLAG_CHECKED set: aBoolean!

isInitiallyExpanded
	"Answer whether the extra detail text is shown when the dialog is opened. Normally it is hidden behind the expando."

	^flags allMask: TDF_EXPANDED_BY_DEFAULT!

isInitiallyExpanded: aBoolean
	"Set whether the extra detail text is shown when the dialog is opened. Normally it is hidden behind the expando."

	flags := flags mask: TDF_EXPANDED_BY_DEFAULT set: aBoolean!

isMinimizable
	"Answer whether the message can be minimized."

	^flags allMask: TDF_CAN_BE_MINIMIZED!

isMinimizable: aBoolean
	"Set whether the message can be minimized."

	"This appears to have no effect, although this flag was added in Windows 8, so it may be an app manifest issue."

	flags := flags mask: TDF_CAN_BE_MINIMIZED set: aBoolean!

isSetForeground
	"Answer whether the receiver will call SetForegroundWindow when it is shown."

	^flags noMask: TDF_NO_SET_FOREGROUND!

isSetForeground: aBoolean
	"Set whether the receiver will call SetForegroundWindow when it is shown."

	flags := flags mask: TDF_NO_SET_FOREGROUND set: aBoolean not!

isSizedToContent
	"Set whether this message box will be size horizontally to fit the content."

	^flags allMask: TDF_SIZE_TO_CONTENT!

isSizedToContent: aBoolean
	"Set whether this message box will be size horizontally to fit the content."

	flags := flags mask: TDF_SIZE_TO_CONTENT set: aBoolean!

isSuppressed
	"Answer whether this message has been previously suppressed by the current user."

	| sizeBuf status buf |
	buf := Utf16String newFixed: 2.	"Note that the value must be 'NO'. Anything else appears to be ignored."
	sizeBuf := ByteArray newFixed: 4.
	sizeBuf uint32AtOffset: 0 put: buf byteSize.
	status := AdvApi32
				regGetValue: HKEY_CURRENT_USER
				lpSubKey: self suppressionsKeyName
				lpValue: self globallyUniqueId
				dwFlags: RRF_RT_REG_SZ
				pdwType: nil
				pvData: buf
				pcbData: sizeBuf.
	^status == ERROR_SUCCESS and: [buf = 'NO']!

isSuppressible
	"Answer whether this message box will be give the user the option of not seeing further occurrences with the same uniqueId in the future."

	^(flags allMask: SuppressibleMask) and: [self uniqueId notNil]!

isSuppressible: aBoolean
	"Set whether this message box will give the user the option of not seeing further occurrences with the same uniqueId in the future."

	"Note that this flag is ignored unless the uniqueId associated with this particular message box is also set."

	flags := flags mask: SuppressibleMask set: aBoolean!

isTaskModal
	"Answer whether the receiver is task modal (i.e. modal to all windows in the application not just the active one)."

	^modality == #task!

isTopMost
	"Answer whether the message should be the top-most window when opened."

	^flags allMask: TopMostMask!

isTopMost: aBoolean
	"Answer whether the message should be the top-most window when opened."

	flags := flags mask: TopMostMask set: aBoolean!

mergedCustomButtons
	"Private - Answer the combination of the custom buttons implementing standard message box buttons that are not provided by the task dialog as common buttons, and the user supplied buttons. The latter take precedence."

	^customButtons
		ifNil: [self baseCustomButtons]
		ifNotNil: 
			[customButtons
				, (self baseCustomButtons reject: 
							[:each |
							| name |
							name := each first.
							customButtons anySatisfy: [:c | c first == name]])]!

modality
	"Answer the symbolic name of the receiver's modal style (one of #application, #task, or #system). "

	^modality!

modality: aSymbol
	"Set the receiver's modal style to that named by the argument, which must be one of #application, #task, or #system.
	  - #application modal message boxes are modal only to the owner window and spawn the message box on a background thread in order to allow the rest of the system to operate normally.
	  - #task modal message boxes are intended to be modal to the whole Dolphin application, and spawn the message box on the main UI thread, which means that the message box has control of the main message loop. This has certain consequences, such as disabling keyboard accelerators."

	modality := aSymbol!

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
				argumentTypes: 'handle uint32 uintptr intptr intptr')!

open
	"Display a Windows Task Dialog for the receiver, and answer a portable symbolic constant for the button pressed by the user."

	button := self buttonNames at: (self getSuppressedDefault ifNil: [self basicOpen]).
	^button!

progressPosition: anInteger
	"Set the progress bar position to that specified. The position should be within the current range. Note that this is ignored until after the task dialog has been opened."

	handle
		ifNotNil: 
			[User32
				sendMessage: handle
				msg: TDM_SET_PROGRESS_BAR_POS
				wParam: anInteger
				lParam: 0]!

progressRange
	^progressRange!

progressRange: anInterval
	"Set the range for the receiver's progress bar to the `Interval` argument. If the argument is nil, then the dialog will be shown without a progress bar (unless it has a marquee progress bar)."

	progressRange := anInterval.
	self updateProgressRange!

progressState: aSymbol
	"Set the state of the receiver's progress bar to one of #normal, #paused, or #error"

	handle
		ifNotNil: 
			[User32
				sendMessage: handle
				msg: TDM_SET_PROGRESS_BAR_STATE
				wParam: (##(LookupTable withAll: {#normal -> 1. #paused -> 3. #error -> 2}) at: aSymbol)
				lParam: 0]!

radioButton
	"Answer a <Symbol> identifying the radio button selected by the user, or nil if none."

	^radioButtonId ~~ 0 ifTrue: [(radioButtons at: radioButtonId) first]!

radioButtons
	"Answer the radio buttons displayed in the receiver, specified as a sequence of {<Symbol>, <String>}, key and label pairs."

	^radioButtons!

radioButtons: aSequenceOfPairs
	"Set the radio buttons displayed in the receiver, specified as a sequence of {<Symbol>, <String>}, key and label pairs.

	Example usage:
		MessageBox new
			headline: 'Please select your preferred beverage:';
			radioButtons: #(#(#tea 'Tea') #(#coffee 'Coffee') #(beer 'Beer'));
			footerText: 'Other beverages are available.';
			footerIcon: Icon information;
			defaultRadioButton: 3;
			buttonStyle: #ok;
			open;
			radioButton
	"

	radioButtons := aSequenceOfPairs!

result
	"Answer the symbolic name of the clicked button."

	^button!

saveDefaultButton: anInteger
	"Private - Remember the user's answer so that this will be used in future without displaying the message box."

	| value |
	value := ByteArray new: 4.
	value uint32AtOffset: 0 put: anInteger.
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
		lpData: 'NO' asUtf16String
		cbData: 6!

saveSuppressedDefault: anInteger
	self isSuppressible
		ifTrue: 
			[self isDefaultable
				ifTrue: [self saveDefaultButton: anInteger]
				ifFalse: 
					["The dialog will be suppressed in future and will always answer the default button, even if a different button was pressed this time."
					self saveSuppressed]]!

setButton: anInteger enablement: aBoolean
	"Enable or disable the button with the specified id."

	handle
		ifNotNil: 
			[User32
				sendMessage: handle
				msg: TDM_ENABLE_BUTTON
				wParam: anInteger
				lpParam: aBoolean asParameter]!

setElement: anInteger icon: anIcon
	"Private - Note that the icon can only be updated by handle if originally set to a specific icon."

	handle
		ifNotNil: 
			[User32
				sendMessage: handle
				msg: TDM_UPDATE_ICON
				wParam: anInteger
				lParam: anIcon asParameter]!

setElement: anInteger text: aString
	"Private - Update the text of the specified element. Causes the dialog to relayout to accomodate the next text."

	handle
		ifNotNil: 
			[| wideText |
			wideText := aString ifNotNil: [aString asUtf16String].
			User32
				sendMessage: handle
				msg: TDM_SET_ELEMENT_TEXT
				wParam: anInteger
				lpParam: wideText]!

setEvents: anEventsCollectionOrNil 
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil. Answer the receiver."

	events := anEventsCollectionOrNil.
	^self!

setForeground
	Notification deprecated.
	self isSetForeground: true!

setRadioButton: anInteger enablement: aBoolean
	"Enable or disable the button with the specified id."

	handle
		ifNotNil: 
			[User32
				sendMessage: handle
				msg: TDM_ENABLE_RADIO_BUTTON
				wParam: anInteger
				lpParam: aBoolean asParameter]!

setStyle: anInteger maskedBy: maskInteger
	"Configure the receiver to emulate the specified MB_XXX message box flags, limiting the changes to those flags that are part of the specified mask."

	(maskInteger allMask: MB_TYPEMASK)
		ifTrue: 
			[self
				buttonStyle: (#(#ok #okCancel #abortRetryIgnore #yesNoCancel #yesNo #retryCancel #cancelRetryContinue)
						at: (anInteger bitAnd: MB_TYPEMASK) + 1
						ifAbsent: #none)].
	(maskInteger allMask: MB_DEFMASK)
		ifTrue: [self defaultButton: ((anInteger bitAnd: MB_DEFMASK) >> ##(MB_DEFMASK lowBit - 1)) + 1].
	(maskInteger allMask: MB_ICONMASK) ifTrue: [self iconStyleFlag: (anInteger bitAnd: MB_ICONMASK)].
	(maskInteger allMask: MB_MODEMASK)
		ifTrue: 
			[self modality: (#(#application #system #task)
						at: ((anInteger bitAnd: MB_MODEMASK) >> ##(MB_MODEMASK lowBit - 1)) + 1)].
	(maskInteger allMask: MB_MISCMASK)
		ifTrue: 
			[self
				isSetForeground: (anInteger allMask: MB_SETFOREGROUND);
				isTopMost: (anInteger allMask: MB_TOPMOST)]!

showIndirect: aTASKDIALOGCONFIG
	| buf buttonId |
	buf := ByteArray newFixed: 12.
	self modality == #application
		ifTrue: 
			["Open the dialog using an overlapped call on a separate thread to avoid losing control of the message loop. We don't need an idle timer at all in this case."
			Processor forkMainIfMain
				ifTrue: 
					[| proc |
					"If the initiating process is the UI process then its priority is boosted so that the operation requested by the user completes more quickly when the dialog is closed."
					proc := Processor activeProcess.
					proc priority: proc priority + 1].
			CommCtrlLibrary default
				overlappedTaskDialogIndirect: aTASKDIALOGCONFIG
				pnButton: buf yourAddress
				pnRadioButton: buf yourAddress + 4
				pfVerificationFlagChecked: buf yourAddress + 8]
		ifFalse: 
			[| hwndParent enabled |
			"Note that we don't need to use the Dolphin idle timer because the dialog offers its own rapid timer notification"
			aTASKDIALOGCONFIG dwFlags: (aTASKDIALOGCONFIG dwFlags bitOr: TDF_CALLBACK_TIMER).
			"Unfortunately TaskDialogs do not provide similar functionality to MB_TASKMODAL/MB_SYSTEMMODAL, so we have to disable all the top-level Windows ourselves."
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
					ensure: [enabled do: [:each | each isEnabled: true]]].
	buttonId := buf int32AtOffset: 0.
	radioButtonId := buf int32AtOffset: 4.
	verified := (buf uint32AtOffset: 8) ~~ 0.
	(verified and: [self isSuppressible]) ifTrue: [self saveSuppressedDefault: buttonId].
	^buttonId!

standardButtonIds
	"Private - Answer an array of the standard Windows button ids for the buttons requested by the message box button style flags. Note that note all of these have built-in (aka common) equivalents in the task dialog."

	^##(LookupTable withAll: {#none -> #().
				#ok -> {IDOK}.
				#okCancel -> {IDOK. IDCANCEL}.
				#abortRetryIgnore -> {IDABORT. IDRETRY. IDIGNORE}.
				#yesNoCancel -> {IDYES. IDNO. IDCANCEL}.
				#yesNo -> {IDYES. IDNO}.
				#retryCancel -> {IDRETRY. IDCANCEL}.
				#cancelRetryContinue -> {IDCANCEL. IDTRYAGAIN. IDCONTINUE}.
				#close -> {IDCLOSE}})
		at: buttonStyle!

startMarqueeProgress: anInteger
	"Start the marquee progress bar running, updating it every anInteger milliseconds. If anInteger is 0, the task dialog uses its default update interval (about 30mS)."

	User32
		sendMessage: handle
		msg: TDM_SET_PROGRESS_BAR_MARQUEE
		wParam: TRUE
		lParam: 0!

stopMarqueeProgress
	"Stop the marquee progress bar running."

	User32
		sendMessage: handle
		msg: TDM_SET_PROGRESS_BAR_MARQUEE
		wParam: 0
		lParam: 0!

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

	progressRange ifNotNil: [self updateProgressRange].
	self hasMarqueeProgress ifTrue: [self startMarqueeProgress: 0].
	self trigger: #created.
	^S_OK!

tdnDestroyed: wParamInteger lParam: lParamInteger
	"Private - The task dialog has been destroyed."

	self trigger: #destroyed.
	handle := nil.
	^S_OK!

tdnDialogConstructed: wParamInteger lParam: lParamInteger
	"Private - The task dialog box has been created, but not yet displayed. The box will have a handle by this point."

	self trigger: #dialogConstructed.
	self isTopMost
		ifTrue: 
			[User32
				setWindowPos: handle
				hWndInsertAfter: HWND_TOPMOST
				x: 0
				y: 0
				cx: 0
				cy: 0
				uFlags: ##(SWP_NOACTIVATE | SWP_NOSIZE | SWP_NOMOVE | SWP_NOREDRAW)].
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
	self setElement: TDE_CONTENT text: aString!

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

updateProgressRange
	| range |
	handle ifNil: [^self].
	range := progressRange ?? ##(0 to: 100).
	User32
		sendMessage: handle
		msg: TDM_SET_PROGRESS_BAR_RANGE
		wParam: 0
		lpParam: ((range stop bitShift: 16) bitOr: range start)! !
!UI.MessageBox categoriesForMethods!
areLinksParsed!accessing-styles!public! !
areLinksParsed:!accessing-styles!public! !
baseCustomButtons!buttons!helpers!private! !
basicOpen!displaying!private! !
beFatalError!accessing-styles!public! !
beSystemModal!accessing-styles!public! !
beTaskModal!accessing-styles!public! !
buildCustomButtonIdsAndLabels!buttons!helpers!private! !
buttonIds!accessing!buttons!private! !
buttonNames!accessing!buttons!private! !
buttonStyle!accessing-styles!buttons!public! !
buttonStyle:!accessing-styles!buttons!public! !
checkboxText!accessing!public! !
checkboxText:!accessing!public! !
collapseLabel!accessing!public! !
collapseLabel:!accessing!public! !
confirm!operations!public! !
confirm:!operations!public! !
confirm:onYes:onNo:onCancel:!operations!public! !
confirmOrCancel!operations!public! !
confirmOrCancel:!operations!public! !
customButtons!buttons!public! !
customButtons:!buttons!public! !
defaultablesKeyName!constants!private! !
defaultButton!accessing!buttons!public! !
defaultButton:!accessing!buttons!public! !
defaultButtonId!accessing!buttons!private! !
defaultCheckboxText!constants!private! !
defaultRadioButton!accessing!public!radio buttons! !
defaultRadioButton:!accessing!public!radio buttons! !
destroy!operations!private! !
detailsText!accessing!public! !
detailsText:!accessing!public! !
expandLabel!accessing!public! !
expandLabel:!accessing!public! !
footerIcon!accessing!public! !
footerIcon:!accessing-styles!public! !
footerText!accessing!public! !
footerText:!accessing!public! !
getDefaultButton!helpers!private! !
getEvents!events!private! !
getSuppressedDefault!helpers!private! !
globallyUniqueId!helpers!private! !
handle!accessing!public! !
hasLinkButtons!accessing-styles!buttons!public! !
hasLinkButtons:!accessing-styles!buttons!public! !
hasMarqueeProgress!accessing-styles!progress bar!public! !
hasMarqueeProgress:!accessing-styles!progress bar!public! !
hasOwner!accessing-styles!private! !
headline!accessing!public! !
headline:!accessing!public! !
icon!accessing!public! !
icon:!accessing!public! !
iconId!helpers!private! !
iconStyle!accessing-styles!public! !
iconStyle:!accessing-styles!public! !
iconStyleFlag!accessing-styles!private! !
iconStyleFlag:!accessing-styles!private! !
initialize!initializing!private! !
isCancellable!accessing-styles!public! !
isCancellable:!accessing-styles!public! !
isChecked!accessing-styles!public! !
isChecked:!accessing-styles!public! !
isConfirmed!public!testing! !
isDefaultable!accessing-styles!public! !
isDefaultable:!accessing-styles!public! !
isExpandedInFooter!accessing-styles!public! !
isExpandedInFooter:!accessing-styles!public! !
isInitiallyChecked!accessing-styles!public! !
isInitiallyChecked:!accessing-styles!public! !
isInitiallyExpanded!accessing-styles!public! !
isInitiallyExpanded:!accessing-styles!public! !
isMinimizable!accessing-styles!public! !
isMinimizable:!accessing-styles!public! !
isSetForeground!accessing-styles!public!testing! !
isSetForeground:!accessing-styles!public! !
isSizedToContent!accessing-styles!public! !
isSizedToContent:!accessing-styles!public! !
isSuppressed!helpers!public! !
isSuppressible!accessing-styles!public!testing! !
isSuppressible:!accessing-styles!public! !
isTaskModal!accessing-styles!public!testing! !
isTopMost!accessing-styles!public! !
isTopMost:!accessing-styles!public! !
mergedCustomButtons!helpers!private! !
modality!accessing-styles!public! !
modality:!accessing-styles!public! !
notificationCallback!helpers!private! !
open!displaying!public! !
progressPosition:!progress bar!public! !
progressRange!progress bar!public! !
progressRange:!progress bar!public! !
progressState:!progress bar!public! !
radioButton!accessing!public!radio buttons! !
radioButtons!accessing!public!radio buttons! !
radioButtons:!accessing!public!radio buttons! !
result!accessing!public! !
saveDefaultButton:!helpers!private! !
saveSuppressed!helpers!private! !
saveSuppressedDefault:!helpers!private! !
setButton:enablement:!buttons!operations!public! !
setElement:icon:!helpers!private! !
setElement:text:!helpers!private! !
setEvents:!events!private! !
setForeground!accessing-styles!public! !
setRadioButton:enablement:!operations!public!radio buttons! !
setStyle:maskedBy:!accessing-styles!private! !
showIndirect:!displaying!private! !
standardButtonIds!helpers!private! !
startMarqueeProgress:!operations!progress bar!public! !
stopMarqueeProgress!operations!progress bar!public! !
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
uniqueId:!accessing!public! !
updateElement:text:!operations!private! !
updateProgressRange!private!progress bar! !
!

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

	defaultCaptions := (IdentityDictionary
				withAll: { #prompt -> 'Please confirm…'. #notify -> 'Note' })
				beReadOnlyObject;
				yourself.
	self addClassConstant: 'CommonButtonFlags'
		value: ((Array new: 11)
				at: IDOK put: TDCBF_OK_BUTTON;
				at: IDCANCEL put: TDCBF_CANCEL_BUTTON;
				at: IDABORT put: 0;
				at: IDRETRY put: TDCBF_RETRY_BUTTON;
				at: IDIGNORE put: 0;
				at: IDYES put: TDCBF_YES_BUTTON;
				at: IDNO put: TDCBF_NO_BUTTON;
				at: IDCLOSE put: TDCBF_CLOSE_BUTTON;
				at: IDHELP put: 0;
				at: IDTRYAGAIN put: 0;
				at: IDCONTINUE put: 0;
				yourself)! !
!UI.MessageBox class categoriesForMethods!
confirm:!instance creation!public! !
confirm:caption:!instance creation!public! !
confirm:onYes:onNo:onCancel:!instance creation!public! !
initialize!development!initializing!private! !
!

