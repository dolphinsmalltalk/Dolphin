"Filed out from Dolphin Smalltalk"!

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

testNextColon
	super testNextColon.
	self writeableCollections do: 
			[:pair |
			| each subject elems actual expected |
			each := pair first.
			subject := self streamWith: each.
			elems := pair last.
			elems do: [:e | subject nextPut: e].
			subject reset.
			actual := subject next: elems size * 2.
			self assert: subject atEnd.
			self closeTempStream: subject.
			expected := each , each.
			self assert: actual equals: expected]!

testResetAfterWrite
	| stream |
	stream := self streamWith: String new.
	stream nextPut: $a.
	stream reset.
	self assert: stream next equals: $a.
	self closeTempStream: stream! !
!ReadWriteStreamTest categoriesForMethods!
streamClass!helpers!private! !
streamOn:!helpers!private! !
testIsEmpty!public!unit tests! !
testNextColon!public!unit tests! !
testResetAfterWrite!public!unit tests! !
!

