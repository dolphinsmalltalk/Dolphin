"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Keyboard
	instanceVariableNames: 'state'
	classVariableNames: 'DefaultInstance VirtualKeys'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Keyboard guid: (GUID fromString: '{87b4c496-026e-11d3-9fd7-00a0cc3e4a32}')!
Keyboard comment: ''!
!Keyboard categoriesForClass!System-Support! !
!Keyboard methodsFor!

asyncKeyState: virtualKeyCodeInteger
	"Private - Answer the state of the specified virtual key."

	^UserLibrary default getAsyncKeyState: virtualKeyCodeInteger!

getState
	"Private - Refresh the cached Win32 asynchronous keyboard state ByteArray and answer it."

	^(UserLibrary default getKeyboardState: state)
		ifTrue: [state]
		ifFalse: [UserLibrary default systemError]!

initialize
	"Private - Initialize the receiver."

	state := ByteArray new: 256!

isAltDown
	"Answer whether the <ALT> key is down."

	^self isKeyDown: VK_MENU!

isButtonDown: aSymbol 
	"Answer whether the mouse button identified by the symbolic name (either #left, #right, or #middle)
	is currently pressed down."

	^self 
		isKeyDown: (##((IdentityDictionary new)
				at: #left put: VK_LBUTTON;
				at: #right put: VK_RBUTTON;
				at: #middle put: VK_MBUTTON;
				at: #xButton1 put: VK_XBUTTON1;
				at: #xButton2 put: VK_XBUTTON2;
				yourself) at: aSymbol)!

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

	^##(Array 
		with: VK_CONTROL
		with: VK_SHIFT
		with: VK_MENU) anySatisfy: [:each | self isKeyDown: each]!

isShiftDown
	"Answer whether the <SHIFT> key is down."

	^self isKeyDown: VK_SHIFT!

keyState: virtualKeyCodeInteger
	"Private - Answer the state of the specified virtual key."

	^UserLibrary default getKeyState: virtualKeyCodeInteger!

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

	UserLibrary default setKeyboardState: state
! !
!Keyboard categoriesFor: #asyncKeyState:!accessing!private! !
!Keyboard categoriesFor: #getState!accessing!private! !
!Keyboard categoriesFor: #initialize!initializing!private! !
!Keyboard categoriesFor: #isAltDown!public!testing! !
!Keyboard categoriesFor: #isButtonDown:!public!testing! !
!Keyboard categoriesFor: #isCancelDown!public!testing! !
!Keyboard categoriesFor: #isCancelPressed!public!testing! !
!Keyboard categoriesFor: #isCtrlDown!public!testing! !
!Keyboard categoriesFor: #isKeyDown:!private!testing! !
!Keyboard categoriesFor: #isKeyPressed:!private!testing! !
!Keyboard categoriesFor: #isModifierDown!public!testing! !
!Keyboard categoriesFor: #isShiftDown!public!testing! !
!Keyboard categoriesFor: #keyState:!accessing!private! !
!Keyboard categoriesFor: #resetCancel!accessing!public! !
!Keyboard categoriesFor: #resetKey:!accessing!private! !
!Keyboard categoriesFor: #setKeyState:to:!accessing!private! !
!Keyboard categoriesFor: #setState!accessing!private! !

!Keyboard class methodsFor!

buildVKeyMap
	^(LookupTable new)
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
		at: 'NUM DECIMAL' put: 16r6E;
		at: '/' put: VK_DIVIDE;
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
		at: '[' put: VK_OEM_4;
		at: '\' put: VK_OEM_5;
		at: ']' put: VK_OEM_6;
		at: '#' put: VK_OEM_7;
		at: '`' put: VK_OEM_8;
		at: 'NUM ENTER' put: VK_RETURN | 16r100;
		at: 'PGUP' put: VK_PRIOR | 16r100;
		at: 'PGDOWN' put: VK_NEXT | 16r100;
		at: 'END' put: VK_END | 16r100;
		at: 'HOME' put: VK_HOME | 16r100;
		at: 'LEFT' put: VK_LEFT | 16r100;
		at: 'UP' put: VK_UP | 16r100;
		at: 'RIGHT' put: VK_RIGHT | 16r100;
		at: 'DOWN' put: VK_DOWN | 16r100;
		at: 'INSERT' put: VK_INSERT | 16r100;
		at: 'DEL' put: VK_DELETE | 16r100;
		at: 'DELETE' put: VK_DELETE | 16r100;
		shrink;
		isImmutable: true;
		yourself!

default
	"Answers the default Keyboard to use"

	DefaultInstance isNil ifTrue: [self default: self new initialize].
	^DefaultInstance!

default: aKeyboard
	"Assigns the default Keyboard"

	DefaultInstance := aKeyboard!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		Keyboard initialize
	"

	VirtualKeys := self buildVKeyMap!

keyNameFromLParam: lParam
	"Private - Answer the name of the specified key.
	Answers nil if the key cannot be translated."

	| buf len |
	buf := String new: 32.
	len := UserLibrary default
			getKeyNameText: lParam lpString: buf nSize: buf basicSize+1.	"includes null term"
	"Despite what the help says, the function does not call SetLastError(), so no
	point signalling a system error here"
	len == 0 ifTrue: [^nil].
	^buf leftString: len!

keyNameFromScanCode: anInteger 
	"Private - Answer the name of the specified key scan code.
	Answers nil if not translatable.
	"

	^self keyNameFromLParam: (anInteger bitShift: 16)!

keyNameFromVKey: anInteger
	"Private - Answer the name of the specified virtual key code.
		Keyboard keyNameFromVKey: 16r23
	"

	^self
		keyNameFromVKey: anInteger 
		ifNone: [self error: 'invalid virtual key ', anInteger displayString]!

keyNameFromVKey: anInteger ifNone: exceptionHandler 
	"Private - Answer the name of the specified virtual key code,
	or evaluate the exceptionHandler block if none."

	| scanCode |
	scanCode := self vKeyToScanCode: anInteger.
	scanCode == 0 ifTrue: [^exceptionHandler value].
	^(self keyNameFromScanCode: (scanCode bitOr: (anInteger maskClear: 16rFF))) 
		ifNil: [exceptionHandler value]!

onPreStripImage
	"Private - The image is about to be stripped."

	self uninitialize!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	DefaultInstance := nil.!

virtualKey: aString 
	"Answer the <integer> virtual key code corresponding to the key with
	English name, aString."

	^VirtualKeys at: aString asUppercase
		ifAbsent: [self error: 'Unrecognised virtual key: ''' , aString , '''']!

vKeyToScanCode: anInteger 
	"Private - Answer the scan code corresponding to the virtual key code, anInteger, or 0 if
	there isn't one."

	^UserLibrary default mapVirtualKey: (anInteger bitAnd: 16rFF) uMapType: MAPVK_VK_TO_VSC! !
!Keyboard class categoriesFor: #buildVKeyMap!**auto generated**!development!private! !
!Keyboard class categoriesFor: #default!accessing!public! !
!Keyboard class categoriesFor: #default:!accessing!public! !
!Keyboard class categoriesFor: #icon!constants!public! !
!Keyboard class categoriesFor: #initialize!development!initializing!private! !
!Keyboard class categoriesFor: #keyNameFromLParam:!constants!private! !
!Keyboard class categoriesFor: #keyNameFromScanCode:!constants!private! !
!Keyboard class categoriesFor: #keyNameFromVKey:!constants!private! !
!Keyboard class categoriesFor: #keyNameFromVKey:ifNone:!constants!private! !
!Keyboard class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Keyboard class categoriesFor: #uninitialize!initializing!private! !
!Keyboard class categoriesFor: #virtualKey:!constants!public! !
!Keyboard class categoriesFor: #vKeyToScanCode:!constants!private! !

