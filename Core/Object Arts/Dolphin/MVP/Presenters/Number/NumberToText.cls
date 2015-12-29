"Filed out from Dolphin Smalltalk X6"!

AbstractToTextConverter subclass: #NumberToText
	instanceVariableNames: '_reserved1'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NumberToText guid: (GUID fromString: '{87B4C709-026E-11D3-9FD7-00A0CC3E4A32}')!
NumberToText comment: 'A NumberToString is a <textTypeConverter> that transforms a numeric subject value to a <readableString> for use by its client. If the subject value is nil it is converted to an empty string and vice versa. When converting a client string back to a subject value the most appropriate class of Number is chosen to represent the value.

Instance Variables:
	format	<readableString> or nil, reserved for future use.


'!
!NumberToText categoriesForClass!MVP-Type Converters-Text! !
!NumberToText methodsFor!

leftToRight: aNumber
	"Answers the result of converting aNumber to a String"

	#todo "Number>>displayString should use GetNumberFormat() to produce locale specific output (add to Locale class)".

	^aNumber displayString.!

rightToLeft: aString
	"Answers the result of converting aString to a Number."

	^Number fromString: aString! !
!NumberToText categoriesFor: #leftToRight:!operations!public! !
!NumberToText categoriesFor: #rightToLeft:!operations!public! !

