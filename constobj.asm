;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Dolphin Smalltalk
; 
; Implement Constant Object Space
;

.586
OPTION CASEMAP:NONE
OPTION NOLJMP
OPTION PROC:PRIVATE

INCLUDE IstAsm.Inc

.LISTALL
;.LALL

.data

PUBLIC ?_Pointers@@3UVMPointers@@A

VM$CNST SEGMENT PUBLIC 'DATA'
?_Pointers@@3UVMPointers@@A VMPointers <>
_emptyStringObj SBYTE 4 DUP (?)				; ... String has null terminator so must pad to 4 bytes
_delimStringObj SBYTE 4 DUP (?)				; ... String 2+1 bytes, padded to 4
_charObjs Character 256 DUP (<>)
; Pad out to fill one page
?_vmConstSegFiller@@3PAEA BYTE 2464 DUP (?)
VM$CNST ENDS


END