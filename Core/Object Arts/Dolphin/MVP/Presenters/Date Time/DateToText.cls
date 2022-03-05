"Filed out from Dolphin Smalltalk"!

AbstractToTextConverter subclass: #DateToText
	instanceVariableNames: 'locale format'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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

	^self format notNil
		ifTrue: [ self format ]
		ifFalse: [ self actualLocale dateFormat ]!

actualLocale
	"Private - Answers the actual locale to use for the conversion"

	^self locale notNil
		ifTrue: [ self locale ]
		ifFalse: [ Locale default ]!

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
	self actualLocale
		printDate: aDate
		on: stream
		format: fmt.
	^stream grabContents!

locale
	"Answer the locale to use for the receiver's conversions"

	^locale!

locale: aLocaleOrNil
	"Set the value of the receiver's instance variable locale to aLocaleOrNil"

	locale := aLocaleOrNil!

rightToLeft: aString
	"Answers the result of converting aString to a Date"
	
	^Date fromString: aString format: self actualFormat! !
!DateToText categoriesForMethods!
actualFormat!accessing!private! !
actualLocale!accessing!private! !
format!accessing!public! !
format:!accessing!public! !
leftToRight:!operations!public! !
locale!accessing!public! !
locale:!accessing!public! !
rightToLeft:!operations!public! !
!

!DateToText class methodsFor!

stbConvertFrom: anSTBClassFormat 
	"Convert from version 0 Bitmap. Version 1 adds a locale inst var"

	^
	[:data | 
	| newInstance |
	newInstance := self basicNew.
	1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
	newInstance locale: Locale default.
	newInstance]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1!

yearPivot
	"Answers the pivot point for two digit years. Years greater or equal to this will be assumed to be
	in the current century. Years less than the pivot will be assumed to be in the next century"

	^Date yearPivot!

yearPivot: anInteger
	"Sets the pivot point for two digit years to be anInteger. 
	Years greater or equal to this will be assumed to be in the current century. 
	Years less than the pivot will be assumed to be in the next century"

	Date yearPivot: anInteger! !
!DateToText class categoriesForMethods!
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
yearPivot!accessing!public! !
yearPivot:!accessing!public! !
!

