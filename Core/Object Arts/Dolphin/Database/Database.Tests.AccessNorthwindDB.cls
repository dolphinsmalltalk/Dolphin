"Filed out from Dolphin Smalltalk 7"!

DBConnectionTestResource subclass: #AccessNorthwindDB
	instanceVariableNames: 'filename'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
AccessNorthwindDB guid: (Core.GUID fromString: '{65bcf4a5-dc5c-461b-a4df-2f29574d34c3}')!
AccessNorthwindDB comment: ''!
!AccessNorthwindDB categoriesForClass!Unclassified! !
!AccessNorthwindDB methodsFor!

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
!AccessNorthwindDB categoriesFor: #connectString!private! !
!AccessNorthwindDB categoriesFor: #createDatabase!private! !
!AccessNorthwindDB categoriesFor: #dropDatabase!private! !

