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
	^'DRIVER={Microsoft Access Driver (*.mdb)};DBQ=<1s>' expandMacrosWith: filename

!

createDatabase
	| source |
	source := self class owningPackage fileLocator localFileSpecFor: 'Northwind.mdb'.
	filename := File composePath: File tempPath subPath: 'Northwind.mdb'.
	File copy: source to: filename.
	(File isWriteable: filename) ifFalse: [File isWriteable: filename set: true].
	^true!

dropDatabase
	super dropDatabase.
	(File exists: filename) ifTrue: [File delete: filename]! !

!Database.Tests.AccessNorthwindDB categoriesForMethods!
connectString!private! !
createDatabase!private! !
dropDatabase!private! !
!

