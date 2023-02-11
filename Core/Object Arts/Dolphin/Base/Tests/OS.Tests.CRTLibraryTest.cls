"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'OS.Tests.CRTLibraryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.CRTLibraryTest guid: (Core.GUID fromString: '{46ac94c8-b775-44c8-9cc9-bf70297081ff}')!
OS.Tests.CRTLibraryTest comment: ''!
!OS.Tests.CRTLibraryTest methodsFor!

testSplitPathInvalidCall
	| buf |
	buf := String new: 1.
	self
		should: 
			[Ucrt
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

testStrCatInvalidCall
	| buf |
	buf := String new: 1.
	self
		should: 
			[Ucrt
				strcat_s: buf
				bufferSize: 1
				strSource: 'abc']
		raise: CRTError
		matching: [:ex | ex errno = CRTConstants.ERANGE]!

testStrCpyInvalidArg
	| buf |
	buf := String new: 1.
	self
		should: 
			[OS.Ucrt
				wcsncpy_s: buf
				bufferSize: 0
				strSource: 'abc'
				count: OS.CRTConstants._TRUNCATE]
		raise: CRTError
		matching: [:ex | ex errno = CRTConstants.EINVAL]!

testStrCpyTruncation
	| buf |
	buf := String new: 1.
	self assert: (OS.Ucrt
				wcsncpy_s: buf
				bufferSize: 1
				strSource: 'abc'
				count: OS.CRTConstants._TRUNCATE)
		equals: OS.CRTConstants.STRUNCATE! !
!OS.Tests.CRTLibraryTest categoriesForMethods!
testSplitPathInvalidCall!public! !
testStrCatInvalidCall!public! !
testStrCpyInvalidArg!public! !
testStrCpyTruncation!public! !
!

