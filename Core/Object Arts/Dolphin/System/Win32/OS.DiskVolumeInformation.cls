"Filed out from Dolphin Smalltalk 7"!

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
!OS.DiskVolumeInformation categoriesForClass!Unclassified! !
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
	sectorsPerClusterBuf := DWORD new.
	bytesPerSectorBuf := DWORD new.
	numberOfFreeClustersBuf := DWORD new.
	totalNumberOfClustersBuf := DWORD new.
	(KernelLibrary default
		getDiskFreeSpace: self rootPath
		lpSectorsPerCluster: sectorsPerClusterBuf
		lpBytesPerSector: bytesPerSectorBuf
		lpNumberOfFreeClusters: numberOfFreeClustersBuf
		lpTotalNumberOfClusters: totalNumberOfClustersBuf) ifFalse: [KernelLibrary default systemError].
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
	freeBytesAvailableBuf := ULARGE_INTEGER new.
	totalNumberOfBytesBuf := ULARGE_INTEGER new.
	totalNumberOfFreeBytesBuf := ULARGE_INTEGER new.
	(KernelLibrary default
		getDiskFreeSpaceEx: path
		lpFreeBytesAvailable: freeBytesAvailableBuf
		lpTotalNumberOfBytes: totalNumberOfBytesBuf
		lpTotalNumberOfFreeBytes: totalNumberOfFreeBytesBuf) ifFalse: [KernelLibrary default systemError].
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
	volumeNameBuffer := Utf16String newFixed: CRTConstants._MAX_PATH.
	volumeSerialNumber := DWORDBytes new.
	maximumComponentLengthBuffer := DWORDBytes new.
	fileSystemFlagsBuffer := DWORDBytes new.
	fileSystemNameBuffer := volumeNameBuffer copy.
	(KernelLibrary default
		getVolumeInformation: self rootPath
		lpVolumeNameBuffer: volumeNameBuffer
		nVolumeNameSize: volumeNameBuffer size + 1
		lpVolumeSerialNumber: volumeSerialNumber
		lpMaximumComponentLength: maximumComponentLengthBuffer
		lpFileSystemFlags: fileSystemFlagsBuffer
		lpFileSystemNameBuffer: fileSystemNameBuffer
		nFileSystemNameSize: fileSystemNameBuffer size + 1) ifFalse: [KernelLibrary default systemError].
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

	(KernelLibrary default setVolumeLabel: self rootPath lpVolumeName: newLabelString)
		ifFalse: [KernelLibrary default systemError].
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
!OS.DiskVolumeInformation categoriesFor: #bytesPerSector!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #calcDiskSpace!helpers!private! !
!OS.DiskVolumeInformation categoriesFor: #displayOn:!displaying!public! !
!OS.DiskVolumeInformation categoriesFor: #displaySerialNumberOn:!displaying!private! !
!OS.DiskVolumeInformation categoriesFor: #driveLetter!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #explorerName!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #fileSystemFlags!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #fileSystemName!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #freeBytes!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #freeClusters!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #getDiskFreeSpace!helpers!private! !
!OS.DiskVolumeInformation categoriesFor: #getDiskFreeSpaceEx!helpers!private! !
!OS.DiskVolumeInformation categoriesFor: #getDiskStats!helpers!private! !
!OS.DiskVolumeInformation categoriesFor: #getVolumeInformation!helpers!private! !
!OS.DiskVolumeInformation categoriesFor: #isSparseFileCapable!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #label!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #label:!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #maxComponentLength!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #printOn:!displaying!public! !
!OS.DiskVolumeInformation categoriesFor: #rootPath!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #sectorsPerCluster!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #serialNumber!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #setPath:!initializing!private! !
!OS.DiskVolumeInformation categoriesFor: #totalBytes!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #totalClusters!accessing!public! !
!OS.DiskVolumeInformation categoriesFor: #totalFreeBytes!accessing!public! !

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
!OS.DiskVolumeInformation class categoriesFor: #forPath:!instance creation!public! !
!OS.DiskVolumeInformation class categoriesFor: #forSystemPath!instance creation!public! !

