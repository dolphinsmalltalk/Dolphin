"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #DCB
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DCB guid: (GUID fromString: '{96b10742-6075-441f-989b-b6147f5955e4}')!
DCB comment: ''!
!DCB categoriesForClass!IDB Goodies! !
!DCB methodsFor!

baudRate
	^self dwBaudRate!

baudRate: anObject 
	self dwBaudRate: anObject!

bByteSize
	"Answer the receiver's bByteSize field as a Smalltalk object."

	^(bytes byteAtOffset: 18)!

bByteSize: anObject
	"Set the receiver's bByteSize field to the value of anObject."

	bytes byteAtOffset: 18 put: anObject!

bEofChar
	"Answer the receiver's bEofChar field as a Smalltalk object."

	^(bytes byteAtOffset: 24)!

bEofChar: anObject
	"Set the receiver's bEofChar field to the value of anObject."

	bytes byteAtOffset: 24 put: anObject!

bErrorChar
	"Answer the receiver's bErrorChar field as a Smalltalk object."

	^(bytes byteAtOffset: 23)!

bErrorChar: anObject
	"Set the receiver's bErrorChar field to the value of anObject."

	bytes byteAtOffset: 23 put: anObject!

bEvtChar
	"Answer the receiver's bEvtChar field as a Smalltalk object."

	^(bytes byteAtOffset: 25)!

bEvtChar: anObject
	"Set the receiver's bEvtChar field to the value of anObject."

	bytes byteAtOffset: 25 put: anObject!

bParity
	"Answer the receiver's bParity field as a Smalltalk object."

	^(bytes byteAtOffset: 19)!

bParity: anObject
	"Set the receiver's bParity field to the value of anObject."

	bytes byteAtOffset: 19 put: anObject!

bStopBits
	"Answer the receiver's bStopBits field as a Smalltalk object."

	^(bytes byteAtOffset: 20)!

bStopBits: anObject
	"Set the receiver's bStopBits field to the value of anObject."

	bytes byteAtOffset: 20 put: anObject!

bXOffChar
	"Answer the receiver's bXOffChar field as a Smalltalk object."

	^(bytes byteAtOffset: 22)!

bXOffChar: anObject
	"Set the receiver's bXOffChar field to the value of anObject."

	bytes byteAtOffset: 22 put: anObject!

bXOnChar
	"Answer the receiver's bXOnChar field as a Smalltalk object."

	^(bytes byteAtOffset: 21)!

bXOnChar: anObject
	"Set the receiver's bXOnChar field to the value of anObject."

	bytes byteAtOffset: 21 put: anObject!

dataBits
	^self bByteSize!

dataBits: aByte 
	self bByteSize: aByte!

dwBaudRate
	"Answer the receiver's dwBaudRate field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

dwBaudRate: anObject
	"Set the receiver's dwBaudRate field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

dwDCBlength
	"Answer the receiver's dwDCBlength field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

dwDCBlength: anObject
	"Set the receiver's dwDCBlength field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

dwFlags
	"Answer the receiver's dwFlags field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

dwFlags: anObject
	"Set the receiver's dwFlags field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject!

fRtsControl
	^(self flags bitShift: -12) bitAnd: 3!

fRtsControl: anInteger
	self flags: ((self flags bitAnd: 4294955007) bitOr: (anInteger bitShift: 12))!

parity
	^self bParity!

parity: aByte 
	self bParity: aByte!

stopBits
	^self bStopBits!

stopBits: aByte 
	self bStopBits: aByte!

wReserved
	"Answer the receiver's wReserved field as a Smalltalk object."

	^(bytes wordAtOffset: 12)!

wReserved: anObject
	"Set the receiver's wReserved field to the value of anObject."

	bytes wordAtOffset: 12 put: anObject!

wReserved1
	"Answer the receiver's wReserved1 field as a Smalltalk object."

	^(bytes wordAtOffset: 26)!

wReserved1: anObject
	"Set the receiver's wReserved1 field to the value of anObject."

	bytes wordAtOffset: 26 put: anObject!

wXOffLim
	"Answer the receiver's wXOffLim field as a Smalltalk object."

	^(bytes wordAtOffset: 16)!

wXOffLim: anObject
	"Set the receiver's wXOffLim field to the value of anObject."

	bytes wordAtOffset: 16 put: anObject!

wXOnLim
	"Answer the receiver's wXOnLim field as a Smalltalk object."

	^(bytes wordAtOffset: 14)!

wXOnLim: anObject
	"Set the receiver's wXOnLim field to the value of anObject."

	bytes wordAtOffset: 14 put: anObject! !
!DCB categoriesFor: #baudRate!public! !
!DCB categoriesFor: #baudRate:!public! !
!DCB categoriesFor: #bByteSize!**compiled accessors**!public! !
!DCB categoriesFor: #bByteSize:!**compiled accessors**!public! !
!DCB categoriesFor: #bEofChar!**compiled accessors**!public! !
!DCB categoriesFor: #bEofChar:!**compiled accessors**!public! !
!DCB categoriesFor: #bErrorChar!**compiled accessors**!public! !
!DCB categoriesFor: #bErrorChar:!**compiled accessors**!public! !
!DCB categoriesFor: #bEvtChar!**compiled accessors**!public! !
!DCB categoriesFor: #bEvtChar:!**compiled accessors**!public! !
!DCB categoriesFor: #bParity!**compiled accessors**!public! !
!DCB categoriesFor: #bParity:!**compiled accessors**!public! !
!DCB categoriesFor: #bStopBits!**compiled accessors**!public! !
!DCB categoriesFor: #bStopBits:!**compiled accessors**!public! !
!DCB categoriesFor: #bXOffChar!**compiled accessors**!public! !
!DCB categoriesFor: #bXOffChar:!**compiled accessors**!public! !
!DCB categoriesFor: #bXOnChar!**compiled accessors**!public! !
!DCB categoriesFor: #bXOnChar:!**compiled accessors**!public! !
!DCB categoriesFor: #dataBits!public! !
!DCB categoriesFor: #dataBits:!public! !
!DCB categoriesFor: #dwBaudRate!**compiled accessors**!public! !
!DCB categoriesFor: #dwBaudRate:!**compiled accessors**!public! !
!DCB categoriesFor: #dwDCBlength!**compiled accessors**!public! !
!DCB categoriesFor: #dwDCBlength:!**compiled accessors**!public! !
!DCB categoriesFor: #dwFlags!**compiled accessors**!public! !
!DCB categoriesFor: #dwFlags:!**compiled accessors**!public! !
!DCB categoriesFor: #fRtsControl!accessing!public! !
!DCB categoriesFor: #fRtsControl:!accessing!public! !
!DCB categoriesFor: #parity!public! !
!DCB categoriesFor: #parity:!public! !
!DCB categoriesFor: #stopBits!public! !
!DCB categoriesFor: #stopBits:!public! !
!DCB categoriesFor: #wReserved!**compiled accessors**!public! !
!DCB categoriesFor: #wReserved:!**compiled accessors**!public! !
!DCB categoriesFor: #wReserved1!**compiled accessors**!public! !
!DCB categoriesFor: #wReserved1:!**compiled accessors**!public! !
!DCB categoriesFor: #wXOffLim!**compiled accessors**!public! !
!DCB categoriesFor: #wXOffLim:!**compiled accessors**!public! !
!DCB categoriesFor: #wXOnLim!**compiled accessors**!public! !
!DCB categoriesFor: #wXOnLim:!**compiled accessors**!public! !

!DCB class methodsFor!

defineFields
	"Defines the control setting for a serial communications device.
	
typedef struct _DCB {
  DWORD DCBlength;
  DWORD BaudRate;
  DWORD fBinary  :1;
  DWORD fParity  :1;
  DWORD fOutxCtsFlow  :1;
  DWORD fOutxDsrFlow  :1;
  DWORD fDtrControl  :2;
  DWORD fDsrSensitivity  :1;
  DWORD fTXContinueOnXoff  :1;
  DWORD fOutX  :1;
  DWORD fInX  :1;
  DWORD fErrorChar  :1;
  DWORD fNull  :1;
  DWORD fRtsControl  :2;
  DWORD fAbortOnError  :1;
  DWORD fDummy2  :17;
  WORD wReserved;
  WORD XonLim;
  WORD XoffLim;
  BYTE ByteSize;
  BYTE Parity;
  BYTE StopBits;
  char XonChar;
  char XoffChar;
  char ErrorChar;
  char EofChar;
  char EvtChar;
  WORD wReserved1;
} DCB, 
 *LPDCB;
"

	self
		defineField: #dwDCBlength type: DWORDField new;
		defineField: #dwBaudRate type: DWORDField new;
		defineField: #dwFlags type: DWORDField new;
		defineField: #wReserved type: WORDField new;
		defineField: #wXOnLim type: WORDField new;
		defineField: #wXOffLim type: WORDField new;
		defineField: #bByteSize type: BYTEField new;
		defineField: #bParity type: BYTEField new;
		defineField: #bStopBits type: BYTEField new;
		defineField: #bXOnChar type: BYTEField new;
		defineField: #bXOffChar type: BYTEField new;
		defineField: #bErrorChar type: BYTEField new;
		defineField: #bEofChar type: BYTEField new;
		defineField: #bEvtChar type: BYTEField new;
		defineField: #wReserved1 type: WORDField new! !
!DCB class categoriesFor: #defineFields!public! !

