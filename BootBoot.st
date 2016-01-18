"Update the boot image"

"
DBOOT was created in the Core folder and had the raw Dolphin package
loaded from there. Fix up the package pathname here.
"
| dolphinPackage |
dolphinPackage := (Package manager packageNamed: 'Dolphin').
dolphinPackage packagePathname: 'Core\', dolphinPackage packagePathname!

"MemoryManager guid is corrupted during boot for some reason (that needs looking into)"
MemoryManager guid: (GUID fromString: '{703BD0AD-FBFF-4D00-866B-B80387F7B1D7}')!

(Smalltalk associations select: [:each |each isImmutable not and: [each value isKindOf: Class]]) do: [:each | each isImmutable: true]!

"Any classes in the Dolphin package that have been changed need manually reloading"
SourceManager fileIn.
PackageManager fileIn.
Package fileIn.
File fileIn.
VMLibrary fileIn.
SessionManager fileIn !

"Install some bare bones packages to get the Installation Management system working"
Package manager install: 'Core\Object Arts\Dolphin\Registry\Dolphin Registry Access.pax'!

"We need this to install any packages containing binaries"
Package manager install: 'Core\Object Arts\Dolphin\System\Base64\Dolphin Base64.pax'!

"Some other things found to be needed"
Package manager 	install: 'Core\Object Arts\Dolphin\Base\Dolphin Base.pax'!
Package manager 	install: 'Core\Object Arts\Dolphin\MVP\Models\Value\Dolphin Value Models.pax'!
Package manager 	install: 'Core\Object Arts\Dolphin\MVP\Type Converters\Dolphin Type Converters.pax'!

"Set Dolphin package version and about operation"
Object owningPackage 
	packageVersion: VMLibrary default versionString!

Processor activeProcess fpeMask: 3!

"Unlock VM"
VMLibrary default unlockVM: 0 expireAfter: 0 flags: 0!

SourceManager default basicCompressSources: 0 asValue.
(Delay forSeconds: 30) wait.
SessionManager current quit!


