﻿"Filed out from Dolphin Smalltalk"!

DOUBLE subclass: #DATE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'AXAutomationConstants'
	classInstanceVariableNames: ''!
DATE guid: (GUID fromString: '{c06f3b6d-0868-11d3-93af-00a024ca708a}')!
DATE comment: ''!
!DATE categoriesForClass!External-Data-Structured! !
!DATE methodsFor!

asDateAndTime
	"Answer a <DateAndTime> converted from the receiver's Active-X Automation date (an 8-byte floating point day number and fraction of a day), which is assumed to in the local time."

	^self value!

value
	"Answer a <TimeStamp> converted from the receiver's Active-X
	Automation date (an 8-byte floating point day number and fraction of a day)."

	^DateAndTime fromSYSTEMTIME: (SYSTEMTIME fromDATE: super value)! !
!DATE categoriesForMethods!
asDateAndTime!accessing!public! !
value!accessing!public! !
!

!DATE class methodsFor!

fromString: aString
	"
		self fromString: '3 February 1995'.
	"
	^self fromString: aString locale: Locale userDefault!

fromString: aString locale: aLocale
	| answer |
	answer := self new.
	OLEAutLibrary default
		varDateFromStr: aString
		lcid: aLocale asParameter
		dwFlags: 0
		pdateOut: answer.
	^answer!

icon
	"Answer a suitable iconic representation for the receiver."

	^Date icon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

maximum
	^(self new)
		value: 2958465.999999999;
		yourself!

minimum
	^(self new)
		value: -657434.9999999999;
		yourself!

now
	"Answer the current date and time as an instance of the receiver."

	^SYSTEMTIME now asFloat
	!

typeName
	"Private - Answer the Dolphin external type name for the receiver.
	There is an appropriate built-in type which we can substitute."

	^#date!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil!

vt
	"Answer the VARTYPE (one of the VT_XXX constants) used to describe the receiver's 
	type when represented in a <VARIANT>."

	^VT_DATE! !
!DATE class categoriesForMethods!
fromString:!instance creation!public! !
fromString:locale:!instance creation!public! !
icon!constants!public! !
initialize!development!initializing!private! !
maximum!constants!public! !
minimum!constants!public! !
now!instance creation!public! !
typeName!constants!private! !
uninitialize!class hierarchy-removing!private! !
vt!constants!public! !
!
