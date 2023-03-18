"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Graphics.GraphicsTool'
	instanceVariableNames: 'handle ownsHandle'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.GraphicsTool guid: (Core.GUID fromString: '{87b4c48d-026e-11d3-9fd7-00a0cc3e4a32}')!
Graphics.GraphicsTool isNonInstantiable: true!
Graphics.GraphicsTool comment: ''!
!Graphics.GraphicsTool categoriesForClass!Graphics-Tools! !
!Graphics.GraphicsTool methodsFor!

asParameter
	"Answer the receiver in a form suitable for an API call."

	^self handle!

basicFree
	"Private - Free up external resources held by the receiver.
	Ignore any errors which might arise."

	Gdi32 deleteObject: handle!

basicHandle
	"Answer the receiver's handle instance variable.
	Does not cause the receiver to be realized."

	^handle!

basicRealize
	"Private - Realize (create) the external resource associated with the receiver, sent from
	the public method, #realize, if not already realized."

	self ownedHandle: self createHandle!

clearCached
	"Private - Clear down the receiver's cached information and handles.
	Should be overridden by subclasses which wish to clear down other
	handles and cached information."

	handle := nil!

createHandle
	"Private - Create and answer an external resource handle associated with the receiver.
	This may be installed as the handle of the receiver if called from #basicRealize or it
	may be used by third parties who require a duplicate handle"

	^self subclassResponsibility!

detachHandle
	"Answer the receiver's handle, and it is owned, relinquish ownership
	to the caller."

	| hTool |
	hTool := self handle.	"May realize the object"
	ownsHandle ifTrue: [self beUnfinalizable].
	self clearCached.
	^hTool!

equals: anObject
	"GraphicTools are considered equal if they are identical
	or they have the same handle. We only include the identity check
	to early out of the possibly expensive handle test (we may need to
	realize the graphics objects to get the handles)."

	^self == anObject or: [self handle = anObject handle].!

free
	"Free external resources held by the receiver, and leave in a state such
	that the receiver will be re-realized the next time it is accessed."

	(self isRealized and: [self ownsHandle]) 
		ifTrue: 
			[self beUnfinalizable.
			self basicFree].
	self clearCached!

getData: aWinStruct
	"Private - Get the data bytes of the receiver's external resource object into	
	the specified structure. N.B. This only works for GDI objects."

	^Gdi32
		getObject: self asParameter
		cbBuffer: aWinStruct byteSize
		lpvObject: aWinStruct!

getDataW: aWinStruct
	"Private - Get the data bytes of the receiver's external resource object into	
	the specified structure. N.B. This only works for GDI objects."

	^Gdi32
		getObjectW: self asParameter
		cbBuffer: aWinStruct byteSize
		lpvObject: aWinStruct!

getStockObject: anInteger
	"Private - Get the handle of the specified stock object."

	^Gdi32 getStockObject: anInteger!

handle
	"Answer the receiver's handle. If unrealized then attempt to realize it first."

	handle isNil
		ifTrue: [self realize].
	^handle!

handle: aHandle
	"Private - Set the receiver's handle to aHandle. Answer the receiver.
	Note: If aHandle isNil, then it is stored as 0 to prevent any subsequent attempt
	to lazily realize the receiver. Thus only one lazy realization attempt is made, 
	this does mean, however, that the handle cannot be set to nil via this mutator."

	handle := aHandle isNil 
		ifTrue: [0]		"prevent subsequent attempts to lazy init."
		ifFalse: [aHandle asParameter]!

initialize
	"Initialize the receiver's instance variables."

	ownsHandle := true	"By default instances will free their handles on finalization"!

isPersistent
	"Private - Answer true if the receiver holds sufficient information such that
	it can recreate itself when the image is saved and restored. This is also
	an indication as to whether the receiver can be filed out/in using the STB
	mechanism. Generally this ability corresponds to a useful implementation
	of #basicRealize."

	"Implementation Note: It turns out that most GraphicsTools are persistent, so it make sense for the 
	the default to be true (rather than false as it was in 5.01 and earlier)"

	^true!

isRealized
	"Answer true if the receiver is realized."

	^handle notNil!

onExit
	"Private - The session is about to end, ensure any resources held by the receiver are
	free'd. We use #free (instead of #basicFree) just in case the receiver is
	already freed."

	self free
!

onStartup
	"Private - The system is starting. Ensure no invalid handles remain."

	self clearCached!

ownedHandle: aHandle
	"Private - Set the handle of the external graphics's tool object represented and owned by
	the receiver to be the argument."

	self handle: aHandle.
	ownsHandle := true.
	self beFinalizable!

ownsHandle
	"Answer whether the receiver owns the handle it is holding"

	^ownsHandle!

ownsHandle: aBoolean
	"Private - Record whether the receiver owns the handle it is holding, and will
	therefore release it when finalized. Answer the receiver."

	ownsHandle := aBoolean!

postCopy
	"Apply any final flourish to the copy that may be required. GraphicsTools hold onto an
	external resource, which can't be shared in case the owner free's it."

	self clearCached.
	^self!

realize
	"Realize (create) the external resource associated with the receiver, but only if not
	already realized."

	^self isRealized ifFalse: [self basicRealize]!

stbFixup: anSTBInFiler at: newObjectIndex
	"Answer the true object that must be used to represent the receiver when read from anSTBInFiler,
	and also perform any post load fixup that might be needed."

	self clearCached.
	^super stbFixup: anSTBInFiler at: newObjectIndex!

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler.
	Only sub-instances of the receiver that are capable of persistency, i.e.
	they hold enough information to re-create themselves, can be filed out."

	self isPersistent ifFalse: [self error: 'Cannot #stbSaveOn: ' , self printString].
	anSTBOutFiler override: handle with: nil.
	[super stbSaveOn: anSTBOutFiler] ensure: [anSTBOutFiler removeOverrideFor: handle]! !
!Graphics.GraphicsTool categoriesForMethods!
asParameter!converting!public! !
basicFree!private!realizing/unrealizing! !
basicHandle!accessing!public! !
basicRealize!private!realizing/unrealizing! !
clearCached!private!realizing/unrealizing! !
createHandle!private!realizing/unrealizing! !
detachHandle!accessing!public! !
equals:!comparing!public! !
free!public!realizing/unrealizing! !
getData:!accessing!private! !
getDataW:!accessing!private! !
getStockObject:!accessing!private! !
handle!accessing!public! !
handle:!accessing!private! !
initialize!initializing!public! !
isPersistent!private!testing! !
isRealized!public!testing! !
onExit!event handling!private! !
onStartup!event handling!private! !
ownedHandle:!accessing!private! !
ownsHandle!public!testing! !
ownsHandle:!initializing!private! !
postCopy!copying!public! !
realize!public!realizing/unrealizing! !
stbFixup:at:!binary filing!public! !
stbSaveOn:!binary filing!public! !
!

!Graphics.GraphicsTool class methodsFor!

fromHandle: aHandle
	"Answers an instance of the receiver with aHandle. The handle is not
	owned by the instance and will not therefore be freed by it."

	^self new
		ownsHandle: false;
		handle: aHandle!

fromOwnedHandle: aHandle 
	"Answers an instance of the receiver with aHandle. The handle is owned by the instance and
	will therefore be freed by it."

	^(self new)
		ownedHandle: aHandle;
		yourself!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

new
	"Answer a new, properly initialized, instance of the receiver."

	^super new initialize!

onExit
	"Ensure all the receiver's subinstances are in their 'invalidated' state on exit
	so that they have released any external resources they are holding."

	self primAllSubinstances do: [:i | i onExit]!

onStartup
	"Ensure all the receiver's subinstances are in their 'invalidated' state on startup
	so that they rebuild their external resource when required rather than attempting
	to use an old handle hanging around from the sesssion when the image was saved."

	self primAllSubinstances do: [:i | i onStartup].
	self onStartup2!

onStartup2
	"Private - Perform system startup processing for all subclasses."

	self allSubclassesDo: [:c | (c class includesSelector: #onStartup2) ifTrue: [c onStartup2]]! !
!Graphics.GraphicsTool class categoriesForMethods!
fromHandle:!instance creation!public! !
fromOwnedHandle:!instance creation!public! !
icon!constants!public! !
new!instance creation!public! !
onExit!event handling!public! !
onStartup!event handling!public! !
onStartup2!event handling!private! !
!

