"Filed out from Dolphin Smalltalk 7"!

AbstractToTextConverter subclass: #BooleanToText
	instanceVariableNames: 'format'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
BooleanToText guid: (GUID fromString: '{87b4c707-026e-11d3-9fd7-00a0cc3e4a32}')!
BooleanToText comment: 'BooleanToString is a <textTypeConverter> that transforms a Boolean subject value to/from a String. If the subject value is nil it is converted to an empty String and vice versa. A format array (e.g. #(''no'' ''yes''), see Boolean) can be specified to dictate the way the subject value is formatted when converted to text. If no explicit format is provided the default is used.

Instance Variables:
	format	<Array> of <readableString> or nil, indicating the text to use for <boolean> values.

'!
!BooleanToText categoriesForClass!MVP-Type Converters-Text! !
!BooleanToText methodsFor!

actualFormat
	"Private - Answers the actual format to use for this conversion. Interprets a nil
	format as the defaultFormat"

	^self format notNil 
		ifTrue: [ self format ] 
		ifFalse: [ self defaultFormat ]!

defaultFormat
	"Private - Answers a two element array of Strings that contains the default 
	text to be used to represent true/false values as text"

	^#('false' 'true')!

errorInvalidFormat
	"Private - Raise an error that some conversion attempt failed
	because the some input was in the wrong format."

	^InvalidFormat signalWith: Boolean!

format
	"Answers the format for the conversion"

	^format!

format: aStringArray
	"Sets the format for the conversion to aStringArray. The first element holds
	the representation of false and the second element holds the representation of true"

	format := aStringArray!

leftToRight: aBoolean
	"Private - Answers the result of converting aBoolean to a String"

	^self actualFormat at: aBoolean asParameter + 1!

rightToLeft: aString
	"Private - Answers the result of converting aString to a Boolean."

	(aString sameAs: (self actualFormat at: 1)) ifTrue: [ ^false ].
	(aString sameAs: (self actualFormat at: 2)) ifTrue: [ ^true ].

	"Raise an error for no match"
	^self errorInvalidFormat


	! !
!BooleanToText categoriesFor: #actualFormat!accessing!private! !
!BooleanToText categoriesFor: #defaultFormat!constants!private! !
!BooleanToText categoriesFor: #errorInvalidFormat!exceptions!private! !
!BooleanToText categoriesFor: #format!accessing!public! !
!BooleanToText categoriesFor: #format:!accessing!public! !
!BooleanToText categoriesFor: #leftToRight:!operations!private! !
!BooleanToText categoriesFor: #rightToLeft:!operations!private! !

