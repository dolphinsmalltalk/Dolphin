"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.CRTErrorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.CRTErrorTest guid: (Core.GUID fromString: '{2a5b554b-8f25-4e71-9987-dee5407f6a88}')!

OS.Tests.CRTErrorTest comment: ''!

!OS.Tests.CRTErrorTest methodsFor!

testStrError
	| subject |
	subject := CRTError new
				tag: CRTError.EBADF;
				yourself.
	Ucrt setlocale: CRTLibrary.LC_ALL locale: 'en-US'.
	[self assert: subject strerror equals: 'Bad file descriptor'] ensure: [Ucrt synchronizeLocale]! !

!OS.Tests.CRTErrorTest categoriesForMethods!
testStrError!public!tests! !
!

