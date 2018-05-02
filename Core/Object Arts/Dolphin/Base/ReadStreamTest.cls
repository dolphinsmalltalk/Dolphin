"Filed out from Dolphin Smalltalk 7"!

PositionableStreamTest subclass: #ReadStreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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

testInterval
	| subject |
	subject := (1 to: 6) readStream.
	1 to: 6 do: [:i | self assert: subject next equals: i].
	self should: [subject next] raise: Stream endOfStreamSignal.
	subject reset.
	self assert: (subject next: 5) equals: (1 to: 5) asArray.
	self assert: subject next equals: 6.
	subject reset.
	self assert: (subject upTo: 1) equals: #().
	self assert: (subject upTo: 3) equals: #(2).
	self assert: subject upToEnd equals: #(4 5 6).
	subject reset.
	self assert: (subject nextAvailable: 1) equals: #(1).
	self assert: (subject nextAvailable: 2) equals: #(1 2).
	self assert: (subject nextAvailable: 5) equals: #(3 4 5 6)!

testNextAvailableColon
	self strings do: 
			[:pair |
			| each subject elems actual expected |
			each := pair first.
			subject := self streamOn: each.
			elems := each asArray.
			0 to: elems size
				do: 
					[:i |
					subject reset.
					actual := subject nextAvailable: i.
					expected := elems copyFrom: 1 to: i.
					self assert: actual asArray equals: expected].
			self assert: subject atEnd.
			subject reset.
			self assert: (subject nextAvailable: elems size + 1) equals: each.
			self closeTempStream: subject]!

testNextColon
	self strings do: 
			[:pair |
			| each subject elems actual expected |
			each := pair first.
			subject := self streamOn: each.
			elems := each asArray.
			0 to: elems size
				do: 
					[:i |
					subject reset.
					actual := subject next: i.
					expected := elems copyFrom: 1 to: i.
					self assert: actual asArray equals: expected].
			self assert: subject atEnd.
			self closeTempStream: subject]!

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
!ReadStreamTest categoriesFor: #testInterval!public!unit tests! !
!ReadStreamTest categoriesFor: #testNextAvailableColon!public!unit tests! !
!ReadStreamTest categoriesFor: #testNextColon!public!unit tests! !
!ReadStreamTest categoriesFor: #testPositionBoundsError!public!unit tests! !

