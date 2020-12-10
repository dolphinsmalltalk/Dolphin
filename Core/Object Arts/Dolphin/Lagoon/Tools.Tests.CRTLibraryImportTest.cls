"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #CRTLibraryImportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CRTLibraryImportTest guid: (GUID fromString: '{a3836ac0-e09a-4f44-b33f-3f87f52f2098}')!
CRTLibraryImportTest comment: ''!
!CRTLibraryImportTest categoriesForClass!SUnit! !
!CRTLibraryImportTest methodsFor!

devOnlyCrtFunctions
	^((MethodCategory deprecatedMethods methodsInBehavior: CRTLibrary) select: [:each | each isKindOf: ExternalMethod])
		collect: [:each | each functionName]!

minimumVmVersion
	"The minimum VM version on which to run this test specified as a 64-bit integer. This allows
	for the VM to temporarily fall behind the CRT imports in the image, as without this
	capability sequencing the changes to image and VM requires multiple steps. "

	"The procedure is:
		1) Add/change CRTLibrary methods 
		2) Advance version number beyond the current VM version (e.g. increment the build version number, the least significant of those below)
		3) Commit changes to Dolphin repo.
		4) Update the .def files for the stubs in the DolphinVM solution.
		5) Commit changes to the DolphinVM repo."

	^self versionFromParts: #(2016 7 0 55)!

stubNames
	^#('ConsoleToGo.exe' 'GUIToGo.exe' 'IPDolphinToGo.dll')!

testStubCrtExports
	"Ensure that .def files include proper CRTLibrary imports (#183)."

	| expected |
	self skipUnless: [VMLibrary default versionInfo fileVersion >= self minimumVmVersion].
	expected := self devOnlyCrtFunctions.
	self stubNames do: 
			[:eachStubName |
			| f l procs missing |
			f := FileLocator installRelative localFileSpecFor: eachStubName.
			l := External.DynamicLinkLibrary open: f.
			
			[| unexported |
			procs := (CRTLibrary selectMethods: [:each | each isExternalCall])
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
!CRTLibraryImportTest categoriesFor: #devOnlyCrtFunctions!constants!private! !
!CRTLibraryImportTest categoriesFor: #minimumVmVersion!accessing!public! !
!CRTLibraryImportTest categoriesFor: #stubNames!constants!private! !
!CRTLibraryImportTest categoriesFor: #testStubCrtExports!public!unit tests! !

