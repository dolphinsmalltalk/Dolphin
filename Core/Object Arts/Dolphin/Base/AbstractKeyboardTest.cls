"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #AbstractKeyboardTest
	instanceVariableNames: 'savedLayout'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

AbstractKeyboardTest guid: (GUID fromString: '{973884cb-33cb-45e6-a489-48d76699c608}')!

AbstractKeyboardTest isAbstract: true!

AbstractKeyboardTest comment: ''!

!AbstractKeyboardTest categoriesForClass!Unclassified! !

!AbstractKeyboardTest methodsFor!

setCurrentKeyboardLayout: aString
	| current |
	current := Keyboard layoutName.
	^current = aString or: 
			[(Keyboard layoutName: aString) and: 
					[savedLayout ifNil: [savedLayout := current].
					true]]!

tearDown
	savedLayout ifNotNil: [Keyboard layoutName: savedLayout]! !

!AbstractKeyboardTest categoriesForMethods!
setCurrentKeyboardLayout:!helpers!private! !
tearDown!private!Running! !
!

