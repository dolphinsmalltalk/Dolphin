"Filed out from Dolphin Smalltalk"!

Tools.Tests.STxDebuggerTest
	subclass: #'Tools.Tests.STLDebuggerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.STLDebuggerTest guid: (Core.GUID fromString: '{ff809f44-4ea6-461b-a9e7-77597a99be16}')!
Tools.Tests.STLDebuggerTest comment: ''!
!Tools.Tests.STLDebuggerTest methodsFor!

expectedDump3
	^'STL version 3:
000002 [Array]
000004     [%<0: nil>]
000005     [%<1: true>]
000006     [%<2: false>]
000007     26: #testVersion0
000009     27: #''†Symbol''
000011     28: ''a''
000013     29: ''a''
000015     [$a]
000016     [$€]
000017     [$£]
000018     [$ÿ]
000019     [$€]
000020     0
000021     -1073741824
000022     30: 18446744073709551616
000024     [Float] 32: 1.25
000035     [Float] 33: Float.Infinity
000045     [Float] 34: Float.NaN
000055     [ScaledDecimal]
000057         [Fraction]
000059             5
000060             4
000061         2
000062     [ScaledDecimal]
000063         [Fraction]
000064             2
000065             3
000066         2
000067     41: Object
000069     [STBMetaclassProxy]
000070         43: ''Dolphin''
000072         44: ''Object''
000074     [%<4: a ProcessorScheduler>]
000075     [STBSingletonProxy]
000077         47: TranscriptShell
000079         48: #current
000081     [%<3: Smalltalk>]
000082     49: #[]
000084     50: #[255]
000086     51: #[1 2 3 4 5]
000088     [STBCollectionProxy]
000089         [%<13: OrderedCollection>]
000090         [Array]
000092             [%<28: ''a''>]
000093             [%<26: #testVersion0>]
000094             [$d]
000095     [STBSortedCollectionProxy]
000098         56: SortedCollection
000100         [Array]
000102             58: ''a''
000104             59: ''B''
000106             60: ''b''
000108             61: ''B''
000110         [MergesortAlgorithm]
000112             [BlockClosure]
000116                 [%<0: nil>]
000117                 [CompiledMethod]
000120                     0
000121                     [STBMetaclassProxy]
000122                         69: ''Dolphin''
000124                         70: ''PluggableSortAlgorithm''
000126                     71: #new
000128                     <1p>
000129                     72: #[171 100 31 177 97 105 233 1 130 106]
000131                     73: #basicNew
000133                     74: #setSortBlock:
000135                     [%<65: [] in nil>]
000136                     75: #%<=
000138                     76: #yourself
000140                 7
000141                 256
000142                 [%<0: nil>]
000143     [STBIdentityDictionaryProxy]
000144         [%<15: LookupTable>]
000145         [Array]
000147             79: ''origin''
000149             [Point]
000151                 10
000152                 20
000153             2
000154             [Point]
000155                 100
000156                 200
End of 72 objects'  << (PluggableSortAlgorithm class >> #new) sourceDescriptor!

expectedDump4
	^'STL version 4:
000002 [Array]
000004     nil
000005     true
000006     false
000007     #testVersion0
000008     #''†Symbol''
000009     26: ''a''
000011     27: ''a''
000013     28: ''a''
000015     29: ''文字化け''
000017     $a
000018     $\x80
000019     $£
000020     $ÿ
000021     $€
000022     $🐬
000023     0
000024     -1073741824
000025     30: 18446744073709551616
000027     [Float] 32: 1.25
000038     [Float] 33: Float.Infinity
000048     [Float] 34: Float.NaN
000058     [ScaledDecimal]
000060         [Fraction]
000062             5
000063             4
000064         2
000065     [ScaledDecimal]
000066         [Fraction]
000067             2
000068             3
000069         2
000070     Object
000071     [STBMetaclassProxy]
000072         42: ''Dolphin''
000074         43: ''Object''
000076     a ProcessorScheduler
000077     [STBSingletonProxy]
000079         TranscriptShell
000080         #current
000081     Smalltalk
000082     46: #[]
000084     47: #[255]
000086     48: #[1 2 3 4 5]
000088     [STBCollectionProxy]
000089         [%<9: OrderedCollection>]
000090         [Array]
000092             [%<26: ''a''>]
000093             #testVersion0
000094             $d
000095     [STBSortedCollectionProxy]
000098         SortedCollection
000099         [Array]
000101             54: ''a''
000103             55: ''B''
000105             56: ''b''
000107             57: ''B''
000109         [MergesortAlgorithm]
000111             [BlockClosure]
000115                 nil
000116                 [CompiledMethod]
000119                     0
000120                     [STBMetaclassProxy]
000121                         65: ''Dolphin''
000123                         66: ''PluggableSortAlgorithm''
000125                     #new
000126                     <1p>
000127                     67: #[171 100 31 177 97 105 233 1 130 106]
000129                     #basicNew
000130                     #setSortBlock:
000131                     [%<61: [] in nil>]
000132                     #%<=
000133                     #yourself
000134                 7
000135                 256
000136                 nil
000137     [STBIdentityDictionaryProxy]
000138         [%<11: LookupTable>]
000139         [Array]
000141             70: ''origin''
000143             [Point]
000145                 10
000146                 20
000147             2
000148             [Point]
000149                 100
000150                 200
End of 83 objects' <<  (PluggableSortAlgorithm class >> #new) sourceDescriptor!

expectedDump5
	^'STL version 5:
000002 [Array]
000004     nil
000005     true
000006     false
000007     #testVersion0
000008     #''†Symbol''
000009     [Utf8String]
000010         #[97 0 98] 26: ''a␀b''
000011     [Utf8String]
000012         #[97 0 98] 27: ''a␀b''
000013     [Utf8String]
000014         #[97 0 98] 28: ''a␀b''
000015     29: ''文字化け''
000017     $a
000018     $\x80
000019     $£
000020     $ÿ
000021     $€
000022     $🐬
000023     0
000024     -1073741824
000025     30: 18446744073709551616
000027     31: 1.25
000029     [Float] 33: Float.Infinity
000040     [Float] 34: Float.NaN
000050     35: 1.25s
000052     [ScaledDecimal]
000054         [Fraction]
000056             2
000057             3
000058         2
000059     #{Core.Object}
000060     #{Core.Object class}
000061     #{Core.Processor}
000062     [STBSingletonProxy]
000064         #{UI.TranscriptShell}
000065         #current
000066     #{Smalltalk}
000067     42: #[]
000069     43: #[255]
000071     44: #[1 2 3 4 5]
000073     [STBCollectionProxy]
000074         [%<9: OrderedCollection>]
000075         [Array]
000077             [%<26: ''a␀b''>]
000078             #testVersion0
000079             $d
000080     [STBSortedCollectionProxy]
000083         #{Core.SortedCollection}
000084         [Array]
000086             50: ''a''
000088             51: ''B''
000090             52: ''b''
000092             53: ''B''
000094         [MergesortAlgorithm]
000096             [BlockClosure]
000100                 nil
000101                 [CompiledMethod]
000104                     0
000105                     #{Kernel.PluggableSortAlgorithm class}
000106                     #new
000107                     <1p>
000108                     60: #[171 100 31 177 97 105 233 1 130 106]
000110                     #basicNew
000111                     #setSortBlock:
000112                     [%<57: [] in nil>]
000113                     #%<=
000114                     #yourself
000115                 7
000116                 256
000117                 nil
000118     [STBIdentityDictionaryProxy]
000119         [%<11: LookupTable>]
000120         [Array]
000122             63: ''origin''
000124             [Point]
000126                 10
000127                 20
000128             2
000129             [Point]
000130                 100
000131                 200
000132     67: #{Core.Object}
End of 79 objects'  << (PluggableSortAlgorithm class >> #new) sourceDescriptor!

expectedDump6
	^'STL version 6:
000002 [Array]
000005     nil
000006     true
000007     false
000008     #testVersion0
000009     #''†Symbol''
000010     [Utf8String]
000013         #[97 0 98] 4: ''a␀b''
000014     [Utf8String]
000015         #[97 0 98] 5: ''a␀b''
000016     [Utf8String]
000017         #[97 0 98] 6: ''a␀b''
000018     7: ''文字化け''
000020     $a
000021     8: $\x80
000023     $£
000024     $ÿ
000025     $€
000026     9: $🐬
000028     0
000029     -1073741824
000030     10: 18446744073709551616
000032     11: 1.25
000034     #{Float.Infinity}
000035     #{Float.NaN}
000036     12: 1.25s
000038     [ScaledDecimal]
000040         [Fraction]
000042             2
000043             3
000044         2
000045     #{Core.Object}
000046     #{Core.Object class}
000047     #{Core.Processor}
000048     #{Core.Transcript}
000049     #{Smalltalk}
000050     17: #[]
000052     18: #[255]
000054     19: #[1 2 3 4 5]
000056     [OrderedCollection]
000059         [%<4: ''a␀b''>]
000060         #testVersion0
000061         $d
000062     [STBSortedCollectionProxy]
000065         #{Core.SortedCollection}
000066         [Array]
000068             25: ''a''
000070             26: ''B''
000072             27: ''b''
000074             28: ''B''
000076         [MergesortAlgorithm]
000078             [BlockClosure]
000082                 nil
000083                 [CompiledMethod]
000086                     0
000087                     #{Kernel.PluggableSortAlgorithm class}
000088                     #new
000089                     <1p>
000090                     35: #[171 100 31 177 97 105 233 1 130 106]
000092                     #basicNew
000093                     #setSortBlock:
000094                     [%<32: [] in nil>]
000095                     #%<=
000096                     #yourself
000097                 7
000098                 256
000099                 nil
000100     [LookupTable]
000103         2
000104         [Point]
000106             100
000107             200
000108         40: ''origin''
000110         [Point]
000111             10
000112             20
000113     42: #{Core.Object}
End of 75 objects'  << (PluggableSortAlgorithm class >> #new) sourceDescriptor!

minimumFilerVersion
	^3!

outfilerClass
	^STLOutFiler!

saveStaticVariableDumpFormat
	^'STL version <1d>:
#{Tools.Tests.STxDebuggerTest.TestVar}
End of 1 object'!

serialize: anObject version: anInteger
	| stream stl |
	stl := super serialize: anObject version: anInteger.
	stream := String writeStream.
	STLPrinter printLiteralStoreArray: stl on: stream.
	^Compiler evaluate: stream contents!

stxDebuggerClass
	^STLDebugger!

testNonExistentClass
	| testClass |
	testClass := Object
				subclass: #STBTest_TestClass
				instanceVariableNames: 'a b c'
				classVariableNames: 'A B C'
				poolDictionaries: ''
				classInstanceVariableNames: ''.
	
	[| dessicated dessicatedInstance |
	dessicated := self serialize: testClass.
	dessicatedInstance := self serialize: testClass new.
	testClass removeFromSystem.
	self should: [self dump: dessicated withOffsets: false] raise: NotFoundError.
	self should: [self dump: dessicatedInstance withOffsets: false] raise: NotFoundError]
			ensure: [#{STBTest_TestClass} ifDefined: [:c | c removeFromSystem]]! !
!Tools.Tests.STLDebuggerTest categoriesForMethods!
expectedDump3!constants!private!unit tests! !
expectedDump4!constants!private! !
expectedDump5!constants!private! !
expectedDump6!constants!private! !
minimumFilerVersion!constants!private! !
outfilerClass!constants!public! !
saveStaticVariableDumpFormat!constants!private! !
serialize:version:!helpers!private! !
stxDebuggerClass!constants!public! !
testNonExistentClass!public!unit tests! !
!

