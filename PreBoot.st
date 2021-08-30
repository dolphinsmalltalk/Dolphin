| deprecated |
deprecated := ClassCategory newNamed: 'Deprecated'.
ClassCategory addClassVariable: 'Deprecated' value: deprecated.
ClassCategory.Table at: 'Deprecated' put: deprecated!

UI.MessageBox owningPackage packagePathname: 'Core\Object Arts\Dolphin\System\Win32\MessageBox\Dolphin Message Box.pac'!
#(#result #buttonIds) do: [:each | MessageBox removeSelector: each]!

Package manager install:  'Core\Object Arts\Dolphin\System\Win32\CommCtrl\Common Controls Library.pax'!
