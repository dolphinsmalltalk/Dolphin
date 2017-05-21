"Filed out from Dolphin Smalltalk 7"!

PositionableStreamTest subclass: #ReadWriteStreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ReadWriteStreamTest guid: (GUID fromString: '{575c0e65-e28f-4acb-a9c8-8294fa8503a3}')!
ReadWriteStreamTest comment: ''!
!ReadWriteStreamTest categoriesForClass!Unclassified! !
!ReadWriteStreamTest methodsFor!

streamClass
	^ReadWriteStream!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^(self streamWith: aString)
		reset;
		yourself!

testIsEmpty
	| stream |
	stream := self streamWith: String new.
	self assert: stream isEmpty.
	"#183"
	stream nextPut: $a.
	self deny: stream isEmpty.
	"This test would fail on Squeak because it uses the position to implement #isEmpty (?)"
	stream reset.
	self deny: stream isEmpty.
	self closeTempStream: stream!

testResetAfterWrite
	| stream |
	stream := self streamWith: String new.
	stream nextPut: $a.
	stream reset.
	self assert: stream next = $a.
	self closeTempStream: stream! !
!ReadWriteStreamTest categoriesFor: #streamClass!helpers!private! !
!ReadWriteStreamTest categoriesFor: #streamOn:!helpers!private! !
!ReadWriteStreamTest categoriesFor: #testIsEmpty!public!unit tests! !
!ReadWriteStreamTest categoriesFor: #testResetAfterWrite!public!unit tests! !

