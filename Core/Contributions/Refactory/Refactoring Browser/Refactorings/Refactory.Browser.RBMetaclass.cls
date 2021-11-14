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
	^self nonMetaclass allClassVariableNames!

allImports
	^self nonMetaclass allImports!

classBindingNames
	^self nonMetaclass classBindingNames!

directlyDefinesClassVariable: aString 
	^self nonMetaclass directlyDefinesClassVariable: aString!

directlyImportsNamespace: aString
	^self nonMetaclass directlyImportsNamespace: aString!

environment
	^self nonMetaclass environment!

fullyQualifiedReference
	"Answer a <BindingReference> to this class."

	^self nonMetaclass fullyQualifiedReference meta!

isMeta
	^true!

localBindingFor: aString
	"Answer a variable binding for the named variable directly in the scope of this class, i.e. one of its own class variables. If there is no such class variable, then answer nil."

	^self instanceClass localBindingFor: aString!

metaclass
	^self!

nonMetaclass
	^nonMetaclass!

nonMetaclass: aRBClass
	nonMetaclass := aRBClass!

printOn: aStream
	super printOn: aStream.
	aStream nextPutAll: ' class'!

realName: aSymbol 
	self realClass: aSymbol asQualifiedReference value class!

storeOn: aStream 
	super storeOn: aStream.
	aStream nextPutAll: ' class'!

unqualifiedName
	"Answer the unqualified name of the non-metaclass."

	^self nonMetaclass unqualifiedName, ' class'! !
!Refactory.Browser.RBMetaclass categoriesForMethods!
allClassVariableNames!accessing!public! !
allImports!accessing!public! !
classBindingNames!public! !
directlyDefinesClassVariable:!public!testing! !
directlyImportsNamespace:!public!testing! !
environment!accessing!public! !
fullyQualifiedReference!converting!public! !
isMeta!public!testing! !
localBindingFor:!binding!public! !
metaclass!accessing!public! !
nonMetaclass!accessing!public! !
nonMetaclass:!accessing!initializing!private! !
printOn:!printing!public! !
realName:!initialize/release!public! !
storeOn:!printing!public! !
unqualifiedName!accessing!public! !
!

!Refactory.Browser.RBMetaclass class methodsFor!

existing: aBehavior
	| meta class |
	class := aBehavior instanceClass.
	meta := class class.
	^(self named: class fullName)
		realClass: meta;
		yourself! !
!Refactory.Browser.RBMetaclass class categoriesForMethods!
existing:!instance creation!public! !
!

