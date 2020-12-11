"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.SessionManagerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.SessionManagerTest guid: (Core.GUID fromString: '{06f1fe94-5aa1-43f9-9d5c-1d4de4f5b519}')!
Kernel.Tests.SessionManagerTest comment: ''!
!Kernel.Tests.SessionManagerTest categoriesForClass!Unclassified! !
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

testSystemDirectory
	| actual |
	actual := SessionManager current systemDirectory.
	self assert: (File isDirectory: actual).
	self assert: (KernelLibrary default fileName asUppercase beginsWith: actual asUppercase)!

testUsername
	"Assumes that getenv: is working"

	| actual |
	actual := SessionManager current getenv: 'USERNAME'.
	self assert: (actual sameAs: SessionManager current userName)!

testWindowsDirectory
	| windows actual |
	windows := 'C:\WINDOWS'.
	actual := SessionManager current windowsDirectory.
	self assert: (File isDirectory: actual).
	self assert: (actual sameAs: windows)! !
!Kernel.Tests.SessionManagerTest categoriesFor: #testComputerName!public!unit tests! !
!Kernel.Tests.SessionManagerTest categoriesFor: #testDocumentsDirectory!public!unit tests! !
!Kernel.Tests.SessionManagerTest categoriesFor: #testGetEnv!public!unit tests! !
!Kernel.Tests.SessionManagerTest categoriesFor: #testSystemDirectory!public!unit tests! !
!Kernel.Tests.SessionManagerTest categoriesFor: #testUsername!public!unit tests! !
!Kernel.Tests.SessionManagerTest categoriesFor: #testWindowsDirectory!public!unit tests! !

