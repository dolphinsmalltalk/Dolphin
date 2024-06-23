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
000870                 [CompiledMethod;][5]
000892                     [0]
000896                     [STBMetaclassProxy]
000904                         [String] 70: ''Dolphin''
000919                         [String] 71: ''PluggableSortAlgorithm''
000949                     [STBSymbolProxy]
000957                         [String] 73: ''new''
000968                     [<1p>]
000972                     [ByteArray][10] 74: #[171 100 31 177 97 105 233 1 130 106]
000990                     [STBSymbolProxy]
000998                         [String] 76: ''basicNew''
001014                     [STBSymbolProxy]
001022                         [String] 78: ''setSortBlock:''
001043                     [%<66: [] in nil>]
001047                     [STBSymbolProxy]
001055                         [String] 80: ''%<=''
001065                     [STBSymbolProxy]
001073                         [String] 82: ''yourself''
001089                 [7]
001093                 [256]
001097                 [%<0: nil>]
001101     [STBIdentityDictionaryProxy;]
001135         [STBClassProxy]
001143             [String] 86: ''Dolphin''
001158             [String] 87: ''LookupTable''
001177         [Array][4]
001185             [String] 89: ''origin''
001199             [Point;]
001212                 [10]
001216                 [20]
001220             [2]
001224             [Point]
001232                 [100]
001236                 [200]
End of 92 objects'
		<< (PluggableSortAlgorithm class >> #new) sourceDescriptor!

expectedDump1
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
000724                 [CompiledMethod;][5]
000746                     [0]
000750                     [STBMetaclassProxy]
000758                         [String] 79: ''Dolphin''
000773                         [String] 80: ''PluggableSortAlgorithm''
000803                     [STBSymbolProxy]
000811                         [String] 82: ''new''
000822                     [<1p>]
000826                     [ByteArray][10] 83: #[171 100 31 177 97 105 233 1 130 106]
000844                     [STBSymbolProxy]
000852                         [String] 85: ''basicNew''
000868                     [STBSymbolProxy]
000876                         [String] 87: ''setSortBlock:''
000897                     [%<75: [] in nil>]
000901                     [STBSymbolProxy]
000909                         [String] 89: ''%<=''
000919                     [STBSymbolProxy]
000927                         [String] 91: ''yourself''
000943                 [7]
000947                 [256]
000951                 [%<0: nil>]
000955     [STBIdentityDictionaryProxy]
000963         [%<15: LookupTable>]
000967         [Array][4]
000975             [String] 94: ''origin''
000989             [Point;]
001002                 [10]
001006                 [20]
001010             [2]
001014             [Point]
001022                 [100]
001026                 [200]
End of 86 objects'
		<< (PluggableSortAlgorithm class >> #new) sourceDescriptor!

expectedDump2
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
000700                 [CompiledMethod;][5]
000722                     [0]
000726                     [STBMetaclassProxy]
000734                         [String] 76: ''Dolphin''
000749                         [String] 77: ''PluggableSortAlgorithm''
000779                     [Symbol] 78: #new
000790                     [<1p>]
000794                     [ByteArray][10] 79: #[171 100 31 177 97 105 233 1 130 106]
000812                     [Symbol] 80: #basicNew
000828                     [Symbol] 81: #setSortBlock:
000849                     [%<72: [] in nil>]
000853                     [Symbol] 82: #%<=
000863                     [Symbol] 83: #yourself
000879                 [7]
000883                 [256]
000887                 [%<0: nil>]
000891     [STBIdentityDictionaryProxy]
000899         [%<15: LookupTable>]
000903         [Array][4]
000911             [String] 86: ''origin''
000925             [Point;]
000938                 [10]
000942                 [20]
000946             [2]
000950             [Point]
000958                 [100]
000962                 [200]
End of 78 objects'
		<< (PluggableSortAlgorithm class >> #new) sourceDescriptor!

expectedDump3
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
000652                 [CompiledMethod;][5]
000674                     [0]
000678                     [STBMetaclassProxy]
000682                         [String] 76: ''Dolphin''
000697                         [String] 77: ''PluggableSortAlgorithm''
000727                     [Symbol] 78: #new
000738                     [<1p>]
000742                     [ByteArray][10] 79: #[171 100 31 177 97 105 233 1 130 106]
000760                     [Symbol] 80: #basicNew
000776                     [Symbol] 81: #setSortBlock:
000797                     [%<72: [] in nil>]
000801                     [Symbol] 82: #%<=
000811                     [Symbol] 83: #yourself
000827                 [7]
000831                 [256]
000835                 [%<0: nil>]
000839     [STBIdentityDictionaryProxy]
000843         [%<15: LookupTable>]
000847         [Array][4]
000855             [String] 86: ''origin''
000869             [Point;]
000878                 [10]
000882                 [20]
000886             [2]
000890             [Point]
000894                 [100]
000898                 [200]
End of 78 objects' << (PluggableSortAlgorithm class >> #new) sourceDescriptor!

expectedDump4
	^'STB version 4:
000007 [Array][34]
000015     [%<0: nil>]
000019     [%<1: true>]
000023     [%<2: false>]
000027     [Symbol] 26: #testVersion0
000047     [Symbol] 27: #''†Symbol''
000064     [Utf8String] 28: ''a␀b''
000075     [AnsiString] 29: ''a␀b''
000086     [Utf8String] 30: ''a␀b''
000097     [Utf8String] 31: ''文字化け''
000117     [$a]
000121     [$\x80]
000125     [$£]
000129     [$ÿ]
000133     [$€]
000137     [$🐬]
000141     [0]
000145     [-1073741824]
000149     [LargeInteger][12] 32: 18446744073709551616
000169     [Float;][8] 34: 1.25
000190     [Float][8] 35: Float.Infinity
000206     [Float][8] 36: Float.NaN
000222     [ScaledDecimal;]
000239         [Fraction;]
000251             [5]
000255             [4]
000259         [2]
000263     [ScaledDecimal]
000267         [Fraction]
000271             [2]
000275             [3]
000279         [2]
000283     [STBClassProxy]
000287         [Utf8String] 44: ''Dolphin''
000302         [Utf8String] 45: ''Object''
000316     [STBMetaclassProxy]
000320         [Utf8String] 47: ''Dolphin''
000335         [Utf8String] 48: ''Object''
000349     [%<4: a ProcessorScheduler>]
000353     [STBSingletonProxy;]
000374         [STBClassProxy]
000378             [Utf8String] 52: ''Dolphin Transcript''
000404             [Utf8String] 53: ''TranscriptShell''
000427         [Symbol] 54: #current
000442     [%<3: Smalltalk>]
000446     [ByteArray][0] 55: #[]
000454     [ByteArray][1] 56: #[255]
000463     [ByteArray][5] 57: #[1 2 3 4 5]
000476     [STBCollectionProxy]
000480         [%<13: OrderedCollection>]
000484         [Array][3]
000492             [%<28: ''a␀b''>]
000496             [%<26: #testVersion0>]
000500             [$d]
000504     [STBSortedCollectionProxy;]
000536         [STBClassProxy]
000540             [Utf8String] 63: ''Dolphin''
000555             [Utf8String] 64: ''SortedCollection''
000579         [Array][4]
000587             [Utf8String] 66: ''a''
000596             [Utf8String] 67: ''B''
000605             [Utf8String] 68: ''b''
000614             [Utf8String] 69: ''B''
000623         [MergesortAlgorithm;]
000645             [BlockClosure;][0]
000669                 [%<0: nil>]
000673                 [CompiledMethod;][5]
000695                     [0]
000699                     [STBMetaclassProxy]
000703                         [Utf8String] 77: ''Dolphin''
000718                         [Utf8String] 78: ''PluggableSortAlgorithm''
000748                     [Symbol] 79: #new
000759                     [<1p>]
000763                     [ByteArray][10] 80: #[171 100 31 177 97 105 233 1 130 106]
000781                     [Symbol] 81: #basicNew
000797                     [Symbol] 82: #setSortBlock:
000818                     [%<73: [] in nil>]
000822                     [Symbol] 83: #%<=
000832                     [Symbol] 84: #yourself
000848                 [7]
000852                 [256]
000856                 [%<0: nil>]
000860     [STBIdentityDictionaryProxy]
000864         [%<15: LookupTable>]
000868         [Array][4]
000876             [Utf8String] 87: ''origin''
000890             [Point;]
000899                 [10]
000903                 [20]
000907             [2]
000911             [Point]
000915                 [100]
000919                 [200]
End of 81 objects'
		<< (PluggableSortAlgorithm class >> #new) sourceDescriptor!

expectedDump5
	^'STB version 5:
000007 [Core.Array][35]
000015     [%<0: nil>]
000019     [%<1: true>]
000023     [%<2: false>]
000027     [Core.Symbol] 26: #testVersion0
000047     [Core.Symbol] 27: #''†Symbol''
000064     [Core.Utf8String] 28: ''a␀b''
000075     [Core.Utf8String] 29: ''a␀b''
000086     [Core.Utf8String] 30: ''a␀b''
000097     [Core.Utf8String] 31: ''文字化け''
000117     [$a]
000121     [$\x80]
000125     [$£]
000129     [$ÿ]
000133     [$€]
000137     [$🐬]
000141     [0]
000145     [-1073741824]
000149     [Core.LargeInteger][12] 32: 18446744073709551616
000169     [Core.Float;][8] 34: 1.25
000195     [Core.Float][8] 35: Float.Infinity
000211     [Core.Float][8] 36: Float.NaN
000227     [Core.ScaledDecimal;]
000249         [Core.Fraction;]
000266             [5]
000270             [4]
000274         [2]
000278     [Core.ScaledDecimal]
000282         [Core.Fraction]
000286             [2]
000290             [3]
000294         [2]
000298     [Kernel.STBClassProxy]
000302         [Core.Utf8String] 44: ''Dolphin''
000317         [Core.Utf8String] 45: ''Core.Object''
000336     [Kernel.STBMetaclassProxy]
000340         [Core.Utf8String] 47: ''Dolphin''
000355         [%<45: ''Core.Object''>]
000359     [%<4: a ProcessorScheduler>]
000363     [Kernel.STBSingletonProxy;]
000391         [Kernel.STBClassProxy]
000395             [Core.Utf8String] 51: ''Dolphin Transcript''
000421             [Core.Utf8String] 52: ''UI.TranscriptShell''
000447         [Core.Symbol] 53: #current
000462     [%<3: Smalltalk>]
000466     [Core.ByteArray][0] 54: #[]
000474     [Core.ByteArray][1] 55: #[255]
000483     [Core.ByteArray][5] 56: #[1 2 3 4 5]
000496     [Kernel.STBCollectionProxy]
000500         [%<13: OrderedCollection>]
000504         [Core.Array][3]
000512             [%<28: ''a␀b''>]
000516             [%<26: #testVersion0>]
000520             [$d]
000524     [Kernel.STBSortedCollectionProxy;]
000563         [Kernel.STBClassProxy]
000567             [Core.Utf8String] 62: ''Dolphin''
000582             [Core.Utf8String] 63: ''Core.SortedCollection''
000611         [Core.Array][4]
000619             [Core.Utf8String] 65: ''a''
000628             [Core.Utf8String] 66: ''B''
000637             [Core.Utf8String] 67: ''b''
000646             [Core.Utf8String] 68: ''B''
000655         [Kernel.MergesortAlgorithm;]
000684             [Kernel.BlockClosure;][0]
000715                 [%<0: nil>]
000719                 [Kernel.CompiledMethod;][5]
000748                     [0]
000752                     [Kernel.STBMetaclassProxy]
000756                         [Core.Utf8String] 76: ''Dolphin''
000771                         [Core.Utf8String] 77: ''Kernel.PluggableSortAlgorithm''
000808                     [Core.Symbol] 78: #new
000819                     [<1p>]
000823                     [Core.ByteArray][10] 79: #[171 100 31 177 97 105 233 1 130 106]
000841                     [Core.Symbol] 80: #basicNew
000857                     [Core.Symbol] 81: #setSortBlock:
000878                     [%<72: [] in nil>]
000882                     [Core.Symbol] 82: #%<=
000892                     [Core.Symbol] 83: #yourself
000908                 [7]
000912                 [256]
000916                 [%<0: nil>]
000920     [Kernel.STBIdentityDictionaryProxy]
000924         [%<15: LookupTable>]
000928         [Core.Array][4]
000936             [Core.Utf8String] 86: ''origin''
000950             [Graphics.Point;]
000968                 [10]
000972                 [20]
000976             [2]
000980             [Graphics.Point]
000984                 [100]
000988                 [200]
000992     [Kernel.FullBindingReference;]
001027         [Core.Utf8String] 92: ''Core.Object''
001046         [Core.Array][2]
001054             [Core.Utf8String] 94: ''Core''
001066             [Core.Utf8String] 95: ''Object''
001080         [%<2: false>]
001084         [%<0: nil>]
001088         [%<0: nil>]
End of 85 objects'  << (PluggableSortAlgorithm class >> #new) sourceDescriptor!

expectedDump6
	^'STB version 6:
000007 [Core.Array][35]
000015     [%<0: nil>]
000019     [%<1: true>]
000023     [%<2: false>]
000027     [Core.Symbol] 26: #testVersion0
000047     [Core.Symbol] 27: #''†Symbol''
000064     [Core.Utf8String] 28: ''a␀b''
000075     [Core.Utf8String] 29: ''a␀b''
000086     [Core.Utf8String] 30: ''a␀b''
000097     [Core.Utf8String] 31: ''文字化け''
000117     [$a]
000121     [$\x80]
000125     [$£]
000129     [$ÿ]
000133     [$€]
000137     [$🐬]
000141     [0]
000145     [-1073741824]
000149     [Core.LargeInteger][12] 32: 18446744073709551616
000169     [Core.Float;][8] 34: 1.25
000195     [Core.Float][8] 35: Float.Infinity
000211     [Core.Float][8] 36: Float.NaN
000227     [Core.ScaledDecimal;]
000249         [Core.Fraction;]
000266             [5]
000270             [4]
000274         [2]
000278     [Core.ScaledDecimal]
000282         [Core.Fraction]
000286             [2]
000290             [3]
000294         [2]
000298     [Kernel.STBClassProxy]
000302         [Core.Utf8String] 44: ''Dolphin''
000317         [Core.Utf8String] 45: ''Core.Object''
000336     [Kernel.STBMetaclassProxy]
000340         [Core.Utf8String] 47: ''Dolphin''
000355         [%<45: ''Core.Object''>]
000359     [%<4: a ProcessorScheduler>]
000363     [Kernel.STBStaticVariableProxy;]
000396         [Kernel.FullBindingReference;]
000431             [Core.Utf8String] 52: ''Core.Transcript''
000454             [Core.Array][2]
000462                 [Core.Utf8String] 54: ''Core''
000474                 [Core.Utf8String] 55: ''Transcript''
000492             [%<2: false>]
000496             [%<0: nil>]
000500             [%<0: nil>]
000504     [%<3: Smalltalk>]
000508     [Core.ByteArray][0] 56: #[]
000516     [Core.ByteArray][1] 57: #[255]
000525     [Core.ByteArray][5] 58: #[1 2 3 4 5]
000538     [Core.OrderedCollection][3]
000546         [%<28: ''a␀b''>]
000550         [%<26: #testVersion0>]
000554         [$d]
000558     [Kernel.STBSortedCollectionProxy;]
000597         [Kernel.STBClassProxy]
000601             [Core.Utf8String] 63: ''Dolphin''
000616             [Core.Utf8String] 64: ''Core.SortedCollection''
000645         [Core.Array][4]
000653             [Core.Utf8String] 66: ''a''
000662             [Core.Utf8String] 67: ''B''
000671             [Core.Utf8String] 68: ''b''
000680             [Core.Utf8String] 69: ''B''
000689         [Kernel.MergesortAlgorithm;]
000718             [Kernel.BlockClosure;][0]
000749                 [%<0: nil>]
000753                 [Kernel.CompiledMethod;][5]
000782                     [0]
000786                     [Kernel.STBMetaclassProxy]
000790                         [Core.Utf8String] 77: ''Dolphin''
000805                         [Core.Utf8String] 78: ''Kernel.PluggableSortAlgorithm''
000842                     [Core.Symbol] 79: #new
000853                     [<1p>]
000857                     [Core.ByteArray][10] 80: #[171 100 31 177 97 105 233 1 130 106]
000875                     [Core.Symbol] 81: #basicNew
000891                     [Core.Symbol] 82: #setSortBlock:
000912                     [%<73: [] in nil>]
000916                     [Core.Symbol] 83: #%<=
000926                     [Core.Symbol] 84: #yourself
000942                 [7]
000946                 [256]
000950                 [%<0: nil>]
000954     [Core.LookupTable][2]
000962         [Core.Utf8String] 86: ''origin''
000976         [Graphics.Point;]
000994             [10]
000998             [20]
001002         [2]
001006         [Graphics.Point]
001010             [100]
001014             [200]
001018     [Kernel.FullBindingReference]
001022         [Core.Utf8String] 91: ''Core.Object''
001041         [Core.Array][2]
001049             [Core.Utf8String] 93: ''Core''
001061             [Core.Utf8String] 94: ''Object''
001075         [%<2: false>]
001079         [%<0: nil>]
001083         [%<0: nil>]
End of 84 objects' << (PluggableSortAlgorithm class >> #new) sourceDescriptor!

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
	| dump dessicated stringWithNull |
	stringWithNull := #($a $\0 $b) asString.
	dessicated := self serialize: {
						nil.
						true.
						false.
						#testVersion0.
						#'†Symbol'.
						stringWithNull.
						stringWithNull asUtf16String.
						$a.
						Character value: 128.
						Character value: 163.
						Character value: 255.
						$€.
						0.
						SmallInteger minimum.
						2 ** 64.
						1.25.
						Float infinity.
						Float nan.
						1.25s.
						2 / 3 asScaledDecimal: 2.
						Object.
						Object class.
						Processor.
						Transcript.
						Smalltalk.
						#[].
						#[255].
						#[1 2 3 4 5].
						{ stringWithNull. #testVersion0. $d } asOrderedCollection.
						#('a' 'B' 'b' 'B') asSortedCollectionUsing: MergesortAlgorithm new.
						LookupTable with: 'origin' -> (10 @ 20) with: 2 -> (100 @ 200)
					}
				version: 0.
	dump := self dump: dessicated withOffsets: true.
	self assert: dump equals: self expectedDump0!

testVersion1
	| dump dessicated stringWithNull |
	stringWithNull := #($a $\0 $b) asString.
	dessicated := self serialize: {
						nil.
						true.
						false.
						#testVersion0.
						#'†Symbol'.
						stringWithNull.
						stringWithNull asUtf16String.
						$a.
						Character value: 128.
						Character value: 163.
						Character value: 255.
						$€.
						0.
						SmallInteger minimum.
						2 ** 64.
						1.25.
						Float infinity.
						Float nan.
						1.25s.
						2 / 3 asScaledDecimal: 2.
						Object.
						Object class.
						Processor.
						Transcript.
						Smalltalk.
						#[].
						#[255].
						#[1 2 3 4 5].
						{ stringWithNull. #testVersion0. $d } asOrderedCollection.
						#('a' 'B' 'b' 'B') asSortedCollectionUsing: MergesortAlgorithm new.
						LookupTable with: 'origin' -> (10 @ 20) with: 2 -> (100 @ 200)
					}
				version: 1.
	dump := self dump: dessicated withOffsets: true.
	self assert: dump equals: self expectedDump1!

testVersion2
	| dump dessicated stringWithNull |
	stringWithNull := #($a $\0 $b) asString.
	dessicated := self serialize: {
						nil.
						true.
						false.
						#testVersion0.
						#'†Symbol'.
						stringWithNull.
						stringWithNull asUtf16String.
						$a.
						Character value: 128.
						Character value: 163.
						Character value: 255.
						$€.
						0.
						SmallInteger minimum.
						2 ** 64.
						1.25.
						Float infinity.
						Float nan.
						1.25s.
						2 / 3 asScaledDecimal: 2.
						Object.
						Object class.
						Processor.
						Transcript.
						Smalltalk.
						#[].
						#[255].
						#[1 2 3 4 5].
						{ stringWithNull. #testVersion0. $d } asOrderedCollection.
						#('a' 'B' 'b' 'B') asSortedCollectionUsing: MergesortAlgorithm new.
						LookupTable with: 'origin' -> (10 @ 20) with: 2 -> (100 @ 200)
					}
				version: 2.
	dump := self dump: dessicated withOffsets: true.
	self assert: dump equals: self expectedDump2! !

!Tools.Tests.STBDebuggerTest categoriesForMethods!
dumpForNonExistentClass!constants!private! !
expectedDump0!constants!private! !
expectedDump1!constants!private! !
expectedDump2!constants!private! !
expectedDump3!constants!private!unit tests! !
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

