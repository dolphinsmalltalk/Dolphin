"Filed out from Dolphin Smalltalk 7"!

MessageBoxAbstract subclass: #MessageBox
	instanceVariableNames: 'button uniqueId flags icon styleFlags'
	classVariableNames: 'ButtonStyles ModeStyles'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {
		'ButtonMap' -> #(#ok #cancel #abort #retry #ignore #yes #no #close #help #retry #ignore).
		'ButtonsForStyle' -> #(#(1) #(1 2) #(3 4 2) #(6 7 2) #(6 7) #(4 2) #(2 10 11)).
		'SuppressibleMask' -> 16r10
	}!
MessageBox guid: (GUID fromString: '{87b4c49f-026e-11d3-9fd7-00a0cc3e4a32}')!
MessageBox comment: 'MessageBox provides a convenient wrapping aound the standard Windows Message Box. It can be used to pose questions, and report information, warnings, or errors.

Note that MessageBox is deliberately implemented using low-level Windows APIs in order to be independent of the MVP subsystem.

Example usage:

	MessageBox new 
		confirm: ''Would you like a cup of tea?''.
	MessageBox warning: ''Contents are hot''.
	MessageBox errorMsg: ''You''''ve burned yourself''.

	"If you are on XP or 2k(3) you can try out the new style of Abort/Retry/Ignore box"
	MessageBox new
		icon: Object icon;
		buttonStyle: #cancelRetryContinue;
		text: ''Is this any more helpful?'';
		open

MessageBox''s can also be configured so that they are suppressible by the user. This includes a checkbox in the MessageBox which the user can tick if they don''t want to see the messsage again. Subsequent attempts to display the same message (as identified by the uniqueId) will result in the immediate return of the default button value. Note that it is the default button value that is returned, NOT the button the user pressed when the chose to suppress the message box. MSDN explains this as follows: 

	Do not confuse "Do not show this dialog box" with "Remember this answer". SHMessageBoxCheck does not provide "Remember this answer" functionality. If the user opts to suppress the message box again, the function does not preserve which button they clicked. Instead, subsequent invocations of SHMessageBoxCheck simply return the [default value].

In other words, if you want to remember the choice the user made when they suppressed the dialog box, and apply that in future, you must store it yourself and set the #defaultButton: index appropriately before "opening" the message box.

Suppressible message boxes support only a limited set of the full range of MessageBox styles. For example they can only show the OK, OK & Cancel, or Yes & No buttons (although in fact the Yes/No style is equivalent to the normal Yes/No/Cancel since it enables the close button on the title bar). Another respect in which SHMessageBoxCheck is more limited is that it ignores the MB_DEFBUTTONX flags. The default button is always the first button in the dialog (i.e. either OK, or Yes, depending on the button style). In the Dolphin implementation setting the #defaultButton: index can be used to control the default answer when the message box has been suppressed as mentioned above, but unfortunately it will not influence the default button selected when the message box is actually show. When a message box is suppressed by the user, Windows writes a value under HKCU/Software/Microsoft/Windows/CurrentVersion/Explorer/DontShowMeThisDialogAgain. The value is named after the #uniqueId set when the message box was opened, prepended with the GUID of the Dolphin application (i.e. the GUID of the SessionManager class). For further information see the MSDN entry for the SHMessageBoxCheck API:

	http://msdn.microsoft.com/library/default.asp?url=/library/en-us/shellcc/platform/shell/reference/shlwapi/others/SHMessageBoxCheck.asp

Instance Variables:
	button		<integer> id of the button that was pressed (e.g. IDOK)
	uniqueId	<Object>. The display string of this object is used to uniquely identify (within an application) a particular suppressible message box instance.
	flags		<integer>. Miscellaneous flags
	icon		<Icon> displayed in the message box.
	styleFlags	<integer>. Button and icon styles.

Class Variables:
	SuppressableMask	<integer> flags mask

Class Variables:
	ButtonMap			<Array> mapping <integer> button ids to <symbol>ic button names.
	ButtonsForStyle		<Array> of <Array> of <integer>. Button ids present on a box with a particular button style, in display order.
	ButtonStyles		<IdentityDictionary> mapping <symbol>ic button style names to the corresponding <integer> MB_ flag values.
	ModeStyles			<IdentityDictionary> mapping <symbol>ic modality style names (e.g. #task) to the corresponding <integer> MB_ flag value.
	SuppressibleMask	<integer>. Masks in/out the suppressible flag from the flags instance variable.

'!
!MessageBox categoriesForClass!MVP-Views-Support! !
!MessageBox methodsFor!

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
	"Private - Display the receiver, and answer the Win32 Id of the button pressed by the user."

	self assert: [self defaultButton <= self buttonIds size].
	self hasOwner ifTrue: [self owner ensureVisible].
	self isSuppressible ifTrue: [self showSuppressible] ifFalse: [self showIndirect].
	^button!

beFatalError
	"Set the receiver's style such that the receiver opens as a fatal error message (e.g. for
	out of resource situations)."

	self
		iconStyle: #error;
		beSystemModal!

beSystemModal
	"Set the receiver's style so that it is system modal (i.e. all top level windows are 
	disabled) when opened. Since this option disables all other applications, it should
	be used only when catastrophic errors occur which require immediate user attention.
	N.B. Should be combined with #error to prevent activation messages being sent to
	the parent window when opened."

	self modality: #system!

beTaskModal
	"Set the receiver's style so that it is task modal (i.e. all top level Dolphin
	windows are disabled) when opened. Other applications are unaffected.
	Task modality only works in Win32 if the owner window handle is NULL, and by
	default we pass the handle of the active window, so must explicity null it here."

	self modality: #task.
	self setForeground.
	self owner: 0!

buttonIds
	^ButtonsForStyle at: self buttonStyleValue + 1!

buttonStyle
	"Answer the symbolic name of the button style to be used in the message box (one of: #ok,
	#okCancel, #yesNo, #yesNoCancel #abortRetryIgnore, #retryCancel, #cancelRetryContinue)"

	^ButtonStyles keyAtValue: self buttonStyleValue!

buttonStyle: aSymbol 
	self setStyle: (ButtonStyles at: aSymbol) maskedBy: MB_TYPEMASK!

buttonStyleValue
	^styleFlags bitAnd: MB_TYPEMASK!

confirm: promptString 
	"Display a host system message box with the prompt, promptString, with caption, 
	captionString, and Yes and No push buttons. Answer whether the user confirmed 
	(by pressing the Yes button)."

	self text: promptString.
	self iconStyle: #prompt.
	self buttonStyle: #yesNo.
	^self open == #yes!

confirm: aString onYes: yesBlock onNo: noBlock onCancel: cancelBlock
	"Prompts the user with a Yes/No/Cancel message box and evaluates the appropriate block based on the response"

	| response |
	response := self confirmOrCancel: aString.

	^response == #cancel
		ifTrue: [cancelBlock value]
		ifFalse: [ 
			response == #yes
				ifTrue: [yesBlock value]
				ifFalse: [noBlock value]]!

confirmOrCancel: promptString 
	"Display a host system message box for the receiver with the prompt, aString,
	and Yes, No and Cancel push buttons. Answer one of the symbolic
	constants #yes, #no, #cancel, according to the button pressed by the receiver."

	self text: promptString.
	self iconStyle: #prompt.
	self buttonStyle: #yesNoCancel.
	^self open!

defaultButton
	"Answer the one-based integer index of the default button."

	^((styleFlags bitAnd: MB_DEFMASK) >> 8) + 1!

defaultButton: anInteger
	"Set the one-based index of the default push button to be used when the receiver is opened.
	By default the first push button is the default button."

	(anInteger between: 1 and: 4)
		ifFalse: [^self error: ('Invalid default button index: <1p>' expandMacrosWith: anInteger)].
	self setStyle: anInteger - 1 << 8 maskedBy: MB_DEFMASK!

globallyUniqueId
	^'<1d>:<2d>' expandMacrosWithArguments: {SessionManager current appIdString. self uniqueId}
		locale: Locale invariant!

hasOwner
	^self owner notNil and: [self owner ~= 0]!

icon: anIcon 
	"Set the receiver's icon to be the argument, anIcon. The icon MUST have been loaded from
	resources since the message box does not use the icon directly, but rather it uses its ID
	and module handle to load it again.. Also the icon only seems to be displayed if the
	resource id is an integer."

	icon := anIcon.
	self iconStyle: (icon isNil ifTrue: [#notify] ifFalse: [#user])!

iconStyleFlag
	"Private - Answer the icon style bits from the receiver's style mask."

	^styleFlags bitAnd: MB_ICONMASK!

iconStyleFlag: anInteger 
	self setStyle: anInteger maskedBy: MB_ICONMASK!

idOfButtonAt: anInteger 
	^self buttonIds at: anInteger!

initialize
	"Private - Initialize the receiver's instance variables."

	flags := 0.
	styleFlags := 0!

isSuppressible
	"Answer whether this message box will be give the user the option of not seeing further
	occurrences with the same uniqueId in the future."

	^(flags allMask: SuppressibleMask) and: [self uniqueId notNil]!

isSuppressible: aBoolean 
	"Set whether this message box will give the user the option of not seeing further
	occurrences with the same uniqueId in the future. Note that this flag is ignored unless the
	uniqueId associated with this particular message box is also set."

	flags := flags mask: SuppressibleMask set: aBoolean!

isTaskModal
	"Answer whether the receiver is task modal (i.e. modal to all windows
	in the application not just the active one)."

	^styleFlags allMask: MB_TASKMODAL!

modality
	"Answer the symbolic name of the receiver's modal style (one of #application, #task, or
	#system). "

	^ModeStyles keyAtValue: (styleFlags bitAnd: MB_MODEMASK)!

modality: aSymbol 
	self setStyle: (ModeStyles at: aSymbol) maskedBy: MB_MODEMASK!

open
	"Display a host system message box for the receiver, and answer a portable symbolic constant 
	for the button pressed by the user.
	Note that the message box will beep when opened by the user (if configured)."

	^self basicOpen; result!

result
	"Answer a portable symbolic constant describing the button that was pressed by the user
	to close the receiver."

	^ButtonMap at: button!

setForeground
	"Set the receiver's style such that the receiver opens in the foreground."

	styleFlags := styleFlags mask: MB_SETFOREGROUND set: true!

setStyle: anInteger maskedBy: maskInteger 
	styleFlags := (styleFlags maskClear: maskInteger) maskSet: (anInteger bitAnd: maskInteger)!

showIndirect
	| hInstance iconIdentifier |
	icon isNil 
		ifFalse: 
			[iconIdentifier := icon identifier.
			hInstance := icon instanceHandle asParameter].
	button := UserLibrary default 
				messageBox: self ownerHandle
				text: self text
				caption: self caption
				style: styleFlags
				icon: iconIdentifier
				instance: hInstance!

showSuppressible
	"Private - Show a message box that offers the user the option to suppress the prompt in future, in which case the default button is returned (not the user's last choice)."

	"Implementation Note: SHMessageBoxCheck does not seem to suffer from the same bug as the normal message box of re-enabling a disabled owner."

	self assertStylesValid.
	button := ShlwapiLibrary default
				shMessageBoxCheck: self ownerHandle
				pszText: self text
				pszTitle: self caption
				uType: styleFlags
				iDefault: (self idOfButtonAt: self defaultButton)
				pszRegVal: self globallyUniqueId.
	button == -1 ifTrue: [ShlwapiLibrary default systemError].
	NTLibrary isWine ifFalse: [^self].
	#wineFix.
	"Suppressible message boxes under Wine have a bug where they ignore the buttonStyles #yesNo and #yesNoCancel and will always answer #ok or #cancel instead. Here we map the return button ids to the correct values"
	(self buttonStyle == #yesNo or: [self buttonStyle == #yesNoCancel])
		ifTrue: 
			[button = IDOK ifTrue: [button := IDYES].
			button = IDCANCEL ifTrue: [button := IDNO]]!

uniqueId
	"Answer the unique id that, should the user decide to suppress this message box, will be
	stored under the following registry key:
		HKCU/Software/Microsoft/Windows/CurrentVersion/Explorer/DontShowMeThisDialogAgain
	This is a global area used by all applications, so the id has to be unique. The class
	attempts to assist you in this by pre-pending this unique id with the GUID of the
	SessionManager class, which is the closest thing to a unique id for each Dolphin
	application. A good choice for the unique id is then the full name of the method displaying
	the message box. Note that if the id is nil the message box will not be suppressible."

	^uniqueId!

uniqueId: anObject 
	uniqueId := anObject displayString: Locale invariant! !
!MessageBox categoriesFor: #assertStylesValid!helpers!private! !
!MessageBox categoriesFor: #basicOpen!displaying!private! !
!MessageBox categoriesFor: #beFatalError!accessing-styles!public! !
!MessageBox categoriesFor: #beSystemModal!accessing-styles!public! !
!MessageBox categoriesFor: #beTaskModal!accessing-styles!public! !
!MessageBox categoriesFor: #buttonIds!accessing!private! !
!MessageBox categoriesFor: #buttonStyle!accessing-styles!public! !
!MessageBox categoriesFor: #buttonStyle:!accessing-styles!public! !
!MessageBox categoriesFor: #buttonStyleValue!accessing!private! !
!MessageBox categoriesFor: #confirm:!operations!public! !
!MessageBox categoriesFor: #confirm:onYes:onNo:onCancel:!displaying!public! !
!MessageBox categoriesFor: #confirmOrCancel:!displaying!public! !
!MessageBox categoriesFor: #defaultButton!accessing!public! !
!MessageBox categoriesFor: #defaultButton:!initializing!public! !
!MessageBox categoriesFor: #globallyUniqueId!helpers!private! !
!MessageBox categoriesFor: #hasOwner!displaying!private! !
!MessageBox categoriesFor: #icon:!accessing!public! !
!MessageBox categoriesFor: #iconStyleFlag!accessing-styles!private! !
!MessageBox categoriesFor: #iconStyleFlag:!accessing-styles!private! !
!MessageBox categoriesFor: #idOfButtonAt:!helpers!private! !
!MessageBox categoriesFor: #initialize!initializing!private! !
!MessageBox categoriesFor: #isSuppressible!public!testing! !
!MessageBox categoriesFor: #isSuppressible:!initializing!public! !
!MessageBox categoriesFor: #isTaskModal!accessing-styles!public! !
!MessageBox categoriesFor: #modality!accessing-styles!public! !
!MessageBox categoriesFor: #modality:!accessing-styles!public! !
!MessageBox categoriesFor: #open!displaying!public! !
!MessageBox categoriesFor: #result!accessing!public!wine fix! !
!MessageBox categoriesFor: #setForeground!accessing-styles!public! !
!MessageBox categoriesFor: #setStyle:maskedBy:!accessing-styles!private! !
!MessageBox categoriesFor: #showIndirect!displaying!private! !
!MessageBox categoriesFor: #showSuppressible!operations!private! !
!MessageBox categoriesFor: #uniqueId!accessing!public! !
!MessageBox categoriesFor: #uniqueId:!initializing!public! !

!MessageBox class methodsFor!

confirm: promptText
	"Display a Windows Message Box prompting for confirmation of the 
	<readableString> prompt, promptText.
	Answer whether the user confirmed (by pressing the Yes button).
	The caption will be filled in from the defaults later."

	^self confirm: promptText  caption: nil!

confirm: prompt caption: title
	"Display a Windows Message Box prompting for confirmation of the 
	<readableString> question, prompt , with the <readableString> caption,
	title."

	^self new
		caption: title;
		confirm: prompt !

confirm: aString onYes: yesBlock onNo: noBlock onCancel: cancelBlock
	"Prompts the user with a Yes/No/Cancel message box and evaluates the 
	appropriate block based on the response"

	^self new
		confirm: aString
		onYes: yesBlock
		onNo: noBlock
		onCancel: cancelBlock!

initialize
	"Private - Initialize the class variables of the receiver:
		MessageBox initialize
	"

	| buttonMap buttonsForStyle |
	buttonMap := (Array new: 11)
				at: IDOK put: #ok;
				at: IDCANCEL put: #cancel;
				at: IDABORT put: #abort;
				at: IDRETRY put: #retry;
				at: IDIGNORE put: #ignore;
				at: IDYES put: #yes;
				at: IDNO put: #no;
				at: IDCLOSE put: #close;
				at: IDHELP put: #help;
				at: IDTRYAGAIN put: #retry;
				at: IDCONTINUE put: #ignore;
				yourself.
	self addClassConstant: 'ButtonMap' value: buttonMap.
	"at: IDTIMEOUT put: #timeout;"
	ButtonStyles := IdentityDictionary new
				at: #ok put: MB_OK;
				at: #okCancel put: MB_OKCANCEL;
				at: #abortRetryIgnore put: MB_ABORTRETRYIGNORE;
				at: #yesNoCancel put: MB_YESNOCANCEL;
				at: #yesNo put: MB_YESNO;
				at: #retryCancel put: MB_RETRYCANCEL;
				at: #cancelRetryContinue put: MB_CANCELTRYCONTINUE;
				shrink;
				yourself.
	buttonsForStyle := (Array new: 7)
				at: MB_OK + 1 put: {IDOK};
				at: MB_OKCANCEL + 1 put: {IDOK. IDCANCEL};
				at: MB_ABORTRETRYIGNORE + 1 put: {IDABORT. IDRETRY. IDCANCEL};
				at: MB_YESNOCANCEL + 1 put: {IDYES. IDNO. IDCANCEL};
				at: MB_YESNO + 1 put: {IDYES. IDNO};
				at: MB_RETRYCANCEL + 1 put: {IDRETRY. IDCANCEL};
				at: MB_CANCELTRYCONTINUE + 1 put: {IDCANCEL. IDTRYAGAIN. IDCONTINUE};
				yourself.
	self addClassConstant: 'ButtonsForStyle' value: buttonsForStyle.
	ModeStyles := IdentityDictionary new
				at: #application put: MB_APPLMODAL;
				at: #task put: MB_TASKMODAL;
				at: #system put: MB_SYSTEMMODAL;
				shrink;
				yourself! !
!MessageBox class categoriesFor: #confirm:!instance creation!public! !
!MessageBox class categoriesFor: #confirm:caption:!instance creation!public! !
!MessageBox class categoriesFor: #confirm:onYes:onNo:onCancel:!instance creation!public! !
!MessageBox class categoriesFor: #initialize!development!initializing!private! !

