"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.SignalTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.SignalTest guid: (Core.GUID fromString: '{d8a6340d-1716-4ae1-883b-2e16c7812667}')!
Core.Tests.SignalTest comment: ''!
!Core.Tests.SignalTest categoriesForClass!Unclassified! !
!Core.Tests.SignalTest methodsFor!

testMessageText
	| signal text |
	signal := Signal description: 'Wibble'.
	text := [signal signal] on: signal do: [:ex | ex messageText].
	self assert: text equals: 'Wibble'.
	text := [signal signal: 'Wobble'] on: signal do: [:ex | ex messageText].
	self assert: text equals: 'Wobble'! !
!Core.Tests.SignalTest categoriesFor: #testMessageText!public!unit tests! !

