"Filed out from Dolphin Smalltalk"!

Smalltalk at: #VMConstants put: (PoolConstantsDictionary named: #VMConstants)!
VMConstants at: 'DoubleSize' put: 16r8!
VMConstants at: 'FloatSize' put: 16r4!
VMConstants at: 'HalfPtrBits' put: 16r10!
VMConstants at: 'HalfPtrMask' put: 16rFFFF!
VMConstants at: 'HalfPtrMax' put: 16r7FFF!
VMConstants at: 'HashBits' put: 16r1E!
VMConstants at: 'IntMax' put: 16r7FFFFFFF!
VMConstants at: 'IntPtrBits' put: 16r20!
VMConstants at: 'IntPtrMask' put: 16rFFFFFFFF!
VMConstants at: 'IntPtrMax' put: 16r7FFFFFFF!
VMConstants at: 'IntPtrSize' put: 16r4!
VMConstants at: 'IntSize' put: 16r4!
VMConstants at: 'IsWin64' put: false!
VMConstants at: 'MaxBlockNesting' put: 16rFF!
VMConstants at: 'MaxLiterals' put: 16r10000!
VMConstants at: 'MaxMessageArgs' put: 16rFF!
VMConstants at: 'MaxPrimitive' put: 16rFF!
VMConstants at: 'MaxTemps' put: 16rFF!
VMConstants at: 'MaxVirtualFunction' put: 16r400!
VMConstants at: 'SmallIntegerMax' put: 16r3FFFFFFF!
VMConstants at: 'SmallIntegerMin' put: -16r40000000!
VMConstants at: 'UIntMax' put: 16rFFFFFFFF!
VMConstants at: 'UIntPtrMax' put: 16rFFFFFFFF!
VMConstants shrink!
