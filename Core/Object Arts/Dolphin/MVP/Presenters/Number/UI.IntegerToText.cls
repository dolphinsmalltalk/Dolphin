"Filed out from Dolphin Smalltalk"!

UI.NumberToText
	subclass: #'UI.IntegerToText'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.IntegerToText guid: (Core.GUID fromString: '{87b4c70b-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.IntegerToText comment: 'IntegerToText is a <textTypeConverter> which transforms an <integer> subject value to/from a <readableString>. If the subject value is nil it is converted to an empty string and vice versa.'!

!UI.IntegerToText categoriesForClass!MVP-Type Converters-Text! !

!UI.IntegerToText methodsFor!

rightToLeft: aString
	"Answers the result of converting aStringOrNil to an Integer. If aStringOrNil is
	empty or nil then answer leftExceptionalValue to represent this"

	^Integer fromString: aString! !

!UI.IntegerToText categoriesForMethods!
rightToLeft:!operations!public! !
!

