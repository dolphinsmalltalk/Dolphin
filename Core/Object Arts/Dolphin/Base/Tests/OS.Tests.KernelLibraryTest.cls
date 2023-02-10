"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.KernelLibraryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.KernelLibraryTest guid: (Core.GUID fromString: '{7b0f6540-a426-45fa-b5c3-5bb94cdcfa07}')!
OS.Tests.KernelLibraryTest comment: ''!
!OS.Tests.KernelLibraryTest methodsFor!

maxPathComponentLength: aString
	| buf max |
	buf := UInt32Bytes new.
	(Kernel32
		getVolumeInformation: aString
		lpVolumeNameBuffer: nil
		nVolumeNameSize: 0
		lpVolumeSerialNumber: nil
		lpMaximumComponentLength: buf
		lpFileSystemFlags: nil
		lpFileSystemNameBuffer: nil
		nFileSystemNameSize: 0) ifFalse: [Kernel32 systemError].
	max := buf value.
	self assert: max >= 255.
	^max!

testCreateDirectory
	| tmpDir subDir |
	tmpDir := File composePath: File tempPath
				subPath: Character dolphin asString , GUID newUnique idlString.
	self assert: (Kernel32 createDirectory: tmpDir).
	
	[self assert: (File isDirectory: tmpDir).
	{String new: 248 - tmpDir size - 2 withAll: $a.
		String new: 248 withAll: $b.
		String new: 248 - tmpDir size - 1 withAll: $c} do: 
				[:each |
				subDir := File composePath: tmpDir subPath: each.
				self assert: (Kernel32 createDirectory: subDir).
				self assert: (File isDirectory: subDir)]]
			ensure: [File deleteDirectory: tmpDir]!

testExpandEnvironmentStrings
	| actual expected |
	actual := Kernel32 expandEnvironmentStrings: ''.
	self assert: actual equals: ''.
	actual := Kernel32 expandEnvironmentStrings: '%WIBBLE%'.
	self assert: actual equals: '%WIBBLE%'.
	actual := Kernel32 expandEnvironmentStrings: '%USERNAME% is a 🐬 user on %COMPUTERNAME%'.
	expected := SessionManager current userName , ' is a 🐬 user on '
				, SessionManager current computerName.
	self assert: actual equals: expected!

testGetCurrentDirectory
	| wd |
	wd := Kernel32 getCurrentDirectory.
	self assert: ((Kernel32 getFileAttributes: wd) allMask: Win32Constants.FILE_ATTRIBUTE_DIRECTORY)!

testGetEnvironmentVariable
	| actual expected |
	self assertIsNil: (Kernel32 getEnvironmentVariable: '').
	self assertIsNil: (Kernel32 getEnvironmentVariable: '%WIBBLE%').
	actual := Kernel32 getEnvironmentVariable: 'USERNAME'.
	self assert: actual equals: SessionManager current userName!

testGetModuleFilename
	| dir lib testDll maxDllFilestem maxComponent |
	self assert: ((Kernel32 getModuleFilename: Kernel32)
				compareOrdinals: (File composePath: SessionManager current systemDirectory subPath: 'KERNEL32.DLL')
				ignoringCase: true)
		equals: 0.
	"GetModuleFilename is documented to fail for libraries opened only to read resources, but historically we have returned an empty string in this case rather than raising an error"
	lib := ResourceLibrary open: 'notepad.exe'.
	self assertNotNil: lib asParameter.
	self assert: (Kernel32 getModuleFilename: lib) equals: ''.
	lib close.
	"Now test with increasingly long paths including some interesting boundary cases of the APIs. We do this by copying a convenient DLL to a temporary directory and giving it a long name."
	dir := File createTemporaryDirectory.
	maxComponent := self maxPathComponentLength: (dir copyFrom: 1 to: 3).
	"LoadLibrary has a lower limit on the maximum length of a DLL name than the component length for the volume. Perhaps this is documented somewhere."
	maxDllFilestem := maxComponent - 13.
	"There is no particular significance to the use of DolphinSureCrypto, it is just a convenient passive DLL that we can copy to a long filename to open"
	testDll := FileLocator installRelative localFileSpecFor: 'DolphinCR8.dll'.
	
	[| path moduleFilename subDir |
	subDir := String new: maxComponent withAll: $x.
	File createDirectory: '\\?\' , dir , '\' , subDir.
	"The maximum size of a short path to a DLL is quite a bit less than MAX_PATH."
	{
		String new: maxComponent - dir size - 5 - 10 withAll: $a.
		String new: maxComponent - dir size - 5 - 5 withAll: $b.
		String new: maxComponent - dir size - 5 - 4 withAll: $c.
		String new: maxComponent - dir size - 4 withAll: $d.
		String new: maxDllFilestem withAll: $e.
		subDir , '\' , (String new: maxDllFilestem withAll: $f)
	} do: 
				[:each |
				path := File
							composePath: dir
							stem: each
							extension: 'dll'.
				"LoadLibrary won't open a short path longer than 251 chars"
				path size >= (Win32Constants.MAX_PATH - 9) ifTrue: [path := '\\?\' , path].
				Kernel32 copyFile: testDll to: path.
				lib := DynamicLinkLibrary open: path.
				moduleFilename := Kernel32 getModuleFilename: lib.
				self assert: moduleFilename equals: path.
				lib close]]
			ensure: 
				[lib isNil ifFalse: [lib free].
				File deleteDirectory: dir]!

testGetSystemDirectory
	| actual expected |
	actual := Kernel32 getSystemDirectory.
	self assert: (File isDirectory: actual).
	expected := $\ join: (($\ split: Kernel32 fileName) copyFrom: 1 to: 3).
	self assert: (actual compareOrdinals: expected ignoringCase: true) equals: 0!

testGetSystemWindowsDirectory
	| actual expected |
	actual := Kernel32 getSystemWindowsDirectory.
	self assert: (File isDirectory: actual).
	expected := $\ join: (($\ split: Kernel32 fileName) copyFrom: 1 to: 2).
	self assert: (actual compareOrdinals: expected ignoringCase: true) equals: 0!

testGetTempPath
	self assert: (File appendPathDelimiter: Kernel32 getTempPath)
		equals: (File appendPathDelimiter: (Kernel32 getEnvironmentVariable: 'TMP'))!

testSetCurrentDirectory
	| tmpDir path |
	tmpDir := File composePath: File tempPath
				subPath: Character dolphin asString , GUID newUnique idlString.
	
	[| wd |
	self assert: (Kernel32 createDirectory: tmpDir).
	path := File composePath: tmpDir
				subPath: (String new: Win32Constants.MAX_PATH - tmpDir asUtf16String size - 3 withAll: $£).
	"SetCurrentDirectoryW is documented as supporting long paths, but empirically it doesn't seem to. As soon as we hit MAX_PATH - 1, the SetCurrentDirectory call will fail complaining the filename or extension is too long (although in fact only 221 code-units long, well within the typical component limit)."
	self assert: path asUtf16String size equals: Win32Constants.MAX_PATH - 2.
	(Kernel32 createDirectory: path) ifFalse: [Kernel32 systemError].
	self assert: (File isDirectory: path).
	wd := Kernel32 getCurrentDirectory.
	self deny: wd equals: path.
	(Kernel32 setCurrentDirectory: path) ifFalse: [Kernel32 systemError].
	self assert: Kernel32 getCurrentDirectory equals: path.
	self assert: (Kernel32 setCurrentDirectory: wd).
	self assert: Kernel32 getCurrentDirectory equals: wd]
			ensure: [File deleteDirectory: tmpDir]!

testSetEnvironmentVariable
	| unique |
	unique := Character dolphin asString , GUID newUnique idlString.
	self assert: (Kernel32 setEnvironmentVariable: unique lpValue: 'a🐬£').
	
	[self assert: (Kernel32 getEnvironmentVariable: unique) equals: 'a🐬£'.
	self assert: (Kernel32 setEnvironmentVariable: unique lpValue: nil).
	self assertIsNil: (Kernel32 getEnvironmentVariable: unique)]
			ensure: [Kernel32 setEnvironmentVariable: unique lpValue: nil]! !
!OS.Tests.KernelLibraryTest categoriesForMethods!
maxPathComponentLength:!helpers!private! !
testCreateDirectory!public!unit tests! !
testExpandEnvironmentStrings!public!unit tests! !
testGetCurrentDirectory!public!unit tests! !
testGetEnvironmentVariable!public!unit tests! !
testGetModuleFilename!public!unit tests! !
testGetSystemDirectory!public!unit tests! !
testGetSystemWindowsDirectory!public!unit tests! !
testGetTempPath!public!unit tests! !
testSetCurrentDirectory!public!unit tests! !
testSetEnvironmentVariable!public!unit tests! !
!

