"Filed out from Dolphin Smalltalk X6.1"!

TestCase subclass: #LineNumberStreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LineNumberStreamTest guid: (GUID fromString: '{6040A7F7-F940-40C9-8DD0-CFD25CEB670F}')!
LineNumberStreamTest comment: ''!
!LineNumberStreamTest categoriesForClass!SmaCC Runtime! !
!LineNumberStreamTest methodsFor!

addCRLFsTo: aString 
	^aString copyReplaceAll: '\'
		with: (String with: Character cr with: Character lf)!

addCRsTo: aString 
	^aString copyReplaceAll: '\' with: (String with: Character cr)!

addLFsTo: aString 
	^aString copyReplaceAll: '\' with: (String with: Character lf)!

testCRLFLines
	| stream |
	stream := SmaCCLineNumberStream 
				on: (ReadStream on: (self addCRLFsTo: '1234\1234\1234\1234')).
	1 to: 4
		do:
			[:each | 
			self assert: stream lineNumber = each.
			4 timesRepeat: [self assert: stream columnNumber = (stream next asInteger - $0 asInteger)].
			stream upTo: Character lf]!

testCRLines
	| stream |
	stream := SmaCCLineNumberStream 
				on: (ReadStream on: (self addCRsTo: '1234\1234\1234\1234')).
	1 to: 4
		do:
			[:each | 
			self assert: stream lineNumber = each.
			4 timesRepeat: [self assert: stream columnNumber = (stream next asInteger - $0 asInteger)].
			stream upTo: Character cr]!

testEmptyLines
	| stream |
	stream := SmaCCLineNumberStream 
				on: (ReadStream on: (self addCRsTo: '\\\')).
	1 to: 4
		do: 
			[:each | 
			self assert: stream lineNumber = each.
			stream upTo: Character cr]!

testForwardPositionCRLFLines
	| stream |
	stream := SmaCCLineNumberStream 
				on: (ReadStream on: (self addCRLFsTo: '1\2\3\4')).
	stream position: 3.
	self assert: stream lineNumber = 2.
	self assert: stream columnNumber = 1!

testLFLines
	| stream |
	stream := SmaCCLineNumberStream 
				on: (ReadStream on: (self addLFsTo: '1234\1234\1234\1234')).
	1 to: 4
		do: 
			[:each | 
			self assert: stream lineNumber = each.
			4 timesRepeat: [self assert: stream columnNumber = (stream next asInteger - $0 asInteger)].
			stream upTo: Character lf]!

testNoLines
	| stream index |
	stream := SmaCCLineNumberStream on: (ReadStream on: 'this is a test').
	self assert: stream lineNumber = 1.
	index := 1.
	stream do: 
			[:each | 
			self assert: stream lineNumber = 1.
			index := index + 1.
			self assert: stream columnNumber = index]!

testPositionCRLFLines
	| stream |
	stream := SmaCCLineNumberStream 
				on: (ReadStream on: (self addCRLFsTo: '1\2\3\4')).
	self assert: stream lineNumber = 1.
	stream upTo: $5.
	self assert: stream lineNumber = 4.
	stream position: 0.
	self assert: stream lineNumber = 1.
	self assert: stream columnNumber = 1.
	stream position: 3.
	self assert: stream lineNumber = 2.
	self assert: stream columnNumber = 1!

testPositionCRLines
	| stream |
	stream := SmaCCLineNumberStream 
				on: (ReadStream on: (self addCRsTo: '1\2\3\4')).
	self assert: stream lineNumber = 1.
	stream upTo: $5.
	self assert: stream lineNumber = 4.
	stream skip: -1.
	self assert: stream lineNumber = 4.
	self assert: stream columnNumber = 1.
	stream position: 0.
	self assert: stream lineNumber = 1.
	self assert: stream columnNumber = 1.
	stream position: 2.
	self assert: stream lineNumber = 2.
	self assert: stream columnNumber = 1! !
!LineNumberStreamTest categoriesFor: #addCRLFsTo:!private! !
!LineNumberStreamTest categoriesFor: #addCRsTo:!private! !
!LineNumberStreamTest categoriesFor: #addLFsTo:!private! !
!LineNumberStreamTest categoriesFor: #testCRLFLines!public!tests! !
!LineNumberStreamTest categoriesFor: #testCRLines!public!tests! !
!LineNumberStreamTest categoriesFor: #testEmptyLines!public!tests! !
!LineNumberStreamTest categoriesFor: #testForwardPositionCRLFLines!public!tests! !
!LineNumberStreamTest categoriesFor: #testLFLines!public!tests! !
!LineNumberStreamTest categoriesFor: #testNoLines!public!tests! !
!LineNumberStreamTest categoriesFor: #testPositionCRLFLines!public!tests! !
!LineNumberStreamTest categoriesFor: #testPositionCRLines!public!tests! !

