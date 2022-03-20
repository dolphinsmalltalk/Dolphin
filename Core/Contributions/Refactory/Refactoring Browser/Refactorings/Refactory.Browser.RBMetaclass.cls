"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBAbstractClass subclass: #'Refactory.Browser.RBMetaclass'
	instanceVariableNames: 'nonMetaclass'
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
	^nonMetaclass allClassVariableNames!

allImports
	^nonMetaclass allImports!

baseEnvironment
	"Private - Answer the default environment for new subclasses of the receiver that the ClassBuilder should use when the provided subclass name is unqualified."

	^nonMetaclass baseEnvironment!

basicEnvironment
	^nonMetaclass basicEnvironment!

bindingOrNil
	"Resolve the binding for the receiver's real class, if any. The name is always a fully qualified name"

	^self globalScope fullBindingFor: self name!

classBindingNames
	^nonMetaclass classBindingNames!

directlyDefinesClassVariable: aString
	^nonMetaclass directlyDefinesClassVariable: aString!

directlyImportsNamespace: aString
	^nonMetaclass directlyImportsNamespace: aString!

environment
	^nonMetaclass environment!

fullName
	"Answer the <String> fully qualified name of the receiver, which is a dot-separated path that binds to the receiver from the global namespace, Root.
	Note that these names will also be bindable within the legacy Smalltalk namespace, because it is itself an immediate child of root, and so any of its siblings is bindable using that sibling's unqualified name."

	^nonMetaclass fullName , ' class'!

fullyQualifiedReference
	"Answer a <BindingReference> to this class."

	^nonMetaclass fullyQualifiedReference meta!

isDefined
	^nonMetaclass isDefined!

isMeta
	^true!

localBindingFor: aString
	"Answer a variable binding for the named variable directly in the scope of this class, i.e. one of its own class variables. If there is no such class variable, then answer nil."

	^nonMetaclass localBindingFor: aString!

localScope
	^nonMetaclass!

metaclass
	^self!

model
	^nonMetaclass model!

name
	"Answer the name of the non-metaclass. Note that in Dolphin 8 this is always a fully-qualified name."

	^nonMetaclass name!

nearestRealClass
	^nonMetaclass nearestRealClass!

nonMetaclass
	^nonMetaclass!

nonMetaclass: aRBClass
	nonMetaclass := aRBClass!

printOn: aStream
	super printOn: aStream.
	aStream nextPutAll: ' class'!

realClass
	^nonMetaclass realClass ifNotNil: [:realClass | realClass class]!

shortName
	^nonMetaclass shortName , ' class'!

storeOn: aStream 
	super storeOn: aStream.
	aStream nextPutAll: ' class'!

subclasses
	^nonMetaclass metaSubclasses!

superclass
	^nonMetaclass superclass
		ifNil: [self model instanceClassFor: Class]
		ifNotNil: [:superclass | superclass metaclass]!

unqualifiedName
	"Answer the unqualified name of the class."

	^nonMetaclass unqualifiedName , ' class'! !
!Refactory.Browser.RBMetaclass categoriesForMethods!
allClassVariableNames!accessing!public! !
allImports!accessing!public! !
baseEnvironment!constants!private! !
basicEnvironment!accessing!public! !
bindingOrNil!bindings!public! !
classBindingNames!accessing!public! !
directlyDefinesClassVariable:!public!testing! !
directlyImportsNamespace:!public!testing! !
environment!accessing!public! !
fullName!converting!public! !
fullyQualifiedReference!converting!public! !
isDefined!public!testing! !
isMeta!public!testing! !
localBindingFor:!binding!public! !
localScope!accessing!public! !
metaclass!accessing!public! !
model!accessing!public! !
name!accessing!public! !
nearestRealClass!accessing!private! !
nonMetaclass!accessing!public! !
nonMetaclass:!accessing!initializing!private! !
printOn:!printing!public! !
realClass!accessing!public! !
shortName!public! !
storeOn:!printing!public! !
subclasses!accessing!public! !
superclass!accessing!public! !
unqualifiedName!accessing!public! !
!

