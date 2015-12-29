"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbMitchellMooreGenerator
	instanceVariableNames: 'randoms lowIndex highIndex'
	classVariableNames: 'UniqueInstance'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbMitchellMooreGenerator guid: (GUID fromString: '{E55002B7-7D2B-11D6-B6CC-00022D5019C8}')!
DhbMitchellMooreGenerator comment: ''!
!DhbMitchellMooreGenerator categoriesForClass!DHB Numerical! !
!DhbMitchellMooreGenerator methodsFor!

floatValue
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/11/00 "

	| x |
	x := (randoms at: lowIndex) + (randoms at: highIndex).
	x < 1.0 ifFalse: [x := x - 1.0].
	randoms at: highIndex put: x.
	highIndex := highIndex + 1.
	highIndex > randoms size ifTrue: [highIndex := 1].
	lowIndex := lowIndex + 1.
	lowIndex > randoms size ifTrue: [lowIndex := 1].
	^x!

initialize: anArray lowIndex: anInteger
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/11/00 "

	randoms := anArray.
	lowIndex := anInteger.
	highIndex := randoms size.
	^self!

integerValue: anInteger
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/11/00 "
	^( self floatValue * anInteger) truncated! !
!DhbMitchellMooreGenerator categoriesFor: #floatValue!information!public! !
!DhbMitchellMooreGenerator categoriesFor: #initialize:lowIndex:!initialization!public! !
!DhbMitchellMooreGenerator categoriesFor: #integerValue:!information!public! !

!DhbMitchellMooreGenerator class methodsFor!

constants: anArray lowIndex: anInteger
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/11/00 "
	^super new initialize: anArray lowIndex: anInteger!

default
	"Private- 
	 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/11/00 "

	| congruentialGenerator |
	congruentialGenerator := DhbCongruentialRandomNumberGenerator new.
	^self generateSeeds: congruentialGenerator!

generateSeeds: congruentialGenerator
	"Private- "
	^self constants: ((1 to: 55) collect: [:n | congruentialGenerator floatValue])
		lowIndex: 24!

new
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/11/00 "
	UniqueInstance isNil
		ifTrue: [ UniqueInstance := self default].
	^UniqueInstance!

reset: anInteger
	"Reset the unique instance used for the default series"
	UniqueInstance := self seed: anInteger.!

seed: anInteger
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 1/18/00 "

	| congruentialGenerator |
	congruentialGenerator := DhbCongruentialRandomNumberGenerator seed: anInteger.
	^self generateSeeds: congruentialGenerator! !
!DhbMitchellMooreGenerator class categoriesFor: #constants:lowIndex:!creation!public! !
!DhbMitchellMooreGenerator class categoriesFor: #default!creation!public! !
!DhbMitchellMooreGenerator class categoriesFor: #generateSeeds:!creation!public! !
!DhbMitchellMooreGenerator class categoriesFor: #new!creation!public! !
!DhbMitchellMooreGenerator class categoriesFor: #reset:!creation!public! !
!DhbMitchellMooreGenerator class categoriesFor: #seed:!creation!public! !

