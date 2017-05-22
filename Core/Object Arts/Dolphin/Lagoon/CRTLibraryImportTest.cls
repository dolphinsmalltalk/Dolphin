"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #CRTLibraryImportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CRTLibraryImportTest guid: (GUID fromString: '{a3836ac0-e09a-4f44-b33f-3f87f52f2098}')!
CRTLibraryImportTest comment: ''!
!CRTLibraryImportTest categoriesForClass!SUnit! !
!CRTLibraryImportTest methodsFor!

devOnlyCrtFunctions
	^#('_get_osfhandle')!

stubNames
	^#('ConsoleToGo.exe' 'GUIToGo.exe' 'IPDolphinToGo.dll')!

testStubCrtExports
	"Ensure that .def files include proper CRTLibrary imports (#183)."

	| expected |
	expected := self devOnlyCrtFunctions.
	self stubNames do: 
			[:eachStubName |
			| f l procs missing |
			f := FileLocator installRelative localFileSpecFor: eachStubName.
			l := ExternalLibrary open: f.
			
			[procs := (CRTLibrary selectMethods: [:each | each isExternalCall])
						collect: [:each | each functionName].
			missing := procs select: [:each | (l getProcAddress: each ifAbsent: []) isNil].
			self assert: (missing difference: expected) isEmpty]
					ensure: [l close]]! !
!CRTLibraryImportTest categoriesFor: #devOnlyCrtFunctions!constants!private! !
!CRTLibraryImportTest categoriesFor: #stubNames!constants!private! !
!CRTLibraryImportTest categoriesFor: #testStubCrtExports!public!unit tests! !

