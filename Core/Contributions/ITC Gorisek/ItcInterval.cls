"Filed out from Dolphin Smalltalk X6.2"!

Interval subclass: #ItcInterval
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ItcInterval guid: (GUID fromString: '{5C4D87C4-B737-4AF4-A80E-ED3860229D75}')!
ItcInterval comment: ''!
!ItcInterval categoriesForClass!Collections-Sequenceable! !
!ItcInterval methodsFor!

includes: anObject 
	"Answer whether the <Object> argument, target, is one of the elements of the receiver.
	Implementation Note: This is based on John Brant's suggestion posted to comp.lang.smalltalk.dolphin,
	though it has been modified slightly to reduce the number of comparisons at the expense of some
	code clarity."

	(start class == Date or: [start class == Time or: [start class isKindOf: TimeStamp]]) 
		ifTrue: 
			[(anObject class == start class 
				or: [(anObject class isKindOf: TimeStamp) and: [start class isKindOf: TimeStamp]]) 
					ifTrue: [^anObject >= start and: [anObject <= stop]]
					ifFalse: [^false]].
	(anObject understandsArithmetic 
		or: [anObject class == Date or: [anObject class == Time or: [anObject class isKindOf: TimeStamp]]]) 
			ifFalse: [^false].
	(step < 0 
		ifTrue: [anObject >= stop and: [anObject <= start]]
		ifFalse: [anObject >= start and: [anObject <= stop]]) ifFalse: [^false].
	^step isInteger 
		ifTrue: [(anObject - start) \\ step = 0]
		ifFalse: [start + (step * ((anObject - start) / step) rounded) = anObject]!

intersects: anInterval 
	^(anInterval start >= start and: [anInterval start <= stop]) 
		or: [anInterval stop >= start and: [anInterval stop <= stop]]! !
!ItcInterval categoriesFor: #includes:!public!testing! !
!ItcInterval categoriesFor: #intersects:!printing!public! !

