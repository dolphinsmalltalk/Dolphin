"Filed out from Dolphin Smalltalk"!

UI.TypeConverter
	subclass: #'UI.PluggableTypeConverter'
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
	"Private - Converts the <Object> argument, which is assumed to be of the receiver's left 
	type to an <Object> of the receiver's right type. Answers the result of the conversion."

	^leftToRightBlock value: anObject!

leftToRightBlock
	^leftToRightBlock!

leftToRightBlock: anObject
	leftToRightBlock := anObject!

rightToLeft: anObject
	"Private - Converts the <Object> argument, which is assumed to be of the receiver's right 
	type to an <Object> of the receiver's left type. Answers the result of the conversion."

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

!UI.PluggableTypeConverter categoriesForMethods!
leftToRight:!operations!private! !
leftToRightBlock!accessing!public! !
leftToRightBlock:!accessing!public! !
rightToLeft:!operations!private! !
rightToLeftBlock!accessing!public! !
rightToLeftBlock:!accessing!public! !
setLeftToRightBlock:rightToLeftBlock:!initializing!private! !
!

!UI.PluggableTypeConverter class methodsFor!

leftToRight: aMonadicValuable
	"Answer a new instance of the receiver that converts between values in the left domain to values in the right domain by evaluating the <monadicValuable>, aMonadicValuable, and which always answers a nil value for the conversion in the reverse direction. This is appropriate for use with static views that do not accept input and so do not require the right-to-left conversion."

	^self leftToRight: aMonadicValuable rightToLeft: [:value | nil]!

leftToRight: leftMonadicValuable rightToLeft: rightMonadicValuable 
	"Answer a new instance of the receiver that converts between values 
	in the left domain to values in the right domain by evaluating the 
	<monadicValuable>, leftMonadicValuable, and which converts in the 
	reverse direction by evaluating the <monadicValuable>, rightMonadicValuable."

	^(super new)
		setLeftToRightBlock: leftMonadicValuable rightToLeftBlock: rightMonadicValuable;
		yourself!

new
	^self leftToRight: [:left | left] rightToLeft: [:right | right]! !

!UI.PluggableTypeConverter class categoriesForMethods!
leftToRight:!instance creation!public! !
leftToRight:rightToLeft:!instance creation!public! !
new!instance creation!public! !
!

