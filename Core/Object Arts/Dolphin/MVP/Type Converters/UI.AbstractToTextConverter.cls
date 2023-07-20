"Filed out from Dolphin Smalltalk"!

UI.TypeConverter
	subclass: #'UI.AbstractToTextConverter'
	instanceVariableNames: 'locale'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.AbstractToTextConverter guid: (Core.GUID fromString: '{87b4c703-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.AbstractToTextConverter comment: 'AbstractToTextConverter is the abstract superclass of all <typeConverter>s dedicated to transformations to and from text. Hence it also conforms to the <textTypeConverter> protocol. It has subclasses specialized for common types of objects such as <Number>s and <Boolean>s. 

'!
!UI.AbstractToTextConverter categoriesForClass!MVP-Type Converters-Abstract! !
!UI.AbstractToTextConverter methodsFor!

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
!UI.AbstractToTextConverter categoriesForMethods!
actualLocale!accessing!private! !
initialize!initializing!private! !
locale!accessing!public! !
locale:!accessing!public! !
!

!UI.AbstractToTextConverter class methodsFor!

stbConvertFrom: anSTBClassFormat
	"Convert from version 0 DateToText. Version 1 adds a locale inst var"

	anSTBClassFormat version == 0
		ifTrue: 
			[^
			[:data |
			(Array new: self instSize)
				at: 1 put: (data at: 1);
				at: 2 put: (data at: 2);
				at: 3 put: Locale default;
				replaceFrom: 4
					to: 4 + data size - 3
					with: data
					startingAt: 3;
				becomeA: self]].
	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1! !
!UI.AbstractToTextConverter class categoriesForMethods!
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
!

