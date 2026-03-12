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
	^'DRIVER={<1s>};DBQ=<2s>' << { self odbcDriver. self filename asString }!

createDatabase
	| mdb |
	mdb := self filename.
	(self class owningPackage fileLocator resolve: 'Northwind.mdb') copyTo: mdb.
	mdb isWriteable ifFalse: [mdb isWriteable: true].
	^true!

dropDatabase
	super dropDatabase.
	(filename notNil and: [filename exists]) ifTrue: [filename delete]!

filename
	^filename ifNil: [filename := Path tempDirectory \ 'Northwind.mdb']!

getOdbcDriver
	^'Microsoft Access Driver (*.mdb)'! !

!Database.Tests.AccessNorthwindDB categoriesForMethods!
connectString!accessing!private! !
createDatabase!operations!private! !
dropDatabase!operations!private! !
filename!accessing!public! !
getOdbcDriver!constants!private! !
!

