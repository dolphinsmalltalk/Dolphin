"Filed out from Dolphin Smalltalk 7"!

UI.AbstractToTextConverter subclass: #'UI.BooleanToText'
	instanceVariableNames: 'format'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.BooleanToText guid: (Core.GUID fromString: '{87b4c707-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.BooleanToText comment: 'BooleanToString is a <textTypeConverter> that transforms a Boolean subject value to/from a String. If the subject value is nil it is converted to an empty String and vice versa. A format array (e.g. #(''no'' ''yes''), see Boolean) can be specified to dictate the way the subject value is formatted when converted to text. If no explicit format is provided the default is used.

Instance Variables:
	format	<Array> of <readableString> or nil, indicating the text to use for <boolean> values.

'!
!UI.BooleanToText categoriesForClass!MVP-Type Converters-Text! !
!UI.BooleanToText methodsFor!

actualFormat
	"Private - Answers the actual format to use for this conversion. If unspecified, use the default format for the <Locale>."

	^self format ifNil: [self actualLocale boolFormat]!

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

	| strings |
	strings := self actualFormat.
	(aString sameAs: (strings at: 1)) ifTrue: [^false].
	(aString sameAs: (strings at: 2)) ifTrue: [^true].

	"Raise an error for no match"
	^self errorInvalidFormat! !
!UI.BooleanToText categoriesFor: #actualFormat!accessing!private! !
!UI.BooleanToText categoriesFor: #errorInvalidFormat!exceptions!private! !
!UI.BooleanToText categoriesFor: #format!accessing!public! !
!UI.BooleanToText categoriesFor: #format:!accessing!public! !
!UI.BooleanToText categoriesFor: #leftToRight:!operations!private! !
!UI.BooleanToText categoriesFor: #rightToLeft:!operations!private! !

