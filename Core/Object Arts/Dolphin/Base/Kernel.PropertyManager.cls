"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.PropertyManager'
	instanceVariableNames: 'register'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.PropertyManager guid: (Core.GUID fromString: '{87b4c4ab-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.PropertyManager comment: ''!
!Kernel.PropertyManager categoriesForClass!System-Support! !
!Kernel.PropertyManager methodsFor!

initialize
	"Private - Initialize the receiver"

	register := WeakIdentityDictionary new
				haveStrongValues;
				yourself!

propertyOf: anObject at: aSymbol 
	"Answers a property value matching aSymbol for anObject"

	^self 
		propertyOf: anObject
		at: aSymbol
		ifAbsent: [anObject errorNotFound: aSymbol]!

propertyOf: anObject at: aSymbol ifAbsent: aBlock
	"Answers a property value matching aSymbol for anObject. If no such property
	exists then aBlock will be evaluated"

	^(register lookup: anObject)
		ifNil: [aBlock value]
		ifNotNil: [:properties | properties at: aSymbol ifAbsent: aBlock]!

propertyOf: anObject at: aSymbol ifAbsentPut: valueOperation
	"Answers a property value matching aSymbol for anObject. If no such property
	exists then the result of evaluating aBlock will is stored as the value of the
	property, and then answered."

	^(register at: anObject ifAbsentPutClean: [IdentityDictionary new]) at: aSymbol
		ifAbsentPut: valueOperation!

propertyOf: anObject at: aSymbol put: valueObject
	"Associates a property valueObject with the property name aSymbol for anObject.
	Answer the valueObject put."

	^(register at: anObject ifAbsentPutClean: [IdentityDictionary new]) at: aSymbol put: valueObject!

register
	^register!

removeAllPropertiesOf: anObject
	"Removes all properties for anObject"

	register removeKey: anObject ifAbsent: []
	!

removePropertyOf: anObject at: aSymbol
	"Removes a property value matching aSymbol for anObject"

	self removePropertyOf: anObject at: aSymbol ifAbsent: [anObject errorNotFound: aSymbol]
!

removePropertyOf: anObject at: aSymbol ifAbsent: aBlock
	"Removes a property value matching aSymbol for anObject. If no such property
	exists then aBlock will be evaluated"

	| propertyDict |
	propertyDict := register at: anObject ifAbsent: [^aBlock value].
	propertyDict removeKey: aSymbol ifAbsent: [^aBlock value].
	propertyDict isEmpty ifTrue: [register removeKey: anObject].
	! !
!Kernel.PropertyManager categoriesFor: #initialize!initializing!private! !
!Kernel.PropertyManager categoriesFor: #propertyOf:at:!adding!public! !
!Kernel.PropertyManager categoriesFor: #propertyOf:at:ifAbsent:!adding!public! !
!Kernel.PropertyManager categoriesFor: #propertyOf:at:ifAbsentPut:!accessing!public! !
!Kernel.PropertyManager categoriesFor: #propertyOf:at:put:!adding!public! !
!Kernel.PropertyManager categoriesFor: #register!accessing!private! !
!Kernel.PropertyManager categoriesFor: #removeAllPropertiesOf:!public!removing! !
!Kernel.PropertyManager categoriesFor: #removePropertyOf:at:!public!removing! !
!Kernel.PropertyManager categoriesFor: #removePropertyOf:at:ifAbsent:!public!removing! !

!Kernel.PropertyManager class methodsFor!

new
	"Answers an instance of the receiver; instances require initialization"

	^super new initialize! !
!Kernel.PropertyManager class categoriesFor: #new!instance creation!public! !

