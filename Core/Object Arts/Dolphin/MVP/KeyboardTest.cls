"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #KeyboardTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
KeyboardTest guid: (GUID fromString: '{01935B3B-EFE5-44CD-8432-57C152A08BA6}')!
KeyboardTest comment: ''!
!KeyboardTest categoriesForClass!Unclassified! !
!KeyboardTest methodsFor!

testVirtualKeyMap
	| vkeys specialCases |
	"If not the UK keyboard layout, then the key names may be different."
	self assert: (Locale lcid: (UserLibrary default getKeyboardLayout: 0) lowWord) asParameter = 2057. 
	vkeys := Keyboard classPool at: 'VirtualKeys'.
	specialCases := #('DEL' 'PAUSE') asSet.
	(vkeys associations reject: [:each | specialCases includes: each key]) do: 
			[:each | 
			| keyName |
			keyName := (Keyboard keyNameFromVKey: each value) asUppercase.
			self assert: keyName = each key].
	"Now the special cases"
	self assert: (vkeys at: 'PAUSE') = VK_PAUSE.
	self assert: (vkeys at: 'DEL') = (vkeys at: 'DELETE')! !
!KeyboardTest categoriesFor: #testVirtualKeyMap!public!unit tests! !

