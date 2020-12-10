"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #SignalTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SignalTest guid: (GUID fromString: '{d8a6340d-1716-4ae1-883b-2e16c7812667}')!
SignalTest comment: ''!
!SignalTest categoriesForClass!Unclassified! !
!SignalTest methodsFor!

testMessageText
	| signal text |
	signal := Signal description: 'Wibble'.
	text := [signal signal] on: signal do: [:ex | ex messageText].
	self assert: text equals: 'Wibble'.
	text := [signal signal: 'Wobble'] on: signal do: [:ex | ex messageText].
	self assert: text equals: 'Wobble'! !
!SignalTest categoriesFor: #testMessageText!public!unit tests! !

