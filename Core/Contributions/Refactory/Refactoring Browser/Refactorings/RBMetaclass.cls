"Filed out from Dolphin Smalltalk 2000 release 4.01"!

RBAbstractClass subclass: #RBMetaclass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBMetaclass comment: 'RBMetaclass represents a Metaclass.
'!

RBMetaclass guid: (GUID fromString: '{CF1618C4-6EE9-418D-9FD0-21E81860E79B}')!

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
	self realClass: (Smalltalk at: aSymbol) class!

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

