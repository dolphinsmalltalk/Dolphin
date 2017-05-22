"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #FileSystemWatcherTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileSystemWatcherTest guid: (GUID fromString: '{4566f591-6075-495a-9a86-ee91c2d7bf3a}')!
FileSystemWatcherTest comment: ''!
!FileSystemWatcherTest categoriesForClass!Unclassified! !
!FileSystemWatcherTest methodsFor!

testEvents
	| watcher |
	watcher := FileSystemWatcher monitorDirectory: SessionManager current imageBase.
	watcher when: #fileModified: send: #bell to: Sound.

! !
!FileSystemWatcherTest categoriesFor: #testEvents!public!unit tests! !

