"Basic cleanup"

"DBOOT was created in the Core folder and had the raw Dolphin package
loaded from there. Fix up the package pathname here."
| dolphinPackage |
dolphinPackage := (Package manager packageNamed: 'Dolphin').
dolphinPackage packagePathname: 'Core\', dolphinPackage packagePathname!

"MemoryManager guid is corrupted during boot for some reason (that needs looking into)"
MemoryManager guid: (GUID fromString: '{703BD0AD-FBFF-4D00-866B-B80387F7B1D7}')!

(Smalltalk associations 
	select: [:each |each isImmutable not and: [each value isKindOf: Class]]) 
	do: [:each | each isImmutable: true]!

"Set the current floating point exception mask"
Processor activeProcess fpeMask: 3!

"Unlock VM"
VMLibrary fileIn!
VMLibrary default unlockVM: 0 expireAfter: 0 flags: 0!
