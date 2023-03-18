"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Keyboard'
	instanceVariableNames: 'state virtualKeys modifierKeys keyNames'
	classVariableNames: 'DefaultInstance InvariantInstance'
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Keyboard guid: (Core.GUID fromString: '{87b4c496-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.Keyboard comment: '`Keyboard` is an abstraction over the system keyboard, and provides services to enquire and set the state of keys, and to map between key codes and the names of keys in the particular keyboard layout that the instance represents.

## Instance Variables:
  `state`			`<Array>`
  `virtualKeys`		`<dictionary>` mapping from the names of the keys in the represented keyboard layout to the corresponding Windows virtual key code
  `modifierKeys`	`<dictionary>` mapping from the names of the modifier keys in the represented keyboard layout to the corresponding Windows modifier flag
  `keyNames`		`<dictionary>` mapping from Windows virtual key codes to the name of the corresponding key in the represented keyboard layout

## Class Variables:
  `DefaultInstance`		`Keyboard` instance representing the current input language
  `InvariantInstance`		`Keyboard` instance represent the Dolphin invariant input language (UK English).
'!
!UI.Keyboard categoriesForClass!System-Support! !
!UI.Keyboard methodsFor!

asyncKeyState: virtualKeyCodeInteger
	"Private - Answer the state of the specified virtual key."

	^User32 getAsyncKeyState: virtualKeyCodeInteger!

buildVKeyMaps
	| nameToVk vkToName invariantKeys count |
	invariantKeys := self class invariant virtualKeys.
	count := invariantKeys size.
	nameToVk := PluggableLookupTable new: count searchPolicy: SearchPolicy caseInsensitive.
	vkToName := IdentityDictionary new: count.
	invariantKeys do: 
			[:each |
			(self getKeyNameFromVKey: each ifNone: nil)
				ifNotNil: 
					[:name |
					nameToVk at: name put: each.
					vkToName at: each put: name]].
	virtualKeys := nameToVk.
	keyNames := vkToName!

buttonKeys
	"Private - Answer an <IdentityDictionary> mapping between the names of the mouse buttons and the corresponding virtual key codes."

	^##(IdentityDictionary withAll: {#left -> VK_LBUTTON.
				#right -> VK_RBUTTON.
				#middle -> VK_MBUTTON.
				#xButton1 -> VK_XBUTTON1.
				#xButton2 -> VK_XBUTTON2})!

getKeyNameFromVKey: anInteger ifNone: exceptionHandler
	"Private - Answer the <readableString> name of the specified virtual key code in this Keyboard layout, or evaluate the exceptionHandler block if none."

	| scanCode |
	scanCode := self vKeyToScanCode: anInteger.
	scanCode == 0 ifTrue: [^exceptionHandler value].
	^(self keyNameFromScanCode: (scanCode bitOr: (anInteger bitAnd: -16r100)))
		ifNil: [exceptionHandler value]!

getState
	"Private - Refresh the cached Win32 asynchronous keyboard state ByteArray and answer it."

	state ifNil: [state := ByteArray new: 256].
	^(User32 getKeyboardState: state) ifTrue: [state] ifFalse: [User32 systemError]!

isAltDown
	"Answer whether the <ALT> key is down."

	^self isKeyDown: VK_MENU!

isButtonDown: aSymbol
	"Answer whether the mouse button identified by the symbolic name (e.g. #left, #right, or #middle) is currently pressed down."

	^self isKeyDown: (self buttonKeys at: aSymbol)!

isCancelDown
	"Answer whether the Cancel (CTRL+BREAK) key is down."

	^self isKeyDown: VK_CANCEL!

isCancelPressed
	"Answer whether the Cancel (CTRL+BREAK) key has been pressed or is being pressed."

	^self isKeyPressed: VK_CANCEL!

isCtrlDown
	"Answer whether the <CTRL> key is down."

	^self isKeyDown: VK_CONTROL!

isKeyDown: virtualKeyCodeInteger
	"Private - Answer whether the specified virtual key is down. Under Windows the high bit of
	a key state is set when the key is down, and GetKeyState() returns a signed short, so the
	result key state will be negative if a key is down."

	^(self keyState: virtualKeyCodeInteger) < 0!

isKeyPressed: virtualKeyCodeInteger
	"Private - Answer whether the specified virtual key has been pressed or is down now.
	Note this is not a reliable indication, so is only suitable for detecting Ctrl+Break or similar."

	^(self asyncKeyState: virtualKeyCodeInteger) anyMask: 16r8001!

isModifierDown
	"Answer whether the any of the keyboard modifier keys (Ctrl, Alt, Shift) are down."

	^##({VK_CONTROL. VK_SHIFT. VK_MENU}) anySatisfy: [:each | self isKeyDown: each]!

isShiftDown
	"Answer whether the <SHIFT> key is down."

	^self isKeyDown: VK_SHIFT!

keyNameFromLParam: anInteger
	"Private - Answer the <readableString> name of the specified key in this keyboard layout, or nil if the key cannot be translated."

	| buf len |
	buf := Utf16String newFixed: 32.
	len := User32
				getKeyNameText: anInteger
				lpString: buf
				nSize: buf basicSize + 1.	"includes null term"
	"Despite what the help says, the function does not call SetLastError(), so no point signalling a system error here"
	^len == 0 ifFalse: [buf resize: len]!

keyNameFromScanCode: anInteger 
	"Private - Answer the <readableString> name of the specified key scan code in this Keyboard layout, or nil if not translatable."

	^self keyNameFromLParam: (anInteger bitShift: 16)!

keyNameFromVKey: anInteger ifNone: aNiladicValuable
	"Private - Answer the <readableString> name of the specified virtual key code in this Keyboard layout, or evaluate the exception handler block, aNiladicValuable, if none."

	^self keyNames at: anInteger ifAbsent: aNiladicValuable!

keyNames
	"Answer a <dictionary> mapping from the <integer> virtual key codes to the <readableString> names of the keys in this Keyboard layout."

	^keyNames
		ifNil: 
			[self buildVKeyMaps.
			keyNames]!

keyState: virtualKeyCodeInteger
	"Private - Answer the state of the specified virtual key."

	^User32 getKeyState: virtualKeyCodeInteger!

modifierKeys
	"Answer a <dictionary> mapping from the <readableString> modifier key names (e.g. CTRL, ALT, SHIFT) in this keyboard layout, to the associated <integer> key modifier flag."

	^modifierKeys
		ifNil: 
			[| vks |
			vks := self keyNames.
			modifierKeys := SearchPolicy caseInsensitive newLookupTable
						at: (vks at: VK_CONTROL) put: FCONTROL;
						at: (vks at: VK_SHIFT) put: FSHIFT;
						at: (vks at: VK_MENU) put: FALT;
						yourself]!

resetCancel
	"Reset the Cancel (CTRL+BREAK) key."

	self resetKey: VK_CANCEL!

resetKey: virtualKeyCodeInteger
	"Private - Reset the specified virtual key."

	self setKeyState: virtualKeyCodeInteger to: 0!

setKeyState: virtualKeyCodeInteger to: byteMask
	"Private - Set the Win32 keyboard state of the specified virtual key to the specified byteMask"

	self getState at: virtualKeyCodeInteger+1 put: byteMask.
	self setState!

setState
	"Private - Modify Win32's keyboard state to that currently cached."

	state ifNotNil: [User32 setKeyboardState: state]!

virtualKeyFromString: aString
	"Answer the <integer> virtual key code for the named key from this keyboard layout."

	^(self virtualKeys lookup: aString)
		ifNil: [self error: ('Unrecognised virtual key: <1p>' expandMacrosWith: aString)]!

virtualKeys
	"Answer a <dictionary> mapping from the <readableString> key names in this layout to the associated <integer> virtual key code."

	^virtualKeys
		ifNil: 
			[self buildVKeyMaps.
			virtualKeys]!

virtualKeys: aLookupTableOfInteger
	virtualKeys := aLookupTableOfInteger.
	keyNames := IdentityDictionary new: virtualKeys size.
	aLookupTableOfInteger keysAndValuesDo: [:name :vk | keyNames at: vk put: name]!

vKeyToScanCode: anInteger
	"Private - Answer the scan code corresponding to the virtual key code, anInteger, or 0 if there isn't one."

	^User32 mapVirtualKey: (anInteger bitAnd: 16rFF) uMapType: MAPVK_VK_TO_VSC! !
!UI.Keyboard categoriesForMethods!
asyncKeyState:!helpers!private! !
buildVKeyMaps!helpers!private! !
buttonKeys!constants!private! !
getKeyNameFromVKey:ifNone:!helpers!private! !
getState!helpers!private! !
isAltDown!public!testing! !
isButtonDown:!public!testing! !
isCancelDown!public!testing! !
isCancelPressed!public!testing! !
isCtrlDown!public!testing! !
isKeyDown:!private!testing! !
isKeyPressed:!private!testing! !
isModifierDown!public!testing! !
isShiftDown!public!testing! !
keyNameFromLParam:!helpers!private! !
keyNameFromScanCode:!helpers!private! !
keyNameFromVKey:ifNone:!helpers!private! !
keyNames!accessing!private! !
keyState:!helpers!private! !
modifierKeys!accessing!private! !
resetCancel!operations!public! !
resetKey:!helpers!private! !
setKeyState:to:!helpers!private! !
setState!helpers!private! !
virtualKeyFromString:!enquiries!public! !
virtualKeys!accessing!private! !
virtualKeys:!initializing!private! !
vKeyToScanCode:!helpers!private! !
!

!UI.Keyboard class methodsFor!

default
	"Answers the default Keyboard to use"

	^DefaultInstance ifNil: [DefaultInstance := self new]!

default: aKeyboard
	"Assigns the default Keyboard"

	DefaultInstance := aKeyboard!

initialize
	"Private - Initialize the receiver's class variables.
		Keyboard initialize
	"

	InvariantInstance := DefaultInstance := nil.
	SessionManager current
		when: #settingChanged:
		send: #onSettingChanged:
		to: self!

invariant
	"Answers the Keyboard to use for invariant key names"

	^InvariantInstance
		ifNil: 
			[InvariantInstance := self new
						virtualKeys: self invariantVKeyMap;
						yourself]!

invariantVKeyMap
	"Private - Answer a <dictionary> mapping from invariant (UK English) key names to the corresponding virtual key code.
	These are the string names that should be used in code, as opposed to localised key names intended to be displayed to an end-user."

	"Yes, VK_OEM_PLUS really does translate to the key name '='"

	^SearchPolicy caseInsensitive newLookupTable
		addAll: {'BACKSPACE' -> VK_BACK.
					'TAB' -> VK_TAB.
					'ENTER' -> VK_RETURN.
					'SHIFT' -> VK_SHIFT.
					'CTRL' -> VK_CONTROL.
					'ALT' -> VK_MENU.
					'ESC' -> VK_ESCAPE.
					'SPACE' -> VK_SPACE.
					'0' -> $0 codePoint.
					'1' -> $1 codePoint.
					'2' -> $2 codePoint.
					'3' -> $3 codePoint.
					'4' -> $4 codePoint.
					'5' -> $5 codePoint.
					'6' -> $6 codePoint.
					'7' -> $7 codePoint.
					'8' -> $8 codePoint.
					'9' -> $9 codePoint.
					'A' -> $A codePoint.
					'B' -> $B codePoint.
					'C' -> $C codePoint.
					'D' -> $D codePoint.
					'E' -> $E codePoint.
					'F' -> $F codePoint.
					'G' -> $G codePoint.
					'H' -> $H codePoint.
					'I' -> $I codePoint.
					'J' -> $J codePoint.
					'K' -> $K codePoint.
					'L' -> $L codePoint.
					'M' -> $M codePoint.
					'N' -> $N codePoint.
					'O' -> $O codePoint.
					'P' -> $P codePoint.
					'Q' -> $Q codePoint.
					'R' -> $R codePoint.
					'S' -> $S codePoint.
					'T' -> $T codePoint.
					'U' -> $U codePoint.
					'V' -> $V codePoint.
					'W' -> $W codePoint.
					'X' -> $X codePoint.
					'Y' -> $Y codePoint.
					'Z' -> $Z codePoint.
					'NUM 0' -> VK_NUMPAD0.
					'NUM 1' -> VK_NUMPAD1.
					'NUM 2' -> VK_NUMPAD2.
					'NUM 3' -> VK_NUMPAD3.
					'NUM 4' -> VK_NUMPAD4.
					'NUM 5' -> VK_NUMPAD5.
					'NUM 6' -> VK_NUMPAD6.
					'NUM 7' -> VK_NUMPAD7.
					'NUM 8' -> VK_NUMPAD8.
					'NUM 9' -> VK_NUMPAD9.
					'NUMMULT' -> VK_MULTIPLY.
					'NUM PLUS' -> VK_ADD.
					'NUM SUB' -> VK_SUBTRACT.
					'NUM DIVIDE' -> (VK_DIVIDE | KF_EXTENDED).
					'NUM DECIMAL' -> VK_DECIMAL.
					'F1' -> VK_F1.
					'F2' -> VK_F2.
					'F3' -> VK_F3.
					'F4' -> VK_F4.
					'F5' -> VK_F5.
					'F6' -> VK_F6.
					'F7' -> VK_F7.
					'F8' -> VK_F8.
					'F9' -> VK_F9.
					'F10' -> VK_F10.
					'F11' -> VK_F11.
					'F12' -> VK_F12.
					'=' -> VK_OEM_PLUS.
					',' -> VK_OEM_COMMA.
					'-' -> VK_OEM_MINUS.
					'.' -> VK_OEM_PERIOD.
					';' -> VK_OEM_1.
					'/' -> VK_OEM_2.
					'[' -> VK_OEM_4.
					'\' -> VK_OEM_5.
					']' -> VK_OEM_6.
					'#' -> VK_OEM_7.
					'`' -> VK_OEM_8.
					'NUM ENTER' -> (VK_RETURN | KF_EXTENDED).
					'PGUP' -> (VK_PRIOR | KF_EXTENDED).
					'PGDOWN' -> (VK_NEXT | KF_EXTENDED).
					'END' -> (VK_END | KF_EXTENDED).
					'HOME' -> (VK_HOME | KF_EXTENDED).
					'LEFT' -> (VK_LEFT | KF_EXTENDED).
					'UP' -> (VK_UP | KF_EXTENDED).
					'RIGHT' -> (VK_RIGHT | KF_EXTENDED).
					'DOWN' -> (VK_DOWN | KF_EXTENDED).
					'INSERT' -> (VK_INSERT | KF_EXTENDED).
					'DEL' -> (VK_DELETE | KF_EXTENDED).
					'DELETE' -> (VK_DELETE | KF_EXTENDED).
					'PAUSE' -> VK_PAUSE.
					'CAPSLOCK' -> VK_CAPITAL};
		isImmutable: true;
		yourself!

layoutName
	"Answer the <readableString> name of the current keyboard layout."

	| buf |
	buf := Utf16String newFixed: KL_NAMELENGTH.
	^(User32 getKeyboardLayoutName: buf) ifTrue: [buf trimNulls] ifFalse: [User32 systemError]!

layoutName: aString
	"Set the current keyboard layout by <readableString> name, answering whether this was accepted.
	Note that this will only work if the Dolphin process owns the window with keyboard focus."

	^self layoutName = aString or: 
			[(User32 loadKeyboardLayout: aString flags: ##(KLF_ACTIVATE | KLF_SETFORPROCESS)) notNil and: 
					[DefaultInstance := nil.
					true]]!

onPreStripImage
	"Private - The image is about to be stripped."

	self uninitialize!

onSettingChanged: anArray 
	"Private - Respond to an OS settings change. Here we are only interested in a change of input language, and reset the default instance so that any subsequent access will pick up the new keyboard layout."

	anArray first = 'InputLang' ifFalse: [^self].
	DefaultInstance := nil!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	InvariantInstance := DefaultInstance := nil.!

virtualKey: aString
	"Answer the <integer> virtual key code corresponding to the key with invariant (UK English) name, aString."

	^self invariant virtualKeyFromString: aString! !
!UI.Keyboard class categoriesForMethods!
default!accessing!public! !
default:!accessing!public! !
initialize!development!initializing!private! !
invariant!accessing!public! !
invariantVKeyMap!constants!private! !
layoutName!accessing!public! !
layoutName:!accessing!public! !
onPreStripImage!class hierarchy-removing!private! !
onSettingChanged:!event handling-win32!private! !
uninitialize!class hierarchy-removing!private! !
virtualKey:!enquiries!public! !
!

