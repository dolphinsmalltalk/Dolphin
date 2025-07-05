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
	| sortBlockMethod |
	sortBlockMethod := SortedCollection class >> #defaultSortBlock.
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
000120                     <2p>
000121                     [STBMetaclassProxy]
000122                         69: ''Dolphin''
000124                         70: ''SortedCollection''
000126                     71: #defaultSortBlock
000128                     <1p>
000129                     72: #[29 105 233 1 130 106]
000131                     [%<65: [] in nil>]
000132                     73: #%<=
000134                 3
000135                 256
000136                 [%<0: nil>]
000137     [STBIdentityDictionaryProxy]
000138         [%<15: LookupTable>]
000139         [Array]
000141             76: ''origin''
000143             [Point]
000145                 10
000146                 20
000147             2
000148             [Point]
000149                 100
000150                 200
End of 69 objects'  
		<< { sortBlockMethod sourceDescriptor. sortBlockMethod header }!

expectedDump4
	| sortBlockMethod |
	sortBlockMethod := SortedCollection class >> #defaultSortBlock.
	^'STL version 4:
000002 [Array]
000004     nil
000005     true
000006     false
000007     #testVersion0
000008     #''†Symbol''
000009     26: ''a''
000011     27: ''a''
000013     $a
000014     $\x80
000015     $£
000016     $ÿ
000017     $€
000018     0
000019     -1073741824
000020     28: 18446744073709551616
000022     [Float] 30: 1.25
000033     [Float] 31: Float.Infinity
000043     [Float] 32: Float.NaN
000053     [ScaledDecimal]
000055         [Fraction]
000057             5
000058             4
000059         2
000060     [ScaledDecimal]
000061         [Fraction]
000062             2
000063             3
000064         2
000065     Object
000066     [STBMetaclassProxy]
000067         40: ''Dolphin''
000069         41: ''Object''
000071     a ProcessorScheduler
000072     [STBSingletonProxy]
000074         TranscriptShell
000075         #current
000076     Smalltalk
000077     44: #[]
000079     45: #[255]
000081     46: #[1 2 3 4 5]
000083     [STBCollectionProxy]
000084         [%<9: OrderedCollection>]
000085         [Array]
000087             [%<26: ''a''>]
000088             #testVersion0
000089             $d
000090     [STBSortedCollectionProxy]
000093         SortedCollection
000094         [Array]
000096             52: ''a''
000098             53: ''B''
000100             54: ''b''
000102             55: ''B''
000104         [MergesortAlgorithm]
000106             [BlockClosure]
000110                 nil
000111                 [CompiledMethod]
000114                     <2p>
000115                     [STBMetaclassProxy]
000116                         63: ''Dolphin''
000118                         64: ''SortedCollection''
000120                     #defaultSortBlock
000121                     <1p>
000122                     65: #[29 105 233 1 130 106]
000124                     [%<59: [] in nil>]
000125                     #%<=
000126                 3
000127                 256
000128                 nil
000129     [STBIdentityDictionaryProxy]
000130         [%<11: LookupTable>]
000131         [Array]
000133             68: ''origin''
000135             [Point]
000137                 10
000138                 20
000139             2
000140             [Point]
000141                 100
000142                 200
000143     72: ''a''
000145     73: ''文字化け''
000147     $🐬
End of 80 objects'
		<< { sortBlockMethod sourceDescriptor. sortBlockMethod header }!

expectedDump5
	| sortBlockMethod |
	sortBlockMethod := SortedCollection class >> #defaultSortBlock.
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
000013     $a
000014     $\x80
000015     $£
000016     $ÿ
000017     $€
000018     0
000019     -1073741824
000020     28: 18446744073709551616
000022     29: 1.25
000024     [Float] 31: Float.Infinity
000035     [Float] 32: Float.NaN
000045     33: 1.25s
000047     [ScaledDecimal]
000049         [Fraction]
000051             2
000052             3
000053         2
000054     #{Core.Object}
000055     #{Core.Object class}
000056     #{Core.Processor}
000057     [STBSingletonProxy]
000059         #{UI.TranscriptShell}
000060         #current
000061     #{Smalltalk}
000062     40: #[]
000064     41: #[255]
000066     42: #[1 2 3 4 5]
000068     [STBCollectionProxy]
000069         [%<9: OrderedCollection>]
000070         [Array]
000072             [%<26: ''a␀b''>]
000073             #testVersion0
000074             $d
000075     [STBSortedCollectionProxy]
000078         #{Core.SortedCollection}
000079         [Array]
000081             48: ''a''
000083             49: ''B''
000085             50: ''b''
000087             51: ''B''
000089         [MergesortAlgorithm]
000091             [BlockClosure]
000095                 nil
000096                 [CompiledMethod]
000099                     <2p>
000100                     #{Core.SortedCollection class}
000101                     #defaultSortBlock
000102                     <1p>
000103                     58: #[29 105 233 1 130 106]
000105                     [%<55: [] in nil>]
000106                     #%<=
000107                 3
000108                 256
000109                 nil
000110     [STBIdentityDictionaryProxy]
000111         [%<11: LookupTable>]
000112         [Array]
000114             61: ''origin''
000116             [Point]
000118                 10
000119                 20
000120             2
000121             [Point]
000122                 100
000123                 200
000124     [Utf8String]
000125         #[97 0 98] 65: ''a␀b''
000126     66: ''文字化け''
000128     $🐬
000129     67: #{Core.Object}
End of 76 objects'
		<< { sortBlockMethod sourceDescriptor. sortBlockMethod header }!

expectedDump6
	| sortBlockMethod |
	sortBlockMethod := SortedCollection class >> #defaultSortBlock.
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
000016     $a
000017     6: $\x80
000019     $£
000020     $ÿ
000021     $€
000022     0
000023     -1073741824
000024     7: 18446744073709551616
000026     8: 1.25
000028     #{Float.Infinity}
000029     #{Float.NaN}
000030     9: 1.25s
000032     [ScaledDecimal]
000034         [Fraction]
000036             2
000037             3
000038         2
000039     #{Core.Object}
000040     #{Core.Object class}
000041     #{Core.Processor}
000042     #{Core.Transcript}
000043     #{Smalltalk}
000044     14: #[]
000046     15: #[255]
000048     16: #[1 2 3 4 5]
000050     [OrderedCollection]
000053         [%<4: ''a␀b''>]
000054         #testVersion0
000055         $d
000056     [STBSortedCollectionProxy]
000059         #{Core.SortedCollection}
000060         [Array]
000062             22: ''a''
000064             23: ''B''
000066             24: ''b''
000068             25: ''B''
000070         [MergesortAlgorithm]
000072             [BlockClosure]
000076                 nil
000077                 [CompiledMethod]
000080                     <2p>
000081                     #{Core.SortedCollection class}
000082                     #defaultSortBlock
000083                     <1p>
000084                     32: #[29 105 233 1 130 106]
000086                     [%<29: [] in nil>]
000087                     #%<=
000088                 3
000089                 256
000090                 nil
000091     [LookupTable]
000094         2
000095         [Point]
000097             100
000098             200
000099         37: ''origin''
000101         [Point]
000102             10
000103             20
000104     [Utf8String]
000105         #[97 0 98] 39: ''a␀b''
000106     40: ''文字化け''
000108     41: $🐬
000110     42: #{Core.Object}
End of 72 objects'
		<< { sortBlockMethod sourceDescriptor. sortBlockMethod header }!

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

