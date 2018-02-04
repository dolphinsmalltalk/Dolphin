"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ThreadWorker
	instanceVariableNames: 'block expires value lock error'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ThreadWorker guid: (GUID fromString: '{5a199ca7-beb5-4182-87ba-abdc6e3de57a}')!
ThreadWorker comment: ''!
!ThreadWorker categoriesForClass!Kernel-Objects! !
!ThreadWorker methodsFor!

block: anObject
	block := anObject!

error
	^error!

evaluate
	TimeStamp current < expires
		ifTrue: [value := block value].
	lock signal!

expires: anObject
	expires := anObject!

hasValue
	^lock excessSignals > 0!

initialize
	super initialize.
	lock := Semaphore new!

value
	lock excessSignals > 0 ifFalse: [lock wait].
	^value! !
!ThreadWorker categoriesFor: #block:!accessing!private! !
!ThreadWorker categoriesFor: #error!accessing!private! !
!ThreadWorker categoriesFor: #evaluate!public! !
!ThreadWorker categoriesFor: #expires:!accessing!private! !
!ThreadWorker categoriesFor: #hasValue!public! !
!ThreadWorker categoriesFor: #initialize!private! !
!ThreadWorker categoriesFor: #value!public! !

!ThreadWorker class methodsFor!

new
	^self shouldNotImplement!

on: aBlock
	^self
		on: aBlock expires: (TimeStamp current addSeconds: 60);
		yourself!

on: aBlock expires: aTime
	^self basicNew initialize
		block: aBlock;
		expires: aTime;
		yourself! !
!ThreadWorker class categoriesFor: #new!public! !
!ThreadWorker class categoriesFor: #on:!public! !
!ThreadWorker class categoriesFor: #on:expires:!public! !

