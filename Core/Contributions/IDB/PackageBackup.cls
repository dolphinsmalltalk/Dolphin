"Filed out from Dolphin Smalltalk X6"!

Object subclass: #PackageBackup
	instanceVariableNames: ''
	classVariableNames: 'BackupFolder'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackageBackup guid: (GUID fromString: '{6F50FCBA-C386-440D-9426-DC697024BF9C}')!
PackageBackup comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!PackageBackup categoriesForClass!IDB Goodies! !
!PackageBackup class methodsFor!

backupFolder
	BackupFolder ifNil: [BackupFolder := self defaultBackupFolder].
	^BackupFolder!

backupFolder: anObject 
	BackupFolder := anObject!

defaultBackupFolder
	^FileLocator imageRelative localFileSpecFor: 'Package backups'!

onAboutToSavePackage: aPackage 
	aPackage savePACBackupTo: self backupFolder! !
!PackageBackup class categoriesFor: #backupFolder!accessing!public! !
!PackageBackup class categoriesFor: #backupFolder:!accessing!public! !
!PackageBackup class categoriesFor: #defaultBackupFolder!accessing!public! !
!PackageBackup class categoriesFor: #onAboutToSavePackage:!event handling!public! !

