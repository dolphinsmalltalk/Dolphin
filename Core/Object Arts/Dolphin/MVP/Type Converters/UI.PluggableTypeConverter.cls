"Filed out from Dolphin Smalltalk 7"!

UI.TypeConverter subclass: #'UI.PluggableTypeConverter'
	instanceVariableNames: 'leftToRightBlock rightToLeftBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.PluggableTypeConverter guid: (Core.GUID fromString: '{54bed5f3-b28b-4731-9baa-db8de92bef40}')!
UI.PluggableTypeConverter comment: '<PluggableTypeConverter> is a generic <TypeConverter> that supports configurable conversions.

Instance Variables:
	leftToRightBlock		<monadicValuable> which, when evaluated against left value, yields right value
	rightToLeftBlock		<monadicValuable> which, when evaluated against right value, yields left value

'!
!UI.PluggableTypeConverter categoriesForClass!MVP-Type Converters-General! !
!UI.PluggableTypeConverter methodsFor!

leftToRight: anObject
	"Private - Converts the <Object> argument, which is assumed to be of the receivers left 
	type to an <Object> of the receiver's right type. Answers the result of the conversion."

	^leftToRightBlock value: anObject!

leftToRightBlock
	^leftToRightBlock!

leftToRightBlock: anObject
	leftToRightBlock := anObject!

rightToLeft: anObject
	"Private - Converts the <Object> argument, which is assumed to be of the receivers right 
	type to an <Object> of the receivers left type. Answers the result of the conversion."

	^rightToLeftBlock value: anObject!

rightToLeftBlock
	^rightToLeftBlock!

rightToLeftBlock: anObject
	rightToLeftBlock := anObject!

setLeftToRightBlock: leftMonadicValuable rightToLeftBlock: rightMonadicValuable
	| noop |
	noop := [:obj | obj].
	leftToRightBlock := leftMonadicValuable ?? noop.
	rightToLeftBlock := rightMonadicValuable ?? noop! !
!UI.PluggableTypeConverter categoriesFor: #leftToRight:!operations!private! !
!UI.PluggableTypeConverter categoriesFor: #leftToRightBlock!accessing!public! !
!UI.PluggableTypeConverter categoriesFor: #leftToRightBlock:!accessing!public! !
!UI.PluggableTypeConverter categoriesFor: #rightToLeft:!operations!private! !
!UI.PluggableTypeConverter categoriesFor: #rightToLeftBlock!accessing!public! !
!UI.PluggableTypeConverter categoriesFor: #rightToLeftBlock:!accessing!public! !
!UI.PluggableTypeConverter categoriesFor: #setLeftToRightBlock:rightToLeftBlock:!initializing!private! !

!UI.PluggableTypeConverter class methodsFor!

leftToRight: leftMonadicValuable rightToLeft: rightMonadicValuable 
	"Answer a new instance of the receiver that converts between values 
	in the left domain to values in the the right domain by evaluating the 
	<monadicValuable>, leftMonadicValuable, and which converts in the 
	reverse direction by evaluating the <monadicValuable>, rightMonadicValuable."

	^(super new)
		setLeftToRightBlock: leftMonadicValuable rightToLeftBlock: rightMonadicValuable;
		yourself!

new
	^self leftToRight: [:left | left] rightToLeft: [:right | right]! !
!UI.PluggableTypeConverter class categoriesFor: #leftToRight:rightToLeft:!instance creation!public! !
!UI.PluggableTypeConverter class categoriesFor: #new!public! !

