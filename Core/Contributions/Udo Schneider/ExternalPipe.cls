"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ExternalPipe
	instanceVariableNames: 'readHandle writeHandle streams'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalPipe guid: (GUID fromString: '{1ebee959-7771-41a4-9164-d9bfd2ac4ea5}')!
ExternalPipe comment: ''!
!ExternalPipe categoriesForClass!Unclassified! !
!ExternalPipe methodsFor!

connectStreams
	streams := Array with: (StdioFileStream 
						fromHandle: (CRTLibrary default convertWinStdHandle: self readHandle toCRTFileMode: 'rt'))
				with: (StdioFileStream 
						fromHandle: (CRTLibrary default convertWinStdHandle: self writeHandle toCRTFileMode: 'wt'))!

createPipe
	| sa bResult |
	readHandle := ExternalHandle new.
	writeHandle := ExternalHandle new.
	sa := SECURITY_ATTRIBUTES new.
	sa bInheritHandle: true asDword.
	KernelLibrary default 
		createPipe: readHandle
		hWritePipe: writeHandle
		lpPipeAttributes: sa
		nSize: 0.
	bResult = false 
		ifTrue: [ExternalPipeExecuteError signal: 'Unable to create Pipe' with: self]!

readHandle
	^readHandle!

readStream
	streams isNil ifTrue: [self connectStreams].
	^streams at: 1!

writeHandle
	^writeHandle!

writeStream
	streams isNil ifTrue: [self connectStreams].
	^streams at: 2! !
!ExternalPipe categoriesFor: #connectStreams!private! !
!ExternalPipe categoriesFor: #createPipe!helpers!initializing!private! !
!ExternalPipe categoriesFor: #readHandle!accessing!private! !
!ExternalPipe categoriesFor: #readStream!accessing!public! !
!ExternalPipe categoriesFor: #writeHandle!accessing!private! !
!ExternalPipe categoriesFor: #writeStream!accessing!public! !

!ExternalPipe class methodsFor!

example1
	"
		self example1
		
	"

	| outputPipe inputPipe process |
	outputPipe := ExternalPipe new.
	inputPipe := ExternalPipe new.
	process := ExternalProcess new.
	process commandLine: 'cmd'.
	process stdoutPipe: outputPipe.
	process stdinPipe: inputPipe.
	[process executeSync] fork.
	
	[Transcript
		show;
		clear.
	[outputPipe readStream atEnd] whileFalse: 
			[Transcript
				nextPutAll: outputPipe readStream nextLine;
				cr;
				flush]] 
			fork.
	[process isAlive] whileFalse.
	[process isTerminated] whileFalse: 
			[| command |
			command := Prompter prompt: 'Please enter a command...' caption: 'DOS Command'.
			(command notNil and: [command notEmpty]) 
				ifTrue: 
					[(inputPipe writeStream)
						nextPutAll: command;
						cr;
						flush]
				ifFalse: 
					[(inputPipe writeStream)
						nextPutAll: 'exit';
						cr;
						flush]]!

example2
	"
		self example2
	"

	"Create external proccess"
	| outputPipe inputPipe process |
	process := ExternalProcess new.
	process commandLine: 'cmd'.
	"Query Pipes"
	outputPipe := process stdoutPipe.
	inputPipe := process stdinPipe.
	"Execute exeternal proccess in different smalltalk process"
	[process executeSync] fork.
	"Start Display to transcript proccess"
	
	[Transcript
		show;
		clear.
	[outputPipe readStream atEnd] whileFalse: 
			[Transcript
				nextPutAll: outputPipe readStream nextLine;
				cr;
				flush]] 
			fork.
	"Wait untíl external process is alive"
	[process isAlive] whileFalse.
	"Ask for input as long as the process is running."
	[process isTerminated] whileFalse: 
			[| command |
			command := Prompter prompt: 'Please enter a command...' caption: 'DOS Command'.
			(command notNil and: [command notEmpty]) 
				ifTrue: 
					[(inputPipe writeStream)
						nextPutAll: command;
						cr;
						flush]
				ifFalse: 
					[(inputPipe writeStream)
						nextPutAll: 'exit';
						cr;
						flush]]!

new
	^super new createPipe; yourself! !
!ExternalPipe class categoriesFor: #example1!must strip!public! !
!ExternalPipe class categoriesFor: #example2!must strip!public! !
!ExternalPipe class categoriesFor: #new!instance creation!public! !

