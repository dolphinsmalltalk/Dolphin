"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBVersionDescriptor
	instanceVariableNames: 'versionNumber readVersionNumber topVersionNumber committingTransactions myCommits'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBVersionDescriptor guid: (GUID fromString: '{8162EDE9-0FB8-11D4-B091-000000000000}')!
ODBVersionDescriptor comment: ''!
!ODBVersionDescriptor categoriesForClass!No category! !
!ODBVersionDescriptor methodsFor!

= anObject 
	anObject class == self class ifFalse: [^false].
	^topVersionNumber == anObject topVersionNumber 
		and: [committingTransactions size == anObject committingTransactions size]!

committingTransactions
	^committingTransactions!

copy
	^self class new 
		topVersionNumber: topVersionNumber
		readVersionNumber: readVersionNumber
		committingTransactions: committingTransactions!

fromVersionTable: aByteArray 
	"Private - Initialize receiver."

	| i vn size |
	topVersionNumber := aByteArray odbLongAt: 1.
	readVersionNumber := topVersionNumber.
	committingTransactions := OrderedCollection new.
	i := 5.
	size := aByteArray size.
	[i < size] whileTrue: 
			[(vn := aByteArray odbLongAt: i) == 0 
				ifFalse: 
					[committingTransactions add: vn.
					vn <= readVersionNumber ifTrue: [readVersionNumber := vn - 1]].
			i := i + 4]!

topVersionNumber
	^topVersionNumber!

topVersionNumber: tvn readVersionNumber: rvn committingTransactions: ct 
	"Private - Initialize receiver variables."

	topVersionNumber := tvn.
	readVersionNumber := rvn.
	committingTransactions := ct asArray!

versionAtStartOK: aVersionNumber 
	"Answer true if object with aVersionNumber can be read. 
	Current transaction commits are ignored."

	aVersionNumber <= readVersionNumber ifTrue: [^true].
	aVersionNumber <= topVersionNumber ifFalse: [^false].
	^(committingTransactions includes: aVersionNumber) not!

versionNumber
	"Answer version number for read-write transactions."

	^versionNumber!

versionNumber: anInteger 
	"Private - Set version number."

	| index |
	(versionNumber := anInteger) isNil 
		ifFalse: 
			[myCommits isNil ifTrue: [myCommits := OrderedCollection new: 4].
			(index := committingTransactions indexOf: anInteger) == 0 
				ifFalse: [committingTransactions at: index put: -1].
			myCommits add: anInteger]!

versionOK: aVersionNumber 
	"Answer true if object with aVersionNumber can be read."

	aVersionNumber <= readVersionNumber ifTrue: [^true].
	aVersionNumber <= topVersionNumber ifTrue: [^(committingTransactions includes: aVersionNumber) not].
	myCommits isNil ifTrue: [^false].
	^myCommits includes: aVersionNumber! !
!ODBVersionDescriptor categoriesFor: #=!public! !
!ODBVersionDescriptor categoriesFor: #committingTransactions!private! !
!ODBVersionDescriptor categoriesFor: #copy!public! !
!ODBVersionDescriptor categoriesFor: #fromVersionTable:!private! !
!ODBVersionDescriptor categoriesFor: #topVersionNumber!private! !
!ODBVersionDescriptor categoriesFor: #topVersionNumber:readVersionNumber:committingTransactions:!private! !
!ODBVersionDescriptor categoriesFor: #versionAtStartOK:!public! !
!ODBVersionDescriptor categoriesFor: #versionNumber!public! !
!ODBVersionDescriptor categoriesFor: #versionNumber:!private! !
!ODBVersionDescriptor categoriesFor: #versionOK:!public! !

