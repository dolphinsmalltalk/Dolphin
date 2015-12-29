"Filed out from Dolphin Smalltalk X6"!

MethodSearch subclass: #MethodSourceSearch
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodSourceSearch guid: (GUID fromString: '{6F058C96-C1BF-4FB5-A2C3-B82976045E6A}')!
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
!MethodSourceSearch categoriesFor: #methodFilter:!helpers!private! !
!MethodSourceSearch categoriesFor: #methodReferenceFilter!helpers!private! !
!MethodSourceSearch categoriesFor: #regexpReferenceFilter!helpers!private! !
!MethodSourceSearch categoriesFor: #simpleReferenceFilter!helpers!private! !
!MethodSourceSearch categoriesFor: #wildcardReferenceFilter!helpers!private! !

