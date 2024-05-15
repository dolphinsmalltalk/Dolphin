"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #ExternalResourceLibraryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExternalResourceLibraryTest guid: (GUID fromString: '{53144b4f-aa74-4ab2-a1c5-7b9c8f0fffec}')!

ExternalResourceLibraryTest comment: ''!

!ExternalResourceLibraryTest categoriesForClass!Unclassified! !

!ExternalResourceLibraryTest methodsFor!

testLibrariesRegister
	self deny: ExternalResourceLibrary.Libraries hasWeakKeys.
	self assert: ExternalResourceLibrary.Libraries hasWeakValues.!

testStbConvertFromVersion0
	| bytes subject |
	bytes := #[33 83 84 66 32 48 32 14 2 31 0 83 84 66 69 120 116 101 114 110 97 108 82 101 115 111 117 114 99 101 76 105 98 114 97 114 121 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 13 0 0 0 68 111 108 112 104 105 110 68 101 118 82 101 115 0 0 0 0].
	"STBDebugger dumpToTranscript: bytes readStream"
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: ExternalResourceLibrary.
	self assert: subject equals: SessionManager current defaultResourceLibrary
!

testStbConvertFromVersion1
	| bytes subject |
	bytes := #[33 83 84 66 32 52 32 14 2 31 0 83 84 66 69 120 116 101 114 110 97 108 82 101 115 111 117 114 99 101 76 105 98 114 97 114 121 80 114 111 120 121 82 0 0 0 14 0 0 0 100 111 108 112 104 105 110 100 114 55 46 100 108 108 0 0 0 0].
	"STBDebugger dumpToTranscript: bytes readStream"
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: ExternalResourceLibrary.
	self assert: subject equals: SessionManager current defaultResourceLibrary
! !

!ExternalResourceLibraryTest categoriesForMethods!
testLibrariesRegister!public!unit tests! !
testStbConvertFromVersion0!public!unit tests! !
testStbConvertFromVersion1!public!unit tests! !
!

