﻿"Filed out from Dolphin Smalltalk"!

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

streamClass
	^ReadStream!

streamWith: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^(self streamOn: aString)
		setToEnd;
		yourself!

testPositionBoundsError
	| stream pos |
	pos := 5.
	stream := self streamOn: String new.
	self
		should: [stream position: pos]
		raise: BoundsError
		matching: [:e | e receiver == stream and: [e tag == 5]]! !

!Core.Tests.ReadStreamTest categoriesForMethods!
streamClass!helpers!private! !
streamWith:!helpers!private! !
testPositionBoundsError!public!unit tests! !
!

