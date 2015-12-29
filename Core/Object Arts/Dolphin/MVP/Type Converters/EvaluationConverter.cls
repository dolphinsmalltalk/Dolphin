"Filed out from Dolphin Smalltalk X6.2"!

TypeConverter subclass: #EvaluationConverter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EvaluationConverter guid: (GUID fromString: '{D66E11D7-487C-4B0D-972E-6CB3A52FCF06}')!
EvaluationConverter comment: 'Left to right: Converts from Smalltalk evaluation strings to the objects they evaluate to.
Right to left: Converts from an object to its #storeString, which is often (but not always) able to evaluate back to an equivalent object.'!
!EvaluationConverter categoriesForClass!MVP-Type Converters-Abstract! !
!EvaluationConverter methodsFor!

leftToRight: aStringOrNil 
	"Answer the result of evaluating aStringOrNil with the compiler"

	^aStringOrNil notNil ifTrue: [Compiler evaluate: aStringOrNil logged: false]!

rightToLeft: anObject 
	"Private - Answers the #storeString of anObject, which can often be converted back to an equal object by evaluating it."

	^anObject storeString! !
!EvaluationConverter categoriesFor: #leftToRight:!operations!private! !
!EvaluationConverter categoriesFor: #rightToLeft:!operations!private! !

