"Filed out from Dolphin Smalltalk"!

Core.SequenceableCollection
	subclass: #'UI.DroppedFilesList'
	instanceVariableNames: 'handle size'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.DroppedFilesList guid: (Core.GUID fromString: '{63eb134a-0edd-49f3-85eb-253b0f48741b}')!
UI.DroppedFilesList comment: 'DroppedFilesList represents a <sequencedReadableCollection> of dropped files. The elements are the <readableString> paths of the files that were dropped over a window which has called the DragAcceptFiles API.'!
!UI.DroppedFilesList categoriesForClass!Kernel-Objects! !
!UI.DroppedFilesList methodsFor!

add: newElement 
	^self shouldNotImplement!

at: index
	"Answer the element at the specified <integer> index of the receiver."

	| cch answer |
	(index < 1 or: [index > self size]) ifTrue: [^self errorSubscriptBounds: index].
	cch := Shell32
				dragQueryFile: handle
				iFile: index - 1
				lpszFile: nil
				cch: 0.
	answer := Utf16String newFixed: cch.
	"Note that although DragQueryFile returns the number of chars required excluding the null
	terminator, one has to tell it the complete length of the buffer including the null
	terminator."
	Shell32
		dragQueryFile: handle
		iFile: index - 1
		lpszFile: answer
		cch: cch + 1.
	^answer!

at: index put: newElement 
	^self shouldNotImplement!

basicFree
	| hdrop |
	hdrop := handle.
	handle := nil.
	Shell32 dragFinish: hdrop!

free
	handle isNull ifTrue: [^self].
	self beUnfinalizable.
	self basicFree!

position
	"Answer a <Point> representing the position at which the files were dropped."

	| struct |
	struct := POINTL newBuffer.
	Shell32 dragQueryPoint: handle lppt: struct.
	^struct asPoint!

setHandle: anExternalHandle
	handle := anExternalHandle.
	self beFinalizable!

size
	"Answer the element at the specified <integer> index of the receiver."

	size
		ifNil: 
			[size := Shell32
						dragQueryFile: handle
						iFile: -1
						lpszFile: nil
						cch: 0].
	^size! !
!UI.DroppedFilesList categoriesForMethods!
add:!adding!public! !
at:!accessing!public! !
at:put:!accessing!public! !
basicFree!finalizing!private! !
free!finalizing!public! !
position!public! !
setHandle:!initializing!private! !
size!accessing!public! !
!

!UI.DroppedFilesList class methodsFor!

fromHandle: anExternalHandle 
	^self new setHandle: anExternalHandle! !
!UI.DroppedFilesList class categoriesForMethods!
fromHandle:!public! !
!

