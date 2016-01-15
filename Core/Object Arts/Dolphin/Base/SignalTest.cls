"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #SignalTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SignalTest guid: (GUID fromString: '{D8A6340D-1716-4AE1-883B-2E16C7812667}')!
SignalTest comment: ''!
!SignalTest categoriesForClass!Unclassified! !
!SignalTest methodsFor!

testMessageText
	| signal text |
	signal := Signal description: 'Wibble'.
	text := [signal signal] on: signal do: [:ex | ex messageText].
	self assert: text = 'Wibble'.
	text := [signal signal: 'Wobble'] on: signal do: [:ex | ex messageText].
	self assert: text = 'Wobble'! !
!SignalTest categoriesFor: #testMessageText!public!unit tests! !

