"Check for update to DBOOT itself"
(SessionManager current argv at: 3 ifAbsent: [nil]) = 'UpdateBoot' ifTrue: [
	SourceManager default fileIn: 'Core\Object Arts\Dolphin\Base\Boot\Boot.st'.
]!

"Apply any patches not yet consolidated into the boot image that are required to load the system package"
SourceManager default fileIn: 'PreBoot.st'!

"Reload the base package constituents to reflect any changes since the boot image was created."
SourceManager default fileIn: 'Core\Object Arts\Dolphin\Base\Kernel.BootSessionManager.cls'!
SessionManager current updateBootImage!

"Install some bare bones packages to get the Installation Management system working"
Package manager install: 'Core\Object Arts\Dolphin\Registry\Dolphin Registry Access.pax'!

"We need this to install any packages containing binaries"
Package manager install: 'Core\Object Arts\Dolphin\System\Base64\Dolphin Base64.pax'!

"Set Dolphin package version and about operation"
Object owningPackage 
	packageVersion: VMLibrary default versionString!

"Load standard Dolphin products"
Package manager install: 'Core\Object Arts\Dolphin\Installation Manager\Dolphin Products.pax'!

"If required, prompt to boot the desired end product"
| productName product isPrompted |

productName := SessionManager current argv at: 3 ifAbsent: [ | p |
	"We'll need MVP bits in order to be able to display the choice prompter for the image version to boot"
	Package manager install: 'Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin Choice Prompter.pax'.
	p := (Smalltalk at: #ChoicePrompter)
		choices: (Tools.DolphinProduct allSubclasses reject: [:each | each isAbstract]) 
		caption: 'Product to boot...'.
	p isNil ifTrue: [SessionManager current quit: -1].
	isPrompted := true.
	p name].

[product := Tools at: productName asSymbol ifAbsent: [ | path |
	path := SessionManager current argv at: 4.
	Package manager install: path.
	Tools at: productName asSymbol].
SessionManager current saveImage: (File fullPathOf: product shortProductName).
Notification signal: 'Booting ', product name.
product boot] on: Error do: [:ex | 
	"isPrompted==true ifFalse: [SessionManager current quit: -2]."
	ex pass ] !

"Ensure all structures have calculated size to avoid recompilation messages later"
ExternalStructure allSubclasses do: [:e | e ensureDefined]!

SessionManager current bootFinished!

Tools.DevelopmentSessionManager installNew!

SessionManager current defaultResourceLibrary loadFlags: 0!

| info |
info := [ | process outputPipe |
	process := ExternalProcess new.
	process commandLine: 'git describe --tags'.
	outputPipe := process stdoutPipe.
	process executeSync.
	[process isTerminated] whileFalse: [].
	outputPipe readStream contents
] on: ExternalProcessExecuteError do: [:ex | nil].
SessionManager current bootInfo: (info isEmpty ifFalse: [info])!

"Mark all the booted packages as base"
Package manager markAllPackagesAsBase!

"Save the booted image"
| devsesh |
SourceManager default flushChanges.
devsesh := SessionManager current.
devsesh onPreSaveImage.
[devsesh primSnapshot: devsesh imageFileName
	backup: false
	type: 0
	maxObjects: 24576*1024
] ensure: [devsesh onPostSaveImage]!

"Remove unnecessary .chg files"
File delete: 'DBOOT.chg'!

SessionManager current onExit; primQuit: 0!


