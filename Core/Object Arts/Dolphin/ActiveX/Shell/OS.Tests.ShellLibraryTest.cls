"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.ShellLibraryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ShellConstants})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.ShellLibraryTest guid: (Core.GUID fromString: '{5f8b77c2-670d-4c13-830f-ed10f6dbdb3d}')!

OS.Tests.ShellLibraryTest comment: ''!

!OS.Tests.ShellLibraryTest methodsFor!

testGetKnownFolderLocation
	| expected actual |
	actual := Shell32 getKnownFolderLocation: FOLDERID_ProgramFilesX86.
	expected := SessionManager current getenv: 'ProgramFiles(x86)'.
	self assert: actual equals: expected.
	actual := Shell32 getKnownFolderLocation: FOLDERID_Windows.
	expected := SessionManager current getenv: 'SystemRoot'.
	actual := Shell32 getKnownFolderLocation: FOLDERID_LocalAppData.
	expected := SessionManager current getenv: 'LOCALAPPDATA'.
	self assert: actual equals: expected.
	self
		should: [Shell32 getKnownFolderLocation: GUID newUnique]
		raise: Win32Error
		matching: [:ex | ex statusCode = 2]! !

!OS.Tests.ShellLibraryTest categoriesForMethods!
testGetKnownFolderLocation!public! !
!

