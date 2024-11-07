"Filed out from Dolphin Smalltalk"!

Database.Tests.DBConnectionTestResource
	subclass: #'Database.Tests.AccessNorthwindDB'
	instanceVariableNames: 'filename'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.Tests.AccessNorthwindDB guid: (Core.GUID fromString: '{65bcf4a5-dc5c-461b-a4df-2f29574d34c3}')!

Database.Tests.AccessNorthwindDB comment: ''!

!Database.Tests.AccessNorthwindDB methodsFor!

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

odbcDriver
	^'Microsoft Access Driver (*.mdb)'! !

!Database.Tests.AccessNorthwindDB categoriesForMethods!
connectString!accessing!private! !
createDatabase!operations!private! !
dropDatabase!operations!private! !
filename!accessing!public! !
odbcDriver!constants!private! !
!

