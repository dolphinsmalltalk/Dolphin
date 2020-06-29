"Filed out from Dolphin Smalltalk 7"!

#{_InstanceBehaviorMasks} declare: (PoolConstantsDictionary named: #_InstanceBehaviorMasks)!
_InstanceBehaviorMasks at: '_FinalizeMask' put: 16r8!
_InstanceBehaviorMasks at: '_GetSpecialMask' put: 16rFF00!
_InstanceBehaviorMasks at: '_PointersMask' put: 16r2!
_InstanceBehaviorMasks at: '_WeakMask' put: 16r12!
_InstanceBehaviorMasks shrink!
