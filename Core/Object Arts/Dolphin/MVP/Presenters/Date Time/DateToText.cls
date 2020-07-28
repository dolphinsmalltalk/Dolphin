"Filed out from Dolphin Smalltalk 7"!

AbstractToTextConverter subclass: #DateToText
	instanceVariableNames: 'format'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DateToText guid: (GUID fromString: '{87b4c708-026e-11d3-9fd7-00a0cc3e4a32}')!
DateToText comment: 'DateToText is a <textTypeConverter> dedicated to transformations between <Date>s and text.

Instance Variables:
	locale	<Locale> to use for the conversion.
	format	<readableString> or nil, holding the format specifier (e.g. ''ddd-MMM-dd/yyyy'') for the conversion.

Class Variables:
	YearPivot	<integer> pivot point to use for two digit years.


'!
!DateToText categoriesForClass!MVP-Type Converters-Text! !
!DateToText methodsFor!

actualFormat
	"Private - Answers the actual date format to use for the conversion"

	^self format ifNil: [self actualLocale dateFormat]!

format
	"Answers the format for the conversion. This is either a String identifying
	a Win32 specific date format (such as 'dd MMM yyyy') or it is nil, which specifies
	the default format for the user/locale"

	^format!

format: aStringOrNil
	"Sets the format for the conversion, to aString. This is either a String identifying
	a Win32 specific date format (such as 'dd MMM yyyy') or it is nil, which specifies
	the default format for the user/locale"

	format := aStringOrNil!

leftToRight: aDate
	"Answers the result of converting aDate to a String"

	| stream fmt |
	fmt := self actualFormat.
	stream := String writeStream: fmt size.
	stream locale: self actualLocale.
	aDate printOn: stream format: fmt.
	^stream grabContents!

rightToLeft: aString
	"Answers the result of converting aString to a Date"
	
	^Date fromString: aString format: self actualFormat! !
!DateToText categoriesFor: #actualFormat!accessing!private! !
!DateToText categoriesFor: #format!accessing!public! !
!DateToText categoriesFor: #format:!accessing!public! !
!DateToText categoriesFor: #leftToRight:!operations!public! !
!DateToText categoriesFor: #rightToLeft:!operations!public! !

!DateToText class methodsFor!

yearPivot
	"Answers the pivot point for two digit years. Years greater or equal to this will be assumed to be
	in the current century. Years less than the pivot will be assumed to be in the next century"

	^Date yearPivot!

yearPivot: anInteger
	"Sets the pivot point for two digit years to be anInteger. 
	Years greater or equal to this will be assumed to be in the current century. 
	Years less than the pivot will be assumed to be in the next century"

	Date yearPivot: anInteger! !
!DateToText class categoriesFor: #yearPivot!accessing!public! !
!DateToText class categoriesFor: #yearPivot:!accessing!public! !

