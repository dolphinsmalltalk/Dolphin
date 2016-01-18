"Filed out from Dolphin Smalltalk 7"!

DictionaryTest subclass: #LookupTableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LookupTableTest guid: (GUID fromString: '{5C366850-2830-493E-A387-2A621F4BC8B2}')!
LookupTableTest comment: ''!
!LookupTableTest categoriesForClass!Unclassified! !
!LookupTableTest methodsFor!

collectionClass
	^LookupTable!

testStrongTalkTests
	"These are the StrongTalk tests from Dictionary class>>test. One of these fails for
	Dictionary itself because it assumes that a copy of the Dictionary also copies all the
	associations (perhaps it should)."

	| d new oc |
	d := self collectionClass new.
	(d respondsTo: #removeAssociation:ifAbsent:) ifFalse: [^self].
	d at: #this put: #that.
	self assert: (d at: #this) = #that.
	new := false.
	d at: #this
		ifAbsentPut: 
			[new := true.
			#that].
	self checkValidity: d.
	self assert: new not.
	d at: #hi
		ifAbsentPut: 
			[new := true.
			#there].
	self checkValidity: d.
	self assert: new.
	oc := OrderedCollection new.
	d keysAndValuesDo: [:k :v | oc add: k -> v].
	self assert: (oc size = 2 and: [oc noDifference: d associations]).
	d add: #hi -> #mom.
	self checkValidity: d.
	self assert: (d associationAt: #hi) value = #mom.
	self assert: (d includesAssociation: #hi -> #mom).
	self assert: (d includesAssociation: #yo -> #momma) not.
	self checkValidity: ((d copy)
				at: #hi put: #there;
				yourself).
	self checkValidity: d.
	self assert: (d at: #hi) = #mom.
	new := false.
	d removeAssociation: #this -> #that ifAbsent: [new := true].
	self checkValidity: d.
	self assert: (d includesKey: #this) not & new not.
	d removeAssociation: #bubba -> #that ifAbsent: [new := true].
	self checkValidity: d.
	self assert: new! !
!LookupTableTest categoriesFor: #collectionClass!helpers!private! !
!LookupTableTest categoriesFor: #testStrongTalkTests!benchmarking!public! !

