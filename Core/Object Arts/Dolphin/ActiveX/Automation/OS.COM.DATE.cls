"Filed out from Dolphin Smalltalk 7"!

External.DOUBLE subclass: #'OS.COM.DATE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.DATE guid: (Core.GUID fromString: '{c06f3b6d-0868-11d3-93af-00a024ca708a}')!
OS.COM.DATE comment: ''!
!OS.COM.DATE categoriesForClass!External-Data-Structured! !
!OS.COM.DATE methodsFor!

asDateAndTime
	"Answer a <DateAndTime> converted from the receiver's Active-X Automation date (an 8-byte floating point day number and fraction of a day), which is assumed to in the local time."

	^self value!

value
	"Answer a <TimeStamp> converted from the receiver's Active-X
	Automation date (an 8-byte floating point day number and fraction of a day)."

	^DateAndTime fromSYSTEMTIME: (SYSTEMTIME fromDATE: super value)! !
!OS.COM.DATE categoriesFor: #asDateAndTime!accessing!public! !
!OS.COM.DATE categoriesFor: #value!accessing!public! !

!OS.COM.DATE class methodsFor!

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

	^SYSTEMTIME now asFloat!

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
!OS.COM.DATE class categoriesFor: #fromString:!instance creation!public! !
!OS.COM.DATE class categoriesFor: #fromString:locale:!instance creation!public! !
!OS.COM.DATE class categoriesFor: #icon!constants!public! !
!OS.COM.DATE class categoriesFor: #initialize!development!initializing!private! !
!OS.COM.DATE class categoriesFor: #maximum!constants!public! !
!OS.COM.DATE class categoriesFor: #minimum!constants!public! !
!OS.COM.DATE class categoriesFor: #now!instance creation!public! !
!OS.COM.DATE class categoriesFor: #typeName!constants!private! !
!OS.COM.DATE class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!OS.COM.DATE class categoriesFor: #vt!constants!public! !

