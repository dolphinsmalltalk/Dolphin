"Filed out from Dolphin Smalltalk"!

RBAbstractClass subclass: #RBMetaclass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
	self realClass: (Smalltalk at: aSymbol) class!

storeOn: aStream 
	super storeOn: aStream.
	aStream nextPutAll: ' class'! !
!RBMetaclass categoriesForMethods!
allClassVariableNames!accessing!public! !
allPoolDictionaryNames!accessing!public! !
directlyDefinesClassVariable:!public!testing! !
directlyDefinesPoolDictionary:!public!testing! !
isMeta!public!testing! !
metaclass!accessing!public! !
printOn:!printing!public! !
realName:!initialize/release!public! !
storeOn:!printing!public! !
!

!RBMetaclass class methodsFor!

existingNamed: aSymbol 
	^(self named: aSymbol)
		realName: aSymbol;
		yourself!

named: aSymbol 
	^(self new)
		name: aSymbol;
		yourself! !
!RBMetaclass class categoriesForMethods!
existingNamed:!instance creation!public! !
named:!instance creation!public! !
!

