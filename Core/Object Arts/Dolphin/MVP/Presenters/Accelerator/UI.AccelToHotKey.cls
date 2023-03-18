"Filed out from Dolphin Smalltalk"!

UI.TypeConverter
	subclass: #'UI.AccelToHotKey'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.HotKeyConstants} #{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: { 'ModifierMap' -> #(16r1 16r4 16r2 16r8 16r4 16r10) }!
UI.AccelToHotKey guid: (Core.GUID fromString: '{87b4c704-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.AccelToHotKey comment: 'AccelToHotKey is the class of <typeConverter> for use with the <HotKey> control to convert from a hot key code to the usual display representation of such key combinations, e.g. CTRL+C.

Class Variables:
	ModifierMap	<Array> of <association>s for mapping hot key modifier masks to accelerator table masks.


'!
!UI.AccelToHotKey categoriesForClass!MVP-Type Converters-General! !
!UI.AccelToHotKey methodsFor!

leftToRight: accelKeyCode
	"Private - Answers an <integer> hot key code which is the result of converting
	from an <integer> accelKeyCode"

	| keyCodes modifiers |
	keyCodes := AcceleratorTable splitKeyCode: accelKeyCode.
	modifiers := self class accelToHotKeyModifiers: keyCodes last.
	"There is no representation for extended keys, but we need one so as not to lose that attribute when translating to/from virtual keys.
	By adding the HOTKEYF_EXT bit to the hot key code after conversion from a virtual key code with KF_EXTENDED, we get the right code."
	(accelKeyCode allMask: KF_EXTENDED) ifTrue: [modifiers := modifiers bitOr: HOTKEYF_EXT].
	^(keyCodes first bitAnd: 16rFF) bitOr: (modifiers bitShift: 8)!

rightToLeft: anInteger
	"Private - Answers the <integer> accelerator code which is the result of  converting from
	the specified <integer> hotkey code."

	"From MSDN: '[A hotkey code contains] the virtual key code and modifier flags. The virtual
	key code is in the LOWORD, and the modifier flags are in the HIWORD.' 
	This is incorrect since only a 16-bit value is returned."

	| hotKeyModifiers vKey |
	hotKeyModifiers := anInteger bitShift: -8.
	vKey := anInteger bitAnd: 255.
	"Preserve the HOTKEYF_EXT flag by combining KF_EXTENDED with the VK_"
	(hotKeyModifiers allMask: HOTKEYF_EXT) ifTrue: [vKey := vKey bitOr: KF_EXTENDED].
	^AcceleratorTable keyCode: vKey modifiers: (self class hotKeyToAccelModifiers: hotKeyModifiers)! !
!UI.AccelToHotKey categoriesForMethods!
leftToRight:!operations!private! !
rightToLeft:!operations!private! !
!

!UI.AccelToHotKey class methodsFor!

accelToHotKeyModifiers: accelKeyModMask
	"Private - Convert an accelerator table modifier mask to the equivalent hot key mask."

	| hotKeyMask |
	hotKeyMask := 0.
	1 to: ModifierMap size
		by: 2
		do: 
			[:i |
			(accelKeyModMask anyMask: (ModifierMap at: i + 1))
				ifTrue: [hotKeyMask := hotKeyMask bitOr: (ModifierMap at: i)]].
	^hotKeyMask!

hotKeyToAccelModifiers: anInteger
	"Private - Convert <integer> hot key modifier flags from the HOTKEYF_xxx enumeration to the equivalent accelerator table modifier flags.
	Note that this will always include the FVIRTKEY flag."

	| modifiers |
	modifiers := FVIRTKEY.
	1 to: ModifierMap size
		by: 2
		do: 
			[:i |
			(anInteger anyMask: (ModifierMap at: i))
				ifTrue: [modifiers := modifiers bitOr: (ModifierMap at: i + 1)]].
	^modifiers!

initialize
	"Private - Initialize the receiver's class variables.
		AccelToHotKey initialize
	"

	self addClassConstant: 'ModifierMap'
		value: {HOTKEYF_SHIFT. FSHIFT. HOTKEYF_CONTROL. FCONTROL. HOTKEYF_ALT. FALT}! !
!UI.AccelToHotKey class categoriesForMethods!
accelToHotKeyModifiers:!initializing!private! !
hotKeyToAccelModifiers:!initializing!private! !
initialize!development!initializing!private! !
!

