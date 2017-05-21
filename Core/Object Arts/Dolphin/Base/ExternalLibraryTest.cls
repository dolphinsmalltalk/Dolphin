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
			ex tag = 1 
				and: [(ex instVarNamed: 'argument') == obj and: [(ex instVarNamed: 'type') = 'lpstr']]].
	self 
		should: [KernelLibrary default findFirstFile: obj lpFindFileData: nil]
		raise: KernelLibrary default invalidArgErrorClass
		matching: 
			[:ex | 
			ex tag = 1
				and: [(ex instVarNamed: 'argument') == obj and: [(ex instVarNamed: 'type') = 'lpstr']]].
	self 
		should: [KernelLibrary default findFirstFile: '*.*' lpFindFileData: obj]
		raise: KernelLibrary default invalidArgErrorClass
		matching: 
			[:ex | 
			ex tag = 2
				and: [(ex instVarNamed: 'argument') == obj and: [(ex instVarNamed: 'type') = 'WIN32_FIND_DATA*']]].
	self 
		should: [UserLibrary default fillRect: obj lprc: RECT new hbr: nil]
		raise: KernelLibrary default invalidArgErrorClass
		matching: 
			[:ex | 
			ex tag = 1
				and: [(ex instVarNamed: 'argument') == obj and: [(ex instVarNamed: 'type') = 'handle']]].

	self 
		should: [UserLibrary default fillRect: nil lprc: obj hbr: nil]
		raise: KernelLibrary default invalidArgErrorClass
		matching: 
			[:ex | 
			ex tag = 2
				and: [(ex instVarNamed: 'argument') == obj and: [(ex instVarNamed: 'type') = 'RECT*']]].
	self 
		should: [UserLibrary default fillRect: nil lprc: RECT new hbr: obj]
		raise: KernelLibrary default invalidArgErrorClass
		matching: 
			[:ex | 
			ex tag = 3
				and: [(ex instVarNamed: 'argument') == obj and: [(ex instVarNamed: 'type') = 'handle']]].

!

testSingletonSerialisation
	| singletons array bytes |
	singletons := Array 
				with: KernelLibrary default
				with: ShellLibrary default
				with: UserLibrary default.
	array := #(#'!!STL' 3 98 3 1114638 ##(Smalltalk.STBSingletonProxy) 8 ##(Smalltalk.KernelLibrary) 8 #default 426 8 ##(Smalltalk.ShellLibrary) 464 426 8 ##(Smalltalk.UserLibrary) 464).
	self assert: ((Object fromLiteralStoreArray: array) asIdentitySet - singletons) isEmpty.
	array := singletons literalStoreArray.
	self assert: ((Object fromLiteralStoreArray: array) asIdentitySet - singletons) isEmpty.
	bytes := #[33 83 84 66 32 51 32 98 0 0 0 3 0 0 0 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 154 0 0 0 82 0 0 0 7 0 0 0 68 111 108 112 104 105 110 82 0 0 0 13 0 0 0 75 101 114 110 101 108 76 105 98 114 97 114 121 178 0 0 0 7 0 0 0 100 101 102 97 117 108 116 170 1 0 0 154 0 0 0 208 1 0 0 82 0 0 0 12 0 0 0 83 104 101 108 108 76 105 98 114 97 114 121 240 1 0 0 170 1 0 0 154 0 0 0 208 1 0 0 82 0 0 0 11 0 0 0 85 115 101 114 76 105 98 114 97 114 121 240 1 0 0].
	self assert: ((Object fromBinaryStoreBytes: bytes) asIdentitySet - singletons) isEmpty.
	bytes := singletons binaryStoreBytes.
	self assert: ((Object fromBinaryStoreBytes: bytes) asIdentitySet - singletons) isEmpty! !
!ExternalLibraryTest categoriesFor: #testInvalidCall!public!unit tests! !
!ExternalLibraryTest categoriesFor: #testSingletonSerialisation!public!unit tests! !

