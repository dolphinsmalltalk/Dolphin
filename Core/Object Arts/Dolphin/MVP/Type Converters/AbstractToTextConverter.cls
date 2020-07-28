"Filed out from Dolphin Smalltalk 7"!

TypeConverter subclass: #AbstractToTextConverter
	instanceVariableNames: 'locale'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractToTextConverter guid: (GUID fromString: '{87b4c703-026e-11d3-9fd7-00a0cc3e4a32}')!
AbstractToTextConverter comment: 'AbstractToTextConverter is the abstract superclass all of <typeConverter>s dedicated to transformations to and from text. Hence it also conforms to the <textTypeConverter> protocol. It has subclasses specialized for common types of object such as <Number>s and <Boolean>s. 

'!
!AbstractToTextConverter categoriesForClass!MVP-Type Converters-Abstract! !
!AbstractToTextConverter methodsFor!

actualLocale
	"Private - Answers the actual locale to use for the conversion"

	^self locale ifNil: [Locale default]!

initialize
	"Private - Initialize the receiver"

	rightNullValue := String empty!

locale
	"Answer the locale to use for the receiver's conversions"

	^locale!

locale: aLocaleOrNil
	"Set the value of the receiver's instance variable locale to aLocaleOrNil"

	locale := aLocaleOrNil! !
!AbstractToTextConverter categoriesFor: #actualLocale!accessing!private! !
!AbstractToTextConverter categoriesFor: #initialize!initializing!private! !
!AbstractToTextConverter categoriesFor: #locale!accessing!public! !
!AbstractToTextConverter categoriesFor: #locale:!accessing!public! !

!AbstractToTextConverter class methodsFor!

stbConvertFrom: anSTBClassFormat
	"Convert from version 0 DateToText. Version 1 adds a locale inst var"

	^
	[:data |
	| newInstance |
	newInstance := self basicNew.
	1 to: 2 do: [:i | newInstance instVarAt: i put: (data at: i)].
	newInstance locale: Locale default.
	3 to: data size do: [:i | newInstance instVarAt: i + 1 put: (data at: i)].
	newInstance]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1! !
!AbstractToTextConverter class categoriesFor: #stbConvertFrom:!binary filing!public! !
!AbstractToTextConverter class categoriesFor: #stbVersion!binary filing!public! !

