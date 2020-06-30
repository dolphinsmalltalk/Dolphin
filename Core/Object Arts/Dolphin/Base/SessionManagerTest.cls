"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #SessionManagerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SessionManagerTest guid: (GUID fromString: '{06f1fe94-5aa1-43f9-9d5c-1d4de4f5b519}')!
SessionManagerTest comment: ''!
!SessionManagerTest categoriesForClass!Unclassified! !
!SessionManagerTest methodsFor!

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
!SessionManagerTest categoriesFor: #testComputerName!public!unit tests! !
!SessionManagerTest categoriesFor: #testDocumentsDirectory!public!unit tests! !
!SessionManagerTest categoriesFor: #testGetEnv!public!unit tests! !
!SessionManagerTest categoriesFor: #testSystemDirectory!public!unit tests! !
!SessionManagerTest categoriesFor: #testUsername!public!unit tests! !
!SessionManagerTest categoriesFor: #testWindowsDirectory!public!unit tests! !

