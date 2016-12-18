;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Dolphin Smalltalk
; External Buffer Primitive routines and helpers in Assembler for IX86
;
; See also flotprim.cpp, as the floating point buffer accessing primitives
; (rarely used by anybody except Mr Bower [and therefore unimportant, tee hee])
; are still coded in dead slow C++
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE IstAsm.Inc

.CODE FFIPRIM_SEG

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Exports
public primitiveAddressOf
public primitiveDWORDAt
public primitiveDWORDAtPut
public primitiveSDWORDAt
public primitiveSDWORDAtPut
public primitiveWORDAt
public primitiveWORDAtPut
public primitiveSWORDAt
public primitiveSWORDAtPut
public primitiveIndirectDWORDAt
public primitiveIndirectDWORDAtPut
public primitiveIndirectSDWORDAt
public primitiveIndirectSDWORDAtPut
public primitiveIndirectWORDAt
public primitiveIndirectWORDAtPut
public primitiveIndirectSWORDAt
public primitiveIndirectSWORDAtPut
public primitiveByteAtAddress
public primitiveByteAtAddressPut

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Imports
extern primitiveFailure0:near32
extern primitiveFailure1:near32
extern primitiveFailure2:near32
extern primitiveFailure3:near32

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MACROS

IndirectAtPreamble MACRO							;; Set up EAX/EDX ready to access value
	mov		ecx, [_SP-OOPSIZE]						;; Load receiver
	ASSUME	ecx:PTR OTE

	mov		edx, [_SP]								;; Load the byte offset

	mov		eax, [ecx].m_location					;; Get ptr to receiver into eax
	ASSUME	eax:PTR ExternalAddress

	sar		edx, 1									;; Convert byte offset from SmallInteger (at the same time testing bottom bit)

	mov		eax, [eax].m_pointer					;; Load pointer out of object (immediately after header)

	jnc		primitiveFailure0						;; Arg not a SmallInteger, fail the primitive

	ASSUME	eax:NOTHING
	ASSUME	ecx:NOTHING
ENDM

IndirectAtPutPreamble MACRO							;; Set up EAX/EDX ready to access value
	mov		ecx, [_SP-OOPSIZE*2]					;; Load receiver
	ASSUME	ecx:PTR OTE

	mov		edx, [_SP-OOPSIZE]						;; Load the byte offset

	mov		eax, [ecx].m_location					;; Get ptr to receiver into eax
	ASSUME	eax:PTR ExternalAddress

	sar		edx, 1									;; Convert byte offset from SmallInteger (at the same time testing bottom bit)

	mov		eax, [eax].m_pointer					;; Load pointer out of object (immediately after header)

	jnc		primitiveFailure0						;; Arg not a SmallInteger, fail the primitive

	ASSUME	eax:NOTHING
	ASSUME	ecx:NOTHING
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Procedures

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  BOOL __fastcall Interpreter::primitiveAddressOf()
;
; Answer the address of the contents of the receiving byte object
; as an Integer. Notice that this is a very fast and simple primitive
;
; Clean stack as no arguments
;
BEGINPRIMITIVE primitiveAddressOf
	mov		ecx, [_SP]							; Load receiver at stack top
;	mov		eax, HEADERSIZE						; We'll want to skip the header

	CANTBEINTEGEROBJECT	<ecx>

;	add		eax, [ecx].m_location				; Load address of object
	mov		eax, [ecx].m_location				; Load address of object
	jmp		replaceStackTopWithNewUnsigned		; Overwrite receiver in ecx, with eax
ENDPRIMITIVE primitiveAddressOf


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; External buffer/structure primitives. 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
BEGINPRIMITIVE primitiveWORDAt
	mov		edx, [_SP]								; Load the byte offset
	mov		ecx, [_SP-OOPSIZE]						; Access receiver at stack top
	ASSUME	ecx:PTR OTE
	sar		edx, 1									; Convert byte offset from SmallInteger (at the same time testing bottom bit)
	mov		eax, [ecx].m_location					; EAX is pointer to receiver
	jnc		primitiveFailure0						; Arg not a SmallInteger, fail the primitive
	js		primitiveFailure1						; Negative offset not valid
				     	
   	; Receiver is a normal byte object
	mov		ecx, [ecx].m_size
	add		edx, SIZEOF WORD						; Adjust offset to be last byte ref'd
	and		ecx, 7fffffffh							; Ignore immutability bit
	cmp		edx, ecx								; Off end of object?
	jg		primitiveFailure1						; Yes, offset too large

	movzx	eax, WORD PTR[eax+edx-SIZEOF WORD]		; No, load WORD from object[offset]

	lea		eax, [eax+eax+1]						; Convert to SmallInteger
	mov		[_SP-OOPSIZE], eax						; Overwrite receiver
	PopStack
	ret
ENDPRIMITIVE primitiveWORDAt


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This primitive is exactly the same as primitiveWORDAt, except that it uses MOVSX
;; instead of MOVZX in order to sign extend the SWORD value
BEGINPRIMITIVE primitiveSWORDAt
	mov		ecx, [_SP-OOPSIZE]						; Access receiver below arg
	ASSUME	ecx:PTR OTE
	mov		edx, [_SP]								; Load the byte offset
	sar		edx, 1									; Convert byte offset from SmallInteger (at the same time testing bottom bit)
	mov		eax, [ecx].m_location					; EAX is pointer to receiver
	jnc		primitiveFailure0						; Arg not a SmallInteger, fail the primitive
	js		primitiveFailure1						; Negative offset not valid
				     	
	; Receiver is a normal byte object
	mov		ecx, [ecx].m_size
	add		edx, SIZEOF WORD						; Adjust offset to be last byte ref'd
	and		ecx, 7fffffffh							; Ignore immutability bit
	cmp		edx, ecx								; Off end of object?
	jg		primitiveFailure1						; Yes, offset too large

	movsx	eax, WORD PTR[eax+edx-SIZEOF WORD]		; No, load WORD from object[offset]

	lea		eax, [eax+eax+1]						; Convert to SmallInteger
	mov		[_SP-OOPSIZE], eax						; Overwrite receiver
	PopStack
	ret
ENDPRIMITIVE primitiveSWORDAt


; static BOOL __fastcall Interpreter::primitiveDWORDAt()
;
; Extract a 4-byte unsigned integer from the receiver (which must be a byte
; addressable object) and answer either a SmallInteger, or a 
; LargePositiveInteger if 30-bits or more are required
;
; Leaves a clean stack as can only succeed if the argument is a SmallInteger
;
BEGINPRIMITIVE primitiveDWORDAt
	mov		ecx, [_SP-OOPSIZE]						; Access receiver below arg
	ASSUME	ecx:PTR OTE
	mov		edx, [_SP]								; Load the byte offset
	sar		edx, 1									; Convert byte offset from SmallInteger
	mov		eax, [ecx].m_location					; EAX is pointer to receiver

	jnc		primitiveFailure0						; Not a SmallInteger, fail the primitive
	js		primitiveFailure1						; Negative offset not valid

	;; Receiver is a normal byte object
	mov		ecx, [ecx].m_size
	add		edx, SIZEOF DWORD						; Adjust offset to be last byte ref'd
	and		ecx, 7fffffffh							; Ignore immutability bit
	cmp		edx, ecx								; Off end of object?
	jg		primitiveFailure1						; Yes, offset too large

	mov		eax, [eax+edx-SIZEOF DWORD]				; No, load DWORD from object[offset]

	;; Its not going to fail, so prepare Smalltalk stack
	PopStack

	;; Deliberately drop through ...

ENDPRIMITIVE primitiveDWORDAt

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Replace object at stack top with a new unsigned (i.e. positive) Integer 
;; (Small or LargePositive as necessary) with the value in EAX
;; Returns TRUE.
;;
replaceStackTopWithNewUnsigned PROC			; Also used from primitiveAddressOf, 32-bit value in eax, overwritten Oop in ecx
	mov		ecx, eax						; Save DWORD value
	add		ecx, eax						; Will it fit into a SmallInteger?
	jo		largePositiveRequired			; No, its a 32-bit value
	js		largePositiveRequired			; Won't be positive SmallInteger (31 bit value)
	inc		ecx								; Yes, add SmallInteger flag
	mov		[_SP], ecx						; Store new SmallInteger at stack top
	mov		eax, ecx						; Return TRUE (non-zero)
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Replace the object at stack top (assuming no count down necessary, or already done)
;; with a new LargePositiveInteger whose value is half that in ECX/Carry Flag
largePositiveRequired:						; eax contains left shifted value
	mov		ecx, eax						; Revert to non-shifted value
	call	LINEWUNSIGNED32					; Returns new object to our caller in eax
	ReplaceStackTopWithNew
	ret										; Return TRUE (Oop must be non zero)
replaceStackTopWithNewUnsigned ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; As above, but receiver is indirection object
;; Optimise for storing SmallInteger, since this most frequent op

BEGINPRIMITIVE primitiveIndirectDWORDAt
	IndirectAtPreamble

	mov		eax, [eax+edx]							; Load DWORD from *(address+offset)
	PopStack
	jmp	replaceStackTopWithNewUnsigned				; Now push on the stack over the receiver
ENDPRIMITIVE primitiveIndirectDWORDAt

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  int __fastcall Interpreter::primitiveSDWORDAt()
;
; Extract a 4-byte signed integer from the receiver (which must be a byte
; addressable object) and answer either a SmallInteger, or a 
; LargeInteger if 31-bits or more are required
;
; Leaves a clean stack as can only succeed if the argument is a SmallInteger
;
BEGINPRIMITIVE primitiveSDWORDAt
	mov		ecx, [_SP-OOPSIZE]						; Access receiver at stack top
	ASSUME	ecx:PTR OTE

	mov		edx, [_SP]								; Load the byte offset
	sar		edx, 1									; Convert byte offset from SmallInteger
	
	mov		eax, [ecx].m_location					; EAX is pointer to receiver
	ASSUME	eax:PTR Object

	jnc		primitiveFailure0						; Not a SmallInteger, fail the primitive
	js		primitiveFailure1						; Negative offset not valid

	;; Receiver is a normal byte object
	mov		ecx, [ecx].m_size
	add		edx, SIZEOF DWORD						; Adjust offset to be last byte ref'd
	and		ecx, 7fffffffh							; Ignore immutability bit
	cmp		edx, ecx								; Off end of object?
	jg		primitiveFailure1						; Yes, offset too large

	mov		eax, [eax+edx-SIZEOF DWORD]				; No, load SDWORD from object[offset]
	ASSUME	eax:SDWORD

	;; Its not going to fail, so prepare Smalltalk stack
	PopStack
	
	mov		ecx, eax								; Restore SDWORD value into ECX
	add		ecx, eax								; Will it fit into a SmallInteger
	jo		@F										; No, its at 32-bit number
	inc		ecx										; Yes, add SmallInteger flag
	mov		[_SP], ecx								; Store new SmallInteger at stack top
	mov		eax, ecx								; Return TRUE (non-zero)
	ret

@@:
	mov		ecx, eax								; Revert to non-shifted value
	call	LINEWSIGNED								; Create new LI with 32-bit signed value in ECX
	ReplaceStackTopWithNew							; Replace stack top with new signed, large, integer
	ret												; When called from primitive, eax non-zero, so will succeed

ENDPRIMITIVE primitiveSDWORDAt

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Optimise for storing SmallInteger, since this most frequent op

BEGINPRIMITIVE primitiveSDWORDAtPut
	mov		ecx, [_SP-OOPSIZE*2]					; Access receiver
	ASSUME	ecx:PTR OTE
	
	mov		edx, [_SP-OOPSIZE]						; Load the byte offset
	sar		edx, 1									; Convert byte offset from SmallInteger

	mov		eax, [ecx].m_location					; EAX is pointer to receiver
	ASSUME	eax:PTR Object

	jnc		primitiveFailure0						; Offset, not a SmallInteger, fail the primitive
	js		primitiveFailure1						; Negative offset invalid

	;; Receiver is a normal byte object
	add		edx, SIZEOF DWORD						; Adjust offset to be last byte ref'd
	cmp		edx, [ecx].m_size						; Off end of object? N.B. Don't mask out immutable bit
	lea		eax, [eax+edx-SIZEOF DWORD]				; Calculate destination address
	ASSUME	eax:PTR SDWORD							; EAX now points at slot to update
	jg		primitiveFailure1						; Yes, offset too large

	;; Deliberately drop through into the common backend
ENDPRIMITIVE primitiveSDWORDAtPut

;; Common backend for xxxxxSDWORDAtPut primitives
sdwordAtPut PROC
	mov		edx, [_SP]
	test	dl, 1									; SmallInteger value?
	jz		@F										; No

	; Store down smallInteger value
	mov		ecx, edx
	sar		edx, 1									; Convert from SmallInteger value
	mov		[eax], edx								; Store down value into object

	; Don't adjust stack until memory has been accessed in case it is inaccessible and causes an access violation

	mov		[_SP-OOPSIZE*2], ecx					; Overwrite receiver
	PopStack <2>									; Past failing so pop arg/offset (both SmallIntegers)
	ret

@@:	
	ASSUME	edx:PTR OTE
	; Non-SmallInteger value
	test	[edx].m_flags, MASK m_pointer
	mov		ecx, [edx].m_size
	jnz		primitiveFailure2						; Can't assign pointer object

	and		ecx, 7fffffffh							; Mask out the immutability bit (can assign const object)
	cmp		ecx, SIZEOF DWORD

	mov		edx, [edx].m_location					; Get pointer to arg2 into ecx
	ASSUME	edx:PTR LargeInteger
	jne		primitiveFailure2

	; So now we know it's a 4-byte object, let's see if its a negative large integer
	mov		edx, [edx].m_digits[0]					; Load the 32-bit value
	ASSUME	edx:DWORD
	mov		[eax], edx								; Store down 32-bit value

	mov		edx, [_SP]								; Reload arg
	mov		[_SP-OOPSIZE*2], edx					; Overwrite receiver
	PopStack <2>									; Pop value and SmallInteger offset
	ret
sdwordAtPut ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; An exact copy of the above, but omits LargePositiveInteger range check

BEGINPRIMITIVE primitiveDWORDAtPut
	mov		ecx, [_SP-OOPSIZE*2]					; Access receiver
	ASSUME	ecx:PTR OTE
	mov		edx, [_SP-OOPSIZE]						; Load the byte offset
	sar		edx, 1									; Convert byte offset from SmallInteger

	mov		eax, [ecx].m_location					; EAX is pointer to receiver

	jnc		primitiveFailure0						; Offset, not a SmallInteger, fail the primitive
	js		primitiveFailure1						; Negative offset invalid

	;; Receiver is a normal byte object
	add		edx, SIZEOF DWORD						; Adjust offset to be last byte ref'd
	cmp		edx, [ecx].m_size						; Off end of object? N.B. Don't mask out immutable bit
	lea		eax, [eax+edx-SIZEOF DWORD]				; Calculate destination address
	jg		primitiveFailure1						; Yes, offset too large

	; DELIBERATELY DROP THROUGH into dwordAtPut
ENDPRIMITIVE primitiveDWORDAtPut

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper backed to primitiveDWORDAtPut and primitiveIndirectDWORDAtPut
dwordAtPut PROC
	; EAX is pointer to destination for DWORD value
	; ECX, EDX not used for input
	; Adjusts stack to remove args if succeeds.
	; May fail the primitive

	mov		edx, [_SP]
	test	dl, 1									; SmallInteger value?
	jz		@F										; No

	; Store down smallInteger value
	mov		ecx, edx
	sar		edx, 1									; Convert from SmallInteger value
	mov		[eax], edx								; Store down value into object
	
	; Past failing so adjust stack (returns the argument)
	mov		[_SP-OOPSIZE*2], ecx					; Overwrite receiver
	PopStack <2>									
	ret

@@:	
	ASSUME	edx:PTR OTE
	; Non-SmallInteger value
	test	[edx].m_flags, MASK m_pointer
	jnz		primitiveFailure2						; Can't assign pointer object

	mov		ecx, [edx].m_size
	and		ecx, 7fffffffh							; Mask out the immutable bit on the assigned value
	cmp		ecx, SIZEOF DWORD

	mov		edx, [edx].m_location					; Get pointer to arg2 into ecx
	ASSUME	edx:PTR Object
	je		@F										; 4 bytes, can store down

	cmp		ecx, SIZEOF QWORD
	jne		primitiveFailure2

	; It's an 8 byte object, may be able to store if top byte zero (e.g. positive LargeIntegers >= 16r80000000)
	ASSUME	edx:PTR QWORDBytes
	cmp		[edx].m_highPart, 0
	jne		primitiveFailure2						; Top dword not zero, so disallow it
@@:
	ASSUME	edx:PTR DWORDBytes

	mov		edx, [edx].m_value						; Load the 32-bit value
	mov		[eax], edx								; Store down 32-bit value

	mov		edx, [_SP]								; Reload arg
	mov		[_SP-OOPSIZE*2], edx					; Overwrite receiver with arg for answer
	PopStack <2>									; Pop value and SmallInteger offset
	ret

	ASSUME	edx:NOTHING
dwordAtPut ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
BEGINPRIMITIVE primitiveIndirectSDWORDAtPut
	mov		ecx, [_SP-OOPSIZE*2]					; Access receiver
	ASSUME	ecx:PTR OTE
	mov		edx, [_SP-OOPSIZE]						; Load the byte offset
	sar		edx, 1									; Convert byte offset from SmallInteger

	mov		eax, [ecx].m_location					; EAX is pointer to receiver

	jnc		primitiveFailure0						; Offset, not a SmallInteger, fail the primitive
	;js		primitiveFailure1						; Negative offset ARE valid

	; Receiver is an ExternalAddress
	mov		eax, (ExternalAddress PTR[eax]).m_pointer; Load pointer out of object (immediately after header)
	add		eax, edx								; Calculate destination address

	jmp		sdwordAtPut								; Pass control to the common backend
ENDPRIMITIVE primitiveIndirectSDWORDAtPut

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; As above, but receiver is indirection object

BEGINPRIMITIVE primitiveIndirectDWORDAtPut
	mov		ecx, [_SP-OOPSIZE*2]					; Access receiver
	ASSUME	ecx:PTR OTE
	mov		edx, [_SP-OOPSIZE]						; Load the byte offset
	sar		edx, 1									; Convert byte offset from SmallInteger

	mov		eax, [ecx].m_location					; EAX is pointer to receiver

	jnc		primitiveFailure0						; Offset, not a SmallInteger, fail the primitive
	;js		primitiveFailure1						; Negative offsets are valid

	; Receiver is an ExternalAddress
	mov		eax, (ExternalAddress PTR[eax]).m_pointer; Load pointer out of object (immediately after header)
	add		eax, edx								; Calculate destination address
	jmp		dwordAtPut								; Pass control to the common backend with primitiveDWORDAtPut

ENDPRIMITIVE primitiveIndirectDWORDAtPut

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
BEGINPRIMITIVE primitiveIndirectSDWORDAt
	IndirectAtPreamble

	push	DWORD PTR[eax+edx]						; Save SDWORD from *(address+offset)

	;; Its not going to fail, so prepare Smalltalk stack
	PopStack
	
	pop		ecx										; Restore SDWORD value into ECX
	add		ecx, ecx								; Will it fit into a SmallInteger
	jo		@F										; No, its at 32-bit number
	inc		ecx										; Yes, add SmallInteger flag
	mov		[_SP], ecx								; Store new SmallInteger at stack top
	mov		eax, ecx								; Return TRUE (non-zero)
	ret

@@:
	rcr		ecx, 1									; Revert to non-shifted value
	call	LINEWSIGNED								; Create new LI with 32-bit signed value in ECX
	ReplaceStackTopWithNew
	ret												; When called from primitive, eax non-zero, so will succeed
ENDPRIMITIVE primitiveIndirectSDWORDAt


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
BEGINPRIMITIVE primitiveIndirectSWORDAt
	IndirectAtPreamble

	movsx	eax, WORD PTR[eax+edx]					; Sign extend WORD from *(address+offset) into EAX

	lea		eax, [eax+eax+1]						; Convert to SmallInteger
	mov		[_SP-OOPSIZE], eax						; Overwrite receiver
	PopStack
	ret
ENDPRIMITIVE primitiveIndirectSWORDAt

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
BEGINPRIMITIVE primitiveIndirectWORDAt
	IndirectAtPreamble
				     	
	movzx	eax, WORD PTR[eax+edx]					; Zero extend WORD from *(address+offset) into EAX

	lea		eax, [eax+eax+1]						; Convert to SmallInteger
	mov		[_SP-OOPSIZE], eax						; Overwrite receiver
	PopStack
	ret
ENDPRIMITIVE primitiveIndirectWORDAt


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;  int __fastcall Interpreter::primitiveByteAtAddress()
;
; Treat the contents of the receiver (which must be a byte object) at
; offsets 0..3 as an address and answer the byte at that address plus
; the offset specified as an argument.
;
BEGINPRIMITIVE primitiveByteAtAddress
	IndirectAtPreamble
	mov		al, BYTE PTR[eax+edx]			; Load the desired byte into AL
	and		eax, 0FFh						; Mask off unwanted high bytes
	lea		eax, [eax+eax+1]				; Convert to SmallInteger
	mov		[_SP-OOPSIZE], eax				; Store new SmallInteger at stack top
	PopStack
	ret
ENDPRIMITIVE primitiveByteAtAddress


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  int __fastcall Interpreter::primitiveByteAtAddressPut()
;
; Treat the contents of the receiver (which must be a byte object) at
; offsets 0..3 as an address and ovewrite the byte at that address plus
; the offset specified as an argument with the argument.
;
BEGINPRIMITIVE primitiveByteAtAddressPut
	mov		ecx, [_SP-OOPSIZE*2]			; Access receiver underneath arguments
	ASSUME	ecx:PTR OTE

	mov		edx, [_SP-OOPSIZE]				; Load the byte offset
	sar		edx, 1							; Convert byte offset from SmallInteger

	mov		eax, [_SP]						; Load the value argument

	mov		ecx, [ecx].m_location			; Load address of object into EAX
	ASSUME	ecx:PTR ExternalAddress

	jnc		primitiveFailure0      			; Offset not a SmallInteger, fail the primitive
	;js		primitiveFailure1				; Negative offsets ARE valid in this case

	mov		ecx, [ecx].m_pointer			; Load the base address from the object
	ASSUME	ecx:PTR BYTE

	add		ecx, edx
	ASSUME	edx:NOTHING						; EDX is now free

	mov		edx, eax						; Load value into EDX

	sar		edx, 1							; Convert byte value from SmallInteger
	jnc		primitiveFailure2      			; Not a SmallInteger, fail the primitive
	
	cmp		edx, 0FFh						; Is it in range?
	ja		primitiveFailure3      			; No, too big (N.B. unsigned comparison)

	mov		[ecx], dl						; Store byte at the specified offset

	mov		[_SP-OOPSIZE*2], eax			; SmallInteger answer (same as value arg)
	PopStack <2>							; Pop SmallInteger args
	; Succeed - EAX contains SmallInteger value, and therefore non-zero
	ret
ENDPRIMITIVE primitiveByteAtAddressPut

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  int __fastcall Interpreter::primitiveWORDAtPut()
;
BEGINPRIMITIVE primitiveWORDAtPut
	mov		ecx, [_SP-OOPSIZE*2]			; Access receiver underneath arguments
	ASSUME	ecx:PTR OTE
	mov		edx, [_SP-OOPSIZE]				; Load the byte offset
	sar		edx, 1							; Convert byte offset from SmallInteger
	mov		eax, [ecx].m_location			; Load address of object
	jnc		primitiveFailure0       		; Not a SmallInteger, fail the primitive
	js		primitiveFailure1				; Negative offsets not valid

	add		edx, SIZEOF WORD				; Adjust offset to be last byte ref'd
	cmp		edx, [ecx].m_size				; Off end of object? N.B. Ignore the immutable bit so fails if receiver constant
	jg		primitiveFailure1				; Yes, offset too large, fail it

	mov		ecx, [_SP]						; Load the value argument
	sar		ecx, 1							; Convert byte value from SmallInteger
	jnc		primitiveFailure2       		; Not a SmallInteger, fail the primitive
	cmp		ecx, 0FFFFh						; Is it in range?
	ja		primitiveFailure3       		; No, too big (N.B. unsigned comparison)

	mov		WORD PTR[eax+edx-SIZEOF WORD], cx	; No, Store down the 16-bit value

	mov		eax, [_SP]						; and value
	mov		[_SP-OOPSIZE*2], eax			; SmallInteger answer (same as value arg)
	PopStack <2>							; Pop SmallInteger args
	ret										; Succeed - non-zero (valid SmallInteger) in eax
ENDPRIMITIVE primitiveWORDAtPut

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  int __fastcall Interpreter::primitiveIndirectWORDAtPut()
;
BEGINPRIMITIVE primitiveIndirectWORDAtPut
	IndirectAtPutPreamble

	mov		ecx, [_SP]						; Load the value argument
	sar		ecx, 1							; Convert byte value from SmallInteger
	jnc		primitiveFailure2       		; Not a SmallInteger, fail the primitive
	cmp		ecx, 0FFFFh						; Is it in range?
	ja		primitiveFailure3       		; No, too big (N.B. unsigned comparison)

	mov		WORD PTR[eax+edx], cx			; Store down the 16-bit value

	mov		eax, [_SP]						; and value
	mov		[_SP-OOPSIZE*2], eax			; SmallInteger answer (same as value arg)
	PopStack <2>							; Pop SmallInteger args
	ret										; Succeed - non-zero (valid address) in eax
ENDPRIMITIVE primitiveIndirectWORDAtPut

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Store a signed word into a buffer. The offset must be in bounds, and the
; value must be a SmallInteger in the range -32768..32767
;
BEGINPRIMITIVE primitiveSWORDAtPut
	mov		ecx, [_SP-OOPSIZE*2]			; Access receiver underneath arguments
	ASSUME	ecx:PTR OTE
	mov		edx, [_SP-OOPSIZE]				; Load the byte offset
	sar		edx, 1							; Convert byte offset from SmallInteger
	mov		eax, [ecx].m_location			; Load address of object
	jnc		primitiveFailure0       		; Not a SmallInteger, fail the primitive
	js		primitiveFailure1				; Negative offsets not valid

	add		edx, SIZEOF WORD				; Adjust offset to be last byte ref'd
	cmp		edx, [ecx].m_size				; Off end of object? N.B. Ignore the immutable bit so fails if receiver constant
	jg		primitiveFailure1				; Yes, offset too large, fail it

	mov		ecx, [_SP]						; Load the value argument
	sar		ecx, 1							; Convert byte value from SmallInteger
	jnc		primitiveFailure2       		; Not a SmallInteger, fail the primitive
	cmp		ecx, 08000h						; Is it in range?
	jge		primitiveFailure3       		; No, too large positive
	cmp		ecx, -08000h
	jl		primitiveFailure3				; No, too large negative

	mov		WORD PTR[eax+edx-SIZEOF WORD], cx	; No, Store down the 16-bit value

	mov		eax, [_SP]						; and value
	mov		[_SP-OOPSIZE*2], eax			; SmallInteger answer (same as value arg)
	PopStack <2>							; Pop SmallInteger args
	ret										; Succeed - non-zero (valid address) in eax
ENDPRIMITIVE primitiveSWORDAtPut

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Store a signed word into a buffer pointed at by the receiver. The
; value must be a SmallInteger in the range -32768..32767. If the receiver's
; address value + the offset is not a writeable address, then a non-fatal GP
; fault will occur.
;
BEGINPRIMITIVE primitiveIndirectSWORDAtPut
	IndirectAtPutPreamble

	mov		ecx, [_SP]						; Load the value argument
	sar		ecx, 1							; Convert byte value from SmallInteger
	jnc		primitiveFailure2       		; Not a SmallInteger, fail the primitive
	cmp		ecx, 08000h						; Is it in range?
	jge		primitiveFailure3       		; No, too large positive
	cmp		ecx, -08000h
	jl		primitiveFailure3				; No, too large negative

	mov		WORD PTR[eax+edx], cx			; Store down the 16-bit value

	mov		eax, [_SP]						; and value
	mov		[_SP-OOPSIZE*2], eax			; SmallInteger answer (same as value arg)
	PopStack <2>							; Pop SmallInteger args
	ret										; Succeed - non-zero (valid address) in eax
ENDPRIMITIVE primitiveIndirectSWORDAtPut


END
