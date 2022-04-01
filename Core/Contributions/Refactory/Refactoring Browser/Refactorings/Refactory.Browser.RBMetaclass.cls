"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBAbstractClass subclass: #'Refactory.Browser.RBMetaclass'
	instanceVariableNames: 'instanceClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBMetaclass guid: (Core.GUID fromString: '{cf1618c4-6ee9-418d-9fd0-21e81860e79b}')!
Refactory.Browser.RBMetaclass comment: 'RBMetaclass represents a Metaclass.
'!
!Refactory.Browser.RBMetaclass categoriesForClass!Refactory-Model! !
!Refactory.Browser.RBMetaclass methodsFor!

allClassVariableNames
	^instanceClass allClassVariableNames!

baseEnvironment
	"Private - Answer the default environment for new subclasses of the receiver that the ClassBuilder should use when the provided subclass name is unqualified."

	^instanceClass baseEnvironment!

basicEnvironment
	^instanceClass basicEnvironment!

bindingOrNil
	"Resolve the binding for the receiver's real class, if any. The name is always a fully qualified name"

	^instanceClass bindingOrNil!

classPool
	"Answer the dictionary of class variables."

	^instanceClass classPool!

environment
	^instanceClass environment!

fullyQualifiedReference
	"Answer a <BindingReference> to this class."

	^instanceClass fullyQualifiedReference meta!

imports
	^instanceClass imports!

instanceClass
	^instanceClass!

instanceClass: aRBClass
	instanceClass := aRBClass!

isDefined
	^instanceClass isDefined!

isMeta
	^true!

localScope
	^instanceClass!

metaclass
	^self!

model
	^instanceClass model!

name
	"Answer the name of the non-metaclass. Note that in Dolphin 8 this is always a fully-qualified name."

	^instanceClass name, ' class'!

nearestRealClass
	^instanceClass nearestRealClass!

realClass
	^instanceClass realClass ifNotNil: [:realClass | realClass class]!

shortName
	^instanceClass shortName , ' class'!

subclasses
	^instanceClass metaSubclasses!

superclass
	^instanceClass superclass
		ifNil: [self model instanceClassFor: Class]
		ifNotNil: [:superclass | superclass metaclass]!

unqualifiedName
	"Answer the unqualified name of the class."

	^instanceClass unqualifiedName , ' class'! !
!Refactory.Browser.RBMetaclass categoriesForMethods!
allClassVariableNames!accessing!public! !
baseEnvironment!constants!private! !
basicEnvironment!accessing!public! !
bindingOrNil!bindings!public! !
classPool!class variables!public! !
environment!accessing!public! !
fullyQualifiedReference!converting!public! !
imports!accessing!public! !
instanceClass!accessing!public! !
instanceClass:!accessing!initializing!private! !
isDefined!public!testing! !
isMeta!public!testing! !
localScope!accessing!public! !
metaclass!accessing!public! !
model!accessing!public! !
name!accessing!public! !
nearestRealClass!accessing!private! !
realClass!accessing!public! !
shortName!accessing!public! !
subclasses!accessing!public! !
superclass!accessing!public! !
unqualifiedName!accessing!public! !
!

