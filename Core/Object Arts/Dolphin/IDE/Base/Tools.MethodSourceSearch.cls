"Filed out from Dolphin Smalltalk 7"!

Tools.MethodSearch subclass: #'Tools.MethodSourceSearch'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.MethodSourceSearch guid: (Core.GUID fromString: '{6f058c96-c1bf-4fb5-a2c3-b82976045e6a}')!
Tools.MethodSourceSearch comment: ''!
!Tools.MethodSourceSearch categoriesForClass!Kernel-Objects! !
!Tools.MethodSourceSearch methodsFor!

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
!Tools.MethodSourceSearch categoriesFor: #methodFilter:!helpers!private! !
!Tools.MethodSourceSearch categoriesFor: #methodReferenceFilter!helpers!private! !
!Tools.MethodSourceSearch categoriesFor: #regexpReferenceFilter!helpers!private! !
!Tools.MethodSourceSearch categoriesFor: #simpleReferenceFilter!helpers!private! !
!Tools.MethodSourceSearch categoriesFor: #wildcardReferenceFilter!helpers!private! !

