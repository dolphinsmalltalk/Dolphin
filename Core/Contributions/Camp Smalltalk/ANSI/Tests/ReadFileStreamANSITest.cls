"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #ReadFileStreamANSITest
	instanceVariableNames: 'readFileStream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!ReadFileStreamANSITest categoriesFor: #canonicalObject!public! !
!ReadFileStreamANSITest categoriesFor: #protocol!public! !
!ReadFileStreamANSITest categoriesFor: #setUp!public! !
!ReadFileStreamANSITest categoriesFor: #tearDown!public! !
!ReadFileStreamANSITest categoriesFor: #testXatEnd!public! !
!ReadFileStreamANSITest categoriesFor: #testXclose!public! !
!ReadFileStreamANSITest categoriesFor: #testXcontents!public! !
!ReadFileStreamANSITest categoriesFor: #testXdoX!public! !
!ReadFileStreamANSITest categoriesFor: #testXexternalType!public! !
!ReadFileStreamANSITest categoriesFor: #testXisBinary!public! !
!ReadFileStreamANSITest categoriesFor: #testXisEmpty!public! !
!ReadFileStreamANSITest categoriesFor: #testXisText!public! !
!ReadFileStreamANSITest categoriesFor: #testXnext!public! !
!ReadFileStreamANSITest categoriesFor: #testXnextLine!public! !
!ReadFileStreamANSITest categoriesFor: #testXnextMatchForX!public! !
!ReadFileStreamANSITest categoriesFor: #testXnextX!public! !
!ReadFileStreamANSITest categoriesFor: #testXpeek!public! !
!ReadFileStreamANSITest categoriesFor: #testXpeekForX!public! !
!ReadFileStreamANSITest categoriesFor: #testXposition!public! !
!ReadFileStreamANSITest categoriesFor: #testXpositionX!public! !
!ReadFileStreamANSITest categoriesFor: #testXreset!public! !
!ReadFileStreamANSITest categoriesFor: #testXsetToEnd!public! !
!ReadFileStreamANSITest categoriesFor: #testXskipToX!public! !
!ReadFileStreamANSITest categoriesFor: #testXskipX!public! !
!ReadFileStreamANSITest categoriesFor: #testXupToX!public! !

