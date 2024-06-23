"Filed out from Dolphin Smalltalk"!

Object subclass: #PackageBackup
	instanceVariableNames: ''
	classVariableNames: 'BackupFolder Instance'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PackageBackup guid: (GUID fromString: '{6f50fcba-c386-440d-9426-dc697024bf9c}')!

PackageBackup comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!PackageBackup categoriesForClass!IDB Goodies! !

!PackageBackup methodsFor!

backupPackage: aPackage
	| backupFilename backupFolder packageFilename |
	packageFilename := aPackage packageFileName.
	(File exists: packageFilename) ifFalse: [^self].
	backupFolder := self class backupFolder.
	File createDirectory: backupFolder.
	backupFilename := File
				composePath: backupFolder
				stem: aPackage name , ' '
						, (DateAndTime now - ##(DateAndTime year: 2024 day: 1)) asMilliseconds truncated printString
				extension: aPackage class packageExtension.
	File copy: packageFilename to: backupFilename!

free
	PackageManager current removeEventsTriggeredFor: self!

initialize
	PackageManager current
		when: #aboutToSave:
		send: #onAboutToSavePackage:
		to: self.
	^self!

onAboutToSavePackage: aPackage
	self backupPackage: aPackage! !

!PackageBackup categoriesForMethods!
backupPackage:!operations!private! !
free!finalizing!public! !
initialize!initializing!public! !
onAboutToSavePackage:!event handling!private! !
!

!PackageBackup class methodsFor!

backupFolder
	BackupFolder ifNil: [BackupFolder := self defaultBackupFolder].
	^BackupFolder!

backupFolder: aString
	BackupFolder := aString!

defaultBackupFolder
	^FileLocator imageRelative localFileSpecFor: 'Package backups'!

disable
	Instance ifNil: [^self].
	Instance free.
	Instance := nil!

enable
	Instance ifNil: [Instance := self new initialize]!

icon
	^PackageManager icon!

initialize
	Smalltalk developmentSystem registerTool: self.
	self enable!

isEnabled
	^Instance notNil!

isEnabled: aBoolean
	aBoolean ifTrue: [self enable] ifFalse: [self disable]!

publishedAspects
	^super publishedAspects
		add: (Aspect boolean: #isEnabled);
		yourself!

uninitialize
	self disable.
	Smalltalk developmentSystem unregisterTool: self! !

!PackageBackup class categoriesForMethods!
backupFolder!accessing!public! !
backupFolder:!accessing!public! !
defaultBackupFolder!constants!private! !
disable!operations!public! !
enable!operations!public! !
icon!constants!public! !
initialize!class initialization!public! !
isEnabled!public!testing! !
isEnabled:!accessing!public! !
publishedAspects!constants!public! !
uninitialize!class hierarchy-removing!public! !
!

