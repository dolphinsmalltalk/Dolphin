"Filed out from Dolphin Smalltalk"!

Kernel.StBlockScope
	subclass: #'Kernel.StOptimizedBlockScope'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.StOptimizedBlockScope guid: (Core.GUID fromString: '{c2ebf9a0-55a4-4d52-922c-923b6953482c}')!

Kernel.StOptimizedBlockScope comment: ''!

!Kernel.StOptimizedBlockScope categoriesForClass!Kernel-Objects! !

!Kernel.StOptimizedBlockScope methodsFor!

hasFarReturn
	^self realScope hasFarReturn!

markFarReturn
	self realScope markFarReturn!

markNeedsSelf
	self realScope markNeedsSelf!

needsSelf
	^self realScope needsSelf!

realScope
	"Answer the nearest real (non-optimized) scope. If the scope is itself unoptimized, then
	this will be the receiver. The actual scope is the scope in which any variables declared in
	the receiver will actually be allocated."

	^self outer realScope! !

!Kernel.StOptimizedBlockScope categoriesForMethods!
hasFarReturn!accessing!public! !
markFarReturn!public!visiting! !
markNeedsSelf!public!visiting! !
needsSelf!accessing!public! !
realScope!accessing!public! !
!

