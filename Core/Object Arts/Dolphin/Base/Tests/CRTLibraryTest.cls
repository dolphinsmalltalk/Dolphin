"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #CRTLibraryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CRTLibraryTest guid: (GUID fromString: '{23931544-d076-4947-b4ab-cf67a5a9ac5a}')!

CRTLibraryTest comment: ''!

!CRTLibraryTest categoriesForClass!Unclassified! !

!CRTLibraryTest methodsFor!

testSplitPathInvalidCall
	| buf |
	buf := String new: 1.
	self
		should: 
			[CRTLibrary default
				_splitpath_s: 'c:\blah'
				drive: nil
				driveLen: 0
				dir: buf
				dirLen: 1
				fname: nil
				fnameLen: 0
				ext: nil
				extLen: 0]
		raise: CRTError
		matching: [:ex | ex errno = CRTConstants.ERANGE]!

testStrCpyInvalidArg
	| buf |
	buf := String new: 1.
	self
		should: 
			[CRTLibrary default
				wcsncpy_s: buf
				bufferSize: 0
				strSource: 'abc'
				count: CRTConstants._TRUNCATE]
		raise: CRTError
		matching: [:ex | ex errno = CRTConstants.EINVAL]!

testStrCpyTruncation
	| buf |
	buf := String new: 1.
	self assert: (CRTLibrary default
				wcsncpy_s: buf
				bufferSize: 1
				strSource: 'abc'
				count: CRTConstants._TRUNCATE)
		equals: CRTConstants.STRUNCATE! !

!CRTLibraryTest categoriesForMethods!
testSplitPathInvalidCall!public! !
testStrCpyInvalidArg!public! !
testStrCpyTruncation!public! !
!

