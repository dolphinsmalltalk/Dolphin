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

	^self nonMetaclass unqualifiedName! !
!Refactory.Browser.RBMetaclass categoriesFor: #allClassVariableNames!accessing!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #allImports!accessing!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #classBindingNames!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #directlyDefinesClassVariable:!public!testing! !
!Refactory.Browser.RBMetaclass categoriesFor: #directlyImportsNamespace:!public!testing! !
!Refactory.Browser.RBMetaclass categoriesFor: #environment!accessing!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #fullyQualifiedReference!converting!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #isMeta!public!testing! !
!Refactory.Browser.RBMetaclass categoriesFor: #localBindingFor:!binding!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #metaclass!accessing!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #nonMetaclass!accessing!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #nonMetaclass:!accessing!initializing!private! !
!Refactory.Browser.RBMetaclass categoriesFor: #printOn:!printing!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #realName:!initialize/release!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #storeOn:!printing!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #unqualifiedName!accessing!public! !

!Refactory.Browser.RBMetaclass class methodsFor!

existing: aBehavior
	| meta class |
	class := aBehavior instanceClass.
	meta := class class.
	^(self named: class fullName)
		realClass: meta;
		yourself! !
!Refactory.Browser.RBMetaclass class categoriesFor: #existing:!instance creation!public! !

