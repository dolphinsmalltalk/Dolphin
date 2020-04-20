"Filed out from Dolphin Smalltalk 7"!

ClassDescription subclass: #Metaclass
	instanceVariableNames: 'instanceClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Metaclass guid: (GUID fromString: '{87b4c4fc-026e-11d3-9fd7-00a0cc3e4a32}')!
Metaclass comment: 'Metaclass is the class of objects which represent the classes of the Classes of the system.
In other words, every class in the system (e.g. Integer) is the sole instance of an instance of Metaclass
(e.g. Integer class), they are not instances of Class (which, in fact, has no instances). A class object''s 
class (a Metaclass) provides the instance specific behavior of that class (i.e. it is where the class 
methods live, whereas the instance methods live in the class object itself).

A Metaclass fulfils the role for a class object that a class object does for its instances.

The Metaclass hierarchy parallels the Class hierarchy in that if class X is a subclass of class Y, then
X class is also a subclass of Y class. The roots of the class hierarchy (e.g. Object), however, are
exceptions to this rule since Object''s superclass is nil, but Object class (i.e. the Metaclass instance of
which Object is an instance) is a subclass of Class.

Please see the Blue Book for further explanation.

Metaclass has the following instance variables:
	instanceClass	- the single instance of the Metaclass which is a Class object'!
!Metaclass categoriesForClass!Kernel-Classes! !
!Metaclass methodsFor!

addToSuper
	"Private - Add the receiver as a subclass of its superclass, but not
	if a root class."

	"Implementation Note: Identify Class as the superclass by name, as if the ClassBuilder is
	currently mutating Class, the Class variable may temporarily be pointing at the old Class
	object."

	superclass name ~~ #Class ifTrue: [super addToSuper]!

bindingFor: aString 
	"Answer a variable binding for the named variable in the scope of this class. 
	If there is no such variable, then answer nil."

	^self instanceClass bindingFor: aString!

classPool
	"Answer the dictionary of class variables."

	^instanceClass classPool!

classVariables
	"Answer the dictionary of class variables."

	^instanceClass classVariables!

classVarNames
	"Answer a Set of the class variable names of the receiver."

	^Set new!

comment
	"Answer the class comment for the receiver."

	^self instanceClass comment
!

comment: aString
	"Set the class comment for the receiver to aString."

	self instanceClass comment: aString
!

fullyQualifiedReference
	"Answer a <BindingReference> that represents a fully qualified reference to the receiver."

	^self instanceClass fullyQualifiedReference meta!

instanceClass
	"Answer the receiver's singleton instance (the actual class object)."

	^instanceClass
!

instanceClass: aClass
	"Private - Set the receiver's instance class to aClass.
	Any users of this method probably don't understand what they're doing."

	instanceClass := aClass
!

instanceVariableNames: aString 
	"Set the instance variables of the receiver (the class instance variables
	of its instance class) to those in aString - a space separated name list."

	| classInstVars |
	classInstVars := aString trimBlanks.
	^self instanceVariableString trimBlanks = classInstVars 
		ifTrue: [self]
		ifFalse: [
			ClassBuilder new
				class: self;
				superclass: superclass;
				instanceSpec: instanceSpec;
				instanceVariableString: classInstVars;
				modifyExistingClass]!

isMeta
	"Answer whether the receiver is a <Metaclass>."

	^true!

name
	"Answer a String containing the receiver name. 
	For speed code directly rather than use concatenation.
	N.B. This is NOT a global name."

	^instanceClass name, ' class'!

new
	"Answer a new instance of the receiver - there can be only one (the
	class object). Why define an instance creation method as an instance
	method? Because Metaclasses are actually the classes of classes."

	instanceClass notNil 
		ifTrue: [self error: 'There can be only one (instance of a metaclass)'].
	^instanceClass := super new!

owningPackage
	^self instanceClass owningPackage!

printDefinitionOn: target
	"Private - Append the textual definition of the receiver to the <puttableStream>, target."

	target
		nextPutAll: self name;
		space;
		display: #instanceVariableNames:;
		space;
		print: self instanceVariableString!

removeClassVarName: aString 
	"Remove the class variable from the receiver with the specified <readableString> name."

	^self instanceClass removeClassVarName: aString!

removeFromSuper
	"Private - Remove the receiver from its superclasses' subclass collection.
	Root Metaclasses will have a superclass of Class - we do not put such
	classes into Class's subclass collection."

	superclass ~~ Class
		ifTrue: [super removeFromSuper]
!

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler saveObject: self as: (STBMetaclassProxy forClass: self)! !
!Metaclass categoriesFor: #addToSuper!class hierarchy-adding!private! !
!Metaclass categoriesFor: #bindingFor:!binding!public! !
!Metaclass categoriesFor: #classPool!class variables!public! !
!Metaclass categoriesFor: #classVariables!class variables!public! !
!Metaclass categoriesFor: #classVarNames!class variables!public! !
!Metaclass categoriesFor: #comment!accessing!public! !
!Metaclass categoriesFor: #comment:!accessing!public! !
!Metaclass categoriesFor: #fullyQualifiedReference!accessing!public! !
!Metaclass categoriesFor: #instanceClass!accessing!public! !
!Metaclass categoriesFor: #instanceClass:!accessing!private! !
!Metaclass categoriesFor: #instanceVariableNames:!class hierarchy-mutating!instance variables!public! !
!Metaclass categoriesFor: #isMeta!public!testing! !
!Metaclass categoriesFor: #name!accessing!public! !
!Metaclass categoriesFor: #new!instance creation!public! !
!Metaclass categoriesFor: #owningPackage!accessing!development!public! !
!Metaclass categoriesFor: #printDefinitionOn:!private!source filing-class definition! !
!Metaclass categoriesFor: #removeClassVarName:!class variables!public! !
!Metaclass categoriesFor: #removeFromSuper!class hierarchy-removing!private! !
!Metaclass categoriesFor: #stbSaveOn:!binary filing!public! !

