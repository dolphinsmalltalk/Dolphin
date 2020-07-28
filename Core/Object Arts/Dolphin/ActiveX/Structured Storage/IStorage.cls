"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IStorage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'OLEStructuredStorageConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IStorage guid: (IID fromString: '{0000000b-0000-0000-c000-000000000046}')!
IStorage comment: 'IStorage is a COMInterface class to wrap the standard COM interface of the same name.

IStorage is an abstraction to represent a structured storage mechanism somewhat similar to a file system which contains both streams (files), represented by IStream interfaces, and sub-storages (sub-directories), represented by further IStorage interfaces. The standard system implementation of IStorage provides a file system within a file (or in fact, and byte device which implements ILockBytes). These are commonly called "compound files".

A notable use of Structure Storage is Word documents.

We do not actually implement this interface in Dolphin, only use it as a means of accessing the system provided structure storage mechanism.

Note that the system compound file implementation can be transaction, unless storages are opened in transacted mode (i.e. STGM_DIRECT). Transacted storages support committing and rolling back changes. The default on freeing (i.e. calling Release()) on a storage is to rollback transacted changes to the last commit point,
so it is wise to explicitly commit changes using #flush, or by sending #close.
'!
!IStorage categoriesForClass!COM-Interfaces! !
!IStorage methodsFor!

close
	"Implement the File protocol close method by committing any changes and
	then releasing the interface."

	self
		flush;
		free!

clsid
	"Answer the CLSID previously written into the receiver.
	N.B. This is the same as evaluating 'self stat clsid', but faster."

	| answer |
	answer := CLSID newNull.
	OLELibrary default readClassStg: self pclsid: answer.
	^answer!

clsid: aCLSID 
	"Set the specified CLSID into the receiver."

	self SetClass: aCLSID!

Commit: grfCommitFlags
	"Invoke the Commit() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Commit(
			[in] unsigned long grfCommitFlags);

	"

	<virtual stdcall: hresult 10 dword>
	^self invalidCall: _failureCode!

copy: elementName to: anIStorage 
	"Copy the named element in the receiver (which may be a sub-storage or stream)
	to the destination storage, IStorage.
	This is the equivalent of the file system 'copy' command used with a 
	destination path that specifies only the directory."

	self 
		copy: elementName
		to: anIStorage
		withName: elementName!

copy: elementName to: anIStorage withName: newElementName 
	"Copy the named element in the receiver (which may be a sub-storage or stream)
	to the destination storage, IStorage, renaming it to newElementName.
	This is the equivalent of the file system 'copy' command."

	self 
		MoveElementTo: elementName
		pstgDest: anIStorage
		pwcsNewName: newElementName
		grfFlags: STGMOVE_COPY!

CopyTo: ciidExclude rgiidExclude: rgiidExclude snbExclude: snbExclude pstgDest: pstgDest
	"Invoke the CopyTo() method of the object wrapped by the receiver.
	
		HRESULT __stdcall CopyTo(
			[in] unsigned long ciidExclude,
			[in] GUID* rgiidExclude,
			[in] wireSNB snbExclude,
			[in] IStorage* pstgDest);

	"

	<virtual stdcall: hresult 8 dword guid* lpvoid IStorage*>
	^self invalidCall: _failureCode!

CreateStorage: pwcsName grfMode: grfMode dwStgFmt: dwStgFmt reserved2: reserved2 ppstg: ppstg
	"Invoke the CreateStorage() method of the object wrapped by the receiver.
	
		HRESULT __stdcall CreateStorage(
			[in] LPWSTR pwcsName,
			[in] unsigned long grfMode,
			[in] unsigned long dwStgFmt,
			[in] unsigned long reserved2,
			[out] IStorage** ppstg);

	"

	<virtual stdcall: hresult 6 lpwstr dword dword dword IStorage**>
	^self invalidCall: _failureCode!

CreateStream: pwcsName grfMode: grfMode reserved1: reserved1 reserved2: reserved2 ppstm: ppstm
	"Invoke the CreateStream() method of the object wrapped by the receiver.
	
		HRESULT __stdcall CreateStream(
			[in] LPWSTR pwcsName,
			[in] unsigned long grfMode,
			[in] unsigned long reserved1,
			[in] unsigned long reserved2,
			[out] IStream** ppstm);

	"

	<virtual stdcall: hresult 4 lpwstr dword dword dword IStream**>
	^self invalidCall: _failureCode!

defaultMode
	"Answer the default access mode flags for opening/createing streams and other storages."

	^##(STGM_READWRITE | STGM_SHARE_EXCLUSIVE)!

delete: elementName
	"Delete the named element from the receiver.
	This is the equivalent of the file system 'delete' command."

	self DestroyElement: elementName asUtf16String!

DestroyElement: pwcsName
	"Invoke the DestroyElement() method of the object wrapped by the receiver.
	
		HRESULT __stdcall DestroyElement(
			[in] LPWSTR pwcsName);

	"

	<virtual stdcall: hresult 13 lpwstr>
	^self invalidCall: _failureCode!

directory
	"Answer a <sequencedReadableCollection> of STATSTG structures describing the
	elements of the receiver.
	This is the equivalent of the filesystem 'dir' command."

	^OLEEnumerator onIEnum: self iEnumStats!

doAutoConvert
	"Perform automatic conversion of an object to a new class.
	Answer the CLSID of the new class."

	| answer |
	answer := CLSID new.
	OLELibrary default oleDoAutoConvert: self pClsidNew: answer.
	^answer!

EnumElements: reserved1 reserved2: reserved2 reserved3: reserved3 ppenum: ppenum
	"Invoke the EnumElements() method of the object wrapped by the receiver.
	
		HRESULT __stdcall EnumElements(
			[in] unsigned long reserved1,
			[in] byte* reserved2,
			[in] unsigned long reserved3,
			[out] IEnumSTATSTG** ppenum);

	"

	<virtual stdcall: hresult 12 dword sbyte* dword void**>
	^self invalidCall: _failureCode!

fastFlush
	"Perform a standard flush to OS disk cache. Despite the name, this is no more 
	dangerous than a normal file I/O flush, which does precisely this (i.e. flushes
	memory buffers to the OS, which we assume will be more reliable than the application).
	Use NT instead of Win95, and this should be quite safe enough."

	self Commit: STGC_DANGEROUSLYCOMMITMERELYTODISKCACHE!

flush
	"Commit the receiver in the decfault manner (this includes a hard flush such that if
	this method returns, then it is guaranteed that updates to the underlying storage
	have been flushed to disk). This could be quite slow if performed too often."

	self Commit: STGC_DEFAULT!

getCLIPFORMATAndUserType
	"Answer a two element array containing the CLIPFORMAT and user type last 
	set into the receiver with WriteFmtUserTypeStg()."

	| cf pszUserType answer |
	cf := WORD new.
	pszUserType := COMTaskMemory new.
	OLELibrary default
		readFmtUserTypeStg: self
		pcf: cf
		lplpszUserType: pszUserType.
	answer := {cf asInteger. Utf16String fromAddress: pszUserType}.
	pszUserType free.
	^answer!

iEnumStats
	"Private - Answer an IEnumSTATSTG on the receiver, which can be used to enumerate
	its elements."

	| enum |
	enum := IEnumStruct elementClass: STATSTG.
	self 
		EnumElements: 0
		reserved2: nil
		reserved3: 0
		ppenum: enum.
	^enum!

isAutoConvert
	"Answer whether the receiver has the auto convert class bit set."

	^(OLELibrary default getConvertStg: self) == S_OK!

isAutoConvert: aBoolean 
	"Mark the receiver for conversion to a different class on next load,
	depending on the <boolean> argument, aBoolean."

	^OLELibrary default setConvertStg: self fConvert: aBoolean!

move: elementName to: anIStorage 
	"Move the named element in the receiver (which may be a sub-storage or stream)
	to the destination storage, anIStorage.
	This is the equivalent of the file system 'move' command."

	self 
		move: elementName
		to: anIStorage
		withName: elementName!

move: elementName to: anIStorage withName: newElementName 
	"Move the named element in the receiver (which may be a sub-storage or stream)
	to the destination storage, anIStorage, renaming it to newElementName.
	This is the equivalent of the file system 'move' command."

	self 
		MoveElementTo: elementName
		pstgDest: anIStorage
		pwcsNewName: newElementName
		grfFlags: STGMOVE_MOVE!

MoveElementTo: pwcsName pstgDest: pstgDest pwcsNewName: pwcsNewName grfFlags: grfFlags
	"Invoke the MoveElementTo() method of the object wrapped by the receiver.
	
		HRESULT __stdcall MoveElementTo(
			[in] LPWSTR pwcsName,
			[in] IStorage* pstgDest,
			[in] LPWSTR pwcsNewName,
			[in] unsigned long grfFlags);

	"

	<virtual stdcall: hresult 9 lpwstr IStorage* lpwstr dword>
	^self invalidCall: _failureCode!

newStorage: storageName 
	"Instantiate and answer an IStorage on a new named sub-storage in the receiver
	with the default mode."

	^self newStorage: storageName mode: self defaultMode!

newStorage: storageName mode: stgMode 
	"Instantiate and answer an IStorage on a new named sub-storage 
	im the receiver with the specified access modes."

	^self 
		newStorage: storageName
		mode: stgMode
		format: STGFMT_DOCUMENT!

newStorage: storageName mode: dwMode format: dwFormat
	"Instantiate and answer an IStorage on a new named substorage 
	im the receiver with the specified access modes and format."

	| answer |
	answer := IStorage newPointer.
	self
		CreateStorage: storageName asUtf16String
		grfMode: dwMode
		dwStgFmt: dwFormat
		reserved2: 0
		ppstg: answer.
	^answer!

newStream: streamName 
	"Instantiate and answer a new IStream in the receiver."

	^self newStream: streamName mode: self defaultMode!

newStream: streamName mode: stgMode
	"Instantiate and answer a new IStream in the receiver with the specified access modes."

	| answer |
	answer := IStream newPointer.
	self
		CreateStream: streamName asUtf16String
		grfMode: stgMode
		reserved1: 0
		reserved2: 0
		ppstm: answer.
	^answer!

openStorage: storageName 
	"Open the existing storage of the specified name in the receiver, and answer an
	IStorage on it with the default access modes."

	^self openStorage: storageName mode: self defaultMode!

openStorage: storageName mode: stgMode
	"Open the existing stream of the specified name in the receiver, and answer an
	IStream on it with the specified access modes."

	| answer |
	answer := IStorage newPointer.
	self
		OpenStorage: storageName asUtf16String
		pstgPriority: nil
		grfMode: (stgMode bitOr: STGM_SHARE_EXCLUSIVE)
		snbExclude: nil
		reserved: 0
		ppstg: answer.	"Help says must specify this"	"Help says must be NULL, else STG_E_INVALIDPARAMETER"
	^answer!

OpenStorage: pwcsName pstgPriority: pstgPriority grfMode: grfMode snbExclude: snbExclude reserved: reserved ppstg: ppstg
	"Invoke the OpenStorage() method of the object wrapped by the receiver.
	
		HRESULT __stdcall OpenStorage(
			[in] LPWSTR pwcsName,
			[in] IStorage* pstgPriority,
			[in] unsigned long grfMode,
			[in] wireSNB snbExclude,
			[in] unsigned long reserved,
			[out] IStorage** ppstg);

	"

	<virtual stdcall: hresult 7 lpwstr IStorage* dword lpvoid dword IStorage**>
	^self invalidCall: _failureCode!

openStream: streamName 
	"Open the existing stream of the specified name in the receiver, and answer an
	IStream on it with the default access modes."

	^self openStream: streamName mode: self defaultMode!

openStream: streamName mode: stgMode
	"Open the existing stream of the specified name in the receiver, and answer an
	IStream on it with the specified access modes."

	| answer |
	answer := IStream newPointer.
	self
		OpenStream: streamName asUtf16String
		reserved1: 0
		grfMode: stgMode
		reserved2: 0
		ppstm: answer.	"STGM_SHARE_EXCLUSIVE must be specified"
	^answer!

OpenStream: pwcsName reserved1: reserved1 grfMode: grfMode reserved2: reserved2 ppstm: ppstm
	"Invoke the RemoteOpenStream() method of the object wrapped by the receiver.
	
		HRESULT __stdcall RemoteOpenStream(
			[in] LPWSTR pwcsName,
			[in] byte* reserved1,
			[in] unsigned long grfMode,
			[in] unsigned long reserved2,
			[out] IStream** ppstm);

	"

	<virtual stdcall: hresult 5 lpwstr sbyte* dword dword IStream**>
	^self invalidCall: _failureCode!

rename: string1 to: string2
	"Change the name of the element of the receiver currently called, string1, to,
	string2.
	This is the equivalent of the file system 'rename' command."

	self RenameElement: string1 asUtf16String pwcsNewName: string2 asUtf16String!

RenameElement: pwcsOldName pwcsNewName: pwcsNewName
	"Invoke the RenameElement() method of the object wrapped by the receiver.
	
		HRESULT __stdcall RenameElement(
			[in] LPWSTR pwcsOldName,
			[in] LPWSTR pwcsNewName);

	"

	<virtual stdcall: hresult 14 lpwstr lpwstr>
	^self invalidCall: _failureCode!

Revert
	"Invoke the Revert() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Revert();

	"

	<virtual stdcall: hresult 11>
	^self invalidCall: _failureCode!

rollback
	"Rollback modifications to the receiver since the last checkpoint."

	self Revert!

SetClass: clsid
	"Invoke the SetClass() method of the object wrapped by the receiver.
	
		HRESULT __stdcall SetClass(
			[in] GUID* clsid);

	"

	<virtual stdcall: hresult 16 guid*>
	^self invalidCall: _failureCode!

setCLIPFORMAT: cf userType: aString
	"Set the clipboard format and user type for the receiver."

	OLELibrary default
		writeFmtUserTypeStg: self
		cf: cf
		lpszUserType: aString asUtf16String!

SetElementTimes: pwcsName pctime: pctime patime: patime pmtime: pmtime
	"Invoke the SetElementTimes() method of the object wrapped by the receiver.
	
		HRESULT __stdcall SetElementTimes(
			[in] LPWSTR pwcsName,
			[in] FILETIME* pctime,
			[in] FILETIME* patime,
			[in] FILETIME* pmtime);

	"

	<virtual stdcall: hresult 15 lpwstr FILETIME* FILETIME* FILETIME*>
	^self invalidCall: _failureCode!

SetStateBits: grfStateBits grfMask: grfMask
	"Invoke the SetStateBits() method of the object wrapped by the receiver.
	
		HRESULT __stdcall SetStateBits(
			[in] unsigned long grfStateBits,
			[in] unsigned long grfMask);

	"

	<virtual stdcall: hresult 17 dword dword>
	^self invalidCall: _failureCode!

stat
	"Answer a STATSTG structure populated with stats for the receiver.
	Simplified wrapper around #Stat:grfStateFlag:."

	| struct |
	struct := STATSTG new.
	self Stat: struct grfStatFlag: STATFLAG_DEFAULT.
	^struct!

Stat: pstatstg grfStatFlag: grfStatFlag
	"Invoke the Stat() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Stat(
			[out] STATSTG* pstatstg,
			[in] unsigned long grfStatFlag);

	"

	<virtual stdcall: hresult 18 STATSTG* dword>
	^self invalidCall: _failureCode! !
!IStorage categoriesFor: #close!operations!public! !
!IStorage categoriesFor: #clsid!accessing!public! !
!IStorage categoriesFor: #clsid:!accessing!public! !
!IStorage categoriesFor: #Commit:!**auto generated**!COM Interfaces-OBJIDL.IStorage!primitives!public! !
!IStorage categoriesFor: #copy:to:!operations!public! !
!IStorage categoriesFor: #copy:to:withName:!operations!public! !
!IStorage categoriesFor: #CopyTo:rgiidExclude:snbExclude:pstgDest:!**auto generated**!COM Interfaces-OBJIDL.IStorage!primitives!public! !
!IStorage categoriesFor: #CreateStorage:grfMode:dwStgFmt:reserved2:ppstg:!**auto generated**!COM Interfaces-OBJIDL.IStorage!primitives!public! !
!IStorage categoriesFor: #CreateStream:grfMode:reserved1:reserved2:ppstm:!**auto generated**!COM Interfaces-OBJIDL.IStorage!primitives!public! !
!IStorage categoriesFor: #defaultMode!constants!public! !
!IStorage categoriesFor: #delete:!operations!public! !
!IStorage categoriesFor: #DestroyElement:!**auto generated**!COM Interfaces-OBJIDL.IStorage!primitives!public! !
!IStorage categoriesFor: #directory!accessing!public! !
!IStorage categoriesFor: #doAutoConvert!operations!public! !
!IStorage categoriesFor: #EnumElements:reserved2:reserved3:ppenum:!**auto generated**!COM Interfaces-OBJIDL.IStorage!primitives!public! !
!IStorage categoriesFor: #fastFlush!operations!public! !
!IStorage categoriesFor: #flush!operations!public! !
!IStorage categoriesFor: #getCLIPFORMATAndUserType!accessing!public! !
!IStorage categoriesFor: #iEnumStats!accessing!private! !
!IStorage categoriesFor: #isAutoConvert!public!testing! !
!IStorage categoriesFor: #isAutoConvert:!modes!public! !
!IStorage categoriesFor: #move:to:!operations!public! !
!IStorage categoriesFor: #move:to:withName:!operations!public! !
!IStorage categoriesFor: #MoveElementTo:pstgDest:pwcsNewName:grfFlags:!**auto generated**!COM Interfaces-OBJIDL.IStorage!primitives!public! !
!IStorage categoriesFor: #newStorage:!operations!public! !
!IStorage categoriesFor: #newStorage:mode:!operations!public! !
!IStorage categoriesFor: #newStorage:mode:format:!operations!public! !
!IStorage categoriesFor: #newStream:!operations!public! !
!IStorage categoriesFor: #newStream:mode:!operations!public! !
!IStorage categoriesFor: #openStorage:!operations!public! !
!IStorage categoriesFor: #openStorage:mode:!operations!public! !
!IStorage categoriesFor: #OpenStorage:pstgPriority:grfMode:snbExclude:reserved:ppstg:!**auto generated**!COM Interfaces-OBJIDL.IStorage!primitives!public! !
!IStorage categoriesFor: #openStream:!operations!public! !
!IStorage categoriesFor: #openStream:mode:!operations!public! !
!IStorage categoriesFor: #OpenStream:reserved1:grfMode:reserved2:ppstm:!**auto generated**!COM Interfaces-OBJIDL.IStorage!primitives!public! !
!IStorage categoriesFor: #rename:to:!operations!public! !
!IStorage categoriesFor: #RenameElement:pwcsNewName:!**auto generated**!COM Interfaces-OBJIDL.IStorage!primitives!public! !
!IStorage categoriesFor: #Revert!**auto generated**!COM Interfaces-OBJIDL.IStorage!primitives!public! !
!IStorage categoriesFor: #rollback!operations!public! !
!IStorage categoriesFor: #SetClass:!**auto generated**!COM Interfaces-OBJIDL.IStorage!primitives!public! !
!IStorage categoriesFor: #setCLIPFORMAT:userType:!accessing!public! !
!IStorage categoriesFor: #SetElementTimes:pctime:patime:pmtime:!**auto generated**!COM Interfaces-OBJIDL.IStorage!primitives!public! !
!IStorage categoriesFor: #SetStateBits:grfMask:!**auto generated**!COM Interfaces-OBJIDL.IStorage!primitives!public! !
!IStorage categoriesFor: #stat!accessing!public! !
!IStorage categoriesFor: #Stat:grfStatFlag:!**auto generated**!COM Interfaces-OBJIDL.IStorage!primitives!public! !

IStorage methodProtocol: #IStorage attributes: #(#readOnly) selectors: #(#Commit: #CopyTo:rgiidExclude:snbExclude:pstgDest: #CreateStorage:grfMode:dwStgFmt:reserved2:ppstg: #CreateStream:grfMode:reserved1:reserved2:ppstm: #DestroyElement: #EnumElements:reserved2:reserved3:ppenum: #MoveElementTo:pstgDest:pwcsNewName:grfFlags: #OpenStorage:pstgPriority:grfMode:snbExclude:reserved:ppstg: #OpenStream:reserved1:grfMode:reserved2:ppstm: #RenameElement:pwcsNewName: #Revert #SetClass: #SetElementTimes:pctime:patime:pmtime: #SetStateBits:grfMask: #Stat:grfStatFlag:)!

!IStorage class methodsFor!

create: fileName 
	"Answer an instance of the receiver on a new DocFile with the specified
	name and the default access mode."

	^self create: fileName mode: self defaultCreateMode!

create: fileName mode: stgMode
	"Answer an instance of the receiver on a new compound file with the specified
	name. The access mode of the answered IStorage is as specified in the stgMode
	argument."

	| answer |
	answer := self newPointer.
	OLELibrary default
		stgCreateDocfile: fileName asUtf16String
		grfMode: stgMode
		reserved: 0
		ppstgOpen: answer.
	^answer

	"STGM_FAILIFTHERE is 0, and therefore has no effect!! STGM_CREATE must be specified in order to overwrite
	an existing file. If not, creation will only complete if the file does not exist."!

createOnILockBytes: anILockBytes 
	"Answer a new instance of the receiver set up to create a new storage on the 
	specified ILockBytes with default access mode (not transacted, read/write, exclusive)."

	^self createOnILockBytes: anILockBytes mode: self defaultCreateMode!

createOnILockBytes: anILockBytes mode: grfMode 
	"Answer a new instance of the receiver set up to create a new storage
	on the specified ILockBytes, with the <integer> mode flags, grfMode,
	taken from the STGM enumeration."

	| answer |
	answer := self newPointer.
	OLELibrary default 
		stgCreateDocfileOnILockBytes: anILockBytes
		grfMode: grfMode
		reserved: 0
		ppstgOpen: answer.
	^answer!

defaultCreateMode
	"Answer the default access mode for a newly created storage."

	^##(STGM_CREATE | STGM_READWRITE | STGM_SHARE_EXCLUSIVE)!

defaultOpenMode
	"Answer the default access mode for a opening an existing storage."

	^##(STGM_READWRITE | STGM_SHARE_EXCLUSIVE)!

defineFunctions
	"Declare the virtual function table for the COM interface 'OBJIDL.IStorage'
		IStorage defineTemplate
	"

	self
		defineFunction: #CreateStream:grfMode:reserved1:reserved2:ppstm:
			argumentTypes: 'lpwstr dword dword dword IStream**';
		defineFunction: #OpenStream:reserved1:grfMode:reserved2:ppstm:
			argumentTypes: 'lpwstr sbyte* dword dword IStream**';
		defineFunction: #CreateStorage:grfMode:dwStgFmt:reserved2:ppstg:
			argumentTypes: 'lpwstr dword dword dword IStorage**';
		defineFunction: #OpenStorage:pstgPriority:grfMode:snbExclude:reserved:ppstg:
			argumentTypes: 'lpwstr IStorage* dword lpvoid dword IStorage**';
		defineFunction: #CopyTo:rgiidExclude:snbExclude:pstgDest:
			argumentTypes: 'dword GUID* lpvoid IStorage*';
		defineFunction: #MoveElementTo:pstgDest:pwcsNewName:grfFlags:
			argumentTypes: 'lpwstr IStorage* lpwstr dword';
		defineFunction: #Commit: argumentTypes: 'dword';
		defineFunction: #Revert;
		defineFunction: #EnumElements:reserved2:reserved3:ppenum:
			argumentTypes: 'dword sbyte* dword void**';
		defineFunction: #DestroyElement: argumentTypes: 'lpwstr';
		defineFunction: #RenameElement:pwcsNewName: argumentTypes: 'lpwstr lpwstr';
		defineFunction: #SetElementTimes:pctime:patime:pmtime:
			argumentTypes: 'lpwstr FILETIME* FILETIME* FILETIME*';
		defineFunction: #SetClass: argumentTypes: 'GUID*';
		defineFunction: #SetStateBits:grfMask: argumentTypes: 'dword dword';
		defineFunction: #Stat:grfStatFlag: argumentTypes: 'STATSTG* dword'.
	#todo.	"Worry about SNB (String name block)"
	#todo	"Implement CopyTo() wrapper functions if required"!

initializeModeMaps
	"Private - Initialize the  following.

		ShareModes		Map between portable share mode symbols and OLE flag values.
		CheckModes	 	Map between portable access mode symbols and OLE flag values 
						with error checking.
		NoCheckModes		Ditto, without error checking."

	"N.B. The portable modes specify the type of sharing permitted, not denied"

	"	ShareModes := ##(
		IdentityDictionary new
			at: #read			put: STGM_SHARE_DENY_WRITE;
			at: #write		put: STGM_SHARE_DENY_WRITE;
			at: #readWrite		put: STGM_SHARE_DENY_NONE;
			at: #exclusive		put: STGM_SHARE_EXCLUSIVE;
			shrink;
			yourself).
	
	CheckModes := ##(
		IdentityDictionary new
			at: #read			put: STGM_READ;
			at: #create		put: STGM_CREATE | STGM_FAILIFTHERE | STGM_READWRITE;
			at: #open			put: STGM_READWRITE | STGM_READWRITE;
			at: #append		put: STGM_READWRITE;
			at: #truncate		put: STGM_CREATE | STGM_READWRITE;
			shrink;
			yourself).

	NoCheckModes := ##(
		IdentityDictionary new
			at: #read			put: STGM_READ;
			at: #create		put: STGM_CREATE | STGM_READWRITE;
			at: #open			put: STGM_READWRITE;
			at: #append		put: STGM_READWRITE;
			at: #truncate		put: STGM_CREATE | STGM_READWRITE;
			shrink;
			yourself)
"

	!

onILockBytes
	"Answer a new instance of the receiver on an global memory ILockBytes."

	^self onILockBytes: ILockBytes onHGLOBAL!

onILockBytes: anILockBytes 
	"Answer a new instance of the receiver on the specified ILockBytes with
	default access mode (not transacted, read/write, exclusive)."

	^self onILockBytes: anILockBytes mode: ##(STGM_CREATE | STGM_READWRITE | STGM_SHARE_EXCLUSIVE)!

onILockBytes: anILockBytes mode: grfMode 
	"Answer a new instance of the receiver on the specified ILockBytes."

	| answer |
	answer := self newPointer.
	OLELibrary default 
		stgCreateDocfileOnILockBytes: anILockBytes
		grfMode: grfMode
		reserved: 0
		ppstgOpen: answer.
	^answer!

open: pathName 
	"Open the specified compound document file, and answer an instance of the receiver for
	accessing it. The compound file is opened in the default mode, read/write, write exclusive,
	transacted."

	^self open: pathName mode: self defaultOpenMode	" ##(STGM_TRANSACTED | STGM_READWRITE | STGM_SHARE_DENY_WRITE)"!

open: pathName mode: stgMode
	"Open the specified compound document file, and answer an instance of the receiver for
	accessing it. The compound file is opened in the specified mode which is a combination
	of the following flags:

		STGM_READ 				- Request read access (default)
		STGM_WRITE				- Request write access. Allows changes to be committed
							  	(i.e. read-only storages can be written too if transacted, but commit will fail)
		STGM_READWRITE 			- Request read and write access
		STGM_SHARE_DENY_NONE 	- No locking
		STGM_SHARE_DENY_READ 	- Read lock
		STGM_SHARE_DENY_WRITE 	- Write lock  
  		STGM_SHARE_EXCLUSIVE 	- Exclusive lock
		STGM_DIRECT 			- Not transacted, changes written immediately, no rollback (default)
		STGM_TRANSACTED 		- Transacted, can be rolled back, must be committed
		STGM_CREATE			- Create if not found
		STGM_CONVERT			- Convert if not a compound document file
		STGM_FAILIFTHERE		- Do not overwrite existing storages/streams when creating (default)
							  	Specify STGM_CREATE as the alternative (but only with create methods).
		STGM_PRIORITY			- High performance, unsociable, read-only access mode 
		STGM_DELETEONRELEASE	- Deletes the storage when released (e.g. for temporary storages)"

	| answer |
	answer := self newPointer.
	OLELibrary default
		stgOpenStorage: pathName asUtf16String
		pstgPriority: nil
		grfMode: stgMode
		snbExclude: nil
		reserved: 0
		ppstgOpen: answer.
	^answer!

openOnILockBytes: anILockBytes 
	"Answer a new instance of the receiver opened on the existing storage whose data resides in the
	the specified <ILockBytes> with default access mode (not transacted, read/write, exclusive)."

	^self openOnILockBytes: anILockBytes mode: self defaultOpenMode!

openOnILockBytes: anILockBytes mode: grfMode 
	"Answer a new instance of the receiver on an existing storage whose
	data is accessible via the specified ILockBytes, with the <integer> mode 
	flags, grfMode, taken from the STGM enumeration."

	| answer |
	answer := self newPointer.
	OLELibrary default 
		stgOpenStorageOnILockBytes: anILockBytes
		pstgPriority: nil
		grfMode: grfMode
		snbExclude: nil
		reserved: 0
		ppstgOpen: answer.
	^answer! !
!IStorage class categoriesFor: #create:!instance creation!public! !
!IStorage class categoriesFor: #create:mode:!instance creation!public! !
!IStorage class categoriesFor: #createOnILockBytes:!instance creation!public! !
!IStorage class categoriesFor: #createOnILockBytes:mode:!instance creation!public! !
!IStorage class categoriesFor: #defaultCreateMode!constants!public! !
!IStorage class categoriesFor: #defaultOpenMode!constants!public! !
!IStorage class categoriesFor: #defineFunctions!initializing!public! !
!IStorage class categoriesFor: #initializeModeMaps!initializing!private! !
!IStorage class categoriesFor: #onILockBytes!instance creation!public! !
!IStorage class categoriesFor: #onILockBytes:!instance creation!public! !
!IStorage class categoriesFor: #onILockBytes:mode:!instance creation!public! !
!IStorage class categoriesFor: #open:!instance creation!public! !
!IStorage class categoriesFor: #open:mode:!instance creation!public! !
!IStorage class categoriesFor: #openOnILockBytes:!instance creation!public! !
!IStorage class categoriesFor: #openOnILockBytes:mode:!instance creation!public! !

