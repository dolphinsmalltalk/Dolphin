"Filed out from Dolphin Smalltalk"!

OS.FileSystemChangeReader subclass: #'OS.FileSystemWatcher'
	instanceVariableNames: 'events'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.FileSystemWatcher guid: (Core.GUID fromString: '{eb4cdf52-701c-4505-9872-8bfce6c37830}')!
OS.FileSystemWatcher comment: 'FileSystemWatcher is a FileSystemChangeReader that publishes the file-system changes it detects as Smalltalk events on the main UI thread.

Clients of the FileSystemWatcher can register to receive the following events:
	
	#fileAdded: <fullPathString>
	#fileModified: <fullPathString>
	#fileRemoved: <fullPathString>
	#fileRenamedFrom: <fullPathString> to: <fullPathString>

All file/directory names passed with triggered events are full paths.

Note that the #fileRemoved: event is received when a file is deleted, or when it is moved out of the monitored directory hierarchy. If a file is moved within the monitored directory hierarchy one will get first a #fileRemoved: and then a #fileAdded:.

From observation it seems that saving a file typically results in two consecutive file modification events. This might be due to the way applications save files, but it is the case with commonly used editors such as Notepad. The FileSystemWatcher makes no attempt to filter these (apparently) duplication notifications - it is the applications responsibility to apply whatever filtering is appropriate. File Save (As) operations may result in the creation of temporary files too. Creating a new folder in Windows Explorer results in an initial {#fileAdded:, ''New Folder''} event, and subsequently a rename event (assuming one renames the folder away from the default name).

See the superclass comment for details of how to set up a FileSystemWatcher.'!
!OS.FileSystemWatcher categoriesForClass!Kernel-Objects! !
!OS.FileSystemWatcher methodsFor!

getEvents
	"Private - Answer the EventsCollection belonging to the receiver, or nil if the receiver
	has no events registered for it"

	^events!

handleError: anInteger 
	[self trigger: #error: with: anInteger] postToMessageQueue!

handleNotifications: aSequencedReadableCollection 
	[self informObservers: aSequencedReadableCollection] postToMessageQueue!

informObservers: aSequencedReadableCollection
	"Private - Inform observers of the file system changes. Note that this must be done in the context of
	the main process, yet it is very likely that the APC is processed by the idle process when
	it calls MsgWaitForMultipleObjectsEx to quiesce the system."

	aSequencedReadableCollection do: 
			[:each |
			self trigger: each action
				withArguments: (each fileNames collect: [:eachPath | File composePath: directory subPath: eachPath])]!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original. Answer the receiver."

	events := nil.
	^self!

setEvents: anEventsCollectionOrNil
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil.
	Answer the receiver."

	events := anEventsCollectionOrNil!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler. We must ensure that the local events collection
	is NOT saved to the filer"

	anSTBOutFiler override: events with: nil.
	super stbSaveOn: anSTBOutFiler.! !
!OS.FileSystemWatcher categoriesForMethods!
getEvents!events!private! !
handleError:!helpers!private! !
handleNotifications:!private! !
informObservers:!helpers!private! !
postCopy!copying!public! !
setEvents:!events!private! !
stbSaveOn:!binary filing!public! !
!

!OS.FileSystemWatcher class methodsFor!

initialize
	"VOID CALLBACK FileIOCompletionRoutine(
		DWORD dwErrorCode,
		DWORD dwNumberOfBytesTransfered,
		LPOVERLAPPED lpOverlapped
	);"

	FileIOCompletionRoutineDescriptor := External.FunctionDescriptor
				argumentTypes: 'uint32 uint32 OVERLAPPED*'! !
!OS.FileSystemWatcher class categoriesForMethods!
initialize!initializing!public! !
!

