"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #ReadFileStreamANSITest
	instanceVariableNames: 'readFileStream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ReadFileStreamANSITest guid: (GUID fromString: '{42d9164f-3512-423f-b6e3-23395a4db77e}')!
ReadFileStreamANSITest comment: ''!
!ReadFileStreamANSITest categoriesForClass!Unclassified! !
!ReadFileStreamANSITest methodsFor!

canonicalObject
	^readFileStream!

protocol
	^#'readFileStream'!

setUp
	super setUp.
	" Requires that a file named 'ansiTestFile.junk' exists in the current directory. "

"	| aPossiblyNewFile |
	aPossiblyNewFile := FileStream write: 'ansiTestFile.junk'.
	aPossiblyNewFile close.
"
"	readFileStream := FileStream read: 'ansiTestFile.junk' "!

tearDown
	"readFileStream close."!

testXatEnd
	" <gettableStream>#atEnd "
	#'File Stream'.!

testXclose
	" <sequencedStream>#close "
	#'File Stream'.!

testXcontents
	" <FileStream>#contents "
	#'File Stream'.!

testXdoX
	" <gettableStream>#do: "
	#'File Stream'.!

testXexternalType
	" <FileStream>#externalType "
	#'File Stream'.!

testXisBinary
	" <FileStream>#isBinary "
	#'File Stream'.!

testXisEmpty
	" <sequencedStream>#isEmpty "
	#'File Stream'.!

testXisText
	" <FileStream>#isText "
	#'File Stream'.!

testXnext
	" <gettableStream>#next "
	#'File Stream'.!

testXnextLine
	" <gettableStream>#nextLine "
	#'File Stream'.!

testXnextMatchForX
	" <gettableStream>#nextMatchFor: "
	#'File Stream'.!

testXnextX
	" <readFileStream>#next: "
	#'File Stream'.!

testXpeek
	" <gettableStream>#peek "
	#'File Stream'.!

testXpeekForX
	" <gettableStream>#peekFor: "
	#'File Stream'.!

testXposition
	" <sequencedStream>#position "
	#'File Stream'.!

testXpositionX
	" <sequencedStream>#position: "
	#'File Stream'.!

testXreset
	" <sequencedStream>#reset "
	#'File Stream'.!

testXsetToEnd
	" <sequencedStream>#setToEnd "
	#'File Stream'.!

testXskipToX
	" <gettableStream>#skipTo: "
	#'File Stream'.!

testXskipX
	" <gettableStream>#skip: "
	#'File Stream'.!

testXupToX
	" <readFileStream>#upTo: "
	#'File Stream'.! !
!ReadFileStreamANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
setUp!public! !
tearDown!public! !
testXatEnd!public! !
testXclose!public! !
testXcontents!public! !
testXdoX!public! !
testXexternalType!public! !
testXisBinary!public! !
testXisEmpty!public! !
testXisText!public! !
testXnext!public! !
testXnextLine!public! !
testXnextMatchForX!public! !
testXnextX!public! !
testXpeek!public! !
testXpeekForX!public! !
testXposition!public! !
testXpositionX!public! !
testXreset!public! !
testXsetToEnd!public! !
testXskipToX!public! !
testXskipX!public! !
testXupToX!public! !
!

