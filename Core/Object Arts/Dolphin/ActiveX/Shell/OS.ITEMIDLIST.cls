﻿"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.ITEMIDLIST'
	instanceVariableNames: 'back'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_ITEMIDLIST_Size' -> 16r4 }!

OS.ITEMIDLIST guid: (Core.GUID fromString: '{928070c1-45d5-4739-b2b1-01e8c27361dc}')!

OS.ITEMIDLIST comment: 'ITEMIDLIST is an <ExternalStructure> that wraps the Windows ITEMIDLIST struct.  ITEMIDLIST serves the same purpose as a file system path, i.e., to identify objects (be they files, folders, virtual or part of the filesystem) in the Windows Shell namespace.  An ITEMIDLIST contains one or more item IDs (a Windows SHITEMID structure), terminated by a two-byte null.

There are two types of ITEMIDLIST -- full and relative.  A full (or absolute) ITEMIDLIST contains a packed list of item ids that together uniquely identifies a shell object relative to the desktop.  A relative ITEMIDLIST contains a packed list of item ids that together uniquely identifies a shell object relative to its parent folder.  In most cases, a relative ITEMIDLIST will contain only one item id.  However, multi-level relative ITEMIDLISTs are also used.  See individual method comments for which type of ITEMIDLIST is expected.

For the Shell API, namespace objects are usually identified by a pointer to their ITEMIDLIST structure, also known as a PIDL.  For this reason, most methods that create an ITEMIDLIST actually create a pointer that is passed to Windows which allocates memory and fills the structure.  The pointer is a WindowsShellMemory instance which is finalizable and so will free the memory it points to when it is garbage collected.

Instance Variables:
	back	<ITEMIDLIST>	Used to prevent an ITEMIDLIST being garbage collected when a new ITEMIDLIST has been constructed on the same memory.'!

!OS.ITEMIDLIST methodsFor!

append: anITEMIDLIST 
	"Answer a copy of the receiver with anITEMIDLIST appended"

	| mySize totalSize copy |
	totalSize := (mySize := self getSize) + anITEMIDLIST getSize + 2.
	copy := self class new: totalSize.
	self 
		replaceBytesOf: copy bytes
		from: 1
		to: mySize
		startingAt: 1.
	anITEMIDLIST 
		replaceBytesOf: copy bytes
		from: mySize + 1
		to: totalSize
		startingAt: 1.
	^copy!

back
	^back!

back: anITEMIDLIST
	"Keep a back pointer to stop anITEMIDLIST being garbage collected while the receiver is still using its external memory"

	back := anITEMIDLIST!

bufferClass
	^WindowsShellMemory!

cb
	"Answer the receiver's mkid.cb field as a Smalltalk object.
	This avoids creating the SHITEMID structure and directly accesses the mkid.cb field "

	^bytes int16AtOffset: 0!

cb: anObject
	"Set the receiver's mkid.cb field to the value of anObject."

	bytes int16AtOffset: 0 put: anObject!

getSize
	"Answer the number of bytes that the receiver uses.  Calculate the size by walking the id list
	and keeping track of the size of each SHITEMID  structure. "

	| sum pidl |
	sum := 0.
	pidl := self.
	[pidl notNil] whileTrue: 
			[sum := sum + pidl cb.
			pidl := pidl idNext].
	^sum!

idCopy
	"Answer an <ITEMIDLIST> that is a copy of the receiver."

	| copy totalSize |
	totalSize := self getSize + 2.
	copy := self class new: totalSize.
	self 
		replaceBytesOf: copy bytes
		from: 1
		to: totalSize
		startingAt: 1.
	^copy!

idLast
	"Answer a single <ITEMIDLIST> that contains the last item id of the receiver."

	| pidl pidlNext |
	pidl := self.
	pidlNext := self.
	[pidlNext notNil] whileTrue: 
			[pidl := pidlNext.
			pidlNext := pidl idNext].
	^pidl!

idNext
	"Answer a single <ITEMIDLIST> that contains the next item id of the receiver, or nil if there are no more elements."

	| cb instance |
	(cb := self cb) = 0 ifTrue: [^nil].
	"// Add cb to pidl (casting to increment by bytes). pidl = (LPITEMIDLIST) (((LPBYTE) pidl) + cb); "
	(instance := self class fromAddress: bytes yourAddress + cb) back: self.
	^instance cb = 0 ifTrue: [nil] ifFalse: [instance]!

idParent
	"Answer a full <ITEMIDLIST> that is the receiver's parent."

	| copy pidl pidlNext |
	copy := self idCopy.
	copy cb = 0 
		ifFalse: 
			[pidlNext := copy.
			[pidlNext notNil] whileTrue: 
					[pidl := pidlNext.
					pidlNext := pidl idNext].
			pidl cb: 0].
	^copy!

isDesktopID
	"Answer whether the receiver represents the Desktop item id list."

	^self cb = 0!

isSingle
	"Answer whether the receiver is a single item id.  NB: The full id of a desktop child will be single."

	^self idNext isNil!

isValid
	^bytes notNil!

onStartup
	"Private - ITEMIDLISTs are not themselves finalizable, but may hold a finalizable memory block."

	bytes beUnfinalizable.
	bytes := nil! !

!OS.ITEMIDLIST categoriesForMethods!
append:!operations!public! !
back!accessing!private! !
back:!accessing!private! !
bufferClass!constants!private! !
cb!accessing!public! !
cb:!accessing!public! !
getSize!operations!public! !
idCopy!operations!public! !
idLast!operations!public! !
idNext!operations!public! !
idParent!operations!public! !
isDesktopID!public!testing! !
isSingle!public!testing! !
isValid!public!testing! !
onStartup!event handling!public! !
!

!OS.ITEMIDLIST class methodsFor!

byteSize
	^_ITEMIDLIST_Size!

defineFields
	"Define the fields of the ITEMIDLIST structure.
		ITEMIDLIST compileDefinition
	
		typedef struct _ITEMIDLIST {
			SHITEMID mkid;
		} ITEMIDLIST;"

	"self 
		defineField: #mkid type: (StructureField type: SHITEMID) offset: 0."

	self byteSize: 4!

exampleCopying
	| path iDesktop id1 id2 |
	path := 'c:\program files'.
	iDesktop := Shell32 getDesktopFolder.
	id1 := iDesktop idlFromPath: path.
	id1 getSize.
	id2 := id1 idCopy.
	id2 getSize!

exampleWalkID: anITEMIDLIST
	"Step through each item id (SHITEMID) in anITEMIDLIST.  Answer a collection of Associations, 
	each consisting of an item id and its length.
		self exampleWalkID: (Shell32 getDesktopFolder idlFromPath: 'c:\program files')
	"

	| idFull coll |
	idFull := anITEMIDLIST idCopy.
	coll := OrderedCollection new.
	[idFull notNil] whileTrue: 
			[coll add: idFull -> idFull getSize.
			idFull := idFull idNext].
	^coll!

exampleWalking
	| path iDesktop id1 id2 |
	path := 'c:\program files'.
	iDesktop := Shell32 getDesktopFolder.
	id1 := iDesktop idlFromPath: path.
	id1 getSize.
	id2 := id1 idNext.
	id2 getSize!

exampleWalkPath: aString
	"Create an instance of the receiver based on the full pathname, aString, and step through each item id.
	Answer a collection of Associations, each consisting of an item id and its length.
		self exampleWalkPath: 'c:\program files'	
	"

	^self exampleWalkID: (Shell32 getDesktopFolder idlFromPath: aString)!

getFieldNames
	^#()!

initialize
	"Private - Initialize the receiver.
	Register with session events to clean up sub-instances on startup.
	
		ITEMIDLIST initialize
	"

	SessionManager current
		when: #sessionStarted
		send: #onStartup
		to: self!

new
	"Use #newPointer or #newBuffer to create an instance of the receiver."
	^self shouldNotImplement

"	^self newPointer"!

onStartup
	"Private - Ensure all the receiver's subinstances are in their clean state on startup
	rather than attempting to use an old safe array hanging around from the sesssion 
	when the image was saved."

	self primAllSubinstances do: [:i | i onStartup].
!

pointerClass
	"Private - Answer the default class to use as a pointer"

	^WindowsShellMemory!

uninitialize
	SessionManager current removeEventsTriggeredFor: self! !

!OS.ITEMIDLIST class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
exampleCopying!examples!public! !
exampleWalkID:!examples!public! !
exampleWalking!examples!public! !
exampleWalkPath:!examples!public! !
getFieldNames!**compiled accessors**!constants!private! !
initialize!development!initializing!private! !
new!instance creation!public! !
onStartup!event handling!private! !
pointerClass!constants!private! !
uninitialize!class hierarchy-removing!private! !
!

