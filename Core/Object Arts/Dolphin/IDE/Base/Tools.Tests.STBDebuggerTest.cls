"Filed out from Dolphin Smalltalk"!

Tools.Tests.STxDebuggerTest
	subclass: #'Tools.Tests.STBDebuggerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Tests.STBDebuggerTest guid: (Core.GUID fromString: '{ff809f44-4ea6-461b-a9e7-77597a99be16}')!

Tools.Tests.STBDebuggerTest comment: ''!

!Tools.Tests.STBDebuggerTest methodsFor!

dumpForNonExistentClass
	^'STB version 6:
000007 [Kernel.STBClassProxy]
000011     [Core.Utf8String] 26: ''nil''
000022     [Core.Utf8String] 27: ''Smalltalk.STBTest_TestClass''
End of 3 object(s)'!

expectedDump0
	| sortBlockMethod |
	sortBlockMethod := SortedCollection class >> #defaultSortBlock.
	^'STB version 0:
000007 [Array;][31]
000020     [%<0: nil>]
000024     [%<1: true>]
000028     [%<2: false>]
000032     [STBSymbolProxy;]
000054         [String;0] 10: ''testVersion0''
000080     [STBSymbolProxy]
000088         [String] 12: ''†Symbol''
000103     [String] 13: ''a␀b''
000114     [UnicodeString;0] 15: ''a␀b''
000141     [$a]
000145     [$€]
000149     [$£]
000153     [$ÿ]
000157     [$€]
000161     [0]
000165     [-1073741824]
000169     [LargeInteger;][12] 17: 18446744073709551616
000201     [Float;][8] 19: 1.25
000222     [Float][8] 20: Float.Infinity
000238     [Float][8] 21: Float.NaN
000254     [ScaledDecimal;]
000275         [Fraction;]
000291             [5]
000295             [4]
000299         [2]
000303     [ScaledDecimal]
000311         [Fraction]
000319             [2]
000323             [3]
000327         [2]
000331     [STBClassProxy;]
000356         [String] 30: ''Dolphin''
000371         [String] 31: ''Object''
000385     [STBMetaclassProxy;]
000414         [String] 34: ''Dolphin''
000429         [String] 35: ''Object''
000443     [%<4: a ProcessorScheduler>]
000447     [STBSingletonProxy;]
000472         [STBClassProxy]
000480             [String] 39: ''Dolphin Transcript''
000506             [String] 40: ''TranscriptShell''
000529         [STBSymbolProxy]
000537             [String] 42: ''current''
000552     [%<3: Smalltalk>]
000556     [ByteArray;][0] 44: #[]
000573     [ByteArray][1] 45: #[255]
000582     [ByteArray][5] 46: #[1 2 3 4 5]
000595     [STBCollectionProxy;]
000621         [STBClassProxy]
000629             [String] 50: ''Dolphin''
000644             [String] 51: ''OrderedCollection''
000669         [Array][3]
000677             [%<13: ''a␀b''>]
000681             [%<8: #testVersion0>]
000685             [$d]
000689     [STBSortedCollectionProxy;]
000725         [STBClassProxy]
000733             [String] 56: ''Dolphin''
000748             [String] 57: ''SortedCollection''
000772         [Array][4]
000780             [String] 59: ''a''
000789             [String] 60: ''B''
000798             [String] 61: ''b''
000807             [String] 62: ''B''
000816         [MergesortAlgorithm;]
000842             [BlockClosure;][0]
000866                 [%<0: nil>]
000870                 [CompiledMethod;][2]
000892                     [<2p>]
000896                     [STBMetaclassProxy]
000904                         [String] 70: ''Dolphin''
000919                         [String] 71: ''SortedCollection''
000943                     [STBSymbolProxy]
000951                         [String] 73: ''defaultSortBlock''
000975                     [<1p>]
000979                     [ByteArray][6] 74: #[29 105 233 1 130 106]
000993                     [%<66: [] in nil>]
000997                     [STBSymbolProxy]
001005                         [String] 76: ''%<=''
001015                 [3]
001019                 [256]
001023                 [%<0: nil>]
001027     [STBIdentityDictionaryProxy;]
001061         [STBClassProxy]
001069             [String] 80: ''Dolphin''
001084             [String] 81: ''LookupTable''
001103         [Array][4]
001111             [String] 83: ''origin''
001125             [Point;]
001138                 [10]
001142                 [20]
001146             [2]
001150             [Point]
001158                 [100]
001162                 [200]
End of 86 objects'
		<< { sortBlockMethod sourceDescriptor. sortBlockMethod header }!

expectedDump1
	| sortBlockMethod |
	sortBlockMethod := SortedCollection class >> #defaultSortBlock.
	^'STB version 1:
000007 [Array][31]
000015     [%<0: nil>]
000019     [%<1: true>]
000023     [%<2: false>]
000027     [STBSymbolProxy]
000035         [String] 27: ''testVersion0''
000055     [STBSymbolProxy]
000063         [String] 29: ''†Symbol''
000078     [String] 30: ''a␀b''
000089     [UnicodeString;0] 32: ''a␀b''
000116     [$a]
000120     [$€]
000124     [$£]
000128     [$ÿ]
000132     [$€]
000136     [0]
000140     [-1073741824]
000144     [LargeInteger][12] 33: 18446744073709551616
000164     [Float;][8] 35: 1.25
000185     [Float][8] 36: Float.Infinity
000201     [Float][8] 37: Float.NaN
000217     [ScaledDecimal;]
000238         [Fraction;]
000254             [5]
000258             [4]
000262         [2]
000266     [ScaledDecimal]
000274         [Fraction]
000282             [2]
000286             [3]
000290         [2]
000294     [STBClassProxy]
000302         [String] 45: ''Dolphin''
000317         [String] 46: ''Object''
000331     [STBMetaclassProxy]
000339         [String] 48: ''Dolphin''
000354         [String] 49: ''Object''
000368     [%<4: a ProcessorScheduler>]
000372     [STBSingletonProxy;]
000397         [STBClassProxy]
000405             [String] 53: ''Dolphin Transcript''
000431             [String] 54: ''TranscriptShell''
000454         [STBSymbolProxy]
000462             [String] 56: ''current''
000477     [%<3: Smalltalk>]
000481     [ByteArray][0] 57: #[]
000489     [ByteArray][1] 58: #[255]
000498     [ByteArray][5] 59: #[1 2 3 4 5]
000511     [STBCollectionProxy]
000519         [%<13: OrderedCollection>]
000523         [Array][3]
000531             [%<30: ''a␀b''>]
000535             [%<26: #testVersion0>]
000539             [$d]
000543     [STBSortedCollectionProxy;]
000579         [STBClassProxy]
000587             [String] 65: ''Dolphin''
000602             [String] 66: ''SortedCollection''
000626         [Array][4]
000634             [String] 68: ''a''
000643             [String] 69: ''B''
000652             [String] 70: ''b''
000661             [String] 71: ''B''
000670         [MergesortAlgorithm;]
000696             [BlockClosure;][0]
000720                 [%<0: nil>]
000724                 [CompiledMethod;][2]
000746                     [<2p>]
000750                     [STBMetaclassProxy]
000758                         [String] 79: ''Dolphin''
000773                         [String] 80: ''SortedCollection''
000797                     [STBSymbolProxy]
000805                         [String] 82: ''defaultSortBlock''
000829                     [<1p>]
000833                     [ByteArray][6] 83: #[29 105 233 1 130 106]
000847                     [%<75: [] in nil>]
000851                     [STBSymbolProxy]
000859                         [String] 85: ''%<=''
000869                 [3]
000873                 [256]
000877                 [%<0: nil>]
000881     [STBIdentityDictionaryProxy]
000889         [%<15: LookupTable>]
000893         [Array][4]
000901             [String] 88: ''origin''
000915             [Point;]
000928                 [10]
000932                 [20]
000936             [2]
000940             [Point]
000948                 [100]
000952                 [200]
End of 80 objects'
		<< { sortBlockMethod sourceDescriptor. sortBlockMethod header }!

expectedDump2
	| sortBlockMethod |
	sortBlockMethod := SortedCollection class >> #defaultSortBlock.
	^'STB version 2:
000007 [Array][31]
000015     [%<0: nil>]
000019     [%<1: true>]
000023     [%<2: false>]
000027     [Symbol] 26: #testVersion0
000047     [Symbol] 27: #''†Symbol''
000062     [String] 28: ''a␀b''
000073     [UnicodeString;0] 30: ''a␀b''
000100     [$a]
000104     [$€]
000108     [$£]
000112     [$ÿ]
000116     [$€]
000120     [0]
000124     [-1073741824]
000128     [LargeInteger][12] 31: 18446744073709551616
000148     [Float;][8] 33: 1.25
000169     [Float][8] 34: Float.Infinity
000185     [Float][8] 35: Float.NaN
000201     [ScaledDecimal;]
000222         [Fraction;]
000238             [5]
000242             [4]
000246         [2]
000250     [ScaledDecimal]
000258         [Fraction]
000266             [2]
000270             [3]
000274         [2]
000278     [STBClassProxy]
000286         [String] 43: ''Dolphin''
000301         [String] 44: ''Object''
000315     [STBMetaclassProxy]
000323         [String] 46: ''Dolphin''
000338         [String] 47: ''Object''
000352     [%<4: a ProcessorScheduler>]
000356     [STBSingletonProxy;]
000381         [STBClassProxy]
000389             [String] 51: ''Dolphin Transcript''
000415             [String] 52: ''TranscriptShell''
000438         [Symbol] 53: #current
000453     [%<3: Smalltalk>]
000457     [ByteArray][0] 54: #[]
000465     [ByteArray][1] 55: #[255]
000474     [ByteArray][5] 56: #[1 2 3 4 5]
000487     [STBCollectionProxy]
000495         [%<13: OrderedCollection>]
000499         [Array][3]
000507             [%<28: ''a␀b''>]
000511             [%<26: #testVersion0>]
000515             [$d]
000519     [STBSortedCollectionProxy;]
000555         [STBClassProxy]
000563             [String] 62: ''Dolphin''
000578             [String] 63: ''SortedCollection''
000602         [Array][4]
000610             [String] 65: ''a''
000619             [String] 66: ''B''
000628             [String] 67: ''b''
000637             [String] 68: ''B''
000646         [MergesortAlgorithm;]
000672             [BlockClosure;][0]
000696                 [%<0: nil>]
000700                 [CompiledMethod;][2]
000722                     [<2p>]
000726                     [STBMetaclassProxy]
000734                         [String] 76: ''Dolphin''
000749                         [String] 77: ''SortedCollection''
000773                     [Symbol] 78: #defaultSortBlock
000797                     [<1p>]
000801                     [ByteArray][6] 79: #[29 105 233 1 130 106]
000815                     [%<72: [] in nil>]
000819                     [Symbol] 80: #%<=
000829                 [3]
000833                 [256]
000837                 [%<0: nil>]
000841     [STBIdentityDictionaryProxy]
000849         [%<15: LookupTable>]
000853         [Array][4]
000861             [String] 83: ''origin''
000875             [Point;]
000888                 [10]
000892                 [20]
000896             [2]
000900             [Point]
000908                 [100]
000912                 [200]
End of 75 objects'
		<< { sortBlockMethod sourceDescriptor. sortBlockMethod header }!

expectedDump3
	| sortBlockMethod |
	sortBlockMethod := SortedCollection class >> #defaultSortBlock.
	^'STB version 3:
000007 [Array][31]
000015     [%<0: nil>]
000019     [%<1: true>]
000023     [%<2: false>]
000027     [Symbol] 26: #testVersion0
000047     [Symbol] 27: #''†Symbol''
000062     [String] 28: ''a␀b''
000073     [UnicodeString;0] 30: ''a␀b''
000100     [$a]
000104     [$€]
000108     [$£]
000112     [$ÿ]
000116     [$€]
000120     [0]
000124     [-1073741824]
000128     [LargeInteger][12] 31: 18446744073709551616
000148     [Float;][8] 33: 1.25
000169     [Float][8] 34: Float.Infinity
000185     [Float][8] 35: Float.NaN
000201     [ScaledDecimal;]
000218         [Fraction;]
000230             [5]
000234             [4]
000238         [2]
000242     [ScaledDecimal]
000246         [Fraction]
000250             [2]
000254             [3]
000258         [2]
000262     [STBClassProxy]
000266         [String] 43: ''Dolphin''
000281         [String] 44: ''Object''
000295     [STBMetaclassProxy]
000299         [String] 46: ''Dolphin''
000314         [String] 47: ''Object''
000328     [%<4: a ProcessorScheduler>]
000332     [STBSingletonProxy;]
000353         [STBClassProxy]
000357             [String] 51: ''Dolphin Transcript''
000383             [String] 52: ''TranscriptShell''
000406         [Symbol] 53: #current
000421     [%<3: Smalltalk>]
000425     [ByteArray][0] 54: #[]
000433     [ByteArray][1] 55: #[255]
000442     [ByteArray][5] 56: #[1 2 3 4 5]
000455     [STBCollectionProxy]
000459         [%<13: OrderedCollection>]
000463         [Array][3]
000471             [%<28: ''a␀b''>]
000475             [%<26: #testVersion0>]
000479             [$d]
000483     [STBSortedCollectionProxy;]
000515         [STBClassProxy]
000519             [String] 62: ''Dolphin''
000534             [String] 63: ''SortedCollection''
000558         [Array][4]
000566             [String] 65: ''a''
000575             [String] 66: ''B''
000584             [String] 67: ''b''
000593             [String] 68: ''B''
000602         [MergesortAlgorithm;]
000624             [BlockClosure;][0]
000648                 [%<0: nil>]
000652                 [CompiledMethod;][2]
000674                     [<2p>]
000678                     [STBMetaclassProxy]
000682                         [String] 76: ''Dolphin''
000697                         [String] 77: ''SortedCollection''
000721                     [Symbol] 78: #defaultSortBlock
000745                     [<1p>]
000749                     [ByteArray][6] 79: #[29 105 233 1 130 106]
000763                     [%<72: [] in nil>]
000767                     [Symbol] 80: #%<=
000777                 [3]
000781                 [256]
000785                 [%<0: nil>]
000789     [STBIdentityDictionaryProxy]
000793         [%<15: LookupTable>]
000797         [Array][4]
000805             [String] 83: ''origin''
000819             [Point;]
000828                 [10]
000832                 [20]
000836             [2]
000840             [Point]
000844                 [100]
000848                 [200]
End of 75 objects'
		<< { sortBlockMethod sourceDescriptor. sortBlockMethod header }!

expectedDump4
	| sortBlockMethod |
	sortBlockMethod := SortedCollection class >> #defaultSortBlock.
	^'STB version 4:
000007 [Array][34]
000015     [%<0: nil>]
000019     [%<1: true>]
000023     [%<2: false>]
000027     [Symbol] 26: #testVersion0
000047     [Symbol] 27: #''†Symbol''
000064     [Utf8String] 28: ''a␀b''
000075     [Utf8String] 29: ''a␀b''
000086     [$a]
000090     [$\x80]
000094     [$£]
000098     [$ÿ]
000102     [$€]
000106     [0]
000110     [-1073741824]
000114     [LargeInteger][12] 30: 18446744073709551616
000134     [Float;][8] 32: 1.25
000155     [Float][8] 33: Float.Infinity
000171     [Float][8] 34: Float.NaN
000187     [ScaledDecimal;]
000204         [Fraction;]
000216             [5]
000220             [4]
000224         [2]
000228     [ScaledDecimal]
000232         [Fraction]
000236             [2]
000240             [3]
000244         [2]
000248     [STBClassProxy]
000252         [Utf8String] 42: ''Dolphin''
000267         [Utf8String] 43: ''Object''
000281     [STBMetaclassProxy]
000285         [Utf8String] 45: ''Dolphin''
000300         [Utf8String] 46: ''Object''
000314     [%<4: a ProcessorScheduler>]
000318     [STBSingletonProxy;]
000339         [STBClassProxy]
000343             [Utf8String] 50: ''Dolphin Transcript''
000369             [Utf8String] 51: ''TranscriptShell''
000392         [Symbol] 52: #current
000407     [%<3: Smalltalk>]
000411     [ByteArray][0] 53: #[]
000419     [ByteArray][1] 54: #[255]
000428     [ByteArray][5] 55: #[1 2 3 4 5]
000441     [STBCollectionProxy]
000445         [%<13: OrderedCollection>]
000449         [Array][3]
000457             [%<28: ''a␀b''>]
000461             [%<26: #testVersion0>]
000465             [$d]
000469     [STBSortedCollectionProxy;]
000501         [STBClassProxy]
000505             [Utf8String] 61: ''Dolphin''
000520             [Utf8String] 62: ''SortedCollection''
000544         [Array][4]
000552             [Utf8String] 64: ''a''
000561             [Utf8String] 65: ''B''
000570             [Utf8String] 66: ''b''
000579             [Utf8String] 67: ''B''
000588         [MergesortAlgorithm;]
000610             [BlockClosure;][0]
000634                 [%<0: nil>]
000638                 [CompiledMethod;][2]
000660                     [<2p>]
000664                     [STBMetaclassProxy]
000668                         [Utf8String] 75: ''Dolphin''
000683                         [Utf8String] 76: ''SortedCollection''
000707                     [Symbol] 77: #defaultSortBlock
000731                     [<1p>]
000735                     [ByteArray][6] 78: #[29 105 233 1 130 106]
000749                     [%<71: [] in nil>]
000753                     [Symbol] 79: #%<=
000763                 [3]
000767                 [256]
000771                 [%<0: nil>]
000775     [STBIdentityDictionaryProxy]
000779         [%<15: LookupTable>]
000783         [Array][4]
000791             [Utf8String] 82: ''origin''
000805             [Point;]
000814                 [10]
000818                 [20]
000822             [2]
000826             [Point]
000830                 [100]
000834                 [200]
000838     [AnsiString] 86: ''a␀b''
000849     [Utf8String] 87: ''文字化け''
000869     [$🐬]
End of 78 objects'
		<< { sortBlockMethod sourceDescriptor. sortBlockMethod header}!

expectedDump5
	| sortBlockMethod |
	sortBlockMethod := SortedCollection class >> #defaultSortBlock.
	^'STB version 5:
000007 [Core.Array][35]
000015     [%<0: nil>]
000019     [%<1: true>]
000023     [%<2: false>]
000027     [Core.Symbol] 26: #testVersion0
000047     [Core.Symbol] 27: #''†Symbol''
000064     [Core.Utf8String] 28: ''a␀b''
000075     [Core.Utf8String] 29: ''a␀b''
000086     [$a]
000090     [$\x80]
000094     [$£]
000098     [$ÿ]
000102     [$€]
000106     [0]
000110     [-1073741824]
000114     [Core.LargeInteger][12] 30: 18446744073709551616
000134     [Core.Float;][8] 32: 1.25
000160     [Core.Float][8] 33: Float.Infinity
000176     [Core.Float][8] 34: Float.NaN
000192     [Core.ScaledDecimal;]
000214         [Core.Fraction;]
000231             [5]
000235             [4]
000239         [2]
000243     [Core.ScaledDecimal]
000247         [Core.Fraction]
000251             [2]
000255             [3]
000259         [2]
000263     [Kernel.STBClassProxy]
000267         [Core.Utf8String] 42: ''Dolphin''
000282         [Core.Utf8String] 43: ''Core.Object''
000301     [Kernel.STBMetaclassProxy]
000305         [Core.Utf8String] 45: ''Dolphin''
000320         [%<43: ''Core.Object''>]
000324     [%<4: a ProcessorScheduler>]
000328     [Kernel.STBSingletonProxy;]
000356         [Kernel.STBClassProxy]
000360             [Core.Utf8String] 49: ''Dolphin Transcript''
000386             [Core.Utf8String] 50: ''UI.TranscriptShell''
000412         [Core.Symbol] 51: #current
000427     [%<3: Smalltalk>]
000431     [Core.ByteArray][0] 52: #[]
000439     [Core.ByteArray][1] 53: #[255]
000448     [Core.ByteArray][5] 54: #[1 2 3 4 5]
000461     [Kernel.STBCollectionProxy]
000465         [%<13: OrderedCollection>]
000469         [Core.Array][3]
000477             [%<28: ''a␀b''>]
000481             [%<26: #testVersion0>]
000485             [$d]
000489     [Kernel.STBSortedCollectionProxy;]
000528         [Kernel.STBClassProxy]
000532             [Core.Utf8String] 60: ''Dolphin''
000547             [Core.Utf8String] 61: ''Core.SortedCollection''
000576         [Core.Array][4]
000584             [Core.Utf8String] 63: ''a''
000593             [Core.Utf8String] 64: ''B''
000602             [Core.Utf8String] 65: ''b''
000611             [Core.Utf8String] 66: ''B''
000620         [Kernel.MergesortAlgorithm;]
000649             [Kernel.BlockClosure;][0]
000680                 [%<0: nil>]
000684                 [Kernel.CompiledMethod;][2]
000713                     [<2p>]
000717                     [Kernel.STBMetaclassProxy]
000721                         [Core.Utf8String] 74: ''Dolphin''
000736                         [%<61: ''Core.SortedCollection''>]
000740                     [Core.Symbol] 75: #defaultSortBlock
000764                     [<1p>]
000768                     [Core.ByteArray][6] 76: #[29 105 233 1 130 106]
000782                     [%<70: [] in nil>]
000786                     [Core.Symbol] 77: #%<=
000796                 [3]
000800                 [256]
000804                 [%<0: nil>]
000808     [Kernel.STBIdentityDictionaryProxy]
000812         [%<15: LookupTable>]
000816         [Core.Array][4]
000824             [Core.Utf8String] 80: ''origin''
000838             [Graphics.Point;]
000856                 [10]
000860                 [20]
000864             [2]
000868             [Graphics.Point]
000872                 [100]
000876                 [200]
000880     [Core.Utf8String] 84: ''a␀b''
000891     [Core.Utf8String] 85: ''文字化け''
000911     [$🐬]
000915     [Kernel.FullBindingReference;]
000950         [Core.Utf8String] 88: ''Core.Object''
000969         [Core.Array][2]
000977             [Core.Utf8String] 90: ''Core''
000989             [Core.Utf8String] 91: ''Object''
001003         [%<2: false>]
001007         [%<0: nil>]
001011         [%<0: nil>]
End of 81 objects' << { sortBlockMethod sourceDescriptor. sortBlockMethod header}!

expectedDump6
	| sortBlockMethod |
	sortBlockMethod := SortedCollection class >> #defaultSortBlock.
	^'STB version 6:
000007 [Core.Array][35]
000015     [%<0: nil>]
000019     [%<1: true>]
000023     [%<2: false>]
000027     [Core.Symbol] 26: #testVersion0
000047     [Core.Symbol] 27: #''†Symbol''
000064     [Core.Utf8String] 28: ''a␀b''
000075     [Core.Utf8String] 29: ''a␀b''
000086     [$a]
000090     [$\x80]
000094     [$£]
000098     [$ÿ]
000102     [$€]
000106     [0]
000110     [-1073741824]
000114     [Core.LargeInteger][12] 30: 18446744073709551616
000134     [Core.Float;][8] 32: 1.25
000160     [Core.Float][8] 33: Float.Infinity
000176     [Core.Float][8] 34: Float.NaN
000192     [Core.ScaledDecimal;]
000214         [Core.Fraction;]
000231             [5]
000235             [4]
000239         [2]
000243     [Core.ScaledDecimal]
000247         [Core.Fraction]
000251             [2]
000255             [3]
000259         [2]
000263     [Kernel.STBClassProxy]
000267         [Core.Utf8String] 42: ''Dolphin''
000282         [Core.Utf8String] 43: ''Core.Object''
000301     [Kernel.STBMetaclassProxy]
000305         [Core.Utf8String] 45: ''Dolphin''
000320         [%<43: ''Core.Object''>]
000324     [%<4: a ProcessorScheduler>]
000328     [Kernel.STBStaticVariableProxy;]
000361         [Kernel.FullBindingReference;]
000396             [Core.Utf8String] 50: ''Core.Transcript''
000419             [Core.Array][2]
000427                 [Core.Utf8String] 52: ''Core''
000439                 [Core.Utf8String] 53: ''Transcript''
000457             [%<2: false>]
000461             [%<0: nil>]
000465             [%<0: nil>]
000469     [%<3: Smalltalk>]
000473     [Core.ByteArray][0] 54: #[]
000481     [Core.ByteArray][1] 55: #[255]
000490     [Core.ByteArray][5] 56: #[1 2 3 4 5]
000503     [Core.OrderedCollection][3]
000511         [%<28: ''a␀b''>]
000515         [%<26: #testVersion0>]
000519         [$d]
000523     [Kernel.STBSortedCollectionProxy;]
000562         [Kernel.STBClassProxy]
000566             [Core.Utf8String] 61: ''Dolphin''
000581             [Core.Utf8String] 62: ''Core.SortedCollection''
000610         [Core.Array][4]
000618             [Core.Utf8String] 64: ''a''
000627             [Core.Utf8String] 65: ''B''
000636             [Core.Utf8String] 66: ''b''
000645             [Core.Utf8String] 67: ''B''
000654         [Kernel.MergesortAlgorithm;]
000683             [Kernel.BlockClosure;][0]
000714                 [%<0: nil>]
000718                 [Kernel.CompiledMethod;][2]
000747                     [<2p>]
000751                     [Kernel.STBMetaclassProxy]
000755                         [Core.Utf8String] 75: ''Dolphin''
000770                         [%<62: ''Core.SortedCollection''>]
000774                     [Core.Symbol] 76: #defaultSortBlock
000798                     [<1p>]
000802                     [Core.ByteArray][6] 77: #[29 105 233 1 130 106]
000816                     [%<71: [] in nil>]
000820                     [Core.Symbol] 78: #%<=
000830                 [3]
000834                 [256]
000838                 [%<0: nil>]
000842     [Core.LookupTable][2]
000850         [Core.Utf8String] 80: ''origin''
000864         [Graphics.Point;]
000882             [10]
000886             [20]
000890         [2]
000894         [Graphics.Point]
000898             [100]
000902             [200]
000906     [Core.Utf8String] 84: ''a␀b''
000917     [Core.Utf8String] 85: ''文字化け''
000937     [$🐬]
000941     [Kernel.FullBindingReference]
000945         [Core.Utf8String] 87: ''Core.Object''
000964         [Core.Array][2]
000972             [Core.Utf8String] 89: ''Core''
000984             [Core.Utf8String] 90: ''Object''
000998         [%<2: false>]
001002         [%<0: nil>]
001006         [%<0: nil>]
End of 80 objects'
		<< { sortBlockMethod sourceDescriptor. sortBlockMethod header }!

minimumFilerVersion
	^0!

outfilerClass
	^STBOutFiler!

saveStaticVariableDumpFormat
	^'STB version <1d>:
[Kernel.STBStaticVariableProxy;]
    [Kernel.FullBindingReference;]
        [%<0: nil>]
        [Core.Array][4]
            [Core.Symbol] 30: #Tools
            [Core.Symbol] 31: #Tests
            [Core.Symbol] 32: #STxDebuggerTest
            [Core.Utf8String] 33: ''TestVar''
        [%<2: false>]
        [%<0: nil>]
        [%<0: nil>]
End of 7 objects'!

stxDebuggerClass
	^STBDebugger!

testNonExistentClass
	| testClass |
	testClass := Object
				subclass: #STBTest_TestClass
				instanceVariableNames: 'a b c'
				classVariableNames: 'A B C'
				poolDictionaries: ''
				classInstanceVariableNames: ''.
	
	[| dessicated dessicatedInstance dump |
	dessicated := self serialize: testClass.
	dessicatedInstance := self serialize: testClass new.
	testClass removeFromSystem.
	dump := self dump: dessicated withOffsets: true.
	self assert: dump
		equals: 'STB version 6:
000007 [Kernel.STBClassProxy]
000011     [Core.Utf8String] 26: ''nil''
000022     [Core.Utf8String] 27: ''Smalltalk.STBTest_TestClass''
End of 3 objects'.
	self should: [self dump: dessicatedInstance withOffsets: true] raise: NotFoundError]
			ensure: [#{STBTest_TestClass} ifDefined: [:c | c removeFromSystem]]!

testVersion0
	| dump dessicated |
	dessicated := self serialize: self objectsToSerializeVersion0 version: 0.
	dump := self dump: dessicated withOffsets: true.
	self assert: dump equals: self expectedDump0!

testVersion1
	| dump dessicated |
	dessicated := self serialize: self objectsToSerializeVersion0 version: 1.
	dump := self dump: dessicated withOffsets: true.
	self assert: dump equals: self expectedDump1!

testVersion2
	| dump dessicated |
	dessicated := self serialize: self objectsToSerializeVersion0 version: 2.
	dump := self dump: dessicated withOffsets: true.
	self assert: dump equals: self expectedDump2! !

!Tools.Tests.STBDebuggerTest categoriesForMethods!
dumpForNonExistentClass!constants!private! !
expectedDump0!constants!private! !
expectedDump1!constants!private! !
expectedDump2!constants!private! !
expectedDump3!constants!private! !
expectedDump4!constants!private! !
expectedDump5!constants!private! !
expectedDump6!constants!private! !
minimumFilerVersion!constants!private! !
outfilerClass!constants!public! !
saveStaticVariableDumpFormat!constants!private! !
stxDebuggerClass!constants!public! !
testNonExistentClass!public!unit tests! !
testVersion0!public!unit tests! !
testVersion1!public!unit tests! !
testVersion2!public!unit tests! !
!

