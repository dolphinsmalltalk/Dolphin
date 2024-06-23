"Filed out from Dolphin Smalltalk"!

UI.TypeConverter
	subclass: #'UI.MappingConverter'
	instanceVariableNames: 'leftToRightMap rightToLeftMap'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.MappingConverter guid: (Core.GUID fromString: '{996f6c3c-194a-4481-ad8f-1d4c9e509c8a}')!

UI.MappingConverter comment: '<MappingConverter> is a <TypeConverter> that can be used to convert between values from fixed sets where there is a one-to-one correspondence between a value of the left type and a value of right type.

Instance Variables:
	leftToRightMap		<LookupTable> whose keys are the left type values and values are the right type values.
	rightToLeftMap		<LookupTable> inversion of leftToRightMap.

'!

!UI.MappingConverter categoriesForClass!MVP-Type Converters-General! !

!UI.MappingConverter methodsFor!

leftToRight: anObject 
	"Private - Converts the <Object> argument, which is assumed to be of the receiver's left 
	type to an <Object> of the receiver's right type. Answers the result of the conversion."

	^leftToRightMap at: anObject!

leftToRightMap
	^leftToRightMap!

leftToRightMap: aLookupTable 
	leftToRightMap := aLookupTable.
	rightToLeftMap := aLookupTable copyEmpty.
	leftToRightMap 
		keysAndValuesDo: [:eachKey :eachValue | rightToLeftMap at: eachValue put: eachKey]!

rightToLeft: anObject 
	"Private - Converts the <Object> argument, which is assumed to be of the receiver's right 
	type to an <Object> of the receiver's left type. Answers the result of the conversion."

	^rightToLeftMap at: anObject!

rightToLeftMap
	^rightToLeftMap!

rightToLeftMap: aLookupTable
	rightToLeftMap := aLookupTable.
	leftToRightMap := aLookupTable copyEmpty.
	rightToLeftMap 
		keysAndValuesDo: [:eachKey :eachValue | leftToRightMap at: eachValue put: eachKey]! !

!UI.MappingConverter categoriesForMethods!
leftToRight:!operations!private! !
leftToRightMap!accessing!private! !
leftToRightMap:!accessing!private! !
rightToLeft:!operations!private! !
rightToLeftMap!accessing!private! !
rightToLeftMap:!accessing!private! !
!

!UI.MappingConverter class methodsFor!

leftToRight: aLookupTable
	"Answer a new instance of the receiver that converts the keys of the <LookupTable>
	argument to the values, and vice versa."

	^self new 
		leftToRightMap: aLookupTable;
		yourself!

rightToLeft: aLookupTable
	"Answer a new instance of the receiver that converts the keys of the <LookupTable>
	argument to the values, and vice versa."

	^self new 
		rightToLeftMap: aLookupTable;
		yourself! !

!UI.MappingConverter class categoriesForMethods!
leftToRight:!instance creation!public! !
rightToLeft:!instance creation!public! !
!

