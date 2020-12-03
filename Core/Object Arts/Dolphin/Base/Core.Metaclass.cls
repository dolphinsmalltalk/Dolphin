"Filed out from Dolphin Smalltalk 7"!

Core.ClassDescription subclass: #'Core.Metaclass'
	instanceVariableNames: 'instanceClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Metaclass guid: (Core.GUID fromString: '{87b4c4fc-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Metaclass comment: 'Metaclass is the class of objects which represent the classes of the Classes of the system.
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
!Core.Metaclass categoriesForClass!Kernel-Classes! !
!Core.Metaclass methodsFor!

absoluteReference
	^self instanceClass absoluteReference meta!

asQualifiedReference
	"Answer a <BindingReference> to this class."

	^self instanceClass fullyQualifiedReference meta!

bindingFor: aString 
	"Answer a variable binding for the named variable in the scope of this class. 
	If there is no such variable, then answer nil."

	^self instanceClass bindingFor: aString!

classBindingNames
	"Answer a Set of the class variable names of the receiver."

	^Set new!

classPool
	"Answer the dictionary of class variables."

	^instanceClass classPool!

classVariables
	"Answer the dictionary of class variables."

	^instanceClass classVariables!

comment
	"Answer the class comment for the receiver."

	^self instanceClass comment
!

comment: aString
	"Set the class comment for the receiver to aString."

	self instanceClass comment: aString
!

environment
	"Answer the receiver's name space."

	^self instanceClass environment!

fullName
	"Answer the <String> fully qualified name of the receiver, which is a dot-separated path that binds to the receiver from the global namespace, Root.
	Note that these names will also be bindable within the legacy Smalltalk namespace, because it is itself an immediate child of root, and so any of its siblings is bindable using that sibling's unqualified name."

	^self instanceClass fullName, ' class'!

fullyQualifiedReference
	"Answer a <BindingReference> that represents a fully qualified reference to the receiver relative to Smalltalk. If the Class is not in the hierarchy below Smalltalk (i.e. it is in Root, or another namespace hierarchy under Root), then it will be an absolute binding reference.
	This will be a meta-binding reference, the value of which is this Metaclass."

	^self instanceClass fullyQualifiedReference meta!

importedNamespacesDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the namespaces imported by the receiver."

	self instanceClass importedNamespacesDo: aMonadicValuable!

imports
	"Answer a <sequencedReadableCollection> of the <Namespaces> imported into the receiver's scope."

	^self instanceClass imports!

imports: anArray
	self instanceClass imports: anArray!

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
		ifFalse: 
			[ClassBuilder new
				class: self;
				superclass: superclass;
				instanceSpec: instanceSpec;
				instanceVariableString: classInstVars;
				modifyExistingClass]!

isAnonymous
	"Answer whether this is an anonymous (unbound) class."

	^self instanceClass isAnonymous!

isMeta
	"Answer whether the receiver is a <Metaclass>."

	^true!

localBindingFor: aString
	"Answer a variable binding for the named variable directly in the scope of this class, i.e. one of its own class variables. If there is no such class variable, then answer nil."

	^self instanceClass localBindingFor: aString!

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

packageManager
	^self instanceClass packageManager!

printDefinitionOn: target
	"Private - Append the textual definition of the receiver to the <puttableStream>, target."

	self printFullNameOn: target.
	target
		space;
		display: #instanceVariableNames:;
		space;
		print: self instanceVariableString!

printFullNameOn: aPuttableStream
	self instanceClass printFullNameOn: aPuttableStream.
	aPuttableStream nextPutAll: ' class'!

printOn: aStream
	"Append the name of the receiver to aStream."

	aStream
		print: self instanceClass;
		nextPutAll: ' class'!

removeClassVarName: aString 
	"Remove the class variable from the receiver with the specified <readableString> name."

	^self instanceClass removeClassVarName: aString!

removeFromSuper
	"Private - Remove the receiver from its superclasses' subclass collection.
	Root Metaclasses will have a superclass of Class - we do not put such
	classes into Class's subclass collection."

	^superclass ~~ Class ifTrue: [super removeFromSuper]!

shortName
	^self instanceClass shortName, ' class'!

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler saveObject: self as: (STBMetaclassProxy forClass: self)!

subclassesDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's subclasses."

	instanceClass ifNotNil: [instanceClass subclassesDo: [:each | aMonadicValuable value: each class]]! !
!Core.Metaclass categoriesFor: #absoluteReference!public! !
!Core.Metaclass categoriesFor: #asQualifiedReference!converting!public! !
!Core.Metaclass categoriesFor: #bindingFor:!binding!public! !
!Core.Metaclass categoriesFor: #classBindingNames!class variables!public! !
!Core.Metaclass categoriesFor: #classPool!class variables!public! !
!Core.Metaclass categoriesFor: #classVariables!class variables!public! !
!Core.Metaclass categoriesFor: #comment!accessing!public! !
!Core.Metaclass categoriesFor: #comment:!accessing!public! !
!Core.Metaclass categoriesFor: #environment!accessing!public! !
!Core.Metaclass categoriesFor: #fullName!accessing!namespaces!public! !
!Core.Metaclass categoriesFor: #fullyQualifiedReference!accessing!public! !
!Core.Metaclass categoriesFor: #importedNamespacesDo:!pool variables!public! !
!Core.Metaclass categoriesFor: #imports!pool variables!public! !
!Core.Metaclass categoriesFor: #imports:!pool variables!public! !
!Core.Metaclass categoriesFor: #instanceClass!accessing!public! !
!Core.Metaclass categoriesFor: #instanceClass:!accessing!private! !
!Core.Metaclass categoriesFor: #instanceVariableNames:!class hierarchy-mutating!instance variables!public! !
!Core.Metaclass categoriesFor: #isAnonymous!public!testing! !
!Core.Metaclass categoriesFor: #isMeta!public!testing! !
!Core.Metaclass categoriesFor: #localBindingFor:!binding!public! !
!Core.Metaclass categoriesFor: #name!accessing!public! !
!Core.Metaclass categoriesFor: #new!instance creation!public! !
!Core.Metaclass categoriesFor: #owningPackage!accessing!development!public! !
!Core.Metaclass categoriesFor: #packageManager!development!public!source filing! !
!Core.Metaclass categoriesFor: #printDefinitionOn:!private!source filing-class definition! !
!Core.Metaclass categoriesFor: #printFullNameOn:!helpers!private! !
!Core.Metaclass categoriesFor: #printOn:!printing!public! !
!Core.Metaclass categoriesFor: #removeClassVarName:!class variables!public! !
!Core.Metaclass categoriesFor: #removeFromSuper!class hierarchy-removing!private! !
!Core.Metaclass categoriesFor: #shortName!public! !
!Core.Metaclass categoriesFor: #stbSaveOn:!binary filing!public! !
!Core.Metaclass categoriesFor: #subclassesDo:!class hierarchy-accessing!public! !

