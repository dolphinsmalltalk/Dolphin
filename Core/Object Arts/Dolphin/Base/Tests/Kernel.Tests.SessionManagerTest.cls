"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.SessionManagerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.SessionManagerTest guid: (Core.GUID fromString: '{06f1fe94-5aa1-43f9-9d5c-1d4de4f5b519}')!
Kernel.Tests.SessionManagerTest comment: ''!
!Kernel.Tests.SessionManagerTest methodsFor!

testComputerName
	"Assumes that getenv: is working"

	| actual |
	actual := SessionManager current getenv: 'COMPUTERNAME'.
	self assert: (actual sameAs: SessionManager current computerName)!

testDocumentsDirectory
	self assert: (File isDirectory: SessionManager current documentsDirectory)!

testGetEnv
	| actual |
	actual := SessionManager current getenv: 'SystemRoot'.
	self assert: (File isDirectory: actual).
	self assert: (File exists: (File composePath: actual subPath: 'win.ini'))!

testUsername
	"Assumes that getenv: is working"

	| actual |
	actual := SessionManager current getenv: 'USERNAME'.
	self assert: (actual sameAs: SessionManager current userName)! !
!Kernel.Tests.SessionManagerTest categoriesForMethods!
testComputerName!public!unit tests! !
testDocumentsDirectory!public!unit tests! !
testGetEnv!public!unit tests! !
testUsername!public!unit tests! !
!

