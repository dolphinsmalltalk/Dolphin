"Filed out from Dolphin Smalltalk"!

DBConnectionTestResource subclass: #AccessNorthwindDB
	instanceVariableNames: 'filename'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AccessNorthwindDB guid: (GUID fromString: '{65bcf4a5-dc5c-461b-a4df-2f29574d34c3}')!

AccessNorthwindDB comment: ''!

!AccessNorthwindDB categoriesForClass!Unclassified! !

!AccessNorthwindDB methodsFor!

connectString
	^'DRIVER={<1s>};DBQ=<2s>' << { self odbcDriver. self filename }!

createDatabase
	| mdb |
	mdb := self filename.
	File copy: (self class owningPackage fileLocator localFileSpecFor: 'Northwind.mdb') to: mdb.
	(File isWriteable: mdb) ifFalse: [File isWriteable: mdb set: true].
	^true!

dropDatabase
	super dropDatabase.
	(filename notNil and: [File exists: filename]) ifTrue: [File delete: filename]!

filename
	^filename ifNil: [filename := File composePath: File tempPath subPath: 'Northwind.mdb']!

getOdbcDriver
	^'Microsoft Access Driver (*.mdb)'! !

!AccessNorthwindDB categoriesForMethods!
connectString!accessing!private! !
createDatabase!operations!private! !
dropDatabase!operations!private! !
filename!accessing!public! !
getOdbcDriver!constants!private! !
!

