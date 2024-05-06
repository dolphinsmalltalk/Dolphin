"Filed out from Dolphin Smalltalk"!

TypeConverter subclass: #InvertingConverter
	instanceVariableNames: 'wrappedConverter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

InvertingConverter guid: (GUID fromString: '{87b4c705-026e-11d3-9fd7-00a0cc3e4a32}')!

InvertingConverter comment: 'An InvertingConverter is a <typeConverter> used to wrap another converter to reverse the direction of conversion. Normally an InvertingConverter is not instantiated explicitly but by using the #inverted method of TypeConverter.

Example:

 NumberToText new inverted

will yield an instance of InvertingConverter that wraps a NumberToText conversion. This is then the equivalent of TextToNumber.

Instance Variables:

	wrapped	<typeConverter> being inverted.

'!

!InvertingConverter categoriesForClass!MVP-Type Converters-General! !

!InvertingConverter methodsFor!

convertFromLeftToRight: anObject
	"Converts anObject, to another type by applying the reverse of our
	wrappedConverter's left to right transformation"
	
	^self wrappedConverter convertFromRightToLeft: anObject!

convertFromRightToLeft: anObject
	"Converts anObject, to another type by applying the reverse of our
	wrappedConverter's right to left transformation"
	
	^self wrappedConverter convertFromLeftToRight: anObject!

inverted
	"Answers a type converter that reverses the direction of the receiver's conversion. 
	Since the receiver is already inverting its wrappedConverter we can merely answer that."

	^self wrappedConverter
!

wrappedConverter
	"Private - Answer the type converter that is being wrapped (and therefore inverted) by
	the receiver"

	^wrappedConverter
!

wrappedConverter: aTypeConverter
	"Private - Set the type converter that is being wrapped (and therefore inverted) by
	the receiver to aTypeConverter"

	wrappedConverter := aTypeConverter
! !

!InvertingConverter categoriesForMethods!
convertFromLeftToRight:!converting!public! !
convertFromRightToLeft:!converting!public! !
inverted!operations!public! !
wrappedConverter!accessing!private! !
wrappedConverter:!accessing!private! !
!

!InvertingConverter class methodsFor!

inverting: aTypeConverter
	"Create an instance of the receiver that wraps aTypeConverter to effectively
	reverse its direction of conversion"

	^super new wrappedConverter: aTypeConverter; yourself!

new
	"Use #inverting:"

	self shouldNotImplement! !

!InvertingConverter class categoriesForMethods!
inverting:!instance creation!public! !
new!instance creation!public! !
!

