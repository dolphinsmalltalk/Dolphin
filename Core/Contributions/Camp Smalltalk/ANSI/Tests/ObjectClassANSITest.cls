"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #ObjectClassANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ObjectClassANSITest guid: (GUID fromString: '{940ea47e-d8e2-451c-ae00-4af396683bbb}')!
ObjectClassANSITest comment: ''!
!ObjectClassANSITest categoriesForClass!Unclassified! !
!ObjectClassANSITest methodsFor!

canonicalObject
	^Object!

protocol
	^#'Object class'!

testXallSubclasses
	" <classDescription>#allSubclasses "

	#Fundamental.
	"	Each element of the result collection supports the protocol <classDescription>."
	#todo.	"can't tell of a class that must be present in ANSI ???"
	self 
		value: [Number allSubclasses]
		should: 
			[:r | 
			(r allSatisfy: [:element | element class conformsToAnsiProtocolNamed: #classDescription]) 
				& r isEmpty not]
		conformTo: #classDescription
		selector: #allSubclasses.
	self 
		value: [Symbol allSubclasses]
		should: 
			[:r | 
			r allSatisfy: [:element | element class conformsToAnsiProtocolNamed: #classDescription]]
		conformTo: #classDescription
		selector: #allSubclasses!

testXallSuperclasses
	" <classDescription>#allSuperclasses "

	#Fundamental.
	"	Each element of the result collection supports the protocol <classDescription>."
	#todo.	"can't tell of a class that must be present in ANSI ???"
	self 
		value: [Fraction allSuperclasses]
		should: 
			[:r | 
			(r allSatisfy: [:element | element class conformsToAnsiProtocolNamed: #classDescription]) 
				& r isEmpty not]
		conformTo: #classDescription
		selector: #allSuperclasses.
	self 
		value: [Object allSuperclasses]
		should: 
			[:r | 
			r allSatisfy: [:element | element class conformsToAnsiProtocolNamed: #classDescription]]
		conformTo: #classDescription
		selector: #allSuperclasses!

testXname
	" <classDescription>#name "
	#'Fundamental'.
	self value: [Object name] should: [:r | r asString = 'Object']
		conformTo: #'classDescription' selector: #'name'.!

testXnew
	" <Object class>#new "
	#'Fundamental'.
	self value: [Object new] should: [:r | r class = Object]
		conformTo: #'Object class' selector: #'new'.!

testXsubclasses
	"2000/06/23 Harmon, R. Changed to fix missing class in second test."

	self 
		value: [Number subclasses]
		should: 
			[:r | 
			(r allSatisfy: [:element | element class conformsToAnsiProtocolNamed: #classDescription]) 
				& r isEmpty not]
		conformTo: #classDescription
		selector: #subclasses.
	self 
		value: [Symbol subclasses]
		should: 
			[:r | 
			r allSatisfy: [:element | element class conformsToAnsiProtocolNamed: #classDescription]]
		conformTo: #classDescription
		selector: #subclasses!

testXsuperclass
	" <classDescription>#superclass "

	#Fundamental.
	"	If the receiver is a class object, return the class objects defined by the class definitions from which the class definition of the receiver directly inherits.  If the class definition of the receiver has no superclasses, return nil."
	#Fundamental.
	self 
		value: [Fraction superclass]
		should: 
			[:r | 
			r isNil 
				ifTrue: [r conformsToAnsiProtocolNamed: #classDescription]
				ifFalse: [r class conformsToAnsiProtocolNamed: #classDescription]]
		conformTo: #classDescription
		selector: #superclass.
	self 
		value: [Object superclass]
		should: 
			[:r | 
			r isNil 
				ifTrue: [r class class conformsToAnsiProtocolNamed: #classDescription]
				ifFalse: [r class conformsToAnsiProtocolNamed: #classDescription]]
		conformTo: #classDescription
		selector: #superclass! !
!ObjectClassANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
testXallSubclasses!public! !
testXallSuperclasses!public! !
testXname!public! !
testXnew!public! !
testXsubclasses!public! !
testXsuperclass!public! !
!

