"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Tools.Tests.CRTLibraryImportTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.CRTLibraryImportTest guid: (Core.GUID fromString: '{a3836ac0-e09a-4f44-b33f-3f87f52f2098}')!
Tools.Tests.CRTLibraryImportTest comment: ''!
!Tools.Tests.CRTLibraryImportTest categoriesForClass!SUnit! !
!Tools.Tests.CRTLibraryImportTest methodsFor!

devOnlyCrtFunctions
	^((MethodCategory deprecatedMethods methodsInBehavior: OS.CRTLibrary)
		select: [:each | each isExternalCall]) collect: [:each | each functionName]!

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
			l := External.DynamicLinkLibrary open: f.
			
			[| unexported |
			procs := (OS.CRTLibrary selectMethods: [:each | each isExternalCall])
						collect: [:each | each functionName].
			missing := procs select: [:each | (l getProcAddress: each asAnsiString ifAbsent: []) isNil].
			unexported := missing difference: expected.
			self assert: unexported isEmpty
				description: 
					[| desc |
					desc := String writeStream.
					desc
						nextPutAll: eachStubName;
						nextPutAll: ' is missing exports for the required CRT functions '.
					unexported asSortedCollection do: [:export | desc print: export]
						separatedBy: [desc nextPutAll: ', '].
					desc contents]]
					ensure: [l close]]! !
!Tools.Tests.CRTLibraryImportTest categoriesForMethods!
devOnlyCrtFunctions!constants!private! !
stubNames!constants!private! !
testStubCrtExports!public!unit tests! !
!

