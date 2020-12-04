"Filed out from Dolphin Smalltalk 7"!

UI.AbstractToTextConverter subclass: #'UI.DateToText'
	instanceVariableNames: 'format'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.DateToText guid: (Core.GUID fromString: '{87b4c708-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.DateToText comment: 'DateToText is a <textTypeConverter> dedicated to transformations between <Date>s and text.

Instance Variables:
	locale	<Locale> to use for the conversion.
	format	<readableString> or nil, holding the format specifier (e.g. ''ddd-MMM-dd/yyyy'') for the conversion.

Class Variables:
	YearPivot	<integer> pivot point to use for two digit years.


'!
!UI.DateToText categoriesForClass!MVP-Type Converters-Text! !
!UI.DateToText methodsFor!

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
!UI.DateToText categoriesFor: #actualFormat!accessing!private! !
!UI.DateToText categoriesFor: #format!accessing!public! !
!UI.DateToText categoriesFor: #format:!accessing!public! !
!UI.DateToText categoriesFor: #leftToRight:!operations!public! !
!UI.DateToText categoriesFor: #rightToLeft:!operations!public! !

!UI.DateToText class methodsFor!

yearPivot
	"Answers the pivot point for two digit years. Years greater or equal to this will be assumed to be
	in the current century. Years less than the pivot will be assumed to be in the next century"

	^Date yearPivot!

yearPivot: anInteger
	"Sets the pivot point for two digit years to be anInteger. 
	Years greater or equal to this will be assumed to be in the current century. 
	Years less than the pivot will be assumed to be in the next century"

	Date yearPivot: anInteger! !
!UI.DateToText class categoriesFor: #yearPivot!accessing!public! !
!UI.DateToText class categoriesFor: #yearPivot:!accessing!public! !

