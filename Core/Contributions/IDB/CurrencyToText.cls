"Filed out from Dolphin Smalltalk X6"!

AbstractToTextConverter subclass: #CurrencyToText
	instanceVariableNames: 'integerLength fractionLength zeroFillInteger commas integerOnly currencySymbol signBeforeCurrency'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CurrencyToText guid: (GUID fromString: '{7B6234B0-AB7C-404B-8DD8-64797CC519BB}')!
CurrencyToText comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!CurrencyToText categoriesForClass!IDB Goodies!MVP-Type Converters-Text! !
!CurrencyToText methodsFor!

addCommasTo: aStream 
	"Private - Replace the contents of aStream with the original contents but with 
	commas added in the appropriate places"

	| groups |
	groups := OrderedCollection new.
	aStream reset.
	[aStream atEnd] whileFalse: [groups add: (aStream nextAvailable: 3)].
	aStream reset.
	(1 to: groups size - 1) do: 
			[:index | 
			aStream nextPutAll: (groups at: index).
			(groups at: index) last isDigit & (groups at: index + 1) first isDigit 
				ifTrue: [aStream nextPut: $,]].
	aStream nextPutAll: groups last!

commas
	"Add commas to the integer part"

	commas isNil ifTrue: [^self defaultCommas].
	^commas!

commas: aBoolean 
	"Add commas to the integer part"

	commas := aBoolean!

currencySymbol
	"The <readableString> used for the currency"

	currencySymbol isNil ifTrue: [^self defaultCurrencySymbol].
	^currencySymbol!

currencySymbol: aString 
	"The <readableString> used for the currency"

	currencySymbol := aString!

defaultCommas
	"True if commas should be added to the integer part"

	^true!

defaultCurrencySymbol
	"The <readableString> giving the currency symbol to use"

	^Locale default currency!

defaultFractionLength
	"The default mimimum length after the dp, padded with zeros if needed"

	^2!

defaultIntegerLength
	"The default mimimum length before the dp"

	^1!

defaultSignBeforeCurrency
	"True if the sign comes before the currenct symbol(s)"

	^false!

defaultZeroFillInteger
	"True if extra space to the left of the dp should be zero filled"

	^false!

fractionLength
	"Minimum length after the dp"

	fractionLength isNil ifTrue: [^self defaultFractionLength].
	^fractionLength max: 0!

fractionLength: anInteger 
	"Minimum length after the dp"

	fractionLength := anInteger!

fractionSideStringFor: aFloat 
	"Answer a String representing the right side of the dp"

	| stream |
	stream := String writeStream.
	aFloat abs fractionPart printOn: stream decimalPlaces: self fractionLength.
	^stream contents copyFrom: 2!

integerFiller
	"Answer the character used for the integer side filler"

	^self zeroFillInteger ifTrue: [$0] ifFalse: [$ ]!

integerLength
	"Minimum length before the dp"

	integerLength isNil ifTrue: [^self defaultIntegerLength].
	^integerLength max: 1!

integerLength: anInteger 
	"Minimum length before the dp"

	integerLength := anInteger!

integerSideStringFor: aNumber 
	"Answer a String representing the left side of the dp.
		Pad if needed, with the appropriate character
		Insert commas if needed
		Fiddle for negative values and sign after currency to give (with/without padding)
			£       -12,345.00
			£-0,000,012,345.00
			£-123.00
			£-1,234.00
		NB The integer field length calculation excludes commas or a sign character"

	| stream padLength |
	stream := ReadWriteStream with: String new.
	stream nextPutAll: aNumber truncated abs printString reverse.
	padLength := self integerLength - stream contents size.
	(aNumber negative and: [self zeroFillInteger not and: [self signBeforeCurrency not]]) 
		ifTrue: [stream nextPut: $-].
	padLength timesRepeat: [stream nextPut: self integerFiller].
	(aNumber negative and: [self zeroFillInteger and: [self signBeforeCurrency not]]) 
		ifTrue: [stream nextPut: $-].
	self commas ifTrue: [self addCommasTo: stream].
	^stream contents reverse!

isLeftExceptionalValue: aNumber 
	"Don't allow nil or anything not a <number>"

	^(super isLeftExceptionalValue: aNumber) or: [(aNumber class conformsToProtocol: #number) not]!

isRightExceptionalValue: aString 
	"Don't allow nil, an empty string or anything not a <readableString>
	Note - local test is first to avoid walkback"

	^(aString class conformsToProtocol: #readableString) not 
		or: [super isRightExceptionalValue: aString]!

leftToRight: aNumber 
	"Convert aNumber into a String.
	Prefix with the default locale currency character(s).
	Insert a sign (if aNumber is negative) either before or after (in #integerSideStringFor:) the currency symbol"

	| stream |
	stream := String writeStream.
	(self signBeforeCurrency and: [aNumber negative]) ifTrue: [stream nextPut: $-].
	stream
		nextPutAll: self currencySymbol;
		nextPutAll: (self integerSideStringFor: aNumber).
	self fractionLength > 0 ifTrue: [stream nextPutAll: (self fractionSideStringFor: aNumber asFloat)].
	^stream contents!

rightToLeft: aString 
	"Convert from aString to a Number. 
	Strip out first -
		currency character(s)
		commas
		spaces"

	| value |
	value := aString copy.
	value := value copyWithoutAll: ', ' , self currencySymbol.
	^Number fromString: value!

signBeforeCurrency
	"Does the sign come before or after the currency symbol"

	signBeforeCurrency isNil ifTrue: [^self defaultSignBeforeCurrency].
	^signBeforeCurrency!

signBeforeCurrency: aBoolean 
	"Does the sign come before or after the currency symbol"

	signBeforeCurrency := aBoolean!

zeroFillInteger
	"Zero fill unused space before dp"

	zeroFillInteger isNil ifTrue: [^self defaultZeroFillInteger].
	^zeroFillInteger!

zeroFillInteger: aBoolean 
	"Zero fill unused space before dp"

	zeroFillInteger := aBoolean! !
!CurrencyToText categoriesFor: #addCommasTo:!operations!private! !
!CurrencyToText categoriesFor: #commas!accessing!public! !
!CurrencyToText categoriesFor: #commas:!accessing!public! !
!CurrencyToText categoriesFor: #currencySymbol!accessing!public! !
!CurrencyToText categoriesFor: #currencySymbol:!accessing!public! !
!CurrencyToText categoriesFor: #defaultCommas!constants!public! !
!CurrencyToText categoriesFor: #defaultCurrencySymbol!constants!public! !
!CurrencyToText categoriesFor: #defaultFractionLength!constants!public! !
!CurrencyToText categoriesFor: #defaultIntegerLength!constants!public! !
!CurrencyToText categoriesFor: #defaultSignBeforeCurrency!constants!public! !
!CurrencyToText categoriesFor: #defaultZeroFillInteger!constants!public! !
!CurrencyToText categoriesFor: #fractionLength!accessing!public! !
!CurrencyToText categoriesFor: #fractionLength:!accessing!public! !
!CurrencyToText categoriesFor: #fractionSideStringFor:!operations!public! !
!CurrencyToText categoriesFor: #integerFiller!helpers!public! !
!CurrencyToText categoriesFor: #integerLength!accessing!public! !
!CurrencyToText categoriesFor: #integerLength:!accessing!public! !
!CurrencyToText categoriesFor: #integerSideStringFor:!operations!public! !
!CurrencyToText categoriesFor: #isLeftExceptionalValue:!public!testing! !
!CurrencyToText categoriesFor: #isRightExceptionalValue:!public!testing! !
!CurrencyToText categoriesFor: #leftToRight:!operations!public! !
!CurrencyToText categoriesFor: #rightToLeft:!operations!public! !
!CurrencyToText categoriesFor: #signBeforeCurrency!accessing!public! !
!CurrencyToText categoriesFor: #signBeforeCurrency:!accessing!public! !
!CurrencyToText categoriesFor: #zeroFillInteger!accessing!public! !
!CurrencyToText categoriesFor: #zeroFillInteger:!accessing!public! !

!CurrencyToText class methodsFor!

publishedAspectsOfInstances
	"Answer a Set of AspectDescriptors that describe the aspects published
	by instances instances of the receiver"

	^(super publishedAspectsOfInstances)
		add: (Aspect boolean: #zeroFillInteger);
		add: (Aspect boolean: #commas);
		add: (Aspect boolean: #signBeforeCurrency);
		add: (Aspect integer: #integerLength);
		add: (Aspect integer: #fractionLength);
		add: (Aspect string: #currencySymbol);
		yourself!

stbConvertFrom: anSTBClassFormat 
	"Convert from version 0 Bitmap. 
		Version 1 adds a signBeforeCurrency inst var"

	^
	[:data | 
	| newInstance |
	newInstance := self basicNew.
	1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
	newInstance]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1! !
!CurrencyToText class categoriesFor: #publishedAspectsOfInstances!constants!must strip!public! !
!CurrencyToText class categoriesFor: #stbConvertFrom:!binary filing!public! !
!CurrencyToText class categoriesFor: #stbVersion!binary filing!public! !

