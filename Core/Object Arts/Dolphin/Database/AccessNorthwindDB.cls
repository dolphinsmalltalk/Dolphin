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
	^'DRIVER={Microsoft Access Driver (*.mdb)};DBQ=<1s>' expandMacrosWith: filename

!

createDatabase
	| source |
	source := (PackageRelativeFileLocator package: self class owningPackage) localFileSpecFor: 'Northwind.mdb'.
	filename := File composePath: File tempPath subPath: 'Northwind.mdb'.
	File copy: source to: filename.
	(File isWriteable: filename) ifFalse: [File isWriteable: filename set: true].
	^true!

dropDatabase
	super dropDatabase.
	KernelLibrary default deleteFile: filename!

filename
	^filename! !

!AccessNorthwindDB categoriesForMethods!
connectString!accessing!private! !
createDatabase!operations!private! !
dropDatabase!operations!private! !
filename!accessing!public! !
!

