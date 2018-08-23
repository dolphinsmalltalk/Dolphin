"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ExternalLibraryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalLibraryTest guid: (GUID fromString: '{52518745-7c3c-4567-8599-3090af0e6567}')!
ExternalLibraryTest comment: ''!
!ExternalLibraryTest categoriesForClass!Unclassified! !
!ExternalLibraryTest methodsFor!

testInvalidCall
	"#1138 - Verify that the correct culprit is identifier for bad call-outs"

	| obj |
	obj := Object new.
	self
		should: [KernelLibrary default outputDebugString: obj]
		raise: KernelLibrary default invalidArgErrorClass
		matching: 
			[:ex |
			ex tag = 1 and: [(ex instVarNamed: 'argument') == obj and: [(ex instVarNamed: 'type') = 'lpwstr']]].
	self
		should: [KernelLibrary default findFirstFile: obj lpFindFileData: nil]
		raise: KernelLibrary default invalidArgErrorClass
		matching: 
			[:ex |
			ex tag = 1 and: [(ex instVarNamed: 'argument') == obj and: [(ex instVarNamed: 'type') = 'lpwstr']]].
	self
		should: [KernelLibrary default findFirstFile: '*.*' lpFindFileData: obj]
		raise: KernelLibrary default invalidArgErrorClass
		matching: 
			[:ex |
			ex tag = 2 and: 
					[(ex instVarNamed: 'argument') == obj
						and: [(ex instVarNamed: 'type') = (WIN32_FIND_DATAW name , '*')]]].
	self
		should: 
			[UserLibrary default
				fillRect: obj
				lprc: (ByteArray newFixed: 16)
				hbr: nil]
		raise: KernelLibrary default invalidArgErrorClass
		matching: 
			[:ex |
			ex tag = 1 and: [(ex instVarNamed: 'argument') == obj and: [(ex instVarNamed: 'type') = 'handle']]].
	self
		should: 
			[UserLibrary default
				fillRect: nil
				lprc: obj
				hbr: nil]
		raise: KernelLibrary default invalidArgErrorClass
		matching: 
			[:ex |
			ex tag = 2 and: [(ex instVarNamed: 'argument') == obj and: [(ex instVarNamed: 'type') = 'RECT*']]].
	self
		should: 
			[UserLibrary default
				fillRect: nil
				lprc: (ByteArray newFixed: 16)
				hbr: obj]
		raise: KernelLibrary default invalidArgErrorClass
		matching: 
			[:ex |
			ex tag = 3 and: [(ex instVarNamed: 'argument') == obj and: [(ex instVarNamed: 'type') = 'handle']]]!

testSingletonSerialisation
	| singletons array bytes |
	singletons := Array 
				with: KernelLibrary default
				with: VersionLibrary default
				with: UserLibrary default.
	array := #(#'!!STL' 3 98 3 1114638 ##(Smalltalk.STBSingletonProxy) 8 ##(Smalltalk.KernelLibrary) 8 #default 426 8 ##(Smalltalk.VersionLibrary) 464 426 8 ##(Smalltalk.UserLibrary) 464).
	self assert: ((Object fromLiteralStoreArray: array) asIdentitySet - singletons) isEmpty.
	array := singletons literalStoreArray.
	self assert: ((Object fromLiteralStoreArray: array) asIdentitySet - singletons) isEmpty.

	bytes := #[33 83 84 66 32 52 32 98 0 0 0 3 0 0 0 6 1 13 0 75 101 114 110 101 108 76 105 98 114 97 114 121 6 1 14 0 86 101 114 115 105 111 110 76 105 98 114 97 114 121 6 1 11 0 85 115 101 114 76 105 98 114 97 114 121].
	self assert: ((Object fromBinaryStoreBytes: bytes) asIdentitySet - singletons) isEmpty.
	bytes := singletons binaryStoreBytes.
	self assert: ((Object fromBinaryStoreBytes: bytes) asIdentitySet - singletons) isEmpty! !
!ExternalLibraryTest categoriesFor: #testInvalidCall!public!unit tests! !
!ExternalLibraryTest categoriesFor: #testSingletonSerialisation!public!unit tests! !

