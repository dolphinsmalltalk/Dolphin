"Filed out from Dolphin Smalltalk"!

TypeConverter subclass: #EvaluationConverter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EvaluationConverter guid: (GUID fromString: '{d66e11d7-487c-4b0d-972e-6cb3a52fcf06}')!
EvaluationConverter comment: 'Left to right: Converts from Smalltalk evaluation strings to the objects they evaluate to.
Right to left: Converts from an object to its #storeString, which is often (but not always) able to evaluate back to an equivalent object.'!
!EvaluationConverter categoriesForClass!MVP-Type Converters-Abstract! !
!EvaluationConverter methodsFor!

leftToRight: aStringOrNil 
	"Answer the result of evaluating aStringOrNil with the compiler"

	^aStringOrNil notNil ifTrue: [Compiler evaluate: aStringOrNil]!

rightToLeft: anObject 
	"Private - Answers the #storeString of anObject, which can often be converted back to an equal object by evaluating it."

	^anObject storeString! !
!EvaluationConverter categoriesForMethods!
leftToRight:!operations!private! !
rightToLeft:!operations!private! !
!

