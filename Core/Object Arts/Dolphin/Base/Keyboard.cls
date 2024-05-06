"Filed out from Dolphin Smalltalk"!

Object subclass: #Keyboard
	instanceVariableNames: 'state virtualKeys modifierKeys keyNames'
	classVariableNames: 'DefaultInstance InvariantInstance'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

Keyboard guid: (GUID fromString: '{87b4c496-026e-11d3-9fd7-00a0cc3e4a32}')!

Keyboard comment: '`Keyboard` is an abstraction over the system keyboard, and provides services to enquire and set the state of keys, and to map between key codes and the names of keys in the particular keyboard layout that the instance represents.

## Instance Variables:
  `state`			`<Array>`
  `virtualKeys`		`<dictionary>` mapping from the names of the keys in the represented keyboard layout to the corresponding Windows virtual key code
  `modifierKeys`	`<dictionary>` mapping from the names of the modifier keys in the represented keyboard layout to the corresponding Windows modifier flag
  `keyNames`		`<dictionary>` mapping from Windows virtual key codes to the name of the corresponding key in the represented keyboard layout

## Class Variables:
  `DefaultInstance`		`Keyboard` instance representing the current input language
  `InvariantInstance`		`Keyboard` instance represent the Dolphin invariant input language (UK English).
'!

!Keyboard categoriesForClass!System-Support! !

!Keyboard methodsFor!

asyncKeyState: virtualKeyCodeInteger
	"Private - Answer the state of the specified virtual key."

	^UserLibrary default getAsyncKeyState: virtualKeyCodeInteger!

buildVKeyMaps
	"Private - Answer a <dictionary> mapping from the localised key names in the current keyboard layout to the corresponding virtual key code."

	| nameToVk vkToName |
	nameToVk := SearchPolicy caseInsensitive newLookupTable.
	vkToName := IdentityDictionary new.
	self class invariant virtualKeys do: 
			[:each |
			(self getKeyNameFromVKey: each ifNone: [])
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
	^(UserLibrary default getKeyboardState: state)
		ifTrue: [state]
		ifFalse: [UserLibrary default systemError]!

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
	len := UserLibrary default
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

	^UserLibrary default getKeyState: virtualKeyCodeInteger!

modifierKeys
	"Answer a <dictionary> mapping from the <readableString> modifier key names (e.g. CTRL, ALT, SHIFT) in this keyboard layout, to the associated <integer> key modifier flag."

	^modifierKeys
		ifNil: 
			[| vks |
			vks := self keyNames.
			modifierKeys := SearchPolicy caseInsensitive newLookupTable
						at: (vks at: VK_SHIFT) put: FSHIFT;
						at: (vks at: VK_CONTROL) put: FCONTROL;
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

	state ifNotNil: [UserLibrary default setKeyboardState: state]
!

virtualKeyFromString: aString
	"Answer the <integer> virtual key code for the named key from this keyboard layout."

	^self virtualKeys at: aString
		ifAbsent: [self error: ('Unrecognised virtual key: <1p>' expandMacrosWith: aString)]!

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

	^UserLibrary default mapVirtualKey: (anInteger bitAnd: 16rFF) uMapType: MAPVK_VK_TO_VSC! !

!Keyboard categoriesForMethods!
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

!Keyboard class methodsFor!

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
		at: 'BACKSPACE' put: VK_BACK;
		at: 'TAB' put: VK_TAB;
		at: 'ENTER' put: VK_RETURN;
		at: 'SHIFT' put: VK_SHIFT;
		at: 'CTRL' put: VK_CONTROL;
		at: 'ALT' put: VK_MENU;
		at: 'PAUSE' put: VK_PAUSE;
		at: 'CAPSLOCK' put: VK_CAPITAL;
		at: 'ESC' put: VK_ESCAPE;
		at: 'SPACE' put: VK_SPACE;
		at: '0' put: $0 codePoint;
		at: '1' put: $1 codePoint;
		at: '2' put: $2 codePoint;
		at: '3' put: $3 codePoint;
		at: '4' put: $4 codePoint;
		at: '5' put: $5 codePoint;
		at: '6' put: $6 codePoint;
		at: '7' put: $7 codePoint;
		at: '8' put: $8 codePoint;
		at: '9' put: $9 codePoint;
		at: 'A' put: $A codePoint;
		at: 'B' put: $B codePoint;
		at: 'C' put: $C codePoint;
		at: 'D' put: $D codePoint;
		at: 'E' put: $E codePoint;
		at: 'F' put: $F codePoint;
		at: 'G' put: $G codePoint;
		at: 'H' put: $H codePoint;
		at: 'I' put: $I codePoint;
		at: 'J' put: $J codePoint;
		at: 'K' put: $K codePoint;
		at: 'L' put: $L codePoint;
		at: 'M' put: $M codePoint;
		at: 'N' put: $N codePoint;
		at: 'O' put: $O codePoint;
		at: 'P' put: $P codePoint;
		at: 'Q' put: $Q codePoint;
		at: 'R' put: $R codePoint;
		at: 'S' put: $S codePoint;
		at: 'T' put: $T codePoint;
		at: 'U' put: $U codePoint;
		at: 'V' put: $V codePoint;
		at: 'W' put: $W codePoint;
		at: 'X' put: $X codePoint;
		at: 'Y' put: $Y codePoint;
		at: 'Z' put: $Z codePoint;
		at: 'NUM 0' put: VK_NUMPAD0;
		at: 'NUM 1' put: VK_NUMPAD1;
		at: 'NUM 2' put: VK_NUMPAD2;
		at: 'NUM 3' put: VK_NUMPAD3;
		at: 'NUM 4' put: VK_NUMPAD4;
		at: 'NUM 5' put: VK_NUMPAD5;
		at: 'NUM 6' put: VK_NUMPAD6;
		at: 'NUM 7' put: VK_NUMPAD7;
		at: 'NUM 8' put: VK_NUMPAD8;
		at: 'NUM 9' put: VK_NUMPAD9;
		at: 'NUMMULT' put: VK_MULTIPLY;
		at: 'NUM PLUS' put: VK_ADD;
		at: 'NUM SUB' put: VK_SUBTRACT;
		at: 'NUM DIVIDE' put: VK_DIVIDE | KF_EXTENDED;
		at: 'NUM DECIMAL' put: VK_DECIMAL;
		at: 'F1' put: VK_F1;
		at: 'F2' put: VK_F2;
		at: 'F3' put: VK_F3;
		at: 'F4' put: VK_F4;
		at: 'F5' put: VK_F5;
		at: 'F6' put: VK_F6;
		at: 'F7' put: VK_F7;
		at: 'F8' put: VK_F8;
		at: 'F9' put: VK_F9;
		at: 'F10' put: VK_F10;
		at: 'F11' put: VK_F11;
		at: 'F12' put: VK_F12;
		at: '=' put: VK_OEM_PLUS;
		at: ',' put: VK_OEM_COMMA;
		at: '-' put: VK_OEM_MINUS;
		at: '.' put: VK_OEM_PERIOD;
		at: '/' put: VK_OEM_2;
		at: '[' put: VK_OEM_4;
		at: '\' put: VK_OEM_5;
		at: ']' put: VK_OEM_6;
		at: '#' put: VK_OEM_7;
		at: '`' put: VK_OEM_8;
		at: 'NUM ENTER' put: VK_RETURN | KF_EXTENDED;
		at: 'PGUP' put: VK_PRIOR | KF_EXTENDED;
		at: 'PGDOWN' put: VK_NEXT | KF_EXTENDED;
		at: 'END' put: VK_END | KF_EXTENDED;
		at: 'HOME' put: VK_HOME | KF_EXTENDED;
		at: 'LEFT' put: VK_LEFT | KF_EXTENDED;
		at: 'UP' put: VK_UP | KF_EXTENDED;
		at: 'RIGHT' put: VK_RIGHT | KF_EXTENDED;
		at: 'DOWN' put: VK_DOWN | KF_EXTENDED;
		at: 'INSERT' put: VK_INSERT | KF_EXTENDED;
		at: 'DEL' put: VK_DELETE | KF_EXTENDED;
		at: 'DELETE' put: VK_DELETE | KF_EXTENDED;
		shrink;
		isImmutable: true;
		yourself!

layoutName
	"Answer the <readableString> name of the current keyboard layout."

	| buf |
	buf := Utf16String newFixed: KL_NAMELENGTH.
	^(UserLibrary default getKeyboardLayoutName: buf)
		ifTrue: [buf trimNulls]
		ifFalse: [UserLibrary default systemError]

!

layoutName: aString
	"Set the current keyboard layout by <readableString> name, answering whether this was accepted.
	Note that this will only work if the Dolphin process owns the window with keyboard focus."

	^self layoutName = aString or: 
			[(UserLibrary default loadKeyboardLayout: aString flags: ##(KLF_ACTIVATE | KLF_SETFORPROCESS))
				notNil and: 
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

!Keyboard class categoriesForMethods!
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

