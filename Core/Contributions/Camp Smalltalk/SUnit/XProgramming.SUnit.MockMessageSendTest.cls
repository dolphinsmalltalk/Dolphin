"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase
	subclass: #'XProgramming.SUnit.MockMessageSendTest'
	instanceVariableNames: 'mockMessage testStream'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

XProgramming.SUnit.MockMessageSendTest guid: (Core.GUID fromString: '{f2572ab0-5290-4e8b-b560-acb0de24437f}')!

XProgramming.SUnit.MockMessageSendTest comment: 'A XProgramming.SUnit.MockMessageSendTest is a test class for testing the behavior of MockMessageSend'!

!XProgramming.SUnit.MockMessageSendTest methodsFor!

setUp

	super setUp.
	testStream := WriteStream on: String new
	!

testBinaryMessagePrintOn
	mockMessage := MockMessageSend on: #binaryMsg: with: #(true) do: [ ].
	
	mockMessage printOn: testStream.
	
	self assert: (testStream contents includesSubstring: 'binaryMsg: true')!

testKeywordMessageArrayPrintOn
	mockMessage := MockMessageSend on: #keyWord:msg: with: #('hello' #(1 2 3)) do: [ ].
	
	mockMessage printOn: testStream.
	
	self assert: (testStream contents includesSubstring: 'keyWord:msg: ( ''hello'', #(1 2 3) )')!

testKeywordMessagePrintOn
	mockMessage := MockMessageSend on: #keyWord:msg: with: #('hello' 'world') do: [ ].
	
	mockMessage printOn: testStream.
	
	self assert: (testStream contents includesSubstring: 'keyWord:msg: ( ''hello'', ''world'' )')!

testUnaryMessagePrintOn
	mockMessage := MockMessageSend on: #unaryMsg with: #() do: [ ].
	
	mockMessage printOn: testStream.
	
	self assert: (testStream contents includesSubstring: 'unaryMsg')! !

!XProgramming.SUnit.MockMessageSendTest categoriesForMethods!
setUp!public!running! !
testBinaryMessagePrintOn!public!running! !
testKeywordMessageArrayPrintOn!public!running! !
testKeywordMessagePrintOn!public!running! !
testUnaryMessagePrintOn!public!running! !
!

