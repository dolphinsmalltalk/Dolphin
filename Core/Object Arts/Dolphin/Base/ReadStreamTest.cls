"Filed out from Dolphin Smalltalk 7"!

PositionableStreamTest subclass: #ReadStreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ReadStreamTest guid: (GUID fromString: '{29dd0ab5-9ebf-496f-aef0-ffc5ba1c2017}')!
ReadStreamTest comment: ''!
!ReadStreamTest categoriesForClass!Unclassified! !
!ReadStreamTest methodsFor!

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
!ReadStreamTest categoriesFor: #streamClass!helpers!private! !
!ReadStreamTest categoriesFor: #streamWith:!helpers!private! !
!ReadStreamTest categoriesFor: #testPositionBoundsError!public!unit tests! !

