"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ComparisonPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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

stbConvertFrom: anSTBClassFormat 
	"Convert from earlier version models.
	1: ComparisionPolicy subsumed by SearchPolicy."

	^
	[:data | 
	| compareBlock |
	Notification 
		signal: 'STB reference to deprecated class ComparisonPolicy encountered. Please resave the offending resource or binary file'.
	compareBlock := data first.
	(compareBlock class == BlockClosure and: 
			[compareBlock method methodClass == self class 
				and: [SearchPolicy respondsTo: compareBlock method selector]]) 
		ifTrue: [(SearchPolicy perform: compareBlock method selector) shallowCopy]
		ifFalse: [PluggableSearchPolicy newCompareBlock: compareBlock hashBlock: [:each | each hash]]]!

stbVersion
	^1! !
!ComparisonPolicy class categoriesFor: #always!instance creation!public! !
!ComparisonPolicy class categoriesFor: #equality!instance creation!public! !
!ComparisonPolicy class categoriesFor: #identity!instance creation!public! !
!ComparisonPolicy class categoriesFor: #never!instance creation!public! !
!ComparisonPolicy class categoriesFor: #new!instance creation!public! !
!ComparisonPolicy class categoriesFor: #stbConvertFrom:!instance creation!public! !
!ComparisonPolicy class categoriesFor: #stbVersion!instance creation!public! !

