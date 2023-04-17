"Filed out from Dolphin Smalltalk"!

TestCase subclass: #SelectorParserTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SelectorParserTest guid: (GUID fromString: '{fafb8169-77bc-4dba-bd7c-033cf0230468}')!
SelectorParserTest comment: ''!
!SelectorParserTest categoriesForClass!Unclassified! !
!SelectorParserTest methodsFor!

testBinarySelector
	| selector |
	(Scanner.ClassificationTable associations select: [:each | each value == #binary]) do: 
			[:each |
			| ch |
			ch := Character value: each key - 1.
			selector := ch asString.
			self assert: (SelectorParser parse: selector) equals: selector.
			self assert: (SelectorParser parse: ' ' , selector) equals: selector.
			self assert: (SelectorParser parse: '"foo bar"' , selector) equals: selector.
			self assert: (SelectorParser parse: selector , selector) equals: selector , selector.
			self assert: (SelectorParser parse: selector , ' ') equals: selector.
			self assert: (SelectorParser parse: selector , 'a') equals: selector.
			self assert: (SelectorParser parse: selector , selector , 'a') equals: selector , selector.
			self assert: (SelectorParser parse: selector , '!!' , 'a') equals: selector , '!!'.
			self assert: (SelectorParser parse: selector , '^a') equals: selector.
			self assert: (SelectorParser parse: selector , selector , '^a') equals: selector , selector]!

testEmpty
	self assert: (SelectorParser parse: '') equals: ''.
	self assert: (SelectorParser parse: ' ') equals: ''.
	self assert: (SelectorParser parse: ' "foo""bar" "foob"') equals: ''.
	self assert: (SelectorParser parse: '.') equals: ''!

testExhaustive
	Object
		allMethodsDo: [:each | self assert: (SelectorParser parse: each getSource) equals: each selector]!

testUnarySelector
	#('a' 'a ' 'a"foo"' 'a b' 'a^b' ' "foo bar"a')
		do: [:each | self assert: (SelectorParser parse: each) equals: 'a'].
	#('aBC' 'aBC ' 'aBC"foo"' 'aBC^b' '"foo" "bar"  aBC"foo"')
		do: [:each | self assert: (SelectorParser parse: each) equals: 'aBC']! !
!SelectorParserTest categoriesForMethods!
testBinarySelector!public! !
testEmpty!public! !
testExhaustive!public! !
testUnarySelector!public! !
!

