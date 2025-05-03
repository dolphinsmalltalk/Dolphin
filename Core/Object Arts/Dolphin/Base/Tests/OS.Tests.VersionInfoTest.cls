"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.VersionInfoTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.VersionInfoTest guid: (Core.GUID fromString: '{8cf9ebae-8007-4170-a1fc-2cdd4b87b0e8}')!

OS.Tests.VersionInfoTest comment: ''!

!OS.Tests.VersionInfoTest methodsFor!

testProductName
	self assert: (VersionInfo forPath: VM fileName) productName equals: 'Dolphin Smalltalk'! !

!OS.Tests.VersionInfoTest categoriesForMethods!
testProductName!public!tests! !
!

