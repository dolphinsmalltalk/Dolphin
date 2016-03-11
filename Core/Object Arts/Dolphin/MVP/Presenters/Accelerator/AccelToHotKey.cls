"Filed out from Dolphin Smalltalk 7"!

TypeConverter subclass: #AccelToHotKey
	instanceVariableNames: ''
	classVariableNames: 'ModifierMap'
	poolDictionaries: 'HotKeyConstants Win32Constants'
	classInstanceVariableNames: ''!
AccelToHotKey guid: (GUID fromString: '{87B4C704-026E-11D3-9FD7-00A0CC3E4A32}')!
AccelToHotKey comment: 'AccelToHotKey is the class of <typeConverter> for use with the <HotKey> control to convert from a hot key code to the usual display representation of such key combinations, e.g. CTRL+C.

Class Variables:
	ModifierMap	<Array> of <association>s for mapping hot key modifier masks to accelerator table masks.


'!
!AccelToHotKey categoriesForClass!MVP-Type Converters-General! !
!AccelToHotKey methodsFor!

leftToRight: accelKeyCode
	"Private - Answers an <integer> hot key code which is the result of converting
	from an <integer> accelKeyCode"

	| keyCodes modifiers |
	keyCodes := AcceleratorTable splitKeyCode: accelKeyCode.
	modifiers := self class accelToHotKeyModifiers: keyCodes last.
	(accelKeyCode allMask: 16r100) ifTrue: [modifiers := modifiers bitOr: HOTKEYF_EXT].
	^(keyCodes first bitAnd: 16rFF) 
		bitOr: (modifiers bitShift: 8)!

rightToLeft: anInteger 
	"Private - Answers the <integer> accelerator code which is the result of  converting from
	the specified <integer> hotkey code."

	"From MSDN: '[A hotkey code contains] the virtual key code and modifier flags. The virtual
	key code is in the LOWORD, and the modifier flags are in the HIWORD.' 
	This is incorrect since only a 16-bit value is returned."

	| hotKeyModifiers vKey |
	hotKeyModifiers := anInteger bitShift: -8.
	vKey := anInteger bitAnd: 255.
	(hotKeyModifiers allMask: HOTKEYF_EXT) ifTrue: [vKey := vKey bitOr: 16r100].
	^AcceleratorTable keyCode: vKey modifiers: (self class hotKeyToAccelModifiers: hotKeyModifiers)! !
!AccelToHotKey categoriesFor: #leftToRight:!operations!private! !
!AccelToHotKey categoriesFor: #rightToLeft:!operations!private! !

!AccelToHotKey class methodsFor!

accelToHotKeyModifiers: accelKeyModMask 
	"Private - Convert an accelerator table modifier mask to the equivalent 
	hot key mask."

	^ModifierMap inject: 0
		into: 
			[:hotKeyMask :each | 
			(accelKeyModMask anyMask: each value) ifTrue: [hotKeyMask maskSet: each key] ifFalse: [hotKeyMask]]!

hotKeyToAccelModifiers: hotKeyModMask 
	"Private - Convert a hot key modifier mask to the equivalent accelerator table
	mask."

	^ModifierMap inject: FVIRTKEY
		into: [:accelMask :each | (hotKeyModMask anyMask: each key) ifTrue: [accelMask maskSet: each value] ifFalse: [accelMask]]!

initialize
	"Private - Initialize the receiver's class variables.
		AccelToHotKey initialize
	"

	ModifierMap :=
		(Array 
			with: HOTKEYF_CONTROL -> FCONTROL
			with: HOTKEYF_SHIFT -> FSHIFT
			with: HOTKEYF_ALT -> FALT
			"There is no representation for extended keys, but we need one so
			as not to lose that attribute when translating to/from virtual keys.
			By copying across this bit to the scan code after conversion from a
			virtual key code, we get the right scan code."
			with: HOTKEYF_EXT -> 16r100)! !
!AccelToHotKey class categoriesFor: #accelToHotKeyModifiers:!initializing!private! !
!AccelToHotKey class categoriesFor: #hotKeyToAccelModifiers:!initializing!private! !
!AccelToHotKey class categoriesFor: #initialize!development!initializing!private! !

