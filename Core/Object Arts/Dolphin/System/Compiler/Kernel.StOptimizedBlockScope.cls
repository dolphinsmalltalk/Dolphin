"Filed out from Dolphin Smalltalk 7"!

StBlockScope subclass: #StOptimizedBlockScope
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StOptimizedBlockScope guid: (GUID fromString: '{c2ebf9a0-55a4-4d52-922c-923b6953482c}')!
StOptimizedBlockScope comment: ''!
!StOptimizedBlockScope categoriesForClass!Kernel-Objects! !
!StOptimizedBlockScope methodsFor!

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
!StOptimizedBlockScope categoriesFor: #hasFarReturn!accessing!public! !
!StOptimizedBlockScope categoriesFor: #markFarReturn!public!visiting! !
!StOptimizedBlockScope categoriesFor: #markNeedsSelf!public!visiting! !
!StOptimizedBlockScope categoriesFor: #needsSelf!accessing!public! !
!StOptimizedBlockScope categoriesFor: #realScope!public! !

