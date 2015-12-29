"Filed out from Dolphin Smalltalk X6"!

SequenceableCollection subclass: #DroppedFilesList
	instanceVariableNames: 'handle size'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DroppedFilesList guid: (GUID fromString: '{63EB134A-0EDD-49F3-85EB-253B0F48741B}')!
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
	answer := String newFixed: cch.
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
!DroppedFilesList categoriesFor: #add:!adding!public! !
!DroppedFilesList categoriesFor: #at:!accessing!public! !
!DroppedFilesList categoriesFor: #at:put:!accessing!public! !
!DroppedFilesList categoriesFor: #basicFree!finalizing!private! !
!DroppedFilesList categoriesFor: #free!finalizing!public! !
!DroppedFilesList categoriesFor: #position!public! !
!DroppedFilesList categoriesFor: #setHandle:!initializing!private! !
!DroppedFilesList categoriesFor: #size!accessing!public! !

!DroppedFilesList class methodsFor!

fromHandle: anExternalHandle 
	^self new setHandle: anExternalHandle! !
!DroppedFilesList class categoriesFor: #fromHandle:!public! !

