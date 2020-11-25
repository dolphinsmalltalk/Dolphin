"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #AXTypeLibraryAnalyzerTest
	instanceVariableNames: 'analyzer'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AXTypeLibraryAnalyzerTest guid: (GUID fromString: '{64fc0f8b-7d1a-4a7f-9a9c-3fdbf7bfdae5}')!
AXTypeLibraryAnalyzerTest comment: 'If these tests fail make sure you have registered TestTypelib by running regsvr32 on Tests\TLATest\Debug\TLATest.dll'!
!AXTypeLibraryAnalyzerTest categoriesForClass!Unclassified! !
!AXTypeLibraryAnalyzerTest methodsFor!

setUp
	"If this fails make sure you have registered TestTypelib by running regsvr32 on Tests\TLATest\Debug\TLATest.dll"

	analyzer := TestTypelib current analyzer.
	analyzer isNil ifTrue: [self skip].!

tearDown
	TestTypelib reset.
	(Package manager packageNamed: 'Excel' ifNone: []) ifNotNil: [:package | package uninstall]!

testDefaultArgs
	| obj |
	Smalltalk at: #TLATESTLibITestDefaultArgs ifPresent: [:class | class comment: nil].
	[(analyzer at: #ITestDefaultArgs) generate] on: Compiler errorClass
		do: [:ex | self assert: false description: ex description].
	obj := (Smalltalk at: #TLATESTLibITestDefaultArgs) new.
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

	| xl class dispanalyser addressFunc method selector |
	xl := AXTypeLibraryAnalyzer 
				open: (FileLocator installRelative localFileSpecFor: 'Resources\Tests\Excel9.olb').
	xl prefix: 'Xl'.
	dispanalyser := xl at: #Range.
	addressFunc := dispanalyser functions detect: [:each | each name = 'Address'].
	dispanalyser generatePropGetWrappers: addressFunc.
	class := Smalltalk at: #XlRange.
	method := class compiledMethodAt: #address.
	selector := 'address:columnAbsolute:referenceStyle:external:relativeTo:' asSymbol.
	method literals noDifference: (Array 
				with: (Smalltalk at: #VARIANT)
				with: #unspecified
				with: selector).
	self assert: (class includesSelector: selector)!

testQuotesInIDL
	| class |
	#(#ITestQuotesInIDL #TestRect #TestPoint) do: 
			[:each | 
			Smalltalk at: #TLATESTLib , each ifPresent: [:c | c comment: nil].
			[(analyzer at: each) generate] on: Compiler errorClass
				do: [:ex | self assert: false description: ex description].
			class := Smalltalk at: #TLATESTLibITestQuotesInIDL.
			self assert: class comment notEmpty.
			self assert: (Compiler evaluate: class comment printString) = class comment]! !
!AXTypeLibraryAnalyzerTest categoriesFor: #setUp!public!unit tests! !
!AXTypeLibraryAnalyzerTest categoriesFor: #tearDown!public!unit tests! !
!AXTypeLibraryAnalyzerTest categoriesFor: #testDefaultArgs!public!unit tests! !
!AXTypeLibraryAnalyzerTest categoriesFor: #testDispinterfacePropGetOptionalArguments!public!unit tests! !
!AXTypeLibraryAnalyzerTest categoriesFor: #testQuotesInIDL!public!unit tests! !

!AXTypeLibraryAnalyzerTest class methodsFor!

resources
	^Array with: TestTypelib! !
!AXTypeLibraryAnalyzerTest class categoriesFor: #resources!public!unit tests! !

