"Filed out from Dolphin Smalltalk"!

MethodCategory subclass: #VirtualMethodCategory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VirtualMethodCategory guid: (GUID fromString: '{87b4c504-026e-11d3-9fd7-00a0cc3e4a32}')!
VirtualMethodCategory isAbstract: true!
VirtualMethodCategory comment: 'VirtualMethodCategory is the class of method categories whose membership is calculated on demand rather than looked up in the method catalogue of the method''s class. As virtual categories usually have no static record in the image, they typically carry no space overhead. This is a significant benefit for the privacy categories ''private'' and ''public'' (membership of which is determined by a bit flag in the method header), as every method in the system is in one or the other. The downside is that querying the membership of the category takes more time, although this is not likely to be noticeable in normal operation.

VirtualMethodCategory itself is abstract, but provides much of the implementation for simple virtual categories, which typically need implement only #includesMethod:

Virtual method categories are sometimes referred to as pseudo-categories.

Instance Variables:
	None

Class Variables:
	None'!
!VirtualMethodCategory categoriesForClass!System-Support! !
!VirtualMethodCategory methodsFor!

addMethodSilently: aCompiledMethod 
	"Private - Add the <CompiledMethod> argument to the set of methods that are members
	of this category. Pseudo-categories have a calculated membership and typically can't be
	added to in this manner, so the default is to do nothing."

	!

behaviorsDo: aMonadicValuable 
	self class environment allBehaviorsDo: aMonadicValuable!

includesBehavior: aBehavior
	"Answer whether the receiver categorizes any methods in the specified class."

	^aBehavior methodDictionary anySatisfy: [:each | self includesMethod: each]!

includesMethod: aCompiledMethod 
	"Answer whether the receiver includes the <CompiledMethod> argument.
	This is the only method that must be implemented in subclasses."

	^self subclassResponsibility!

isSlowToEnumerate
	"Answer whether this method category is slow to enumerate. This may be the case for certain
	calculated categories."

	^false!

isVirtual
	"Answer whether the receiver is a virtual category, i.e. one that has 
	calculated contents. All pseudo-categories are virtual, but not vice versa."

	^true!

methodsInBehavior: aBehavior
	"Answer a <sequencedReadableCollection> of <CompiledMethods>s being all the methods in the <Behavior>
	argument which are members of the receiver."

	| answer |
	answer := WriteStream on: (Array new: 8).
	self methodsInBehavior: aBehavior do: [:each | answer nextPut: each].
	^answer contents!

methodsInBehavior: aBehavior do: aMonadicValuable 
	aBehavior methodDictionary 
		do: [:each | (self includesMethod: each) ifTrue: [aMonadicValuable value: each]]!

removeMethodSilently: aCompiledMethod 
	"Private - Remove the <CompiledMethod> argument from the set of 
	methods that are members of the receiver, and make no fuss about it.
	In general the membership of pseudo-categories is generated and in 
	order to remove a method it is necessary to modify it so that it no longer
	fits the membership criteria of the category, therefore the default is to
	do nothing here."

	!

selectorsInBehavior: aBehavior
	"Answer a <sequencedReadableCollection> of <Symbol>s being the selectors of methods in the <Behavior> argument which are members of the receiver."

	| selectors |
	selectors := WriteStream on: (Array new: 8).
	self methodsInBehavior: aBehavior do: [:each | selectors nextPut: each selector].
	^selectors contents! !
!VirtualMethodCategory categoriesForMethods!
addMethodSilently:!adding!private! !
behaviorsDo:!enumerating!public! !
includesBehavior:!enumerating!public! !
includesMethod:!public!testing! !
isSlowToEnumerate!public!testing! !
isVirtual!public!testing! !
methodsInBehavior:!enumerating!public! !
methodsInBehavior:do:!enumerating!public! !
removeMethodSilently:!private!removing! !
selectorsInBehavior:!enumerating!public! !
!

