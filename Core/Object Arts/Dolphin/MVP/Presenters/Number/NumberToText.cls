"Filed out from Dolphin Smalltalk 7"!

AbstractToTextConverter subclass: #NumberToText
	instanceVariableNames: '_reserved1'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
NumberToText guid: (GUID fromString: '{87b4c709-026e-11d3-9fd7-00a0cc3e4a32}')!
NumberToText comment: 'A NumberToString is a <textTypeConverter> that transforms a numeric subject value to a <readableString> for use by its client. If the subject value is nil it is converted to an empty string and vice versa. When converting a client string back to a subject value the most appropriate class of Number is chosen to represent the value.

Instance Variables:
	format	<readableString> or nil, reserved for future use.


'!
!NumberToText categoriesForClass!MVP-Type Converters-Text! !
!NumberToText methodsFor!

leftToRight: aNumber
	"Answers the result of converting aNumber to a String"

	#todo.	"Numbers should be displayed through the Locale, but at present the rightToLeft operation is only implemented for Smalltalk format."
	^aNumber displayString!

rightToLeft: aString
	"Answers the result of converting aString to a Number."

	^Number fromString: aString! !
!NumberToText categoriesFor: #leftToRight:!operations!public! !
!NumberToText categoriesFor: #rightToLeft:!operations!public! !

