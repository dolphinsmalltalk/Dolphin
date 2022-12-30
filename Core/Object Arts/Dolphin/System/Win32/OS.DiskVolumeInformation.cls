"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'OS.DiskVolumeInformation'
	instanceVariableNames: 'path rootPath label serialNumber maxComponentLength fileSystemFlags fileSystemName sectorsPerCluster bytesPerSector freeClusters totalClusters freeBytes totalBytes totalFreeBytes'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.DiskVolumeInformation guid: (Core.GUID fromString: '{3de35cee-9281-49c6-9bd5-7141432d16e4}')!
OS.DiskVolumeInformation comment: 'DiskVolumeInformation can be used to access various statistics and various other items of information available through the Win32 API about disk volumes, for example the disk volumne label and serial number of the disk in a particular drive.

Example Usage:
	DiskVolumeInformation forPath: ''c:\'''!
!OS.DiskVolumeInformation methodsFor!

bytesPerSector
	"Answer the value of the receiver's ''bytesPerSector'' instance variable."

	bytesPerSector isNil ifTrue: [self getDiskFreeSpace].
	^bytesPerSector!

calcDiskSpace
	"Private - Call the Win32 GetDiskFreeSpaceEx() API to retrieve the free bytes etc, 
	or if that is not available use the old GetDiskFreeSpace() API (e.g. on Win95 
	prior to OSR2)."

	[self getDiskFreeSpaceEx] on: Win32Error
		do: 
			[:e |
			| bytesPerCluster |
			bytesPerCluster := self bytesPerSector * self sectorsPerCluster.
			totalBytes := self freeClusters * bytesPerCluster.
			totalFreeBytes := freeBytes := self totalClusters * bytesPerCluster]!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		nextPutAll: self explorerName;
		nextPutAll: ', Serial No. '.
	self displaySerialNumberOn: aPuttableStream!

displaySerialNumberOn: aStream
	"Private - Display the volume serial number on aStream as a <readableString>"

	| serial |
	serial := self serialNumber.
	aStream nextPutAll: ('%04X-%04X' sprintfWith: serial highWord with: serial lowWord)!

driveLetter
	"Answer the <readableString> drive letter to which this volume information relates (if any)."

	^self rootPath leftString: 1
!

explorerName
	"Answer the <readableString> name that the Windows Explorer would display for this volume
	in the folder tree."

	| vol |
	vol := self label.
	^(String writeStream: 40)
		nextPutAll: (vol isEmpty ifTrue: ['Local Disk'] ifFalse: [vol]);
		nextPutAll: ' (';
		nextPutAll: self driveLetter;
		nextPutAll: ':)';
		contents!

fileSystemFlags
	"Answer the <integer> flags associated with the file system (see the FS_XXX enumeration)."

	fileSystemFlags isNil ifTrue: [self getVolumeInformation].
	^fileSystemFlags!

fileSystemName
	"Answer the <readableString> name of the file-system, e.g. NTFS or FAT."

	fileSystemFlags isNil ifTrue: [self getVolumeInformation].
	^fileSystemName!

freeBytes
	"Answer the value of the receiver's ''freeBytes'' instance variable.
	N.B. On Win95 this value may not be accurate for large volumes (>2Gb)."

	freeBytes isNil ifTrue: [self calcDiskSpace].
	^freeBytes!

freeClusters
	"Answer the value of the receiver's ''freeClusters'' instance variable.
	N.B. This value may not be accurate for large volumes (>2Gb)."

	freeClusters isNil ifTrue: [self getDiskFreeSpace].
	^freeClusters!

getDiskFreeSpace
	"Private - Call the Win32 GetDiskFreeSpace() API to retrieve the cluster sizes, etc."

	| sectorsPerClusterBuf bytesPerSectorBuf numberOfFreeClustersBuf totalNumberOfClustersBuf |
	sectorsPerClusterBuf := UInt32Bytes new.
	bytesPerSectorBuf := UInt32Bytes new.
	numberOfFreeClustersBuf := UInt32Bytes new.
	totalNumberOfClustersBuf := UInt32Bytes new.
	(Kernel32
		getDiskFreeSpace: self rootPath
		lpSectorsPerCluster: sectorsPerClusterBuf
		lpBytesPerSector: bytesPerSectorBuf
		lpNumberOfFreeClusters: numberOfFreeClustersBuf
		lpTotalNumberOfClusters: totalNumberOfClustersBuf) ifFalse: [Kernel32 systemError].
	sectorsPerCluster := sectorsPerClusterBuf value.
	bytesPerSector := bytesPerSectorBuf value.
	freeClusters := freeBytes isNil
				ifTrue: 
					["Likely to be wrong, but the best we can do..."
					freeClusters := numberOfFreeClustersBuf value]
				ifFalse: [freeBytes / (bytesPerSector * sectorsPerCluster)].
	totalClusters := totalBytes isNil
				ifTrue: 
					["Again likely to be wrong, ..."
					totalNumberOfClustersBuf value]
				ifFalse: [totalBytes / (bytesPerSector * sectorsPerCluster)]!

getDiskFreeSpaceEx
	"Private - Call the Win32 GetDiskFreeSpace() API to retrieve the free space etc, etc."

	| freeBytesAvailableBuf totalNumberOfBytesBuf totalNumberOfFreeBytesBuf |
	freeBytesAvailableBuf := UInt64Bytes new.
	totalNumberOfBytesBuf := UInt64Bytes new.
	totalNumberOfFreeBytesBuf := UInt64Bytes new.
	(Kernel32
		getDiskFreeSpaceEx: path
		lpFreeBytesAvailable: freeBytesAvailableBuf
		lpTotalNumberOfBytes: totalNumberOfBytesBuf
		lpTotalNumberOfFreeBytes: totalNumberOfFreeBytesBuf) ifFalse: [Kernel32 systemError].
	freeBytes := freeBytesAvailableBuf value.
	totalFreeBytes := totalNumberOfFreeBytesBuf value.
	totalBytes := totalNumberOfBytesBuf value!

getDiskStats
	"Private - Call the Win32 GetDiskFreeSpaceEx() API to retrieve the free bytes etc, 
	and then calculate other stats, or if that is not available use the old GetDiskFreeSpace() 
	API (e.g. on Win95 prior to OSR2) and calculate from there."

	[self getDiskFreeSpaceEx] on: Win32Error
		do: 
			[:e |
			| bytesPerCluster |
			bytesPerCluster := self bytesPerSector * self sectorsPerCluster.
			totalBytes := self freeClusters * bytesPerCluster.
			totalFreeBytes := freeBytes := self totalClusters * bytesPerCluster]!

getVolumeInformation
	"Private - Call the Win32 GetVolumeInformation() API to retrieve the label, etc."

	| volumeNameBuffer volumeSerialNumber maximumComponentLengthBuffer fileSystemFlagsBuffer fileSystemNameBuffer |
	"Max size of volume name buffer is documented as MAX_PATH + 1 - we implicitly allocate the null terminator"
	volumeNameBuffer := Kernel32 stringBufferClass newFixed: Win32Constants.MAX_PATH.
	volumeSerialNumber := UInt32Bytes new.
	maximumComponentLengthBuffer := UInt32Bytes new.
	fileSystemFlagsBuffer := UInt32Bytes new.
	fileSystemNameBuffer := volumeNameBuffer copy.
	(Kernel32
		getVolumeInformation: self rootPath
		lpVolumeNameBuffer: volumeNameBuffer
		nVolumeNameSize: volumeNameBuffer size + 1
		lpVolumeSerialNumber: volumeSerialNumber
		lpMaximumComponentLength: maximumComponentLengthBuffer
		lpFileSystemFlags: fileSystemFlagsBuffer
		lpFileSystemNameBuffer: fileSystemNameBuffer
		nFileSystemNameSize: fileSystemNameBuffer size + 1) ifFalse: [Kernel32 systemError].
	label := volumeNameBuffer trimNulls.
	serialNumber := volumeSerialNumber value.
	maxComponentLength := maximumComponentLengthBuffer value.
	fileSystemFlags := fileSystemFlagsBuffer value.
	fileSystemName := fileSystemNameBuffer trimNulls!

isSparseFileCapable
	"Answer whether the file system supports sparse files."

	^self fileSystemFlags allMask: Win32Constants.FILE_SUPPORTS_SPARSE_FILES!

label
	"Answer the <readableString> disk volume label. If the disk is not labelled 
	this will be an empty <String>."

	label isNil ifTrue: [self getVolumeInformation].
	^label!

label: newLabelString
	"Set the label of this disk volume."

	(Kernel32 setVolumeLabel: self rootPath lpVolumeName: newLabelString)
		ifFalse: [Kernel32 systemError].
	label := newLabelString!

maxComponentLength
	"Answer the <integer> maximum length of a file system path component part (e.g. 
	the maximum length of a directory name)."

	maxComponentLength isNil ifTrue: [self getVolumeInformation].
	^maxComponentLength!

printOn: target
	"Append, to the <puttableStream>, target, a string whose characters are a 
	the same as those which would result from sending a #printString
	message to the receiver."

	target
		basicPrint: self;
		nextPut: $(;
		display: self;
		nextPut: $)!

rootPath
	"Answer the value of the receiver's ''rootPath'' instance variable."

	rootPath isNil
		ifTrue: [rootPath := (File splitDriveFrom: path) asUppercase copyWith: File pathDelimiter].
	^rootPath!

sectorsPerCluster
	"Answer the value of the receiver's ''sectorsPerCluster'' instance variable."

	sectorsPerCluster isNil ifTrue: [self getDiskFreeSpace].
	^sectorsPerCluster!

serialNumber
	"Answer the 32-bit <integer> disk serial number. Normally displayed by Windows/Dos
	as two 16-bit hex values, being the high and low words of this 32-bit value."

	serialNumber isNil ifTrue: [self getVolumeInformation].
	^serialNumber!

setPath: pathString
	"Private - Initialize the receiver to retrieve disk volume information for the volume on which
	the specified path resides."

	path := pathString!

totalBytes
	"Answer the value of the receiver's ''totalBytes'' instance variable."

	totalBytes isNil ifTrue: [self calcDiskSpace].
	^totalBytes!

totalClusters
	"Answer the value of the receiver's ''totalClusters'' instance variable."

	totalClusters isNil ifTrue: [self getDiskFreeSpace].
	^totalClusters!

totalFreeBytes
	"Answer the value of the receiver's ''totalFreeBytes'' instance variable."

	totalFreeBytes isNil ifTrue: [self calcDiskSpace].
	^totalFreeBytes! !
!OS.DiskVolumeInformation categoriesForMethods!
bytesPerSector!accessing!public! !
calcDiskSpace!helpers!private! !
displayOn:!displaying!public! !
displaySerialNumberOn:!displaying!private! !
driveLetter!accessing!public! !
explorerName!accessing!public! !
fileSystemFlags!accessing!public! !
fileSystemName!accessing!public! !
freeBytes!accessing!public! !
freeClusters!accessing!public! !
getDiskFreeSpace!helpers!private! !
getDiskFreeSpaceEx!helpers!private! !
getDiskStats!helpers!private! !
getVolumeInformation!helpers!private! !
isSparseFileCapable!accessing!public! !
label!accessing!public! !
label:!accessing!public! !
maxComponentLength!accessing!public! !
printOn:!displaying!public! !
rootPath!accessing!public! !
sectorsPerCluster!accessing!public! !
serialNumber!accessing!public! !
setPath:!initializing!private! !
totalBytes!accessing!public! !
totalClusters!accessing!public! !
totalFreeBytes!accessing!public! !
!

!OS.DiskVolumeInformation class methodsFor!

forPath: rootPath
	"Answer a new instance of the receiver for the <readableString> rootPath of a particular disk
		self forPath: 'C:\'
	"

	^self new
		setPath: rootPath;
		yourself!

forSystemPath
	"Answer a new instance of the receiver for the system disk
		self forSystemPath
	"

	^self forPath: SessionManager current systemDirectory! !
!OS.DiskVolumeInformation class categoriesForMethods!
forPath:!instance creation!public! !
forSystemPath!instance creation!public! !
!

