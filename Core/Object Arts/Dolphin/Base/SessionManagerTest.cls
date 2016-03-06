"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #SessionManagerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SessionManagerTest guid: (GUID fromString: '{06F1FE94-5AA1-43F9-9D5C-1D4DE4F5B519}')!
SessionManagerTest comment: ''!
!SessionManagerTest categoriesForClass!Unclassified! !
!SessionManagerTest methodsFor!

testSystemDirectory
	"#1422"

	| sys32 |
	sys32 := 'C:\WINDOWS\System32'.
	self assert: (SessionManager current systemDirectory sameAs: sys32)!

testWindowsDirectory
	| windows |
	windows := 'C:\WINDOWS'.
	self assert: (SessionManager current windowsDirectory sameAs: windows)! !
!SessionManagerTest categoriesFor: #testSystemDirectory!public!unit tests! !
!SessionManagerTest categoriesFor: #testWindowsDirectory!public!unit tests! !

