"Filed out from Dolphin Smalltalk"!

TestCase subclass: #STONCStyleCommentsSkipStreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STONCStyleCommentsSkipStreamTest guid: (GUID fromString: '{a5305b0e-412c-473c-8718-a2fe44c28b38}')!
STONCStyleCommentsSkipStreamTest comment: ''!
!STONCStyleCommentsSkipStreamTest categoriesForClass!STON-Tests-Reader! !
!STONCStyleCommentsSkipStreamTest methodsFor!

testBlockReading
	| input buffer |
	input := STONCStyleCommentsSkipStream on: 'abc/*comment*/def' readStream.
	buffer := String new: 6.
	self assert: (input readInto: buffer startingAt: 1 count: 4) equals: 4.
	self assert: (buffer copyFrom: 1 to: 4) equals: 'abcd'.
	self assert: (input readInto: buffer startingAt: 5 count: 4) equals: 2.
	self assert: buffer equals: 'abcdef'.
	input := STONCStyleCommentsSkipStream on: 'abc//comment\def' withCRs readStream.
	buffer := String new: 6.
	self assert: (input readInto: buffer startingAt: 1 count: 6) equals: 6.
	self assert: buffer equals: 'abcdef'.
	self assert: input atEnd!

testCommentInString
	self 
		assert: (STONCStyleCommentsSkipStream on: '''/*comment*/''' readStream) upToEnd 
		equals: '''/*comment*/'''.
	self 
		assert: (STONCStyleCommentsSkipStream on: '{''foo'':''/*comment*/bar''}' readStream) upToEnd 
		equals: '{''foo'':''/*comment*/bar''}'.
	self 
		assert: (STONCStyleCommentsSkipStream on: '{''foo'':''//comment\''bar''}' readStream) upToEnd 
		equals: '{''foo'':''//comment\''bar''}'.
	self 
		assert: (STONCStyleCommentsSkipStream on: '{"foo":"/*comment*/bar"}' readStream) upToEnd 
		equals: '{"foo":"/*comment*/bar"}'.
	self 
		assert: (STONCStyleCommentsSkipStream on: '{"foo":"//comment\"bar"}' readStream) upToEnd 
		equals: '{"foo":"//comment\"bar"}'!

testMultiLineComment
	self 
		assert: (STONCStyleCommentsSkipStream on: 'foo\//comment\bar' withCRs readStream) upToEnd 
		equals: 'foo\bar' withCRs.
	self 
		assert: (STONCStyleCommentsSkipStream on: 'foo\//comment\bar' withCRs readStream) nextLine
		equals: 'foo'.
	self 
		assert: ((STONCStyleCommentsSkipStream on: 'foo\//comment\bar' withCRs readStream) nextLine; nextLine) 
		equals: 'bar'.
	self assert: (STONCStyleCommentsSkipStream on: '//comment' readStream) atEnd.!

testNonComment
	self assert: (STONCStyleCommentsSkipStream on: 'foo' readStream) upToEnd equals: 'foo'.
	self assert: (STONCStyleCommentsSkipStream on: 'foo' readStream) nextLine equals: 'foo'.
	self deny: (STONCStyleCommentsSkipStream on: 'foo' readStream) atEnd.
	self assert: (STONCStyleCommentsSkipStream on: '' readStream) atEnd.!

testSingleLineComment
	self assert: (STONCStyleCommentsSkipStream on: 'foo/*comment*/bar' readStream) upToEnd equals: 'foobar'.
	self assert: (STONCStyleCommentsSkipStream on: 'foo/*comment*/bar' readStream) nextLine equals: 'foobar'.
	self deny: (STONCStyleCommentsSkipStream on: 'foo/*comment*/bar' readStream) atEnd.
	self assert: (STONCStyleCommentsSkipStream on: '/*comment*/' readStream) atEnd.!

testSTON
	"Comments are processed first and totally removed.
	They are not even whitespace (not that whitespace is relevant in STON)."
	
	self 
		assert: (STON fromStream: (STONCStyleCommentsSkipStream on: '123/*comment*/456' readStream)) 
		equals: 123456.
	self 
		assert: (STON fromStream: (STONCStyleCommentsSkipStream on: '/*comment*/''abcd''' readStream)) 
		equals: 'abcd'.
	self 
		assert: (STON fromStream: (STONCStyleCommentsSkipStream on: '123//456' readStream)) 
		equals: 123.
	self 
		should: [ STON fromStream: (STONCStyleCommentsSkipStream on: '//456' readStream) ] 
		raise: STONReaderError
! !
!STONCStyleCommentsSkipStreamTest categoriesForMethods!
testBlockReading!public!testing! !
testCommentInString!public!testing! !
testMultiLineComment!public!testing! !
testNonComment!public!testing! !
testSingleLineComment!public!testing! !
testSTON!public!testing! !
!

