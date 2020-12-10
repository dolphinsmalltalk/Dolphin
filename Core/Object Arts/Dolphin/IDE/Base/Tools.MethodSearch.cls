"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.MethodSearch'
	instanceVariableNames: 'findDetails regexp literal'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'IgnoreCaseMask' -> 16r1
	}!
Tools.MethodSearch guid: (Core.GUID fromString: '{702ae94a-b32c-4d97-b2a5-8080cf67e3b4}')!
Tools.MethodSearch comment: 'SelectorSearch represents the information and behaviour necessary to filter the methods of the system according to whether they define or reference a message selector matching specified criteria. This can include regular expression matching when the ''VBScript Regular Expressions'' package is loaded.

Instance Variables:
	findDetails		<FindDetails> holding search information (usually entered into the AdvancedFindDialog).
	regexp			<IRegExp2>, or nil if not a regexp search.

Class Variables:
	IgnoreCaseMask		<integer>

'!
!Tools.MethodSearch categoriesForClass!Kernel-Objects! !
!Tools.MethodSearch methodsFor!

findDetails
	"Answer an <AdvancedFindDetails> configured to find the selectors against which the receiver matches."

	^findDetails!

findDetails: aFindDetails 
	findDetails := aFindDetails!

initialize
	findDetails := AdvancedFindDetails new!

literal
	^literal!

literal: anObject
	literal := anObject.
	self pattern: anObject displayString.
	self searchMode: #text!

literalDefinitionFilter
	| selector |
	selector := self literal.
	^[:method | method selector == selector]!

literalSymbolsFilter: matchBlock 
	^
	[:eachMethod | 
	(eachMethod 
		literalsDetect: [:eachLiteral | (eachLiteral isKindOf: Symbol) and: [matchBlock value: eachLiteral]]
		ifNone: []) notNil]!

methodDefinitionFilter
	"Private - Answer a <monadicValuable> which can be used to discriminate between <CompiledMethod>s that
	match this selector search and those that do not."

	| type |
	type := self searchMode.
	^type == #regularExpression 
		ifTrue: [self regexpDefinitionFilter]
		ifFalse: 
			[type == #wildcardExpression 
				ifTrue: [self wildcardDefinitionFilter]
				ifFalse: [self literalDefinitionFilter]]!

methodReferenceFilter
	"Private - Answer a <monadicValuable> which can be used to discriminate between <CompiledMethod>s that
	match this selector search and those that do not."

	| type |
	type := self searchMode.
	^type == #regularExpression 
		ifTrue: [self regexpReferenceFilter]
		ifFalse: 
			[type == #wildcardExpression 
				ifTrue: [self wildcardReferenceFilter]
				ifFalse: [self simpleReferenceFilter]]!

pattern
	"Answer the receiver's current search pattern <String>. The interpretation of this string is
	dependant upon the search type mode."

	^findDetails pattern!

pattern: aString 
	findDetails pattern: aString!

regexpDefinitionFilter
	"Private - Answer a <monadicValuable> that can be evaluated to identify <CompiledMethod>s whos'
	selectors match the receiver's regular expression."

	| re |
	re := self regularExpression.
	^
	[:each | 
	| bstr matches selector |
	selector := each selector.
	bstr := selector asBSTR.
	matches := re execute: bstr.
	bstr free.
	"We want to match the entire selector"
	matches notEmpty and: [matches first length = selector size]]!

regexpReferenceFilter
	"Private - Answer a <monadicValuable> that can be evaluated to identify <CompiledMethod>s
	with references from the literal frame to selectors that match the receiver's regexp"

	^self literalSymbolsFilter: 
			[:each | 
			| bstr hits |
			bstr := each asBSTR.
			hits := self regularExpression execute: bstr.
			bstr free.
			"We want to match the entire selector"
			hits notEmpty and: [hits first length = each size]]!

regularExpression
	"Private - Answer a <IRegExp> configured with the receiver's current search details."

	regexp isNull 
		ifTrue: 
			[regexp := Smalltalk.IRegExp new.
			regexp
				pattern: findDetails pattern;
				ignoreCase: findDetails isCaseSensitive not].
	^regexp!

searchMode
	"Answer the search mode <Symbol>; one of #literal, #wildcard, #regexp."

	^findDetails searchMode!

searchMode: aSymbol 
	findDetails searchMode: aSymbol!

simpleReferenceFilter
	| object special |
	object := self literal.
	object isNil ifTrue: [self error: 'Invalid reference search'].
	special := VMLibrary default indexOfSpecialSelector: object ifAbsent: [].
	^special isNil 
		ifTrue: [[:each | each refersToLiteral: object]]
		ifFalse: [[:each | (each refersToLiteral: object) or: [each sendsSpecialSelector: special]]]!

wildcardDefinitionFilter
	| match ignoreCase |
	match := self wildcardMatchPattern.
	ignoreCase := findDetails isCaseSensitive not.
	^[:method | match match: method selector ignoreCase: ignoreCase]!

wildcardMatchPattern
	"Private - Answer a match <String> suitable sending #match: to match the user specified wildcard pattern."

	| match pattern |
	pattern := findDetails pattern.
	"If the user has asked for a wildcard search, but not actually included any wildcards, then
	assume they have specified a selector prefix to search for (a common case)."
	(pattern includesAnyOf: '*?') 
		ifFalse: 
			[pattern := pattern , '*'.
			findDetails pattern: pattern].
	match := pattern copyReplacing: $? withObject: $#.
	findDetails isWholeWord 
		ifFalse: 
			[match first = $* ifFalse: [match := '*' , match].
			match last = $* ifFalse: [match := match , '*']].
	^match!

wildcardReferenceFilter
	| match ignoreCase |
	match := self wildcardMatchPattern.
	ignoreCase := findDetails isCaseSensitive not.
	^self literalSymbolsFilter: [:each | match match: each ignoreCase: ignoreCase]! !
!Tools.MethodSearch categoriesFor: #findDetails!accessing!public! !
!Tools.MethodSearch categoriesFor: #findDetails:!accessing!public! !
!Tools.MethodSearch categoriesFor: #initialize!initializing!public! !
!Tools.MethodSearch categoriesFor: #literal!public! !
!Tools.MethodSearch categoriesFor: #literal:!accessing!public! !
!Tools.MethodSearch categoriesFor: #literalDefinitionFilter!helpers!private! !
!Tools.MethodSearch categoriesFor: #literalSymbolsFilter:!helpers!private! !
!Tools.MethodSearch categoriesFor: #methodDefinitionFilter!helpers!private! !
!Tools.MethodSearch categoriesFor: #methodReferenceFilter!helpers!private! !
!Tools.MethodSearch categoriesFor: #pattern!accessing!public! !
!Tools.MethodSearch categoriesFor: #pattern:!accessing!public! !
!Tools.MethodSearch categoriesFor: #regexpDefinitionFilter!helpers!private! !
!Tools.MethodSearch categoriesFor: #regexpReferenceFilter!helpers!private! !
!Tools.MethodSearch categoriesFor: #regularExpression!accessing!private! !
!Tools.MethodSearch categoriesFor: #searchMode!accessing!public! !
!Tools.MethodSearch categoriesFor: #searchMode:!accessing!public! !
!Tools.MethodSearch categoriesFor: #simpleReferenceFilter!helpers!private! !
!Tools.MethodSearch categoriesFor: #wildcardDefinitionFilter!helpers!private! !
!Tools.MethodSearch categoriesFor: #wildcardMatchPattern!helpers!private! !
!Tools.MethodSearch categoriesFor: #wildcardReferenceFilter!helpers!private! !

!Tools.MethodSearch class methodsFor!

new
	^super new initialize!

newFindDetails: aFindDetails 
	^(self new)
		literal: aFindDetails pattern asSymbol;
		findDetails: aFindDetails;
		yourself!

newLiteral: anObject
	^(self new)
		literal: anObject
		yourself!

newPattern: aString 
	^self newFindDetails: (AdvancedFindDetails newPattern: aString)!

newSelector: aSymbol 
	^self newLiteral: aSymbol asSymbol! !
!Tools.MethodSearch class categoriesFor: #new!instance creation!public! !
!Tools.MethodSearch class categoriesFor: #newFindDetails:!instance creation!public! !
!Tools.MethodSearch class categoriesFor: #newLiteral:!instance creation!public! !
!Tools.MethodSearch class categoriesFor: #newPattern:!instance creation!public! !
!Tools.MethodSearch class categoriesFor: #newSelector:!instance creation!public! !

