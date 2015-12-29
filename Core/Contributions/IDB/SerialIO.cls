"Filed out from Dolphin Smalltalk X6"!

Object subclass: #SerialIO
	instanceVariableNames: 'deviceName handle oldCOMMTIMEOUTS oldDCB'
	classVariableNames: ''
	poolDictionaries: 'CommsConstants Win32Constants'
	classInstanceVariableNames: ''!
SerialIO guid: (GUID fromString: '{012BA300-5420-11D3-998B-BCA753D3B065}')!
SerialIO comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!SerialIO categoriesForClass!IDB Goodies! !
!SerialIO methodsFor!

connectionParameters
	"Answers a String giving the basic connection parameters"

	| dcb |
	dcb := DCB new.
	KernelLibrary default getCommState: handle lpDCB: dcb.
	^(String writeStream)
		print: dcb baudRate;
		nextPut: $-;
		print: dcb dataByteSize;
		nextPut: $-;
		nextPut: (##((LookupTable new)
					at: NOPARITY put: $N;
					at: ODDPARITY put: $O;
					at: EVENPARITY put: $E;
					at: MARKPARITY put: $M;
					at: SPACEPARITY put: $S;
					yourself) at: dcb parity);
		nextPut: $-;
		nextPutAll: (##((LookupTable new)
					at: ONESTOPBIT put: '1';
					at: ONE5STOPBITS put: '1.5';
					at: TWOSTOPBITS put: '2';
					yourself) at: dcb stopBits);
		contents!

connectTo: aString 
	"Connects the receiver to the serial device named aString"

	deviceName := aString.
	(deviceName indexOfSubCollection: 'COM') = 1 ifFalse: [^self error: 'The device name must be COMn'].
	(handle := KernelLibrary default 
				createFile: deviceName
				dwDesiredAccess: GENERIC_READ | GENERIC_WRITE
				dwSharedMode: 0
				lpSecurityAttributes: nil
				dwCreationDistribution: OPEN_EXISTING
				dwFlagsAndAttributes: 0
				hTemplateFile: nil) = INVALID_HANDLE_VALUE 
		ifTrue: [self error: 'Unable to open device'].
	self
		initializeComms;
		beFinalizable.
	^self!

disconnect
	"If the device is still open, the handle has not been set to nil
	then restore the old values that were saved when the device 
	was opened and then close the handle"

	handle isNil 
		ifFalse: 
			[(KernelLibrary default)
				setCommTimeouts: handle lpCommTimeouts: oldCOMMTIMEOUTS;
				setCommState: handle lpDCB: oldDCB;
				closeHandle: handle.
			handle := nil].
	self beUnfinalizable!

enableRTS
	"A fix that forces the RTS line to be permanently enabled. If this is not enabled
	then the remote device might refuse to transmit data"

	| dcb |
	dcb := DCB new.
	KernelLibrary default getCommState: handle lpDCB: dcb.
	dcb fRtsControl: RTS_CONTROL_ENABLE.
	KernelLibrary default setCommState: handle lpDCB: dcb!

finalize
	"Ensure that the device has been disconnected before it is destroyed. Failure
	to do this can result in the device becoming unavailable"

	self disconnect!

initializeComms
	"Initialize the hardware "

	self
		initializeDCB;
		initializeCOMMTIMEOUTS	"Insert fix initialisation calls here"!

initializeCOMMTIMEOUTS
	"The only initialization we are going to do is to set the timeouts to a more suitable
	scheme. 

	The effect of the default values is to disable timeouts, therefore if you ask for 100 
	characters from the device then the read operations will not return, and Dolphin
	is therefore disabled, until all 100 character have been read.

	The values below set the following (assume 100 characters are asked for) -
		The api will return if 100 character become available in less than 150 mS 
			which is made up of the constant, 50 mS, plus the number of character, 100,
			multiplied by the multiplier, 1.    50 + (100 * 1)
		The api will return, with any available characters, when the timeout of 150mS expires.
		The api will return if there is a gap of 20mS after a character is received even if 
			less than 100 characters have arrived and the timeout has not matured.

	For a fuller explanation see the API docs"

	| timeouts |
	oldCOMMTIMEOUTS := COMMTIMEOUTS new.
	KernelLibrary default getCommTimeouts: handle lpCommTimeouts: oldCOMMTIMEOUTS.
	timeouts := COMMTIMEOUTS new.
	timeouts
		readIntervalTimeout: 20;
		readTotalTimeoutMultiplier: 1;
		readTotalTimeoutConstant: 50;
		writeTotalTimeoutMultiplier: 0;
		writeTotalTimeoutConstant: 0.
	KernelLibrary default setCommTimeouts: handle lpCommTimeouts: timeouts!

initializeDCB
	"Set some parameters. If you always want to use the windows default values
	then omit the changes. This method must always be called, even if it makes no
	changes, as we always restore the original DCB.

	For a fuller explanation see the API docs"

	| dcb |
	oldDCB := DCB new.
	KernelLibrary default getCommState: handle lpDCB: oldDCB.
	dcb := DCB new.
	KernelLibrary default getCommState: handle lpDCB: dcb.
	dcb
		baudRate: CBR_9600;
		parity: NOPARITY;
		stopBits: ONESTOPBIT.
	KernelLibrary default setCommState: handle lpDCB: dcb!

read: anInteger 
	"Read up to anInteger number of characters from the serial device. If less than anInteger
	number are read then the size of the buffer indicates how many.
	Any errors are ignored!!!!"

	| byteBuffer bytesRead |
	byteBuffer := ByteArray new: anInteger.
	bytesRead := DWORD new.
	KernelLibrary default 
		readFile: handle
		lpBuffer: byteBuffer
		nNumberOfBytesToRead: anInteger
		lpNumberOfBytesRead: bytesRead
		lpOverlapped: nil.
	^byteBuffer copyFrom: 1 to: bytesRead asInteger!

write: aByteArrayOrString 
	"Writes aByteArrayOrString to the serial device and doesn't return until all the characters
	have been written.
	Answers the object written and ignores any errors"

	KernelLibrary default 
		writeFile: handle
		lpBuffer: aByteArrayOrString
		nNumberOfBytesToWrite: aByteArrayOrString size
		lpNumberOfBytesWritten: DWORD new
		lpOverlapped: nil.
	^aByteArrayOrString! !
!SerialIO categoriesFor: #connectionParameters!accessing!public! !
!SerialIO categoriesFor: #connectTo:!operations!operations-startup!public! !
!SerialIO categoriesFor: #disconnect!operations-shutdown!public! !
!SerialIO categoriesFor: #enableRTS!initializing!public!serial fix! !
!SerialIO categoriesFor: #finalize!finalizing!public! !
!SerialIO categoriesFor: #initializeComms!initializing!public! !
!SerialIO categoriesFor: #initializeCOMMTIMEOUTS!initializing!public! !
!SerialIO categoriesFor: #initializeDCB!initializing!public! !
!SerialIO categoriesFor: #read:!operations!public! !
!SerialIO categoriesFor: #write:!operations!public! !

!SerialIO class methodsFor!

connectTo: aString 
	"Answer a new instance of the receiver connected to the device named aString"

	^self new connectTo: aString! !
!SerialIO class categoriesFor: #connectTo:!instance creation!public! !

