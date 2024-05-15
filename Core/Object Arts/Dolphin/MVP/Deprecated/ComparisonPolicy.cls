"Filed out from Dolphin Smalltalk"!

Object subclass: #ComparisonPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ComparisonPolicy guid: (GUID fromString: '{02cd77f7-d41d-4e1c-82ee-92322a049235}')!

ComparisonPolicy comment: 'This class has now been deprecated, use SearchPolicy (which implements the <comparisonPolicy> protocol) instead.'!

!ComparisonPolicy categoriesForClass!Deprecated! !

!ComparisonPolicy class methodsFor!

always
	Notification deprecated.	"5.0: This whole class has been replaced by SearchPolicy, which implements the <comparisonPolicy> protocol"
	^SearchPolicy always!

equality
	Notification deprecated.	"5.0: This whole class has been replaced by SearchPolicy, which implements the <comparisonPolicy> protocol"
	^SearchPolicy equality!

identity
	Notification deprecated.	"5.0 This whole class has been replaced by SearchPolicy, which implements the <comparisonPolicy> protocol"
	^SearchPolicy identity!

never
	Notification deprecated.	"5.0: This whole class has been replaced by SearchPolicy, which implements the <comparisonPolicy> protocol"
	^SearchPolicy never!

new
	"ComparisonPolicy is a singleton class."

	^self shouldNotImplement!

searchPolicyForComparison: anObject
	anObject class == BlockClosure
		ifTrue: 
			[| method |
			method := anObject method.
			(method methodClass == self class and: [SearchPolicy respondsTo: method selector])
				ifTrue: 
					["shallowCopy is necessary here because STB uses become to swap in the converted object, and we don't want to swap the singleton"
					^(SearchPolicy perform: method selector) shallowCopy]]
		ifFalse: 
			[anObject class == Message
				ifTrue: 
					[anObject selector == #= ifTrue: [^SearchPolicy equality shallowCopy].
					anObject selector == #== ifTrue: [^SearchPolicy identity shallowCopy]]].
	^SearchPolicy newCompareBlock: anObject hashBlock: [:each | each hash]!

stbConvertFrom: anSTBClassFormat
	"Convert from earlier version models.
	1: ComparisionPolicy subsumed by SearchPolicy."

	^
	[:data |
	"In the meantime, provide a replacement SearchPolicy. This will map the standard equality/identity/never/always directly. Other cases will yield a pluggable search policy with the original block, which may not work."
	self searchPolicyForComparison: data first]!

stbVersion
	^1! !

!ComparisonPolicy class categoriesForMethods!
always!instance creation!public! !
equality!instance creation!public! !
identity!instance creation!public! !
never!instance creation!public! !
new!instance creation!public! !
searchPolicyForComparison:!instance creation!private! !
stbConvertFrom:!instance creation!public! !
stbVersion!instance creation!public! !
!

