| deprecated |
deprecated := ClassCategory newNamed: 'Deprecated'.
ClassCategory addClassVariable: 'Deprecated' value: deprecated.
ClassCategory.Table at: 'Deprecated' put: deprecated!

UI.MessageBox owningPackage packagePathname: 'Core\Object Arts\Dolphin\System\Win32\MessageBox\Dolphin Message Box.pac'!
#(#assertStylesValid #buttonIds #buttonStyle #buttonStyle: #buttonStyleValue #defaultButton #iconStyleFlag #idOfButtonAt: #initialize #isTaskModal #modality #modality: #result #setForeground #setStyle:maskedBy: #showIndirect #showSuppressible) do: [:each | MessageBox removeSelector: each]!
UI.MessageBox class removeSelector: #initialize!
#('ButtonStyles' 'ModeStyles') do: [:each | UI.MessageBox classPool removeKey: each]!

Package manager install: 'Core\Object Arts\Dolphin\System\Win32\CommCtrl\Common Controls Library.pax'!

