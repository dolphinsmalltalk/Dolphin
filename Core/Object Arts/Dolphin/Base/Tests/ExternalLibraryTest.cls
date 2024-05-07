"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #ExternalLibraryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExternalLibraryTest guid: (GUID fromString: '{52518745-7c3c-4567-8599-3090af0e6567}')!

ExternalLibraryTest comment: ''!

!ExternalLibraryTest categoriesForClass!Unclassified! !

!ExternalLibraryTest methodsFor!

makeTestMethodFrom: anExternalMethod overlapped: aBoolean 
	^aBoolean 
		ifTrue: [anExternalMethod copy extraIndex: 48; yourself]
		ifFalse: [anExternalMethod]!

testInvalidCallArguments
	"Verify that the correct culprit is identified for bad call-outs"

	self verifyInvalidCallArguments: false!

testInvalidOverlappedCallArguments
	self verifyInvalidCallArguments: true!

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
	self assert: ((Object fromBinaryStoreBytes: bytes) asIdentitySet - singletons) isEmpty!

verifyInvalidCallArguments: aBoolean
	| apiCall errorClass obj |
	obj := Object new.
	errorClass := KernelLibrary default invalidArgErrorClass.
	apiCall := self makeTestMethodFrom: KernelLibrary >> #outputDebugString: overlapped: aBoolean.
	self
		should: [apiCall value: KernelLibrary default withArguments: {obj}]
		raise: errorClass
		matching: 
			[:ex |
			ex hresult = (HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.InvalidParameter1)
				and: [ex argument == obj and: [ex type = 'lpwstr']]].
	apiCall := self makeTestMethodFrom: KernelLibrary >> #findFirstFile:lpFindFileData:
				overlapped: aBoolean.
	self
		should: [apiCall value: KernelLibrary default withArguments: {'*.*' asUtf16String. obj}]
		raise: errorClass
		matching: 
			[:ex |
			ex hresult = (HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.InvalidParameter2)
				and: [ex argument == obj and: [ex type = (WIN32_FIND_DATAW name , '*')]]].
	apiCall := self makeTestMethodFrom: UserLibrary >> #fillRect:lprc:hbr: overlapped: aBoolean.
	self
		should: [apiCall value: UserLibrary default withArguments: {obj. ByteArray newFixed: 16. nil}]
		raise: errorClass
		matching: 
			[:ex |
			ex hresult = (HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.InvalidParameter1)
				and: [ex argument == obj and: [ex type = 'handle']]].
	self
		should: [apiCall value: UserLibrary default withArguments: {nil. obj. nil}]
		raise: errorClass
		matching: 
			[:ex |
			ex hresult = (HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.InvalidParameter2)
				and: [ex argument == obj and: [ex type = 'RECT*']]].
	self
		should: [apiCall value: UserLibrary default withArguments: {nil. ByteArray newFixed: 16. obj}]
		raise: errorClass
		matching: 
			[:ex |
			ex hresult = (HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.InvalidParameter3)
				and: [ex argument == obj and: [ex type = 'handle']]].
	"The rare case of an API with more than 12 parameters, and the error is in the 13th"
	apiCall := self makeTestMethodFrom: GDILibrary
						>> #stretchDIBits:xDest:yDest:nDestWidth:nDestHeight:xSrc:ySrc:nSrcWidth:nSrcHeight:lpBits:lpBitsInfo:iUsage:dwRop:
				overlapped: aBoolean.
	self
		should: [apiCall value: GDILibrary default withArguments: #(nil 0 0 0 0 0 0 0 0 nil nil 0 's')]
		raise: HRESULTError
		matching: [:ex | ex hresult = (HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.InvalidParameter)]! !

!ExternalLibraryTest categoriesForMethods!
makeTestMethodFrom:overlapped:!helpers!private! !
testInvalidCallArguments!public!unit tests! !
testInvalidOverlappedCallArguments!public!unit tests! !
testSingletonSerialisation!public!unit tests! !
verifyInvalidCallArguments:!helpers!private! !
!

