"Filed out from Dolphin Smalltalk X6"!

Win32Structure subclass: #DCB
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DCB guid: (GUID fromString: '{CA575583-8616-11D3-83E2-9B967DD5722F}')!
DCB comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!DCB categoriesForClass!IDB Goodies! !
!DCB methodsFor!

fAbortOnError
	^(self flags bitAt: 15) ~= 0!

fBinary
	^(self flags bitAt: 1) ~= 0!

fDsrSensitivity
	^(self flags bitAt: 7) ~= 0!

fDtrControl
	^(self flags bitShift: -4) bitAnd: 3!

fDtrControl: anInteger 
	self flags: ((self flags bitAnd: 4294967247) bitOr: (anInteger bitShift: 4))!

fErrorChar
	^(self flags bitAt: 11) ~= 0!

fInX
	^(self flags bitAt: 10) ~= 0!

fNull
	^(self flags bitAt: 12) ~= 0!

fOutX
	^(self flags bitAt: 9) ~= 0!

fOutxCtsFlow
	^(self flags bitAt: 3) ~= 0!

fOutxDsrFlow
	^(self flags bitAt: 4) ~= 0!

fParity
	^(self flags bitAt: 2) ~= 0!

fRtsControl
	^(self flags bitShift: -12) bitAnd: 3!

fRtsControl: anInteger 
	self flags: ((self flags bitAnd: 4294955007) bitOr: (anInteger bitShift: 12))!

fTXContinueOnXoff
	^(self flags bitAt: 8) ~= 0! !
!DCB categoriesFor: #fAbortOnError!accessing!public! !
!DCB categoriesFor: #fBinary!accessing!public! !
!DCB categoriesFor: #fDsrSensitivity!accessing!public! !
!DCB categoriesFor: #fDtrControl!accessing!public! !
!DCB categoriesFor: #fDtrControl:!accessing!public! !
!DCB categoriesFor: #fErrorChar!accessing!public! !
!DCB categoriesFor: #fInX!accessing!public! !
!DCB categoriesFor: #fNull!accessing!public! !
!DCB categoriesFor: #fOutX!accessing!public! !
!DCB categoriesFor: #fOutxCtsFlow!accessing!public! !
!DCB categoriesFor: #fOutxDsrFlow!accessing!public! !
!DCB categoriesFor: #fParity!accessing!public! !
!DCB categoriesFor: #fRtsControl!accessing!public! !
!DCB categoriesFor: #fRtsControl:!accessing!public! !
!DCB categoriesFor: #fTXContinueOnXoff!accessing!public! !

!DCB class methodsFor!

defineFields
	"The DCB structure defines the control setting for a serial communications device. 
	typedef struct _DCB { // dcb 
		DWORD DCBlength;           // sizeof(DCB) 
		DWORD BaudRate;            // current baud rate 
		DWORD fBinary: 1;          // binary mode, no EOF check 
		DWORD fParity: 1;          // enable parity checking 
		DWORD fOutxCtsFlow:1;      // CTS output flow control 
		DWORD fOutxDsrFlow:1;      // DSR output flow control 
		DWORD fDtrControl:2;       // DTR flow control type 
		DWORD fDsrSensitivity:1;   // DSR sensitivity 
		DWORD fTXContinueOnXoff:1; // XOFF continues Tx 
		DWORD fOutX: 1;        // XON/XOFF out flow control 
		DWORD fInX: 1;         // XON/XOFF in flow control 
		DWORD fErrorChar: 1;   // enable error replacement 
		DWORD fNull: 1;        // enable null stripping 
		DWORD fRtsControl:2;   // RTS flow control 
		DWORD fAbortOnError:1; // abort reads/writes on error 
		DWORD fDummy2:17;      // reserved 
		WORD wReserved;        // not currently used 
		WORD XonLim;           // transmit XON threshold 
		WORD XoffLim;          // transmit XOFF threshold 
		BYTE ByteSize;         // number of bits/byte, 4-8 
		BYTE Parity;           // 0-4=no,odd,even,mark,space 
		BYTE StopBits;         // 0,1,2 = 1, 1.5, 2 
		char XonChar;          // Tx and Rx XON character 
		char XoffChar;         // Tx and Rx XOFF character 
		char ErrorChar;        // error replacement character 
		char EofChar;          // end of input character 
		char EvtChar;          // received event character 
		WORD wReserved1;       // reserved; do not use 
		} DCB; "

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #baudRate type: DWORDField new;
		defineField: #flags type: DWORDField new;
		defineField: #wReserved type: WORDField filler;
		defineField: #xOnLim type: WORDField new;
		defineField: #xOffLim type: WORDField new;
		defineField: #dataByteSize type: BYTEField new;
		defineField: #parity type: BYTEField new;
		defineField: #stopBits type: BYTEField new;
		defineField: #xOnChar type: BYTEField new;
		defineField: #xOffChar type: BYTEField new;
		defineField: #errorChar type: BYTEField new;
		defineField: #eofChar type: BYTEField new;
		defineField: #evtChar type: BYTEField new;
		defineField: #wReserved1 type: WORDField filler!

packing
	"Answer the default packing for instances of the receiver.
	This is the maximum alignment to which members of the structure
	after the first are padded. Each field type has a natural alignment
	(e.g. ints align to 32-bit boundaries), and it is the smaller of the
	packing and the natural alignment which is used to decide the
	padding necessary for the field in the structure.
	PRINTDLG is an old Win16 structure with byte packing."

	^1! !
!DCB class categoriesFor: #defineFields!initializing!public! !
!DCB class categoriesFor: #packing!constants!public! !

