﻿"Filed out from Dolphin Smalltalk"!

UI.Tests.AbstractKeyboardTest
	subclass: #'UI.Tests.AcceleratorTableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.AcceleratorTableTest guid: (Core.GUID fromString: '{ffc00c13-8da5-4b75-b82d-f96bba254efe}')!

UI.Tests.AcceleratorTableTest comment: ''!

!UI.Tests.AcceleratorTableTest methodsFor!

numMultCode
	^(FVIRTKEY | FALT) << 9 | VK_MULTIPLY!

testKeycodeFromString
	<skipUnless: #setUkKeyboard>

	"Other keys where the VK code is not the Ascii codepoint"
	{',' -> VK_OEM_COMMA. '-' -> VK_OEM_MINUS. '.' -> VK_OEM_PERIOD}
		, ((1 to: 9) collect: [:each | ('NUM ' , each displayString) -> (VK_NUMPAD1 + each - 1)]) do: 
				[:each |
				| code keyString |
				code := each value | (FVIRTKEY << 9).
				keyString := each key.
				self assert: code equals: (AcceleratorTable keyCodeFromString: keyString).
				self assert: code | (FCONTROL << 9)
					equals: (AcceleratorTable keyCodeFromString: 'Ctrl+' , keyString).
				self assert: code | (FSHIFT << 9) equals: (AcceleratorTable keyCodeFromString: 'Shift+' , keyString).
				self assert: code | (FALT << 9) equals: (AcceleratorTable keyCodeFromString: 'Alt+' , keyString).
				self assert: code | ((FSHIFT | FCONTROL) << 9)
					equals: (AcceleratorTable keyCodeFromString: 'Ctrl+Shift+' , keyString)].
	"		with: '+' -> VK_OEM_PLUS"
	"Extended keys"
	{'END' -> VK_END. 'DOWN' -> VK_DOWN. 'PGUP' -> VK_PRIOR} do: 
			[:each |
			| code keyString |
			code := each value | KF_EXTENDED | (FVIRTKEY << 9).
			keyString := each key.
			self assert: code equals: (AcceleratorTable keyCodeFromString: keyString).
			self assert: code | (FCONTROL << 9)
				equals: (AcceleratorTable keyCodeFromString: 'Ctrl+' , keyString).
			self assert: code | (FSHIFT << 9) equals: (AcceleratorTable keyCodeFromString: 'Shift+' , keyString).
			self assert: code | (FALT << 9) equals: (AcceleratorTable keyCodeFromString: 'Alt+' , keyString).
			self assert: code | ((FSHIFT | FCONTROL) << 9)
				equals: (AcceleratorTable keyCodeFromString: 'Ctrl+Shift+' , keyString)].
	#(#('CTRL+NUM 1' 4705)) do: 
			[:each |
			self assert: each last equals: (AcceleratorTable keyCodeFromString: each first).
			self]!

testKeycodeFromStringAlphaNumerics
	"for alphanumerics, the keycode corresponds with the ascii code point"

	"Use the US keyboard layout so that this test at least will run on the CI build"
	<skipUnless: #setUsKeyboard>
	($A codePoint to: $Z codePoint) , ($0 codePoint to: $9 codePoint) do: 
			[:each |
			| code keyString |
			"The FVIRTKEY modifier flag should always be set."
			code := each | (FVIRTKEY << 9).
			keyString := (Character value: each) asString.
			self assert: code equals: (AcceleratorTable keyCodeFromString: keyString).
			self assert: code | (FCONTROL << 9)
				equals: (AcceleratorTable keyCodeFromString: 'Ctrl+' , keyString).
			self assert: code | (FSHIFT << 9) equals: (AcceleratorTable keyCodeFromString: 'Shift+' , keyString).
			self assert: code | (FALT << 9) equals: (AcceleratorTable keyCodeFromString: 'Alt+' , keyString).
			self assert: code | ((FSHIFT | FCONTROL) << 9)
				equals: (AcceleratorTable keyCodeFromString: 'cTrl+sHift+' , keyString)]!

testRoundTrippingInvariantKeyNames
	| invariant |
	invariant := AcceleratorTable invariantKeyStringFromCode: self numMultCode.
	self assert: invariant equals: 'ALT+NUMMULT'.
	self assert: (AcceleratorTable keyCodeFromInvariantString: invariant) equals: self numMultCode!

testRoundTrippingKeyNames
	"https://github.com/dolphinsmalltalk/Dolphin/issues/159."

	"Fails with US keyboard in the presence of the bug"
	<skipUnless: #setUsKeyboard>
	| localised |
	localised := AcceleratorTable keyStringFromCode: self numMultCode.
	self assert: localised equals: 'Alt+Num *'.
	self assert: (AcceleratorTable keyCodeFromString: localised) equals: self numMultCode! !

!UI.Tests.AcceleratorTableTest categoriesForMethods!
numMultCode!constants!private! !
testKeycodeFromString!public!unit tests! !
testKeycodeFromStringAlphaNumerics!public!unit tests! !
testRoundTrippingInvariantKeyNames!public!unit tests! !
testRoundTrippingKeyNames!public!unit tests! !
!

