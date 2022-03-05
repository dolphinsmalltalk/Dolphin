"Filed out from Dolphin Smalltalk"!

AbstractToTextConverter subclass: #TimeToText
	instanceVariableNames: 'format'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TimeToText guid: (GUID fromString: '{87b4c70a-026e-11d3-9fd7-00a0cc3e4a32}')!
TimeToText comment: 'TimeToText is a <textTypeConverter> that transforms a <Time> subject value to/from a <readableString>. If the subject value is nil it is converted to an empty string and vice versa. A format string (e.g. ''hh:mm:ss tt'', see <Time>) can be specified to dictate the way the subject value is formatted when converted to text. If no explicit format is provided the default for the current user is used.

Instance Variables:
	format	<readableString> or nil, holding the format specifier (e.g. ''hh:mm:ss tt'') for the conversion.

'!
!TimeToText categoriesForClass!MVP-Type Converters-Text! !
!TimeToText methodsFor!

actualFormat
	"Private - Answers the actual date format to use for the conversion"

	^self format notNil
		ifTrue: [ self format ]
		ifFalse: [ self locale timeFormat ]!

format
	"Answers the format for the conversion. This is either a String identifying
	a Win32 specific time format (such as 'hh:mm:ss tt') or it is nil, which specifies
	the default format for the user/locale"

	^format!

format: aStringOrNil
	"Sets the format for the conversion, to aString. This is either a String identifying
	a Win32 specific time format (such as 'hh:mm:ss tt') or it is nil, which specifies
	the default format for the user/locale"

	format := aStringOrNil
!

leftToRight: aTime
	"Private - Answers the result of converting aTime to a String"

	| stream fmt |
	fmt := self actualFormat.
	stream := String writeStream: fmt size.
	aTime printOn: stream format: fmt.
	^stream grabContents!

locale
	"Private - Answer the locale to use for the receiver's conversions"

	^Locale default!

rightToLeft: aString
	"Private - Answers the result of converting aString to a Time."

	^Time fromString: aString
! !
!TimeToText categoriesForMethods!
actualFormat!accessing!private! !
format!accessing!public! !
format:!accessing!public! !
leftToRight:!operations!private! !
locale!accessing!private! !
rightToLeft:!operations!private! !
!

