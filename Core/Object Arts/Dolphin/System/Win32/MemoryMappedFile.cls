"Filed out from Dolphin Smalltalk"!

Object subclass: #MemoryMappedFile
	instanceVariableNames: 'file name handle maximumSize ownsFile'
	classVariableNames: ''
	poolDictionaries: 'MMFConstants Win32Constants'
	classInstanceVariableNames: ''!
MemoryMappedFile guid: (GUID fromString: '{87c4eee1-16f8-422b-b9e6-2e1c2963affd}')!
MemoryMappedFile comment: 'MemoryMappedFile is an abstraction over the Win32 Memory-Mapped File API.

Instance Variables:
	file				<File> the file which the receiver maps into memory.
	name			<String> system wide name of the mapping (used for sharing mappings between processes, not the filename)
	handle			<ExternalHandle>. File mapping handle
	maximumSize		<integer>
	ownsFile		<boolean>. Whether or not the mapping opened the file (and should therefore close it when free''d)

'!
!MemoryMappedFile categoriesForClass!Kernel-Objects! !
!MemoryMappedFile methodsFor!

asParameter
	"Answer the receiver in a form suitable for passing to an external function
	primitive method (see ExternalLibrary and subclasses)."

	"Implementation Note: The file mapping is lazily created on demand."

	handle isNull 
		ifTrue: 
			[handle := self createMapping.
			self beFinalizable].
	^handle!

basicFree
	"Private - Free external resources held by the receiver."

	"Implementation Note: According to MSDN the order in which the views are unmapped and the
	file mapping itself is closed is immaterial. Therefore we don't need to synchronise the
	finalization order in any way."

	"Transcript
		display: 'Closing Memory Mapped File: ';
		print: file;
		cr."

	KernelLibrary default closeHandle: handle.
	ownsFile ifTrue: [file close]!

createMapping
	"Private - Create the file mapping and answer its handle."

	^(KernelLibrary default 
		createFileMapping: file asParameter
		lpAttributes: nil
		flProtect: (self isReadOnly ifTrue: [PAGE_READONLY] ifFalse: [PAGE_READWRITE])
		dwMaximumSizeHigh: (maximumSize bitShift: -32)
		dwMaximumSizeLow: (16rFFFFFFFF bitAnd: maximumSize)
		lpName: name) ifNil: [KernelLibrary default systemError]!

free
	"Free external resources held by the receiver, and leave in a clean state."

	handle isNull ifTrue: [^self].
	self beUnfinalizable.
	self basicFree.
	file := handle := nil!

isReadOnly
	"Answer whether this is a read-only mapping. This decision is based on the file-open mode of
	the mapped <File>."

	^file accessFlags noMask: GENERIC_WRITE!

mapView
	"Answer a <MemoryMappedFileView> addressing the entire content of the file."

	^self mapViewFrom: 1 to: 0!

mapViewFrom: startInteger to: stopInteger 
	"Answer a <MemoryMappedFileView> addressing the specified interval in the file."

	| count allocationGranularity offset view |
	#todo.	"Use GetSystemInfo to get the allocation granularity"
	allocationGranularity := 64 * 1024.
	offset := startInteger - 1.
	offset \\ allocationGranularity ~= 0 
		ifTrue: 
			[self error: ('Start offset must be a multiple of the system''s allocation granularity (<1d>)' 
						expandMacrosWith: allocationGranularity)].
	count := stopInteger - offset.
	view := KernelLibrary default 
				mapViewOfFile: self asParameter
				dwDesiredAccess: (self isReadOnly ifTrue: [FILE_MAP_READ] ifFalse: [FILE_MAP_ALL_ACCESS])
				dwFileOffsetHigh: (offset bitShift: -32)
				dwFileOffsetLow: (offset bitAnd: 16rFFFFFFFF)
				dwNumberOfBytesToMap: count.
	view beFinalizable.
	^view!

maximumSize
	"Answer the maximum size of the file-mapping object."

	^maximumSize!

maximumSize: anInteger 
	"Set the maximum size of the file-mapping object. Note that this cannot be changed after the
	mapping has been created. If you specify a maximum size greater than the current size of the
	file, then the OS will expand the file to the maximum size when the file mapping is
	realized, i.e. the file is statically reallocated to the maximum size, or as explain in MSDN
	'...you must calculate or estimate the size of the finished file because file mapping
	objects are static in size; once created, their size cannot increase or decrease.'. If you
	don't specify a maximum size (i.e. the default of zero is used), then the maximum size of
	the file mapping will be the existing file size. This is not valid if the file is empty."

	maximumSize = anInteger ifTrue: [^self].
	handle notNull 
		ifTrue: [^self error: 'Maximum size of a file mapping object cannot be changed after realization'].
	maximumSize := anInteger!

setFile: aFile owned: aBoolean name: aString 
	file := aFile.
	ownsFile := aBoolean.
	name := aString.
	maximumSize := 0! !
!MemoryMappedFile categoriesForMethods!
asParameter!converting!public! !
basicFree!private!realizing/unrealizing! !
createMapping!helpers!private! !
free!public!realizing/unrealizing! !
isReadOnly!helpers!public!testing! !
mapView!operations!public! !
mapViewFrom:to:!operations!public! !
maximumSize!accessing!public! !
maximumSize:!accessing!public! !
setFile:owned:name:!initializing!private! !
!

!MemoryMappedFile class methodsFor!

icon
	^File icon!

onFile: aFile 
	"Answer a new instance of the receiver which is a memory-mapping onto the specified <File>."

	^self onFile: aFile named: nil!

onFile: aFile named: aString 
	"Answer a new instance of the receiver which is a memory-mapping onto the specified File, with the specified name.
	The name can be nil for an unnamed mapping. Named mappings can be shared with other processes."

	^(self basicNew)
		setFile: aFile
			owned: false
			name: aString;
		yourself!

open: aString
	"Open the file described by aString for exclusive read/write access.
	Answer the the new instance or signal a FileException if the operation fails."

	^self open: aString mode: #open!

open: aString mode: aSymbol
	"Open a file for exclusive read and/or write memory-mapped access. The mode symbol, aSymbol,
	determines what file opening mode to use when opening the file. Errors will be reported if
	an attempt is made to open a file which does not or does not exist, depending on the access
	mode (see File>>open:mode:check:share: for the rules)."

	^self open: aString mode: aSymbol check: true!

open: aString mode: aSymbol check: aBoolean 
	"Open a file for exclusive read and/or write memory-mapped access. The mode symbol, aSymbol,
	determines what file opening mode to use when opening the file. The check flag, aBoolean,
	determines whether or not errors are reported (see File>>open:mode:check:share: for the
	rules). Note that we always open files for mapping in exclusive mode (see MSDN topic 'Create
	a File Mapping Object')."

	^(self basicNew)
		setFile: (File 
					open: aString
					mode: aSymbol
					check: aBoolean
					share: #exclusive)
			owned: true
			name: nil;
		yourself! !
!MemoryMappedFile class categoriesForMethods!
icon!constants!public! !
onFile:!instance creation!public! !
onFile:named:!instance creation!public! !
open:!instance creation!public! !
open:mode:!instance creation!public! !
open:mode:check:!instance creation!public! !
!

