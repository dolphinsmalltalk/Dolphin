"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'UI.Tests.AbstractKeyboardTest'
	instanceVariableNames: 'savedLayout'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.AbstractKeyboardTest guid: (Core.GUID fromString: '{973884cb-33cb-45e6-a489-48d76699c608}')!
UI.Tests.AbstractKeyboardTest isNonInstantiable: true!
UI.Tests.AbstractKeyboardTest comment: ''!
!UI.Tests.AbstractKeyboardTest categoriesForClass!Unclassified! !
!UI.Tests.AbstractKeyboardTest methodsFor!

setCurrentKeyboardLayout: aString
	| current |
	current := Keyboard layoutName.
	^current = aString or: 
			[(Keyboard layoutName: aString) and: 
					[savedLayout ifNil: [savedLayout := current].
					true]]!

tearDown
	savedLayout ifNotNil: [Keyboard layoutName: savedLayout]! !
!UI.Tests.AbstractKeyboardTest categoriesFor: #setCurrentKeyboardLayout:!helpers!private! !
!UI.Tests.AbstractKeyboardTest categoriesFor: #tearDown!private!Running! !

