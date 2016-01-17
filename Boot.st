"Boot a workable Dolphin from the boot image"

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

"We'll need MVP bits in order to be able to display the choice prompter for the image version to boot"
Package manager 	install: 'Core\Object Arts\Dolphin\Base\Dolphin Base.pax'!
Package manager 	install: 'Core\Object Arts\Dolphin\MVP\Models\Value\Dolphin Value Models.pax'!
Package manager 	install: 'Core\Object Arts\Dolphin\MVP\Type Converters\Dolphin Type Converters.pax'!
Package manager 	install: 'Core\Object Arts\Dolphin\MVP\Base\Dolphin MVP Base.pax'!
Package manager 	install: 'Core\Object Arts\Dolphin\Installation Manager\Dolphin Products.pax'!
Package manager  	install: 'Core\Object Arts\Dolphin\MVP\Dialogs\Common\Dolphin Common Dialogs.pax'!
Package manager 	install: 'Core\Object Arts\Dolphin\MVP\Presenters\List\Dolphin List Presenter.pax'!
Package manager 	install: 'Core\Object Arts\Dolphin\MVP\Presenters\Choice\Dolphin Choice Presenter.pax'!
Package manager  	install: 'Core\Object Arts\Dolphin\MVP\Presenters\Text\Dolphin Text Presenter.pax'!
Package manager 	install: 'Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin Choice Prompter.pax'!

"It was a crap idea to have classes whose names only differed by case wasn't it - hence we need this bodge even now"
SourceManager default fileIn: 'Core\Object Arts\Dolphin\MVP\Base\BITMAP_Struct.cls'!
BITMAP initializeAfterLoad!
SourceManager default fileIn: 'Core\Object Arts\Dolphin\MVP\Base\DIBSECTION_Struct.cls'!
DIBSECTION initializeAfterLoad!

"Set Dolphin package version and about operation"
Object owningPackage 
	packageVersion: VMLibrary default versionString!

Processor activeProcess fpeMask: 3!

"If required, prompt to boot the desired end product"
| productName product isPrompted |

productName := SessionManager current argv at: 3 ifAbsent: [ | p |
	p := ChoicePrompter
		choices: (DolphinProduct allSubclasses reject: [:each | each isAbstract]) 
		caption: 'Product to boot...'.
	p isNil ifTrue: [SessionManager current quit: -1].
	isPrompted := true.
	p name].

[product := Smalltalk at: productName asSymbol ifAbsent: [ | path |
	path := SessionManager current argv at: 4.
	Package manager install: path.
	Smalltalk at: productName asSymbol].
SessionManager current saveImage: (File fullPathOf: product shortProductName).
Notification signal: 'Booting ', product name.
product boot] on: Error do: [:ex | 
	"isPrompted==true ifFalse: [SessionManager current quit: -2]."
	ex pass ] !

DevelopmentSessionManager installNew!

SessionManager current defaultResourceLibrary loadFlags: 0.
SessionManager current stashBootInfo!

"Ensure all structures have calculated size to avoid recompilation messages later"
ExternalStructure allSubclasses do: [:e | e byteSize]!

"Mark all the booted packages as base"
Package manager markAllPackagesAsBase!

"Unlock VM"
VMLibrary default unlockVM: 0 expireAfter: 0 flags: 0!

SourceManager default basicCompressSources: 0 asValue.
SessionManager current saveImage!

"Remove rogue .img and unnecessary .chg files"
File delete: (File default: SessionManager current imagePath extension: 'img').
File delete: 'DBOOT.chg'!

SessionManager current quit!


