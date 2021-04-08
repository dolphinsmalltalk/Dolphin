"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'OS.COM.Tests.TypeLibraryAnalyzerTest'
	instanceVariableNames: 'analyzer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Tests.TypeLibraryAnalyzerTest guid: (Core.GUID fromString: '{64fc0f8b-7d1a-4a7f-9a9c-3fdbf7bfdae5}')!
OS.COM.Tests.TypeLibraryAnalyzerTest comment: 'If these tests fail make sure you have registered TestTypelib by running regsvr32 on Tests\TLATest\Debug\TLATest.dll'!
!OS.COM.Tests.TypeLibraryAnalyzerTest categoriesForClass!Unclassified! !
!OS.COM.Tests.TypeLibraryAnalyzerTest methodsFor!

setUp
	"If this fails make sure you have registered TestTypelib by running regsvr32 on Tests\TLATest\Debug\TLATest.dll"

	analyzer := Tests.TestTypelib current analyzer.
	analyzer isNil ifTrue: [self skip]!

tearDown
	Tests.TestTypelib reset.
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
	xl := TypeLibraryAnalyzer
				open: (FileLocator installRelative localFileSpecFor: 'Resources\Tests\Excel9.olb').
	xl prefix: 'Xl'.
	dispanalyser := xl at: #Range.
	addressFunc := dispanalyser functions detect: [:each | each name = 'Address'].
	dispanalyser generatePropGetWrappers: addressFunc.
	class := Smalltalk at: #XlRange.
	method := class compiledMethodAt: #address.
	selector := 'address:columnAbsolute:referenceStyle:external:relativeTo:' asSymbol.
	method literals noDifference: (Array
				with: (Smalltalk at: #'VARIANT')
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
!OS.COM.Tests.TypeLibraryAnalyzerTest categoriesFor: #setUp!public!unit tests! !
!OS.COM.Tests.TypeLibraryAnalyzerTest categoriesFor: #tearDown!public!unit tests! !
!OS.COM.Tests.TypeLibraryAnalyzerTest categoriesFor: #testDefaultArgs!public!unit tests! !
!OS.COM.Tests.TypeLibraryAnalyzerTest categoriesFor: #testDispinterfacePropGetOptionalArguments!public!unit tests! !
!OS.COM.Tests.TypeLibraryAnalyzerTest categoriesFor: #testQuotesInIDL!public!unit tests! !

!OS.COM.Tests.TypeLibraryAnalyzerTest class methodsFor!

resources
	^{TestTypelib}! !
!OS.COM.Tests.TypeLibraryAnalyzerTest class categoriesFor: #resources!public!unit tests! !

