"Filed out from Dolphin Smalltalk 7"!

XProgramming.SUnit.TestCase subclass: #'STON.Tests.CStyleCommentsSkipStreamTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.CStyleCommentsSkipStreamTest guid: (Core.GUID fromString: '{a5305b0e-412c-473c-8718-a2fe44c28b38}')!
STON.Tests.CStyleCommentsSkipStreamTest comment: ''!
!STON.Tests.CStyleCommentsSkipStreamTest categoriesForClass!STON-Tests-Reader! !
!STON.Tests.CStyleCommentsSkipStreamTest methodsFor!

testBlockReading
	| input buffer |
	input := CStyleCommentsSkipStream on: 'abc/*comment*/def' readStream.
	buffer := String new: 6.
	self assert: (input
				readInto: buffer
				startingAt: 1
				count: 4)
		equals: 4.
	self assert: (buffer copyFrom: 1 to: 4) equals: 'abcd'.
	self assert: (input
				readInto: buffer
				startingAt: 5
				count: 4)
		equals: 2.
	self assert: buffer equals: 'abcdef'.
	input := CStyleCommentsSkipStream on: 'abc//comment\def' withCRs readStream.
	buffer := String new: 6.
	self assert: (input
				readInto: buffer
				startingAt: 1
				count: 6)
		equals: 6.
	self assert: buffer equals: 'abcdef'.
	self assert: input atEnd!

testCommentInString
	self assert: (CStyleCommentsSkipStream on: '''/*comment*/''' readStream) upToEnd
		equals: '''/*comment*/'''.
	self assert: (CStyleCommentsSkipStream on: '{''foo'':''/*comment*/bar''}' readStream) upToEnd
		equals: '{''foo'':''/*comment*/bar''}'.
	self assert: (CStyleCommentsSkipStream on: '{''foo'':''//comment\''bar''}' readStream) upToEnd
		equals: '{''foo'':''//comment\''bar''}'.
	self assert: (CStyleCommentsSkipStream on: '{"foo":"/*comment*/bar"}' readStream) upToEnd
		equals: '{"foo":"/*comment*/bar"}'.
	self assert: (CStyleCommentsSkipStream on: '{"foo":"//comment\"bar"}' readStream) upToEnd
		equals: '{"foo":"//comment\"bar"}'!

testMultiLineComment
	self assert: (CStyleCommentsSkipStream on: 'foo\//comment\bar' withCRs readStream) upToEnd
		equals: 'foo\bar' withCRs.
	self assert: (CStyleCommentsSkipStream on: 'foo\//comment\bar' withCRs readStream) nextLine
		equals: 'foo'.
	self assert: ((CStyleCommentsSkipStream on: 'foo\//comment\bar' withCRs readStream)
				nextLine;
				nextLine)
		equals: 'bar'.
	self assert: (CStyleCommentsSkipStream on: '//comment' readStream) atEnd!

testNonComment
	self assert: (CStyleCommentsSkipStream on: 'foo' readStream) upToEnd equals: 'foo'.
	self assert: (CStyleCommentsSkipStream on: 'foo' readStream) nextLine equals: 'foo'.
	self deny: (CStyleCommentsSkipStream on: 'foo' readStream) atEnd.
	self assert: (CStyleCommentsSkipStream on: '' readStream) atEnd!

testSingleLineComment
	self assert: (CStyleCommentsSkipStream on: 'foo/*comment*/bar' readStream) upToEnd equals: 'foobar'.
	self assert: (CStyleCommentsSkipStream on: 'foo/*comment*/bar' readStream) nextLine equals: 'foobar'.
	self deny: (CStyleCommentsSkipStream on: 'foo/*comment*/bar' readStream) atEnd.
	self assert: (CStyleCommentsSkipStream on: '/*comment*/' readStream) atEnd!

testSTON
	"Comments are processed first and totally removed.
	They are not even whitespace (not that whitespace is relevant in STON)."

	self assert: (STON fromStream: (CStyleCommentsSkipStream on: '123/*comment*/456' readStream))
		equals: 123456.
	self assert: (STON fromStream: (CStyleCommentsSkipStream on: '/*comment*/''abcd''' readStream))
		equals: 'abcd'.
	self assert: (STON fromStream: (CStyleCommentsSkipStream on: '123//456' readStream)) equals: 123.
	self should: [STON fromStream: (CStyleCommentsSkipStream on: '//456' readStream)] raise: ReaderError! !
!STON.Tests.CStyleCommentsSkipStreamTest categoriesFor: #testBlockReading!public!testing! !
!STON.Tests.CStyleCommentsSkipStreamTest categoriesFor: #testCommentInString!public!testing! !
!STON.Tests.CStyleCommentsSkipStreamTest categoriesFor: #testMultiLineComment!public!testing! !
!STON.Tests.CStyleCommentsSkipStreamTest categoriesFor: #testNonComment!public!testing! !
!STON.Tests.CStyleCommentsSkipStreamTest categoriesFor: #testSingleLineComment!public!testing! !
!STON.Tests.CStyleCommentsSkipStreamTest categoriesFor: #testSTON!public!testing! !

