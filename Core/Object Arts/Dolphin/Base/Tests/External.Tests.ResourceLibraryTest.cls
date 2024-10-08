﻿"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'External.Tests.ResourceLibraryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.ResourceLibraryTest guid: (Core.GUID fromString: '{53144b4f-aa74-4ab2-a1c5-7b9c8f0fffec}')!

External.Tests.ResourceLibraryTest comment: ''!

!External.Tests.ResourceLibraryTest methodsFor!

testComparing
	| reslib1 reslib2 |
	reslib1 := ResourceLibrary open: 'regedt32.exe'.
	reslib2 := ResourceLibrary open: SessionManager current systemDirectory , '\regedt32.exe.'.
	"The exe will be opened twice as a resource only library - GetModuleFilename doesn't work for resource only libs, so we don't know that the two paths map to the same library."
	self deny: reslib1 identicalTo: reslib2.
	self deny: reslib1 equals: reslib2.
	self deny: reslib1 hash equals: reslib2 hash.
	self deny: reslib1 equals: SessionManager.Current defaultResourceLibrary.
	self assert: reslib1 identicalTo: (ResourceLibrary open: 'Regedt32.exe')!

testComparingImage
	| reslib1 reslib2 |
	reslib1 := ResourceLibrary open: 'user32'.
	reslib2 := ResourceLibrary open: SessionManager current systemDirectory, '\User32.dll'.
	"Because User32 is already open as a full image, it will be possible to query the full module file name, and the Libraries register will have that full name added when reslib1 is opened. Therefore when reslib2 is opened, the existing instance will be found and answered."
	self assert: reslib1 identicalTo: reslib2.
	self assert: reslib1 equals: reslib2.
	self assert: reslib1 hash equals: reslib2 hash.
	self deny: reslib1 equals: (SessionManager.Current defaultResourceLibrary).
	
	!

testLibrariesRegister
	self deny: ResourceLibrary.Libraries hasWeakKeys.
	self assert: ResourceLibrary.Libraries hasWeakValues.
	self assert: (ResourceLibrary open: 'user32') identicalTo: (ResourceLibrary open: 'User32.dll').
	self assert: (ResourceLibrary open: 'dolphindr7') identicalTo: (SessionManager.Current defaultResourceLibrary)!

testStbConvertFromVersion0
	| bytes subject |
	bytes := #[33 83 84 66 32 48 32 14 2 31 0 83 84 66 69 120 116 101 114 110 97 108 82 101 115 111 117 114 99 101 76 105 98 114 97 114 121 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 13 0 0 0 68 111 108 112 104 105 110 68 101 118 82 101 115 0 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: ResourceLibrary.
	self assert: subject equals: SessionManager current defaultResourceLibrary!

testStbConvertFromVersion1
	| bytes subject |
	bytes := #[33 83 84 66 32 52 32 14 2 31 0 83 84 66 69 120 116 101 114 110 97 108 82 101 115 111 117 114 99 101 76 105 98 114 97 114 121 80 114 111 120 121 82 0 0 0 14 0 0 0 100 111 108 112 104 105 110 100 114 55 46 100 108 108 0 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: ResourceLibrary.
	self assert: subject equals: SessionManager current defaultResourceLibrary! !

!External.Tests.ResourceLibraryTest categoriesForMethods!
testComparing!public!unit tests! !
testComparingImage!public!unit tests! !
testLibrariesRegister!public!unit tests! !
testStbConvertFromVersion0!public! !
testStbConvertFromVersion1!public! !
!

