"Filed out from Dolphin Smalltalk 7"!

Core.Tests.PositionableStreamTest subclass: #'Core.Tests.ReadWriteStreamTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.ReadWriteStreamTest guid: (Core.GUID fromString: '{575c0e65-e28f-4acb-a9c8-8294fa8503a3}')!
Core.Tests.ReadWriteStreamTest comment: ''!
!Core.Tests.ReadWriteStreamTest categoriesForClass!Unclassified! !
!Core.Tests.ReadWriteStreamTest methodsFor!

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
!Core.Tests.ReadWriteStreamTest categoriesFor: #streamClass!helpers!private! !
!Core.Tests.ReadWriteStreamTest categoriesFor: #streamOn:!helpers!private! !
!Core.Tests.ReadWriteStreamTest categoriesFor: #testIsEmpty!public!unit tests! !
!Core.Tests.ReadWriteStreamTest categoriesFor: #testNextColon!public!unit tests! !
!Core.Tests.ReadWriteStreamTest categoriesFor: #testResetAfterWrite!public!unit tests! !

