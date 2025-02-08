"Filed out from Dolphin Smalltalk"!

Core.Tests.PositionableStreamTest
	subclass: #'Core.Tests.ReadStreamTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.ReadStreamTest guid: (Core.GUID fromString: '{29dd0ab5-9ebf-496f-aef0-ffc5ba1c2017}')!

Core.Tests.ReadStreamTest comment: ''!

!Core.Tests.ReadStreamTest methodsFor!

expectedAnsiProtocolNames
	^#(#collectionStream #gettableStream #Object #ReadStream #sequencedStream)!

streamWith: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^(self streamOn: aString)
		setToEnd;
		yourself!

testPeekForOverArray
	"Test AbstractReadStream>>peekFor: over an Array, which can contain nils"
	<mustConform: #gettableStream>
	<mustConform: #collectionStream>

	| stream |
	"Empty stream (initlially at end)"
	stream := self streamOn: #().
	self deny: (stream peekFor: $a).
	self assert: stream atEnd.
	"Non-empty stream"
	stream := self streamOn: #(1 nil 2).
	"Not at end but mismatch"
	self deny: (stream peekFor: 2).
	self deny: (stream peekFor: nil).
	self assert: stream position equals: 0.
	"Successful match of first element"
	self assert: (stream peekFor: 1).
	self assert: stream position equals: 1.
	"Mismatch - currently on nil"
	self deny: (stream peekFor: 2).
	self deny: (stream peekFor: 3).
	self assert: stream position equals: 1.
	"Successful match of nil"
	self deny: stream atEnd.
	self assert: (stream peekFor: nil).
	self deny: stream atEnd.
	self deny: (stream peekFor: 3).
	"Match last"
	self assert: (stream peekFor: 2).
	"Now at end"
	self deny: (stream peekFor: 1).
	self deny: (stream peekFor: nil).
	self assert: stream atEnd!

testPositionBoundsError
	| stream pos |
	pos := 5.
	stream := self streamOn: String new.
	self
		should: [stream position: pos]
		raise: BoundsError
		matching: [:e | e receiver == stream and: [e tag == 5]]! !

!Core.Tests.ReadStreamTest categoriesForMethods!
expectedAnsiProtocolNames!constants!private! !
streamWith:!helpers!private! !
testPeekForOverArray!public!unit tests! !
testPositionBoundsError!public!unit tests! !
!

!Core.Tests.ReadStreamTest class methodsFor!

streamClass
	^ReadStream! !

!Core.Tests.ReadStreamTest class categoriesForMethods!
streamClass!private! !
!

