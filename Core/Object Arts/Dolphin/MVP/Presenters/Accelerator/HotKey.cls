"Filed out from Dolphin Smalltalk"!

ValueConvertingControlView subclass: #HotKey
	instanceVariableNames: 'invalidCombinationsRule defaultKeyRule'
	classVariableNames: ''
	poolDictionaries: 'HotKeyConstants'
	classInstanceVariableNames: ''!
HotKey guid: (GUID fromString: '{87b4c736-026e-11d3-9fd7-00a0cc3e4a32}')!
HotKey comment: 'HotKey is a <valueView> implementing the Windows "msctls_hotkey32" common control. The <valueModel> associated with a HotKey must always yield an <integer> hot-key value when mapped through the installed type converter. Typically, a HotKey view is configured with an AccelToHotKey <typeConverter> and used to display/edit accelerator key definitions. A HotKey will normally be used in conjunction with a <NumberPresenter>.

Instance Variables:
	invalidCombinationsRule	<integer> or nil, describing the key combinations which are invalid.
	defaultKeyRule		<integer> or nil, indicating the default key.


'!
!HotKey categoriesForClass!MVP-Views! !
!HotKey methodsFor!

currentModifiers
	"Private - Answer the a bit mask of the hot key modifiers corresponding
	to the current keyboard state. Note that this does NOT bitOr: in either
	HOTKEYF_EXT or the current default mask."

	| kb |
	kb := Keyboard default.
	^{VK_SHIFT -> HOTKEYF_SHIFT. VK_CONTROL -> HOTKEYF_CONTROL. VK_MENU -> HOTKEYF_ALT} inject: 0
		into: [:mask :each | (kb isKeyDown: each key) ifTrue: [mask bitOr: each value] ifFalse: [mask]]!

defaultExtent
	"Private - Answer the default size of the receiver. This is used only to
	set the size of a view when it is created. Thereafter preferredExtent is
	used when the desired size of a view is requested."

	^##(200 @ 25)!

defaultKeyMask
	"Answer the receiver's default key mask."

	^defaultKeyRule!

defaultKeyMask: anInteger
	"Set the receiver's default key mask."

	defaultKeyRule := anInteger.
	self setRules!

displayValue
	"Private - Answer an <integer> representation of the current hot key."

	^(self 
		sendMessage: HKM_GETHOTKEY
		wParam: 0
		lpParam: 0) bitAnd: 16rFFFF!

displayValue: anInteger 
	"Private - Set the hot-key of the receiver to the specified <integer> hot-key code."

	| code |
	code := anInteger isNil ifTrue: [0] ifFalse: [anInteger bitAnd: 16rFFFF].
	self setHotKey: (code bitAnd: 16rFF) modifiers: (code bitShift: -8)!

initialize
	"Private - Initialise the new receiver."

	super initialize.
	typeconverter := AccelToHotKey new.
	invalidCombinationsRule := defaultKeyRule := 0!

invalidCombinationsMask
	"Answer the receiver's invalid modifiers mask."

	^invalidCombinationsRule!

invalidCombinationsMask: anInteger
	"Set the receiver's invalid modifiers mask."

	invalidCombinationsRule := anInteger.
	self setRules!

onViewCreated
	"The receiver window has been created. Copy the info held
	in instance variables across to it"

	super onViewCreated.
	self setRules!

preTranslateKeyboardInput: aMSG 
	"Private - Dispatch keyboard input in the receiver directly to avoid accelerator table
	translation in containing shell."

	(UserLibrary default)
		translateMessage: aMSG;
		dispatchMessage: aMSG.
	^true!

setHotKey: hotKeyCode
	"Private - Set the receiver's hot key combination.
	N.B. HKM_SETHOTKEY has no return value.
	"

	self
		sendMessage: HKM_SETHOTKEY
		wParam: hotKeyCode
		lpParam: 0!

setHotKey: virtualKeyCode modifiers: modifiers
	"Private - Set the receiver's hot key combination.	"

	| mods |
	mods := modifiers.
	(virtualKeyCode anyMask: 16r100)
		ifTrue: [mods := mods maskSet: HOTKEYF_EXT].
	self setHotKey: ((virtualKeyCode bitAnd: 16rFF) bitOr: (mods bitShift: 8))!

setRules
	"Private - Set the receivers invalid modifiers and its default modifier."

	self
		sendMessage: HKM_SETRULES
		wParam: invalidCombinationsRule
		lpParam: defaultKeyRule!

wmKeyDown: message wParam: wParam lParam: lParam 
	"Private - Default handler for a WM_KEYDOWN.
	We override this in order to prevent VK_DELETE getting through to the HotKey
	control, which treats it literally, thus preventing the use of the Delete key as an 
	accelerator. Note that the control also absorbs other keys, such as "

	^wParam == VK_DELETE 
		ifTrue: 
			[self setHotKey: wParam
				modifiers: self currentModifiers | HOTKEYF_EXT | self defaultKeyMask.
			0	"suppress default processing"]
		ifFalse: 
			[super 
				wmKeyDown: message
				wParam: wParam
				lParam: lParam]!

wmKeyUp: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_KEYUP.
	Update the model with the latest key."

	self updateModel.
	^false!

wmSysKeyUp: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_SYSKEYUP.
	Update the model with the latest key"

	self updateModel.
	^false! !
!HotKey categoriesForMethods!
currentModifiers!accessing!private! !
defaultExtent!accessing!constants!private! !
defaultKeyMask!accessing!public! !
defaultKeyMask:!accessing!public! !
displayValue!private!updating! !
displayValue:!private!updating! !
initialize!initializing!private! !
invalidCombinationsMask!accessing!public! !
invalidCombinationsMask:!accessing!public! !
onViewCreated!event handling!public! !
preTranslateKeyboardInput:!dispatching!public! !
setHotKey:!accessing!private! !
setHotKey:modifiers:!accessing!private! !
setRules!accessing!private! !
wmKeyDown:wParam:lParam:!event handling!event handling-win32!private! !
wmKeyUp:wParam:lParam:!event handling-win32!private! !
wmSysKeyUp:wParam:lParam:!event handling-win32!private! !
!

!HotKey class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'msctls_hotkey32'! !
!HotKey class categoriesForMethods!
icon!constants!public! !
winClassName!constants!private! !
!

