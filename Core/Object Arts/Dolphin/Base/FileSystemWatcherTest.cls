"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #FileSystemWatcherTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileSystemWatcherTest guid: (GUID fromString: '{4566F591-6075-495A-9A86-EE91C2D7BF3A}')!
FileSystemWatcherTest comment: ''!
!FileSystemWatcherTest categoriesForClass!Unclassified! !
!FileSystemWatcherTest methodsFor!

testEvents
	| watcher |
	watcher := FileSystemWatcher monitorDirectory: SessionManager current imageBase.
	watcher when: #fileModified: send: #bell to: Sound.

! !
!FileSystemWatcherTest categoriesFor: #testEvents!public!unit tests! !

