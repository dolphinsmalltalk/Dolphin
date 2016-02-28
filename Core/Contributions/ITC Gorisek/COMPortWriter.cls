"Filed out from Dolphin Smalltalk 7"!

Object subclass: #COMPortWriter
	instanceVariableNames: 'handle'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants Win32Errors'
	classInstanceVariableNames: ''!
COMPortWriter guid: (GUID fromString: '{C2915EB0-BAE3-41B8-BB21-9DA381CD8932}')!
COMPortWriter comment: ''!
!COMPortWriter categoriesForClass!Unclassified! !
!COMPortWriter methodsFor!

close
	handle isNil 
		ifFalse: 
			[(KernelLibrary default closeHandle: handle) ifFalse: [self error: 'Could not release COM port'].
			handle := nil]!

enableRTS
	"A fix that forces the RTS line to be permanently enabled. If this is not enabled
	then the remote device might refuse to transmit data"

	| dcb |
	dcb := DCB new.
	KernelLibrary default getCommState: handle lpDCB: dcb.
	dcb fRtsControl: 1.
	KernelLibrary default setCommState: handle lpDCB: dcb!

finalize
	"Ensure that the device has been disconnected before it is destroyed. Failure
	to do this can result in the device becoming unavailable"

	self close!

openPort: anIntegerOrDeviceName 
	| deviceName |
	deviceName := anIntegerOrDeviceName isString 
				ifTrue: [anIntegerOrDeviceName]
				ifFalse: 
					[(anIntegerOrDeviceName isNil or: [anIntegerOrDeviceName < 0]) 
						ifTrue: [self error: 'Invalid COM port number'].
					'COM' , anIntegerOrDeviceName printString].
	handle := KernelLibrary default 
				createFile: deviceName
				dwDesiredAccess: GENERIC_READ | GENERIC_WRITE
				dwSharedMode: 0
				lpSecurityAttributes: 0
				dwCreationDistribution: OPEN_EXISTING
				dwFlagsAndAttributes: 0
				hTemplateFile: nil.
	handle asSignedInteger == -1 
		ifTrue: 
			[self error: 'Could not open COM port [' , anIntegerOrDeviceName asWebString , ']. OS error: ' 
						, KernelLibrary default getLastError printString].
	self beFinalizable!

openPort: aStringOrInteger speed: bpsSpeed 
	self
		openPort: aStringOrInteger;
		setBaudRate: bpsSpeed
			parity: #no
			dataBits: 8!

parityMapping
	^(LookupTable new)
		at: #no put: 0;
		at: #odd put: 1;
		at: #even put: 2;
		at: #mark put: 3;
		at: #space put: 4;
		yourself!

read: anInteger 
	"Read up to anInteger number of characters from the serial device. If less than anInteger
	number are read in available time (see time-outs) then the size of the buffer indicates how many bytes were read."

	| byteBuffer bytesRead |
	byteBuffer := ByteArray new: anInteger.
	bytesRead := DWORD new.
	^(KernelLibrary default 
		readFile: handle
		lpBuffer: byteBuffer
		nNumberOfBytesToRead: anInteger
		lpNumberOfBytesRead: bytesRead
		lpOverlapped: nil) 
			ifTrue: [byteBuffer copyFrom: 1 to: bytesRead asInteger]
			ifFalse: [self error: 'Failed to read from COM port']!

setBaudRate: baudRate parity: parity dataBits: dataBits 
	self 
		setBaudRate: baudRate
		parity: parity
		dataBits: dataBits
		stopBits: nil!

setBaudRate: baudRate parity: parity dataBits: dataBits stopBits: stopBits 
	| dcb result |
	VMLibrary default isWindowsVistaOrGreater 
		ifTrue: 
			["the code below does not work on Windows 7, do nothing here until this is fixed"

			"the workaround is to set default device settings in the Windows control panel"
			^nil].
	dcb := DCB new.
	result := KernelLibrary default getCommState: handle lpDCB: dcb.
	result = true 
		ifFalse: 
			[ItcSystemManager logDevTimeError: 'ERROR getting serial port Comm state: ' 
						, KernelLibrary default getLastError printString].
	dcb
		baudRate: baudRate;
		parity: (self parityMapping at: parity ifAbsent: [0]);
		dataBits: ((dataBits notNil and: [dataBits = 7 or: [dataBits = 8]]) ifTrue: [dataBits] ifFalse: [8]).
	stopBits isNil ifFalse: [dcb stopBits: stopBits].
	result := KernelLibrary default setCommState: handle lpDCB: dcb.
	result = true 
		ifFalse: 
			[self error: 'Error setting the Comm state: ' , KernelLibrary default getLastError printString].
	"set default time-out automatically as default behaviour"
	self setDefaultCommTimeouts!

setDefaultCommTimeouts
	"Private - The only initialization we are going to do is to set the timeouts to a more suitable
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
	timeouts := COMMTIMEOUTS new.
	timeouts
		readIntervalTimeout: 20;
		readTotalTimeoutMultiplier: 1;
		readTotalTimeoutConstant: 50;
		writeTotalTimeoutMultiplier: 0;
		writeTotalTimeoutConstant: 0.
	(KernelLibrary default setCommTimeouts: handle lpCommTimeouts: timeouts) 
		ifFalse: 
			[self error: 'Error setting the Commtimeouts: ' , KernelLibrary default getLastError printString]!

write: aStringOrByteArray 
	self write: aStringOrByteArray count: aStringOrByteArray size!

write: aStringOrByteArray count: bytesToWriteInteger 
	| len bytesWritten |
	len := bytesToWriteInteger isNil ifTrue: [aStringOrByteArray size] ifFalse: [bytesToWriteInteger].
	len == 0 ifTrue: [^0].
	bytesWritten := ByteArray newFixed: 4.
	^(KernelLibrary default 
		writeFile: handle
		lpBuffer: aStringOrByteArray
		nNumberOfBytesToWrite: len
		lpNumberOfBytesWritten: bytesWritten
		lpOverlapped: nil) 
			ifTrue: [bytesWritten dwordAtOffset: 0]
			ifFalse: 
				['Failed to write to COM port'.
				FileException signalOn: (File fromHandle: handle)]! !
!COMPortWriter categoriesFor: #close!public! !
!COMPortWriter categoriesFor: #enableRTS!initializing!public!serial fix! !
!COMPortWriter categoriesFor: #finalize!finalizing!public! !
!COMPortWriter categoriesFor: #openPort:!public! !
!COMPortWriter categoriesFor: #openPort:speed:!public! !
!COMPortWriter categoriesFor: #parityMapping!private! !
!COMPortWriter categoriesFor: #read:!public! !
!COMPortWriter categoriesFor: #setBaudRate:parity:dataBits:!public! !
!COMPortWriter categoriesFor: #setBaudRate:parity:dataBits:stopBits:!public! !
!COMPortWriter categoriesFor: #setDefaultCommTimeouts!private! !
!COMPortWriter categoriesFor: #write:!public! !
!COMPortWriter categoriesFor: #write:count:!public! !

