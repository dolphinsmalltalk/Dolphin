"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'UI.TypeConverter'
	instanceVariableNames: 'leftNullValue rightNullValue'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.TypeConverter guid: (Core.GUID fromString: '{87b4c4c8-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.TypeConverter isNonInstantiable: true!
UI.TypeConverter comment: 'A <TypeConverter> is capable of converting one type of object into another and vice versa. Very often a TypeConverter forms part of a <ValueConverter> model that sits between a subject value and some client of that value. The subject value is referred to as the ''left'' value and the value the client sees is the ''right'' value. In a typical usage (within the MVP framework) the ''left'' type is the type of the Model value, and the right type is the display value (usually a String).

TypeConverter is itself an abstract class and concrete subclasses must be created to provide specific type convertions. Subclasses should implement #leftToRight: and #rightToLeft: methods to perform the conversions. These methods are, however, private. The public interface for conversion is as defined in the <typeConverter> method protocol.

In order that these seletor names hold a common meaning all subclasses should follow the naming convention LefttypeToRighttype (e.g. NumberToString). 

TypeConverters support the notion of an undefined or null value for both left and right value types. The ''null'' value for one side is mapped to the ''null'' value for the other side and vice versa, without going through the normal conversion process. For example text converters will map nil from the left subject value to the empty string display value.

Instance Variables:
	leftNullValue	<Object> or nil, to which the right null value is mapped by a right to left conversion.
	rightNullValue 	<Object> or nil, to which the left null value is mapped by a left to right conversion.



'!
!UI.TypeConverter categoriesForClass!MVP-Type Converters-Abstract! !
!UI.TypeConverter methodsFor!

convertFromLeftToRight: anObject 
	"Converts the <Object> argument, which is assumed to be of the receivers left type
	(possibly its null value) to an <Object> of the receiver's right type (possibly its null
	value), and answers the resulting right value."

	(self isLeftNullValue: anObject) ifTrue: [^self rightNullValue].
	^self leftToRight: anObject!

convertFromRightToLeft: anObject 
	"Converts anObject, which is assumed to be of the receivers right type to an object
	of the receivers left type. If anObject is an exceptional value it will be converted to the 
	receiver's equivalent for the right hand side. Answers the result of the conversion."

	(self isRightNullValue: anObject) ifTrue: [^self leftNullValue].
	^self rightToLeft: anObject!

inverted
	"Answers a type converter that reverses the direction of the receiver's conversion. 
	In this case answers an instance of InvertingConverter that wraps the receiver"

	^InvertingConverter inverting: self!

isLeftNullValue: anObject 
	"Private - Answers whether the argument can be considered the 'null' value 
	for the left hand side value type."

	^anObject = self leftNullValue!

isRightNullValue: anObject 
	"Private - Answers whether the argument can be considered the 'null' value 
	for the left hand side value type."

	^anObject = self rightNullValue!

leftNullValue
	"Answer the 'null' value of the left type."

	^leftNullValue!

leftNullValue: anObject 
	"Set the 'null' value of the left type to the argument."

	leftNullValue := anObject!

leftToRight: anObject
	"Private - Converts the <Object> argument, which is assumed to be of the receivers left 
	type to an <Object> of the receiver's right type. Answers the result of the conversion. 
	Must be overridden by subclasses to perform specific conversions."

	^self subclassResponsibility!

rightNullValue
	"Answer the 'null' value of the right type."

	^rightNullValue!

rightNullValue: anObject 
	"Set the 'null' value of the right type to the argument."

	rightNullValue := anObject!

rightToLeft: anObject
	"Private - Converts the <Object> argument, which is assumed to be of the receivers right 
	type to an <Object> of the receivers left type. Answers the result of the conversion. 
	Must be overridden by subclasses to perform specific conversions"

	^self subclassResponsibility! !
!UI.TypeConverter categoriesFor: #convertFromLeftToRight:!converting!public! !
!UI.TypeConverter categoriesFor: #convertFromRightToLeft:!converting!public! !
!UI.TypeConverter categoriesFor: #inverted!operations!public! !
!UI.TypeConverter categoriesFor: #isLeftNullValue:!private!testing! !
!UI.TypeConverter categoriesFor: #isRightNullValue:!private!testing! !
!UI.TypeConverter categoriesFor: #leftNullValue!accessing!public! !
!UI.TypeConverter categoriesFor: #leftNullValue:!accessing!public! !
!UI.TypeConverter categoriesFor: #leftToRight:!operations!private! !
!UI.TypeConverter categoriesFor: #rightNullValue!accessing!public! !
!UI.TypeConverter categoriesFor: #rightNullValue:!accessing!public! !
!UI.TypeConverter categoriesFor: #rightToLeft:!operations!private! !

UI.TypeConverter methodProtocol: #typeConverter attributes: #(#readOnly) selectors: #(#convertFromLeftToRight: #convertFromRightToLeft: #inverted #leftNullValue #leftNullValue: #rightNullValue #rightNullValue:)!

!UI.TypeConverter class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

new
	"Answer a new instance of the receiver. Instances require initialization"

	^super new initialize! !
!UI.TypeConverter class categoriesFor: #icon!constants!public! !
!UI.TypeConverter class categoriesFor: #new!instance creation!public! !

