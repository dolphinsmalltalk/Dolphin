!Core.SearchPolicy class methodsFor!

newCompareBlock: discriminator hashBlock: hasher
	^PluggableSearchPolicy basicNew compareBlock: discriminator hashBlock: hasher! !
| var |
var := ByteCodeDispatcher classPool associationAt: 'FirstShowSpecialSend'.
ByteCodeDispatcher classPool removeKey: 'FirstShowSpecialSend'.
var setKey: 'FirstShortSpecialSend'.
ByteCodeDispatcher classPool add: var!

