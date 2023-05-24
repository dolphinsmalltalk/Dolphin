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

tlaTestTypelib
	"Private - If this fails make sure you have registered TestTypelib by running regsvr32 on Tests\TLATest\Debug\TLATest.dll"

	analyzer := Tests.TestTypelib current analyzer.
	analyzer isNil ifTrue: [self skip]! !
!OS.COM.Tests.TypeLibraryAnalyzerTest categoriesForMethods!
tearDown!public!unit tests! !
testDefaultArgs!public!unit tests! !
testDispinterfacePropGetOptionalArguments!public!unit tests! !
testQuotesInIDL!public!unit tests! !
tlaTestTypelib!accessing!private! !
!

!OS.COM.Tests.TypeLibraryAnalyzerTest class methodsFor!

resources
	^{TestTypelib}! !
!OS.COM.Tests.TypeLibraryAnalyzerTest class categoriesForMethods!
resources!public!unit tests! !
!

