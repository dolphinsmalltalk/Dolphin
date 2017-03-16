"Filed out from Dolphin Smalltalk 7"!

Magnitude subclass: #Money
	instanceVariableNames: 'currency amount'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Money guid: (GUID fromString: '{2b710238-2f4b-43c8-8f51-f78e4072c761}')!
Money comment: ''!
!Money categoriesForClass!Unclassified! !
!Money methodsFor!

- aMagnitude 
	^aMagnitude class == Money 
		ifTrue: 
			[(self equalsCurrency: aMagnitude currency) 
				ifTrue: [Money new setCurrency: (self currencyFor: aMagnitude) amount: amount - aMagnitude amount]
				ifFalse: [self error: 'Can''t add to amount in different currency']]
		ifFalse: [Money new setCurrency: currency amount: amount - aMagnitude]!

* aMagnitude 
	^aMagnitude class == Money 
		ifTrue: 
			[(self equalsCurrency: aMagnitude currency) 
				ifTrue: [Money new setCurrency: (self currencyFor: aMagnitude) amount: amount * aMagnitude amount]
				ifFalse: [self error: 'Can''t multiply with amount in different currency']]
		ifFalse: [Money new setCurrency: currency amount: amount * aMagnitude]!

/ aMagnitude 
	^aMagnitude class == Money 
		ifTrue: 
			[(self equalsCurrency: aMagnitude currency) 
				ifTrue: [Money new setCurrency: (self currencyFor: aMagnitude) amount: amount / aMagnitude amount]
				ifFalse: [self error: 'Can''t multiply with amount in different currency']]
		ifFalse: [Money new setCurrency: currency amount: amount / aMagnitude]!

-~ aMagnitude 
	^aMagnitude isNil ifTrue: [self] ifFalse: [self - aMagnitude]!

+ aMagnitude 
	^aMagnitude class == Money 
		ifTrue: 
			[(self equalsCurrency: aMagnitude currency) 
				ifTrue: [Money new setCurrency: (self currencyFor: aMagnitude) amount: amount + aMagnitude amount]
				ifFalse: 
					[| app |
					((Processor activeProcess respondsTo: #webApplication) 
						and: [(app := Processor activeProcess webApplication) notNil]) 
							ifTrue: 
								[Money new setCurrency: app denarnaValutaDefault
									amount: (app convertToDefaultCurrency: amount from: self basicCurrency) 
											+ (app convertToDefaultCurrency: aMagnitude amount from: aMagnitude currency)]
							ifFalse: [self error: 'Can''t add to amount in different currency']]]
		ifFalse: [Money new setCurrency: currency amount: amount + aMagnitude]!

+~ aMagnitude 
	^aMagnitude isNil ifTrue: [self] ifFalse: [self + aMagnitude]!

< operand 
	"Answer whether the receiver is less than the <magnitude>, operand.

	Only this relational operator need be implemented by subclasses, since the others can 
	be implemented in terms of it (though performance may dictate otherwise)."

	^operand class == Money 
		ifTrue: 
			[(self equalsCurrency: operand currency) 
				ifTrue: [amount < operand amount]
				ifFalse: [self error: 'Can''t compare different currencies']]
		ifFalse: [operand > amount]!

<= operand 
	"Answer whether the receiver is less than the <magnitude>, operand.

	Only this relational operator need be implemented by subclasses, since the others can 
	be implemented in terms of it (though performance may dictate otherwise)."

	^operand class == Money 
		ifTrue: 
			[(self equalsCurrency: operand currency) 
				ifTrue: [amount <= operand amount]
				ifFalse: [self error: 'Can''t compare different currencies']]
		ifFalse: [amount <= operand]!

= aMagnitude 
	"Answer whether the receiver is equivalent to the argument, aMagnitude."

	"Objects are found equal for calculated money with * to!!"

	^aMagnitude class == Money 
		ifTrue: [(self equalsCurrency: aMagnitude currency) and: [aMagnitude amount = amount]]
		ifFalse: [aMagnitude = amount]!

> operand 
	"Answer whether the receiver is less than the <magnitude>, operand.

	Only this relational operator need be implemented by subclasses, since the others can 
	be implemented in terms of it (though performance may dictate otherwise)."

	^operand class == Money 
		ifTrue: 
			[(self equalsCurrency: operand currency) 
				ifTrue: [amount > operand amount]
				ifFalse: [self error: 'Can''t compare different currencies']]
		ifFalse: [operand < amount]!

>= operand 
	"Answer whether the receiver is less than the <magnitude>, operand.

	Only this relational operator need be implemented by subclasses, since the others can 
	be implemented in terms of it (though performance may dictate otherwise)."

	^operand class == Money 
		ifTrue: 
			[(self equalsCurrency: operand currency) 
				ifTrue: [amount >= operand amount]
				ifFalse: [self error: 'Can''t compare different currencies']]
		ifFalse: [amount >= operand]!

abs
	^amount >= 0 ifTrue: [self] ifFalse: [Money new setCurrency: currency amount: amount abs]!

addToFloat: aFloat 
	^Money new setCurrency: currency amount: amount + aFloat!

addToInteger: anInteger 
	^Money new setCurrency: currency amount: amount + anInteger!

addToScaledDecimal: aDecimal 
	^Money new setCurrency: currency amount: amount + aDecimal!

amount
	^amount!

amount: anObject 
	amount := self normalizeAmount: anObject!

asDecimalOrFloat
	^self amount asDecimalOrFloat!

basicCurrency
	"Answer basic currency, without the calculated mark * , if any."

	^currency last == $* ifTrue: [currency copyFrom: 1 to: currency size - 1] ifFalse: [currency]!

currency
	^currency!

currency: anObject 
	currency := self normalizeCurrency: anObject!

currencyFor: aMoney 
	"If any of currencies ends with * than result must end with *. Exception is when amount is zero. Method presumes that currencies already matched equal (#equalsCurrency:)."

	^currency last == $* 
		ifTrue: 
			[amount isZero 
				ifTrue: 
					[aMoney amount isZero 
						ifTrue: 
							["Both are zero (set without *)."
							currency copyFrom: 1 to: currency size - 1]
						ifFalse: [aMoney currency]]
				ifFalse: [currency]]
		ifFalse: [aMoney amount isZero ifTrue: [currency] ifFalse: [aMoney currency]]!

equalsCurrency: aCurrency 
	"If last character is special conversion character * than it is still same currency."
	| str1 str2 |
	str1 := currency last == $* ifTrue: [currency copyFrom: 1 to: currency size - 1] ifFalse: [currency].
	str2 := aCurrency last == $* 
				ifTrue: [aCurrency copyFrom: 1 to: aCurrency size - 1]
				ifFalse: [aCurrency].
	^str1 = str2!

first
	^amount!

greaterThanFloat: aFloat 
	^amount > aFloat!

greaterThanInteger: anInteger 
	^amount > anInteger!

greaterThanScaledDecimal: aDecimal 
	^amount > aDecimal!

hash
	^self basicCurrency hash + amount hash!

isMoney
	^true!

isNilOrZero
	^amount isNilOrZero!

isNumber
	^true!

isZero
	^amount isZero!

itcAsNumberOrZero
	^self!

itcNegated
	^Money new setCurrency: currency amount: 0.0s - amount!

last
	^currency!

normalizeAmount: aNumber 
	aNumber isNumber 
		ifFalse: 
			["Report error only in development, in runtime return zero."
			ItcSystemManager isRuntime ifTrue: [^0].
			self error: 'Invalid amount parameter'].
	^aNumber isMoney ifTrue: [aNumber amount] ifFalse: [aNumber asDecimalOrFloat]!

normalizeCurrency: aString 
	| str |
	aString isString 
		ifTrue: 
			[str := WriteStream on: (String new: aString size).
			aString do: [:ch | ch itcIsAlphaNumeric ifTrue: [str nextPut: ch itcAsUppercase]].
			(str := str contents) isEmpty 
				ifFalse: 
					["Add special funcionality for character * . It is used on currency conversions and it means that amount is calculated, not entered directly."
					aString last == $* ifTrue: [str := str , '*']]].
	str isEmpty 
		ifTrue: 
			["Show error only in development, in runtime set to default currency."
			ItcSystemManager isRuntime 
				ifTrue: 
					[| app |
					app := (Processor activeProcess respondsTo: #webApplication) 
								ifTrue: [Processor activeProcess webApplication].
					str := app isNil ifTrue: [''] ifFalse: [app denarnaValutaDefault]]
				ifFalse: [self error: 'Invalid currency parameter']].
	^str!

printOn: aStream 
	currency isString ifTrue: [aStream nextPutAll: currency] ifFalse: [currency printOn: aStream].
	aStream nextPut: $ .
	amount printOn: aStream!

roundTo: aNumber 
	^Money new setCurrency: currency amount: (amount roundTo: aNumber)!

setAndNormalizeCurrency: aString amount: aNumber 
	currency := self normalizeCurrency: aString.
	amount := self normalizeAmount: aNumber!

setCurrency: aString amount: aNumber 
	currency := aString.
	amount := aNumber!

subtractFromFloat: aFloat 
	^Money new setCurrency: currency amount: aFloat - amount!

subtractFromInteger: anInteger 
	^Money new setCurrency: currency amount: anInteger - amount!

subtractFromScaledDecimal: aDecimal 
	^Money new setCurrency: currency amount: aDecimal - amount! !
!Money categoriesFor: #-!comparing!public! !
!Money categoriesFor: #*!comparing!public! !
!Money categoriesFor: #/!comparing!public! !
!Money categoriesFor: #-~!comparing!public! !
!Money categoriesFor: #+!comparing!public! !
!Money categoriesFor: #+~!comparing!public! !
!Money categoriesFor: #<!comparing!public! !
!Money categoriesFor: #<=!comparing!public! !
!Money categoriesFor: #=!comparing!public! !
!Money categoriesFor: #>!comparing!public! !
!Money categoriesFor: #>=!comparing!public! !
!Money categoriesFor: #abs!comparing!public! !
!Money categoriesFor: #addToFloat:!accessing!private! !
!Money categoriesFor: #addToInteger:!accessing!private! !
!Money categoriesFor: #addToScaledDecimal:!accessing!private! !
!Money categoriesFor: #amount!accessing!public! !
!Money categoriesFor: #amount:!accessing!public! !
!Money categoriesFor: #asDecimalOrFloat!accessing!public! !
!Money categoriesFor: #basicCurrency!accessing!public! !
!Money categoriesFor: #currency!accessing!public! !
!Money categoriesFor: #currency:!accessing!public! !
!Money categoriesFor: #currencyFor:!accessing!private! !
!Money categoriesFor: #equalsCurrency:!comparing!public! !
!Money categoriesFor: #first!obsolete!public! !
!Money categoriesFor: #greaterThanFloat:!comparing!private! !
!Money categoriesFor: #greaterThanInteger:!comparing!private! !
!Money categoriesFor: #greaterThanScaledDecimal:!comparing!private! !
!Money categoriesFor: #hash!comparing!public! !
!Money categoriesFor: #isMoney!comparing!public! !
!Money categoriesFor: #isNilOrZero!comparing!public! !
!Money categoriesFor: #isNumber!comparing!public! !
!Money categoriesFor: #isZero!comparing!public! !
!Money categoriesFor: #itcAsNumberOrZero!converting!public! !
!Money categoriesFor: #itcNegated!converting!public! !
!Money categoriesFor: #last!obsolete!public! !
!Money categoriesFor: #normalizeAmount:!accessing!private! !
!Money categoriesFor: #normalizeCurrency:!accessing!private! !
!Money categoriesFor: #printOn:!accessing!private! !
!Money categoriesFor: #roundTo:!accessing!public! !
!Money categoriesFor: #setAndNormalizeCurrency:amount:!accessing!private! !
!Money categoriesFor: #setCurrency:amount:!accessing!private! !
!Money categoriesFor: #subtractFromFloat:!accessing!private! !
!Money categoriesFor: #subtractFromInteger:!accessing!private! !
!Money categoriesFor: #subtractFromScaledDecimal:!accessing!private! !

!Money class methodsFor!

amount: aNumber currency: aString 
	^(aNumber isNil or: [aString isNil]) 
		ifFalse: [self new setAndNormalizeCurrency: aString amount: aNumber]!

currency: aString amount: aNumber 
	^(aNumber isNil or: [aString isNil]) 
		ifFalse: [self new setAndNormalizeCurrency: aString amount: aNumber]! !
!Money class categoriesFor: #amount:currency:!public! !
!Money class categoriesFor: #currency:amount:!public! !

