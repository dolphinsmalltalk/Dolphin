"Filed out from Dolphin Smalltalk"!

FileSystemChangeReader subclass: #FileSystemChangeStream
	instanceVariableNames: 'queue'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FileSystemChangeStream guid: (GUID fromString: '{49dd0dec-28ae-4954-ac32-94524feb054c}')!

FileSystemChangeStream comment: 'FileSystemChangeStream is a FileSystemChangeReader that publishes the file-system changes as entries on a <SharedQueue>. This allows the changes to be read by arbitrary background processes as if reading from an infinite stream of such changes. Note that it is possible to experience a Win32Error when reading from the queue in exceptional circumstances due to some underlying error reported by the ReadDirectoryChanges API. Should such an error be detected and handled, then it should be assumed that the FileSystemChangeStream will have to be recreated. 

A FileSystemChangeStream can be set up as follows:
	
	stream := FileSystemChangeStream directory: ''c:\directory_to_monitor''.
	stream filterString: ''*.xml;*.config''.
	stream startMonitoring.

To read changes one simply sends the #next message to the FileSystemChangeStream. This will block until a change notification is available. [Clearly this is inappropriate for use from the main UI process, in which case the event driven FileSystemWatcher should be used instead]. For example:

	p := [[| change | change := stream next. Transcript print: Time now; display: '': ''; print: change; cr] repeat] forkAt: Processor userBackgroundPriority.
	...
	stream stopMonitoring. p terminate

The changes are described by instances of <FileSystemChange>. This has attributes that represent the symbolic name of the change, the names of the files changed, and also the time that the change was first recorded. Note that this not necessarily the time that the change actually occurred, as there is some latency before Windows notifies changes.

'!

!FileSystemChangeStream categoriesForClass!Unclassified! !

!FileSystemChangeStream methodsFor!

handleError: anInteger 
	queue nextPut: anInteger!

handleNotifications: aSequencedReadableCollection 
	aSequencedReadableCollection do: [:each | queue nextPut: each]!

initialize
	queue := SharedQueue new.
	super initialize!

next
	"Answer the next file system change notification, blocking the calling process until one is available."

	| next |
	next := queue next.
	next isInteger ifTrue: [^Win32Error signalWith: next].
	^next! !

!FileSystemChangeStream categoriesForMethods!
handleError:!helpers!private! !
handleNotifications:!private! !
initialize!initializing!private! !
next!public! !
!

