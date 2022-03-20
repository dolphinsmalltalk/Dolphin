"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Refactory.Browser.ClassAttributes'
	instanceVariableNames: 'className superclassName instanceVariableNames classVariableNames imports classConstants classInstanceVariableNames instanceSpec guid comment categories'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ClassAttributes guid: (Core.GUID fromString: '{d1d894c3-0b6c-4f3b-b537-27deba6d9813}')!
Refactory.Browser.ClassAttributes comment: ''!
!Refactory.Browser.ClassAttributes categoriesForClass!Kernel-Objects! !
!Refactory.Browser.ClassAttributes methodsFor!

baseEnvironment
	^Error notYetImplemented!

categories
	^categories!

categories: anObject
	categories := anObject!

category
	"Answer the <ClassCategory> of the class described by the receiver or nil if it does not have one."

	^categories notEmpty ifTrue: [categories first]!

category: anObject
	categories := {anObject}!

classConstants
	classConstants isString ifTrue: [classConstants := Compiler evaluate: classConstants].
	^classConstants!

classConstants: anArray
	classConstants := anArray!

classInstanceVariableNames
	^classInstanceVariableNames!

classInstanceVariableNames: anArray
	classInstanceVariableNames := anArray!

className
	^self fullName!

className: anObject
	className := anObject asQualifiedReference!

classVariableNames
	^classVariableNames!

classVariableNames: anArray
	classVariableNames := anArray!

comment
	^comment!

comment: anObject
	comment := anObject!

environment
	^className environment!

fullName
	^className pathString!

guid
	^guid!

guid: anObject
	guid := anObject!

imports
	^imports!

imports: anArray
	imports := anArray!

initialize
	instanceVariableNames := classVariableNames := imports := classConstants := classInstanceVariableNames := categories := #().
	instanceSpec := 0!

instanceSpec: anInteger
	instanceSpec := anInteger!

instanceVariableNames
	^instanceVariableNames!

instanceVariableNames: anObject
	instanceVariableNames := anObject!

isBytes
	"Answer whether the class described by the receiver has indexable instance variables that are bytes, as opposed to pointers."

	^self isPointers not!

isInBaseEnvironment
	^className isQualifiedName not!

isIndirection
	"Answer whether the class described by the receiver has instances that are actually indirect references to other objects."

	^instanceSpec anyMask: Behavior._IndirectMask!

isMourner
	"Answer whether the class described by the receiver has weak instances that like to grieve for the loss of their constituents."

	^instanceSpec anyMask: Behavior._MournerMask!

isNonInstantiable
	"Answer whether the class described by the receiver is non-instantiable."

	^instanceSpec anyMask: Behavior._NonInstantiableMask!

isNullTerminated
	"Answer whether the class described by the receiver has byte instances with an implicit null-terminator (i.e. strings)."

	^instanceSpec allMask: Behavior._NullTermMask!

isPointers
	"Answer whether the class described by the receiver has instance variables that are pointers to other objects, as opposed to bytes."

	^instanceSpec anyMask: Behavior._PointersMask!

isVariable
	"Answer whether the class described by the receiver has indexable instance variables."

	^instanceSpec anyMask: Behavior._VariableMask!

kindOfSubclass
	"Answer the subclassing type for the class described by the receiver."

	^self isVariable
		ifTrue: [self isBytes ifTrue: ['variableByteSubclass:'] ifFalse: ['variableSubclass:']]
		ifFalse: ['subclass:']!

kindOfSubclass: aString
	aString = 'subclass:'
		ifTrue: [instanceSpec := Behavior._IsPointersMask]
		ifFalse: 
			[aString = 'variableSubclass:'
				ifTrue: [instanceSpec := Behavior._IsPointersMask | Behavior._VariableMask]
				ifFalse: [instanceSpec := Behavior._VariableMask]]!

printFullNameOn: aWriteStream
	className displayOn: aWriteStream!

superclass
	^superclassName ifNotNil: [superclassName valueOrNil]!

superclass: aClass
	superclassName := aClass ifNotNil: [aClass fullyQualifiedReference]!

superclassName
	^superclassName ifNotNil: [superclassName pathString]!

superclassName: aString
	superclassName := aString ifNotNil: [aString asQualifiedReference]!

unqualifiedName
	^className path last asSymbol! !
!Refactory.Browser.ClassAttributes categoriesForMethods!
baseEnvironment!accessing!public! !
categories!accessing!public! !
categories:!accessing!public! !
category!categories-accessing!public! !
category:!accessing!public! !
classConstants!accessing!public! !
classConstants:!accessing!public! !
classInstanceVariableNames!accessing!public! !
classInstanceVariableNames:!accessing!public! !
className!accessing!public! !
className:!accessing!public! !
classVariableNames!accessing!public! !
classVariableNames:!accessing!public! !
comment!accessing!public! !
comment:!accessing!public! !
environment!accessing!public! !
fullName!accessing!public! !
guid!accessing!public! !
guid:!accessing!public! !
imports!accessing!public! !
imports:!accessing!public! !
initialize!initializing!private! !
instanceSpec:!accessing!public! !
instanceVariableNames!accessing!public! !
instanceVariableNames:!accessing!public! !
isBytes!instance specification-testing!public! !
isInBaseEnvironment!public!testing! !
isIndirection!instance specification-testing!public! !
isMourner!instance specification-testing!public! !
isNonInstantiable!instance specification-testing!public! !
isNullTerminated!instance specification-testing!public! !
isPointers!instance specification-testing!public! !
isVariable!instance specification-testing!public! !
kindOfSubclass!class hierarchy-testing!public! !
kindOfSubclass:!public! !
printFullNameOn:!printing!public! !
superclass!accessing!public! !
superclass:!accessing!public! !
superclassName!accessing!public! !
superclassName:!accessing!public! !
unqualifiedName!accessing!public! !
!

!Refactory.Browser.ClassAttributes class methodsFor!

fromClass: aClassDescription
	| class |
	class := aClassDescription instanceClass.
	^self basicNew
		superclass: class superclass;
		instanceSpec: class instanceSpec;
		className: aClassDescription fullName;
		instanceVariableNames: class instanceVariableNames;
		classVariableNames: class classVariableNames;
		imports: class imports;
		classInstanceVariableNames: class class instanceVariableNames;
		classConstants: class classConstants;
		categories: class categories;
		guid: class guid;
		yourself!

new	
	^super new initialize! !
!Refactory.Browser.ClassAttributes class categoriesForMethods!
fromClass:!public! !
new!public! !
!

