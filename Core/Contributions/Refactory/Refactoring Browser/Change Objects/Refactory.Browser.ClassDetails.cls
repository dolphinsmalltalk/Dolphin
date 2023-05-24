"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Refactory.Browser.ClassDetails'
	instanceVariableNames: 'classReference superclassReference instanceVariableNames classVariableNames imports classConstants classInstanceVariableNames instanceSpec guid comment categoryNames package'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ClassDetails guid: (Core.GUID fromString: '{d1d894c3-0b6c-4f3b-b537-27deba6d9813}')!
Refactory.Browser.ClassDetails comment: ''!
!Refactory.Browser.ClassDetails categoriesForClass!Kernel-Objects! !
!Refactory.Browser.ClassDetails methodsFor!

baseEnvironment
	^self superclass ifNil: [Smalltalk] ifNotNil: [:superClass | superClass baseEnvironment]!

categories
	^self classCategories ifNil: [{ClassCategory unclassified}]!

categories: aCollection
	categoryNames := aCollection ifNotNil: [aCollection asArray collect: [:each | each asString]]!

category: anObject
	self categories: {anObject}!

categoryNames
	^categoryNames!

classCategories
	^categoryNames ifNotNil: [categoryNames collect: [:each | ClassCategory name: each]]!

classConstants
	classConstants isString ifTrue: [classConstants := Compiler evaluate: classConstants].
	^classConstants ?? #()!

classConstants: anArray
	classConstants := anArray!

classInstanceVariableNames
	^classInstanceVariableNames ?? #()!

classInstanceVariableNames: anArray
	classInstanceVariableNames := anArray!

classInstanceVariableString: aString
	classInstanceVariableNames := $\x20 split: aString!

className
	^self fullName!

className: anObject
	classReference := anObject asQualifiedReference!

classReference
	^classReference!

classVariableNames
	^classVariableNames ?? #()!

classVariableNames: anArray
	classVariableNames := anArray!

classVariableString
	^$\x20 join: (self classVariableNames , (self classConstants collect: [:each | each key])) sort!

classVariableString: aString
	classVariableNames := $\x20 split: aString!

comment
	^comment!

comment: aString
	comment := aString!

environment
	^classReference environment!

environmentName
	^self classReference environmentName ?? #Smalltalk!

fromClass: aClassDescription
	| class |
	class := aClassDescription instanceClass.
	superclassReference := class superclass
				ifNotNil: [:superclass | superclass fullyQualifiedReference].
	classReference := aClassDescription fullyQualifiedReference.
	instanceVariableNames := class instanceVariableNames.
	classVariableNames := class classVariableNames.
	imports := class imports.
	classInstanceVariableNames := class metaclass instanceVariableNames.
	classConstants := class classConstants.
	instanceSpec := class instanceSpec.
	self categories: class classCategories.
	guid := class guid.
	comment := class comment.
	package := class owningPackage.
	^self!

fullName
	^classReference asString!

guid
	^guid!

guid: anObject
	guid := anObject!

hasSpecialBehavior
	^self instanceSpec
		anyMask: ##(Behavior._IndirectMask | Behavior._NullTermMask | Behavior._NonInstantiableMask
				| Behavior._MournerMask)!

imports
	^imports ?? #()!

imports: anArray
	imports := anArray!

instanceSpec
	^instanceSpec ?? 0!

instanceSpec: anInteger
	instanceSpec := anInteger!

instanceVariableNames
	^instanceVariableNames ?? #()!

instanceVariableNames: anArray
	instanceVariableNames := anArray!

instanceVariableString
	^$\x20 join: self instanceVariableNames!

instanceVariableString: aString
	instanceVariableNames := $\x20 split: aString!

isBytes
	"Answer whether the class described by the receiver has indexable instance variables that are bytes, as opposed to pointers."

	^self isPointers not!

isBytes: aBoolean 
	self isPointers: aBoolean not!

isInBaseEnvironment
	^self environmentName = self baseEnvironment fullName!

isIndirection
	"Answer whether the class described by the receiver has instances that are actually indirect references to other objects."

	^self instanceSpec anyMask: Behavior._IndirectMask!

isIndirection: aBoolean
	"Set whether the class described by the receiver has instances that are actually indirect references to other objects."

	instanceSpec := self instanceSpec mask: Behavior._IndirectMask set: aBoolean!

isMourner
	"Answer whether the class described by the receiver has weak instances that like to grieve for the loss of their constituents."

	^self instanceSpec anyMask: Behavior._MournerMask!

isMourner: aBoolean
	"Set whether the class described by the receiver has weak instances that like to grieve for the loss of their constituents."

	instanceSpec := self instanceSpec mask: Behavior._MournerMask set: aBoolean!

isNonInstantiable
	"Answer whether the class described by the receiver is non-instantiable."

	^self instanceSpec anyMask: Behavior._NonInstantiableMask!

isNonInstantiable: aBoolean
	"Set whether the class described by the receiver should not be instantiated, e.g. it is abstract."

	instanceSpec := self instanceSpec mask: Behavior._NonInstantiableMask set: aBoolean!

isNullTerminated
	"Answer whether the class described by the receiver has byte instances with an implicit null-terminator (i.e. strings)."

	^self instanceSpec allMask: Behavior._NullTermMask!

isNullTerminated: aBoolean
	"Set whether the class described by the receiver has byte instances with an implicit null-terminator (i.e. strings)."

	instanceSpec := self instanceSpec mask: Behavior._NullTermMask set: aBoolean!

isPointers
	"Answer whether the class described by the receiver has instance variables that are pointers to other objects, as opposed to bytes."

	^self instanceSpec anyMask: Behavior._PointersMask!

isPointers: aBoolean
	"Set whether the class described by the receiver has instance variables that are pointers to other objects, as opposed to bytes."

	instanceSpec := self instanceSpec mask: Behavior._PointersMask set: aBoolean!

isVariable
	"Answer whether the class described by the receiver has indexable instance variables."

	^self instanceSpec anyMask: Behavior._VariableMask!

isVariable: aBoolean
	"Set whether the class described by the receiver has indexable instance variables."

	instanceSpec := self instanceSpec mask: Behavior._VariableMask set: aBoolean!

kindOfSubclass
	"Answer the subclassing type for the class described by the receiver."

	^self isVariable
		ifTrue: [self isPointers ifTrue: ['variableSubclass:'] ifFalse: ['variableByteSubclass:']]
		ifFalse: ['subclass:']!

kindOfSubclass: aString
	aString = 'subclass:'
		ifTrue: [self instanceSpec: Behavior._IsPointersMask]
		ifFalse: 
			[aString = 'variableSubclass:'
				ifTrue: [self instanceSpec: Behavior._IsPointersMask | Behavior._VariableMask]
				ifFalse: [self instanceSpec: Behavior._VariableMask]]!

name
	^self unqualifiedName!

package
	^package!

package: aPackage
	package := aPackage!

packageName: aString
	self package: (Package manager packageNamed: aString)!

printFullNameOn: aWriteStream
	classReference displayOn: aWriteStream!

printOn: aWriteStream
	(self sourceFilerClass on: aWriteStream) printBasicDefinitionOfClass: self!

sharedPoolNames
	^self imports collect: 
			[:each |
			(each valueOrNil ifNotNil: [:sharedPoolClass | Smalltalk oldNames lookup: sharedPoolClass])
				ifNil: [each unqualifiedName]]!

shortName
	"Answer the shortest <String> name of the receiver that is bindable from Smalltalk. i.e. for classes defined directly in Smalltalk, or in any of its imports, this will be an unqualified name. Otherwise it is the fully qualified name relative to Smalltalk."

	^self environment shortNameFor: self unqualifiedName!

sourceFilerClass
	^(self package
		ifNil: [self isInBaseEnvironment ifTrue: [Class legacySourceFilerClass]]
		ifNotNil: [:pkg | pkg sourceFilerClass]) ifNil: [Class sourceFilerClass]!

storeDetail: aSymbol value: anObject on: aStream
	anObject
		ifNotNil: 
			[aStream
				nextPutAll: aSymbol;
				space;
				store: anObject;
				nextPut: $;;
				crtab]!

storeOn: aStream
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' new';
		crtab.
	aStream
		nextPutAll: #className:;
		space;
		store: classReference;
		nextPut: $;;
		crtab.
	self
		storeDetail: #superclassName:
			value: superclassReference
			on: aStream;
		storeDetail: #instanceVariableNames:
			value: instanceVariableNames
			on: aStream;
		storeDetail: #classVariableNames:
			value: classVariableNames
			on: aStream;
		storeDetail: #imports:
			value: imports
			on: aStream;
		storeDetail: #classInstanceVariableNames:
			value: classInstanceVariableNames
			on: aStream;
		storeDetail: #classConstants:
			value: classConstants
			on: aStream;
		storeDetail: #instanceSpec:
			value: instanceSpec
			on: aStream.
	self
		storeDetail: #guid:
			value: guid
			on: aStream;
		storeDetail: #comment:
			value: comment
			on: aStream;
		storeDetail: #categories:
			value: categoryNames
			on: aStream.
	package
		ifNotNil: 
			[aStream
				nextPutAll: #packageName:;
				space;
				store: package name;
				nextPut: $;;
				crtab].
	aStream nextPutAll: 'yourself)'!

superclass
	^superclassReference
		ifNotNil: 
			[superclassReference valueOrNil
				ifNil: 
					[self class new
						className: superclassReference;
						yourself]]!

superclass: aClass
	superclassReference := aClass ifNotNil: [aClass fullyQualifiedReference]!

superclassName
	^superclassReference ifNotNil: [superclassReference pathString]!

superclassName: aString
	superclassReference := aString ifNotNil: [aString asQualifiedReference]!

superclassReference
	^superclassReference!

unqualifiedName
	^classReference path last asSymbol! !
!Refactory.Browser.ClassDetails categoriesForMethods!
baseEnvironment!accessing!public! !
categories!accessing!public! !
categories:!accessing!public! !
category:!accessing!public! !
categoryNames!accessing!public! !
classCategories!accessing!public! !
classConstants!accessing!public! !
classConstants:!accessing!public! !
classInstanceVariableNames!accessing!public! !
classInstanceVariableNames:!accessing!public! !
classInstanceVariableString:!accessing!public! !
className!accessing!public! !
className:!accessing!public! !
classReference!accessing!public! !
classVariableNames!accessing!public! !
classVariableNames:!accessing!public! !
classVariableString!accessing!public! !
classVariableString:!accessing!public! !
comment!accessing!public! !
comment:!accessing!public! !
environment!accessing!public! !
environmentName!accessing!public! !
fromClass:!initializing!private! !
fullName!accessing!public! !
guid!accessing!public! !
guid:!accessing!public! !
hasSpecialBehavior!instance specification-testing!public! !
imports!accessing!public! !
imports:!accessing!public! !
instanceSpec!accessing!public! !
instanceSpec:!accessing!public! !
instanceVariableNames!accessing!public! !
instanceVariableNames:!accessing!public! !
instanceVariableString!accessing!public! !
instanceVariableString:!accessing!public! !
isBytes!instance specification-testing!public! !
isBytes:!instance specification-accessing!public! !
isInBaseEnvironment!public!testing! !
isIndirection!instance specification-testing!public! !
isIndirection:!instance specification-accessing!public! !
isMourner!instance specification-testing!public! !
isMourner:!instance specification-accessing!public! !
isNonInstantiable!instance specification-testing!public! !
isNonInstantiable:!instance specification-accessing!public! !
isNullTerminated!instance specification-testing!public! !
isNullTerminated:!instance specification-accessing!public! !
isPointers!instance specification-testing!public! !
isPointers:!instance specification-accessing!public! !
isVariable!instance specification-testing!public! !
isVariable:!instance specification-accessing!public! !
kindOfSubclass!instance specification-accessing!public! !
kindOfSubclass:!instance specification-accessing!public! !
name!accessing!public! !
package!accessing!public! !
package:!accessing!public! !
packageName:!accessing!public! !
printFullNameOn:!printing!public! !
printOn:!printing!public! !
sharedPoolNames!accessing!public! !
shortName!accessing!public! !
sourceFilerClass!constants!private! !
storeDetail:value:on:!public!storing! !
storeOn:!public!storing! !
superclass!accessing!public! !
superclass:!accessing!public! !
superclassName!accessing!public! !
superclassName:!accessing!public! !
superclassReference!accessing!public! !
unqualifiedName!accessing!public! !
!

!Refactory.Browser.ClassDetails class methodsFor!

className: aString superclass: aClass categories: aCollection
	^self new
		className: aString;
		superclass: aClass;
		categories: aCollection;
		yourself!

fromClass: aClassDescription
	^self basicNew fromClass: aClassDescription!

new	
	^super new initialize! !
!Refactory.Browser.ClassDetails class categoriesForMethods!
className:superclass:categories:!instance creation!public! !
fromClass:!public! !
new!public! !
!

