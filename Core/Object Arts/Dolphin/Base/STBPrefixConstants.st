"Filed out from Dolphin Smalltalk X6"!

Smalltalk at: #STBPrefixConstants put: (PoolConstantsDictionary named: #STBPrefixConstants)!
STBPrefixConstants at: 'BytesMask' put: 16r10!
STBPrefixConstants at: 'CharacterMask' put: 16r4!
STBPrefixConstants at: 'ClassPrefixMask' put: 16r4!
STBPrefixConstants at: 'DataPrefixMask' put: 16r2!
STBPrefixConstants at: 'IndexShift' put: -16r4!
STBPrefixConstants at: 'InstSizeMask' put: 16rFF!
STBPrefixConstants at: 'InstSizeShift' put: -16r8!
STBPrefixConstants at: 'LiteralPrefixMask' put: 16r8!
STBPrefixConstants at: 'LocatorLenShift' put: -16r10!
STBPrefixConstants at: 'NonZeroVersionMask' put: 16r40!
STBPrefixConstants at: 'ProxyMask' put: 16r8!
STBPrefixConstants at: 'SmallIntegerMask' put: 16r1!
STBPrefixConstants at: 'SmallIntegerShift' put: -16r1!
STBPrefixConstants at: 'VariableMask' put: 16r20!
STBPrefixConstants shrink!
