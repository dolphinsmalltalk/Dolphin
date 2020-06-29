"Filed out from Dolphin Smalltalk 7"!

#{WinCryptConstants} declare: (PoolConstantsDictionary named: #WinCryptConstants)!
WinCryptConstants at: 'CRYPTPROTECT_AUDIT' put: 16r10!
WinCryptConstants at: 'CRYPTPROTECT_CRED_REGENERATE' put: 16r80!
WinCryptConstants at: 'CRYPTPROTECT_CRED_SYNC' put: 16r8!
WinCryptConstants at: 'CRYPTPROTECT_FIRST_RESERVED_FLAGVAL' put: 16rFFFFFFF!
WinCryptConstants at: 'CRYPTPROTECT_LAST_RESERVED_FLAGVAL' put: 16rFFFFFFFF!
WinCryptConstants at: 'CRYPTPROTECT_LOCAL_MACHINE' put: 16r4!
WinCryptConstants at: 'CRYPTPROTECT_NO_RECOVERY' put: 16r20!
WinCryptConstants at: 'CRYPTPROTECT_PROMPT_ON_PROTECT' put: 16r2!
WinCryptConstants at: 'CRYPTPROTECT_PROMPT_ON_UNPROTECT' put: 16r1!
WinCryptConstants at: 'CRYPTPROTECT_PROMPT_REQUIRE_STRONG' put: 16r10!
WinCryptConstants at: 'CRYPTPROTECT_PROMPT_RESERVED' put: 16r4!
WinCryptConstants at: 'CRYPTPROTECT_PROMPT_STRONG' put: 16r8!
WinCryptConstants at: 'CRYPTPROTECT_UI_FORBIDDEN' put: 16r1!
WinCryptConstants at: 'CRYPTPROTECT_VERIFY_PROTECTION' put: 16r40!
WinCryptConstants at: 'CRYPTPROTECTMEMORY_BLOCK_SIZE' put: 16r10!
WinCryptConstants at: 'CRYPTPROTECTMEMORY_CROSS_PROCESS' put: 16r1!
WinCryptConstants at: 'CRYPTPROTECTMEMORY_SAME_LOGON' put: 16r2!
WinCryptConstants at: 'CRYPTPROTECTMEMORY_SAME_PROCESS' put: 16r0!
WinCryptConstants shrink!
