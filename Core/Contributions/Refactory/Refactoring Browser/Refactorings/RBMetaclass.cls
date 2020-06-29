"Filed out from Dolphin Smalltalk 7"!

RBAbstractClass subclass: #RBMetaclass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RBMetaclass guid: (GUID fromString: '{cf1618c4-6ee9-418d-9fd0-21e81860e79b}')!
RBMetaclass comment: 'RBMetaclass represents a Metaclass.
'!
!RBMetaclass categoriesForClass!Refactory-Model! !
!RBMetaclass methodsFor!

allClassVariableNames
	^self nonMetaclass allClassVariableNames!

allPoolDictionaryNames
	^self nonMetaclass allPoolDictionaryNames!

directlyDefinesClassVariable: aString 
	^self nonMetaclass directlyDefinesClassVariable: aString!

directlyDefinesPoolDictionary: aString 
	^self nonMetaclass directlyDefinesPoolDictionary: aString!

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
!RBMetaclass categoriesFor: #allClassVariableNames!accessing!public! !
!RBMetaclass categoriesFor: #allPoolDictionaryNames!accessing!public! !
!RBMetaclass categoriesFor: #directlyDefinesClassVariable:!public!testing! !
!RBMetaclass categoriesFor: #directlyDefinesPoolDictionary:!public!testing! !
!RBMetaclass categoriesFor: #isMeta!public!testing! !
!RBMetaclass categoriesFor: #metaclass!accessing!public! !
!RBMetaclass categoriesFor: #printOn:!printing!public! !
!RBMetaclass categoriesFor: #realName:!initialize/release!public! !
!RBMetaclass categoriesFor: #storeOn:!printing!public! !

!RBMetaclass class methodsFor!

existingNamed: aSymbol 
	^(self named: aSymbol)
		realName: aSymbol;
		yourself!

named: aSymbol 
	^(self new)
		name: aSymbol;
		yourself! !
!RBMetaclass class categoriesFor: #existingNamed:!instance creation!public! !
!RBMetaclass class categoriesFor: #named:!instance creation!public! !

