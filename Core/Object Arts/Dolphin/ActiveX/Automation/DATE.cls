"Filed out from Dolphin Smalltalk X6"!

DOUBLE subclass: #DATE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'AXAutomationConstants'
	classInstanceVariableNames: ''!
DATE guid: (GUID fromString: '{C06F3B6D-0868-11D3-93AF-00A024CA708A}')!
DATE comment: ''!
!DATE categoriesForClass!External-Data-Structured! !
!DATE methodsFor!

asDate
	^self asTimeStamp date!

asTimeStamp
	"Answer a <TimeStamp> converted from the receiver's Active-X
	Automation date (an 8-byte floating point day number and fraction of a day)."

	^self value!

value
	"Answer a <TimeStamp> converted from the receiver's Active-X
	Automation date (an 8-byte floating point day number and fraction of a day)."

	^TimeStamp fromDATE: super value! !
!DATE categoriesFor: #asDate!converting!public! !
!DATE categoriesFor: #asTimeStamp!accessing!public! !
!DATE categoriesFor: #value!accessing!public! !

!DATE class methodsFor!

fromString: aString
	^self fromString: aString locale: Locale userDefault!

fromString: aString locale: aLocale
	| answer |
	answer := self new.
	OLEAutLibrary default
		varDateFromStr: aString asUnicodeString lcid: aLocale asParameter dwFlags: 0 pdateOut: answer.
	^answer
	

!

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
!DATE class categoriesFor: #fromString:!instance creation!public! !
!DATE class categoriesFor: #fromString:locale:!instance creation!public! !
!DATE class categoriesFor: #icon!constants!public! !
!DATE class categoriesFor: #initialize!development!initializing!private! !
!DATE class categoriesFor: #maximum!constants!public! !
!DATE class categoriesFor: #minimum!constants!public! !
!DATE class categoriesFor: #now!instance creation!public! !
!DATE class categoriesFor: #typeName!constants!private! !
!DATE class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!DATE class categoriesFor: #vt!constants!public! !

