"Filed out from Dolphin Smalltalk 7"!

Database.Tests.DBConnectionTestResource subclass: #'Database.Tests.AccessNorthwindDB'
	instanceVariableNames: 'filename'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Database.Tests.AccessNorthwindDB guid: (Core.GUID fromString: '{65bcf4a5-dc5c-461b-a4df-2f29574d34c3}')!
Database.Tests.AccessNorthwindDB comment: ''!
!Database.Tests.AccessNorthwindDB categoriesForClass!Unclassified! !
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
	File delete: filename! !
!Database.Tests.AccessNorthwindDB categoriesFor: #connectString!private! !
!Database.Tests.AccessNorthwindDB categoriesFor: #createDatabase!private! !
!Database.Tests.AccessNorthwindDB categoriesFor: #dropDatabase!private! !

