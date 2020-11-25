"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #IDispatchTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IDispatchTest guid: (GUID fromString: '{5f6be15f-132a-4eef-b9cb-960a4d8cab7c}')!
IDispatchTest comment: ''!
!IDispatchTest categoriesForClass!Unclassified! !
!IDispatchTest methodsFor!

testDisplayOn
	self assert: ((IDispatch createObject:'Scripting.FileSystemObject') displayString = 'a FileSystemObject').
	self assert: ((IDispatch createObject:'Scripting.FileSystemObject') drives displayString beginsWith: 'an OrderedCollection(').!

testDNU
	| fs dict path ts |
	fs := IDispatch createObject: 'Scripting.FileSystemObject'.
	"propget and indexed propget"
	self assert: (fs drives item: 'C:') displayString = 'C:'.
	"2 arg method call"
	path := fs buildPath: File tempPath name: 'IDispatchTest_testDNU.txt'.
	"3 arg method call"
	ts := fs 
				createTextFile: path
				overwrite: true
				unicode: false.
	"One arg method call"
	ts writeLine: 'Blah blah blah'.
	"Zero arg method call"
	ts close.
	"2 arg method call (could be indexed propset"
	dict := IDispatch createObject: 'Scripting.Dictionary'.
	dict add: 1 _: 'Blair'.
	self assert: (dict item: 1) = 'Blair'.
	"Indexed propset"
	dict item: 2 value: 'Bower'.
	self assert: (dict item: 2) = 'Bower'.
	"Another indexed propset"
	dict key: 1 newKey: 0.
	self assert: (dict item: 0) = 'Blair'.
	self assert: dict count = 2.
	"1 arg method calls"
	self assert: (dict exists: 0).
	dict remove: 0.
	self deny: (dict exists: 0).
	self assert: dict count = 1.
	"0 arg method call"
	dict removeAll.
	self assert: dict count = 0.
	"Deliberate mispelling - should raise DNU"
	self should: [dict counts] raise: MessageNotUnderstood.
	"1 Extraneous argument to propgets (no propset)"
	self should: [dict count: 1] raise: HRESULTError.
	"2 Extraneous args to propget"
	self should: [dict count: 1 _: 2] raise: HRESULTError.
	"3 extraneous args to propget"
	self should: 
			[dict 
				count: 1
				_: 2
				_: 3]
		raise: HRESULTError.
	"Zero args to 2 arg method call (treat as propget)"
	self should: [dict add] raise: HRESULTError.
	"One args to 2 arg method call (treat as propget)"
	self should: [dict add: 1] raise: HRESULTError!

testInspectablePropertiesOfDual
	| obj cDrive aspects |
	obj := IDispatch createObject: 'Scripting.FileSystemObject'.
	self assert: (obj publishedAspects includesKey: 'Drives').
	cDrive := (obj getProperty: #Drives) getProperty: 'Item' item: 'C:'.
	aspects := cDrive publishedAspects.
	#('AvailableSpace' 'DriveLetter' 'DriveType' 'FileSystem' 'FreeSpace' 'IsReady' 'Path' 'RootFolder' 'SerialNumber' 'ShareName' 'TotalSize' 'VolumeName') 
		do: [:each | self assert: (aspects includesKey: each)]!

testReadOnlyAspects
	| obj prop aspects |
	obj := IDispatch createObject: 'Scripting.Dictionary'.
	aspects := obj publishedAspects.
	prop := aspects at: 'Count'.
	self deny: prop isNullable.
	self deny: prop isWriteable.
	prop := aspects at: 'CompareMode'.
	self assert: prop isNullable.
	self assert: prop isWriteable.
	obj free! !
!IDispatchTest categoriesFor: #testDisplayOn!public!unit tests! !
!IDispatchTest categoriesFor: #testDNU!public!unit tests! !
!IDispatchTest categoriesFor: #testInspectablePropertiesOfDual!public!unit tests! !
!IDispatchTest categoriesFor: #testReadOnlyAspects!public!unit tests! !

