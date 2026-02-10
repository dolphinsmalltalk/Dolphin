"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'External.Tests.UInt8ArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.UInt8ArrayTest guid: (Core.GUID fromString: '{a04998d8-28b3-46e0-b1bb-b173b8af04a0}')!

External.Tests.UInt8ArrayTest comment: ''!

!External.Tests.UInt8ArrayTest methodsFor!

testSelfEvaluating
	| subject stream |
	subject := self newTestSubjectOfSize: 6.
	self assert: subject isSelfEvaluating.
	stream := SmalltalkLocale.Hex writeStream.
	stream nextPutAll: '(UInt8Array withAll: #['.
	subject value do: [:each | stream print: each] separatedBy: [stream space].
	stream nextPutAll: '])'.
	self assert: subject printString equals: stream contents! !

!External.Tests.UInt8ArrayTest categoriesForMethods!
testSelfEvaluating!public!unit tests! !
!

!External.Tests.UInt8ArrayTest class methodsFor!

arrayClass
	^UInt8Array!

elementFromIndex: anInteger
	^##({ 0. Int8.MaxValue. Int8.MaxValue + 1. UInt8.MaxValue. 1. UInt8.MaxValue - 1 }) at: anInteger! !

!External.Tests.UInt8ArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

