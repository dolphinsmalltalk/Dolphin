"Filed out from Dolphin Smalltalk"!

MethodSearch subclass: #MethodSourceSearch
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodSourceSearch guid: (GUID fromString: '{6f058c96-c1bf-4fb5-a2c3-b82976045e6a}')!
MethodSourceSearch comment: ''!
!MethodSourceSearch categoriesForClass!Kernel-Objects! !
!MethodSourceSearch methodsFor!

methodFilter: aMonadicValuable 
	^[:each | each getSource ifNil: [false] ifNotNil: [:src | aMonadicValuable value: src]]!

methodReferenceFilter
	"Private - Answer a <monadicValuable> which can be used to discriminate between <CompiledMethod>s that
	match this search and those that do not."

	^self methodFilter: super methodReferenceFilter!

regexpReferenceFilter
	| re |
	re := findDetails regularExpression.
	^[:each | re test: each]!

simpleReferenceFilter
	| find what |
	what := findDetails pattern.
	find := findDetails isCaseSensitive 
				ifTrue: [[:each | each findString: what]]
				ifFalse: 
					[| lower |
					lower := what asLowercase.
					[:text | text asLowercase findString: lower]].
	^findDetails isWholeWord 
		ifTrue: 
			[
			[:text | 
			| found |
			found := find value: text.
			found ~~ 0 and: 
					[(found == 1 or: [(text at: found - 1) isAlphaNumeric not]) and: 
							[| end |
							end := found + what size.
							end > text size or: [(text at: end) isAlphaNumeric not]]]]]
		ifFalse: [[:text | (find value: text) ~~ 0]]!

wildcardReferenceFilter
	| match ignoreCase |
	match := self wildcardMatchPattern.
	ignoreCase := findDetails isCaseSensitive not.
	^[:text | match match: text ignoreCase: ignoreCase]! !
!MethodSourceSearch categoriesForMethods!
methodFilter:!helpers!private! !
methodReferenceFilter!helpers!private! !
regexpReferenceFilter!helpers!private! !
simpleReferenceFilter!helpers!private! !
wildcardReferenceFilter!helpers!private! !
!

