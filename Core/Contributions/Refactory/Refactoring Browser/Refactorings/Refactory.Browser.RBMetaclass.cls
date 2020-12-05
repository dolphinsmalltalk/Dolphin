"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RBAbstractClass subclass: #'Refactory.Browser.RBMetaclass'
	instanceVariableNames: ''
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

directlyDefinesClassVariable: aString 
	^self nonMetaclass directlyDefinesClassVariable: aString!

directlyImportsNamespace: aString
	^self nonMetaclass directlyImportsNamespace: aString!

fullyQualifiedReference
	"Answer a <BindingReference> to this class."

	^self soleInstance fullyQualifiedReference meta!

isMeta
	^true!

metaclass
	^self!

printOn: aStream
	super printOn: aStream.
	aStream nextPutAll: ' class'!

realName: aSymbol 
	self realClass: aSymbol asQualifiedReference value class!

storeOn: aStream 
	super storeOn: aStream.
	aStream nextPutAll: ' class'! !
!Refactory.Browser.RBMetaclass categoriesFor: #allClassVariableNames!accessing!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #allImports!accessing!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #directlyDefinesClassVariable:!public!testing! !
!Refactory.Browser.RBMetaclass categoriesFor: #directlyImportsNamespace:!public!testing! !
!Refactory.Browser.RBMetaclass categoriesFor: #fullyQualifiedReference!converting!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #isMeta!public!testing! !
!Refactory.Browser.RBMetaclass categoriesFor: #metaclass!accessing!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #printOn:!printing!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #realName:!initialize/release!public! !
!Refactory.Browser.RBMetaclass categoriesFor: #storeOn:!printing!public! !

!Refactory.Browser.RBMetaclass class methodsFor!

existing: aBehavior
	| meta class |
	class := aBehavior instanceClass.
	meta := class class.
	^(self named: class fullName)
		realClass: meta;
		yourself! !
!Refactory.Browser.RBMetaclass class categoriesFor: #existing:!instance creation!public! !

