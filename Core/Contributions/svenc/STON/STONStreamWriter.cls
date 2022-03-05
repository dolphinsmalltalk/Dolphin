"Filed out from Dolphin Smalltalk"!

Object subclass: #STONStreamWriter
	instanceVariableNames: 'writer first'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STONStreamWriter guid: (GUID fromString: '{6bdb0b54-8382-4d5b-b901-b52c3b1fdb07}')!
STONStreamWriter comment: 'STONStreamWriter helps in streaming writing STON representations.
This is an abstract class.'!
!STONStreamWriter categoriesForClass!STON-Core-Writer! !
!STONStreamWriter methodsFor!

initialize
	super initialize.
	first := true!

on: stonWriter
	writer := stonWriter! !
!STONStreamWriter categoriesForMethods!
initialize!initialize/release!public! !
on:!initialize/release!public! !
!

!STONStreamWriter class methodsFor!

new
	^super new initialize!

on: stonWriter
	^ self new
		on: stonWriter;
		yourself! !
!STONStreamWriter class categoriesForMethods!
new!public! !
on:!instance creation!public! !
!

