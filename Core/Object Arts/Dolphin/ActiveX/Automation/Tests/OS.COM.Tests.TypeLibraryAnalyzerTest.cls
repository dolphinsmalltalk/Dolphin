"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.TypeLibraryAnalyzerTest'
	instanceVariableNames: 'analyzer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Tests.TypeLibraryAnalyzerTest guid: (Core.GUID fromString: '{64fc0f8b-7d1a-4a7f-9a9c-3fdbf7bfdae5}')!
OS.COM.Tests.TypeLibraryAnalyzerTest comment: 'If these tests fail make sure you have registered TestTypelib by running regsvr32 on Tests\TLATest\Debug\TLATest.dll'!
!OS.COM.Tests.TypeLibraryAnalyzerTest methodsFor!

tearDown
	Tests.TestTypelib reset.
	(Package manager packageNamed: 'Excel' ifNone: nil) ifNotNil: [:package | package uninstall]!

testDefaultArgs
	| obj tlb |
	tlb := self tlaTestTypelib.
	#{TLATESTLib.ITestDefaultArgs} ifDefined: [:class | class comment: nil].
	
	[
	(tlb at: #ITestDefaultArgs) generate] on: Compiler errorClass
			do: [:ex | self assert: false description: ex description].
	obj := #{TLATESTLib.ITestDefaultArgs} value  new.
	obj testDefaultBool.
	obj testDefaultBstr.
	obj testDefaultDate.
	obj testDefaultCy.
	obj testDefaultI1.
	obj testDefaultI2.
	obj testDefaultI4.
	obj testDefaultI8.
	obj testDefaultIDispatch.
	obj testDefaultIUnknown.
	obj testDefaultUI1.
	obj testDefaultUI2.
	obj testDefaultUI4.
	"	obj testDefaultUI8."
	obj testDefaultR4.
	obj testDefaultR8.
	obj testDefaultVariant!

testDispinterfacePropGetOptionalArguments
	"#1478"
	<knownSlowTest>
	| xl class dispanalyser addressFunc method selector ns |
	xl := TypeLibraryAnalyzer
				open: (FileLocator installRelative localFileSpecFor: 'Resources\Tests\Excel9.olb').
	xl namespaceName: #{COM.Tests.Xl}.
	#todo. "Fix the fact that we have to explicitly cause the namespace class to be generated"
	ns := xl namespaceBinding.
	self assert: ns fullName equals: 'OS.COM.Tests.Xl'.
	dispanalyser := xl at: #Range.
	addressFunc := dispanalyser functions detect: [:each | each name = 'Address'].
	dispanalyser generatePropGetWrappers: addressFunc.
	class := #{COM.Tests.Xl.Range} value.
	method := class compiledMethodAt: #address.
	selector := 'address:columnAbsolute:referenceStyle:external:relativeTo:' asSymbol.
	method literals noDifference: { VARIANT. #unspecified. selector }.
	self assert: (class includesSelector: selector)!

testQuotesInIDL
	| class tlb |
	tlb := self tlaTestTypelib.
	#(#ITestQuotesInIDL #TestRect #TestPoint) do: 
			[:each |
			| bindingRef |
			bindingRef := BindingReference path: { 'TLATESTLib'. each }.
			bindingRef ifDefined: [:c | c comment: nil].
			[(tlb at: each) generate] on: Compiler errorClass
				do: [:ex | self assert: false description: ex description].
			class := bindingRef value.
			self assert: class comment notEmpty.
			self assert: (Compiler evaluate: class comment printString) = class comment]!

testStbConvertFromVersion2
	| bytes subject |
	bytes := #[33 83 84 66 32 52 32 70 9 21 0 2 0 0 0 65 88 84 121 112 101 76 105 98 114 97 114 121 65 110 97 108 121 122 101 114 6 2 9 0 73 84 121 112 101 76 105 98 50 0 0 0 0 0 0 0 0 5 8 0 0 6 1 8 0 84 76 73 66 65 84 84 82 114 0 0 0 32 0 0 0 252 1 41 102 81 105 84 72 158 178 217 162 87 15 43 46 0 0 0 0 1 0 0 0 5 0 1 0 8 0 0 0 82 0 0 0 0 0 0 0 82 0 0 0 7 0 0 0 87 105 110 72 116 116 112 178 0 0 0 10 0 0 0 87 105 110 72 116 116 112 76 105 98 178 0 0 0 16 0 0 0 87 105 110 72 116 116 112 67 111 110 115 116 97 110 116 115 234 0 0 0 240 0 0 0 98 0 0 0 6 0 0 0 82 0 0 0 11 0 0 0 80 82 79 80 86 65 82 73 65 78 84 178 0 0 0 7 0 0 0 86 65 82 73 65 78 84 82 0 0 0 15 0 0 0 82 101 109 111 116 97 98 108 101 72 97 110 100 108 101 178 0 0 0 14 0 0 0 69 120 116 101 114 110 97 108 72 97 110 100 108 101 82 0 0 0 4 0 0 0 71 85 73 68 178 0 0 0 4 0 0 0 71 85 73 68 0 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: TypeLibraryAnalyzer.
	self assert: subject attributes guid
		equals: (GUID fromString: '{662901fc-6951-4854-9eb2-d9a2570f2b2e}').
	self assert: subject packageName equals: 'WinHttp'.
	self assert: subject constantsPoolName equals: #WinHttpConstants.
	self assert: subject aliasMap
		equals: (LookupTable
				withAll: { 'GUID' -> #GUID. 'PROPVARIANT' -> #VARIANT. 'RemotableHandle' -> #ExternalHandle }).
	self assert: subject generationFlags
		equals: TypeGenerationFlags.NoTypeLib | TypeGenerationFlags.LowercaseIdentifiers.
	self assert: subject namespaceName equals: #WinHttp asQualifiedReference!

tlaTestTypelib
	"Private - If this fails make sure you have registered TestTypelib by running regsvr32 on Tests\TLATest\Debug\TLATest.dll"

	analyzer := Tests.TestTypelib current analyzer.
	analyzer isNil ifTrue: [self skip].
	^analyzer! !
!OS.COM.Tests.TypeLibraryAnalyzerTest categoriesForMethods!
tearDown!public!unit tests! !
testDefaultArgs!public!unit tests! !
testDispinterfacePropGetOptionalArguments!public!unit tests! !
testQuotesInIDL!public!unit tests! !
testStbConvertFromVersion2!public!unit tests! !
tlaTestTypelib!accessing!private! !
!

!OS.COM.Tests.TypeLibraryAnalyzerTest class methodsFor!

resources
	^{TestTypelib}! !
!OS.COM.Tests.TypeLibraryAnalyzerTest class categoriesForMethods!
resources!public!unit tests! !
!

