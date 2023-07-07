"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'OS.FileSystemChangeReader'
	instanceVariableNames: 'handle directory watchSubDirs notificationMask callback buffer overlapStruct filters'
	classVariableNames: 'FileIOCompletionRoutineDescriptor'
	imports: #(#{OS.Win32Constants} #{OS.FileSystemWatcherConstants} #{OS.Win32Errors})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.FileSystemChangeReader guid: (Core.GUID fromString: '{d46a38a5-966c-4e12-a910-00936a4993bd}')!
OS.FileSystemChangeReader isNonInstantiable: true!
OS.FileSystemChangeReader comment: 'FileSystemChangeReader is a class of objects that can be used to monitor the file system for changes occurring in a specified directory, and (optionally) its sub-directories. The directory can reside on the local computer, a network drive, or a remote computer, as long as the computers concerned are not running Windows 9x (which does not support the necessary Win32 API).

FileSystemChangeReader employs the ReadDirectoryChangesW API to request directory monitoring, and uses Win32 overlapped I/O in conjunction with asynchronous procedure calls to receive the notifications. By utilising Dolphin''s generic callback mechanism overlapped I/O APCs are simple and efficient, however because they are received when Dolphin enters an alertable wait state, they will normally be processed by the idle process when it issues a MsgWaitForMultipleObjectsEx call to quiesce the system. 

FileSystemChangeReader itself is abstract, and has subclasses that publish the file system notifications either as Smalltalk events on the main UI thread (FileSystemWatcher), or by pushing them onto a SharedQueue for processing by a background thread (FileSystemChangeReader).

To monitor the entire contents of a directory and its sub-directories, pass the name of the directory with or without a terminating back slash, for example:
	FileSystemWatcher monitorDirectory: ''c:\temp''

To monitor a specific file set up a monitor on the directory and then set the filename as the filter, for example:
	fscr := FileSystemChangeReader directory: ''c:\temp''.
	fscr filterString: ''blah.txt''.
	[[| change | change := fscr next. Transcript print: Time now; display: '': ''; print: change; cr] repeat] forkAt: Processor userBackgroundPriority.
	fscr startMonitoring.

A range of files matching a wildcarded filename, or filenames, can also be monitored.
	fsw := FileSystemWatcher directory: ''c:\temp''.
	fsw filterString: ''*.txt;*.doc''.
	fsw startMonitoring.

The filters can also be set using the #filters: method and passing an array of strings as its argument.

The #watchSubDirs flag allows control over whether the watcher will also monitor for changes in files matching the filter in sub-directories. 

It is possible to mask out certain change events (which one might want to do if monitoring a frequently updated directory), or receive more detailed changes events (such as changes to file sizes, and even the time of last access) by setting the #notificationMask. By default a FileSystemWatcher will report the addition, modification, removal and renaming of files.

N.B. If you monitor a directory such as c:\Windows\ or : c:\Windows\System32, you may start to receive so many notifications that system performance is impacted.  It is advisable to consider carefully before monitoring any directory.'!
!OS.FileSystemChangeReader categoriesForClass!Kernel-Objects! !
!OS.FileSystemChangeReader methodsFor!

addFilter: aString 
	self filters: (self filters copyWith: aString)!

bufferSize
	^8192!

changeWatchProperty: aNiladicValuable 
	| wasMonitoring |
	wasMonitoring := self stopMonitoring.
	[aNiladicValuable value] ensure: [wasMonitoring ifTrue: [self startMonitoring]]!

createCallback
	overlapStruct := OVERLAPPED new.
	callback := Callback block: 
					[:dwErrorCode :dwNumberOfBytesTransfered :lpOverlapped |
					dwErrorCode = 0 ifFalse: [self processError: dwErrorCode].
					dwNumberOfBytesTransfered > 0 ifTrue: [self processNotifications].
					"Need to read again to get the next set of notifications... handle null if closed"
					handle notNull
						ifTrue: [self readDirectoryChanges ifFalse: [self processError: Kernel32 getLastError]]]
				descriptor: FileIOCompletionRoutineDescriptor!

defaultNotificationMask
	^FILE_NOTIFY_CHANGE_LAST_WRITE | FILE_NOTIFY_CHANGE_DIR_NAME | FILE_NOTIFY_CHANGE_FILE_NAME!

directory
	"Answer the path to the directory being (or to be) watched."

	^directory!

directory: aString 
	"Set the path to be monitored. If this specifies a path to a directory, then that directory
	is monitored. If it specifies a path to a file, then the directory containing that file is
	monitored for changes to that specified file."

	self changeWatchProperty: [directory := aString]!

filters
	^filters ?? #('*')!

filters: anArrayOfStrings 
	filters := anArrayOfStrings isEmpty ifFalse: [anArrayOfStrings asArray]!

filterString
	^$; join: self filters!

filterString: aString
	self filters: ($; split: aString)!

free
	"Free any external resources owned by the receiver."

	self stopMonitoring.
	callback free.
	callback := nil!

freeDirectoryHandle: anExternalHandle
	Kernel32
		cancelIo: anExternalHandle;
		closeHandle: anExternalHandle!

getDirectoryHandle
	"Private - Get a file handle onto the monitored directory. This can be done by passing
	FILE_FLAG_BACKUP_SEMANTICS as a flag to the CreateFile() API. FILE_LIST_DIRECTORY access is
	needed for monitoring changes, and we want to overlap the access. Note that we disallow
	deletion of the monitored directory by not passing FILE_SHARE_DELETE in the share mode. This
	is because we don't receive any notification if the directory is deleted after we start
	monitoring, so we would be blissfully unaware."

	handle := Kernel32
				createFile: directory
				dwDesiredAccess: FILE_LIST_DIRECTORY
				dwSharedMode: FILE_SHARE_READ | FILE_SHARE_WRITE
				lpSecurityAttributes: nil
				dwCreationDistribution: OPEN_EXISTING
				dwFlagsAndAttributes: FILE_FLAG_BACKUP_SEMANTICS | FILE_FLAG_OVERLAPPED
				hTemplateFile: nil.
	handle isInvalid ifFalse: [^self].
	handle := nil.
	Kernel32 systemError!

handleError: anInteger 
	^self subclassResponsibility!

handleNotifications: aSequencedReadableCollection 
	^self subclassResponsibility!

initialize
	notificationMask := self defaultNotificationMask.
	watchSubDirs := true!

isMonitoring
	^handle notNull!

isMonitoring: aBoolean 
	aBoolean ifTrue: [self startMonitoring] ifFalse: [self stopMonitoring]!

notificationMask
	^notificationMask!

notificationMask: anInteger 
	"Set the ReadDirectoryChangesW notification mask. The argument should be a combination of
	flags from the FILE_NOTIFY_CHANGE_XXX enumeration defined in FileSystemWatchConstants.
	At least one of the flags must be set."

	anInteger = 0 ifTrue: [^self error: 'At least one notification filter flag must be set'].
	self changeWatchProperty: [notificationMask := anInteger]!

notifyAttributes
	"Answer whether attribute changes in the watched directory or subtree cause change notifications."

	^self notificationMask allMask: FILE_NOTIFY_CHANGE_ATTRIBUTES!

notifyAttributes: aBoolean 
	self changeWatchProperty: 
			[self notificationMask: (self notificationMask mask: FILE_NOTIFY_CHANGE_ATTRIBUTES set: aBoolean)]!

notifyCreationTime
	"Answer whether changes to the creation time of files in the watched directory or subtree
	cause change notifications."

	^self notificationMask allMask: FILE_NOTIFY_CHANGE_CREATION!

notifyCreationTime: aBoolean 
	self changeWatchProperty: 
			[self notificationMask: (self notificationMask mask: FILE_NOTIFY_CHANGE_CREATION set: aBoolean)]!

notifyDirectoryName
	"Answer whether directory-name change in the watched directory or subtree cause a change
	notification. Relevant changes include creating or deleting a directory."

	^self notificationMask allMask: FILE_NOTIFY_CHANGE_DIR_NAME!

notifyDirectoryName: aBoolean 
	self changeWatchProperty: 
			[self notificationMask: (self notificationMask mask: FILE_NOTIFY_CHANGE_DIR_NAME set: aBoolean)]!

notifyFileName
	"Answer whether file name changes in the watched directory or subtree cause change
	notifications. Relevant changes include renaming, creating, or deleting a file."

	^self notificationMask allMask: FILE_NOTIFY_CHANGE_FILE_NAME!

notifyFileName: aBoolean 
	self changeWatchProperty: 
			[self notificationMask: (self notificationMask mask: FILE_NOTIFY_CHANGE_FILE_NAME set: aBoolean)]!

notifyLastAccess
	"Answer whether changes to the last access time of files in the watched directory or subtree
	cause change notifications."

	^self notificationMask allMask: FILE_NOTIFY_CHANGE_LAST_ACCESS!

notifyLastAccess: aBoolean 
	self changeWatchProperty: 
			[self notificationMask: (self notificationMask mask: FILE_NOTIFY_CHANGE_LAST_ACCESS set: aBoolean)]!

notifyLastWrite
	"Answer whether changes to the last write-time of files in the watched directory or subtree
	cause change notifications. As with file size change notifications, notifications of file
	writes may be delayed until the OS file system cache is flushed."

	^self notificationMask allMask: FILE_NOTIFY_CHANGE_LAST_WRITE!

notifyLastWrite: aBoolean 
	self changeWatchProperty: 
			[self notificationMask: (self notificationMask mask: FILE_NOTIFY_CHANGE_LAST_WRITE set: aBoolean)]!

notifySecurity
	"Answer whether security-descriptor changes in the watched directory or subtree cause change
	notifications."

	^self notificationMask allMask: FILE_NOTIFY_CHANGE_SECURITY!

notifySecurity: aBoolean 
	self changeWatchProperty: 
			[self notificationMask: (self notificationMask mask: FILE_NOTIFY_CHANGE_SECURITY set: aBoolean)]!

notifySize
	"Answer whether file-size changes in the watched directory or subtree cause change
	notifications. Note that the OS detects file size changes only when a file is written to the
	disk, so the notification may be delayed until the file-system cache is flushed."

	^self notificationMask allMask: FILE_NOTIFY_CHANGE_SIZE!

notifySize: aBoolean 
	self changeWatchProperty: 
			[self notificationMask: (self notificationMask mask: FILE_NOTIFY_CHANGE_SIZE set: aBoolean)]!

processError: anInteger
	buffer := nil.
	Kernel32 closeHandle: handle.
	handle := nil.
	anInteger = ERROR_OPERATION_ABORTED ifTrue: [^self].
	self handleError: anInteger!

processNotifications
	| unpacked filtered |
	unpacked := self unpackNotifications.
	filtered := unpacked select: [:each | self shouldNotifyChange: each].
	filtered isEmpty ifTrue: [^self].
	self handleNotifications: filtered!

readDirectoryChanges
	self assert: [handle notNull].
	^(Kernel32
		readDirectoryChangesW: handle
		lpBuffer: buffer
		nBufferLength: buffer size
		bWatchSubtree: self watchSubDirs
		dwNotifyFilter: self notificationMask
		lpBytesReturned: nil
		lpOverlapped: overlapStruct
		lpCompletionRoutine: callback asParameter) asBoolean!

removeFilter: aString 
	self filters: (self filters copyWithout: aString)!

shouldNotifyChange: anAssociation
	^anAssociation fileNames anySatisfy: 
			[:eachPath |
			self filters anySatisfy: [:eachFilter | eachFilter match: (File splitFilenameFrom: eachPath)]]!

startMonitoring
	"Start monitoring directory for changes."

	| err |
	handle isNull ifFalse: [^self].
	self getDirectoryHandle.
	self beFinalizable.
	self createCallback.
	buffer := ByteArray newFixed: self bufferSize.
	self readDirectoryChanges ifTrue: [^self].
	buffer := nil.
	err := Kernel32 getLastError.
	Kernel32 closeHandle: handle.
	handle := nil.
	^Kernel32 systemError: err!

stopMonitoring
	"Stop monitoring the directory for changes. Answer whether the receiver was monitoring
	changes at the time of the request to stop."

	| wasMonitoring |
	wasMonitoring := handle notNull.
	wasMonitoring
		ifTrue: 
			[| fh |
			self beUnfinalizable.
			fh := handle.
			handle := nil.
			self freeDirectoryHandle: fh].
	"We must now allow the system to deliver an APC to inform us of the aborted IO BEFORE we let
	the receiver (and therefore the callback object) go out of scope. In order to do this we
	must enter an alertable wait state, e.g. using SleepEx. N.B. We won't normally sleep for
	20mS, just as long as it takes the APC to arrive, which in practice is immediately."
	buffer isNil ifFalse: [Kernel32 sleepEx: 20 bAlertable: true].
	^wasMonitoring!

unpackNotifications
	"Private - Unpack the file system notifications from the 'array' of variable length
	structures. Note that the structure sometimes contains side by side notifications of the
	same change, so we ignore these."

	| address notifications struct offset last next |
	notifications := OrderedCollection new.
	address := buffer yourAddress.
	struct := FILE_NOTIFY_INFORMATION fromAddress: address.
	last := nil.
	
	[| code fileName |
	fileName := struct FileName asString.
	code := struct Action.
	next := FileSystemChange code: code fileName: fileName.
	last = next
		ifFalse: 
			[code == 5
				ifTrue: [last fileNames: last fileNames , next fileNames]
				ifFalse: [notifications addLast: next]].
	offset := struct NextEntryOffset.
	offset = 0]
			whileFalse: 
				[last := next.
				address := address + offset.
				struct bytes: address asExternalAddress].
	^notifications!

watchSubDirs
	"Answer whether the receiver monitors sub-directories of the main watch directory for changes."

	^watchSubDirs!

watchSubDirs: aBoolean 
	"Set whether the receiver monitors sub-directories of the main watch directory for changes."

	self changeWatchProperty: [watchSubDirs := aBoolean]! !
!OS.FileSystemChangeReader categoriesForMethods!
addFilter:!accessing!private! !
bufferSize!constants!private! !
changeWatchProperty:!helpers!private! !
createCallback!helpers!private! !
defaultNotificationMask!constants!private! !
directory!accessing!public! !
directory:!accessing!public! !
filters!accessing!public! !
filters:!accessing!public! !
filterString!accessing!public! !
filterString:!accessing!public! !
free!public!realizing/unrealizing! !
freeDirectoryHandle:!helpers!private!realizing/unrealizing! !
getDirectoryHandle!helpers!private!realizing/unrealizing! !
handleError:!helpers!private! !
handleNotifications:!helpers!private! !
initialize!initializing!private! !
isMonitoring!public!testing! !
isMonitoring:!accessing!public! !
notificationMask!accessing!public! !
notificationMask:!accessing!public! !
notifyAttributes!public!testing! !
notifyAttributes:!accessing!public! !
notifyCreationTime!public!testing! !
notifyCreationTime:!accessing!public! !
notifyDirectoryName!public!testing! !
notifyDirectoryName:!accessing!public! !
notifyFileName!public!testing! !
notifyFileName:!accessing!public! !
notifyLastAccess!public!testing! !
notifyLastAccess:!accessing!public! !
notifyLastWrite!public!testing! !
notifyLastWrite:!accessing!public! !
notifySecurity!public!testing! !
notifySecurity:!accessing!public! !
notifySize!public!testing! !
notifySize:!accessing!public! !
processError:!accessing!private! !
processNotifications!helpers!private! !
readDirectoryChanges!helpers!private! !
removeFilter:!accessing!public! !
shouldNotifyChange:!helpers!private! !
startMonitoring!operations!public! !
stopMonitoring!public!realizing/unrealizing! !
unpackNotifications!helpers!private! !
watchSubDirs!accessing!public! !
watchSubDirs:!accessing!public! !
!

!OS.FileSystemChangeReader class methodsFor!

directory: aString 
	^(self new)
		directory: aString;
		yourself!

initialize
	"VOID CALLBACK FileIOCompletionRoutine(
		DWORD dwErrorCode,
		DWORD dwNumberOfBytesTransfered,
		LPOVERLAPPED lpOverlapped
	);"

	FileIOCompletionRoutineDescriptor := External.FunctionDescriptor
				argumentTypes: 'uint32 uint32 OVERLAPPED*'!

monitorDirectory: aString 
	^(self directory: aString)
		startMonitoring;
		yourself!

new
	^(self basicNew)
		initialize;
		yourself!

publishedEventsOfInstances
	"Answer a <Set> of <Symbols> that describe the published events triggered by instances of
	the receiver."

	^(super publishedEventsOfInstances)
		add: #fileAdded:;
		add: #fileRemoved:;
		add: #fileModified:;
		add: #fileRenamedFrom:to:;
		yourself! !
!OS.FileSystemChangeReader class categoriesForMethods!
directory:!instance creation!public! !
initialize!initializing!public! !
monitorDirectory:!instance creation!public! !
new!public! !
publishedEventsOfInstances!events!public! !
!

