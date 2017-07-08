"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #StreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StreamTest guid: (GUID fromString: '{f1611eb3-2c1c-491e-a814-c62dcdce0fff}')!
StreamTest comment: ''!
!StreamTest categoriesForClass!Unclassified! !
!StreamTest methodsFor!

closeTempStream: aStream
	"Private - Clean up the temporary stream argument."!

streamClass
	^self subclassResponsibility!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^self streamClass on: aString!

testUpTo
	| chars stream |
	chars := 'abcdefghij'.
	stream := self streamOn: chars.
	self assert: (stream upTo: $a) equals: ''.
	self assert: (stream upTo: $b) equals: ''.
	self assert: (stream upTo: $d) equals: 'c'.
	self assert: (stream upTo: $g) equals: 'ef'.
	self assert: (stream upTo: $z) equals: 'hij'.
	self assert: stream atEnd.
	self assert: (stream upTo: $z) equals: ''.
	stream reset.
	self assert: (stream upTo: $j) equals: 'abcdefghi'.
	self assert: stream atEnd.
	stream reset.
	self assert: (stream upTo: $z) equals: chars.
	self assert: stream atEnd.
	self closeTempStream: stream! !
!StreamTest categoriesFor: #closeTempStream:!helpers!private! !
!StreamTest categoriesFor: #streamClass!helpers!private! !
!StreamTest categoriesFor: #streamOn:!helpers!private! !
!StreamTest categoriesFor: #testUpTo!public! !

!StreamTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!StreamTest class categoriesFor: #isAbstract!public!Testing! !

