"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.AbstractKeyboardTest'
	instanceVariableNames: 'savedLayout'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.AbstractKeyboardTest guid: (Core.GUID fromString: '{973884cb-33cb-45e6-a489-48d76699c608}')!
UI.Tests.AbstractKeyboardTest isNonInstantiable: true!
UI.Tests.AbstractKeyboardTest comment: ''!
!UI.Tests.AbstractKeyboardTest methodsFor!

setCurrentKeyboardLayout: aString
	| current |
	current := Keyboard layoutName.
	^current = aString or: 
			[(Keyboard layoutName: aString) and: 
					[savedLayout ifNil: [savedLayout := current].
					true]]!

setUkKeyboard
	^self setCurrentKeyboardLayout: '00000809'!

setUsKeyboard
	^self setCurrentKeyboardLayout: '00000409'!

tearDown
	savedLayout ifNotNil: [Keyboard layoutName: savedLayout].
	super tearDown! !
!UI.Tests.AbstractKeyboardTest categoriesForMethods!
setCurrentKeyboardLayout:!helpers!private! !
setUkKeyboard!initializing!private! !
setUsKeyboard!initializing!private! !
tearDown!private!Running! !
!

