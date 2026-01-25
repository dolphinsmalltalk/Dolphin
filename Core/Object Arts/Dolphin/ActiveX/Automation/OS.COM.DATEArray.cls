"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'OS.COM.DATEArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.DATEArray guid: (Core.GUID fromString: '{1ab09263-e480-45e1-82d9-0bfacb1170ae}')!

OS.COM.DATEArray comment: '`DATEArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of OLE Automate `DATE`s.

`DATE` represents moments in time using a double-precision floating point number where the integer part is a day number offset from 30th December 1899, and the fractional part represents the time of day as a fraction of 86400 (the number of seconds in a day). The time fraction is always considered positive, even if the day number is negative.'!

!OS.COM.DATEArray methodsFor!

uncheckedAt: anInteger
	^DateAndTime fromDATE: (bytes doubleAtOffset: (anInteger - 1) * DOUBLE._DOUBLE_Size)!

uncheckedAt: anInteger put: aDateAndTime
	bytes doubleAtOffset: (anInteger - 1) * DOUBLE._DOUBLE_Size put: aDateAndTime asFloat.
	^aDateAndTime! !

!OS.COM.DATEArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!OS.COM.DATEArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^DATE! !

!OS.COM.DATEArray class categoriesForMethods!
elementClass!constants!public! !
!

