"Filed out from Dolphin Smalltalk"!

SequenceableCollection subclass: #DroppedFilesList
	instanceVariableNames: 'handle size'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DroppedFilesList guid: (GUID fromString: '{63eb134a-0edd-49f3-85eb-253b0f48741b}')!

DroppedFilesList comment: 'DroppedFilesList represents a <sequencedReadableCollection> of dropped files. The elements are the <readableString> paths of the files that were dropped over a window which has called the DragAcceptFiles API.'!

!DroppedFilesList categoriesForClass!Kernel-Objects! !

!DroppedFilesList methodsFor!

add: newElement 
	^self shouldNotImplement!

at: index 
	"Answer the element at the specified <integer> index of the receiver."

	| cch answer |
	(index < 1 or: [index > self size]) ifTrue: [^self errorSubscriptBounds: index].
	cch := ShellLibrary default 
				dragQueryFile: handle
				iFile: index - 1
				lpszFile: nil
				cch: 0.
	answer := Utf16String newFixed: cch.
	"Note that although DragQueryFile returns the number of chars required excluding the null
	terminator, one has to tell it the complete length of the buffer including the null
	terminator."
	ShellLibrary default 
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
	ShellLibrary default dragFinish: hdrop!

free
	handle isNull ifTrue: [^self].
	self beUnfinalizable.
	self basicFree!

position
	"Answer a <Point> representing the position at which the files were dropped."

	| struct |
	struct := POINTL new.
	ShellLibrary default dragQueryPoint: handle lppt: struct.
	^struct asPoint!

setHandle: anExternalHandle
	handle := anExternalHandle.
	self beFinalizable!

size
	"Answer the element at the specified <integer> index of the receiver."

	size 
		ifNil: 
			[size := ShellLibrary default 
						dragQueryFile: handle
						iFile: -1
						lpszFile: nil
						cch: 0].
	^size! !

!DroppedFilesList categoriesForMethods!
add:!adding!public! !
at:!accessing!public! !
at:put:!accessing!public! !
basicFree!finalizing!private! !
free!finalizing!public! !
position!public! !
setHandle:!initializing!private! !
size!accessing!public! !
!

!DroppedFilesList class methodsFor!

fromHandle: anExternalHandle 
	^self new setHandle: anExternalHandle! !

!DroppedFilesList class categoriesForMethods!
fromHandle:!public! !
!

