"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #WriteFileStreamANSITest
	instanceVariableNames: 'writeFileStream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WriteFileStreamANSITest guid: (GUID fromString: '{75562e52-c345-46dd-a2e1-734f105077f4}')!
WriteFileStreamANSITest comment: ''!
!WriteFileStreamANSITest categoriesForClass!Unclassified! !
!WriteFileStreamANSITest methodsFor!

canonicalObject
	^writeFileStream!

protocol
	^#'writeFileStream'!

setUp
	super setUp.
	" This method will create a file named 'ansiTestFile.junk' in the current directory
	if it does not already exist. "

	"writeFileStream := FileStream write: 'ansiTestFile.junk'"!

tearDown
	"writeFileStream close"!

testXclose
	" <sequencedStream>#close "
	#'File Stream'.!

testXcontents
	" <FileStream>#contents "
	#'File Stream'.!

testXcr
	" <puttableStream>#cr "
	#'File Stream'.!

testXexternalType
	" <FileStream>#externalType "
	#'File Stream'.!

testXflush
	" <puttableStream>#flush "
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

testXnextPutAllX
	" <puttableStream>#nextPutAll: "
	#'File Stream'.!

testXnextPutX
	" <puttableStream>#nextPut: "
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

testXspace
	" <puttableStream>#space "
	#'File Stream'.!

testXtab
	" <puttableStream>#tab "
	#'File Stream'.! !
!WriteFileStreamANSITest categoriesFor: #canonicalObject!public! !
!WriteFileStreamANSITest categoriesFor: #protocol!public! !
!WriteFileStreamANSITest categoriesFor: #setUp!public! !
!WriteFileStreamANSITest categoriesFor: #tearDown!public! !
!WriteFileStreamANSITest categoriesFor: #testXclose!public! !
!WriteFileStreamANSITest categoriesFor: #testXcontents!public! !
!WriteFileStreamANSITest categoriesFor: #testXcr!public! !
!WriteFileStreamANSITest categoriesFor: #testXexternalType!public! !
!WriteFileStreamANSITest categoriesFor: #testXflush!public! !
!WriteFileStreamANSITest categoriesFor: #testXisBinary!public! !
!WriteFileStreamANSITest categoriesFor: #testXisEmpty!public! !
!WriteFileStreamANSITest categoriesFor: #testXisText!public! !
!WriteFileStreamANSITest categoriesFor: #testXnextPutAllX!public! !
!WriteFileStreamANSITest categoriesFor: #testXnextPutX!public! !
!WriteFileStreamANSITest categoriesFor: #testXposition!public! !
!WriteFileStreamANSITest categoriesFor: #testXpositionX!public! !
!WriteFileStreamANSITest categoriesFor: #testXreset!public! !
!WriteFileStreamANSITest categoriesFor: #testXsetToEnd!public! !
!WriteFileStreamANSITest categoriesFor: #testXspace!public! !
!WriteFileStreamANSITest categoriesFor: #testXtab!public! !

