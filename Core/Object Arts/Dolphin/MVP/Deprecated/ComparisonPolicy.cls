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

stbConvertFrom: anSTBClassFormat
	"Convert from earlier version models.
	1: ComparisionPolicy subsumed by SearchPolicy."

	^
	[:data |
	| compareBlock |
	compareBlock := data first.
	(compareBlock class == BlockClosure and: 
			[compareBlock method methodClass == self class
				and: [SearchPolicy respondsTo: compareBlock method selector]])
		ifTrue: 
			["shallowCopy is necessary here because STB uses become to swap in the converted object"
			(SearchPolicy perform: compareBlock method selector) shallowCopy]
		ifFalse: [PluggableSearchPolicy newCompareBlock: compareBlock hashBlock: [:each | each hash]]]!

stbVersion
	^1! !

!ComparisonPolicy class categoriesForMethods!
always!instance creation!public! !
equality!instance creation!public! !
identity!instance creation!public! !
never!instance creation!public! !
new!instance creation!public! !
stbConvertFrom:!instance creation!public! !
stbVersion!instance creation!public! !
!

