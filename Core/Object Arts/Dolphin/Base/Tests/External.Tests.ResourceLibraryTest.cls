"Filed out from Dolphin Smalltalk"!

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
	self assert: (ResourceLibrary open: 'dolphindr7') identicalTo: (SessionManager.Current defaultResourceLibrary)! !
!External.Tests.ResourceLibraryTest categoriesForMethods!
testComparing!public!unit tests! !
testComparingImage!public!unit tests! !
testLibrariesRegister!public!unit tests! !
!

